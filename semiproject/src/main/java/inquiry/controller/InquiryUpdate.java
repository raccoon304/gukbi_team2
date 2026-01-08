package inquiry.controller;

import java.sql.SQLException;

import org.json.JSONObject;

import common.controller.AbstractController;
import inquiry.domain.InquiryDTO;
import inquiry.model.InquiryDAO;
import inquiry.model.InquiryDAO_imple;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;

public class InquiryUpdate extends AbstractController {

	private InquiryDAO idao = new InquiryDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        String method = request.getMethod();

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
            // ===== 로그인 확인 =====
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

            // ===== inquiryNumber 검증 =====
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

            // ===== 입력값 =====
            String inquiryType = request.getParameter("inquiryType");
            String title = request.getParameter("title");
            String inquiryContent = request.getParameter("inquiryContent");

            if (inquiryType == null || inquiryType.trim().isEmpty()
             || title == null || title.trim().isEmpty()
             || inquiryContent == null || inquiryContent.trim().isEmpty()) {

                json.put("success", false);
                json.put("message", "모든 항목을 입력해주세요.");

                request.setAttribute("json", json.toString());
                super.setRedirect(false);
                super.setViewPage("/WEB-INF/admin/admin_jsonview.jsp");
                return;
            }

            // ===== 권한(작성자만 수정) =====
            InquiryDTO origin = idao.selectInquiryDetail(inquiryNumber);

            if (origin == null) {
                json.put("success", false);
                json.put("message", "해당 문의가 존재하지 않습니다.");

                request.setAttribute("json", json.toString());
                super.setRedirect(false);
                super.setViewPage("/WEB-INF/admin/admin_jsonview.jsp");
                return;
            }

            if (!loginUser.getMemberid().equals(origin.getMemberid())) {
                json.put("success", false);
                json.put("message", "본인이 작성한 문의만 수정할 수 있습니다.");

                request.setAttribute("json", json.toString());
                super.setRedirect(false);
                super.setViewPage("/WEB-INF/admin/admin_jsonview.jsp");
                return;
            }
            if (origin.getReplyStatus() == 2) {
            		json.put("success", false);
                json.put("message", "관리자 답변이 달린 문의는 수정이 불가능합니다.");

                request.setAttribute("json", json.toString());
                super.setRedirect(false);
                super.setViewPage("/WEB-INF/admin/admin_jsonview.jsp");
                return;
            	
            }

            // ===== 수정 =====
            InquiryDTO dto = new InquiryDTO();
            dto.setInquiryNumber(inquiryNumber);
            dto.setInquiryType(inquiryType.trim());
            dto.setTitle(title.trim());
            dto.setInquiryContent(inquiryContent.trim());

            int n = idao.updateInquiry(dto);

            if (n == 1) {
                json.put("success", true);
                json.put("message", "문의가 수정되었습니다.");
            } else {
                json.put("success", false);
                json.put("message", "문의 수정에 실패했습니다.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            json.put("success", false);
            json.put("message", "문의 수정 중 오류가 발생했습니다.");
        }

        request.setAttribute("json", json.toString());
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/admin/admin_jsonview.jsp");
    }
}
