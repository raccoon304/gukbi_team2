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

        System.out.println("=== PaymentSuccess 시작 ===");
        
        CartDAO cdao = new CartDAO_imple();
        OrderDAO odao = new OrderDAO_imple();

        // 🔥 수정: "payCartList"로 변경!
        @SuppressWarnings("unchecked")
        List<CartDTO> cartList = (List<CartDTO>) session.getAttribute("payCartList");

        System.out.println("payCartList(세션): " + cartList);

        // ===== 바로구매 보정 로직 시작 =====
        if (cartList == null || cartList.isEmpty()) {
            System.out.println("payCartList가 null 또는 비어있음!");

            @SuppressWarnings("unchecked")
            List<Map<String, Object>> directOrderList =
                (List<Map<String, Object>>) session.getAttribute("directOrderList");

            System.out.println("directOrderList(세션): " + directOrderList);

            if (directOrderList == null || directOrderList.isEmpty()) {
                System.out.println("directOrderList도 null 또는 비어있음!");
                request.setAttribute("message", "주문 상품 없음");
                request.setAttribute("loc", request.getContextPath() + "/pay/payMent.hp");
                setViewPage("/WEB-INF/msg.jsp");
                return;
            }

            System.out.println("directOrderList에서 cartList 생성");
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

            session.setAttribute("payCartList", cartList);
        }

        System.out.println("cartList size: " + cartList.size());
        for (CartDTO cart : cartList) {
            System.out.println("    - " + cart.getProductName() 
                             + ", 수량: " + cart.getQuantity()
                             + ", 가격: " + cart.getPrice());
        }

        /* ================= 쿠폰 정보 ================= */
        String couponIdParam = request.getParameter("couponId");
        String discountAmountParam = request.getParameter("discountAmount");

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

        System.out.println("쿠폰ID: " + couponIssueId + ", 할인금액: " + discountAmount);

        /* ================= 배송지 ================= */
        String deliveryAddress = request.getParameter("deliveryAddress");
        if (deliveryAddress == null || deliveryAddress.isBlank()) {
           deliveryAddress = "(임시 주소)";
        }

        System.out.println("배송지: " + deliveryAddress);

        Integer orderId = (Integer) session.getAttribute("readyOrderId");

        if (orderId == null) {
            System.out.println("readyOrderId가 null!");
            request.setAttribute("message", "유효하지 않은 결제 요청입니다.");
            request.setAttribute("loc", request.getContextPath() + "/index.hp");
            setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        System.out.println("orderId: " + orderId);

        try {
            System.out.println(">>> 주문 정보 업데이트 시작");

            // 주문 정보 업데이트 (할인액, 배송지)
            int n = odao.updateOrderDiscountAndAddress(orderId, discountAmount, deliveryAddress);

            if (n == 0) {
                throw new Exception("주문 정보 업데이트 실패");
            }

            System.out.println(" 주문 정보 업데이트 완료");
            System.out.println(">>> 주문 상세 등록 시작");
           
            for (CartDTO cart : cartList) {

                System.out.println("처리 중: " + cart.getProductName() + ", 옵션ID: " + cart.getOptionId());

                // 재고 차감 실패 → 즉시 실패
                if (odao.decreaseStock(cart.getOptionId(), cart.getQuantity()) != 1) {
                    throw new Exception("재고 부족: " + cart.getProductName());
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

            System.out.println("주문 상세 등록 완료");

            // 성공
            odao.updateOrderStatus(orderId, "PAID");
            odao.updateDeliveryStatus(orderId, 0);
            
            System.out.println("주문 상태 업데이트 완료");

            // 성공했을 때만 부수 로직
            if (couponIssueId > 0) {
                odao.updateCouponUsed(loginuser.getMemberid(), couponIssueId);
                System.out.println("쿠폰 사용 처리 완료");
            }

            // 장바구니에서 삭제 (cartId가 0보다 큰 것만)
            List<Integer> cartIdsToDelete = cartList.stream()
                    .map(CartDTO::getCartId)
                    .filter(id -> id > 0)
                    .toList();

            if (!cartIdsToDelete.isEmpty()) {
                cdao.deleteSuccessCartId(cartIdsToDelete);
                System.out.println("장바구니에서 삭제 완료: " + cartIdsToDelete);
            }

            // 세션 정리
            session.removeAttribute("payCartList");  
            session.removeAttribute("readyOrderId");

            System.out.println("세션 정리 완료");
            System.out.println("PaymentSuccess 완료 ");

        } catch (Exception e) {
            System.out.println("결제 처리 중 오류 발생!");
            e.printStackTrace();

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