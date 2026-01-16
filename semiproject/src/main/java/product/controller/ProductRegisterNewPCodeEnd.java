package product.controller;


import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;
import java.util.Calendar;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;

import common.controller.AbstractController;
import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import product.domain.ProductDTO;
import product.model.ProductDAO;
import product.model.ProductDAO_imple;


//상품등록 페이지의 데이터를 DB에 넣어주는 페이지
//해당 페이지는 상품추가 및 옵션추가 모두 해주는 페이지
public class ProductRegisterNewPCodeEnd extends AbstractController {
	private ProductDAO proDao = new ProductDAO_imple();
	
	private String extractFileName(String partHeader) {
		if (partHeader == null) return null;
		
		for(String cd : partHeader.split("\\;")) {
			cd = cd.trim();
			
			if(cd.startsWith("filename")) {
				String fileName = cd.substring(cd.indexOf("=") + 1).trim().replace("\"", ""); 
				// 경로 제거 ( \ 또는 / 모두 대응 )
	            fileName = fileName.substring(
	                Math.max(fileName.lastIndexOf('/'), fileName.lastIndexOf('\\')) + 1
	            );

	            // 파일명이 비어있으면 null
	            if (fileName.isBlank()) return null;

	            return fileName;
	            
				// File.separator 란? OS가 Windows 이라면 \ 이고, OS가 Mac, Linux, Unix 이라면 / 을 말하는 것이다.
				//int index = fileName.lastIndexOf(File.separator);        
				//return fileName.substring(index + 1);
			}
		}
		return null;
	}
	
    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        //System.out.println("상품등록페이지 최종 처리 시작..");
    	
    	//1️ JSON 문자열 읽기
    	Part jsonPart = request.getPart("registrationData");
    	
    	StringBuilder sb = new StringBuilder();
    	BufferedReader br = new BufferedReader(
    	    new InputStreamReader(jsonPart.getInputStream(), "UTF-8")
    	);
    	String line;
    	while ((line = br.readLine()) != null) {
    	    sb.append(line);
    	}
    	
    	JSONObject jsonRequest = new JSONObject(sb.toString());

        
        
        
        //1. 첨부되어진 파일을 디스크의 어느 경로에 업로드 할 것인지 그 경로를 설정해야 한다.  
    	HttpSession session = request.getSession();
		ServletContext svlCtx = session.getServletContext();
		String uploadFileDir = svlCtx.getRealPath("/image/product_TH");
		//System.out.println("이미지 파일 실제경로: " + uploadFileDir);
		//이미지 파일 실제경로: C:\NCS\workspace_jsp\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\semiproject\image\product_TH
        
		String image = null; //제품 이미지
		Collection<Part> parts = request.getParts();
		
		for(Part part : parts) {
			
			//form 태그에서 전송되어온 것이 파일일 경우
			if(part.getHeader("Content-Disposition").contains("filename=")) {
				
				String cd = part.getHeader("Content-Disposition");
			    if (cd == null || !cd.contains("filename")) continue;
				
			    String fileName = extractFileName(cd);
			    
			    //핵심 방어 로직
			    if (fileName == null || !fileName.contains(".")) {
			        //System.out.println("⛔ 업로드 제외 파일: " + fileName);
			        continue;
			    }
			    
			    
				if(part.getSize() > 0) {
					//System.out.println("업로드한 파일명:  " + fileName);
					//업로드한 파일명:  berkelekle단가라포인트03.jpg
					
					String newFilename = fileName.substring(0, fileName.lastIndexOf(".")); // 확장자를 뺀 파일명 알아오기  
					newFilename += "_"+String.format("%1$tY%1$tm%1$td%1$tH%1$tM%1$tS", Calendar.getInstance()); 
		    		newFilename += System.nanoTime();
		    		newFilename += fileName.substring(fileName.lastIndexOf(".")); // 확장자 붙이기
		    		//System.out.println("실제 업로드 newFilename: " + newFilename);
		    		//실제 업로드 newFilename: berkelekle단가라포인트03_2026011610291591511433391300.jpg
		    		
		    		//파일을 지정된 디스크 경로에 저장해주기. 이것이 파일을 업로드 해주는 작업
		    		part.write(uploadFileDir + File.separator + newFilename);
		    		
		    		//임시 저장된 파일 데이터를 제거
		    		part.delete();
		    		
		    		if("image".equals(part.getName())) {
		    			image = newFilename;
		    		}
				}//end of if(part.getSize() > 0)-----
				
			}//end of if(part.getHeader("Content-Disposition").contains("filename="))-----
			//form 태그에서 전송되어온 파일이 아닐 경우
			else {
				String formValue = request.getParameter(part.getName());
				System.out.printf("파일이 아닌 경우 파라미터(name)명 : %s, value값 : %s \n", part.getName(), formValue);
			}
			System.out.println("");
			
		}//end of for()-----
		
		
        //2️ product 객체 파싱
        JSONObject product = jsonRequest.getJSONObject("product");
        String productCode = product.getString("productCode");	//상품코드
        String productName = product.getString("productName");	//상품명
        String brand = product.getString("brand");				//브랜드명
        
		// !!!! 크로스 사이트 스크립트 공격에 대응하는 안전한 코드(시큐어코드) 작성하기 !!!! //
		// 2024년 12월 기준 전후로 <script 가 들어오면 크롬(엣지)웹브라우저 차원에서
		// Uncaught SyntaxError: Unexpected token '<' 라는 오류를 발생시켜서 차단을 시켜버리고 있음. 
        String description = product.getString("description");	//상품설명
        description = description.replaceAll("<", "&lt;");
        description = description.replaceAll(">", "&gt;");
        
		// 입력한 내용에서 엔터는 <br>로 변환하기
        description = description.replaceAll("\r\n", "<br>");
        
        
        int basePrice = product.getInt("basePrice");			//기본금(256GB)
        //String imagePath = product.getString("imagePath");		//이미지경로
        String salesStatus = product.getString("salesStatus");	//판매상태
        
        //ProductDTO에 값들 모두 넣어주기
        ProductDTO proDto = new ProductDTO();
        proDto.setProductCode(productCode);
        proDto.setProductName(productName);
        proDto.setBrandName(brand);
        proDto.setProductDesc(description);
        proDto.setPrice(basePrice);
        proDto.setImagePath(image);
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
