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
import order.domain.OrderDTO;
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

        /* 
           GET : 결제 완료 페이지
         */
        if ("GET".equalsIgnoreCase(request.getMethod())) {

            if (loginuser == null) {
                request.setAttribute("message", "로그인 정보 없음");
                request.setAttribute("loc", request.getContextPath() + "/login/login.hp");
                setRedirect(false);
                setViewPage("/WEB-INF/msg.jsp");
                return;
            }

            Integer orderId = (Integer) session.getAttribute("lastOrderId");

            if (orderId == null) {
                request.setAttribute("message", "이미 처리된 주문입니다.");
                request.setAttribute("loc", request.getContextPath() + "/index.hp");
                setRedirect(false);
                setViewPage("/WEB-INF/msg.jsp");
                return;
            }

            OrderDAO odao = new OrderDAO_imple();

            Map<String, Object> orderHeader = odao.selectOrderHeader(orderId);
            List<Map<String, Object>> orderItems =
                    odao.selectOrderDetailForPayment(orderId);

            if (orderHeader == null || orderItems == null || orderItems.isEmpty()) {
                request.setAttribute("message", "주문 정보를 불러올 수 없습니다.");
                request.setAttribute("loc", request.getContextPath() + "/index.hp");
                setRedirect(false);
                setViewPage("/WEB-INF/msg.jsp");
                return;
            }

            // F5 / 재접근 방지
            session.removeAttribute("lastOrderId");

            request.setAttribute("order", orderHeader);
            request.setAttribute("orderDetailList", orderItems);

            String deliveryType = (String) session.getAttribute("deliveryType");
            request.setAttribute("deliveryType", deliveryType);
            session.removeAttribute("deliveryType");

            setRedirect(false);
            setViewPage("/WEB-INF/pay_MS/paymentSuccess.jsp");
            return;
        }

        /* 
           POST : 최초 결제 성공
         */
        if (!"POST".equalsIgnoreCase(request.getMethod())) {
            request.setAttribute("message", "비정상적인 접근입니다.");
            request.setAttribute("loc", "javascript:history.back()");
            setRedirect(false);
            setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        if (loginuser == null) {
            request.setAttribute("message", "로그인 정보 없음");
            request.setAttribute("loc", "javascript:history.back()");
            setRedirect(false);
            setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        // PG 결제 식별값 (검증용)
        String impUid = request.getParameter("imp_uid");
        String merchantUid = request.getParameter("merchant_uid");

        if (impUid == null || merchantUid == null) {
            request.setAttribute("message", "결제 정보 누락");
            request.setAttribute("loc", "javascript:history.back()");
            setRedirect(false);
            setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        CartDAO cdao = new CartDAO_imple();
        OrderDAO odao = new OrderDAO_imple();

        @SuppressWarnings("unchecked")
        List<CartDTO> cartList = (List<CartDTO>) session.getAttribute("cartList");

        if (cartList == null || cartList.isEmpty()) {
            request.setAttribute("message", "주문할 상품 정보가 없습니다.");
            request.setAttribute("loc", request.getContextPath() + "/cart/zangCart.hp");
            setRedirect(false);
            setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        /* 
           서버 기준 금액 재계산
         */
        int calculatedTotal = 0;
        for (CartDTO cart : cartList) {
            calculatedTotal += cart.getPrice() * cart.getQuantity();
        }

        /* 
           쿠폰 검증 및 할인 계산
        */
        int couponId = parseIntSafe(request.getParameter("couponId"));
        int calculatedDiscount = 0;

        if (couponId > 0) {
            Map<String, Object> couponInfo =
                    odao.selectCouponInfo(loginuser.getMemberid(), couponId);

            if (couponInfo == null) {
                throw new RuntimeException("유효하지 않은 쿠폰");
            }

            int discountType = (int) couponInfo.get("discountType");
            int discountValue = (int) couponInfo.get("discountValue");

            calculatedDiscount =
                    (discountType == 0)
                        ? discountValue
                        : calculatedTotal * discountValue / 100;

            if (calculatedDiscount > calculatedTotal) {
                calculatedDiscount = calculatedTotal;
            }
        }

        /* 
           배송지
         */
        String deliveryAddress = request.getParameter("deliveryAddress");
        if (deliveryAddress == null || deliveryAddress.isBlank()) {
            deliveryAddress = (String) session.getAttribute("address");
        }
        if (deliveryAddress == null || deliveryAddress.isBlank()) {
            throw new RuntimeException("배송지 정보 없음");
        }

        /* 
           주문 생성
        */
        OrderDTO order = new OrderDTO();
        order.setMemberId(loginuser.getMemberid());
        order.setTotalAmount(calculatedTotal);
        order.setDiscountAmount(calculatedDiscount);
        order.setDeliveryAddress(deliveryAddress);
        order.setOrderStatus("READY");

        int orderId = odao.insertOrder(order);

        
        try {
            for (CartDTO cart : cartList) {

                if (odao.decreaseStock(cart.getOptionId(), cart.getQuantity()) != 1) {
                    throw new RuntimeException("재고 부족");
                }

                int unitPrice = cart.getPrice();

                int result = odao.insertOrderDetail(
                	    orderId,
                	    cart.getOptionId(),
                	    cart.getQuantity(),
                	    cart.getPrice(),
                	    cart.getProductName(),
                	    cart.getBrand_name()
                	);

                if (result != 1) {
                    throw new RuntimeException("주문 상세 저장 실패");
                }
            }

            // 전체 성공
            odao.updateOrderStatus(orderId, "PAID");

        } catch (Exception e) {

            // 하나라도 실패
            odao.updateOrderStatus(orderId, "FAIL");
            throw e;
        }
    
        /* =========================
           장바구니 정리
        ========================= */
        cdao.deleteSuccessCartId(
                cartList.stream().map(CartDTO::getCartId).toList()
        );
        session.removeAttribute("cartList");

        /* =========================
           쿠폰 사용 처리
        ========================= */
        if (couponId > 0) {
            if (odao.updateCouponUsed(loginuser.getMemberid(), couponId) != 1) {
                throw new RuntimeException("쿠폰 사용 처리 실패");
            }
        }

        /* =========================
           완료 페이지 이동
        ========================= */
        session.setAttribute("lastOrderId", orderId);
        setRedirect(true);
        setViewPage(request.getContextPath() + "/payment/paymentSuccess.hp");
    }
}