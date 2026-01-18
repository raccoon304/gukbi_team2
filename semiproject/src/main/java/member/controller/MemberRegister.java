package member.controller;

import java.sql.SQLException;

import common.controller.AbstractController;
import delivery.domain.DeliveryDTO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import member.domain.MemberDTO;
import member.model.MemberDAO;
import member.model.MemberDAO_imple;

public class MemberRegister extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String method = request.getMethod();
		MemberDAO mdao = new MemberDAO_imple();
		
		
		if("GET".equalsIgnoreCase(method)) {
			super.setRedirect(false);
			super.setViewPage("/WEB-INF/member_YD/memberRegister.jsp");
		}
		else{ //POST로 들어온 경우 
			String memberid = request.getParameter("memberid");
			String name = request.getParameter("name");
			String password = request.getParameter("password");
			String mobile = request.getParameter("mobile");
			String email= request.getParameter("email");
			String birthday = request.getParameter("birthday");
			String gender_str = request.getParameter("gender");
			int gender = 0;
			
			String address = request.getParameter("address");
			String addressDetail = request.getParameter("addressDetail");
			String postalCode = request.getParameter("postalCode");
			
			// ===== 서버단 유효성 검사 시작 =====
			memberid = (memberid == null) ? "" : memberid.trim();
			name     = (name == null) ? "" : name.trim();
			email    = (email == null) ? "" : email.trim();
			birthday = (birthday == null) ? "" : birthday.trim();
			password = (password == null) ? "" : password; 
			mobile   = (mobile == null) ? "" : mobile.replaceAll("[^0-9]", ""); 
			gender_str = (gender_str == null) ? "" : gender_str.trim();

			address = (address == null) ? "" : address.trim();
			addressDetail = (addressDetail == null) ? "" : addressDetail.trim();
			postalCode = (postalCode == null) ? "" : postalCode.trim();

			// 필수값 체크
			if (memberid.isEmpty() || name.isEmpty() || password.isEmpty() || mobile.isEmpty()
					|| email.isEmpty() || birthday.isEmpty() || gender_str.isEmpty()
					|| address.isEmpty() || addressDetail.isEmpty() || postalCode.isEmpty()) {

				request.setAttribute("message", "필수 입력값이 누락되었습니다.");
				request.setAttribute("loc", "javascript:history.back()");
				super.setRedirect(false);
				super.setViewPage("/WEB-INF/msg.jsp");
				return;
			}

			// DB 길이 확인용
			if (memberid.length() > 40 || name.length() > 30 || email.length() > 200 || birthday.length() != 10) {
				request.setAttribute("message", "입력값 길이가 올바르지 않습니다.");
				request.setAttribute("loc", "javascript:history.back()");
				super.setRedirect(false);
				super.setViewPage("/WEB-INF/msg.jsp");
				return;
			}

			// 형식 체크
			if (!memberid.matches("^[a-zA-Z][a-zA-Z0-9_]{3,39}$")) {
				request.setAttribute("message", "아이디 형식이 올바르지 않습니다.");
				request.setAttribute("loc", "javascript:history.back()");
				super.setRedirect(false);
				super.setViewPage("/WEB-INF/msg.jsp");
				return;
			}

			if (!name.matches("^[가-힣a-zA-Z]+$")) {
				request.setAttribute("message", "성명 형식이 올바르지 않습니다.");
				request.setAttribute("loc", "javascript:history.back()");
				super.setRedirect(false);
				super.setViewPage("/WEB-INF/msg.jsp");
				return;
			}

			if (!mobile.matches("^010\\d{8}$")) {
				request.setAttribute("message", "전화번호 형식이 올바르지 않습니다.");
				request.setAttribute("loc", "javascript:history.back()");
				super.setRedirect(false);
				super.setViewPage("/WEB-INF/msg.jsp");
				return;
			}

			if (!email.matches("^[0-9a-zA-Z]([-_\\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\\.]?[0-9a-zA-Z])*\\.[a-zA-Z]{2,}$")) {
				request.setAttribute("message", "이메일 형식이 올바르지 않습니다.");
				request.setAttribute("loc", "javascript:history.back()");
				super.setRedirect(false);
				super.setViewPage("/WEB-INF/msg.jsp");
				return;
			}

			if (!birthday.matches("^\\d{4}-\\d{2}-\\d{2}$")) {
				request.setAttribute("message", "생년월일 형식이 올바르지 않습니다.");
				request.setAttribute("loc", "javascript:history.back()");
				super.setRedirect(false);
				super.setViewPage("/WEB-INF/msg.jsp");
				return;
			}
			// 오늘/미래 날짜 선택 불가 (오늘 포함)
			try {
				java.time.LocalDate birthDate = java.time.LocalDate.parse(birthday);
				java.time.LocalDate today = java.time.LocalDate.now();

				if (!birthDate.isBefore(today)) { // birthDate가 오늘보다 크거나 같을경우
					request.setAttribute("message", "생년월일은 오늘 및 미래 날짜로 선택할 수 없습니다.");
					request.setAttribute("loc", "javascript:history.back()");
					super.setRedirect(false);
					super.setViewPage("/WEB-INF/msg.jsp");
					return;
				}
			} catch (Exception ex) {
				request.setAttribute("message", "생년월일 값이 올바르지 않습니다.");
				request.setAttribute("loc", "javascript:history.back()");
				super.setRedirect(false);
				super.setViewPage("/WEB-INF/msg.jsp");
				return;
			}

			if (!password.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[^\\w\\s]).{8,15}$")) {
				request.setAttribute("message", "비밀번호 형식이 올바르지 않습니다.");
				request.setAttribute("loc", "javascript:history.back()");
				super.setRedirect(false);
				super.setViewPage("/WEB-INF/msg.jsp");
				return;
			}

			// 성별 값 검증 + 변환
			if ("female".equals(gender_str)) {
				gender = 1;
			}
			else if ("male".equals(gender_str)) {
				gender = 0;
			}
			else {
				request.setAttribute("message", "성별 값이 올바르지 않습니다.");
				request.setAttribute("loc", "javascript:history.back()");
				super.setRedirect(false);
				super.setViewPage("/WEB-INF/msg.jsp");
				return;
			}
			// ===== 서버단 유효성 검사끝 =====
			
			/*
			 * System.out.println(memberid); System.out.println(name);
			 * System.out.println(password); System.out.println(mobile);
			 * System.out.println(email); System.out.println(birthday);
			 * System.out.println(gender); System.out.println(address);
			 * System.out.println(addressDetail); System.out.println(postalCode);
			 */
			MemberDTO mbrDto = new MemberDTO();
			mbrDto.setMemberid(memberid);
			mbrDto.setName(name);
			mbrDto.setPassword(password);
			mbrDto.setMobile(mobile);
			mbrDto.setEmail(email);
			mbrDto.setBirthday(birthday);
			mbrDto.setGender(gender);
			
			DeliveryDTO devDto = new DeliveryDTO();
			devDto.setMemberId(memberid);
			devDto.setRecipientName(name);
			devDto.setRecipientPhone(mobile);
			devDto.setIsDefault(1);
			devDto.setAddress(address);
			devDto.setAddressDetail(addressDetail);
			devDto.setPostalCode(postalCode);
			devDto.setAddressName("기본배송지");
			
			// ==== 회원가입이 성공되어지면 회원가입 성공 이라는 alert를 띄우고 시작페이지로 이동 ==== //
			String message = ""; 
			String loc = ""; 
						
			try {
				int n = mdao.registerMember(mbrDto, devDto);	
				if(n==2) {
					message = "회원가입 성공";
					loc = request.getContextPath()+"/index.hp";
				}
			} catch (SQLException e) {
				e.printStackTrace();
				message = "회원가입 실패";
				loc= "javascript:history.back()";
			}
				
			request.setAttribute("message", message);
			request.setAttribute("loc", loc);
			
			super.setRedirect(false);
			super.setViewPage("/WEB-INF/msg.jsp");		
			
			
			
			
			
			
			
		}
	}
}
