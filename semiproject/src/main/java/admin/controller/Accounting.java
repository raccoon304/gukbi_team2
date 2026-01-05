package admin.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import common.controller.AbstractController;
import coupon.domain.CouponDTO;
import coupon.model.CouponDAO;
import coupon.model.CouponDAO_imple;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class Accounting extends AbstractController {
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		CouponDAO cpDao = new CouponDAO_imple();
		
		// 관리자(admin) 로 로그인 했을때만 접속 가능하도록 한다
		
		HttpSession session = request.getSession();
		
//		MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");
		
//		if(loginuser != null && "admin".equals(loginuser.getUserid())) {
		    // 관리자로 로그인 했을 경우
		
		
		


	        super.setRedirect(false);
	        super.setViewPage("/WEB-INF/admin/accounting.jsp");
			
//		}
//		else {
			// 관리자로 로그인 하지 않은 경우
//			String message = "관리자만 접근이 가능합니다";
//			String loc = "javascript:history.back()";
			
//			request.setAttribute("message", message);
//			request.setAttribute("loc", loc);
			
//			super.setRedirect(false);
//			super.setViewPage("/WEB-INF/msg.jsp");
			
//		}		
		
		
	}

}
