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

public class InquiryDetail extends AbstractController {

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
            // ===== 로그인/관리자 판별  =====
            HttpSession session = request.getSession(false);
            MemberDTO loginUser = (session == null) ? null : (MemberDTO) session.getAttribute("loginUser");

            boolean isLoggedIn = (loginUser != null);
            boolean isAdmin = isLoggedIn && "admin".equals(loginUser.getMemberid());

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

            // ===== 상세 조회 =====
            InquiryDTO inquiry = idao.selectInquiryDetail(inquiryNumber);

            if (inquiry == null) {
                json.put("success", false);
                json.put("message", "문의를 찾을 수 없습니다.");

                request.setAttribute("json", json.toString());
                super.setRedirect(false);
                super.setViewPage("/WEB-INF/admin/admin_jsonview.jsp");
                return;
            }

            // ===== 작성자 여부 =====
            boolean isOwner = isLoggedIn && loginUser.getMemberid().equals(inquiry.getMemberid());

            // ===== 데이터 =====
            json.put("success", true);
            json.put("inquiryNumber", inquiry.getInquiryNumber());

            
            json.put("memberid", inquiry.getMemberid()); // 작성자

            json.put("inquiryType", inquiry.getInquiryType());
            json.put("title", inquiry.getTitle());
            json.put("registerday", inquiry.getRegisterday() != null ? inquiry.getRegisterday().toString() : "");
            json.put("inquiryContent", inquiry.getInquiryContent());

            json.put("replyContent", inquiry.getReplyContent());
            json.put("replyRegisterday", inquiry.getReplyRegisterday() != null ? inquiry.getReplyRegisterday().toString() : "");
            json.put("replyStatus", inquiry.getReplyStatus());
            json.put("replyStatusString", inquiry.getReplyStatusString());

            // ===== 권한 =====
            json.put("isAdmin", isAdmin);
            json.put("canReply", isAdmin);          // 관리자만 답변
            json.put("canEdit", isOwner);           // 작성자만 수정
            json.put("canDelete", isOwner || isAdmin); // 정책: 작성자 또는 관리자 삭제

        } catch (Exception e) {
            e.printStackTrace();
            json.put("success", false);
            json.put("message", "문의 상세 조회 중 오류가 발생했습니다.");
        }

        request.setAttribute("json", json.toString());
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/admin/admin_jsonview.jsp");
    }
}
