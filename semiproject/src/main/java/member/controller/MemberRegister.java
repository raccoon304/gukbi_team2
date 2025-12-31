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
			
			if(gender_str.equals("female")) {
				gender = 1;
			}
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
