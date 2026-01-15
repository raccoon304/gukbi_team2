package auth.controller;

import java.util.Random;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.model.MemberDAO;
import member.model.MemberDAO_imple;
import util.security.Sha256;
import util.sms.SmsService;

public class VerifyCertification extends AbstractController {

    private MemberDAO mdao = new MemberDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        String method = request.getMethod();

        // POST만 허용
        if (!"POST".equalsIgnoreCase(method)) {
            request.setAttribute("message", "비정상적인 접근입니다.");
            request.setAttribute("loc", request.getContextPath() + "/member/accountFind.hp");

            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        // 회원이 입력한 인증번호 값
        String userCertificationCode = request.getParameter("userCertificationCode");
        String userid = request.getParameter("userid");
        String channel = request.getParameter("channel");

        userCertificationCode = (userCertificationCode == null) ? "" : userCertificationCode.trim();
        userid = (userid == null) ? "" : userid.trim();
        channel = (channel == null || channel.trim().isEmpty()) ? "email" : channel.trim();

        HttpSession session = request.getSession();

        // 발급한 인증번호
        String certication_code = (String) session.getAttribute("certication_code");

        // 만료시간(ms)
        Long expireAt = null;
        Object expObj = session.getAttribute("pwdfind_cert_expire");
        if (expObj instanceof Long) {
            expireAt = (Long) expObj;
        } else if (expObj instanceof String) {
            try { expireAt = Long.parseLong((String) expObj); } catch (Exception ignore) {}
        }

        // 세션에 저장해둔 비번찾기 대상 아이디 (조작 방지)
        String sessionUserid = (String) session.getAttribute("pwdfind_memberid");

        String message = "";
        String loc = "";

        // 기본 유효성
        if (userCertificationCode.isEmpty() || userid.isEmpty()) {
            message = "인증코드/아이디가 비어있습니다. 다시 시도해주세요.";
            loc = request.getContextPath() + "/member/accountFind.hp";

            request.setAttribute("message", message);
            request.setAttribute("loc", loc);
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        // 세션 대상 아이디 검증
        if (sessionUserid != null && !sessionUserid.trim().isEmpty() && !userid.equals(sessionUserid)) {
            message = "인증 대상 정보가 일치하지 않습니다. 다시 비밀번호 찾기를 진행해주세요.";
            loc = request.getContextPath() + "/member/accountFind.hp";

            cleanupVerifySession(session);

            request.setAttribute("message", message);
            request.setAttribute("loc", loc);
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        // 만료 체크
        if (expireAt != null && System.currentTimeMillis() > expireAt) {
            message = "인증코드 유효시간(5분)이 만료되었습니다. 인증코드를 다시 발급받아주세요.";
            loc = request.getContextPath() + "/member/accountFind.hp";

            cleanupVerifySession(session);

            request.setAttribute("message", message);
            request.setAttribute("loc", loc);
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        // 코드 일치 검사
        if (certication_code != null && certication_code.equals(userCertificationCode)) {

            // ===== phone(SMS) 인증 성공 처리 =====
            if ("phone".equalsIgnoreCase(channel)) {

                String sessionMobile = (String) session.getAttribute("pwdfind_mobile"); // PwdFind에서 저장됨

                if (sessionMobile == null || sessionMobile.trim().isEmpty()) {
                    message = "휴대폰 정보가 없습니다. 비밀번호 찾기를 다시 진행해주세요.";
                    loc = request.getContextPath() + "/member/accountFind.hp";
                } else {

                    // 1) 임시비번(숫자 6자리)
                    String tempPwd = makeTempPassword6();

                    // 2) DB 업데이트(sha256)
                    String hashedPwd = Sha256.encrypt(tempPwd);
                    int n = mdao.updatePasswordByUserid(userid, hashedPwd);

                    if (n == 1) {

                        // 3) 문자로 임시비번 발송
                        boolean sent;
                        try {
                            SmsService smsService = new SmsService(request.getServletContext());
                            sent = smsService.sendTempPassword(sessionMobile, tempPwd);
                        } catch (Exception e) {
                            e.printStackTrace();
                            sent = false;
                        }

                        if (sent) {
                            message = "SMS 인증이 완료되었습니다. 임시비밀번호를 문자로 발급했습니다.";
                        } else {
                            message = "임시비밀번호는 발급되었으나 문자 전송에 실패했습니다. 관리자에게 문의하세요.";
                        }

                        // ★ 요청한 이동: /index.hp
                        loc = request.getContextPath() + "/index.hp";

                    } else {
                        message = "임시비밀번호 발급에 실패했습니다. 다시 시도해주세요.";
                        loc = request.getContextPath() + "/member/accountFind.hp";
                    }
                }

                // phone 케이스: 인증/비번찾기 세션 정리
                cleanupVerifySession(session);

            }

            // ===== email 인증 성공 처리(기존 로직 유지) =====
            else {
                session.setAttribute("pwdfind_verified", true);
                session.setAttribute("pwdfind_verified_userid", userid);

                message = "이메일 인증이 완료되었습니다. 임시비밀번호를 이메일로 발급합니다.";
                loc = request.getContextPath() + "/member/pwdUpdateEnd.hp?userid=" + userid;

                // 인증 정보 정리
                session.removeAttribute("certication_code");
                session.removeAttribute("pwdfind_cert_expire");
            }

        } else {
            message = "발급된 인증코드와 다릅니다.\\n인증코드를 확인하거나 인증코드를 다시 발급받아야 합니다.";
            loc = request.getContextPath() + "/member/accountFind.hp";

            cleanupVerifySession(session);
        }

        request.setAttribute("message", message);
        request.setAttribute("loc", loc);

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/msg.jsp");
    }

    // 임시비밀번호(숫자 6자리)
    private String makeTempPassword6() {
        Random rnd = new Random();
        int n = rnd.nextInt(900000) + 100000; // 100000~999999
        return String.valueOf(n);
    }

    // 인증/비번찾기 세션 정리(재사용/재시도 안전)
    private void cleanupVerifySession(HttpSession session) {
        session.removeAttribute("certication_code");
        session.removeAttribute("pwdfind_cert_expire");
        session.removeAttribute("pwdfind_mobile");
        session.removeAttribute("pwdfind_channel");
        // 아래는 재시도 UX에 따라 남겨도 되지만, 조작 방지 위해 보통 같이 제거 추천
        // session.removeAttribute("pwdfind_memberid");
    }
}
