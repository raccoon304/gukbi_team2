package auth.controller;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;
import member.model.MemberDAO;
import member.model.MemberDAO_imple;

public class MemberWithdraw extends AbstractController {
	 private final MemberDAO mDao = new MemberDAO_imple();

	 @Override
	 public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		 HttpSession session = request.getSession();
		 MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
		 
		 // 로그인 체크
		 if (loginUser == null) {
			 request.setAttribute("message", "로그인 후 이용 가능합니다.");
			 request.setAttribute("loc", request.getContextPath() + "/index.hp");
			 super.setRedirect(false);
			 super.setViewPage("/WEB-INF/msg.jsp");
			 return;
		 }

		 // GET 차단
		 if (!"POST".equalsIgnoreCase(request.getMethod())) {
			 request.setAttribute("message", "비정상적인 접근입니다.");
			 request.setAttribute("loc", "javascript:history.back()");
			 super.setRedirect(false);
			 super.setViewPage("/WEB-INF/msg.jsp");
			 return;
		 }
		 
		 String memberId = loginUser.getMemberid();

		 int n = mDao.updateMemberStatusWithdraw(memberId); // status=1
		 
		 
		 if (n == 1) {
			 // 탈퇴 성공 , 세션 종료(로그아웃)
			 session.invalidate();

			 request.setAttribute("message", "회원 탈퇴가 완료되었습니다.");
			 request.setAttribute("loc", request.getContextPath() + "/index.hp");
		 } else {
			 request.setAttribute("message", "회원 탈퇴 처리에 실패했습니다. 이미 탈퇴했거나 오류가 발생했습니다.");
			 request.setAttribute("loc", request.getContextPath() + "/myPage/myPage.hp");
		 }

		 super.setRedirect(false);
		 super.setViewPage("/WEB-INF/msg.jsp");
	 }
}
