package auth.controller;

import java.util.HashMap;
import java.util.Map;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;
import member.model.MemberDAO;
import member.model.MemberDAO_imple;

public class MemberLogin extends AbstractController {

    private MemberDAO mbDao = new MemberDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        String method = request.getMethod();

        if ("GET".equalsIgnoreCase(method)) {
            String message = "비정상적인 접근입니다!";
            String loc = "javascript:history.back()";

            request.setAttribute("message", message);
            request.setAttribute("loc", loc);

            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        String loginId = request.getParameter("loginId");
        String loginPw = request.getParameter("loginPw");

        Map<String, String> paraMap = new HashMap<>();
        paraMap.put("loginId", loginId);
        paraMap.put("loginPw", loginPw);

        MemberDTO loginUser = mbDao.login(paraMap); 

        response.setContentType("application/json; charset=UTF-8");

        // 로그인 실패
        if (loginUser == null) {
            String json = "{\"success\":false, \"message\":\"아이디 또는 비밀번호가 올바르지 않습니다.\"}";
            response.getWriter().write(json);
            return;
        }

        // ======================= 휴면 분기 =======================
        HttpSession session = request.getSession();

        // 이미 휴면(IDLE=1)인 계정인 경우 휴면 해제 페이지로 유도
        if (loginUser.getIdle() == 1) {

            // 휴면해제 페이지에서 쓸 값 보관
            session.setAttribute("dormantMemberId", loginUser.getMemberid());
            session.setAttribute("dormantLoginUser", loginUser);

            // redirect 값은 반드시 문자열로(따옴표 포함) ==> 뷰단 ajax에서 분기해서 처리함. 
            String json = String.format(
                "{\"success\":false, \"dormant\":true, \"redirect\":\"%s/member/dormantUnlock.hp\"}",
                request.getContextPath()
            );
            response.getWriter().write(json);
            return;
        }

        // IDLE=0 이지만 마지막 로그인 기준 3개월 지난경우  idle=1 전환 후 휴면해제 페이지로 유도
        if (mbDao.isDormantTarget(loginUser.getMemberid())) {

            mbDao.updateMemberIdle(loginUser.getMemberid());

            // 휴면해제 페이지에서 쓸 값 보관
            session.setAttribute("dormantMemberId", loginUser.getMemberid());
            session.setAttribute("dormantLoginUser", loginUser);

            String json = String.format(
                "{\"success\":false, \"dormant\":true, \"redirect\":\"%s/member/dormantUnlock.hp\"}",
                request.getContextPath()
            );
            response.getWriter().write(json);
            return;
        }

        // 정상 로그인 일경우 세션 저장하고  최종 접속일자 (last_login_ymd) 업데이트
        session.setAttribute("loginUser", loginUser);

        // 정상 로그인에서는 휴면 임시값 제거
        session.removeAttribute("dormantMemberId");
        session.removeAttribute("dormantLoginUser");

        // 마지막 접속일 갱신
        mbDao.updateLastLoginYmd(loginUser.getMemberid());

        String json = "{\"success\":true, \"redirect\":\"" + request.getContextPath() + "/index.hp\"}";
        response.getWriter().write(json);
    }
}
