package review.controller;

import java.io.File;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
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

public class ReviewWrite extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

    		ReviewDAO rdao = new ReviewDAO_imple();
    	
        HttpSession session = request.getSession();
        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

        String method = request.getMethod();

        // GET : 리뷰 작성 페이지
        if ("GET".equalsIgnoreCase(method)) {

            // 로그인 체크
            if (loginUser == null) {
                String productCode = request.getParameter("productCode");
                if (productCode == null || productCode.trim().isEmpty()) productCode = "ALL";

                String returnUrl = request.getContextPath() + "/review/reviewWrite.hp?productCode="
                        + URLEncoder.encode(productCode, StandardCharsets.UTF_8);

                request.setAttribute("message", "리뷰 작성은 로그인 후 가능합니다.");
                request.setAttribute("loc",
                        request.getContextPath() + "/login.hp?returnUrl="
                                + URLEncoder.encode(returnUrl, StandardCharsets.UTF_8));

                super.setRedirect(false);
                super.setViewPage("/WEB-INF/admin/admin_msg.jsp");
                return;
            }

            String productCode = request.getParameter("productCode");
            if (productCode == null || productCode.trim().isEmpty()) productCode = "ALL";
            productCode = productCode.trim();

            List<Map<String, Object>> writableList =
                    rdao.getWritableOrderDetailList(loginUser.getMemberid(), "ALL");

            request.setAttribute("productCode", productCode);
            request.setAttribute("writableList", writableList);

            super.setRedirect(false);
            super.setViewPage("/WEB-INF/review/reviewWrite.jsp");
            return;
        }


        // POST : 리뷰 등록
        // 로그인 체크
        if (loginUser == null) {
            request.setAttribute("message", "로그인 후 이용 가능합니다.");
            request.setAttribute("loc", request.getContextPath() + "/login.hp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/admin/admin_msg.jsp");
            return;
        }

        // productCode - 상품상세에서 들어오면 그 상품으로 감
        String productCode = request.getParameter("productCode");
        if (productCode == null || productCode.trim().isEmpty()) productCode = "ALL";
        productCode = productCode.trim();

        // 주문상세 선택값
        int orderDetailId;
        try {
            orderDetailId = Integer.parseInt(request.getParameter("orderDetailId"));
        } catch (Exception e) {
            request.setAttribute("message", "구매한 옵션을 선택해야 리뷰 작성이 가능합니다.");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/admin/admin_msg.jsp");
            return;
        }

        // 작성 가능 체크
        boolean canWrite = rdao.canWriteReview(loginUser.getMemberid(), orderDetailId);
        if (!canWrite) {
            request.setAttribute("message", "리뷰 작성이 불가능합니다 (구매내역이 없거나 이미 작성된 리뷰가 있습니다.)");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/admin/admin_msg.jsp");
            return;
        }

        // optionId 조회
        int optionId = rdao.getOptionIdByOrderDetailId(loginUser.getMemberid(), orderDetailId);
        if (optionId <= 0) {
            request.setAttribute("message", "리뷰 작성 정보 확인에 실패했습니다.");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/admin/admin_msg.jsp");
            return;
        }

        // 제목
        String title = request.getParameter("reviewTitle"); // JSP에서 name="reviewTitle" 로 맞춰줘
        if (title == null) title = "";
        title = title.trim();

        if (title.isBlank() || title.length() > 100) {
            request.setAttribute("message", "리뷰 제목은 1~100자 사이로 입력하세요.");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/admin/admin_msg.jsp");
            return;
        }

        // 내용
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

        // 별점
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

        // 이미지 저장
        String uploadDir = request.getServletContext().getRealPath("/image/review");
        File dir = new File(uploadDir);
        if (!dir.exists()) dir.mkdirs();

        List<Map<String, Object>> images = new ArrayList<>();
        int sortNo = 1;

        for (Part part : request.getParts()) {
            if (!"reviewImages".equals(part.getName())) continue;
            if (part.getSize() <= 0) continue;
            if (sortNo > 5) break;

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

            File saveFile = new File(dir, saveName);
            part.write(saveFile.getAbsolutePath());

            String webPath = "/image/review/" + saveName;

            Map<String, Object> imgMap = new HashMap<>();
            imgMap.put("imagePath", webPath);
            imgMap.put("sortNo", Integer.valueOf(sortNo));
            images.add(imgMap);

            sortNo++;
        }

        int reviewNumber;

        try {
            reviewNumber = rdao.insertReviewWithImages(
                    loginUser.getMemberid(),
                    optionId,
                    orderDetailId,
                    title,
                    content,
                    rating,
                    images
            );
        } catch (Exception e) {

            // 실패하면 업로드한 파일 삭제
            if (!images.isEmpty()) {
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

            request.setAttribute("message", "리뷰 등록에 실패했습니다. 이미 작성한 리뷰는 추가 작성이 불가합니다.");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/admin/admin_msg.jsp");
            return;
        }

        // 성공 메시지 + 리뷰리스트 이동(선택상품 유지)
        String loc = request.getContextPath() + "/review/reviewList.hp?productCode="
                + URLEncoder.encode(productCode, StandardCharsets.UTF_8);

        request.setAttribute("message", "리뷰가 등록되었습니다.");
        request.setAttribute("loc", loc);
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/admin/admin_msg.jsp");
        return;
    }
}
