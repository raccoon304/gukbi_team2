package product.controller;

import org.json.JSONObject;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import product.model.ProductDAO;
import product.model.ProductDAO_imple;

// 상품코드 중복확인 페이지 //
public class CheckDuplicateProductCode extends AbstractController {
	private ProductDAO proDao = new ProductDAO_imple();
	

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String method = request.getMethod();
		
		//System.out.println(method);
		//System.out.println("상품코드 중복체크 파일에 잘 들어왔습니다.");
		if("GET".equalsIgnoreCase(method)) {
			
			
		} else {
			String productCode = request.getParameter("productCode");
			//System.out.println(productCode);
			
			//상품코드 중복확인하기(중복된 값이 있다면 true를 반환하여 가져옴)
			boolean isProductCode = proDao.ckProductCode(productCode);
			
			JSONObject jsonObj = new JSONObject();
			jsonObj.put("isProductCode", isProductCode);
			
			String json = jsonObj.toString();
			request.setAttribute("json", json);
			
			super.setRedirect(false);
			super.setViewPage("/WEB-INF/jsonview.jsp");
			
		}//end of if~else()-----
	}//end of execute()-----
}
