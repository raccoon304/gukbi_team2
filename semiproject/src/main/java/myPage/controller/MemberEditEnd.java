package myPage.controller;

import java.util.HashMap;
import java.util.Map;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;
import member.model.MemberDAO;
import member.model.MemberDAO_imple;

public class MemberEditEnd extends AbstractController {

    private MemberDAO mbDao = new MemberDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        if (!"POST".equalsIgnoreCase(request.getMethod())) {
            request.setAttribute("message", "비정상적인 접근입니다!");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        HttpSession session = request.getSession();
        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

        if (loginUser == null) {
            request.setAttribute("message", "로그인이 필요합니다.");
            request.setAttribute("loc", request.getContextPath() + "/index.hp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        // memberid를 session에서 직접 받아오므로 개인 검증은 하지않음.
        String memberid = loginUser.getMemberid();

        String name   = request.getParameter("name");
        String email  = request.getParameter("email");
        String mobile = request.getParameter("mobile");

        Map<String,String> paraMap = new HashMap<>();
        paraMap.put("memberid", memberid);
        paraMap.put("name", name);
        paraMap.put("email", email);
        paraMap.put("mobile", mobile);

        int n = mbDao.updateMember(paraMap);

        if (n == 1) {
            // 세션 갱신(평문 기준)
            loginUser.setName(name);
            loginUser.setEmail(email);
            loginUser.setMobile(mobile);
            session.setAttribute("loginUser", loginUser);

            request.setAttribute("message", "정보수정 되었습니다.");
            request.setAttribute("loc", request.getContextPath() + "/myPage/myPage.hp");
            
                  
        } else {
            request.setAttribute("message", "정보수정에 실패하였습니다.");
            request.setAttribute("loc", "javascript:history.back()");

        }

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/msg.jsp");
    }
}
