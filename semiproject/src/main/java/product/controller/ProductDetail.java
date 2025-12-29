package product.controller;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class ProductDetail extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		System.out.println("안녕하세요? 디테일하시네요~ productDetail.hp 들어왔어요~");
		
		String method = request.getMethod();
		
		System.out.println("method: "+method);
		
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/anth(상품)/productDetail.jsp");
	}

}
