package admin.controller;

import common.controller.AbstractController;
import coupon.model.CouponDAO;
import coupon.model.CouponDAO_imple;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class CouponEnable extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		CouponDAO cdao = new CouponDAO_imple();
		
		String msg = "처리 실패";
        String sNo = request.getParameter("couponCategoryNo");

        try {
            if (sNo == null || sNo.trim().isEmpty()) {
                msg = "쿠폰번호가 없습니다.";
            } else {
                int couponCategoryNo = Integer.parseInt(sNo);

                int n = cdao.enableCoupon(couponCategoryNo); // USABLE=1
                msg = (n == 1) ? "사용함으로 변경 완료" : "DB 업데이트 실패";
            }
        } catch (Exception e) {
            msg = "오류가 발생했습니다.";
        }

        // flash message (한 번만 보여주기)
	    HttpSession session = request.getSession();
	    session.setAttribute("flashMsg", msg);

	    super.setRedirect(true);
	    super.setViewPage(request.getContextPath() + "/admin/coupon.hp"); // msg 파라미터 제거
		
	}

}
