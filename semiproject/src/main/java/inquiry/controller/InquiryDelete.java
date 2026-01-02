package inquiry.controller;

import java.sql.SQLException;

import org.json.JSONObject;

import common.controller.AbstractController;
import inquiry.domain.InquiryDTO;
import inquiry.model.InquiryDAO;
import inquiry.model.InquiryDAO_imple;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class InquiryDelete extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        String method = request.getMethod();

        if (!"POST".equalsIgnoreCase(method)) {
            super.setRedirect(true);
            super.setViewPage(request.getContextPath() + "/inquiry/inquiryList.hp");
            return;
        }

        String memberID = (String) request.getSession().getAttribute("memberID");

        JSONObject jsonObj = new JSONObject();

        if (memberID == null) {
            jsonObj.put("success", false);
            jsonObj.put("needLogin", true);
            jsonObj.put("message", "로그인이 필요합니다.");
        } else {
            InquiryDAO dao = new InquiryDAO_imple();

            try {
                int inquiryNumber = Integer.parseInt(request.getParameter("inquiryNumber"));

                // 본인 문의인지 확인
                InquiryDTO inquiry = dao.selectInquiryDetail(inquiryNumber);

                if (inquiry == null) {
                    jsonObj.put("success", false);
                    jsonObj.put("message", "문의를 찾을 수 없습니다.");
                } else if (!memberID.equals(inquiry.getMemberID())) {
                    jsonObj.put("success", false);
                    jsonObj.put("message", "본인이 작성한 문의만 삭제할 수 있습니다.");
                } else {
                    int result = dao.deleteInquiry(inquiryNumber);

                    if (result > 0) {
                        jsonObj.put("success", true);
                        jsonObj.put("message", "문의가 삭제되었습니다.");
                    } else {
                        jsonObj.put("success", false);
                        jsonObj.put("message", "문의 삭제에 실패했습니다.");
                    }
                }

            } catch (NumberFormatException e) {
                jsonObj.put("success", false);
                jsonObj.put("message", "잘못된 요청입니다.");
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
