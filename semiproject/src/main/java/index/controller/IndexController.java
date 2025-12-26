package index.controller;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import member.model.MemberDAO;
import member.model.MemberDAO_imple;

public class IndexController extends AbstractController {

	

	
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {     
		
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/index.jsp");	
	}
}
