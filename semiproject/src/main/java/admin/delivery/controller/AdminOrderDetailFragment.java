package admin.delivery.controller;

import java.util.List;
import java.util.Map;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;
import order.model.OrderDAO;
import order.model.OrderDAO_imple;

public class AdminOrderDetailFragment extends AbstractController {

    private OrderDAO odao = new OrderDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
    		
        response.setContentType("text/html; charset=UTF-8");

        HttpSession session = request.getSession();
        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

        // 관리자 체크
        if (loginUser == null || !"admin".equals(loginUser.getMemberid())) {
            request.setAttribute("errMsg", "관리자만 접근 가능합니다.");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/admin/delivery/orderDetailFragment.jsp");
            return;
        }

        String orderNo = request.getParameter("orderNo");
        orderNo = (orderNo == null) ? "" : orderNo.trim();

        int orderId;
        try {
            orderId = Integer.parseInt(orderNo);
        } catch (NumberFormatException e) {
            request.setAttribute("errMsg", "잘못된 주문번호입니다.");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/admin/delivery/adminOrderDetailFragment.jsp.jsp");
            return;
        }

        Map<String, Object> header = odao.selectOrderHeaderforYD(orderId);
        List<Map<String, Object>> items = odao.selectOrderItemsForModal(orderId);

        if (header == null || header.isEmpty()) {
            request.setAttribute("errMsg", "주문 정보를 찾을 수 없습니다.");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/admin/delivery/adminOrderDetailFragment.jsp.jsp");
            return;
        }

        request.setAttribute("orderHeader", header);
        request.setAttribute("items", items);
        request.setAttribute("product", items); //
        
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/admin/delivery/adminOrderDetailFragment.jsp");
    }
}
