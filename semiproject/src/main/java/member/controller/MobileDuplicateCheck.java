package member.controller;

import org.json.JSONObject;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import member.model.MemberDAO;
import member.model.MemberDAO_imple;

public class MobileDuplicateCheck extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		MemberDAO mdao = new MemberDAO_imple();
		String method = request.getMethod(); // GET 또는 POST가 나옴. 
		
		if("POST".equalsIgnoreCase(method)) {
			String mobile = request.getParameter("mobile");
			
			boolean isExists = mdao.mobileDuplicateCheck(mobile);
			
			JSONObject jsonObj = new JSONObject(); 	// 자바스크립트에서 쓸 빈객체 하나 생성
			jsonObj.put("isExists", isExists);		// {"isExists", true} 또는 {"isExists", false}로 나오게됨.
			System.out.println("확인용 isExists => " + isExists); 
				
			String json = jsonObj.toString(); 
			System.out.println("확인용 JSON => " + json); 
			
			request.setAttribute("json", json); 
			
			super.setRedirect(false);
			super.setViewPage("/WEB-INF/jsonview.jsp");
		}//EoP if
		else {//GET으로 들어온 경우 
			
		}	

	}

}
