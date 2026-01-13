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

        if (cartList == null || cartList.isEmpty()) {
            throw new RuntimeException("주문 상품 없음");
        }

        /* ================= 서버 기준 총액 ================= */
        int calculatedTotal = 0;
        for (CartDTO cart : cartList) {
            calculatedTotal += cart.getPrice() * cart.getQuantity();
        }

        /* ================= 쿠폰 IssueId 확보 ( 핵심 수정) ================= */
        int couponIssueId = parseIntSafe(request.getParameter("couponId")); ;

        if (couponIssueId > 0) {
            session.setAttribute("usedCouponIssueId", couponIssueId);
        } else {
            Integer saved = (Integer) session.getAttribute("usedCouponIssueId");
            couponIssueId = (saved == null) ? 0 : saved;
        }

        int calculatedDiscount = 0;

        if (couponIssueId > 0) {
            Map<String, Object> couponInfo =
                    odao.selectCouponInfo(loginuser.getMemberid(), couponIssueId);

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

        /* ================= 배송지 ================= */
        String deliveryAddress = request.getParameter("deliveryAddress");
        if (deliveryAddress == null || deliveryAddress.isBlank()) {
            throw new RuntimeException("배송지 없음");
        }

        /* ================= 주문 생성 ================= */
        OrderDTO order = new OrderDTO();
        order.setMemberId(loginuser.getMemberid());
        order.setTotalAmount(calculatedTotal);
        order.setDiscountAmount(calculatedDiscount);
        order.setDeliveryAddress(deliveryAddress);
        
        order.setRecipientName(loginuser.getName());
        order.setRecipientPhone(loginuser.getMobile());

        int orderId = odao.insertOrder(order);

      
            for (CartDTO cart : cartList) {

            	 // 재고 차감 실패 → 즉시 실패 처리
                if (odao.decreaseStock(cart.getOptionId(), cart.getQuantity()) != 1) {
           	
                    odao.updateOrderStatus(orderId, "FAIL");
                    odao.updateDeliveryStatus(orderId, 4);
                    
                
                    request.setAttribute("message", "재고가 부족하여 결제가 실패했습니다.");
                    request.setAttribute("loc", request.getContextPath() + "/payment/payMent.hp");
                    setRedirect(false);
                    setViewPage("/WEB-INF/msg.jsp");
                    return;
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
       
            odao.updateOrderStatus(orderId, "PAID");
            odao.updateDeliveryStatus(orderId, 0); // 배송 준비

       
    	   
        

        /* ================= 장바구니 정리 ================= */
        cdao.deleteSuccessCartId(
            cartList.stream()
                    .map(CartDTO::getCartId)
                    .filter(id -> id > 0)
                    .toList()
        );
        session.removeAttribute("cartList");

        /* ================= 쿠폰 사용 처리 ================= */
        if (couponIssueId > 0) {
            odao.updateCouponUsed(loginuser.getMemberid(), couponIssueId);
            session.removeAttribute("usedCouponIssueId");
        }

        /* ================= 완료 페이지 ================= */
        session.setAttribute("lastOrderId", orderId);
        setRedirect(true);
        setViewPage(request.getContextPath() + "/payment/paymentSuccess.hp");
    }
}