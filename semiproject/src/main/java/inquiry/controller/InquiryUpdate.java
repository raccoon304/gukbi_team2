package inquiry.controller;

import java.sql.SQLException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.json.JSONObject;
import inquiry.model.*;
import inquiry.domain.*;
import common.controller.AbstractController;

public class InquiryUpdate extends AbstractController {
    
    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        String method = request.getMethod();
        
        if ("POST".equalsIgnoreCase(method)) {
            String memberID = (String) request.getSession().getAttribute("memberID");
            
            JSONObject jsonObj = new JSONObject();
            
            if (memberID == null) {
                jsonObj.put("success", false);
                jsonObj.put("message", "로그인이 필요합니다.");
                jsonObj.put("needLogin", true);
            } else {
                InquiryDAO dao = new InquiryDAO_imple();
                
                int inquiryNumber = Integer.parseInt(request.getParameter("inquiryNumber"));
                String inquiryType = request.getParameter("inquiryType");
                String title = request.getParameter("title");
                String inquiryContent = request.getParameter("inquiryContent");
                
                InquiryDTO inquiry = new InquiryDTO();
                inquiry.setInquiryNumber(inquiryNumber);
                inquiry.setMemberID(memberID);
                inquiry.setInquiryType(inquiryType);
                inquiry.setTitle(title);
                inquiry.setInquiryContent(inquiryContent);
                
                try {
                    int result = dao.updateInquiry(inquiry);
                    
                    if (result > 0) {
                        jsonObj.put("success", true);
                        jsonObj.put("message", "문의가 수정되었습니다.");
                    } else {
                        jsonObj.put("success", false);
                        jsonObj.put("message", "문의 수정에 실패했습니다. 본인이 작성한 문의만 수정할 수 있습니다.");
                    }
                    
                } catch (SQLException e) {
                    e.printStackTrace();
                    jsonObj.put("success", false);
                    jsonObj.put("message", "데이터베이스 오류가 발생했습니다.");
                }
            }
            
            response.setContentType("application/json; charset=UTF-8");
            response.getWriter().print(jsonObj.toString());
            return;
        }
    }
}