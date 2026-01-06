package myPage.controller;

import java.util.HashMap;
import java.util.Map;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;
import member.model.MemberDAO;
import member.model.MemberDAO_imple;

public class MemberEdit extends AbstractController {

    private MemberDAO mbDao = new MemberDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        String method = request.getMethod();

        // POST로만 처리(너 요구사항 유지)
        if ("GET".equalsIgnoreCase(method)) {
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

        // ===== 본인 수정 검증 =====
        // 폼에서 memberid를 보내도 되고( hidden ), 안 보내면 세션값 사용(권장)
        String memberid = request.getParameter("memberid");
        if (memberid == null || memberid.trim().isEmpty()) {
            memberid = loginUser.getMemberid();
        }

        if (!loginUser.getMemberid().equals(memberid)) {
            request.setAttribute("message", "다른 사용자의 정보를 수정하는것은 불가합니다.");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        // ===== 폼 표시 vs 저장 처리 분기 =====
        String name   = request.getParameter("name");
        String email  = request.getParameter("email");
        String mobile = request.getParameter("mobile");

        boolean isShowForm = (name == null && email == null && mobile == null);

        // (1) 수정폼 보여주기
        if (isShowForm) {
            request.setAttribute("memberInfo", loginUser);
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/member_YD/memberEdit.jsp"); // 너가 만든 수정폼 JSP
            return;
        }

        // (2) 저장 처리
        Map<String, String> paraMap = new HashMap<>();
        paraMap.put("memberid", memberid);
        paraMap.put("name", name);
        paraMap.put("email", email);
        paraMap.put("mobile", mobile);

        int n = mbDao.updateMember(paraMap);

        if (n == 1) {
            // ✅ 세션 갱신(간단): 세션 객체 값 업데이트
            loginUser.setName(name);
            loginUser.setEmail(email);
            loginUser.setMobile(mobile); // 주의: DTO mobile이 평문 기준이면 OK
            session.setAttribute("loginUser", loginUser);

            request.setAttribute("message", "정보수정 되었습니다.");
            request.setAttribute("loc", request.getContextPath() + "/myPage/myPage.hp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
        } else {
            request.setAttribute("message", "정보수정에 실패하였습니다.");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
        }
    }
}
