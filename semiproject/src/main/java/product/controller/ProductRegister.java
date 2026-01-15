package product.controller;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;

//상품등록페이지//
public class ProductRegister extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		HttpSession session = request.getSession();
        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
        
        if(!loginUser.getMemberid().equals("admin")) {
        	//관리자가 아닐 경우(아마 그럴 일 없음)
        	super.setRedirect(true);
        	super.setViewPage(request.getContextPath()+"/index.hp");
        	
        } else {
        	//관리자인 경우
        	//System.out.println("관리자입니다~");
        	super.setRedirect(false);
        	super.setViewPage("/WEB-INF/product_TH/productRegister.jsp");
        }
		
		
	}//end of execute()-----

}
