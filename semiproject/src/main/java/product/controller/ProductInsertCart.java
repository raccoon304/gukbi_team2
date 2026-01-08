package product.controller;

import java.util.HashMap;
import java.util.Map;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import product.model.ProductDAO;
import product.model.ProductDAO_imple;

public class TestJSON extends AbstractController {
	private ProductDAO proDao = new ProductDAO_imple();
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		//옵션ID를 구하기 위한 값들
		String productCode = request.getParameter("productCode");
		String storage =request.getParameter("storage");
		String color =request.getParameter("color");
		
		//장바구니에서 결제하기 위한 주문수량과 기본금액, 추가금
		String quantity = request.getParameter("quantity");
		String totalPrice = request.getParameter("totalPrice");
		String unitPrice = request.getParameter("unitPrice");
		
		
		
		Map<String, String> paraMap = new HashMap<String, String>();
		paraMap.put("productCode", productCode);
		paraMap.put("storage", storage);
		paraMap.put("color", color);
		paraMap.put("quantity", quantity);
		paraMap.put("totalPrice", totalPrice);
		paraMap.put("unitPrice", unitPrice);
		
		System.out.println("\n"+ productCode +"\n"+ storage +"\n"+ color +"\n"+ totalPrice+ "\n" +quantity+ "\n" +unitPrice);
		//proDao.selectFindProductOption();
		
	}

}
