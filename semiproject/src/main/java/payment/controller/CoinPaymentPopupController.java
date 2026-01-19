package payment.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import cart.domain.CartDTO;
import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;
import order.domain.OrderDTO;
import order.model.OrderDAO;
import order.model.OrderDAO_imple;

public class CoinPaymentPopupController extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession();
        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

        if (loginUser == null) {
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().println("""
                <script>
                    alert('로그인 후 이용 가능합니다.');
                    window.close();
                </script>
            """);
            return;
        }

        if (!"GET".equalsIgnoreCase(request.getMethod())) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        int finalPrice;
        try {
            finalPrice = Integer.parseInt(request.getParameter("finalPrice"));
            if (finalPrice <= 0) throw new NumberFormatException();
        } catch (Exception e) {
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().println("""
                <script>
                    alert('결제 금액이 올바르지 않습니다.');
                    window.close();
                </script>
            """);
            return;
        }

        OrderDAO odao = new OrderDAO_imple();

        @SuppressWarnings("unchecked")
        List<CartDTO> cartList = (List<CartDTO>) session.getAttribute("payCartList");

        if (cartList == null || cartList.isEmpty()) {
            alertAndClose(response, "주문 상품이 없습니다.");
            return;
        }

        // PG 진입 전 재고 검증
        for (CartDTO cart : cartList) {
            int stock = odao.selectStock(cart.getOptionId()); // 잘됨
            if (stock < cart.getQuantity()) {
                alertAndClose(response, "재고가 부족한 상품이 있어 결제를 진행할 수 없습니다.");
                return;
            }
        }

        try {
            // 1. 이전 READY 주문 정리 (이건 그냥 테스트용인것이다.)
            odao.expireReadyOrders();

            // 2. 주문 DTO 생성
            OrderDTO order = new OrderDTO();
            order.setMemberId(loginUser.getMemberid());
            order.setTotalAmount(finalPrice);
            order.setOrderStatus("READY");
            order.setDeliveryAddress("(결제 대기중)");
            order.setRecipientName(loginUser.getName());
            order.setRecipientPhone(loginUser.getMobile());

            // 3. 주문 상세 리스트 생성
            List<Map<String, Object>> orderDetails = new ArrayList<>();
            for (CartDTO cart : cartList) {
                Map<String, Object> detail = new HashMap<>();
                detail.put("option_id", cart.getOptionId());
                detail.put("quantity", cart.getQuantity());
                detail.put("unit_price", cart.getPrice());
                detail.put("product_name", cart.getProductName());
                detail.put("brand_name", cart.getBrand_name());
                orderDetails.add(detail);
            }

            // 4. 주문 생성 + 주문상세 생성 (단일 트랜잭션)
            int orderId = odao.insertOrderWithDetailsAnd(order, orderDetails);

            if (orderId == 0) {
                alertAndClose(response, "주문 생성에 실패했습니다.");
                return;
            }
            
            // 5. 세션에 저장
            session.setAttribute("readyOrderId", orderId);

    //        System.out.println("=== READY 주문 생성 완료 ===");
    //        System.out.println("orderId: " + orderId);
    //        System.out.println("주문 상세 등록 완료");
    //        System.out.println("재고 차감 완료");

        } catch (Exception e) {
            e.printStackTrace();
            alertAndClose(response, "주문 생성 중 오류가 발생했습니다.");
            return;
        }

        // 6. JSP로 넘길 값
        Integer orderId = (Integer) session.getAttribute("readyOrderId");
        request.setAttribute("userid", loginUser.getMemberid());
        request.setAttribute("orderId", orderId);
        request.setAttribute("finalPrice", finalPrice);

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/pay_MS/coinPaymentPopup.jsp");
    }

    private void alertAndClose(HttpServletResponse response, String msg) throws Exception {
        response.setContentType("text/html; charset=UTF-8");
        response.getWriter().println("""
            <script>
                alert('%s');
                window.close();
            </script>
        """.formatted(msg.replace("'", "\\'")));
    }
}