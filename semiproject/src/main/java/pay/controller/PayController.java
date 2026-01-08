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

import coupon.model.CouponDAO;
import coupon.model.CouponDAO_imple;
import coupon.domain.CouponDTO;
import coupon.domain.CouponIssueDTO;

public class PayController extends AbstractController {

    private CartDAO cartDao = new CartDAO_imple();

    // 악 악 악
    
    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession();
        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
        
        
        /* ================= 로그인 체크 ================= */
        if (loginUser == null) {
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().println(
                "<script>alert('로그인 후 이용 가능합니다.');location.href='"
                + request.getContextPath() + "/WEB-INF/index.jsp';</script>"
            );
            return;
        }
        

        String cartIdsParam = request.getParameter("cartIds");
        String couponIdParam = request.getParameter("couponId");

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
        	 totalPrice += (Integer) item.get("total_price");
        }

        
        // 3. 할인
        int discountPrice = 0;

        
        if (couponIdParam != null && !couponIdParam.isBlank()) {

            try {
                int couponId = Integer.parseInt(couponIdParam);

                CouponDAO cdao = new CouponDAO_imple();
                List<Map<String, Object>> couponList =
                        cdao.selectCouponList(loginUser.getMemberid());

                for (Map<String, Object> row : couponList) {

                    CouponDTO coupon = (CouponDTO) row.get("coupon");
                    CouponIssueDTO issue = (CouponIssueDTO) row.get("issue");

                    if (issue.getCouponId() == couponId
                        && issue.getUsedYn() == 0) {   

                        if (coupon.getDiscountType() == 1) { // 정액
                            discountPrice = coupon.getDiscountValue();
                        }
                        else if (coupon.getDiscountType() == 2) { // 정률
                            discountPrice = totalPrice
                                            * coupon.getDiscountValue() / 100;
                        }
                        break;
                    }
                }
            } catch (Exception ignore) {}
        }

        // 방어
        if (discountPrice > totalPrice) {
            discountPrice = totalPrice;
        }
        // 4. 최종 금액
        int finalPrice = totalPrice - discountPrice;

  
        // 5. JSP 전달
        request.setAttribute("orderList", orderList);
        request.setAttribute("totalPrice", totalPrice);
        request.setAttribute("discountPrice", discountPrice);
        request.setAttribute("finalPrice", finalPrice);

        request.setAttribute("loginUser", loginUser);
        
        
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/pay_MS/payMent.jsp");
    }
}