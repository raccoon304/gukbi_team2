package map.controller;

import java.util.List;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import map.domain.StoreDTO;
import map.model.StoreDAO;
import map.model.StoreDAO_imple;
import member.domain.MemberDTO;

public class StoreDelete extends AbstractController {

    private StoreDAO sdao = new StoreDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession();
        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

        if (loginUser == null || !"admin".equals(loginUser.getMemberid())) {
            request.setAttribute("message", "접근 권한이 없습니다.");
            request.setAttribute("loc", request.getContextPath() + "/map/mapView.hp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        String method = request.getMethod();


        if ("GET".equalsIgnoreCase(method)) {
            List<StoreDTO> storeList = sdao.selectAllStoresForAdmin();
            request.setAttribute("storeList", storeList);

            super.setRedirect(false);
            super.setViewPage("/WEB-INF/map_YD/StoreDelete.jsp");
            return;
        }

        String storeIdStr = request.getParameter("store_id");
        int storeId;

        try {
            storeId = Integer.parseInt(storeIdStr);
        } catch (Exception e) {
            request.setAttribute("message", "매장 선택 값이 올바르지 않습니다.");
            request.setAttribute("loc", request.getContextPath() + "/map/storeDelete.hp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        int n = sdao.toggleStoreActive(storeId);

        if (n == 1) {
            request.setAttribute("message", "매장 상태가 변경되었습니다.");
            request.setAttribute("loc", request.getContextPath() + "/map/storeDelete.hp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
        } else {
            request.setAttribute("message", "상태 변경에 실패했습니다.");
            request.setAttribute("loc", request.getContextPath() + "/map/storeDelete.hp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
        }
    }
}
