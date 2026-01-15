package auth.controller;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class AccountFind extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        if (!"GET".equalsIgnoreCase(request.getMethod())) {
            // POST로 직접 들어오는 경우 방지 
            super.setRedirect(true);
            super.setViewPage(request.getContextPath() + "/member/accountFind.hp");
            return;
        }

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/member_YD/accountFind.jsp");
    }
}
