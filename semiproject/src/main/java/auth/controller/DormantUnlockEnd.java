package auth.controller;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;
import member.model.MemberDAO;
import member.model.MemberDAO_imple;

public class DormantUnlockEnd extends AbstractController {

	 private final MemberDAO mDao = new MemberDAO_imple();

	    @Override
	    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

	        // POST만 허용
	        if (!"POST".equalsIgnoreCase(request.getMethod())) {
	            request.setAttribute("message", "비정상적인 접근입니다.");
	            request.setAttribute("loc", request.getContextPath() + "/index.hp");

	            super.setRedirect(false);
	            super.setViewPage("/WEB-INF/msg.jsp");
	            return;
	        }

	        HttpSession session = request.getSession();

	        // 휴면시 임시 정보를 받아오게됨. 
	        String dormantMemberId = (String) session.getAttribute("dormantMemberId");
	        MemberDTO dormantLoginUser = (MemberDTO) session.getAttribute("dormantLoginUser");

	        if (dormantMemberId == null || dormantLoginUser == null) {
	            request.setAttribute("message", "휴면 해제 정보가 만료되었습니다. 다시 로그인 해주세요.");
	            request.setAttribute("loc", request.getContextPath() + "/index.hp");

	            super.setRedirect(false);
	            super.setViewPage("/WEB-INF/msg.jsp");
	            return;
	        }

	        int n = mDao.unlockDormant(dormantMemberId); // idle=0 + last_login_ymd 오늘로 갱신

	        if (n == 1) {

	            // 로그인 처리(휴면 해제 완료 후 바로 로그인 상태로)
	            dormantLoginUser.setIdle(0);

	            // lastLogin도 오늘 날짜로 맞춤
	            String todayYmd = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
	            dormantLoginUser.setLastLogin(todayYmd);

	            session.setAttribute("loginUser", dormantLoginUser);

	            // 임시 세션값 제거
	            session.removeAttribute("dormantMemberId");
	            session.removeAttribute("dormantLoginUser");

	            request.setAttribute("message", "휴면 해제가 완료되었습니다. 다시 이용 가능합니다.");
	            request.setAttribute("loc", request.getContextPath() + "/index.hp");
	        }
	        else {
	            request.setAttribute("message", "휴면 해제에 실패했습니다. 다시 시도해주세요.");
	            request.setAttribute("loc", request.getContextPath() + "/index.hp");
	        }

	        super.setRedirect(false);
	        super.setViewPage("/WEB-INF/msg.jsp");
	    }

}
