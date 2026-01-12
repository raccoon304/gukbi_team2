package inquiry.controller;

import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

	 private InquiryDAO dao = new InquiryDAO_imple();

	    @Override
	    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

	    	String method = request.getMethod();

	        JSONObject json = new JSONObject();

	        // POST만 허용
	        if (!"POST".equalsIgnoreCase(method)) {
	            json.put("success", false);
	            json.put("message", "잘못된 요청입니다.");
	            request.setAttribute("json", json.toString());
	            super.setRedirect(false);
	            super.setViewPage("/WEB-INF/admin/admin_jsonview.jsp");
	            return;
	        }

	        try {
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

	            
	            String inquiryType = request.getParameter("inquiryType");
	            String title = request.getParameter("title");
	            String inquiryContent = request.getParameter("inquiryContent");

	            // isSecret: "1" 또는 "0" (없으면 0)
	            String isSecretStr = request.getParameter("isSecret");
	            int isSecret = 0;
	            if ("1".equals(isSecretStr)) {
	                isSecret = 1;
	            }

	            // 유효성
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

	           
	            InquiryDTO idto = new InquiryDTO();
	            idto.setMemberid(loginUser.getMemberid());
	            idto.setInquiryType(inquiryType.trim());
	            idto.setTitle(title.trim());
	            idto.setInquiryContent(inquiryContent.trim());
	            idto.setIsSecret(isSecret);

	            int n = dao.insertInquiry(idto);

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
