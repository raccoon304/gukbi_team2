package inquiry.controller;

import java.sql.SQLException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.json.JSONObject;

import inquiry.domain.InquiryDTO;
import inquiry.model.*;
import common.controller.AbstractController;

public class InquiryDelete extends AbstractController {
    
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
                
                try {
                    // 본인 문의인지 확인
                    InquiryDTO inquiry = dao.selectInquiryDetail(inquiryNumber);
                    
                    if (inquiry != null && inquiry.getMemberID().equals(memberID)) {
                        int result = dao.deleteInquiry(inquiryNumber);
                        
                        if (result > 0) {
                            jsonObj.put("success", true);
                            jsonObj.put("message", "문의가 삭제되었습니다.");
                        } else {
                            jsonObj.put("success", false);
                            jsonObj.put("message", "문의 삭제에 실패했습니다.");
                        }
                    } else {
                        jsonObj.put("success", false);
                        jsonObj.put("message", "본인이 작성한 문의만 삭제할 수 있습니다.");
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