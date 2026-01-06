package member.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import common.controller.AbstractController;

public class Logout extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

    	HttpSession session = request.getSession(false);

        if (session != null) {
            session.invalidate(); 
        }

        // 로그아웃 후 메인으로 리다이렉트
        super.setRedirect(true);
        super.setViewPage(request.getContextPath() + "/index.hp");
    }
}
