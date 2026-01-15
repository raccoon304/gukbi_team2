package pay.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import cart.domain.CartDTO;
import cart.model.CartDAO;
import cart.model.CartDAO_imple;
import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;
import order.domain.OrderDTO;
import order.model.OrderDAO;
import order.model.OrderDAO_imple;

public class PayController extends AbstractController {

    /* ================= 유틸 ================= */
    private int getInt(Map<String, Object> map, String key) {
        Object v = map.get(key);
        if (v == null) return 0;
        if (v instanceof Number) return ((Number) v).intValue();
        try {
            return Integer.parseInt(String.valueOf(v));
        } catch (Exception e) {
            return 0;
        }
    }

    private String getStr(Map<String, Object> map, String key) {
        Object v = map.get(key);
        return (v == null) ? "" : String.valueOf(v);
    }

    private CartDAO cartDao = new CartDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession();
        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

        /* ================= 로그인 체크 ================= */
        if (loginUser == null) {
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().println(
                "<script>alert('로그인 후 이용 가능합니다.');"
              + "location.href='" + request.getContextPath() + "/index.jsp';</script>"
            );
            return;
        }

        OrderDAO odao = new OrderDAO_imple();

        /* ================= 오래된 READY 주문 FAIL 처리 (본인 것만) ================= */
        int n = odao.expireReadyOrders(loginUser.getMemberid());

        /* ================= 세션 초기화 (READY 재사용 방지) ================= */
        session.removeAttribute("readyOrderId");
        session.removeAttribute("cartList");
        session.removeAttribute("usedCouponId");

        /* ================= 파라미터 ================= */
        String cartIdsParam = request.getParameter("cartIds");
        // couponIdParam 삭제 - 여기서는 받지 않음

        List<Map<String, Object>> orderList = new ArrayList<>();
        List<CartDTO> cartList = new ArrayList<>();

        /* ================= 결제 대상 조회 ================= */
        if (cartIdsParam != null && !cartIdsParam.isBlank()) {
            // 장바구니 결제
            String[] cartIdArray = cartIdsParam.split(",");

            for (String cartIdStr : cartIdArray) {
                try {
                    int cartId = Integer.parseInt(cartIdStr.trim());

                    Map<String, Object> item =
                        cartDao.selectCartById(cartId, loginUser.getMemberid());

                    if (item == null) continue;

                    orderList.add(item);

                    CartDTO cart = new CartDTO();
                    cart.setCartId(cartId);
                    cart.setOptionId(getInt(item, "option_id"));
                    cart.setQuantity(getInt(item, "quantity"));
                    cart.setPrice(getInt(item, "unit_price"));
                    cart.setProductName(getStr(item, "product_name"));
                    cart.setBrand_name(getStr(item, "brand_name"));

                    cartList.add(cart);

                } catch (NumberFormatException ignore) {}
            }

        } else {
            // 상품 상세 → 바로 구매
            String productCode = request.getParameter("productCode");
            String optionIdStr = request.getParameter("optionId");
            String quantityStr = request.getParameter("quantity");

            if (productCode == null || optionIdStr == null || quantityStr == null) {
                response.getWriter().println(
                    "<script>alert('잘못된 접근입니다.');history.back();</script>"
                );
                return;
            }

            int optionId;
            int quantity;

            try {
                optionId = Integer.parseInt(optionIdStr);
                quantity = Integer.parseInt(quantityStr);
            } catch (NumberFormatException e) {
                response.getWriter().println(
                    "<script>alert('잘못된 수량 또는 옵션입니다.');history.back();</script>"
                );
                return;
            }

            Map<String, Object> item =
                cartDao.selectDirectProduct(productCode, optionId, quantity);

            if (item != null) {
                orderList.add(item);

                CartDTO cart = new CartDTO();
                cart.setCartId(0); // 바로구매
                cart.setOptionId(optionId);
                cart.setQuantity(quantity);
                cart.setPrice(getInt(item, "unit_price"));
                cart.setProductName(getStr(item, "product_name"));
                cart.setBrand_name(getStr(item, "brand_name"));

                cartList.add(cart);
            }
        }

        /* ================= 공통 검증 ================= */
        if (orderList.isEmpty()) {
            response.getWriter().println(
                "<script>alert('유효한 상품이 없습니다.');history.back();</script>"
            );
            return;
        }

        /* ================= 총 금액 ================= */
        int totalPrice = 0;
        for (Map<String, Object> item : orderList) {
            totalPrice += getInt(item, "total_price");
        }

        /* ================= 쿠폰 목록만 조회 (계산은 JSP에서) ================= */
        List<Map<String, Object>> couponList =
            odao.selectAvailableCoupons(loginUser.getMemberid());

        /* ================= 임시 주문 생성 (할인 전) ================= */
        OrderDTO order = new OrderDTO();
        order.setMemberId(loginUser.getMemberid());
        order.setTotalAmount(totalPrice);
        order.setDiscountAmount(0);  // 일단 0으로
        order.setDeliveryAddress("(결제 중 입력됨)");  // 임시값
        order.setRecipientName(loginUser.getName());
        order.setRecipientPhone(loginUser.getMobile());
        order.setOrderStatus("READY");

        int orderId = odao.insertOrder(order);
        session.setAttribute("readyOrderId", orderId);

        /* ================= JSP 전달 ================= */
        session.setAttribute("cartList", cartList);

        request.setAttribute("orderList", orderList);
        request.setAttribute("couponList", couponList);
        request.setAttribute("totalPrice", totalPrice);
        request.setAttribute("discountPrice", 0);  // JSP에서 계산
        request.setAttribute("finalPrice", totalPrice);  // JSP에서 변경
        request.setAttribute("loginUser", loginUser);

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/pay_MS/payMent.jsp");
    }
}