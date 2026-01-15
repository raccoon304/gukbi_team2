package myPage.controller;

import java.util.List;
import java.util.Map;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;
import order.domain.OrderDTO;
import order.model.OrderDAO;
import order.model.OrderDAO_imple;

public class OrderDetailFragment extends AbstractController {

    private OrderDAO odao = new OrderDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        response.setContentType("text/html; charset=UTF-8");

        HttpSession session = request.getSession();
        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

        if (loginUser == null) {
            request.setAttribute("errMsg", "로그인이 필요합니다.");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/myPage_YD/orderDetailFragment.jsp");
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
            super.setViewPage("/WEB-INF/myPage_YD/orderDetailFragment.jsp");
            return;
        }

        // ✅ 내 주문인지 검증: 기존 메서드(selectOrderSummaryList) 그대로 사용
        boolean isMine = false;
        List<OrderDTO> myOrders = odao.selectOrderSummaryList(loginUser.getMemberid());
        for (OrderDTO dto : myOrders) {
            if (dto.getOrderId() == orderId) {
                isMine = true;
                break;
            }
        }

        if (!isMine) {
            request.setAttribute("errMsg", "접근 권한이 없습니다.");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/myPage_YD/orderDetailFragment.jsp");
            return;
        }

        //  기존 메서드 재사용 (수정/교체 없음)
        Map<String, Object> header = odao.selectOrderHeader(orderId);
        List<Map<String, Object>> items = odao.selectOrderDetailForPayment(orderId);
        List<Map<String, Object>> product = odao.selectOrderItemsForModal(orderId);
        
        System.out.println("header keys => " + header.keySet());
        System.out.println("header map => " + header);

        
        if (header == null || header.isEmpty()) {
            request.setAttribute("errMsg", "주문 정보를 찾을 수 없습니다.");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/myPage_YD/orderDetailFragment.jsp");
            return;
        }

        request.setAttribute("orderHeader", header);
        request.setAttribute("items", items);
        request.setAttribute("product", product);
        
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/myPage_YD/orderDetailFragment.jsp");
    }
}
