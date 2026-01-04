package product.controller;

import java.util.List;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import product.domain.ProductListDTO;
import product.model.ProductDAO;
import product.model.ProductDAO_imple;

//상품페이지의 카드 UI에 적용시킬 값을 가져오기 위한 파일
public class ProductList extends AbstractController {
	private ProductDAO proDao = new ProductDAO_imple(); 
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		//String method = request.getMethod();
		
		try {
			//상품페이지의 카드UI용 DTO를 이용해 상품정보 가져오기(상품코드, 상품명, 브랜드명, 이미지경로, 옵션중 가장 낮은 가격)
			List<ProductListDTO> productCardList = proDao.productCardList();
			request.setAttribute("productCardList", productCardList);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/product_TH/productList.jsp");
	}

}
