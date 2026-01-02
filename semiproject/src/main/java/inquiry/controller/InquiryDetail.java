package inquiry.controller;

import java.sql.SQLException;

import org.json.JSONObject;

import common.controller.AbstractController;
import inquiry.domain.InquiryDTO;
import inquiry.model.InquiryDAO;
import inquiry.model.InquiryDAO_imple;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class InquiryDetail extends AbstractController {

    private boolean isAdmin(String memberID) {
        return memberID != null && "admin".equalsIgnoreCase(memberID);
    }

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        String method = request.getMethod();

        // AJAX는 POST로만 받는다고 가정
        if (!"POST".equalsIgnoreCase(method)) {
            request.setAttribute("json", new JSONObject()
                    .put("success", false)
                    .put("message", "잘못된 요청입니다.")
                    .toString());
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/jsonview.jsp");
            return;
        }

        String memberID = (String) request.getSession().getAttribute("memberID");
        boolean admin = isAdmin(memberID);

        JSONObject jsonObj = new JSONObject();

        try {
            String strInquiryNumber = request.getParameter("inquiryNumber");
            if (strInquiryNumber == null) {
                jsonObj.put("success", false);
                jsonObj.put("message", "잘못된 요청입니다.");
            } else {
                int inquiryNumber = Integer.parseInt(strInquiryNumber);

                InquiryDAO dao = new InquiryDAO_imple();
                InquiryDTO inquiry = dao.selectInquiryDetail(inquiryNumber);

                if (inquiry == null) {
                    jsonObj.put("success", false);
                    jsonObj.put("message", "문의를 찾을 수 없습니다.");
                } else {
                    jsonObj.put("success", true);

                    jsonObj.put("inquiryNumber", inquiry.getInquiryNumber());
                    jsonObj.put("memberID", inquiry.getMemberID());
                    jsonObj.put("inquiryType", inquiry.getInquiryType());
                    jsonObj.put("title", inquiry.getTitle());

                    // LocalDateTime -> toString() 형태(2025-12-31T00:00:00)로 내려감
                    jsonObj.put("registerday", inquiry.getRegisterday() != null ? inquiry.getRegisterday().toString() : "");

                    jsonObj.put("inquiryContent", inquiry.getInquiryContent());
                    jsonObj.put("replyContent", inquiry.getReplyContent());
                    jsonObj.put("replyRegisterday", inquiry.getReplyRegisterday() != null ? inquiry.getReplyRegisterday().toString() : "");
                    jsonObj.put("replyStatus", inquiry.getReplyStatus());
                    jsonObj.put("replyStatusString", inquiry.getReplyStatusString());

                    // ★ 관리자 여부/답변 가능 여부 내려주기
                    jsonObj.put("isAdmin", admin);
                    jsonObj.put("canReply", admin);
                }
            }
        } catch (NumberFormatException e) {
            jsonObj.put("success", false);
            jsonObj.put("message", "inquiryNumber 형식이 올바르지 않습니다.");
        } catch (SQLException e) {
            e.printStackTrace();
            jsonObj.put("success", false);
            jsonObj.put("message", "데이터베이스 오류가 발생했습니다.");
        }

        request.setAttribute("json", jsonObj.toString());
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/jsonview.jsp");
    }
}
