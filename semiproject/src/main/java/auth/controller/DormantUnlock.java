package auth.controller;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class DormantUnlock extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
        String dormantMemberId = (String) session.getAttribute("dormantMemberId");

        // 휴면 대상 세션이 없으면 직접 접근 차단
        if (dormantMemberId == null || dormantMemberId.trim().isEmpty()) {
            request.setAttribute("message", "비정상적인 접근입니다.");
            request.setAttribute("loc", request.getContextPath() + "/index.hp");

            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        // 화면에 아이디 보여주고 싶으면 request로 내려줌
        request.setAttribute("dormantMemberId", dormantMemberId);

        super.setRedirect(false);
        // 요청한 경로
        super.setViewPage("/WEB-INF/member_YD/dormantUnlock.jsp");

	}

}
