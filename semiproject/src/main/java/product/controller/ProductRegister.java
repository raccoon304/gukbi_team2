package product.controller;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

//상품등록페이지//
public class ProductRegister extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String method = request.getMethod();
		
		//System.out.println(method);
		//System.out.println("안녕하세요~ 상품등록페이지입니다.");
		
		
		
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/product_TH/productRegister.jsp");
		
	}//end of execute()-----

}
