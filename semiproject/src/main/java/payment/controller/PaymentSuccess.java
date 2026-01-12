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

    // 안전한 숫자 파싱 메서드
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

         
        //   GET 요청 처리 (리다이렉트 후)
       
        if ("GET".equalsIgnoreCase(request.getMethod())) {
            
            if (loginuser == null) {
                request.setAttribute("message", "로그인 정보 없음");
                request.setAttribute("loc", request.getContextPath() + "/login/login.hp");
                setRedirect(false);
                setViewPage("/WEB-INF/msg.jsp");
                return;
            }

            // 세션에서 orderId 가져오기
            Integer orderId = (Integer) session.getAttribute("lastOrderId");

            // f5를 눌렀을때 메세지 띄우고 인덱스 페이지로 이동시키기
            if (orderId == null) {
                request.setAttribute("message", "이미 처리된 주문입니다.");
                request.setAttribute("loc", request.getContextPath() + "/index.hp");
                setRedirect(false);
                setViewPage("/WEB-INF/msg.jsp");
                return;
            }

            // DB에서 주문 정보 조회
            OrderDAO odao = new OrderDAO_imple();
            Map<String, Object> orderHeader = odao.selectOrderHeader(orderId);
            List<Map<String, Object>> orderItems = odao.selectOrderDetailForPayment(orderId);

            if (orderHeader == null || orderItems == null || orderItems.isEmpty()) {
                request.setAttribute("message", "주문 정보를 불러올 수 없습니다.");
                request.setAttribute("loc", request.getContextPath() + "/index.hp");
                setRedirect(false);
                setViewPage("/WEB-INF/msg.jsp");
                return;
            }

            // 세션에서 orderId 제거 (일회성 - F5 방지)
            session.removeAttribute("lastOrderId");

            // 화면에 데이터 전달
            request.setAttribute("order", orderHeader);
            request.setAttribute("orderDetailList", orderItems);

            String deliveryTypeFromSession =
            (String) session.getAttribute("deliveryType");

            request.setAttribute("deliveryType", deliveryTypeFromSession);
            session.removeAttribute("deliveryType");
            
            setRedirect(false);
            setViewPage("/WEB-INF/pay_MS/paymentSuccess.jsp");
            return;
        }

    
         //  POST 요청 처리 (최초 결제 완료)
        if (!"POST".equalsIgnoreCase(request.getMethod())) {
            request.setAttribute("message", "비정상적인 접근입니다.");
            request.setAttribute("loc", "javascript:history.back()");
            setRedirect(false);
            setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        /* 
           2. 로그인 체크
        */
        if (loginuser == null) {
            request.setAttribute("message", "로그인 정보 없음");
            request.setAttribute("loc", "javascript:history.back()");
            setRedirect(false);
            setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        /* 
           3. 결제 식별값 체크
         */
        String impUid = request.getParameter("imp_uid");
        String merchantUid = request.getParameter("merchant_uid");

        if (impUid == null || merchantUid == null) {
            request.setAttribute("message", "결제 정보 누락");
            request.setAttribute("loc", "javascript:history.back()");
            setRedirect(false);
            setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        /* 
           4. 결제 금액 / 배송지 파라미터
           (방탄 처리)
         */
        int totalAmount = parseIntSafe(request.getParameter("totalAmount"));
        int discountAmount = parseIntSafe(request.getParameter("discountAmount"));
        String deliveryAddress = request.getParameter("deliveryAddress");
        String deliveryType = request.getParameter("deliveryTypeSelected");
        
        if (totalAmount <= 0) {
            request.setAttribute("message", "결제 금액 오류");
            request.setAttribute("loc", "javascript:history.back()");
            setRedirect(false);
            setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        if (deliveryAddress == null || deliveryAddress.isBlank()) {
            request.setAttribute("message", "배송지 정보가 없습니다.");
            request.setAttribute("loc", "javascript:history.back()");
            setRedirect(false);
            setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        CartDAO cdao = new CartDAO_imple();
        OrderDAO odao = new OrderDAO_imple();

        /* 
           5. 주문 생성 → orderId 받기
        */
        OrderDTO order = new OrderDTO();
        order.setMemberId(loginuser.getMemberid());
        order.setTotalAmount(totalAmount);
        order.setDiscountAmount(discountAmount);
        order.setDeliveryAddress(deliveryAddress);
        order.setOrderStatus("PAID");

 
        // order.setImpUid(impUid);
        // order.setMerchantUid(merchantUid);

        int orderId = odao.insertOrder(order);
 
       // 6. 주문 상세 생성 (장바구니 기준)       
        @SuppressWarnings("unchecked")
        List<CartDTO> cartList = (List<CartDTO>) session.getAttribute("cartList");

        if (cartList == null || cartList.isEmpty()) {
            request.setAttribute("message", "주문할 상품 정보가 없습니다.");
            request.setAttribute("loc", request.getContextPath() + "/cart/cart.hp");
            setRedirect(false);
            setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        int totalInserted = 0;

        for (CartDTO cart : cartList) {
            totalInserted += odao.insertOrderDetail(orderId, cart);
            
        }

        if (totalInserted != cartList.size()) {
            throw new RuntimeException("주문 상세 저장 실패");
        }

        /* 
           7. 장바구니 정리
           (결제에 사용된 cart_id만 삭제)
        */
        List<Integer> cartIdList = cartList.stream()
                                           .map(CartDTO::getCartId)
                                           .toList();

        cdao.deleteSuccessCartId(cartIdList);
        
        session.removeAttribute("cartList");
        
     // 결제한 행에 대해서 사용한 쿠폰 처리
        int couponId = parseIntSafe(request.getParameter("couponId"));

        if (couponId > 0) {

            int couponResult =
                odao.updateCouponUsed(loginuser.getMemberid(), couponId);

            if (couponResult != 1) {
                throw new RuntimeException("쿠폰 사용 처리 실패");
            }
        }
        /* =========================
           8. orderId를 세션에 저장하고 GET으로 리다이렉트
        ========================= */
        session.setAttribute("lastOrderId", orderId);
        session.setAttribute("deliveryType", deliveryType);
        
        // 같은 URL로 GET 리다이렉트
        setRedirect(true);
        setViewPage(request.getContextPath() + "/payment/paymentSuccess.hp");
    }
}