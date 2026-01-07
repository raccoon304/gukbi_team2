package inquiry.controller;

import java.sql.SQLException;

import org.json.JSONObject;

import common.controller.AbstractController;
import inquiry.domain.InquiryDTO;
import inquiry.model.InquiryDAO;
import inquiry.model.InquiryDAO_imple;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class InquiryUpdate extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        String method = request.getMethod();
        JSONObject jsonObj = new JSONObject();

        if (!"POST".equalsIgnoreCase(method)) {
            jsonObj.put("success", false);
            jsonObj.put("message", "잘못된 요청입니다.");
            request.setAttribute("json", jsonObj.toString());

            super.setRedirect(false);
            super.setViewPage("/WEB-INF/jsonview.jsp");
            return;
        }

        String memberID = (String) request.getSession().getAttribute("memberID");

        if (memberID == null) {
            jsonObj.put("success", false);
            jsonObj.put("needLogin", true);
            jsonObj.put("message", "로그인이 필요합니다.");
        } else {
            InquiryDAO dao = new InquiryDAO_imple();

            int inquiryNumber = Integer.parseInt(request.getParameter("inquiryNumber"));
            String inquiryType = request.getParameter("inquiryType");
            String title = request.getParameter("title");
            String inquiryContent = request.getParameter("inquiryContent");

            try {
                // 본인 글인지 먼저 확인하고 업데이트
                InquiryDTO origin = dao.selectInquiryDetail(inquiryNumber);

                if (origin == null) {
                    jsonObj.put("success", false);
                    jsonObj.put("message", "해당 문의가 존재하지 않습니다.");
                } else if (!memberID.equals(origin.getMemberID())) {
                    jsonObj.put("success", false);
                    jsonObj.put("message", "본인이 작성한 문의만 수정할 수 있습니다.");
                } else {
                    InquiryDTO inquiry = new InquiryDTO();
                    inquiry.setInquiryNumber(inquiryNumber);
                    inquiry.setMemberID(memberID);
                    inquiry.setInquiryType(inquiryType);
                    inquiry.setTitle(title);
                    inquiry.setInquiryContent(inquiryContent);

                    int result = dao.updateInquiry(inquiry);

                    if (result > 0) {
                        jsonObj.put("success", true);
                        jsonObj.put("message", "문의가 수정되었습니다.");
                    } else {
                        jsonObj.put("success", false);
                        jsonObj.put("message", "문의 수정에 실패했습니다.");
                    }
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
    }
}
