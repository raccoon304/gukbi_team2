package review.controller;

import java.io.File;
import java.util.List;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;
import review.model.ReviewDAO;
import review.model.ReviewDAO_imple;

public class ReviewDelete extends AbstractController {

   
    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

    		ReviewDAO rdao = new ReviewDAO_imple();
    	
        HttpSession session = request.getSession();
        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

        // 로그인 체크
        if(loginUser == null) {
            request.setAttribute("message", "로그인 후 이용 가능합니다.");
            request.setAttribute("loc", request.getContextPath() + "/login.hp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/admin/admin_msg.jsp");
            return;
        }

        // POST만 허용
        if(!"POST".equalsIgnoreCase(request.getMethod())) {
            request.setAttribute("message", "잘못된 요청입니다.");
            request.setAttribute("loc", request.getContextPath() + "/review/reviewList.hp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/admin/admin_msg.jsp");
            return;
        }

        
        String productCode = request.getParameter("productCode");
        String sort = request.getParameter("sort");
        String sizePerPage = request.getParameter("sizePerPage");
        String currentShowPageNo = request.getParameter("currentShowPageNo");

        int reviewNumber = 0;
        try {
            reviewNumber = Integer.parseInt(request.getParameter("reviewNumber"));
        } catch(Exception e) {
            request.setAttribute("message", "리뷰 번호가 올바르지 않습니다.");
            request.setAttribute("loc", request.getContextPath() + "/review/reviewList.hp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/admin/admin_msg.jsp");
            return;
        }

        // === 삭제 전: 이미지 경로 목록 확보(실제파일 삭제용) ===
        List<String> imgList = rdao.selectReviewImageList(reviewNumber);

        int n = 0;
        try {
            n = rdao.deleteReview(loginUser.getMemberid(), reviewNumber);
        } catch(Exception e) {
            request.setAttribute("message", "리뷰 삭제 중 오류가 발생했습니다.");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/admin/admin_msg.jsp");
            return;
        }

        if(n != 1) {
            request.setAttribute("message", "삭제 권한이 없거나 이미 삭제된 리뷰입니다.");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/admin/admin_msg.jsp");
            return;
        }

        // === DB 삭제 성공 후: 서버에 저장된 이미지 파일도 삭제 ===
        // 이미지 저장 경로: /image/review/xxx.jpg
        // 실제 폴더: getRealPath("/image/review")
        String uploadDir = request.getServletContext().getRealPath("/image/review");

        if(imgList != null) {
            for(String webPath : imgList) {
                if(webPath == null) continue;
                try {
                    String fileName = webPath.substring(webPath.lastIndexOf("/") + 1);
                    File f = new File(uploadDir, fileName);
                    if(f.exists()) f.delete();
                } catch(Exception ignore) {}
            }
        }

        
        String loc = request.getContextPath() + "/review/reviewList.hp"
                + "?productCode=" + productCode
                + "&sort=" + sort
                + "&sizePerPage=" + sizePerPage
                + "&currentShowPageNo=" + currentShowPageNo;


        super.setRedirect(true);
        super.setViewPage(loc);
    }

   
}
