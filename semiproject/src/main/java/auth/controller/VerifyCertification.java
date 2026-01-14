package auth.controller;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class VerifyCertification extends AbstractController {

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

        userCertificationCode = (userCertificationCode == null) ? "" : userCertificationCode.trim();
        userid = (userid == null) ? "" : userid.trim();

        HttpSession session = request.getSession();

        // 발급한 인증번호
        String certication_code = (String) session.getAttribute("certication_code");

        // 만료시간(ms) - PwdFind에서 메일 발송 성공 시 세팅해야 함
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

        // 세션 대상 아이디 검증 (없으면 스킵 가능하지만, 있으면 반드시 체크 권장)
        if (sessionUserid != null && !sessionUserid.trim().isEmpty() && !userid.equals(sessionUserid)) {
            message = "인증 대상 정보가 일치하지 않습니다. 다시 비밀번호 찾기를 진행해주세요.";
            loc = request.getContextPath() + "/member/accountFind.hp";

            // 인증 관련 세션 정리
            session.removeAttribute("certication_code");
            session.removeAttribute("pwdfind_cert_expire");

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

            // 만료면 무조건 인증정보 폐기
            session.removeAttribute("certication_code");
            session.removeAttribute("pwdfind_cert_expire");

            request.setAttribute("message", message);
            request.setAttribute("loc", loc);
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        // 코드 일치 검사
        if (certication_code != null && certication_code.equals(userCertificationCode)) {

            // 인증 성공 플래그
            session.setAttribute("pwdfind_verified", true);
            session.setAttribute("pwdfind_verified_userid", userid);

            message = "인증성공 되었습니다. 임시비밀번호를 이메일로 발급합니다.";
            loc = request.getContextPath() + "/member/pwdUpdateEnd.hp?userid=" + userid;

            // 성공 시에도 인증정보 폐기
            session.removeAttribute("certication_code");
            session.removeAttribute("pwdfind_cert_expire");

        } else {
            message = "발급된 인증코드와 다릅니다.\\n인증코드를 확인하거나 인증코드를 다시 발급받아야 합니다.";
            loc = request.getContextPath() + "/member/accountFind.hp";

            session.removeAttribute("certication_code");
            session.removeAttribute("pwdfind_cert_expire");
        }

        request.setAttribute("message", message);
        request.setAttribute("loc", loc);

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/msg.jsp");
    }
}
