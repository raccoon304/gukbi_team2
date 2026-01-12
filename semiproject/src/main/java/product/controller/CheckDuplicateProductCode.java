package product.controller;

import org.json.JSONObject;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import product.domain.ProductOptionDTO;
import product.model.ProductDAO;
import product.model.ProductDAO_imple;

// 상품코드 중복확인 페이지 //
public class CheckDuplicateProductCode extends AbstractController {
	private ProductDAO proDao = new ProductDAO_imple();
	

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String method = request.getMethod();
		String message = "";
		
		//System.out.println(method);
		//System.out.println("상품코드 중복체크 파일에 잘 들어왔습니다.");
		if("GET".equalsIgnoreCase(method)) {
			
			
		} else {
			String productCode = request.getParameter("productCode");
			//System.out.println(productCode);
			
			//상품코드 중복확인하기(중복된 값이 있다면 true를 반환하여 가져옴)
			boolean isProductCode = proDao.ckProductCode(productCode);
			
			String productName = "";
			String brandName = "";
			String productDESC = "";
			int price = 0;
			
			if(isProductCode) {
				//상품코드가 중복된 경우 => 옵션값을 가져오기
				//message = "이미 존재하는 상품코드입니다. 옵션값을 알아오겠습니다.";
				ProductOptionDTO proOptionDto = proDao.selectOptionOne(productCode);
				productName = proOptionDto.getProDto().getProductName();
				price = proOptionDto.getProDto().getPrice();
				brandName = proOptionDto.getProDto().getBrandName();
				productDESC = proOptionDto.getProDto().getProductDesc();
				
				//System.out.println(proOptionDto.getProDto().getProductName());
				//System.out.println(proOptionDto.getProDto().getPrice());
			} else {
				//중복되지 않은 상품코드
				
			}
			
			JSONObject jsonObj = new JSONObject();
			jsonObj.put("isProductCode", isProductCode);
			jsonObj.put("productName", productName);
			jsonObj.put("price", price);
			jsonObj.put("brandName", brandName);
			jsonObj.put("productDESC", productDESC);
			//jsonObj.put("message", message);
			
			String json = jsonObj.toString();
			request.setAttribute("json", json);
			
			super.setRedirect(false);
			super.setViewPage("/WEB-INF/jsonview.jsp");
			
		}//end of if~else()-----
	}//end of execute()-----
}
