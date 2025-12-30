package admin.controller;

import java.sql.SQLException;

import org.json.JSONObject;

import common.controller.AbstractController;
import coupon.domain.CouponDTO;
import coupon.model.CouponDAO;
import coupon.model.CouponDAO_imple;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


public class CouponCreate extends AbstractController {

	private CouponDAO cpDao = new CouponDAO_imple();
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String method = request.getMethod();
		int n = 0;
		String message = "";
		String loc = "";
		
		if("POST".equalsIgnoreCase(method)) {
			// POST 방식이라면
			
			String couponName = request.getParameter("couponName");
			String discountType = request.getParameter("discountType");
			String discountValue = request.getParameter("discountValue");
			
			System.out.println(method);
	//		System.out.println(couponName);
	//		System.out.println(discountType); // percentage or fixed
	//		System.out.println(discountValue);
			
			CouponDTO cpDto = new CouponDTO();
			
			cpDto.setCouponName(couponName);
			
			if("fixed".equals(discountType)) {
				discountType = "0";
			}
			else {
				discountType = "1";
			}
			
			cpDto.setDiscountType(Integer.parseInt(discountType));
			cpDto.setDiscountValue(Integer.parseInt(discountValue));
		
			try {
				n = cpDao.CouponCreate(cpDto);
				
				if(n==1) {
					message = cpDto.getCouponName()+" 쿠폰 생성이 완료되었습니다.";
					loc = request.getContextPath()+"/admin/coupon.hp";
					
				}
				
				
			}catch(SQLException e) {
				e.printStackTrace();
				message = "쿠폰 생성이 DB오류로 인해 실패했습니다.";
				loc = "javascript:history.back()";
			}
			
		}
		else {
			// POST 방식이 아니라면
			message = "비정상적인 경로로 들어왔습니다.";
			loc = "javascript:history.back()";
			
		}
		
		JSONObject jsonObj = new JSONObject(); // {} 자바스크립트에서 쓸 수 있는 빈 객체
		jsonObj.put("n", n); //	{"n":1} 또는 {"n":0}
		jsonObj.put("message", message); 
		jsonObj.put("loc", loc); 
		String json = jsonObj.toString();
		request.setAttribute("json", json);
		request.setAttribute("popup_close", true); // 팝업창 닫기 용도
		
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/admin/admin_jsonview.jsp");
		
	}

}
