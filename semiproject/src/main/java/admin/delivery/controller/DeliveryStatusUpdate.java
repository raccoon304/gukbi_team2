package admin.delivery.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import common.controller.AbstractController;
import admin.delivery.model.AdminDeliveryDAO;
import admin.delivery.model.AdminDeliveryDAO_imple;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class DeliveryStatusUpdate extends AbstractController {

    private AdminDeliveryDAO dao = new AdminDeliveryDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        if (!"POST".equalsIgnoreCase(request.getMethod())) {
            super.setRedirect(true);
            super.setViewPage(request.getContextPath() + "/admin/delivery/orderDeliveryList.hp");
            return;
        }

        String newStatus = request.getParameter("newStatus"); // "0"/"1"/"2"
        String orderIds  = request.getParameter("orderIds");  // "1001,1002,1003"

        newStatus = (newStatus == null ? "" : newStatus.trim());
        orderIds  = (orderIds  == null ? "" : orderIds.trim());

        if (!"0".equals(newStatus) && !"1".equals(newStatus) && !"2".equals(newStatus)) {
            super.setRedirect(true);
            super.setViewPage(request.getContextPath() + "/admin/delivery/orderDeliveryList.hp");
            return;
        }

        
        String deliveryStatus = request.getParameter("deliveryStatus");
        String sort = request.getParameter("sort");
        String sizePerPage = request.getParameter("sizePerPage");
        String currentShowPageNo = request.getParameter("currentShowPageNo");
        String searchType = request.getParameter("searchType");
        String searchWord = request.getParameter("searchWord");

        if (deliveryStatus == null) deliveryStatus = "ALL";
        if (sort == null) sort = "latest";
        if (sizePerPage == null) sizePerPage = "10";
        if (currentShowPageNo == null) currentShowPageNo = "1";
        if (searchType == null) searchType = "";
        if (searchWord == null) searchWord = "";

        String encodedWord = java.net.URLEncoder.encode(searchWord, "UTF-8");

        String loc = request.getContextPath() + "/admin/delivery/orderDeliveryList.hp"
                   + "?deliveryStatus=" + deliveryStatus
                   + "&sort=" + sort
                   + "&sizePerPage=" + sizePerPage
                   + "&currentShowPageNo=" + currentShowPageNo
                   + "&searchType=" + searchType
                   + "&searchWord=" + encodedWord;

        // 주문번호 리스트 만들기
        List<Long> orderIdList = new ArrayList<>();
        if (!orderIds.isEmpty()) {
            for (String s : orderIds.split(",")) {
                try {
                    long id = Long.parseLong(s.trim());
                    if (id > 0) orderIdList.add(id);
                } catch (Exception ignore) {}
            }
        }

        HttpSession session = request.getSession();

        if (orderIdList.isEmpty()) {
            session.setAttribute("flashMsg", "선택된 주문이 없습니다.");
            super.setRedirect(true);
            super.setViewPage(loc);
            return;
        }

        int target = Integer.parseInt(newStatus);

        // 현재 배송상태 조회
        Map<Long, Integer> statusMap = dao.selectDeliveryStatusMap(orderIdList);

        // DB에 없는 주문번호 제거
        List<Long> validIds = new ArrayList<>();
        for (Long oid : orderIdList) {
            if (statusMap.containsKey(oid)) validIds.add(oid);
        }
        orderIdList = validIds;

        if (orderIdList.isEmpty()) {
            session.setAttribute("flashMsg", "선택된 주문이 없습니다.");
            super.setRedirect(true);
            super.setViewPage(loc);
            return;
        }

        // 상태 체크
        boolean has0 = false, has1 = false, has2 = false, has4 = false;
        boolean allSameAsTarget = true;

        for (Long oid : orderIdList) {
            int cur = statusMap.get(oid);

            if (cur == 0) has0 = true;
            else if (cur == 1) has1 = true;
            else if (cur == 2) has2 = true;
            else if (cur == 4) has4 = true;

            if (cur != target) allSameAsTarget = false;
        }

        // 주문실패 포함
        if (has4) {
            session.setAttribute("flashMsg", "주문실패 주문은 배송상태 변경 대상이 아닙니다.");
            super.setRedirect(true);
            super.setViewPage(loc);
            return;
        }

        // 같은 값으로 변경
        if (allSameAsTarget) {
            session.setAttribute("flashMsg", "배송상태를 현재와 같은 값으로 변경 할 수 없습니다.");
            super.setRedirect(true);
            super.setViewPage(loc);
            return;
        }

        // ====== 변경 규칙/메시지 ======
        // 허용: 0->1, 1->2
        // 금지: 1->0, 2->1, 2->0 (역순)
        // 금지: 0->2 (건너뛰기)

        if (target == 0) {
            if (has2) session.setAttribute("flashMsg", "배송완료를 배송준비중으로 바꿀 수 없습니다.");
            else if (has1) session.setAttribute("flashMsg", "배송중인 주문을 배송준비중으로 바꿀 수 없습니다.");
            else session.setAttribute("flashMsg", "배송상태는 배송준비중으로 변경할 수 없습니다.");
            super.setRedirect(true);
            super.setViewPage(loc);
            return;
        }

        if (target == 1) {
            if (has2) {
                session.setAttribute("flashMsg", "배송완료 주문을 배송중으로 바꿀 수 없습니다.");
                super.setRedirect(true);
                super.setViewPage(loc);
                return;
            }
            
            if (has1) {
                session.setAttribute("flashMsg", "배송준비중인 주문만 배송중으로 변경할 수 있습니다.");
                super.setRedirect(true);
                super.setViewPage(loc);
                return;
            }
        }

        if (target == 2) {
            
            if (has0) {
                session.setAttribute("flashMsg", "배송준비중인 주문은 배송완료로 변경할 수 없습니다.");
                super.setRedirect(true);
                super.setViewPage(loc);
                return;
            }
            if (has2) {
                session.setAttribute("flashMsg", "배송중인 주문만 배송완료로 변경할 수 있습니다.");
                super.setRedirect(true);
                super.setViewPage(loc);
                return;
            }
        }

        // 업데이트 실행
        int n = dao.updateDeliveryStatus(orderIdList, target);

        if (n > 0) {
            session.setAttribute("flashMsg", "배송상태 변경 완료(" + n + "건)");
        } else {
            session.setAttribute("flashMsg", "변경 실패");
        }

        super.setRedirect(true);
        super.setViewPage(loc);
    }
}
