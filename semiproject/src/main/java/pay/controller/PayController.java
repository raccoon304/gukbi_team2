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

        /* ================= 오래된 READY 주문 FAIL 처리 ================= */
        int n = odao.expireReadyOrders(loginUser.getMemberid());

        /* ================= 파라미터 ================= */
        String cartIdsParam = request.getParameter("cartIds");

        List<Map<String, Object>> orderList = new ArrayList<>();
        List<CartDTO> cartList = new ArrayList<>();

        /* ================= 결제 대상 조회 ================= */
        if (cartIdsParam != null && !cartIdsParam.isBlank()) {
            // ✅ 장바구니 결제 - directOrderItem 세션 삭제
            session.removeAttribute("directOrderItem");
            
            System.out.println("▼▼▼▼▼ PayController - Cart Purchase ▼▼▼▼▼");
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
            // ✅ 바로 구매
            String productCode = request.getParameter("productCode");
            String optionIdStr = request.getParameter("optionId");
            String quantityStr = request.getParameter("quantity");

            System.out.println("▼▼▼▼▼ PayController - Direct Purchase ▼▼▼▼▼");
            System.out.println("productCode: [" + productCode + "]");
            System.out.println("optionIdStr: [" + optionIdStr + "]");
            System.out.println("quantityStr: [" + quantityStr + "]");

            // ✅ 파라미터가 있으면 새로 조회 (세션 무시)
            if (productCode != null && optionIdStr != null && quantityStr != null) {
                
                System.out.println("NEW PURCHASE - Parameters found, clearing old session");
                // ✅ 기존 세션 삭제
                session.removeAttribute("directOrderItem");
                
                int optionId;
                int quantity;

                try {
                    optionId = Integer.parseInt(optionIdStr);
                    quantity = Integer.parseInt(quantityStr);
                    System.out.println("Parsed - optionId: " + optionId + ", quantity: " + quantity);
                } catch (NumberFormatException e) {
                    System.out.println("ERROR: Number format exception!");
                    response.getWriter().println(
                        "<script>alert('잘못된 수량 또는 옵션입니다.');history.back();</script>"
                    );
                    return;
                }

                System.out.println("Calling cartDao.selectDirectProduct...");
                
                Map<String, Object> item = cartDao.selectDirectProduct(productCode, optionId, quantity);

                System.out.println("After cartDao.selectDirectProduct - item: " + item);

                if (item != null) {
                    // ✅ 새로운 상품 정보를 세션에 저장
                    session.setAttribute("directOrderItem", item);
                    
                    orderList.add(item);

                    CartDTO cart = new CartDTO();
                    cart.setCartId(0);
                    cart.setOptionId(optionId);
                    cart.setQuantity(quantity);
                    cart.setPrice(getInt(item, "unit_price"));
                    cart.setProductName(getStr(item, "product_name"));
                    cart.setBrand_name(getStr(item, "brand_name"));

                    cartList.add(cart);
                    
                    System.out.println("New item saved to session and added to orderList");
                } else {
                    System.out.println("ERROR: item is NULL!");
                    response.getWriter().println(
                        "<script>alert('상품 조회에 실패했습니다.');history.back();</script>"
                    );
                    return;
                }
                
            } else {
                // ✅ 파라미터가 없으면 세션 사용 (JSP forward 시)
                System.out.println("NO PARAMETERS - Using session");
                
                Map<String, Object> directItem = (Map<String, Object>) session.getAttribute("directOrderItem");
                
                if (directItem != null) {
                    System.out.println("directItem from session: " + directItem);
                    
                    int savedQuantity = getInt(directItem, "quantity");
                    System.out.println("Quantity from session: " + savedQuantity);
                    
                    orderList.add(directItem);

                    CartDTO cart = new CartDTO();
                    cart.setCartId(0);
                    cart.setOptionId(getInt(directItem, "option_id"));
                    cart.setQuantity(savedQuantity);
                    cart.setPrice(getInt(directItem, "unit_price"));
                    cart.setProductName(getStr(directItem, "product_name"));
                    cart.setBrand_name(getStr(directItem, "brand_name"));

                    cartList.add(cart);
                } else {
                    System.out.println("ERROR: No session item and no parameters!");
                    response.getWriter().println(
                        "<script>alert('잘못된 접근입니다.');history.back();</script>"
                    );
                    return;
                }
            }
            
            System.out.println("▲▲▲▲▲ PayController - Direct Purchase END ▲▲▲▲▲");
        }

        /* ================= 세션 초기화 (주문 관련만) ================= */
        session.removeAttribute("readyOrderId");
        session.removeAttribute("usedCouponId");

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

        /* ================= 쿠폰 목록만 조회 ================= */
        List<Map<String, Object>> couponList =
            odao.selectAvailableCoupons(loginUser.getMemberid());

        /* ================= 임시 주문 생성 ================= */
        OrderDTO order = new OrderDTO();
        order.setMemberId(loginUser.getMemberid());
        order.setTotalAmount(totalPrice);
        order.setDiscountAmount(0);
        order.setDeliveryAddress("(결제 중 입력됨)");
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
        request.setAttribute("discountPrice", 0);
        request.setAttribute("finalPrice", totalPrice);
        request.setAttribute("loginUser", loginUser);

        System.out.println("Forward to JSP with orderList size: " + orderList.size());

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/pay_MS/payMent.jsp");
    }
}