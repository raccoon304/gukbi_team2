package member.controller;

import java.util.HashMap;
import java.util.Map;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;
import member.model.MemberDAO;
import member.model.MemberDAO_imple;

public class MemberLogin extends AbstractController {
	
	private MemberDAO mbDao = new MemberDAO_imple();
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String method = request.getMethod(); 
		
		//System.out.println("method=" + request.getMethod());
		//System.out.println("queryString=" + request.getQueryString());
		
		
	    if("GET".equalsIgnoreCase(method)) {
	    	// GET 방식으로 들어온 경우
	        String message = "비정상적인 접근입니다!";
	        String loc = "javascript:history.back()"; // 이전 페이지로 되돌려보내기.
	         
	        request.setAttribute("message", message);
	        request.setAttribute("loc", loc);
	         
	        super.setRedirect(false);
	        super.setViewPage("/WEB-INF/msg.jsp");
	        return;
	    }
	    String loginId = request.getParameter("loginId");
	    String loginPw = request.getParameter("loginPw");
	    
	    Map<String, String> paraMap = new HashMap<>();
	    paraMap.put("loginId", loginId);
	    paraMap.put("loginPw", loginPw);
	      
		/*
		 * System.out.println("loginId param = " + request.getParameter("loginId"));
		 * System.out.println("loginPw param = " + request.getParameter("loginPw"));
		 * System.out.println("map loginId = " + paraMap.get("loginId"));
		 * System.out.println("map loginPw = " + paraMap.get("loginPw"));
		 * System.out.println("map loginPw length = " + (paraMap.get("loginPw")==null ?
		 * "null" : paraMap.get("loginPw").length()));
		 */
	    
	    MemberDTO loginUser = mbDao.login(paraMap); // 로그인 한 회원정보 가져오기
	    
	    response.setContentType("application/json; charset=UTF-8");
	    
	    if(loginUser != null) {
	    	HttpSession session = request.getSession();
			session.setAttribute("loginUser", loginUser);   	
	    	
			String json = "{\"success\":true, \"redirect\":\"" + request.getContextPath() + "/index.hp\"}";
			response.getWriter().write(json);
	    } else {
	    	String json = "{\"success\":false, \"message\":\"아이디 또는 비밀번호가 올바르지 않습니다.\"}";
	        response.getWriter().write(json);
	    }  
	}//end of execute()-----
}
