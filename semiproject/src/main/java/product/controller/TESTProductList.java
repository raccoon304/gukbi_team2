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
		
		//제품 테이블의 정보들 모두 가져오기
		List<ProductDTO> productList = proDao.selectProduct();
		request.setAttribute("productList", productList);


		super.setRedirect(false);
		super.setViewPage("/WEB-INF/product_TH/TESTProductList.jsp");
	}

}
