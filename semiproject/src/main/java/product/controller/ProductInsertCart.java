package product.controller;

import java.util.HashMap;
import java.util.Map;

import org.json.JSONObject;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import product.model.ProductDAO;
import product.model.ProductDAO_imple;

// ====== 장바구니 페이지 =======
public class ProductInsertCart extends AbstractController {
	private ProductDAO proDao = new ProductDAO_imple();
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String method = request.getMethod();
		String message = "";
		String loc = "";
		
		if("POST".equalsIgnoreCase(method)) {
			String productOptionId = request.getParameter("productOptionId"); //옵션아이디
			String quantity = request.getParameter("quantity"); //주문수량
			
			//System.out.println(loginUserId+"\n"+productOptionId+"\n"+quantity);
			Map<String, String> paraMap = new HashMap<String, String>();
			paraMap.put("productOptionId", productOptionId);
			paraMap.put("quantity", quantity);
			
			//fk_member_id(회원아이디), fk_option_id(옵션아이디), quantity(재고량)
			
			// 장바구니 테이블의 상품에 대해 확인하기
			boolean isCartProduct = proDao.isCartProduct(paraMap);
			int result = 0;
			if(isCartProduct) {
				//장바구니에 같은 상품이 있는 경우
				//장바구니 테이블에 상품이 있는 경우 ==> update
				result = proDao.updateProductCart(paraMap);
			} else {
				//장바구니에 같은 상품이 없는 경우
				//장바구니 테이블에 상품이 없는 경우 ==> insert
				result = proDao.insertProductCart(paraMap);
			}
			
			if(result != 0) {
				message = "장바구니 페이지로 이동하시겠습니까?";
				loc = request.getContextPath() + "/cart/zangCart.hp";
			} else {
				System.out.println("Insert문 SQL에 오류가 발생했습니다.");
			}
			
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
