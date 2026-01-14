package review.controller;

import java.util.Map;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;
import review.model.ReviewDAO;
import review.model.ReviewDAO_imple;

public class ReviewUpdate extends AbstractController {

    private ReviewDAO rdao = new ReviewDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession();
        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

        // 로그인 체크
        if (loginUser == null) {
            request.setAttribute("message", "로그인 후 이용 가능합니다.");
            request.setAttribute("loc", request.getContextPath() + "/login.hp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/admin/admin_msg.jsp");
            return;
        }

        
        int reviewNumber;
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
        else productCode = productCode.trim();

        String sort = request.getParameter("sort");
        if (sort == null || sort.trim().isEmpty()) sort = "latest";
        else sort = sort.trim();

        String sizePerPage = request.getParameter("sizePerPage");
        if (sizePerPage == null || sizePerPage.trim().isEmpty()) sizePerPage = "10";
        else sizePerPage = sizePerPage.trim();

        String currentShowPageNo = request.getParameter("currentShowPageNo");
        if (currentShowPageNo == null || currentShowPageNo.trim().isEmpty()) currentShowPageNo = "1";
        else currentShowPageNo = currentShowPageNo.trim();

        String method = request.getMethod();

        // ===== GET: 수정폼 =====
        if ("GET".equalsIgnoreCase(method)) {

            Map<String, String> review = rdao.getReviewForEdit(reviewNumber, loginUser.getMemberid());

            if (review == null || review.isEmpty()) {
                request.setAttribute("message", "수정할 리뷰가 없거나 권한이 없습니다.");
                request.setAttribute("loc", request.getContextPath() + "/review/reviewList.hp");
                super.setRedirect(false);
                super.setViewPage("/WEB-INF/admin/admin_msg.jsp");
                return;
            }

            request.setAttribute("review", review);
            request.setAttribute("productCode", productCode);
            request.setAttribute("sort", sort);
            request.setAttribute("sizePerPage", sizePerPage);
            request.setAttribute("currentShowPageNo", currentShowPageNo);

            super.setRedirect(false);
            super.setViewPage("/WEB-INF/review/reviewEdit.jsp");
            return;
        }

        // ===== POST만 허용 =====
        if (!"POST".equalsIgnoreCase(method)) {
            request.setAttribute("message", "잘못된 요청입니다.");
            request.setAttribute("loc", request.getContextPath() + "/review/reviewList.hp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/admin/admin_msg.jsp");
            return;
        }

        // ===== POST: 수정 저장 =====
        String title = request.getParameter("reviewTitle");
        if (title == null) title = "";
        title = title.trim();

        if (title.isBlank() || title.length() > 100) {
            request.setAttribute("message", "리뷰 제목은 1~100자 사이로 입력하세요.");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/admin/admin_msg.jsp");
            return;
        }

        String content = request.getParameter("reviewContent");
        if (content == null) content = "";
        content = content.trim();

        if (content.isBlank() || content.length() > 1000) {
            request.setAttribute("message", "리뷰 내용은 1~1000자 사이로 입력하세요.");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/admin/admin_msg.jsp");
            return;
        }

        double rating;
        try {
            rating = Double.parseDouble(request.getParameter("rating"));
        } catch (Exception e) {
            rating = 0;
        }

        if (rating < 0.5 || rating > 5.0 || (rating * 2 != Math.floor(rating * 2))) {
            request.setAttribute("message", "별점은 0.5~5.0 사이로 선택하세요.");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/admin/admin_msg.jsp");
            return;
        }

        boolean ok = rdao.updateReview(reviewNumber, loginUser.getMemberid(), title, content, rating);

        if (!ok) {
            request.setAttribute("message", "리뷰 수정에 실패했습니다.");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/admin/admin_msg.jsp");
            return;
        }

        String loc = request.getContextPath() + "/review/reviewList.hp"
                   + "?productCode=" + productCode
                   + "&sort=" + sort
                   + "&sizePerPage=" + sizePerPage
                   + "&currentShowPageNo=" + currentShowPageNo;
        
        request.setAttribute("message", "리뷰가 수정되었습니다.");
        request.setAttribute("loc", loc);
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/admin/admin_msg.jsp");
    }
}
