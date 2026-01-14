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

	        
	        // ================================ 휴면계정 인증 필요시 인증코드 생성 및 발송 ================================ 
	        String certCode = request.getParameter("certCode");
	        certCode = (certCode == null) ? "" : certCode.trim();

	        String savedCode = (String) session.getAttribute("dormant_cert_code");
	        Long expireMs = (Long) session.getAttribute("dormant_cert_expire");

	        if (savedCode == null || expireMs == null) {
	            request.setAttribute("message", "인증번호 발송 후 다시 시도해주세요.");
	            request.setAttribute("loc", request.getContextPath() + "/member/dormantUnlock.hp");
	            super.setRedirect(false);
	            super.setViewPage("/WEB-INF/msg.jsp");
	            return;
	        }

	        if (System.currentTimeMillis() > expireMs) {
	            session.removeAttribute("dormant_cert_code");
	            session.removeAttribute("dormant_cert_expire");

	            request.setAttribute("message", "인증번호가 만료되었습니다. 다시 발급받아주세요.");
	            request.setAttribute("loc", request.getContextPath() + "/member/dormantUnlock.hp");
	            super.setRedirect(false);
	            super.setViewPage("/WEB-INF/msg.jsp");
	            return;
	        }

	        if (!savedCode.equals(certCode)) {
	            request.setAttribute("message", "인증번호가 올바르지 않습니다.");
	            request.setAttribute("loc", request.getContextPath() + "/member/dormantUnlock.hp");
	            super.setRedirect(false);
	            super.setViewPage("/WEB-INF/msg.jsp");
	            return;
	        }
	        // ================================ 휴면계정 인증 필요시 인증코드 생성 및 발송 끝 ================================ 

	        // 인증 성공했으면 인증정보는 삭제
	        session.removeAttribute("dormant_cert_code");
	        session.removeAttribute("dormant_cert_expire");
	        
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
