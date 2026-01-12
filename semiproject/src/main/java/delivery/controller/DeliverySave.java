package delivery.controller;

import java.util.HashMap;
import java.util.Map;

import common.controller.AbstractController;
import delivery.model.DeliveryDAO;
import delivery.model.DeliveryDAO_imple;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;

public class DeliverySave extends AbstractController {

	private final DeliveryDAO dao = new DeliveryDAO_imple();

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
    
    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

    	HttpSession session = request.getSession();
        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

        if (loginUser == null) {
            request.setAttribute("message", "로그인 후 이용 가능합니다.");
            request.setAttribute("loc", request.getContextPath() + "/index.hp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        if (!"POST".equalsIgnoreCase(request.getMethod())) {
            super.setRedirect(true);
            super.setViewPage(request.getContextPath() + "/myPage/delivery.hp");
            return;
        }

        request.setCharacterEncoding("UTF-8");

        String mode = request.getParameter("mode"); // 추가인 경우 add , 수정의경우 edit
        String deliveryAddressId = request.getParameter("deliveryAddressId"); // edit일 때만 필수

        String addressName = request.getParameter("addressName");
        String recipientName = request.getParameter("recipientName");
        String postalCode = request.getParameter("postalCode");
        String recipientPhone = request.getParameter("recipientPhone");
        String address = request.getParameter("address");
        String addressDetail = request.getParameter("addressDetail");

        // 필수값 검증
        if (isBlank(mode) ||
            isBlank(addressName) || isBlank(recipientName) || isBlank(postalCode) ||
            isBlank(recipientPhone) || isBlank(address)) {

            request.setAttribute("message", "필수 입력값이 누락되었습니다.");
            request.setAttribute("loc", request.getContextPath() + "/myPage/delivery.hp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        String memberId = loginUser.getMemberid();

        Map<String, String> paraMap = new HashMap<>();
        paraMap.put("memberId", memberId);
        paraMap.put("addressName", addressName.trim());
        paraMap.put("recipientName", recipientName.trim());
        paraMap.put("postalCode", postalCode.trim());
        paraMap.put("recipientPhone", recipientPhone.trim()); 
        paraMap.put("address", address.trim());
        paraMap.put("addressDetail", addressDetail == null ? "" : addressDetail.trim());

        int n = 0;

        // mode값을 통해서 수정/추가 분기처리 
        
        // 배송지 추가일 경우
        if ("add".equalsIgnoreCase(mode)) { 
            n = dao.insertDelivery(paraMap);

        } else if ("edit".equalsIgnoreCase(mode)) {

            // edit은 deliveryAddressId 필수
            if (isBlank(deliveryAddressId)) {
                request.setAttribute("message", "수정할 배송지 정보가 없습니다.");
                request.setAttribute("loc", request.getContextPath() + "/myPage/delivery.hp");
                super.setRedirect(false);
                super.setViewPage("/WEB-INF/msg.jsp");
                return;
            }

            paraMap.put("deliveryAddressId", deliveryAddressId.trim());

            // update는 WHERE delivery_address_id = ? AND member_id = ?
            n = dao.updateDelivery(paraMap);

        } else {
            request.setAttribute("message", "잘못된 요청입니다.");
            request.setAttribute("loc", request.getContextPath() + "/myPage/delivery.hp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        if (n == 1) {
            // 성공하면 redirect로 목록 갱신
            super.setRedirect(true);
            super.setViewPage(request.getContextPath() + "/myPage/delivery.hp");
        } else {
            request.setAttribute("message", "저장에 실패했습니다.");
            request.setAttribute("loc", request.getContextPath() + "/myPage/delivery.hp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
        }
    }


}