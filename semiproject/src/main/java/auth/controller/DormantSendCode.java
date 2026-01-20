package auth.controller;

import java.security.SecureRandom;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import mail.controller.GoogleMail;
import member.domain.MemberDTO;

public class DormantSendCode extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        response.setContentType("application/json; charset=UTF-8");

        if (!"POST".equalsIgnoreCase(request.getMethod())) {
            response.getWriter().write("{\"success\":false, \"message\":\"비정상적인 접근입니다.\"}");
            response.getWriter().flush();
            return;
        }

        HttpSession session = request.getSession();

        String dormantMemberId = (String) session.getAttribute("dormantMemberId");
        MemberDTO dormantLoginUser = (MemberDTO) session.getAttribute("dormantLoginUser");

        if (dormantMemberId == null || dormantLoginUser == null) {
            response.getWriter().write("{\"success\":false, \"message\":\"휴면 인증 대상이 아닙니다. 다시 로그인 해주세요.\"}");
            response.getWriter().flush();
            return;
        }

        String email = dormantLoginUser.getEmail();
        if (email == null || email.trim().isEmpty()) {
            response.getWriter().write("{\"success\":false, \"message\":\"등록된 이메일 정보가 없습니다.\"}");
            response.getWriter().flush();
            return;
        }
        email = email.trim();

        String certCode = makeCertificationCode();

        try {
            GoogleMail mail = new GoogleMail();
            mail.send_certification_code(email, certCode);

            long expireAt = System.currentTimeMillis() + (5 * 60 * 1000);

            session.setAttribute("dormant_cert_code", certCode);
            session.setAttribute("dormant_cert_expire", expireAt);

            // expireAt을 JSON에 포함해서 내려줌
            response.getWriter().write("{\"success\":true, \"expireAt\":" + expireAt + "}");
            response.getWriter().flush();
            return;

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\":false, \"message\":\"인증번호 발송에 실패했습니다.\"}");
            response.getWriter().flush();
            return;
        }
    }

    private String makeCertificationCode() {
        SecureRandom rnd = new SecureRandom();
        StringBuilder sb = new StringBuilder();

        for (int i = 0; i < 5; i++) {
            char randchar = (char) (rnd.nextInt('z' - 'a' + 1) + 'a');
            sb.append(randchar);
        }
        for (int i = 0; i < 5; i++) {
            sb.append(rnd.nextInt(10));
        }
        return sb.toString();
    }
}
