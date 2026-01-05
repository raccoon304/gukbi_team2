package pay.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import cart.model.CartDAO;
import cart.model.CartDAO_imple;
import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;

public class PayController extends AbstractController {

    private CartDAO cartDao = new CartDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession();
        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

        if (loginUser == null) {
            super.setRedirect(true);
            super.setViewPage(request.getContextPath() + "/login/login.jsp");
            return;
        }

        String cartIdsParam = request.getParameter("cartIds");

        if (cartIdsParam == null || cartIdsParam.trim().isEmpty()) {
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().println(
                "<script>alert('선택된 상품이 없습니다.');history.back();</script>"
            );
            return;
        }

        // 1. 선택된 cartId만 조회
        String[] cartIdArray = cartIdsParam.split(",");
        List<Map<String, Object>> orderList = new ArrayList<>();

        for (String cartIdStr : cartIdArray) {
            try {
                int cartId = Integer.parseInt(cartIdStr.trim());
                Map<String, Object> item =
                        cartDao.selectCartById(cartId, loginUser.getMemberid());

                if (item != null) {
                    orderList.add(item);
                }
            } catch (NumberFormatException ignore) {}
        }

        if (orderList.isEmpty()) {
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().println(
                "<script>alert('유효한 상품이 없습니다.');history.back();</script>"
            );
            return;
        }

        // 2. 총 상품금액 (DAO에서 계산된 totalPrice만 합산)
        int totalPrice = 0;

        for (Map<String, Object> item : orderList) {
            int lineTotal = (Integer) item.get("total_price");
            totalPrice += lineTotal;
        }

        // 3. 할인
        int discountPrice = 0;

        // 4. 최종 금액
        int finalPrice = totalPrice - discountPrice;

        // 5. JSP 전달
        request.setAttribute("orderList", orderList);
        request.setAttribute("totalPrice", totalPrice);
        request.setAttribute("discountPrice", discountPrice);
        request.setAttribute("finalPrice", finalPrice);

        request.setAttribute("memberName", loginUser.getName());
        request.setAttribute("mobilePhone", loginUser.getMobile());
        request.setAttribute("address", "기본 배송지");

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/pay_MS/payMent.jsp");
    }
}