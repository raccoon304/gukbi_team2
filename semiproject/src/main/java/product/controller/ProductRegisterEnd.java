package product.controller;

import org.json.JSONObject;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

//상품등록 페이지의 데이터를 DB에 넣어주는 페이지
public class ProductRegisterEnd extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		System.out.println("상품등록페이지의 최종입니다..");
		
		String message = "상품등록에 성공했습니다.";
		
		
		
		
		
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("message", message);
		
		String json = jsonObj.toString();
		request.setAttribute("json", json);
		
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/jsonview.jsp");
		
		
		
	}//end of execute()-----
}
