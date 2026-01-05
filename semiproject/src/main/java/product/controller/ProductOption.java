package product.controller;

import java.util.List;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import product.domain.ProductDTO;
import product.domain.ProductOptionDTO;
import product.model.ProductDAO;
import product.model.ProductDAO_imple;

//상품상세페이지
public class ProductOption extends AbstractController {
	private ProductDAO proDao = new ProductDAO_imple();
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String productCode = request.getParameter("productCode");
		//위의 받아온 productCode는 상품테이블의 상품코드임!!
		
		try {
			//제품정보 가져오기(제품테이블)
			ProductDTO proDto = proDao.selectOne(productCode);
			//제품상세 옵션 리스트 정보 가져오기(제품상세테이블)
			List<ProductOptionDTO> proOptionList = proDao.selectProductOption(productCode);
			
			ProductOptionDTO proDetilDto = proDao.selectDetailOne(productCode);
			
			
			request.setAttribute("proDto", proDto);
			request.setAttribute("proOptionList", proOptionList);
			
			request.setAttribute("proDetilDto", proDetilDto);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/product_TH/productOption.jsp");
	}

}
