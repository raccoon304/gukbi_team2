package inquiry.controller;

import java.util.HashMap;
import java.util.Map;

import org.json.JSONObject;

import common.controller.AbstractController;
import inquiry.model.InquiryDAO;
import inquiry.model.InquiryDAO_imple;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;

public class InquiryReply extends AbstractController {

	private InquiryDAO idao = new InquiryDAO_imple();
	
    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

    	
        String method = request.getMethod();

        if (!"POST".equalsIgnoreCase(method)) {
            request.setAttribute("json", new JSONObject()
                    .put("success", false)
                    .put("message", "잘못된 요청입니다.")
                    .toString());
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/admin/admin_jsonview.jsp");
            return;
        }

        JSONObject json = new JSONObject();

        try {
            HttpSession session = request.getSession(false);
            MemberDTO loginUser = (session == null) ? null : (MemberDTO) session.getAttribute("loginUser");

            if (loginUser == null) {
                json.put("needLogin", true);
                json.put("success", false);
                json.put("message", "로그인이 필요합니다.");

                request.setAttribute("json", json.toString());
                super.setRedirect(false);
                super.setViewPage("/WEB-INF/admin/admin_jsonview.jsp");
                return;
            }

            if (!"admin".equals(loginUser.getMemberid())) {
                json.put("needAdmin", true);
                json.put("success", false);
                json.put("message", "관리자만 답변할 수 있습니다.");

                request.setAttribute("json", json.toString());
                super.setRedirect(false);
                super.setViewPage("/WEB-INF/admin/admin_jsonview.jsp");
                return;
            }

            
            String inquiryNumberStr = request.getParameter("inquiryNumber");
            String replyContent = request.getParameter("replyContent");

            int inquiryNumber = 0;
            
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

            
            if (replyContent == null || replyContent.trim().isEmpty()) {
                json.put("success", false);
                json.put("message", "답변 내용을 입력하세요.");

                request.setAttribute("json", json.toString());
                super.setRedirect(false);
                super.setViewPage("/WEB-INF/admin/admin_jsonview.jsp");
                return;
            }
            
            Map<String,String> paraMap = new HashMap<>();
            paraMap.put("inquiryNumber", String.valueOf(inquiryNumber));
            paraMap.put("replyContent", replyContent.trim());

            
            int n = idao.updateReply(paraMap);

            if(n==1) {
	            	json.put("success", true);
	            	json.put("message", "관리자 답변이 저장되었습니다.");
	            	json.put("replyStatus", 2);
            }
            else {
	            	json.put("success", false);
	            	json.put("message", "해당 문의가 존재하지 않습니다.");
            }
            

        } catch (Exception e) {
            e.printStackTrace();
            json.put("success", false);
            json.put("message", "답변 저장 중 오류가 발생했습니다.");
        }

        request.setAttribute("json", json.toString());
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/admin/admin_jsonview.jsp");
    }
}
