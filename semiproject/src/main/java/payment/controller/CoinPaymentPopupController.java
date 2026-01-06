package payment.controller;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;

public class CoinPaymentPopupController extends AbstractController {

	 @Override
	    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

	        HttpSession session = request.getSession();
	        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

	        // 1️⃣ 로그인 체크
	        if (loginUser == null) {
	            response.setContentType("text/html; charset=UTF-8");
	            response.getWriter().println("""
	                <script>
	                    alert('로그인 후 이용 가능합니다.');
	                    window.close();
	                </script>
	            """);
	            return;
	        }

	        // 2️⃣ GET 요청만 허용
	        if (!"GET".equalsIgnoreCase(request.getMethod())) {
	            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
	            return;
	        }

	        // 3️⃣ finalPrice 검증 (🔥 핵심)
	        int finalPrice;
	        try {
	            finalPrice = Integer.parseInt(request.getParameter("finalPrice"));
	            if (finalPrice <= 0) throw new NumberFormatException();
	        } catch (Exception e) {
	            response.getWriter().println("""
	                <script>
	                    alert('결제 금액이 올바르지 않습니다.');
	                    window.close();
	                </script>
	            """);
	            return;
	        }

	        // 4️⃣ JSP로 넘길 값
	        request.setAttribute("userid", loginUser.getMemberid());
	        request.setAttribute("finalPrice", finalPrice);

	        super.setRedirect(false);
	        super.setViewPage("/WEB-INF/pay_MS/coinPaymentPopup.jsp");
	    }
	}