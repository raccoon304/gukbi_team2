package index.controller;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import product.domain.ProductDTO;
import product.model.ProductDAO;
import product.model.ProductDAO_imple;

public class IndexController extends AbstractController {
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {     
		
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/index.jsp");	
		//System.out.println("index.hp에 잘 들어왔습니다.");
	}
}
