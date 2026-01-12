package delivery.controller;

import java.util.List;

import common.controller.AbstractController;
import delivery.domain.DeliveryDTO;
import delivery.model.DeliveryDAO;
import delivery.model.DeliveryDAO_imple;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;

public class Delivery extends AbstractController {

	private DeliveryDAO dDao = new DeliveryDAO_imple(); 

	@Override
  	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

  		HttpSession session = request.getSession();
  		MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

  		if (loginUser == null) {
  			request.setAttribute("message", "로그인이 필요합니다.");
  			request.setAttribute("loc", request.getContextPath() + "/index.hp");
  			super.setRedirect(false);
  			super.setViewPage("/WEB-INF/msg.jsp");
  			return;
  		}

  		String memberid = loginUser.getMemberid();
  		
  		
  		// 배송지 목록 조회
  		List<DeliveryDTO> deliveryList = dDao.selectDeliveryList(memberid);

  		request.setAttribute("memberInfo", loginUser);
  		request.setAttribute("deliveryList", deliveryList);

  		super.setRedirect(false);
  		super.setViewPage("/WEB-INF/myPage_YD/delivery.jsp"); 
  		
  		
  		
  	}
	
	
}