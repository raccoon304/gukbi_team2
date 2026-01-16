package product.controller;


import java.util.HashMap;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import product.domain.ProductDTO;
import product.model.ProductDAO;
import product.model.ProductDAO_imple;


//상품등록 페이지의 데이터를 DB에 넣어주는 페이지
//해당 페이지는 상품추가 및 옵션추가 모두 해주는 페이지
public class ProductRegisterNewPCodeEndOriginal extends AbstractController {
	private ProductDAO proDao = new ProductDAO_imple();
	
    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        System.out.println("상품등록페이지 최종 처리 시작..");

        //1️ JSON 문자열 읽기
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = request.getReader().readLine()) != null) {
            sb.append(line);
        }
        JSONObject jsonRequest = new JSONObject(sb.toString());


        //2️ product 객체 파싱
        JSONObject product = jsonRequest.getJSONObject("product");
        String productCode = product.getString("productCode");	//상품코드
        String productName = product.getString("productName");	//상품명
        String brand = product.getString("brand");				//브랜드명
        String description = product.getString("description");	//상품설명
        int basePrice = product.getInt("basePrice");				//기본금(256GB)
        String imagePath = product.getString("imagePath");		//이미지경로
        String salesStatus = product.getString("salesStatus");	//판매상태
        
        //ProductDTO에 값들 모두 넣어주기
        ProductDTO proDto = new ProductDTO();
        proDto.setProductCode(productCode);
        proDto.setProductName(productName);
        proDto.setBrandName(brand);
        proDto.setProductDesc(description);
        proDto.setPrice(basePrice);
        proDto.setImagePath(imagePath);
        proDto.setSaleStatus(salesStatus);
        
        //새로운 상품을 테이블에 삽입해주기
        int n = proDao.insertProduct(proDto);
        if(n == 0) {
    		System.out.println("DB 오류입니다!!");
        }
        

        
        
        // 3️ options 배열 파싱
        JSONArray options = jsonRequest.getJSONArray("options");
        Map<String, String> paraMap = new HashMap<>();
        int result = 0;
        
        for (int i = 0; i < options.length(); i++) {
            JSONObject opt = options.getJSONObject(i);
            result = 0;

            paraMap.put("productCode", productCode);
            paraMap.put("color", opt.getString("color"));
            paraMap.put("storage", opt.getString("storage"));
            paraMap.put("stock", String.valueOf(opt.getInt("stock")));
            paraMap.put("additionalPrice", String.valueOf(opt.getInt("additionalPrice")));
            
            //새로운 상품에 대해 옵션들 추가해주기
            result = proDao.selectInsertOption(paraMap);
            if(result == 0) {
        		System.out.println("DB 오류!");
        		break;
            }
        }//end of for()-----

        
        //4️ JSON 응답
        JSONObject jsonObj = new JSONObject();
        jsonObj.put("message", "상품등록에 성공했습니다.");
        request.setAttribute("json", jsonObj.toString());

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/jsonview.jsp");
        
    }//end of execute()-----
}
