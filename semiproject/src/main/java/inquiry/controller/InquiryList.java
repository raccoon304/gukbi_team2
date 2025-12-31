package inquiry.controller;

import java.sql.SQLException;
import java.util.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import org.json.JSONObject;
import inquiry.model.*;
import inquiry.domain.*;
import common.controller.AbstractController;

public class InquiryList extends AbstractController {
    
    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        String method = request.getMethod();
        
        if ("POST".equalsIgnoreCase(method)) {
            // Ajax 요청
            InquiryDAO dao = new InquiryDAO_imple();
            
            // 세션에서 회원 ID 가져오기
            String memberID = (String) request.getSession().getAttribute("memberID");
            
            List<InquiryDTO> inquiryList = null;
            
            try {
                if (memberID != null) {
                    // 로그인한 회원의 문의 목록
                    inquiryList = dao.selectInquiriesByMember(memberID);
                } else {
                    // 비로그인 시 빈 목록
                    inquiryList = new ArrayList<>();
                }
                
                // JSON 변환
                JSONArray jsonArr = new JSONArray();
                
                for (InquiryDTO inquiry : inquiryList) {
                    JSONObject jsonObj = new JSONObject();
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
                    
                    jsonArr.put(jsonObj);
                }
                
                // JSON 응답
                response.setContentType("application/json; charset=UTF-8");
                response.getWriter().print(jsonArr.toString());
                
            } catch (SQLException e) {
                e.printStackTrace();
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                JSONObject errorObj = new JSONObject();
                errorObj.put("error", "데이터베이스 오류가 발생했습니다.");
                response.getWriter().print(errorObj.toString());
            }
            
        } else {
            // GET 요청 - JSP 페이지 보여주기
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/inquiry/inquiry.jsp");
        }
    }
}