package inquiry.controller;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import common.controller.AbstractController;
import inquiry.domain.InquiryDTO;
import inquiry.model.InquiryDAO;
import inquiry.model.InquiryDAO_imple;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;

public class InquiryList extends AbstractController {

	private InquiryDAO dao = new InquiryDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession(false);
        MemberDTO loginUser = (session == null) ? null : (MemberDTO) session.getAttribute("loginUser");

        List<InquiryDTO> inquiryList = new ArrayList<>();
        
        try {

            if (loginUser == null) {
               
            } else if ("admin".equalsIgnoreCase(loginUser.getMemberid())) {
                inquiryList = dao.selectAllInquiries();
            } else {
                inquiryList = dao.selectInquiriesByMember(loginUser.getMemberid());
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "문의 목록을 불러오는 중 오류가 발생했습니다.");
        }

        request.setAttribute("inquiryList", inquiryList);
        
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/inquiry/inquiry.jsp");
    }
}
