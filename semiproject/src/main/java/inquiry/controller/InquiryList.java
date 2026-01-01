package inquiry.controller;

import java.util.List;

import common.controller.AbstractController;
import inquiry.domain.InquiryDTO;
import inquiry.model.InquiryDAO;
import inquiry.model.InquiryDAO_imple;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class InquiryList extends AbstractController {

    private InquiryDAO dao = new InquiryDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        // 세션 로그인 사용자
        String memberID = (String) request.getSession().getAttribute("memberID");

        try {
            List<InquiryDTO> inquiryList;

            if (memberID != null) {
                inquiryList = dao.selectInquiriesByMember(memberID);
            } else {
                inquiryList = List.of(); // 빈 리스트
            }

            // JSP에서 사용
            request.setAttribute("inquiryList", inquiryList);
            request.setAttribute("memberID", memberID);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "문의 목록을 불러오는 중 오류가 발생했습니다.");
        }

        // JSP로 forward
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/inquiry/inquiry.jsp");
    }
}
