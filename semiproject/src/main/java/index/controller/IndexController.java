package index.controller;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;

public class IndexController extends AbstractController {
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {     
		//HttpSession session = request.getSession();
        //MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
        
        //System.out.println("loginUser: " +loginUser);
        //if(loginUser != null) {
        	//System.out.println("loginUser: " +loginUser.getMemberid());
        //}
		
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/index.jsp");	
		//System.out.println("index.hp에 잘 들어왔습니다.");
		
	}//end of execute()-----
}
