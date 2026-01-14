package auth.controller;

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

public class PwdFind extends AbstractController {

    private MemberDAO mdao = new MemberDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        String method = request.getMethod();

        // 탭 유지
        // accountFind.jsp로 다시 포워드 됐을 때도 비밀번호 찾기 탭이 계속 선택된 상태로 보이게 하기위함
        request.setAttribute("activeTab", "pwd");

        if ("GET".equalsIgnoreCase(method)) {
            request.setAttribute("pwd_posted", false);
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/member_YD/accountFind.jsp");
            return;
        }

        request.setAttribute("pwd_posted", true);

        String pwdFindType = request.getParameter("pwdFindType"); // 결과 => email 또는  phone
        pwdFindType = (pwdFindType == null || pwdFindType.trim().isEmpty()) ? "email" : pwdFindType.trim();

        // 입력값
        String memberid = request.getParameter("memberid");
        String name     = request.getParameter("name");
        String email    = request.getParameter("email");

        memberid = (memberid == null) ? "" : memberid.trim();
        name     = (name == null) ? "" : name.trim();
        email    = (email == null) ? "" : email.trim();

        // 화면 유지용 입력값 유지
        request.setAttribute("pwdFindType", pwdFindType.toLowerCase());
        request.setAttribute("pwd_memberid", memberid);
        request.setAttribute("pwd_name", name);
        request.setAttribute("pwd_email", email);

        // 상태를 하나로만 결정 뷰단에서 이 값만 보고 1개 메시지만 출력하면 되게 구성
        String pwd_status = "UNKNOWN";

        // 지금은 이메일만 구현
        if (!"email".equalsIgnoreCase(pwdFindType)) { // 개발 해야됨.
            pwd_status = "NOT_READY";
            applyCompatFlags(request, false, false, pwd_status);
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/member_YD/accountFind.jsp");
            return;
        }

        // 유효성
        if (memberid.isEmpty() || name.isEmpty() || email.isEmpty()) {
            pwd_status = "INVALID";
            applyCompatFlags(request, false, false, pwd_status);
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/member_YD/accountFind.jsp");
            return;
        }

        // 입력한 정보랑 맞는게 있는지 검사 
        Map<String, String> paraMap = new HashMap<>();
        paraMap.put("memberid", memberid);
        paraMap.put("name", name);
        paraMap.put("email", email);

        boolean isUserExists = mdao.isUserExistsForPwdFindEmail(paraMap);
        System.out.println("isUserExists : " + isUserExists);

        if (!isUserExists) {
            pwd_status = "NO_USER";
            applyCompatFlags(request, false, false, pwd_status);
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/member_YD/accountFind.jsp");
            return;
        }

        // 인증코드 생성(영문소문자 5 + 숫자 5)
        String certication_code = makeCertificationCode();

        boolean sendMailSuccess = false;
        try {
            GoogleMail mail = new GoogleMail();
            mail.send_certification_code(email, certication_code);
            sendMailSuccess = true;

            HttpSession session = request.getSession();
            session.setAttribute("certication_code", certication_code);

            // 인증 성공 후(VerifyCertification) 비번재설정/임시비번 발송 등에 사용할 값들
            session.setAttribute("pwdfind_email", email);
            session.setAttribute("pwdfind_memberid", memberid);

            // !!!!!! 만료 시간 관리인데, 개발 예정임 
            // session.setAttribute("pwdfind_cert_time", System.currentTimeMillis());

        } catch (Exception e) {
            e.printStackTrace();
            sendMailSuccess = false;
        }

        pwd_status = sendMailSuccess ? "MAIL_SENT" : "MAIL_FAIL";
        applyCompatFlags(request, true, sendMailSuccess, pwd_status);

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/member_YD/accountFind.jsp");
    }

    // 인증코드 생성: 영문소문자 5 + 숫자 5
    private String makeCertificationCode() {
        Random rnd = new Random();
        StringBuilder sb = new StringBuilder();

        for (int i = 0; i < 5; i++) {
            char randchar = (char) (rnd.nextInt('z' - 'a' + 1) + 'a');
            sb.append(randchar);
        }
        for (int i = 0; i < 5; i++) {
            int randnum = rnd.nextInt(10);
            sb.append(randnum);
        }
        return sb.toString();
    }

    // 기존 JSP가 아직 pwd_isUserExists / pwd_sendMailSuccess 를 쓰고 있어도 깨지지 않게 호환용 플래그를 같이 내려줌
    private void applyCompatFlags(HttpServletRequest request, boolean isUserExists, boolean sendMailSuccess, String pwd_status) {
        request.setAttribute("pwd_status", pwd_status);

        // 기존에 쓰던 값(호환)
        request.setAttribute("pwd_isUserExists", isUserExists);
        request.setAttribute("pwd_sendMailSuccess", sendMailSuccess);
    }
}
