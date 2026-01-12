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

public class DeliveryDelete extends AbstractController {

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

        // GET 차단
        if (!"POST".equalsIgnoreCase(request.getMethod())) {
            request.setAttribute("message", "올바르지 않은 접근입니다.");
            request.setAttribute("loc", request.getContextPath() + "/myPage/delivery.hp");

            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        String memberid = loginUser.getMemberid();

        // 체크된 배송지 id
        String[] selectAddId = request.getParameterValues("deliveryAddressId");

        // 체크 안 했을 때 처리
        if (selectAddId == null || selectAddId.length == 0) {
            request.setAttribute("message", "삭제할 배송지를 선택해주세요.");
            request.setAttribute("loc", request.getContextPath() + "/myPage/delivery.hp");

            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        Map<String, String> paraMap = new HashMap<>();
        paraMap.put("memberid", memberid);

        //체크 갯수가 3개면 키값이 selectAddId0 .. selectAddId2 이렇게 나옴.
        for (int i = 0; i < selectAddId.length; i++) {
            paraMap.put("selectAddId_" + i, selectAddId[i]);
        }

        // 기본배송지가 있는지 한번 더 확인하는 메서드 
        boolean hasDefault = dDao.hasDefaultAddressInSelection(paraMap);

        if (hasDefault) {
            request.setAttribute("message", "기본 배송지는 삭제할 수 없습니다. 기본 배송지를 변경한 후 삭제해주세요.");
            request.setAttribute("loc", request.getContextPath() + "/myPage/delivery.hp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            
            return;
        }  
            
        
        // 삭제 실행
        int n = dDao.deleteDelivery(paraMap);

        if (n > 0) {
            request.setAttribute("message", "배송지가 삭제되었습니다.");
            request.setAttribute("loc", request.getContextPath() + "/myPage/delivery.hp");

            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
            
        } else {
            // 실패: 본인 주소 아니거나 이미 삭제된 경우 등
            request.setAttribute("message", "배송지 삭제에 실패했습니다. (이미 삭제되었거나 권한이 없습니다.)");
            request.setAttribute("loc", request.getContextPath() + "/myPage/delivery.hp");

            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
        }
        
    }
}