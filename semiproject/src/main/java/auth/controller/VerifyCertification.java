package auth.controller;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class VerifyCertification extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		String method = request.getMethod();

		if ("POST".equalsIgnoreCase(method)) {
			// 회원이 입력한 인증번호 값 
			String userCertificationCode = request.getParameter("userCertificationCode");
			String userid = request.getParameter("userid");

			userCertificationCode = (userCertificationCode == null) ? "" : userCertificationCode.trim();
			userid = (userid == null) ? "" : userid.trim();

			HttpSession session = request.getSession();
			// 발급한 인증번호 
			String certication_code = (String) session.getAttribute("certication_code");
			//System.out.println("서티피케이션 코드 :"+certication_code);
			
			String message = "";
			String loc = "";

			if (certication_code != null && certication_code.equals(userCertificationCode)) {
				 //세션에 인증을 성공했다는 세션 플래그를 같이 보내버림 ( 인증코드 입력을 안해도 get으로 보내버려서 주소 치면 DB비밀번호가 바뀔 가능성이있음...)
				 session.setAttribute("pwdfind_verified", true);
				 session.setAttribute("pwdfind_verified_userid", userid);
				 
				 message = "인증성공 되었습니다. 임시비밀번호를 이메일로 발급합니다.";
				 loc = request.getContextPath() + "/member/pwdUpdateEnd.hp?userid=" + userid;
				
			} else {
				message = "발급된 인증코드와 다릅니다.\\n인증코드를 확인하거나 인증코드를 다시 발급받아야 합니다.";
				loc = request.getContextPath() + "/member/accountFind.hp";
			}

			request.setAttribute("message", message);
			request.setAttribute("loc", loc);

			super.setRedirect(false);
			super.setViewPage("/WEB-INF/msg.jsp");

			// 세션 인증코드 삭제
			session.removeAttribute("certication_code");
		}

	}

}
