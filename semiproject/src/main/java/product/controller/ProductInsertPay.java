package product.controller;

import java.util.HashMap;
import java.util.Map;

import org.json.JSONObject;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import product.model.ProductDAO;
import product.model.ProductDAO_imple;


// ======= 구매하기 페이지 =======
public class ProductInsertPay extends AbstractController {
	private ProductDAO proDao = new ProductDAO_imple();

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String method = request.getMethod();
		String message = "";
		String loc = "";
		
		String productCode = "";
		String productOptionId = "";
		String quantity = ""; 
		if("POST".equalsIgnoreCase(method)) {
			request.getParameter("productCode"); //상품코드
			request.getParameter("productOptionId"); //옵션아이디
			request.getParameter("quantity"); //주문수량
			
			request.setAttribute("productCode", productCode);
			request.setAttribute("productOptionId", productOptionId);
			request.setAttribute("quantity", quantity);
			
			
			super.setRedirect(false);
			super.setViewPage("/WEB-INF/pay_MS/payMent.jsp");
			
			
			message = "상품 구매 페이지로 이동하시겠습니까?"; 
			loc = request.getContextPath() + "/pay/payMent.hp";
			 
			
		} else {
			//GET방식으로 들어온 경우
			message = "올바른 접근 방식이 아닙니다.";
			loc = "javascript:history.back()";
			
			super.setRedirect(true);
			super.setViewPage(request.getContextPath()+"/index.hp");
		}
		
		//proDao.selectFindProductOption();
		JSONObject jsonObj = new JSONObject(); 
		jsonObj.put("productCode",productCode); 
		jsonObj.put("productOptionId", productOptionId);
		jsonObj.put("quantity", quantity); jsonObj.put("message", message);
		jsonObj.put("loc", loc);
		
		String json = jsonObj.toString(); request.setAttribute("json", json);
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/jsonview.jsp");
		

	}//end of execute()-----

}
