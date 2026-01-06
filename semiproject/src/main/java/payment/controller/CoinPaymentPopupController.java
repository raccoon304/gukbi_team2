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
		
        
            String method = request.getMethod(); // GET / POST

            /* ================= 로그인 체크 ================= */
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

            /* ================= POST 요청만 허용 ================= */
            if ("POST".equalsIgnoreCase(method)) {

                // 1. 파라미터 수신 (※ 최소화)
                String paymentId = request.getParameter("paymentId");

                if (paymentId == null || paymentId.trim().isEmpty()) {
                    response.getWriter().println("""
                        <script>
                            alert('잘못된 결제 요청입니다.');
                            window.close();
                        </script>
                    """);
                    return;
                }

                // 2. 여기서 서버 기준으로 결제정보 조회 (DAO)
                // PaymentDTO pay = paymentDao.selectPayment(paymentId, loginUser.getMemberid());

                // 예시 (임시)
                int finalPrice = 2200000;

                // 3. JSP 전달
                request.setAttribute("finalPrice", finalPrice);
                request.setAttribute("userid", loginUser.getMemberid());

                // 4. PG 팝업 JSP 이동
                super.setRedirect(false);
                super.setViewPage("/WEB-INF/payment/coinPaymentPopup.jsp");
            }
            else {
                // GET 직접 접근 차단
                response.setContentType("text/html; charset=UTF-8");
                response.getWriter().println("""
                    <script>
                        alert('비정상적인 접근입니다.');
                        window.close();
                    </script>
                """);
            }
        }
    }


