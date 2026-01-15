package payment.controller;

import java.util.List;
import java.util.Map;

import cart.domain.CartDTO;
import cart.model.CartDAO;
import cart.model.CartDAO_imple;
import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;
import order.model.OrderDAO;
import order.model.OrderDAO_imple;

public class PaymentSuccess extends AbstractController {

    private int parseIntSafe(String value) {
        try {
            return Integer.parseInt(value);
        } catch (Exception e) {
            return 0;
        }
    }

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginUser");

        /* ================= GET : 결제 완료 페이지 ================= */
        if ("GET".equalsIgnoreCase(request.getMethod())) {

            Integer orderId = (Integer) session.getAttribute("lastOrderId");
            if (loginuser == null || orderId == null) {
                request.setAttribute("message", "이미 처리된 주문입니다.");
                request.setAttribute("loc", request.getContextPath() + "/index.hp");
                setRedirect(false);
                setViewPage("/WEB-INF/msg.jsp");
                return;
            }

            OrderDAO odao = new OrderDAO_imple();
            request.setAttribute("order", odao.selectOrderHeader(orderId));
            request.setAttribute("orderDetailList", odao.selectOrderDetailForPayment(orderId));

            session.removeAttribute("lastOrderId");

            setRedirect(false);
            setViewPage("/WEB-INF/pay_MS/paymentSuccess.jsp");
            return;
        }

        /* ================= POST : 결제 성공 처리 ================= */
        if (!"POST".equalsIgnoreCase(request.getMethod()) || loginuser == null) {
            request.setAttribute("message", "비정상 접근");
            request.setAttribute("loc", "javascript:history.back()");
            setRedirect(false);
            setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        CartDAO cdao = new CartDAO_imple();
        OrderDAO odao = new OrderDAO_imple();

        @SuppressWarnings("unchecked")
        List<CartDTO> cartList = (List<CartDTO>) session.getAttribute("cartList");

        // ===== 바로구매 보정 로직 시작 =====
        if (cartList == null || cartList.isEmpty()) {

            @SuppressWarnings("unchecked")
            List<Map<String, Object>> directOrderList =
                (List<Map<String, Object>>) session.getAttribute("directOrderList");

            if (directOrderList == null || directOrderList.isEmpty()) {
                request.setAttribute("message", "주문 상품 없음");
                request.setAttribute("loc", request.getContextPath() + "/pay/payMent.hp");
                setViewPage("/WEB-INF/msg.jsp");
                return;
            }

            cartList = new java.util.ArrayList<>();

            for (Map<String, Object> m : directOrderList) {
                CartDTO c = new CartDTO();
                c.setCartId(0);
                c.setOptionId(Integer.parseInt(String.valueOf(m.get("option_id"))));
                c.setQuantity(Integer.parseInt(String.valueOf(m.get("quantity"))));
                c.setPrice(Integer.parseInt(String.valueOf(m.get("unit_price"))));
                c.setProductName(String.valueOf(m.get("product_name")));
                c.setBrand_name(String.valueOf(m.get("brand_name")));
                cartList.add(c);
            }

            session.setAttribute("cartList", cartList);
        }

        /* ================= 여기부터 수정 ================= */

        // 1. 폼에서 전달받은 쿠폰 정보
        String couponIdParam = request.getParameter("couponId");
        String discountAmountParam = request.getParameter("discountAmount"); // 또는 discountAmountHidden

        int couponIssueId = 0;
        int discountAmount = 0;

        if (couponIdParam != null && !couponIdParam.isBlank()) {
            try {
                couponIssueId = Integer.parseInt(couponIdParam);
                
                // 쿠폰 유효성 검증
                if (couponIssueId > 0) {
                    Map<String, Object> couponInfo =
                        odao.selectCouponInfo(loginuser.getMemberid(), couponIssueId);

                    if (couponInfo == null) {
                        throw new RuntimeException("유효하지 않은 쿠폰");
                    }
                }
            } catch (NumberFormatException e) {
                couponIssueId = 0;
            }
        }

        // 할인 금액 파싱
        if (discountAmountParam != null && !discountAmountParam.isBlank()) {
            try {
                discountAmount = Integer.parseInt(discountAmountParam);
            } catch (NumberFormatException e) {
                discountAmount = 0;
            }
        }

        /* ================= 배송지 ================= */
        String deliveryAddress = request.getParameter("deliveryAddress");
        if (deliveryAddress == null || deliveryAddress.isBlank()) {
           deliveryAddress = "(임시 주소)";
        }

        Integer orderId = (Integer) session.getAttribute("readyOrderId");

        if (orderId == null) {
            request.setAttribute("message", "유효하지 않은 결제 요청입니다.");
            request.setAttribute("loc", request.getContextPath() + "/index.hp");
            setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        try {

            // 2. 주문 정보 업데이트 (할인액, 배송지)
           int n = odao.updateOrderDiscountAndAddress(orderId, discountAmount, deliveryAddress);

           if (n == 0) {
               throw new Exception("주문 정보 업데이트 실패");
           }
           
            for (CartDTO cart : cartList) {

                // 재고 차감 실패 → 즉시 실패
                if (odao.decreaseStock(cart.getOptionId(), cart.getQuantity()) != 1) {
                    throw new Exception("재고 부족");
                }

                odao.insertOrderDetail(
                    orderId,
                    cart.getOptionId(),
                    cart.getQuantity(),
                    cart.getPrice(),
                    cart.getProductName(),
                    cart.getBrand_name()
                );
            }

            // 성공
            odao.updateOrderStatus(orderId, "PAID");
            odao.updateDeliveryStatus(orderId, 0);
            
            // 성공했을 때만 부수 로직
            if (couponIssueId > 0) {
                odao.updateCouponUsed(loginuser.getMemberid(), couponIssueId);
            }

            cdao.deleteSuccessCartId(
                cartList.stream()
                        .map(CartDTO::getCartId)
                        .filter(id -> id > 0)
                        .toList()
            );

            session.removeAttribute("cartList");
            session.removeAttribute("readyOrderId");  // 추가: 사용한 orderId 제거

        } catch (Exception e) {

            // 실패 → DB 반영
            odao.updateOrderStatus(orderId, "FAIL");
            odao.updateDeliveryStatus(orderId, 4);

            request.setAttribute("message", "결제 처리 중 문제가 발생했습니다. 다시 시도해주세요.");
            request.setAttribute("loc", request.getContextPath() + "/pay/payMent.hp");
            setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        /* ================= 완료 페이지 ================= */
        session.setAttribute("lastOrderId", orderId);
        setRedirect(true);
        setViewPage(request.getContextPath() + "/payment/paymentSuccess.hp");
    }
}