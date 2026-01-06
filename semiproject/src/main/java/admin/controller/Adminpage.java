package admin.controller;

import java.util.List;

import admin.domain.AdminPageDTO;
import admin.model.AdminDAO;
import admin.model.AdminDAO_imple;
import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;

public class Adminpage extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		AdminDAO adao = new AdminDAO_imple();
		
		// 관리자(admin) 로 로그인 했을때만 접속 가능하도록 한다
		
		HttpSession session = request.getSession();
		
		MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
		
		if(loginUser != null && "admin".equals(loginUser.getMemberid())) {
			// 관리자로 로그인 했을 경우
		
		
		
			// 오늘 가입한 회원
			List<MemberDTO> todayNewMembers = adao.todayNewMembers();
			request.setAttribute("todayNewMembers", todayNewMembers);
			
			// 품절 임박 상품
			List<AdminPageDTO> lowStockProducts = adao.lowStockProducts();
			request.setAttribute("lowStockProducts", lowStockProducts);
			
			// 최근 주문 5건
			List<AdminPageDTO> currentOrders = adao.currentOrders();
			request.setAttribute("currentOrders", currentOrders);
			
			// 오늘 주문 수
			int todayOrderCount = adao.todayOrderCount();
			request.setAttribute("todayOrderCount", todayOrderCount);
			
			// 오늘 매출
			long todaySales = adao.todaySales();
			request.setAttribute("todaySales", todaySales);
			
			
			super.setRedirect(false);
			super.setViewPage("/WEB-INF/admin/dashboard.jsp");
			
			
			
		}
		else {
			// 관리자로 로그인 하지 않은 경우
			String message = "관리자만 접근이 가능합니다";
			String loc = "javascript:history.back()";
			
			request.setAttribute("message", message);
			request.setAttribute("loc", loc);
			
			super.setRedirect(false);
			super.setViewPage("/WEB-INF/admin/admin_msg.jsp");
			
		}
		
	}

}
