package payment.controller;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;
import order.domain.OrderDTO;
import order.model.OrderDAO;
import order.model.OrderDAO_imple;

public class CoinPaymentPopupController extends AbstractController {
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		HttpSession session = request.getSession();
		MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
		
		// 1️ 로그인 체크
		if (loginUser == null) {
			response.setContentType("text/html; charset=UTF-8");
			response.getWriter().println("""
				<script>
					alert('로그인 후 이용 가능합니다.');  
					window.close();
				</script>
			""");
			return;
		}
		
		// 2️ GET 요청만 허용
		if (!"GET".equalsIgnoreCase(request.getMethod())) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST);
			return;
		}
		

		// 4️ finalPrice 검증
		int finalPrice;
		try {
			finalPrice = Integer.parseInt(request.getParameter("finalPrice"));
			if (finalPrice <= 0) throw new NumberFormatException();
		} catch (Exception e) {
			response.setContentType("text/html; charset=UTF-8");
			response.getWriter().println("""
				<script>
					alert('결제 금액이 올바르지 않습니다.');
					window.close();
				</script>
			""");
			return;
		}
			
		// ====== READY 생성 시작 ======
		OrderDAO odao = new OrderDAO_imple();

		// 1. 이전 READY 정리 (선택이지만 권장)
		odao.expireReadyOrders(loginUser.getMemberid());

		// 2. 주문 생성 (READY)
		OrderDTO order = new OrderDTO();
		order.setMemberId(loginUser.getMemberid());
		order.setTotalAmount(finalPrice);
		order.setOrderStatus("READY");
		// order.setPaymentTryAt(SYSDATE); // DAO에서 처리해도 OK

		order.setDeliveryAddress("(결제 안되서 미공개)");
		order.setRecipientName(loginUser.getName());
		order.setRecipientPhone(loginUser.getMobile());
		
		int orderId = odao.insertOrder(order);

		// 3. 세션에 저장 (이 시점이 READY 시작)
		session.setAttribute("readyOrderId", orderId);
		// ====== READY 생성 끝 ======
		
		
		// 6️ JSP로 넘길 값
		request.setAttribute("userid", loginUser.getMemberid());
		request.setAttribute("orderId", orderId);  // orderId 추가
		request.setAttribute("finalPrice", finalPrice);
		
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/pay_MS/coinPaymentPopup.jsp");
	}
}