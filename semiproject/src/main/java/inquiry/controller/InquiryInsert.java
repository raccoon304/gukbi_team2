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

public class InquiryInsert extends AbstractController {

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

	            // ===== 등록 =====
	            InquiryDTO dto = new InquiryDTO();
	            dto.setMemberid(loginUser.getMemberid());
	            dto.setInquiryType(inquiryType.trim());
	            dto.setTitle(title.trim());
	            dto.setInquiryContent(inquiryContent.trim());

	            int n = idao.insertInquiry(dto);

	            if (n == 1) {
	                json.put("success", true);
	                json.put("message", "문의가 등록되었습니다.");
	            } else {
	                json.put("success", false);
	                json.put("message", "문의 등록에 실패했습니다.");
	            }

	        } catch (Exception e) {
	            e.printStackTrace();
	            json.put("success", false);
	            json.put("message", "문의 등록 중 오류가 발생했습니다.");
	        }

	        request.setAttribute("json", json.toString());
	        super.setRedirect(false);
	        super.setViewPage("/WEB-INF/admin/admin_jsonview.jsp");
	    }
}
