package product.controller;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class ProductList extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		//System.out.println("안녕하세요?? productList.hp 들어왔어요~");
		
		String method = request.getMethod();
		//System.out.println("method: "+method);
		
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/product_TH/productList.jsp");
	}

}
