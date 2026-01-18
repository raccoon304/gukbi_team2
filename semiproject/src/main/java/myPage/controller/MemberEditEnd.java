package myPage.controller;

import java.util.HashMap;
import java.util.Map;
import java.util.regex.Pattern;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;
import member.model.MemberDAO;
import member.model.MemberDAO_imple;

public class MemberEditEnd extends AbstractController {

    private final MemberDAO mbDao = new MemberDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        if (!"POST".equalsIgnoreCase(request.getMethod())) {
            request.setAttribute("message", "비정상적인 접근입니다!");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        HttpSession session = request.getSession();
        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

        if (loginUser == null) {
            request.setAttribute("message", "로그인이 필요합니다.");
            request.setAttribute("loc", request.getContextPath() + "/index.hp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        // memberid는 세션(loginUser)에서 가져옴
        String memberid = loginUser.getMemberid();

        String name   = request.getParameter("name");
        String email  = request.getParameter("email");
        String mobile = request.getParameter("mobile");
        String password = request.getParameter("password");
        String passwordChk = request.getParameter("passwordChk");

        name   = (name == null) ? "" : name.trim();
        email  = (email == null) ? "" : email.trim();
        mobile = (mobile == null) ? "" : mobile.trim();
        password = (password == null) ? "" : password.trim();
        passwordChk = (passwordChk == null) ? "" : passwordChk.trim();

        // 공란 방지용
        if (name.isEmpty() || email.isEmpty() || mobile.isEmpty()) {
            request.setAttribute("message", "성명/이메일/전화번호는 필수 입력입니다.");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        // 뷰단과 동일하게 유효성 검사 한번더 
        if (!Pattern.matches("^[가-힣a-zA-Z]+$", name)) {
            request.setAttribute("message", "성명은 한글 또는 영문자만 입력 가능합니다.");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        if (!Pattern.matches("^010\\d{8}$", mobile)) {
            request.setAttribute("message", "전화번호는 010으로 시작하는 11자리 숫자만 가능합니다.");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        if (!Pattern.matches("^[0-9a-zA-Z]([-_\\.]*[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\\.]*[0-9a-zA-Z])*\\.[a-zA-Z]{2,}$", email)) {
            request.setAttribute("message", "이메일 형식이 올바르지 않습니다.");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        // 비밀번호 변경 여부 판단
        boolean changePw = !password.isEmpty();

        if (changePw) {
            // 8~15, 대/소문자/숫자/특수문자 포함
            if (!Pattern.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[^\\w\\s]).{8,15}$", password)) {
                request.setAttribute("message", "비밀번호는 8~15자이며, 영문 대/소문자, 숫자, 특수문자를 모두 포함해야 합니다.");
                request.setAttribute("loc", "javascript:history.back()");
                super.setRedirect(false);
                super.setViewPage("/WEB-INF/msg.jsp");
                return;
            }

            if (passwordChk.isEmpty()) {
                request.setAttribute("message", "비밀번호 확인을 입력해주세요.");
                request.setAttribute("loc", "javascript:history.back()");
                super.setRedirect(false);
                super.setViewPage("/WEB-INF/msg.jsp");
                return;
            }

            if (!password.equals(passwordChk)) {
                request.setAttribute("message", "비밀번호가 일치하지 않습니다.");
                request.setAttribute("loc", "javascript:history.back()");
                super.setRedirect(false);
                super.setViewPage("/WEB-INF/msg.jsp");
                return;
            }
        } else {
            // 비번은 비었는데 확인만 들어온 경우 방지
            if (!passwordChk.isEmpty()) {
                request.setAttribute("message", "비밀번호를 변경하려면 비밀번호도 함께 입력해주세요.");
                request.setAttribute("loc", "javascript:history.back()");
                super.setRedirect(false);
                super.setViewPage("/WEB-INF/msg.jsp");
                return;
            }
        }

        Map<String, String> paraMap = new HashMap<>();
        paraMap.put("memberid", memberid);
        paraMap.put("name", name);
        paraMap.put("email", email);
        paraMap.put("mobile", mobile);

        // 비밀번호는 입력했을때만 전송
        if (changePw) {
            paraMap.put("password", password);
        }

        int n = mbDao.updateMember(paraMap);

        if (n == 1) {
            loginUser.setName(name);
            loginUser.setEmail(email);
            loginUser.setMobile(mobile);
            session.setAttribute("loginUser", loginUser);

            request.setAttribute("message", "정보수정 되었습니다.");
            request.setAttribute("loc", request.getContextPath() + "/myPage/myPage.hp");
        } else {
            request.setAttribute("message", "정보수정에 실패하였습니다.");
            request.setAttribute("loc", "javascript:history.back()");
        }

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/msg.jsp");
    }
}
