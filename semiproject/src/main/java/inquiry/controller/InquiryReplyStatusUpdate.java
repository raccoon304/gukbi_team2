package inquiry.controller;

import java.sql.SQLException;

import org.json.JSONObject;

import common.controller.AbstractController;
import inquiry.model.InquiryDAO;
import inquiry.model.InquiryDAO_imple;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class InquiryReplyStatusUpdate extends AbstractController {

    private boolean isAdmin(HttpServletRequest request) {
        String memberID = (String) request.getSession().getAttribute("memberID");
        return memberID != null && "admin".equalsIgnoreCase(memberID);
    }

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        JSONObject jsonObj = new JSONObject();

        String method = request.getMethod();

        if (!"POST".equalsIgnoreCase(method)) {
            jsonObj.put("success", false);
            jsonObj.put("message", "잘못된 요청입니다.");
            request.setAttribute("json", jsonObj.toString());
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/jsonview.jsp");
            return;
        }

        if (!isAdmin(request)) {
            jsonObj.put("success", false);
            jsonObj.put("message", "관리자만 상태 변경이 가능합니다.");
            request.setAttribute("json", jsonObj.toString());
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/jsonview.jsp");
            return;
        }

        try {
            int inquiryNumber = Integer.parseInt(request.getParameter("inquiryNumber"));
            int replyStatus = Integer.parseInt(request.getParameter("replyStatus"));

            InquiryDAO dao = new InquiryDAO_imple();
            int n = dao.updateReplyStatus(inquiryNumber, replyStatus);

            if (n == 1) {
                jsonObj.put("success", true);
                jsonObj.put("message", "상태 변경 성공");
            } else {
                jsonObj.put("success", false);
                jsonObj.put("message", "상태 변경에 실패했습니다.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            jsonObj.put("success", false);
            jsonObj.put("message", "데이터베이스 오류가 발생했습니다.");
        } catch (NumberFormatException e) {
            jsonObj.put("success", false);
            jsonObj.put("message", "요청 값이 올바르지 않습니다.");
        }

        request.setAttribute("json", jsonObj.toString());
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/jsonview.jsp");
    }
}
