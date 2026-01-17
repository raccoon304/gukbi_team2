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

        /* ================= 파라미터 ================= */
        String cartIdsParam = request.getParameter("cartIds");

        @SuppressWarnings("unchecked")
        List<Integer> payCartIds = (List<Integer>) session.getAttribute("payCartIds");
        
        List<Map<String, Object>> orderList = new ArrayList<>();
        List<CartDTO> cartList = new ArrayList<>();

        System.out.println("=== PayController 디버깅 시작 ===");
        System.out.println("cartIdsParam: " + cartIdsParam);
        System.out.println("payCartIds(세션): " + payCartIds);
        System.out.println("loginUser ID: " + loginUser.getMemberid());

        /* ================= 결제 대상 조회 ================= */
        
        // 1. URL 파라미터로 넘어온 경우 (장바구니에서 선택 결제)
        if (cartIdsParam != null && !cartIdsParam.isBlank()) {
            System.out.println(">>> 장바구니 선택 결제 경로");
            
            String[] cartIdArray = cartIdsParam.split(",");

            for (String cartIdStr : cartIdArray) {
                try {
                    int cartId = Integer.parseInt(cartIdStr.trim());
                    System.out.println("처리 중인 cartId: " + cartId);

                    Map<String, Object> item = cartDao.selectCartById(cartId, loginUser.getMemberid());
                    System.out.println("조회 결과: " + item);

                    if (item == null) {
                        System.out.println("WARNING: cartId " + cartId + " 조회 실패");
                        continue;
                    }

                    orderList.add(item);

                    CartDTO cart = new CartDTO();
                    cart.setCartId(cartId);
                    cart.setOptionId(getInt(item, "option_id"));
                    cart.setQuantity(getInt(item, "quantity"));
                    cart.setPrice(getInt(item, "unit_price"));
                    cart.setProductName(getStr(item, "product_name"));
                    cart.setBrand_name(getStr(item, "brand_name"));

                    cartList.add(cart);

                } catch (NumberFormatException e) {
                    System.out.println("ERROR: cartId 파싱 실패 - " + cartIdStr);
                }
            }
        } 
        // 2. 바로구매에서 넘어온 경우 (세션에 저장된 payCartIds 사용)
        else if (payCartIds != null && !payCartIds.isEmpty()) {
            System.out.println(">>> 바로구매 결제 경로");
            System.out.println("payCartIds size: " + payCartIds.size());

            for (int cartId : payCartIds) {
                System.out.println("처리 중인 cartId: " + cartId);

                Map<String, Object> item = cartDao.selectCartById(cartId, loginUser.getMemberid());
                System.out.println("selectCartById 결과: " + item);

                // JOIN 실패 시 fallback
                if (item == null) {
                    System.out.println("JOIN 실패, fallback 시도...");
                    item = cartDao.selectRawCartById(cartId, loginUser.getMemberid());
                    System.out.println("selectRawCartById 결과: " + item);
                    
                    if (item == null) {
                        System.out.println("ERROR: cartId " + cartId + " fallback도 실패");
                        continue;
                    }

                    // 최소 결제 정보 보정
                    item.put("product_name", "(상품정보 조회 중)");
                    item.put("brand_name", "");
                    item.put("unit_price", 0);
                    item.put("total_price", 0);
                    System.out.println("fallback 데이터로 보정 완료");
                }

                orderList.add(item);

                CartDTO cart = new CartDTO();
                cart.setCartId(cartId);
                cart.setOptionId(getInt(item, "option_id"));
                cart.setQuantity(getInt(item, "quantity"));
                cart.setPrice(getInt(item, "unit_price"));
                cart.setProductName(getStr(item, "product_name"));
                cart.setBrand_name(getStr(item, "brand_name"));

                cartList.add(cart);
            }
        }
        // 3. 둘 다 없는 경우
        else {
            System.out.println("ERROR: cartIdsParam도 없고 payCartIds도 없음");
        }

        System.out.println("최종 orderList size: " + orderList.size());
        System.out.println("=== PayController 디버깅 종료 ===");

        /* ================= 공통 검증 ================= */
        if (orderList.isEmpty()) {
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().println(
                "<script>alert('유효한 상품이 없습니다.\\n\\n문제가 계속되면 관리자에게 문의해주세요.');"
              + "history.back();</script>"
            );
            return;
        }

        // 세션 정리
        session.removeAttribute("payCartIds");
        
        /* ================= 총 금액 ================= */
        int totalPrice = 0;
        for (Map<String, Object> item : orderList) {
            totalPrice += getInt(item, "total_price");
        }

        System.out.println("총 결제 금액: " + totalPrice);

        /* ================= 쿠폰 목록만 조회 ================= */
        List<Map<String, Object>> couponList = odao.selectAvailableCoupons(loginUser.getMemberid());

        /* ================= JSP 전달 ================= */
        session.setAttribute("payCartList", cartList);

        System.out.println(">>> payCartList 세션 저장 완료");
        System.out.println(">>> cartList size: " + cartList.size());
        for (CartDTO cart : cartList) {
            System.out.println("    - cartId: " + cart.getCartId() 
                             + ", optionId: " + cart.getOptionId()
                             + ", quantity: " + cart.getQuantity()
                             + ", product: " + cart.getProductName());
        }

        request.setAttribute("orderList", orderList);
        request.setAttribute("couponList", couponList);
        request.setAttribute("totalPrice", totalPrice);
        request.setAttribute("discountPrice", 0);
        request.setAttribute("finalPrice", totalPrice);
        request.setAttribute("loginUser", loginUser);

        System.out.println(">>> JSP로 포워딩: /WEB-INF/pay_MS/payMent.jsp");

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/pay_MS/payMent.jsp");
    }
}