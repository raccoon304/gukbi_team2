package review.controller;

import java.util.List;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;
import review.domain.ReviewDTO;
import review.model.ReviewDAO;
import review.model.ReviewDAO_imple;

public class ReviewDetail extends AbstractController {

    private ReviewDAO rdao = new ReviewDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession();
        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

      
        int reviewNumber = 0;
        try {
            reviewNumber = Integer.parseInt(request.getParameter("reviewNumber"));
        } catch (Exception e) {
            request.setAttribute("message", "잘못된 요청입니다.");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/admin/admin_msg.jsp");
            return;
        }

        
        String productCode = request.getParameter("productCode");
        if (productCode == null || productCode.trim().isEmpty()) productCode = "ALL";
        productCode = productCode.trim();

        String sort = request.getParameter("sort");
        if (sort == null || sort.trim().isEmpty()) sort = "latest";
        sort = sort.trim();

        String sizePerPage = request.getParameter("sizePerPage");
        if (sizePerPage == null || sizePerPage.trim().isEmpty()) sizePerPage = "10";
        sizePerPage = sizePerPage.trim();

        String currentShowPageNo = request.getParameter("currentShowPageNo");
        if (currentShowPageNo == null || currentShowPageNo.trim().isEmpty()) currentShowPageNo = "1";
        currentShowPageNo = currentShowPageNo.trim();

        // === 상세 데이터 조회 ===
        ReviewDTO dto = rdao.selectReviewDetail(reviewNumber);
        if (dto == null) {
            request.setAttribute("message", "존재하지 않는 리뷰입니다.");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/admin/admin_msg.jsp");
            return;
        }

        List<String> imgList = rdao.selectReviewImageList(reviewNumber);

       
        request.setAttribute("loginUser", loginUser); 
        request.setAttribute("productCode", productCode);
        request.setAttribute("sort", sort);
        request.setAttribute("sizePerPage", sizePerPage);
        request.setAttribute("currentShowPageNo", currentShowPageNo);

        request.setAttribute("dto", dto);
        request.setAttribute("imgList", imgList);

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/review/reviewDetail.jsp");
    }

}
