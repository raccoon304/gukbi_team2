package index.controller;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.websocket.Session;
import member.domain.MemberDTO;
import product.domain.ProductDTO;
import product.model.ProductDAO;
import product.model.ProductDAO_imple;

public class IndexController extends AbstractController {
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {     
		
		//로그인을 한 세션정보 가져오기(MemberLogin.java / myPage.java 참고)
		/*
		 * HttpSession session = request.getSession(); Session loginUser =
		 * session.getAttribute("loginUser");
		 * 
		 * System.out.println(loginUser.getName());
		 * 
		 * request.setAttribute("loginUser", loginUser);
		 */
		
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/index.jsp");	
		//System.out.println("index.hp에 잘 들어왔습니다.");
	}
}
