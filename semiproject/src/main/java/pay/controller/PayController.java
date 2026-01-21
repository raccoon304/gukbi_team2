package pay.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import cart.domain.CartDTO;
import cart.model.CartDAO;
import cart.model.CartDAO_imple;
import common.controller.AbstractController;
import delivery.domain.DeliveryDTO;
import delivery.model.DeliveryDAO;
import delivery.model.DeliveryDAO_imple;
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
    private DeliveryDAO deliveryDao = new DeliveryDAO_imple();
    
    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession();
        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

        /* ================= 로그인 체크 ================= */
        if (loginUser == null) {
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().println(
                "<script>alert('로그인 후 이용 가능합니다.');"
              + "location.href='" + request.getContextPath() + "/WEB-INF/index.jsp';</script>"
            );
            return;
        }

        String memberId = loginUser.getMemberid();
        
        OrderDAO odao = new OrderDAO_imple();
        
        /* ================= 파라미터 ================= */
        String cartIdsParam = request.getParameter("cartIds");

        // 세션에서 payCartIds 확인 (PayPreviewController에서 설정한 경우)
        @SuppressWarnings("unchecked")
        List<Integer> payCartIds = (List<Integer>) session.getAttribute("payCartIds");

        // Parameter / Attribute 모두 체크
        String productCode = request.getParameter("productCode");
        if (productCode == null || productCode.isBlank()) {
            productCode = (String) request.getAttribute("productCode");
        }

        String optionIdStr = request.getParameter("optionId");
        if (optionIdStr == null || optionIdStr.isBlank()) {
            optionIdStr = (String) request.getAttribute("optionId");
        }
        if (optionIdStr == null || optionIdStr.isBlank()) {
            optionIdStr = (String) request.getAttribute("productOptionId");
        }

        String quantityStr = request.getParameter("quantity");
        if (quantityStr == null || quantityStr.isBlank()) {
            quantityStr = (String) request.getAttribute("quantity");
        }

        List<Map<String, Object>> orderList = new ArrayList<>();
        List<CartDTO> cartList = new ArrayList<>();

        /*
        System.out.println("=== PayController 시작 ===");
        System.out.println("cartIdsParam: " + cartIdsParam);
        System.out.println("payCartIds (세션): " + payCartIds);
        System.out.println("productCode: " + productCode);
        System.out.println("optionIdStr: " + optionIdStr);
        System.out.println("quantityStr: " + quantityStr);
         */
        
        /* ================= 결제 대상 조회 ================= */

        // 1. 세션 payCartIds 사용 (바로구매)
        if (payCartIds != null && !payCartIds.isEmpty()) {
      //      System.out.println(">>> 세션 payCartIds 사용 (바로구매)");

            for (Integer cartId : payCartIds) {
                Map<String, Object> item = cartDao.selectCartById(cartId, loginUser.getMemberid());

                if (item == null) {
     //              System.out.println("WARNING: cartId " + cartId + " 조회 실패");
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
            }

            // 사용 후 세션 제거
            session.removeAttribute("payCartIds");
        }
        // 2. 장바구니 선택 결제
        else if (cartIdsParam != null && !cartIdsParam.isBlank()) {
       //     System.out.println(">>> 장바구니 결제");

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
      //          System.out.println("ERROR: cartId 파싱 실패 - " + e.getMessage());
                }
            }
        }
        // 3. 바로구매 (직접 파라미터)
        else if (productCode != null && !productCode.isBlank()
              && optionIdStr != null && !optionIdStr.isBlank()
              && quantityStr != null && !quantityStr.isBlank()) {

     //      System.out.println(">>> 바로구매 (직접 파라미터)");

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

            Map<String, Object> item = cartDao.selectDirectProduct(productCode, optionId, quantity);

            if (item != null) {
                orderList.add(item);

                CartDTO cart = new CartDTO();
                cart.setCartId(0);
                cart.setOptionId(optionId);
                cart.setQuantity(quantity);
                cart.setPrice(getInt(item, "unit_price"));
                cart.setProductName(getStr(item, "product_name"));
                cart.setBrand_name(getStr(item, "brand_name"));

                cartList.add(cart);
            } else {
                response.setContentType("text/html; charset=UTF-8");
                response.getWriter().println(
                    "<script>alert('상품 정보를 찾을 수 없습니다.');history.back();</script>"
                );
                return;
            }
        } else {
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().println(
                "<script>alert('결제 정보가 없습니다.');history.back();</script>"
            );
            return;
        }

        /* ================= 검증 ================= */
        if (orderList.isEmpty()) {
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().println(
                "<script>alert('유효한 상품이 없습니다.');history.back();</script>"
            );
            return;
        }

        /* ================= 총 금액 ================= */
        int totalPrice = 0;
        for (Map<String, Object> item : orderList) {
            int unitPrice = getInt(item, "unit_price");
            int qty = getInt(item, "quantity");
            totalPrice += unitPrice * qty;   // 할인 전 기준
        }

        /* ================= 쿠폰 ================= */
        List<Map<String, Object>> couponList =
                odao.selectAvailableCoupons(loginUser.getMemberid());

        /* ================= 배송지 목록 조회 추가 ================= */
        List<DeliveryDTO> deliveryList = deliveryDao.selectDeliveryList(memberId);
        request.setAttribute("deliveryList", deliveryList);
        
        // 기본 배송지 찾기
        DeliveryDTO defaultDelivery = null;
        for (DeliveryDTO delivery : deliveryList) {
            if (delivery.getIsDefault() == 1) {
                defaultDelivery = delivery;
                break;
            }
        }
        
        // 기본 배송지 정보를 결제 페이지에 표시
        if (defaultDelivery != null) {
            request.setAttribute("defaultAddress", defaultDelivery.getAddress());
            request.setAttribute("defaultAddressDetail", defaultDelivery.getAddressDetail());
            request.setAttribute("defaultPostalCode", defaultDelivery.getPostalCode());
            request.setAttribute("defaultRecipientName", defaultDelivery.getRecipientName());
            request.setAttribute("defaultRecipientPhone", defaultDelivery.getRecipientPhone());
        }
        
        
        
        /* ================= 세션 저장 ================= */
        session.setAttribute("payCartList", cartList);

        /* ================= JSP 전달 ================= */
        request.setAttribute("stockAdjusted", true);
        
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