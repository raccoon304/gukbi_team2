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

            System.out.println("=== PayPreviewController 시작 ===");
            System.out.println("memberId: " + memberId);
            System.out.println("optionId: " + optionId);
            System.out.println("quantity: " + quantity);

            CartDAO cdao = new CartDAO_imple();
            Map<String, Object> cartRow = cdao.selectCartByOption(memberId, optionId);

            int cartId;

            if (cartRow != null) {
                int existCartId = (int) cartRow.get("cart_id");
                int existQty = (int) cartRow.get("quantity");

                System.out.println("기존 cartId 발견: " + existCartId);
                System.out.println("기존 수량: " + existQty + " → 변경 수량: " + (existQty + quantity));

                cdao.setQuantity(existCartId, memberId, existQty + quantity);
                cartId = existCartId;
            } else {
                System.out.println("신규 cart 생성");
                cartId = cdao.insertCartAndReturnId(memberId, optionId, quantity);
                System.out.println("생성된 cartId: " + cartId);
            }

            List<Integer> payCartIds = List.of(cartId);
            session.setAttribute("payCartIds", payCartIds);

            System.out.println(">>> 세션에 저장된 payCartIds: " + payCartIds);
            System.out.println("=== PayPreviewController 종료 ===");

            // redirect로 변경! (같은 애플리케이션 내에서)
            response.sendRedirect(request.getContextPath() + "/pay/payMent.hp");

        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().println("<script>alert('오류가 발생했습니다: " + e.getMessage() + "'); history.back();</script>");
        }
    }
}