package admin.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import common.controller.AbstractController;
import coupon.domain.CouponDTO;
import coupon.model.CouponDAO;
import coupon.model.CouponDAO_imple;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class CouponView extends AbstractController {
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		CouponDAO cpDao = new CouponDAO_imple();
		
		// 관리자(admin) 로 로그인 했을때만 접속 가능하도록 한다
		
		HttpSession session = request.getSession();
		
//		MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");
		
//		if(loginuser != null && "admin".equals(loginuser.getUserid())) {
		    // 관리자로 로그인 했을 경우
		
		
			String flashMsg = (String) session.getAttribute("flashMsg");
	
			if (flashMsg != null) {
			  request.setAttribute("msg", flashMsg);
			  session.removeAttribute("flashMsg");
			}
		
		
			// ======= 페이징 처리 없는 쿠폰 리스트 ======= //
		//	List<CouponDTO> couponList = cpDao.selectCouponList();
	    //  request.setAttribute("couponList", couponList);
	        
	        String sizePerPage = request.getParameter("sizePerPage");
	        String currentShowPageNo = request.getParameter("currentShowPageNo");

	        if(sizePerPage == null || (!"10".equals(sizePerPage) && !"5".equals(sizePerPage) && !"3".equals(sizePerPage))) {
	            sizePerPage = "10";
	        }

	        if(currentShowPageNo == null) {
	            currentShowPageNo = "1";
	        }

	        int totalPage = cpDao.getTotalPageCoupon(Integer.parseInt(sizePerPage));

	        // 장난 방지
	        try {
	            if(Integer.parseInt(currentShowPageNo) > totalPage || Integer.parseInt(currentShowPageNo) <= 0) {
	                currentShowPageNo = "1";
	            }
	        } catch(NumberFormatException e) {
	            currentShowPageNo = "1";
	        }

	        Map<String,String> paraMap = new HashMap<>();
	        paraMap.put("sizePerPage", sizePerPage);
	        paraMap.put("currentShowPageNo", currentShowPageNo);

	        // === 페이지바 만들기 ===
	        String pageBar = "";
	        int blockSize = 10;
	        int loop = 1;
	        int pageNo = ((Integer.parseInt(currentShowPageNo)-1)/blockSize)*blockSize + 1;

	        String ctxPath = request.getContextPath();
	        String url = ctxPath + "/admin/coupon.hp"
	                   + "?sizePerPage=" + sizePerPage;

	        pageBar += "<li class='page-item'><a class='page-link' href='"+url+"&currentShowPageNo=1'>[처음]</a></li>";

	        if(pageNo != 1) {
	            pageBar += "<li class='page-item'><a class='page-link' href='"+url+"&currentShowPageNo="+(pageNo-1)+"'>[이전]</a></li>";
	        }

	        while(!(loop > blockSize || pageNo > totalPage)) {

	            if(pageNo == Integer.parseInt(currentShowPageNo)) {
	                pageBar += "<li class='page-item active'><a class='page-link' href='#'>"+pageNo+"</a></li>";
	            } else {
	                pageBar += "<li class='page-item'><a class='page-link' href='"+url+"&currentShowPageNo="+pageNo+"'>"+pageNo+"</a></li>";
	            }

	            loop++;
	            pageNo++;
	        }

	        if(pageNo <= totalPage) {
	            pageBar += "<li class='page-item'><a class='page-link' href='"+url+"&currentShowPageNo="+pageNo+"'>[다음]</a></li>";
	        }

	        pageBar += "<li class='page-item'><a class='page-link' href='"+url+"&currentShowPageNo="+totalPage+"'>[마지막]</a></li>";

	        // === 쿠폰 리스트(페이징) 조회 ===
	        List<CouponDTO> couponList = cpDao.selectCouponPaging(paraMap);

	        request.setAttribute("couponList", couponList);
	        request.setAttribute("pageBar", pageBar);
	        request.setAttribute("sizePerPage", sizePerPage);
	        request.setAttribute("currentShowPageNo", currentShowPageNo);


	        super.setRedirect(false);
	        super.setViewPage("/WEB-INF/admin/coupons/coupons.jsp");
			
//		}
//		else {
			// 관리자로 로그인 하지 않은 경우
//			String message = "관리자만 접근이 가능합니다";
//			String loc = "javascript:history.back()";
			
//			request.setAttribute("message", message);
//			request.setAttribute("loc", loc);
			
//			super.setRedirect(false);
//			super.setViewPage("/WEB-INF/msg.jsp");
			
//		}		
		
		
	}

}
