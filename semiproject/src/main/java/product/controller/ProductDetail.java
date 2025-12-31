package product.controller;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import product.domain.ProductDTO;
import product.domain.ProductDetailDTO;
import product.model.ProductDAO;
import product.model.ProductDAO_imple;

public class ProductDetail extends AbstractController {
	private ProductDAO proDao = new ProductDAO_imple();
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		//System.out.println("안녕하세요? 디테일하시네요~ productDetail.hp 들어왔어요~");
		
		String test = request.getParameter("seq");
		//System.out.println(test);
		
		try {
			//제품상세 정보 가져오기
			ProductDetailDTO proDetilDto = proDao.selectDetailOne(test);
			ProductDTO proDto = proDao.selectOne(test);
			/* ====== 상품상세테이블의 데이터 가져오기 ======
			 * System.out.println(proDetilDto.getOptionId() +"\n"
			 * +proDetilDto.getFkProductCode()+"\n" +proDetilDto.getColor()+"\n"
			 * +proDetilDto.getStorageSize()+"\n" +proDetilDto.getColor()+"\n"
			 * +proDetilDto.getStockQty()+"\n" +proDetilDto.getImagePath());
			 */
			
			/* ====== 상품테이블의 데이터 가져오기 ======
			 * System.out.println(proDto.getProductCode()+"\n"+
			 * proDto.getProductName()+"\n"+ proDto.getBrandName()+"\n"+
			 * proDto.getProductDesc()+"\n"+ proDto.getSaleStatus()+"\n");
			 */
			
			
			request.setAttribute("proDetilDto", proDetilDto);
			request.setAttribute("proDto", proDto);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/product_TH/productDetail.jsp");
	}

}
