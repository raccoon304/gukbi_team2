package pay.controller;

import java.io.PrintWriter;
import org.json.JSONObject;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;
import order.domain.OrderDTO;
import order.model.OrderDAO;
import order.model.OrderDAO_imple;

public class CreateOrderController extends AbstractController {
	
	// 결제페이지에서 PG창으로 들어가는 통로
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		
		response.setContentType("application/json; charset=UTF-8");
		PrintWriter out = response.getWriter();
		
		HttpSession session = request.getSession();
		MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

		/* ================= 로그인 체크 ================= */
		if (loginUser == null) {
			System.out.println("로그인 안 됨!");
			JSONObject json = new JSONObject();
			json.put("success", false);
			json.put("message", "로그인이 필요합니다.");
			out.print(json.toString());
			return;
		}
		
		System.out.println("로그인 사용자: " + loginUser.getName());

		/* ================= 파라미터 수신 ================= */
		String totalPriceStr = request.getParameter("totalPrice");
		String discountPriceStr = request.getParameter("discountPrice");
		String finalPriceStr = request.getParameter("finalPrice");
		String deliveryAddress = request.getParameter("deliveryAddress");
		String detailAddress = request.getParameter("detailAddress");
		String couponIdStr = request.getParameter("couponId");
		
		// recipientName, recipientPhone은 파라미터가 없으면 세션의 loginUser에서 가져옴
		String recipientName = request.getParameter("recipientName");
		String recipientPhone = request.getParameter("recipientPhone");
		
		if (recipientName == null || recipientName.isEmpty()) {
			recipientName = loginUser.getName();
		}
		if (recipientPhone == null || recipientPhone.isEmpty()) {
			recipientPhone = loginUser.getMobile();
		}
		
		System.out.println("받은 파라미터:");
		System.out.println("totalPrice: " + totalPriceStr);
		System.out.println("discountPrice: " + discountPriceStr);
		System.out.println("finalPrice: " + finalPriceStr);
		System.out.println("deliveryAddress: " + deliveryAddress);
		System.out.println("detailAddress: " + detailAddress);
		System.out.println("recipientName: " + recipientName);
		System.out.println("recipientPhone: " + recipientPhone);
		System.out.println("couponId: " + couponIdStr);

		/* ================= 유효성 검사 ================= */
		if (totalPriceStr == null || deliveryAddress == null) {
			System.out.println("필수 정보 누락!");
			JSONObject json = new JSONObject();
			json.put("success", false);
			json.put("message", "필수 정보가 누락되었습니다.");
			out.print(json.toString());
			return;
		}

		try {
			int totalPrice = Integer.parseInt(totalPriceStr);
			int discountPrice = (discountPriceStr != null && !discountPriceStr.isEmpty()) 
				? Integer.parseInt(discountPriceStr) : 0;
			int finalPrice = (finalPriceStr != null && !finalPriceStr.isEmpty()) 
				? Integer.parseInt(finalPriceStr) : totalPrice;
			Integer couponId = (couponIdStr != null && !couponIdStr.isEmpty() && !couponIdStr.equals("null") && !couponIdStr.equals("")) 
				? Integer.parseInt(couponIdStr) : null;

			/* ================= 주소 합치기 ================= */
			String fullAddress = deliveryAddress;
			if (detailAddress != null && !detailAddress.trim().isEmpty()) {
				fullAddress += " " + detailAddress;
			}
			
			System.out.println("최종 주소: " + fullAddress);
			System.out.println("최종 금액: " + finalPrice);

			/* ================= 임시 주문 생성 (READY 상태) ================= */
			OrderDTO order = new OrderDTO();
			order.setMemberId(loginUser.getMemberid());
			order.setTotalAmount(totalPrice);
			order.setDiscountAmount(discountPrice);
			order.setDeliveryAddress(fullAddress);
			order.setRecipientName(recipientName);
			order.setRecipientPhone(recipientPhone);
			order.setOrderStatus("READY");

			OrderDAO odao = new OrderDAO_imple();
			
			System.out.println("오래된 READY 주문 정리 시작...");
			/* ================= 오래된 READY 주문 정리 ================= */
			int expiredCount = odao.expireReadyOrders(loginUser.getMemberid());
			System.out.println("만료 처리된 주문 수: " + expiredCount);
			
			System.out.println("주문 생성 시작...");
			/* ================= 주문 생성 ================= */
			int orderId = odao.insertOrder(order);
			
			System.out.println("생성된 orderId: " + orderId);

			if (orderId > 0) {
				// 세션에 주문 ID 저장
				session.setAttribute("readyOrderId", orderId);
				
				// 쿠폰 사용 시 세션에 저장
				if (couponId != null) {
					session.setAttribute("usedCouponId", couponId);
				}
				
				// 성공 응답
				JSONObject json = new JSONObject();
				json.put("success", true);
				json.put("orderId", orderId);
				json.put("message", "주문이 생성되었습니다.");
				out.print(json.toString());
				
				System.out.println("========================================");
				System.out.println("주문 생성 완료 - orderId: " + orderId);
				System.out.println("========================================");
				
			} else {
				System.out.println("주문 생성 실패! orderId가 0 이하");
				// 실패 응답
				JSONObject json = new JSONObject();
				json.put("success", false);
				json.put("message", "주문 생성에 실패했습니다.");
				out.print(json.toString());
			}

		} catch (NumberFormatException e) {
			System.err.println("숫자 변환 오류: " + e.getMessage());
			e.printStackTrace();
			JSONObject json = new JSONObject();
			json.put("success", false);
			json.put("message", "잘못된 금액 정보입니다.");
			out.print(json.toString());
			
		} catch (Exception e) {
			System.err.println("예상치 못한 오류: " + e.getMessage());
			e.printStackTrace();
			JSONObject json = new JSONObject();
			json.put("success", false);
			json.put("message", "서버 오류가 발생했습니다: " + e.getMessage());
			out.print(json.toString());
		}
	}
}