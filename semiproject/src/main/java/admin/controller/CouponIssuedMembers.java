package admin.controller;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import common.controller.AbstractController;
import coupon.domain.CouponIssueDTO;
import coupon.model.CouponDAO;
import coupon.model.CouponDAO_imple;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class CouponIssuedMembers extends AbstractController {

	
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		CouponDAO cdao = new CouponDAO_imple();
		
		String sCouponCategoryNo = request.getParameter("couponCategoryNo");
		String filter = request.getParameter("filter");
		
		if(filter == null) {
			filter = "all";
		}
		
        if(sCouponCategoryNo == null || sCouponCategoryNo.trim().isEmpty()) {
            return;
        }

        int couponCategoryNo = Integer.parseInt(sCouponCategoryNo);

        int sizePerPage = 10;
        int currentShowPageNo = 1;

        try {
            if(request.getParameter("sizePerPage") != null)
                sizePerPage = Integer.parseInt(request.getParameter("sizePerPage"));

            if(request.getParameter("currentShowPageNo") != null)
                currentShowPageNo = Integer.parseInt(request.getParameter("currentShowPageNo"));
        } catch(Exception ignore) {}

        
        if(!("all".equals(filter) || "unused".equals(filter) || "used".equals(filter) || "expired".equals(filter))) {
            filter = "all";
        }
        
        int totalPage = cdao.getTotalPageIssuedMembers(couponCategoryNo, sizePerPage, filter);

        if(totalPage == 0) totalPage = 1;
        if(currentShowPageNo < 1) currentShowPageNo = 1;
        if(currentShowPageNo > totalPage) currentShowPageNo = totalPage;

        Map<String, String> paraMap = new HashMap<>();
        paraMap.put("couponCategoryNo", String.valueOf(couponCategoryNo));
        paraMap.put("sizePerPage", String.valueOf(sizePerPage));
        paraMap.put("currentShowPageNo", String.valueOf(currentShowPageNo));
        paraMap.put("filter", filter);
        
        List<CouponIssueDTO> issuedList = cdao.selectIssuedMembersPaging(paraMap);

        String pageBar = makeIssuedPageBar(currentShowPageNo, totalPage);

        request.setAttribute("issuedList", issuedList);
        request.setAttribute("issuedPageBar", pageBar);
        request.setAttribute("issuedTotalPage", totalPage);

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/admin/coupons/issuedMembers_fragment.jsp");
		
	}

	
	private String makeIssuedPageBar(int currentShowPageNo, int totalPage) {

        StringBuilder sb = new StringBuilder();

        int blockSize = 5;
        int pageNo = ((currentShowPageNo - 1)/blockSize) * blockSize + 1;

        sb.append("<li class='page-item'>")
          .append("<a class='page-link issued-page' href='#' data-page='1'>처음</a>")
          .append("</li>"); 
        
        // prev
        if(pageNo > 1) {
            sb.append("<li class='page-item'>")
              .append("<a class='page-link issued-page' href='#' data-page='").append(pageNo-1).append("'>이전</a>")
              .append("</li>");
        }

        int loop = 1;
        while(loop <= blockSize && pageNo <= totalPage) {

            if(pageNo == currentShowPageNo) {
                sb.append("<li class='page-item active'>")
                  .append("<a class='page-link' href='#'>").append(pageNo).append("</a>")
                  .append("</li>");
            } else {
                sb.append("<li class='page-item'>")
                  .append("<a class='page-link issued-page' href='#' data-page='").append(pageNo).append("'>")
                  .append(pageNo).append("</a>")
                  .append("</li>");
            }

            pageNo++;
            loop++;
        }

        // next
        if(pageNo <= totalPage) {
            sb.append("<li class='page-item'>")
              .append("<a class='page-link issued-page' href='#' data-page='").append(pageNo).append("'>다음</a>")
              .append("</li>");
        }
        
        
        sb.append("<li class='page-item'>")
          .append("<a class='page-link issued-page' href='#' data-page='").append(totalPage).append("'>마지막</a>")
          .append("</li>");
        

        return sb.toString();
    }
	
	
}



