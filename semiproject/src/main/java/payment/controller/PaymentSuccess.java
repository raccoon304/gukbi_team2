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
import order.domain.*;

public class PaymentSuccess extends AbstractController {

	
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		

		// get, post 판별
		String method = request.getMethod();
		
		// 만약 get 방식이라면 차단 
		if (!"POST".equalsIgnoreCase(request.getMethod())) {
	        request.setAttribute("message", "비정상적인 접근입니다.");
	        request.setAttribute("loc", "javascript:history.back()");
	        setRedirect(false);
	        setViewPage("/WEB-INF/msg.jsp");
	        return;
	    }
				
		
		// 로그인 체크
		HttpSession session = request.getSession();
		MemberDTO loginuser = (MemberDTO) session.getAttribute("loginUser");
		
		if (loginuser == null) {
		    request.setAttribute("message", "로그인 정보 없음");
		    request.setAttribute("loc", "javascript:history.back()");
		    setViewPage("/WEB-INF/msg.jsp");
		    return;
		}
	
        // POST 데이터
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

        // (1) 주문 생성 → orderId 받기
        OrderDTO order = new OrderDTO();
        order.setMemberId(loginuser.getMemberid());
        order.setTotalAmount(totalAmount);
        order.setDiscountAmount(discountAmount);
        order.setDeliveryAddress(deliveryAddress);
        order.setOrderStatus("PAID"); 

        int orderId = odao.insertOrder(order);

        // (2) 주문 상세 생성 (장바구니 기준)
        @SuppressWarnings("unchecked")
        List<CartDTO> cartList = (List<CartDTO>) session.getAttribute("cartList");

        for (CartDTO cart : cartList) {
            odao.insertOrderDetail(orderId, cart);
        }

     // (3) 장바구니 정리
        // CartDTO → cart_id 추출
        List<Integer> cartIdList = cartList.stream()
                                           .map(CartDTO::getCartId)
                                           .toList();

        // 결제에 사용된 cart_id만 삭제
        int deletedCount = cdao.deleteCartByCartIds(cartIdList);

        /* =========================
           4,5. 결제 완료 화면용 데이터 조회
           (Map 기반 – 안전빵)
        ========================= */
        Map<String, Object> orderHeader = odao.selectOrderHeader(orderId);
        List<Map<String, Object>> orderItems =
                odao.selectOrderDetailForPayment(orderId);

        request.setAttribute("order", orderHeader);
        request.setAttribute("orderItems", orderItems);

        
        //  여기서 DB 처리 / 결제 검증
        setRedirect(false);
        setViewPage("/WEB-INF/pay_MS/paymentSuccess.jsp");
    }
}

