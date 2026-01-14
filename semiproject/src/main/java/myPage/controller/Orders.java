package myPage.controller;

import java.util.List;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;
import order.domain.OrderDTO;
import order.model.OrderDAO;
import order.model.OrderDAO_imple;

public class Orders extends AbstractController {

	 private OrderDAO oDao = new OrderDAO_imple();

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

        // 사이드바 표시용
        request.setAttribute("memberInfo", loginUser);

        // 주문내역 리스트
        List<OrderDTO> orderList = oDao.selectOrderSummaryList(loginUser.getMemberid());
        request.setAttribute("orderList", orderList);

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/myPage_YD/orders.jsp");
    }

}
