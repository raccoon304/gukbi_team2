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
        String productCode = request.getParameter("productCode");
        String optionIdStr = request.getParameter("optionId");
        String quantityStr = request.getParameter("quantity");
        
        List<Map<String, Object>> orderList = new ArrayList<>();
        List<CartDTO> cartList = new ArrayList<>();

        System.out.println("=== PayController 시작 ===");
        System.out.println("cartIdsParam: " + cartIdsParam);
        System.out.println("productCode: " + productCode);
        System.out.println("optionIdStr: " + optionIdStr);
        System.out.println("quantityStr: " + quantityStr);

        /* ================= 결제 대상 조회 ================= */
        
        // 1. 장바구니에서 선택 결제
        if (cartIdsParam != null && !cartIdsParam.isBlank()) {
            System.out.println(">>> 장바구니 결제");
            
            String[] cartIdArray = cartIdsParam.split(",");

            for (String cartIdStr : cartIdArray) {
                try {
                    int cartId = Integer.parseInt(cartIdStr.trim());

                    Map<String, Object> item = cartDao.selectCartById(cartId, loginUser.getMemberid());

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
                    System.out.println("ERROR: cartId 파싱 실패");
                }
            }
        } 
        // 2. 바로구매 (장바구니 형식으로 변환)
        else if (productCode != null && optionIdStr != null && quantityStr != null) {
            System.out.println(">>> 바로구매");

            // Attribute에서도 확인 (ProductInsertPay 경유 시)
            if (productCode.isBlank()) {
                productCode = (String) request.getAttribute("productCode");
            }
            if (optionIdStr.isBlank()) {
                optionIdStr = (String) request.getAttribute("optionId");
                if (optionIdStr == null) {
                    optionIdStr = (String) request.getAttribute("productOptionId");
                }
            }
            if (quantityStr.isBlank()) {
                quantityStr = (String) request.getAttribute("quantity");
            }

            if (productCode == null || optionIdStr == null || quantityStr == null) {
                response.setContentType("text/html; charset=UTF-8");
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
                response.setContentType("text/html; charset=UTF-8");
                response.getWriter().println(
                    "<script>alert('잘못된 수량 또는 옵션입니다.');history.back();</script>"
                );
                return;
            }

            // ✅ selectDirectProduct로 상품 정보 조회
            Map<String, Object> item = cartDao.selectDirectProduct(productCode, optionId, quantity);

            System.out.println("selectDirectProduct 결과: " + item);

            if (item != null) {
                // ✅ orderList에 추가 (JSP 표시용)
                orderList.add(item);

                // ✅ CartDTO 생성 (결제 처리용)
                CartDTO cart = new CartDTO();
                cart.setCartId(0);  // 바로구매는 cartId = 0
                cart.setOptionId(optionId);
                cart.setQuantity(quantity);
                cart.setPrice(getInt(item, "unit_price"));
                cart.setProductName(getStr(item, "product_name"));
                cart.setBrand_name(getStr(item, "brand_name"));

                cartList.add(cart);
                
                System.out.println("✅ 바로구매 상품 추가:");
                System.out.println("  - " + cart.getProductName());
                System.out.println("  - 수량: " + cart.getQuantity());
                System.out.println("  - 가격: " + cart.getPrice());
            } else {
                System.out.println("❌ 상품 조회 실패");
            }
        }
        else {
            System.out.println("❌ 결제 정보 없음");
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().println(
                "<script>alert('결제 정보가 없습니다.');history.back();</script>"
            );
            return;
        }

        System.out.println("orderList size: " + orderList.size());
        System.out.println("cartList size: " + cartList.size());

        /* ================= 공통 검증 ================= */
        if (orderList.isEmpty()) {
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().println(
                "<script>alert('유효한 상품이 없습니다.');"
              + "history.back();</script>"
            );
            return;
        }
        
        /* ================= 총 금액 ================= */
        int totalPrice = 0;
        for (Map<String, Object> item : orderList) {
            totalPrice += getInt(item, "total_price");
        }

        System.out.println("총 금액: " + totalPrice);

        /* ================= 쿠폰 목록 조회 ================= */
        List<Map<String, Object>> couponList = odao.selectAvailableCoupons(loginUser.getMemberid());

        /* ================= 세션에 저장 ================= */
        session.setAttribute("payCartList", cartList);
        
        System.out.println("✅ payCartList 세션 저장 완료");
        for (CartDTO cart : cartList) {
            System.out.println("  - cartId: " + cart.getCartId()
                             + ", optionId: " + cart.getOptionId()
                             + ", 상품: " + cart.getProductName());
        }

        /* ================= JSP 전달 ================= */
        request.setAttribute("orderList", orderList);
        request.setAttribute("couponList", couponList);
        request.setAttribute("totalPrice", totalPrice);
        request.setAttribute("discountPrice", 0);
        request.setAttribute("finalPrice", totalPrice);
        request.setAttribute("loginUser", loginUser);

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/pay_MS/payMent.jsp");
    }
}