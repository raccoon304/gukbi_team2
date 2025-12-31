package inquiry.controller;

import java.sql.SQLException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.json.JSONObject;
import inquiry.model.*;
import inquiry.domain.*;
import common.controller.AbstractController;

public class InquiryDetail extends AbstractController {
    
    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        String method = request.getMethod();
        
        if ("POST".equalsIgnoreCase(method)) {
            InquiryDAO dao = new InquiryDAO_imple();
            
            int inquiryNumber = Integer.parseInt(request.getParameter("inquiryNumber"));
            
            try {
                InquiryDTO inquiry = dao.selectInquiryDetail(inquiryNumber);
                
                JSONObject jsonObj = new JSONObject();
                
                if (inquiry != null) {
                    jsonObj.put("inquiryNumber", inquiry.getInquiryNumber());
                    jsonObj.put("memberID", inquiry.getMemberID());
                    jsonObj.put("inquiryType", inquiry.getInquiryType());
                    jsonObj.put("title", inquiry.getTitle());
                    jsonObj.put("registerday", inquiry.getRegisterday() != null ? 
                               inquiry.getRegisterday().toString() : "");
                    jsonObj.put("inquiryContent", inquiry.getInquiryContent());
                    jsonObj.put("replyContent", inquiry.getReplyContent());
                    jsonObj.put("replyRegisterday", inquiry.getReplyRegisterday() != null ? 
                               inquiry.getReplyRegisterday().toString() : "");
                    jsonObj.put("replyStatus", inquiry.getReplyStatus());
                    jsonObj.put("replyStatusString", inquiry.getReplyStatusString());
                    jsonObj.put("success", true);
                } else {
                    jsonObj.put("success", false);
                    jsonObj.put("message", "문의를 찾을 수 없습니다.");
                }
                
                response.setContentType("application/json; charset=UTF-8");
                response.getWriter().print(jsonObj.toString());
                
            } catch (SQLException e) {
                e.printStackTrace();
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                JSONObject errorObj = new JSONObject();
                errorObj.put("success", false);
                errorObj.put("message", "데이터베이스 오류가 발생했습니다.");
                response.getWriter().print(errorObj.toString());
            }
        }
    }
}