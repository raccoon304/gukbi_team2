package admin.delivery.controller;

import java.util.ArrayList;
import java.util.List;

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
            super.setViewPage(request.getContextPath() + "/admin/delivery/orderDeliveryList.hp");
            return;
        }

        int n = dao.updateDeliveryStatus(orderIdList, Integer.parseInt(newStatus));

        session.setAttribute("flashMsg", (n > 0 ? "배송상태 변경 완료(" + n + "건)" : "변경 실패"));

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

        super.setRedirect(true);
        super.setViewPage(loc);
    }
}
