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

        // 로그인 체크
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

        // GET : 팝업 페이지 열기
        if ("GET".equalsIgnoreCase(request.getMethod())) {

            request.setAttribute("userid", loginUser.getMemberid());
            request.setAttribute("finalPrice", request.getParameter("finalPrice"));

            super.setRedirect(false);
            super.setViewPage("/WEB-INF/pay_MS/CoinPaymentPopup.jsp");
            return;
        }
    }
}