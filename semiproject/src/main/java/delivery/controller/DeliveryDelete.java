package delivery.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import common.controller.AbstractController;
import delivery.domain.DeliveryDTO;
import delivery.model.DeliveryDAO;
import delivery.model.DeliveryDAO_imple;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;

public class DeliveryDelete extends AbstractController {
	DeliveryDAO dDao = new DeliveryDAO_imple();
	
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
  		
  		String[] selectAddId = request.getParameterValues("deliveryAddressId");
		/*
		 * System.out.println(ids.length);  1 개 체크시 1 
		 * System.out.println(ids[0]); delivery_address_id가 나옴.
		 */
  		Map<String, String> paraMap = new HashMap<>();
  		
  		paraMap.put("memberid", memberid);
  		
  		for(int i=0; i<selectAddId.length; i++) {
  			//System.out.println("selectAddId"+i + selectAddId[i]);
  			paraMap.put("selectAddId"+i, selectAddId[i]);
  		}
  		
  		
  		super.setRedirect(true);
  		super.setViewPage(request.getContextPath() + "/myPage/delivery.hp"); 
  	}

}
