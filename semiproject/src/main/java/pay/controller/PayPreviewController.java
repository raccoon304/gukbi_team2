package pay.controller;

import java.util.List;
import java.util.Map;
import cart.model.CartDAO;
import cart.model.CartDAO_imple;
import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;

public class PayPreviewController extends AbstractController {

    private static final int MAX_ORDER_QUANTITY = 50;

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession();
        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

        if (loginUser == null) {
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().println("<script>alert('로그인이 필요합니다.'); history.back();</script>");
            return;
        }

        try {
            String memberId = loginUser.getMemberid();
            int optionId = Integer.parseInt(request.getParameter("optionId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            // 수량 제한 (1~50)
            if (quantity > MAX_ORDER_QUANTITY) {
                quantity = MAX_ORDER_QUANTITY;
            }
            if (quantity < 1) {
                quantity = 1;
            }

            System.out.println("=== PayPreviewController 시작 ===");
            System.out.println("memberId: " + memberId);
            System.out.println("optionId: " + optionId);
            System.out.println("quantity: " + quantity);

            CartDAO cdao = new CartDAO_imple();
            Map<String, Object> cartRow = cdao.selectCartByOption(memberId, optionId);

            int cartId;

            if (cartRow != null) {
                // 같은 옵션이 이미 장바구니에 있음 → 수량 누적
                int existCartId = (int) cartRow.get("cart_id");
                int existQty = (int) cartRow.get("quantity");

                System.out.println("기존 cartId 발견: " + existCartId);
                System.out.println("기존 수량: " + existQty + " → 추가 수량: " + quantity);

                // 누적 수량도 50개 제한
                int newQty = existQty + quantity;
                if (newQty > MAX_ORDER_QUANTITY) {
                    newQty = MAX_ORDER_QUANTITY;
                    System.out.println("⚠️ 최대 수량 초과, 50개로 제한");
                }

                System.out.println("최종 수량: " + newQty);

                cdao.setQuantity(existCartId, memberId, newQty);
                cartId = existCartId;

            } else {
                // 다른 옵션 → 새로 추가
                System.out.println("신규 cart 생성");
                cartId = cdao.insertCartAndReturnId(memberId, optionId, quantity);
                System.out.println("생성된 cartId: " + cartId);
            }

            List<Integer> payCartIds = List.of(cartId);
            session.setAttribute("payCartIds", payCartIds);

            System.out.println(">>> 세션에 저장된 payCartIds: " + payCartIds);
            System.out.println("=== PayPreviewController 종료 ===");

            response.sendRedirect(request.getContextPath() + "/pay/payMent.hp");

        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().println("<script>alert('오류가 발생했습니다: " + e.getMessage() + "'); history.back();</script>");
        }
    }
}