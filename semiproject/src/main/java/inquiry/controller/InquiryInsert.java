package inquiry.controller;

import java.sql.SQLException;

import org.json.JSONObject;

import common.controller.AbstractController;
import inquiry.domain.InquiryDTO;
import inquiry.model.InquiryDAO;
import inquiry.model.InquiryDAO_imple;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class InquiryInsert extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        String method = request.getMethod();

        if ("POST".equalsIgnoreCase(method)) {

            // 세션에서 회원 ID 가져오기
            String memberID = (String) request.getSession().getAttribute("memberID");

            JSONObject jsonObj = new JSONObject();

            if (memberID == null) {
                jsonObj.put("success", false);
                jsonObj.put("needLogin", true);
                jsonObj.put("message", "로그인이 필요합니다.");
            }
            else {
                String inquiryType = request.getParameter("inquiryType");
                String title = request.getParameter("title");
                String inquiryContent = request.getParameter("inquiryContent");

                InquiryDTO inquiry = new InquiryDTO();
                inquiry.setMemberID(memberID);
                inquiry.setInquiryType(inquiryType);
                inquiry.setTitle(title);
                inquiry.setInquiryContent(inquiryContent);

                InquiryDAO dao = new InquiryDAO_imple();

                try {
                    int result = dao.insertInquiry(inquiry);

                    if (result == 1) {
                        jsonObj.put("success", true);
                        jsonObj.put("message", "문의가 등록되었습니다.");
                    } else {
                        jsonObj.put("success", false);
                        jsonObj.put("message", "문의 등록에 실패했습니다.");
                    }

                } catch (SQLException e) {
                    e.printStackTrace();
                    jsonObj.put("success", false);
                    jsonObj.put("message", "데이터베이스 오류가 발생했습니다.");
                }
            }

            request.setAttribute("json", jsonObj.toString());

            super.setRedirect(false);
            super.setViewPage("/WEB-INF/jsonview.jsp");
            return;
        }

        // POST가 아니면(직접 URL 접근 등) 목록으로 보내기
        super.setRedirect(true);
        super.setViewPage(request.getContextPath() + "/inquiry/inquiryList.hp");
    }
}
