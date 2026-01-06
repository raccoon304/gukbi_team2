package myPage.controller;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;

public class MyPage extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession();

        // 로그인 컨트롤러에서 저장한 키 그대로
        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
        
        
        if (loginUser == null) {
            String message = "로그인 후 이용 가능합니다.";
            String loc = request.getContextPath() + "/index.hp";

            request.setAttribute("message", message);
            request.setAttribute("loc", loc);

            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        if ("GET".equalsIgnoreCase(request.getMethod())) {
        	//System.out.println(loginUser.getName()+"하고"+loginUser.getRegisterday());
            request.setAttribute("memberInfo", loginUser);
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/member_YD/myPage.jsp");
            return;
        }

        String message = "비정상적인 접근입니다!";
        String loc = "javascript:history.back()";

        request.setAttribute("message", message);
        request.setAttribute("loc", loc);

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/msg.jsp");
    }
}
