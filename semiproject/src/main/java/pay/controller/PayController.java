package pay.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import cart.domain.CartDTO;
import cart.model.CartDAO;
import cart.model.CartDAO_imple;
import common.controller.AbstractController;
import coupon.domain.CouponDTO;
import coupon.domain.CouponIssueDTO;
import coupon.model.CouponDAO;
import coupon.model.CouponDAO_imple;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;

public class PayController extends AbstractController {

	// Map에서 int 안전 추출
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

	// Map에서 String 안전 추출
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

        /* ================= 파라미터 ================= */
        String cartIdsParam = request.getParameter("cartIds");
        String couponIdParam = request.getParameter("couponId");

        List<Map<String, Object>> orderList = new ArrayList<>();
        List<CartDTO> cartList = new ArrayList<>();
        
        /* ================= 결제 대상 조회 ================= */
        if (cartIdsParam != null && !cartIdsParam.isBlank()) {
            //  기존 장바구니 결제 (그대로 유지)

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
            // 상품상세 → 바로구매 (추가된 부분)

            String productCode = request.getParameter("productCode");
            String optionIdStr = request.getParameter("optionId");
            String quantityStr = request.getParameter("quantity");

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
                response.getWriter().println("""
                    <script>
                        alert('잘못된 수량 또는 옵션입니다.');
                        history.back();
                    </script>
                """);
                return;
            }
            
            Map<String, Object> item =
                cartDao.selectDirectProduct(productCode, optionId, quantity);

            if (item != null) {
                orderList.add(item);
                
                CartDTO cart = new CartDTO();
                cart.setCartId(0); // 바로구매는 cart_id 없음
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
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().println(
                "<script>alert('유효한 상품이 없습니다.');history.back();</script>"
            );
            return;
        }
        
        
        /* ================= 총 상품금액 ================= */
        int totalPrice = 0;
        for (Map<String, Object> item : orderList) {
        	 totalPrice += getInt(item, "total_price");
        }

        /* ================= 쿠폰 ================= */
        int discountPrice = 0;
        CouponDAO cdao = new CouponDAO_imple();
        List<Map<String, Object>> couponList =
            cdao.selectCouponList(loginUser.getMemberid());

        if (couponIdParam != null && !couponIdParam.isBlank()) {
            try {
                int couponId = Integer.parseInt(couponIdParam);

                for (Map<String, Object> row : couponList) {
                    CouponDTO coupon = (CouponDTO) row.get("coupon");
                    CouponIssueDTO issue = (CouponIssueDTO) row.get("issue");

                    if (issue.getCouponId() == couponId && issue.getUsedYn() == 0) {
                        discountPrice = (coupon.getDiscountType() == 0)
                            ? coupon.getDiscountValue()
                            : totalPrice * coupon.getDiscountValue() / 100;
                        break;
                    }
                }
            } catch (Exception ignore) {}
        }

        if (discountPrice < 0) discountPrice = 0;
        if (discountPrice > totalPrice) discountPrice = totalPrice;

        /* ================= 최종 금액 ================= */
        int finalPrice = totalPrice - discountPrice;

        /* ================= 선택한 쿠폰 세션 저장 (PaymentSuccess용) ================= */
        if (couponIdParam != null && !couponIdParam.isBlank()) {
            session.setAttribute("usedCouponId", Integer.parseInt(couponIdParam));
        } else {
            session.removeAttribute("usedCouponId");
        }
        
        /* ================= JSP 전달 ================= */
        session.setAttribute("cartList", cartList);
        
        
        request.setAttribute("orderList", orderList);
        request.setAttribute("couponList", couponList);
        request.setAttribute("totalPrice", totalPrice);
        request.setAttribute("discountPrice", discountPrice);
        request.setAttribute("finalPrice", finalPrice);
        request.setAttribute("loginUser", loginUser);

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/pay_MS/payMent.jsp");
        
        
    }
}

