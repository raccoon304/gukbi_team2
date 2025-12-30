package product.controller;

import java.util.List;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import product.domain.ProductDTO;
import product.model.ProductDAO;
import product.model.ProductDAO_imple;

public class TESTProductList extends AbstractController {
	private ProductDAO proDao = new ProductDAO_imple(); 
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		//String method = request.getMethod();
		//System.out.println("method: "+method);
		
		//제품에 대한 내용 출력하기
		//List<ProductDTO> proList = proDao.selectProduct();
		//request.setAttribute("proList", proList);


		super.setRedirect(false);
		super.setViewPage("/WEB-INF/product_TH/TESTProductList.jsp");
	}

}
