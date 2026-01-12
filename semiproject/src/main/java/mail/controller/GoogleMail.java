package mail.controller;

import java.util.Properties;

import javax.mail.Address;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;

import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

public class GoogleMail {

    // 공통 SMTP 세션 생성, 여기서는 SMTP는 안쓸듯? 
    private Session getSession() {
        Properties prop = new Properties();

        // SMTP 서버 정보
        prop.put("mail.smtp.host", "smtp.gmail.com");
        prop.put("mail.smtp.port", "465");

        // 인증 및 SSL
        prop.put("mail.smtp.auth", "true");
        prop.put("mail.smtp.debug", "true");

        prop.put("mail.smtp.socketFactory.port", "465");
        prop.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
        prop.put("mail.smtp.socketFactory.fallback", "false");

        prop.put("mail.smtp.ssl.enable", "true");
        prop.put("mail.smtp.ssl.trust", "smtp.gmail.com");
        prop.put("mail.smtp.ssl.protocols", "TLSv1.2");

        // 465(SSL) 사용 중이면 starttls는 사실상 필요 없음
        // 그래도 환경 따라 요구되는 경우가 있어 유지 가능
        prop.put("mail.smtp.starttls.enable", "true");

        Authenticator smtpAuth = new MySMTPAuthenticator();
        Session ses = Session.getInstance(prop, smtpAuth);

        // 디버그 출력
        ses.setDebug(true);

        return ses;
    }

    // 공통 => 메일 전송 (text + html 같이)
    private void sendMail(String recipient, String subject, String plainText, String html) throws Exception {
        Session ses = getSession();

        MimeMessage msg = new MimeMessage(ses);

        // 제목
        msg.setSubject(subject, "UTF-8");

        // 보내는 사람  인증된 계정과 동일하게 맞춤
        // MySMTPAuthenticator가 어떤 계정으로 로그인하는지에 맞춰서 from도 동일하게 해줘야 스팸/차단 위험이 줄어듦
        String sender = "sistsix0376@gmail.com"; // <-- 여기 계정이 실제 로그인 계정과 같아야 함
        Address fromAddr = new InternetAddress(sender);
        msg.setFrom(fromAddr);

        Address toAddr = new InternetAddress(recipient);
        msg.addRecipient(Message.RecipientType.TO, toAddr);

        // text/plain + text/html 같이 보내기 (네이버 스팸 완화에 도움)
        MimeMultipart multipart = new MimeMultipart("alternative");

        MimeBodyPart textPart = new MimeBodyPart();
        textPart.setText(plainText, "UTF-8");
        multipart.addBodyPart(textPart);

        MimeBodyPart htmlPart = new MimeBodyPart();
        htmlPart.setContent(html, "text/html; charset=UTF-8");
        multipart.addBodyPart(htmlPart);

        msg.setContent(multipart);

        Transport.send(msg);
    }

    // 인증코드 발송
    public void send_certification_code(String recipient, String certification_code) throws Exception {

        String subject = "[비밀번호 찾기] 이메일 인증코드 안내";

        String plainText =
                "비밀번호 찾기 이메일 인증코드 안내\n\n" +
                "인증코드: " + certification_code + "\n" +
                "인증코드는 5분 이내에만 유효합니다.\n" +
                "본 메일을 요청하지 않으셨다면 무시해 주세요.";

        String html =
            "<div style='max-width:480px; margin:0 auto; padding:30px; " +
            "font-family:Arial, sans-serif; background-color:#f9f9f9; border-radius:10px;'>" +
            "<h2 style='color:#333; text-align:center;'>🔐 이메일 인증 안내</h2>" +
            "<p style='font-size:15px; color:#555; line-height:1.6;'>" +
            "안녕하세요 😊<br><br>" +
            "요청하신 이메일 인증을 진행하기 위해 아래 인증코드를 입력해 주세요." +
            "</p>" +
            "<div style='margin:30px 0; text-align:center;'>" +
            "  <span style='display:inline-block; padding:15px 25px; " +
            "  font-size:22px; font-weight:bold; color:#ffffff; " +
            "  background-color:#ff6b6b; border-radius:8px; letter-spacing:3px;'>" +
                 certification_code +
            "  </span>" +
            "</div>" +
            "<p style='font-size:14px; color:#777;'>" +
            "※ 인증코드는 <strong>5분 이내</strong>에만 유효합니다.<br>" +
            "본 메일을 요청하지 않으셨다면 안전하게 무시해 주세요." +
            "</p>" +
            "<hr style='border:none; border-top:1px solid #ddd; margin:25px 0;'>" +
            "<p style='font-size:12px; color:#aaa; text-align:center;'>" +
            "© 2025 MyMVC Name. All rights reserved." +
            "</p>" +
            "</div>";

        sendMail(recipient, subject, plainText, html);
    }

    // 임시비밀번호 발급 메일 발송 
    public void send_temp_password(String recipient, String tempPwd) throws Exception {

        String subject = "[비밀번호 찾기] 임시 비밀번호 발급 안내";

        String plainText =
                "임시 비밀번호가 발급되었습니다.\n\n" +
                "임시 비밀번호: " + tempPwd + "\n\n" +
                "로그인 후 반드시 비밀번호를 변경해 주세요.\n" +
                "본 메일을 요청하지 않으셨다면 무시해 주세요.";

        String html =
            "<div style='max-width:480px; margin:0 auto; padding:30px; " +
            "font-family:Arial, sans-serif; background-color:#f9f9f9; border-radius:10px;'>" +
            "<h2 style='color:#333; text-align:center;'>🔑 임시 비밀번호 발급 안내</h2>" +
            "<p style='font-size:15px; color:#555; line-height:1.6;'>" +
            "안녕하세요 😊<br><br>" +
            "요청하신 <strong>임시 비밀번호</strong>가 발급되었습니다." +
            "</p>" +
            "<div style='margin:30px 0; text-align:center;'>" +
            "  <span style='display:inline-block; padding:15px 25px; " +
            "  font-size:22px; font-weight:bold; color:#ffffff; " +
            "  background-color:#3b82f6; border-radius:8px; letter-spacing:2px;'>" +
                 tempPwd +
            "  </span>" +
            "</div>" +
            "<p style='font-size:14px; color:#777;'>" +
            "로그인 후 <strong>반드시 비밀번호를 변경</strong>해 주세요.<br>" +
            "본 메일을 요청하지 않으셨다면 안전하게 무시해 주세요." +
            "</p>" +
            "<hr style='border:none; border-top:1px solid #ddd; margin:25px 0;'>" +
            "<p style='font-size:12px; color:#aaa; text-align:center;'>" +
            "© 2025 MyMVC Name. All rights reserved." +
            "</p>" +
            "</div>";

        sendMail(recipient, subject, plainText, html);
    }
}
