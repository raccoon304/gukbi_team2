package member.controller;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import member.model.MemberDAO;
import member.model.MemberDAO_imple;

public class IdFind extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        // GET인경우 
        if ("GET".equalsIgnoreCase(request.getMethod())) {
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/member_YD/accountFind.jsp");
            return;
        }

        // POST
        String findType = request.getParameter("idFindType"); // email 또는 phone
        findType = (findType == null || findType.trim().isEmpty()) ? "email" : findType.trim();

        String name = request.getParameter("name");
        name = (name == null) ? "" : name.trim();

        // 입력값 유지용
        request.setAttribute("searchedName", name);
        request.setAttribute("selectedIdFindType", findType);

        if (name.isEmpty()) {
            request.setAttribute("errorMsg", "성명을 입력하세요.");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/member_YD/idFind.jsp"); // 결과페이지에 실패
            return;
        }

        MemberDAO dao = new MemberDAO_imple();

        String memberId = null;

        // 이름 + 휴대폰 조합인 경우
        if ("phone".equalsIgnoreCase(findType)) {

            String mobile = request.getParameter("mobile");
            mobile = (mobile == null) ? "" : mobile.trim();
            mobile = mobile.replaceAll("\\D", ""); // 숫자만

            request.setAttribute("searchedMobile", mobile);

            if (mobile.isEmpty()) {
                request.setAttribute("errorMsg", "휴대폰 번호를 입력하세요.");
                super.setRedirect(false);
                super.setViewPage("/WEB-INF/member_YD/idFind.jsp");
                return;
            }

            // 길이 체크(필요 시 조정)
            if (!(mobile.length() == 10 || mobile.length() == 11)) {
                request.setAttribute("errorMsg", "휴대폰 번호 형식이 올바르지 않습니다.");
                super.setRedirect(false);
                super.setViewPage("/WEB-INF/member_YD/idFind.jsp");
                return;
            }

            memberId = dao.findMemberIdByNameAndMobile(name, mobile);

        // 이름 + 이메일 조합인 경우
        } else { 

            String email = request.getParameter("email");
            email = (email == null) ? "" : email.trim();

            request.setAttribute("searchedEmail", email);

            if (email.isEmpty()) {
                request.setAttribute("errorMsg", "이메일을 입력하세요.");
                super.setRedirect(false);
                super.setViewPage("/WEB-INF/member_YD/idFind.jsp");
                return;
            }

            memberId = dao.findMemberIdByNameAndEmail(name, email);
        }

        if (memberId == null) {
            request.setAttribute("errorMsg", "일치하는 회원정보가 없습니다.");
        } else {
            request.setAttribute("maskedMemberId", maskMemberId(memberId));
        }

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/member_YD/idFind.jsp");
    }

    private String maskMemberId(String memberId) {
        if (memberId == null) return null;

        int len = memberId.length();

        if (len <= 1) return "*";
        if (len == 2) return memberId.charAt(0) + "*";
        if (len == 3) return memberId.substring(0, 1) + "*" + memberId.substring(2);
        if (len == 4) return memberId.substring(0, 2) + "**";

        String front = memberId.substring(0, 2);
        String back = memberId.substring(len - 2);
        String stars = "*".repeat(len - 4);

        return front + stars + back;
    }
}
