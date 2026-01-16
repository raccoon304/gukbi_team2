package review.controller;

import java.util.HashMap;
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

        String method = request.getMethod();

        // 파라미터(목록용)
        String productCode = normalize(nvl(request.getParameter("productCode"), "ALL"));
        if (productCode.isEmpty()) productCode = "ALL";
        if ("ALL".equalsIgnoreCase(productCode)) productCode = "ALL";

        String sort = normalize(nvl(request.getParameter("sort"), "latest"));
        if (sort.isEmpty()) sort = "latest";

        String sizePerPage = normalize(nvl(request.getParameter("sizePerPage"), "10"));
        if (sizePerPage.isEmpty()) sizePerPage = "10";

        String currentShowPageNo = normalize(nvl(request.getParameter("currentShowPageNo"), "1"));
        if (currentShowPageNo.isEmpty()) currentShowPageNo = "1";

        // reviewNumber
        int reviewNumber;
        try {
            reviewNumber = Integer.parseInt(normalize(nvl(request.getParameter("reviewNumber"), "")));
        } catch (Exception e) {
            request.setAttribute("message", "잘못된 요청입니다.");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/admin/admin_msg.jsp");
            return;
        }

        // GET: 수정폼
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
            request.setAttribute("reviewNumber", reviewNumber);
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

        // POST: 수정 저장
        // 내 리뷰 맞는지 확인 + 기존 데이터
        Map<String, String> origin = rdao.getReviewForEdit(reviewNumber, loginUser.getMemberid());
        if (origin == null || origin.isEmpty()) {
            request.setAttribute("message", "수정할 리뷰가 없거나 권한이 없습니다.");
            request.setAttribute("loc", request.getContextPath() + "/review/reviewList.hp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/admin/admin_msg.jsp");
            return;
        }

        String title = normalize(nvl(request.getParameter("reviewTitle"), ""));
        String content = normalize(nvl(request.getParameter("reviewContent"), ""));
        String ratingStr = normalize(nvl(request.getParameter("rating"), ""));

        // 별점
        Double ratingObj = null;
        try {
            if (!ratingStr.isEmpty()) ratingObj = Double.parseDouble(ratingStr);
        } catch (Exception ignore) {}
        double rating = (ratingObj == null ? 0 : ratingObj.doubleValue());

        // 실패 시 수정페이지로 forward(입력 유지)
        String errMsg = null;

        if (title.isBlank()) {
            errMsg = "리뷰 제목을 입력하세요.";
        } else if (title.length() > 100) {
            errMsg = "글자수를 초과하여 작성 할 수 없습니다. (제목 최대 100자)";
        } else if (content.isBlank()) {
            errMsg = "리뷰 내용을 입력하세요.";
        } else if (content.length() > 1000) {
            errMsg = "글자수를 초과하여 작성 할 수 없습니다. (내용 최대 1000자)";
        } else if (ratingObj == null) {
            errMsg = "별점을 선택하세요.";
        } else if (!(rating >= 0.5 && rating <= 5.0 && (rating * 2 == Math.floor(rating * 2)))) {
            errMsg = "별점은 0.5~5.0 사이로 선택하세요.";
        }

        if (errMsg != null) {
            forwardEditWithValues(request, reviewNumber, origin, title, content, rating, errMsg,
                                  productCode, sort, sizePerPage, currentShowPageNo);
            return;
        }

        // 수정 실행
        boolean ok = false;
        try {
            ok = rdao.updateReview(reviewNumber, loginUser.getMemberid(), title, content, rating);
        } catch (Exception e) {

            String msg = String.valueOf(e.getMessage());
            String dbMsg = (msg != null && msg.contains("ORA-12899"))
                         ? "글자수를 초과하여 작성 할 수 없습니다."
                         : "리뷰 수정에 실패했습니다.";

            forwardEditWithValues(request, reviewNumber, origin, title, content, rating, dbMsg,
                                  productCode, sort, sizePerPage, currentShowPageNo);
            return;
        }

        if (!ok) {
            forwardEditWithValues(request, reviewNumber, origin, title, content, rating, "리뷰 수정에 실패했습니다.",
                                  productCode, sort, sizePerPage, currentShowPageNo);
            return;
        }

        // 성공 -> 목록 이동
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

    // 수정페이지로 되돌리기(입력값 유지)
    private void forwardEditWithValues(HttpServletRequest request,
                                       int reviewNumber,
                                       Map<String, String> origin,
                                       String title,
                                       String content,
                                       double rating,
                                       String errMsg,
                                       String productCode,
                                       String sort,
                                       String sizePerPage,
                                       String currentShowPageNo) throws Exception {

        Map<String, String> reviewForView = new HashMap<>(origin);
        reviewForView.put("reviewTitle", title);
        reviewForView.put("reviewContent", content);
        
        reviewForView.put("rating", String.valueOf(rating));

        request.setAttribute("errMsg", errMsg);
        request.setAttribute("review", reviewForView);
        request.setAttribute("reviewNumber", reviewNumber);

        request.setAttribute("productCode", productCode);
        request.setAttribute("sort", sort);
        request.setAttribute("sizePerPage", sizePerPage);
        request.setAttribute("currentShowPageNo", currentShowPageNo);

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/review/reviewEdit.jsp");
    }

    private String nvl(String s, String dft) {
        return (s == null) ? dft : s;
    }

    // 공백(NBSP) 방어
    private String normalize(String s) {
        if (s == null) return "";
        return s.replace('\u00A0', ' ').trim();
    }
}
