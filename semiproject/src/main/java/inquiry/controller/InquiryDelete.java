package inquiry.controller;

import org.json.JSONObject;

import common.controller.AbstractController;
import inquiry.domain.InquiryDTO;
import inquiry.model.InquiryDAO;
import inquiry.model.InquiryDAO_imple;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;

public class InquiryDelete extends AbstractController {

	private InquiryDAO idao = new InquiryDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        String method = request.getMethod();

        // POST만 허용
        if (!"POST".equalsIgnoreCase(method)) {
            JSONObject json = new JSONObject();
            json.put("success", false);
            json.put("message", "잘못된 요청입니다.");

            request.setAttribute("json", json.toString());
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/admin/admin_jsonview.jsp");
            return;
        }

        JSONObject json = new JSONObject();

        try {
            // ===== 로그인 확인 (loginUser) =====
            HttpSession session = request.getSession(false);
            MemberDTO loginUser = (session == null) ? null : (MemberDTO) session.getAttribute("loginUser");

            if (loginUser == null) {
                json.put("success", false);
                json.put("needLogin", true);
                json.put("message", "로그인이 필요합니다.");

                request.setAttribute("json", json.toString());
                super.setRedirect(false);
                super.setViewPage("/WEB-INF/admin/admin_jsonview.jsp");
                return;
            }

            boolean isAdmin = "admin".equals(loginUser.getMemberid());

            // ===== inquiryNumber 검증 (parseInt) =====
            String inquiryNumberStr = request.getParameter("inquiryNumber");
            int inquiryNumber = 0;

            try {
                inquiryNumber = Integer.parseInt(inquiryNumberStr);
                if (inquiryNumber <= 0) throw new NumberFormatException();
            } catch (NumberFormatException e) {
                json.put("success", false);
                json.put("message", "문의번호가 올바르지 않습니다.");

                request.setAttribute("json", json.toString());
                super.setRedirect(false);
                super.setViewPage("/WEB-INF/admin/admin_jsonview.jsp");
                return;
            }

            // ===== 작성자 확인용 조회 =====
            InquiryDTO inquiry = idao.selectInquiryDetail(inquiryNumber);

            if (inquiry == null) {
                json.put("success", false);
                json.put("message", "문의를 찾을 수 없습니다.");

                request.setAttribute("json", json.toString());
                super.setRedirect(false);
                super.setViewPage("/WEB-INF/admin/admin_jsonview.jsp");
                return;
            }

            boolean isOwner = loginUser.getMemberid().equals(inquiry.getMemberid());

            // 정책: 작성자 또는 관리자 삭제 가능 (InquiryDetail의 canDelete와 맞춤)
            if (!(isOwner || isAdmin)) {
                json.put("success", false);
                json.put("message", "삭제 권한이 없습니다.");

                request.setAttribute("json", json.toString());
                super.setRedirect(false);
                super.setViewPage("/WEB-INF/admin/admin_jsonview.jsp");
                return;
            }

            int n = idao.deleteInquiry(inquiryNumber);

            if (n == 1) {
                json.put("success", true);
                json.put("message", "문의가 삭제되었습니다.");
            } 
            else {
                json.put("success", false);
                json.put("message", "문의 삭제에 실패했습니다.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            json.put("success", false);
            json.put("message", "문의 삭제 중 오류가 발생했습니다.");
        }

        request.setAttribute("json", json.toString());
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/admin/admin_jsonview.jsp");
    }
}
