package auth.controller;

import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import mail.controller.GoogleMail;
import member.model.MemberDAO;
import member.model.MemberDAO_imple;
import util.sms.SmsService;

public class PwdFindSend extends AbstractController {

    private MemberDAO mdao = new MemberDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        if (!"POST".equalsIgnoreCase(request.getMethod())) {
            writeJson(response, false, "INVALID_METHOD", "잘못된 접근입니다.", 0L, "", "");
            return;
        }

        String pwdFindType = nvl(request.getParameter("pwdFindType"));
        pwdFindType = pwdFindType.isEmpty() ? "email" : pwdFindType;

        String memberid = nvl(request.getParameter("memberid"));
        String name     = nvl(request.getParameter("name"));
        String email    = nvl(request.getParameter("email"));
        String mobile   = nvl(request.getParameter("mobile")).replaceAll("\\D", "");

        // ===== 공통 유효성 검사 =====
        if (memberid.isEmpty() || name.isEmpty()) {
            writeJson(response, false, "INVALID", "아이디/성명을 입력하세요.", 0L, "", memberid);
            return;
        }

        // 휴대폰 인증
        if ("phone".equalsIgnoreCase(pwdFindType)) {

            if (mobile.isEmpty()) {
                writeJson(response, false, "INVALID", "휴대폰 번호를 입력하세요.", 0L, "phone", memberid);
                return;
            }

            Map<String, String> paraMap = new HashMap<>();
            paraMap.put("memberid", memberid);
            paraMap.put("name", name);
            paraMap.put("mobile", mobile);

            boolean isUserExists = mdao.isUserExistsForPwdFindPhone(paraMap);
            if (!isUserExists) {
                writeJson(response, false, "NO_USER", "일치하는 회원정보가 없습니다.", 0L, "phone", memberid);
                return;
            }

            String smsCode = makeSmsCode6();
            boolean sent;

            try {
                SmsService smsService = new SmsService(request.getServletContext());
                sent = smsService.sendVerificationCode(mobile, smsCode);
            } catch (Exception e) {
                e.printStackTrace();
                sent = false;
            }

            if (!sent) {
                writeJson(response, false, "SMS_FAIL", "문자 전송에 실패했습니다.", 0L, "phone", memberid);
                return;
            }

            HttpSession session = request.getSession();
            long expireAtMs = System.currentTimeMillis() + (5 * 60 * 1000);

            session.setAttribute("certication_code", smsCode);
            session.setAttribute("pwdfind_cert_expire", expireAtMs);
            session.setAttribute("pwdfind_mobile", mobile);
            session.setAttribute("pwdfind_memberid", memberid);
            session.setAttribute("pwdfind_channel", "phone");

            writeJson(response, true, "SMS_SENT", "인증코드를 문자로 발송했습니다.", expireAtMs, "phone", memberid);
            return;
        }

        // 이메일 인증
        if (email.isEmpty()) {
            writeJson(response, false, "INVALID", "이메일을 입력하세요.", 0L, "email", memberid);
            return;
        }

        Map<String, String> paraMap = new HashMap<>();
        paraMap.put("memberid", memberid);
        paraMap.put("name", name);
        paraMap.put("email", email);

        boolean isUserExists = mdao.isUserExistsForPwdFindEmail(paraMap);
        if (!isUserExists) {
            writeJson(response, false, "NO_USER", "일치하는 회원정보가 없습니다.", 0L, "email", memberid);
            return;
        }

        String certCode = makeCertificationCode();
        boolean sent;

        try {
            GoogleMail mail = new GoogleMail();
            mail.send_certification_code(email, certCode);
            sent = true;
        } catch (Exception e) {
            e.printStackTrace();
            sent = false;
        }

        if (!sent) {
            writeJson(response, false, "MAIL_FAIL", "메일 전송에 실패했습니다.", 0L, "email", memberid);
            return;
        }

        HttpSession session = request.getSession();
        long expireAtMs = System.currentTimeMillis() + (5 * 60 * 1000);

        session.setAttribute("certication_code", certCode);
        session.setAttribute("pwdfind_cert_expire", expireAtMs);
        session.setAttribute("pwdfind_email", email);
        session.setAttribute("pwdfind_memberid", memberid);
        session.setAttribute("pwdfind_channel", "email");

        writeJson(response, true, "MAIL_SENT", "인증코드를 이메일로 발송했습니다.", expireAtMs, "email", memberid);
    }

    private String nvl(String s) {
        return (s == null) ? "" : s.trim();
    }

    private String makeCertificationCode() {
        Random rnd = new Random();
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < 5; i++) sb.append((char) (rnd.nextInt('z' - 'a' + 1) + 'a'));
        for (int i = 0; i < 5; i++) sb.append(rnd.nextInt(10));
        return sb.toString();
    }

    private String makeSmsCode6() {
        Random rnd = new Random();
        int n = rnd.nextInt(900000) + 100000;
        return String.valueOf(n);
    }

    private void writeJson(HttpServletResponse response,
                           boolean success,
                           String status,
                           String msg,
                           long expireAtMs,
                           String channel,
                           String memberid) throws Exception {

        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();

        msg = (msg == null) ? "" : msg.replace("\\", "\\\\").replace("\"", "\\\"");

        out.print("{");
        out.print("\"success\":" + success + ",");
        out.print("\"status\":\"" + status + "\",");
        out.print("\"msg\":\"" + msg + "\",");
        out.print("\"expireAtMs\":" + expireAtMs + ",");
        out.print("\"channel\":\"" + channel + "\",");
        out.print("\"memberid\":\"" + memberid + "\"");
        out.print("}");
        out.flush();
    }
}
