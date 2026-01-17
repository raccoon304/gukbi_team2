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

public class ReviewWrite extends AbstractController {

    private ReviewDAO rdao = new ReviewDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession();
        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

        String method = request.getMethod();

        //  productCode 정리
        String productCode = request.getParameter("productCode");
        if (productCode == null) productCode = "ALL";
        productCode = productCode.replace('\u00A0', ' ').trim();
        if (productCode.isEmpty()) productCode = "ALL";
        if ("ALL".equalsIgnoreCase(productCode)) productCode = "ALL";

        // GET : 작성 페이지
        if ("GET".equalsIgnoreCase(method)) {

            if (loginUser == null) {
	            	request.setAttribute("message", "로그인이 필요합니다.");
	            	request.setAttribute("loc", "javascript:history.back()");
	            	super.setRedirect(false);
	            	super.setViewPage("/WEB-INF/admin/admin_msg.jsp");
	            	return;
            }

            List<Map<String, Object>> writableList =
                    rdao.getWritableOrderDetailList(loginUser.getMemberid(), productCode);

            request.setAttribute("productCode", productCode);
            request.setAttribute("writableList", writableList);

            super.setRedirect(false);
            super.setViewPage("/WEB-INF/review/reviewWrite.jsp");
            return;
        }

        // POST : 등록
        if (loginUser == null) {
            request.setAttribute("message", "로그인 후 이용 가능합니다.");
            request.setAttribute("loc", request.getContextPath() + "/login.hp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/admin/admin_msg.jsp");
            return;
        }

        // 주문상세 선택
        int orderDetailId;
        try {
            orderDetailId = Integer.parseInt(request.getParameter("orderDetailId"));
        } catch (Exception e) {
            failToWritePage(request, loginUser, productCode, "구매 옵션을 선택하세요.");
            return;
        }

        // 작성 가능 체크
        boolean canWrite = rdao.canWriteReview(loginUser.getMemberid(), orderDetailId);
        if (!canWrite) {
            failToWritePage(request, loginUser, productCode,
                    "리뷰 작성이 불가능합니다. (배송 완료된 주문이 없거나 이미 작성된 리뷰가 있습니다.)");
            return;
        }

        // optionId 조회
        int optionId = rdao.getOptionIdByOrderDetailId(loginUser.getMemberid(), orderDetailId);
        if (optionId <= 0) {
            failToWritePage(request, loginUser, productCode, "리뷰 작성 정보 확인에 실패했습니다.");
            return;
        }

        // 제목
        String title = request.getParameter("reviewTitle");
        if (title == null) title = "";
        title = title.trim();

        if (title.isBlank()) {
            failToWritePage(request, loginUser, productCode, "리뷰 제목을 입력하세요.");
            return;
        }
        if (title.length() > 100) {
            failToWritePage(request, loginUser, productCode, "글자수를 초과하여 작성 할 수 없습니다. (제목 최대 100자)");
            return;
        }

        // 내용
        String content = request.getParameter("reviewContent");
        if (content == null) content = "";
        content = content.trim();

        if (content.isBlank()) {
            failToWritePage(request, loginUser, productCode, "리뷰 내용을 입력하세요.");
            return;
        }
        if (content.length() > 1000) {
            failToWritePage(request, loginUser, productCode, "글자수를 초과하여 작성 할 수 없습니다. (내용 최대 1000자)");
            return;
        }

        // 별점
        double rating;
        try {
            rating = Double.parseDouble(request.getParameter("rating"));
        } catch (Exception e) {
            rating = 0;
        }

        if (!(rating >= 0.5 && rating <= 5.0 && (rating * 2 == Math.floor(rating * 2)))) {
            failToWritePage(request, loginUser, productCode, "별점은 0.5~5.0 사이로 선택하세요.");
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
            part.write(new File(dir, saveName).getAbsolutePath());

            String webPath = "/image/review/" + saveName;

            Map<String, Object> imgMap = new HashMap<>();
            imgMap.put("imagePath", webPath);
            imgMap.put("sortNo", Integer.valueOf(sortNo));
            images.add(imgMap);

            sortNo++;
        }

        //  DB 저장
        try {
            rdao.insertReviewWithImages(
                    loginUser.getMemberid(),
                    optionId,
                    orderDetailId,
                    title,
                    content,
                    rating,
                    images
            );
        } catch (Exception e) {

            // 실패하면 업로드 파일 삭제
            for (Map<String, Object> img : images) {
                try {
                    String webPath = (String) img.get("imagePath");
                    if (webPath == null) continue;
                    String fileName = webPath.substring(webPath.lastIndexOf("/") + 1);
                    File f = new File(dir, fileName);
                    if (f.exists()) f.delete();
                } catch (Exception ignore) {}
            }

            String emsg = String.valueOf(e.getMessage());

            // ORA-12899(길이 초과)면 글자수 초과로 안내 + 작성페이지 유지
            if (emsg != null && emsg.contains("ORA-12899")) {
                failToWritePage(request, loginUser, productCode, "글자수를 초과하여 작성 할 수 없습니다.");
            } else {
                failToWritePage(request, loginUser, productCode, "리뷰 등록에 실패했습니다. (이미 작성된 리뷰/DB 오류)");
            }
            return;
        }

        // 성공: 리스트로 이동
        String loc = request.getContextPath() + "/review/reviewList.hp?productCode=" + productCode;

        request.setAttribute("message", "리뷰가 등록되었습니다.");
        request.setAttribute("loc", loc);
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/admin/admin_msg.jsp");
    }

    // 실패 : write.jsp로 forward + 입력값 유지 + writableList 재조회
    private void failToWritePage(HttpServletRequest request, MemberDTO loginUser, String productCode, String msg) throws Exception {

        request.setAttribute("errMsg", msg);

        request.setAttribute("formOrderDetailId", request.getParameter("orderDetailId"));
        request.setAttribute("formTitle", request.getParameter("reviewTitle"));
        request.setAttribute("formContent", request.getParameter("reviewContent"));
        request.setAttribute("formRating", request.getParameter("rating"));

        request.setAttribute("productCode", productCode);

        List<Map<String, Object>> writableList =
                rdao.getWritableOrderDetailList(loginUser.getMemberid(), productCode);
        request.setAttribute("writableList", writableList);

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/review/reviewWrite.jsp");
    }
}
