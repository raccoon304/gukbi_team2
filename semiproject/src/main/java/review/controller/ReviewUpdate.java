package review.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
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

    private static final int MAX_FILES = 5;
    private static final String STATIC_PREFIX = "/image/review_image/";

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession();
        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

        if (loginUser == null) {
            request.setAttribute("message", "로그인이 필요합니다.");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/admin/admin_msg.jsp");
            return;
        }

        String method = request.getMethod();

        
        String productCode = request.getParameter("productCode");
        if (productCode == null) productCode = "ALL";
        productCode = productCode.replace('\u00A0', ' ').trim();
        if (productCode.isEmpty()) productCode = "ALL";
        if ("ALL".equalsIgnoreCase(productCode)) productCode = "ALL";

        String sort = request.getParameter("sort");
        if (sort == null || sort.trim().isEmpty()) sort = "latest";
        else sort = sort.trim();

        String sizePerPage = request.getParameter("sizePerPage");
        if (sizePerPage == null || sizePerPage.trim().isEmpty()) sizePerPage = "10";
        else sizePerPage = sizePerPage.trim();

        String currentShowPageNo = request.getParameter("currentShowPageNo");
        if (currentShowPageNo == null || currentShowPageNo.trim().isEmpty()) currentShowPageNo = "1";
        else currentShowPageNo = currentShowPageNo.trim();

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

            List<Map<String, Object>> imgList = rdao.selectReviewImageInfoList(reviewNumber);

            request.setAttribute("review", review);
            request.setAttribute("reviewNumber", reviewNumber);
            request.setAttribute("imgList", imgList);

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

        // 내 리뷰 맞는지 확인
        Map<String, String> origin = rdao.getReviewForEdit(reviewNumber, loginUser.getMemberid());
        if (origin == null || origin.isEmpty()) {
            request.setAttribute("message", "수정할 리뷰가 없거나 권한이 없습니다.");
            request.setAttribute("loc", request.getContextPath() + "/review/reviewList.hp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/admin/admin_msg.jsp");
            return;
        }

        // ===== 입력값 =====
        String title = request.getParameter("reviewTitle");
        if (title == null) title = "";
        title = title.trim();

        String content = request.getParameter("reviewContent");
        if (content == null) content = "";
        content = content.trim();

        double rating;
        try {
            rating = Double.parseDouble(request.getParameter("rating"));
        } catch (Exception e) {
            rating = 0;
        }

        // ===== 서버 검증 =====
        if (title.isBlank()) {
            failToEditPage(request, loginUser, reviewNumber, productCode, sort, sizePerPage, currentShowPageNo,
                    "리뷰 제목을 입력하세요.", title, content, rating);
            return;
        }
        if (title.length() > 100) {
            failToEditPage(request, loginUser, reviewNumber, productCode, sort, sizePerPage, currentShowPageNo,
                    "글자수를 초과하여 작성 할 수 없습니다. (제목 최대 100자)", title, content, rating);
            return;
        }
        if (content.isBlank()) {
            failToEditPage(request, loginUser, reviewNumber, productCode, sort, sizePerPage, currentShowPageNo,
                    "리뷰 내용을 입력하세요.", title, content, rating);
            return;
        }
        if (content.length() > 1000) {
            failToEditPage(request, loginUser, reviewNumber, productCode, sort, sizePerPage, currentShowPageNo,
                    "글자수를 초과하여 작성 할 수 없습니다. (내용 최대 1000자)", title, content, rating);
            return;
        }
        if (!(rating >= 0.5 && rating <= 5.0 && (rating * 2 == Math.floor(rating * 2)))) {
            failToEditPage(request, loginUser, reviewNumber, productCode, sort, sizePerPage, currentShowPageNo,
                    "별점은 0.5~5.0 사이로 선택하세요.", title, content, rating);
            return;
        }

        // ===== 삭제할 이미지 IDs =====
        String[] delIds = request.getParameterValues("delImageId");
        List<Integer> deleteImageIds = new ArrayList<>();
        if (delIds != null) {
            for (String s : delIds) {
                try { deleteImageIds.add(Integer.parseInt(s)); } catch (Exception ignore) {}
            }
        }

        // ===== 기존 이미지 수 =====
        List<Map<String, Object>> oldImgs = rdao.selectReviewImageInfoList(reviewNumber);
        int oldCnt = (oldImgs == null ? 0 : oldImgs.size());
        int delCnt = deleteImageIds.size(); 

        // ===== 새로 추가할 이미지: imagePath[] 로 받기 =====
        String[] addPaths = request.getParameterValues("imagePath"); // JS가 hidden으로 보내는 값
        List<Map<String, Object>> newImages = new ArrayList<>();

        // 서버에 실제 파일 존재 체크용 realPath
        String staticRealDir = request.getServletContext().getRealPath(STATIC_PREFIX);
        File staticDir = new File(staticRealDir);

        int addCount = 0;
        if (addPaths != null) {
            for (String p : addPaths) {

                if (p == null) continue;
                p = p.trim();
                if (p.isEmpty()) continue;

                // 정적 폴더만 허용
                if (!p.startsWith(STATIC_PREFIX)) continue;

                // 최종 5장 제한: (기존 - 삭제 + 추가)
                if ((oldCnt - delCnt + addCount) >= MAX_FILES) break;

                // 파일명 추출 + 서버에 진짜 존재하는지 체크
                String fileName = p.substring(p.lastIndexOf("/") + 1);
                if (fileName.isBlank()) continue;

                // 디렉토리 탈출 방지(기본 방어)
                if (fileName.contains("..") || fileName.contains("/") || fileName.contains("\\")) continue;

                // 확장자 제한
                String lower = fileName.toLowerCase();
                if (!(lower.endsWith(".jpg") || lower.endsWith(".jpeg") || lower.endsWith(".png") || lower.endsWith(".webp"))) continue;

                // 서버에 파일이 실제 있어야 다른 PC에서도 보임
                File f = new File(staticDir, fileName);
                if (!f.exists() || !f.isFile()) continue;

                Map<String, Object> imgMap = new HashMap<>();
                imgMap.put("imagePath", p);
                newImages.add(imgMap);

                addCount++;
            }
        }

        // ===== DAO 업데이트 =====
        try {
            boolean ok = rdao.updateReviewWithImages(
                    reviewNumber,
                    loginUser.getMemberid(),
                    title,
                    content,
                    rating,
                    deleteImageIds,
                    newImages
            );

            if (!ok) {
                failToEditPage(request, loginUser, reviewNumber, productCode, sort, sizePerPage, currentShowPageNo,
                        "리뷰 수정에 실패했습니다.", title, content, rating);
                return;
            }

        } catch (Exception e) {

            String emsg = String.valueOf(e.getMessage());
            if (emsg != null && emsg.contains("ORA-12899")) {
                failToEditPage(request, loginUser, reviewNumber, productCode, sort, sizePerPage, currentShowPageNo,
                        "글자수를 초과하여 작성 할 수 없습니다.", title, content, rating);
            } else {
                failToEditPage(request, loginUser, reviewNumber, productCode, sort, sizePerPage, currentShowPageNo,
                        "리뷰 수정에 실패했습니다.", title, content, rating);
            }
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

    private void failToEditPage(HttpServletRequest request, MemberDTO loginUser,
                                int reviewNumber, String productCode, String sort,
                                String sizePerPage, String currentShowPageNo,
                                String errMsg, String title, String content, double rating) throws Exception {

        Map<String, String> origin = rdao.getReviewForEdit(reviewNumber, loginUser.getMemberid());
        Map<String, String> reviewForView = new HashMap<>(origin);
        reviewForView.put("reviewTitle", title);
        reviewForView.put("reviewContent", content);
        reviewForView.put("rating", String.valueOf(rating));

        List<Map<String, Object>> imgList = rdao.selectReviewImageInfoList(reviewNumber);

        request.setAttribute("errMsg", errMsg);
        request.setAttribute("review", reviewForView);
        request.setAttribute("reviewNumber", reviewNumber);
        request.setAttribute("imgList", imgList);

        request.setAttribute("productCode", productCode);
        request.setAttribute("sort", sort);
        request.setAttribute("sizePerPage", sizePerPage);
        request.setAttribute("currentShowPageNo", currentShowPageNo);

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/review/reviewEdit.jsp");
    }
}
