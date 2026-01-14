package product.controller;


import java.util.HashMap;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import product.model.ProductDAO;
import product.model.ProductDAO_imple;


//상품등록 페이지의 데이터를 DB에 넣어주는 페이지
//해당 페이지는 옵션만 추가할 때 사용
public class ProductRegisterEnd extends AbstractController {
	private ProductDAO proDao = new ProductDAO_imple();
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		System.out.println("상품등록페이지의 최종입니다..");
		String message = "상품등록에 성공했습니다.";
		
	    // JSON 데이터 읽기
	    StringBuilder sb = new StringBuilder();
	    String line;
	    while ((line = request.getReader().readLine()) != null) {
	        sb.append(line);
	    }
	    JSONObject jsonRequest = new JSONObject(sb.toString());

	    //받아온 상품코드
	    String productCode = jsonRequest.getString("productCode");
        
        //options 배열 파싱
        JSONArray options = jsonRequest.getJSONArray("optionData");
        Map<String, String> paraMap = new HashMap<>();
        int result = 0;
        
        for(int i = 0; i < options.length(); i++) {
            JSONObject opt = options.getJSONObject(i);
            result = 0;
            
            paraMap.put("productCode", productCode);
            paraMap.put("color", opt.getString("color"));
            paraMap.put("storage", opt.getString("storage"));
            paraMap.put("stock", String.valueOf(opt.getInt("stock")));
            paraMap.put("additionalPrice", String.valueOf(opt.getInt("additionalPrice")));
            
            //선택한 옵션(용량, 색상)이 중복옵션인지, 새 옵션인지 알아와서 update/insert 해주기
            result = proDao.selectInsertOrUpdateOption(paraMap);
            if(result == 0) {
            		System.out.println("DB 오류!");
            		break;
            }
        }//end of for()-----

		
	    
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("message", message);
		
		String json = jsonObj.toString();
		request.setAttribute("json", json);
		
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/jsonview.jsp");
	}//end of execute()-----
}
