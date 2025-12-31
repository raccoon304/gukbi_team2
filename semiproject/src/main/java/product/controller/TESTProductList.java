package product.controller;


import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class TESTProductList extends AbstractController {
	
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
