package review.controller;

import java.io.File;
import java.nio.file.Paths;
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
        if (loginUser == null) {
            request.setAttribute("message", "로그인 후 이용 가능합니다.");
            request.setAttribute("loc", request.getContextPath() + "/login.hp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        String method = request.getMethod();

        if ("GET".equalsIgnoreCase(method)) {
            // 폼 페이지로
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/review/reviewWrite.jsp");
            return;
        }

        // POST
        int orderDetailId, optionId;
        try {
            orderDetailId = Integer.parseInt(request.getParameter("orderDetailId"));
            optionId = Integer.parseInt(request.getParameter("optionId"));
        } catch(Exception e) {
            request.setAttribute("message", "잘못된 요청입니다.");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        // 내 구매(PAID)인지 + 이미 리뷰 있는지 확인
        boolean canWrite = rdao.canWriteReview(loginUser.getMemberid(), orderDetailId);
        if(!canWrite) {
            request.setAttribute("message", "리뷰 작성이 불가능합니다.\n(구매내역이 아니거나 이미 리뷰가 작성되었습니다)");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        String content = request.getParameter("reviewContent");
        if(content == null) content = "";
        content = content.trim();

        if(content.isBlank() || content.length() > 1000) {
            request.setAttribute("message", "리뷰 내용은 1~1000자 사이로 입력하세요.");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        double rating;
        try {
            rating = Double.parseDouble(request.getParameter("rating"));
        } catch(Exception e) {
            rating = 0;
        }

        // 별점 범위 체크
        if(rating < 0.5 || rating > 5.0 || (rating * 2 != Math.floor(rating * 2))) {
            request.setAttribute("message", "별점은 0.5~5.0 사이의 0.5 단위로 입력하세요.");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        // 리뷰 insert -> reviewNumber 확보
        int reviewNumber;
        try {
            reviewNumber = rdao.insertReview(optionId, orderDetailId, content, rating);
        } catch(Exception e) {
            
            request.setAttribute("message", "리뷰 등록에 실패했습니다.\n이미 작성한 리뷰는 추가 작성이 불가합니다.");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        // 이미지 저장 + DB insert
        String uploadDir = request.getServletContext().getRealPath("/image/review");
        File dir = new File(uploadDir);
        if(!dir.exists()) dir.mkdirs();

        int sortNo = 1;
        for(Part part : request.getParts()) {

            if(!"reviewImages".equals(part.getName())) continue;
            if(part.getSize() <= 0) continue;
            if(sortNo > 5) break;

            String ct = part.getContentType();
            if(ct == null || !ct.startsWith("image/")) continue;

            String submitted = Paths.get(part.getSubmittedFileName()).getFileName().toString();
            String ext = "";
            int dot = submitted.lastIndexOf(".");
            if(dot > -1) ext = submitted.substring(dot).toLowerCase();

            if(!(ext.equals(".jpg") || ext.equals(".jpeg") || ext.equals(".png") || ext.equals(".webp"))) {
                continue;
            }

            String saveName = "rv_" + reviewNumber + "_" + UUID.randomUUID().toString().replace("-", "") + ext;
            File saveFile = new File(dir, saveName);
            part.write(saveFile.getAbsolutePath());

            String webPath = "/image/review/" + saveName;

            try {
                rdao.insertReviewImage(reviewNumber, webPath, sortNo);
                sortNo++;
            } catch(Exception e) {
            	    saveFile.delete(); // DB 실패했으면 파일도 지우기
                e.printStackTrace();
            }
        }

        // 완료 이동
        super.setRedirect(true);
        super.setViewPage(request.getContextPath() + "/review/reviewList.hp?optionId=" + optionId);
		
	}

}
