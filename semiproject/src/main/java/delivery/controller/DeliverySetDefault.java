package delivery.controller;

import java.util.HashMap;
import java.util.Map;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;
import delivery.model.DeliveryDAO;
import delivery.model.DeliveryDAO_imple;

public class DeliverySetDefault extends AbstractController {

    private DeliveryDAO dDao = new DeliveryDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession();
        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

        String message = "";
        String loc = request.getContextPath() + "/index.hp";

        // 로그인 체크
        if (loginUser == null) {
            message = "로그인 후 이용 가능합니다.";
            request.setAttribute("message", message);
            request.setAttribute("loc", loc);
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        // POST만 허용
        if (!"POST".equalsIgnoreCase(request.getMethod())) {
            message = "비정상적인 접근입니다.";
            loc = request.getContextPath() + "/myPage/delivery.hp";

            request.setAttribute("message", message);
            request.setAttribute("loc", loc);
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        String deliveryAddressId = request.getParameter("deliveryAddressId");
        deliveryAddressId = (deliveryAddressId == null) ? "" : deliveryAddressId.trim();

        // 유효성 검사
        if (deliveryAddressId.isEmpty() || !deliveryAddressId.matches("^\\d+$")) {
            message = "선택한 배송지 정보가 올바르지 않습니다.";
            loc = request.getContextPath() + "/myPage/delivery.hp";

            request.setAttribute("message", message);
            request.setAttribute("loc", loc);
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        // DAO 호출 해당 회원 소유 배송지인지까지 같이 검증되도록
        Map<String, String> paraMap = new HashMap<>();
        paraMap.put("memberId", loginUser.getMemberid()); // 프로젝트에서 memberid getter 확인
        paraMap.put("deliveryAddressId", deliveryAddressId);

        int n = dDao.setDefaultDelivery(paraMap);

        if (n == 1) {
            message = "기본 배송지가 변경되었습니다.";
        } else {
            // n==0인 경우해당 id가 없거나, 남의 배송지거나, 이미 삭제된 배송지 등
            message = "기본 배송지 변경에 실패했습니다. 다시 시도해주세요.";
        }

        loc = request.getContextPath() + "/myPage/delivery.hp";

        request.setAttribute("message", message);
        request.setAttribute("loc", loc);
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/msg.jsp");
    }
}
