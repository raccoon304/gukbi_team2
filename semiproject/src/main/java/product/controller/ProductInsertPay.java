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
		
		if("POST".equalsIgnoreCase(method)) {
			String loginUserId = request.getParameter("loginUserId"); //회원아이디
			String productOptionId = request.getParameter("productOptionId"); //옵션아이디
			String quantity = request.getParameter("quantity"); //주문수량
			
			//System.out.println(loginUserId+"\n"+productOptionId+"\n"+quantity);
			
			Map<String, String> paraMap = new HashMap<String, String>();
			paraMap.put("loginUserId", loginUserId);
			paraMap.put("productOptionId", productOptionId);
			paraMap.put("quantity", quantity);
			
			//넘길데이터: 옵션아이디, 기본금액, 추가금액, 주문수량
			//int result = proDao.insertProductPay(paraMap);
			
			message = "상품 구매 페이지로 이동합니다.";
			loc = request.getContextPath() + "/pay/payMent.hp";
			/*
			if(result == 1) {
			} else {
				System.out.println("Insert문 SQL에 오류가 발생했습니다.");
			}
			*/
			
		} else {
			//GET방식으로 들어온 경우
			message = "올바른 접근 방식이 아닙니다.";
			loc = "javascript:history.back()";
		}
		
		//proDao.selectFindProductOption();
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("message", message);
		jsonObj.put("loc", loc);
		
		String json = jsonObj.toString();
		request.setAttribute("json", json);
		
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/jsonview.jsp");

	}//end of execute()-----

}
