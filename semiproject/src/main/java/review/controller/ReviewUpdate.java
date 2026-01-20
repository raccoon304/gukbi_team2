package review.controller;

import java.io.File;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import member.domain.MemberDTO;
import review.model.ReviewDAO;
import review.model.ReviewDAO_imple;

public class ReviewUpdate extends AbstractController {

    private ReviewDAO rdao = new ReviewDAO_imple();

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

            // 기존 이미지 목록 내려주기
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

        // ===== POST: 수정 저장 =====
        if (!"POST".equalsIgnoreCase(method)) {
            request.setAttribute("message", "잘못된 요청입니다.");
            request.setAttribute("loc", request.getContextPath() + "/review/reviewList.hp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/admin/admin_msg.jsp");
            return;
        }

        // 내 리뷰 맞는지 확인 + 기존 이미지 수 조회
        Map<String, String> origin = rdao.getReviewForEdit(reviewNumber, loginUser.getMemberid());
        if (origin == null || origin.isEmpty()) {
            request.setAttribute("message", "수정할 리뷰가 없거나 권한이 없습니다.");
            request.setAttribute("loc", request.getContextPath() + "/review/reviewList.hp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/admin/admin_msg.jsp");
            return;
        }

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

        // 서버 검증
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

        // 삭제할 이미지 ID들
        String[] delIds = request.getParameterValues("delImageId");
        List<Integer> deleteImageIds = new ArrayList<>();
        if (delIds != null) {
            for (String s : delIds) {
                try { deleteImageIds.add(Integer.parseInt(s)); } catch (Exception ignore) {}
            }
        }

        // 기존 이미지 개수
        List<Map<String, Object>> oldImgs = rdao.selectReviewImageInfoList(reviewNumber);
        int oldCnt = (oldImgs == null ? 0 : oldImgs.size());
        int delCnt = deleteImageIds.size();

        // 새 이미지 저장
        String uploadDir = request.getServletContext().getRealPath("/image/review");
        File dir = new File(uploadDir);
        if (!dir.exists()) dir.mkdirs();

        List<Map<String, Object>> newImages = new ArrayList<>();
        int addCount = 0;

        for (Part part : request.getParts()) {
            if (!"reviewImages".equals(part.getName())) continue;
            if (part.getSize() <= 0) continue;

            // 최종 5장 제한(기존-삭제 + 새로추가)
            if ((oldCnt - delCnt + addCount) >= 5) break;

            String ct = part.getContentType();
            if (ct == null || !ct.startsWith("image/")) continue;

            String submitted = part.getSubmittedFileName();
            if (submitted == null || submitted.isBlank()) continue;
            submitted = Paths.get(submitted).getFileName().toString();

            String ext = "";
            int dot = submitted.lastIndexOf(".");
            if (dot > -1) ext = submitted.substring(dot).toLowerCase();

            if (!(ext.equals(".jpg") || ext.equals(".jpeg") || ext.equals(".png") || ext.equals(".webp"))) continue;

            String saveName = "rv_" + UUID.randomUUID().toString().replace("-", "") + ext;
            part.write(new File(dir, saveName).getAbsolutePath());

            String webPath = "/image/review/" + saveName;

            Map<String, Object> imgMap = new HashMap<>();
            imgMap.put("imagePath", webPath);
            newImages.add(imgMap);

            addCount++;
        }

        // DAO 업데이트
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
                // 업로드 파일 삭제
                deleteUploadedFiles(dir, newImages);
                failToEditPage(request, loginUser, reviewNumber, productCode, sort, sizePerPage, currentShowPageNo,
                        "리뷰 수정에 실패했습니다.", title, content, rating);
                return;
            }

        } catch (Exception e) {
            deleteUploadedFiles(dir, newImages);

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

    private void deleteUploadedFiles(File dir, List<Map<String, Object>> images) {
        if (images == null) return;
        
        for (Map<String, Object> img : images) {
            try {
                String webPath = (String) img.get("imagePath");
                if (webPath == null) continue;
                String fileName = webPath.substring(webPath.lastIndexOf("/") + 1);
                File f = new File(dir, fileName);
                if (f.exists()) f.delete();
            } catch (Exception ignore) {}
        }
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
