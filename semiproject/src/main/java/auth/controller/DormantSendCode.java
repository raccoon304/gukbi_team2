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

        // POST만 허용
        if (!"POST".equalsIgnoreCase(request.getMethod())) {
            response.getWriter().write("{\"success\":false, \"message\":\"비정상적인 접근입니다.\"}");
            return;
        }

        HttpSession session = request.getSession();

        // 휴면해제 대상(로그인 시 MemberLogin에서 세션에 저장해둔 값)
        String dormantMemberId = (String) session.getAttribute("dormantMemberId");
        MemberDTO dormantLoginUser = (MemberDTO) session.getAttribute("dormantLoginUser");

        if (dormantMemberId == null || dormantLoginUser == null) {
            response.getWriter().write("{\"success\":false, \"message\":\"휴면 인증 대상이 아닙니다. 다시 로그인 해주세요.\"}");
            return;
        }

        String email = dormantLoginUser.getEmail();
        if (email == null || email.trim().isEmpty()) {
            response.getWriter().write("{\"success\":false, \"message\":\"등록된 이메일 정보가 없습니다.\"}");
            return;
        }
        email = email.trim();

        // 인증코드 생성(비밀번호찾기와 동일하게 영문소문자 5 + 숫자 5)
        String certCode = makeCertificationCode();

        boolean sendMailSuccess = false;
        try {
            GoogleMail mail = new GoogleMail();
            // 기존 메일 전송 메서드 재활용
            mail.send_certification_code(email, certCode);
            sendMailSuccess = true;

            // 세션에 저장(휴면 전용 키 사용)
            session.setAttribute("dormant_cert_code", certCode);
            session.setAttribute("dormant_cert_expire", System.currentTimeMillis() + (5 * 60 * 1000)); // 5분

        } catch (Exception e) {
            e.printStackTrace();
            sendMailSuccess = false;
        }

        if (sendMailSuccess) {
            response.getWriter().write("{\"success\":true}");
        } else {
            response.getWriter().write("{\"success\":false, \"message\":\"인증번호 발송에 실패했습니다.\"}");
        }
    }

    // 비밀번호찾기와 동일한 규격으로 진행 문소문자 5 + 숫자 5
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
