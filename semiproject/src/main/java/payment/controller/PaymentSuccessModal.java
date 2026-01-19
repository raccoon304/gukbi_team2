package payment.controller;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;
import order.model.OrderDAO;
import order.model.OrderDAO_imple;

public class PaymentSuccessModal extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        String method = request.getMethod(); // ⭐ 핵심

        /* ================= GET : 결제 완료 모달 조회 ================= */
        if ("GET".equalsIgnoreCase(method)) {

            HttpSession session = request.getSession();
            MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

            // 1️⃣ 로그인 체크
            if (loginUser == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401
                return;
            }

            // 2️⃣ 주문번호 파라미터
            String orderNo = request.getParameter("orderNo");
            if (orderNo == null || orderNo.isBlank()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // 400
                return;
            }

            int orderId;
            try {
                orderId = Integer.parseInt(orderNo);
            } catch (NumberFormatException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // 400
                return;
            }

            OrderDAO odao = new OrderDAO_imple();

            // 3️ 해킹 방지
            boolean isMyOrder = odao.isOrderOwner(orderId, loginUser.getMemberid());
            if (!isMyOrder) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN); // 403
                return;
            }

            // 4️ 데이터 조회
            request.setAttribute("order", odao.selectOrderHeader(orderId));
            request.setAttribute("orderDetailList",
                                 odao.selectOrderDetailForPayment(orderId));

            // 5️ fragment JSP로 forward
            setRedirect(false);
            setViewPage("/WEB-INF/pay_MS/payMentSuccessModal.jsp");
            return;
        }

        /* ================= POST (및 기타 메서드) : 차단 ================= */
        response.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED); // 
    }
}