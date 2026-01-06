package inquiry.controller;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import org.json.JSONObject;

import common.controller.AbstractController;
import inquiry.model.InquiryDAO;
import inquiry.model.InquiryDAO_imple;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class InquiryReply extends AbstractController {

    private boolean isAdmin(String memberID) {
        return memberID != null && "admin".equalsIgnoreCase(memberID);
    }

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        String method = request.getMethod();

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
        JSONObject jsonObj = new JSONObject();

        // 로그인 체크
        if (memberID == null) {
            jsonObj.put("success", false);
            jsonObj.put("needLogin", true);
            jsonObj.put("message", "로그인이 필요합니다.");
            request.setAttribute("json", jsonObj.toString());
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/jsonview.jsp");
            return;
        }

        // 관리자 체크
        if (!isAdmin(memberID)) {
            jsonObj.put("success", false);
            jsonObj.put("needAdmin", true);
            jsonObj.put("message", "관리자만 답변을 등록/수정할 수 있습니다.");
            request.setAttribute("json", jsonObj.toString());
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/jsonview.jsp");
            return;
        }

        try {
            int inquiryNumber = Integer.parseInt(request.getParameter("inquiryNumber"));
            String replyContent = request.getParameter("replyContent");

            if (replyContent == null || replyContent.trim().isEmpty()) {
                jsonObj.put("success", false);
                jsonObj.put("message", "답변 내용을 입력하세요.");
            } else {
                InquiryDAO dao = new InquiryDAO_imple();

                Map<String, Object> replyMap = new HashMap<>();
                replyMap.put("inquiryNumber", inquiryNumber);
                replyMap.put("replyContent", replyContent.trim());

                int result = dao.updateReply(replyMap);

                if (result > 0) {
                    jsonObj.put("success", true);
                    jsonObj.put("message", "관리자 답변이 저장되었습니다.");
                } else {
                    jsonObj.put("success", false);
                    jsonObj.put("message", "답변 저장에 실패했습니다.");
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
