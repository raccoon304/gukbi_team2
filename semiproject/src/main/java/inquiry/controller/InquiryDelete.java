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

	private InquiryDAO dao = new InquiryDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

    	JSONObject json = new JSONObject();

        try {
            // POST만 허용
            if (!"POST".equalsIgnoreCase(request.getMethod())) {
                json.put("success", false);
                json.put("message", "잘못된 요청입니다.");
                request.setAttribute("json", json.toString());
                super.setRedirect(false);
                super.setViewPage("/WEB-INF/admin/admin_jsonview.jsp");
                return;
            }

            // 로그인 체크
            HttpSession session = request.getSession();
		    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

            if (loginUser == null) {
                json.put("success", false);
                json.put("needLogin", true);
                json.put("message", "로그인이 필요합니다.");
                request.setAttribute("json", json.toString());
                super.setRedirect(false);
                super.setViewPage("/WEB-INF/admin/admin_jsonview.jsp");
                return;
            }

            boolean isAdmin = "admin".equalsIgnoreCase(loginUser.getMemberid());

            // inquiryNumber
            String inquiryNumberStr = request.getParameter("inquiryNumber");
            int inquiryNumber;

            try {
                inquiryNumber = Integer.parseInt(inquiryNumberStr);
                
                if (inquiryNumber <= 0) {
                		throw new NumberFormatException();
                }
                
            } catch (NumberFormatException e) {
                json.put("success", false);
                json.put("message", "문의번호가 올바르지 않습니다.");
                request.setAttribute("json", json.toString());
                super.setRedirect(false);
                super.setViewPage("/WEB-INF/admin/admin_jsonview.jsp");
                return;
            }

            // 원글 조회
            InquiryDTO origin = dao.selectInquiryDetail(inquiryNumber);

            if (origin == null) {
                json.put("success", false);
                json.put("message", "이미 삭제되었거나 존재하지 않는 문의입니다.");
                request.setAttribute("json", json.toString());
                super.setRedirect(false);
                super.setViewPage("/WEB-INF/admin/admin_jsonview.jsp");
                return;
            }

            // 관리자, 작성자만 삭제 가능
            String ownerMemberId = origin.getMemberid();
            if (!isAdmin && !loginUser.getMemberid().equals(ownerMemberId)) {
                json.put("success", false);
                json.put("message", "본인이 작성한 문의만 삭제할 수 있습니다.");
                request.setAttribute("json", json.toString());
                super.setRedirect(false);
                super.setViewPage("/WEB-INF/admin/admin_jsonview.jsp");
                return;
            }

            // 소프트 삭제
            String deletedBy = loginUser.getMemberid();

            int n = dao.softDeleteInquiry(inquiryNumber,deletedBy,isAdmin,loginUser.getMemberid());

            if (n == 1) {
                json.put("success", true);
                json.put("message", "문의가 삭제되었습니다.");
            } else {
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
