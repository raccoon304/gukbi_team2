package auth.controller;

import java.io.PrintWriter;
import java.security.SecureRandom;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import mail.controller.GoogleMail;
import member.model.MemberDAO;
import member.model.MemberDAO_imple;
import util.security.Sha256;
import util.sms.SmsService;

public class VerifyCertificationAjax extends AbstractController {

    private MemberDAO mdao = new MemberDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        if (!"POST".equalsIgnoreCase(request.getMethod())) {
            writeJson(response, false, "INVALID_METHOD", "잘못된 접근입니다.", "");
            return;
        }

        String userCertificationCode = nvl(request.getParameter("userCertificationCode"));
        String userid = nvl(request.getParameter("userid"));
        String channel = nvl(request.getParameter("channel"));
        if (channel.isEmpty()) channel = "email";

        HttpSession session = request.getSession();

        String certication_code = (String) session.getAttribute("certication_code");

        Long expireAt = null;
        Object expObj = session.getAttribute("pwdfind_cert_expire");
        if (expObj instanceof Long) expireAt = (Long) expObj;
        else if (expObj instanceof String) {
            try { expireAt = Long.parseLong((String) expObj); } catch (Exception ignore) {}
        }

        String sessionUserid = (String) session.getAttribute("pwdfind_memberid");

        // 기본 유효성
        if (userCertificationCode.isEmpty() || userid.isEmpty()) {
            writeJson(response, false, "INVALID", "인증코드/아이디가 비어있습니다.", "");
            return;
        }

        // userid 매칭
        if (sessionUserid != null && !sessionUserid.trim().isEmpty() && !userid.equals(sessionUserid)) {
            cleanupVerifySession(session);
            writeJson(response, false, "MISMATCH", "인증 대상 정보가 일치하지 않습니다. 다시 진행해주세요.", "");
            return;
        }

        // 만료 체크
        if (expireAt != null && System.currentTimeMillis() > expireAt) {
            cleanupVerifySession(session);
            writeJson(response, false, "EXPIRED", "인증코드 유효시간(5분)이 만료되었습니다. 재발급 해주세요.", "");
            return;
        }

        // 코드 일치
        if (certication_code == null || !certication_code.equals(userCertificationCode)) {
            // 틀린 경우 세션은 유지 시킴(재입력 UX)
            writeJson(response, false, "WRONG_CODE", "인증코드가 올바르지 않습니다.", "");
            return;
        }

        // 인증 성공 후 처리
        if ("phone".equalsIgnoreCase(channel)) {

            String sessionMobile = (String) session.getAttribute("pwdfind_mobile");
            if (sessionMobile == null || sessionMobile.trim().isEmpty()) {
                cleanupVerifySession(session);
                writeJson(response, false, "NO_MOBILE", "휴대폰 정보가 없습니다. 다시 진행해주세요.", "");
                return;
            }

            String tempPwd = makeTempPassword6();
            String hashedPwd = Sha256.encrypt(tempPwd);

            int n = mdao.updatePasswordByUserid(userid, hashedPwd);
            if (n != 1) {
                cleanupVerifySession(session);
                writeJson(response, false, "UPDATE_FAIL", "임시비밀번호 발급에 실패했습니다.", "");
                return;
            }

            boolean sent;
            try {
                SmsService smsService = new SmsService(request.getServletContext());
                sent = smsService.sendTempPassword(sessionMobile, tempPwd);
            } catch (Exception e) {
                //e.printStackTrace();
                sent = false;
            }

            cleanupVerifySession(session);

            if (sent) {
                writeJson(response, true, "OK", "SMS 인증 완료. 임시비밀번호를 문자로 발급했습니다.", request.getContextPath() + "/index.hp");
            } else {
                writeJson(response, true, "OK", "임시비밀번호는 발급되었으나 문자 전송에 실패했습니다. 관리자에게 문의하세요.", request.getContextPath() + "/index.hp");
            }
            return;
        }

        // 이메일 인증 성공시 임시비밀번호 발급 하고 메일 발송까지 여기서 끝냄
        // 	=> 기존에  PwdUpdateEnd로 페이지 이동 때문에 빈화면 출력되서 고침. 
        String email = (String) session.getAttribute("pwdfind_email");
        if (email == null || email.trim().isEmpty()) {
            cleanupVerifySession(session);
            writeJson(response, false, "NO_EMAIL", "이메일 정보가 없습니다. 다시 진행해주세요.", "");
            return;
        }

        String tempPwd = makeTempPassword10();
        String hashedPwd = Sha256.encrypt(tempPwd);

        int n = mdao.updatePasswordByUserid(userid, hashedPwd);
        if (n != 1) {
            cleanupVerifySession(session);
            writeJson(response, false, "UPDATE_FAIL", "임시비밀번호 발급에 실패했습니다.", "");
            return;
        }

        boolean sent;
        try {
            GoogleMail mail = new GoogleMail();
            mail.send_temp_password(email, tempPwd);
            sent = true;
        } catch (Exception e) {
            //e.printStackTrace();
            sent = false;
        }

        cleanupVerifySession(session);

        if (sent) {
            writeJson(response, true, "OK", "이메일 인증 완료. 임시비밀번호를 이메일로 발급했습니다.", request.getContextPath() + "/index.hp");
        } else {
            writeJson(response, true, "OK", "임시비밀번호는 발급되었으나 메일 전송에 실패했습니다. 관리자에게 문의하세요.", request.getContextPath() + "/index.hp");
        }
    }

    private String nvl(String s) {
        return (s == null) ? "" : s.trim();
    }

    private void cleanupVerifySession(HttpSession session) {
        session.removeAttribute("certication_code");
        session.removeAttribute("pwdfind_cert_expire");
        session.removeAttribute("pwdfind_mobile");
        session.removeAttribute("pwdfind_channel");
        session.removeAttribute("pwdfind_email");
        session.removeAttribute("pwdfind_memberid");
        session.removeAttribute("pwdfind_verified");
        session.removeAttribute("pwdfind_verified_userid");
    }

    private String makeTempPassword6() {
        SecureRandom rnd = new SecureRandom();
        int n = rnd.nextInt(900000) + 100000;
        return String.valueOf(n);
    }

    private String makeTempPassword10() {
        final String chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        SecureRandom rnd = new SecureRandom();
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < 10; i++) sb.append(chars.charAt(rnd.nextInt(chars.length())));
        return sb.toString();
    }

    private void writeJson(HttpServletResponse response, boolean success, String status, String msg, String loc) throws Exception {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();

        msg = (msg == null) ? "" : msg.replace("\\", "\\\\").replace("\"", "\\\"");
        loc = (loc == null) ? "" : loc.replace("\\", "\\\\").replace("\"", "\\\"");

        out.print("{");
        out.print("\"success\":" + success + ",");
        out.print("\"status\":\"" + status + "\",");
        out.print("\"msg\":\"" + msg + "\",");
        out.print("\"loc\":\"" + loc + "\"");
        out.print("}");
        out.flush();
    }
}
