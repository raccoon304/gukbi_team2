package payment.controller;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import order.model.OrderDAO;
import order.model.OrderDAO_imple;

public class PaymentFail extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession();
        Integer orderId = (Integer) session.getAttribute("readyOrderId");

        if (orderId != null) {

            OrderDAO odao = new OrderDAO_imple();

            // READY 상태일 때만 FAIL 처리 (중복/경합 방어)
          int n = odao.updateOrderStatusIfReady(orderId, "FAIL");
            odao.updateDeliveryStatus(orderId, 4);

            // 사용한 READY 정리
            session.removeAttribute("readyOrderId");
        }

        // 화면/리다이렉트 없음 (AJAX 호출)
        return;
    }
}