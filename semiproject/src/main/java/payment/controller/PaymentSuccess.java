package payment.controller;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class PaymentSuccess extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		 // POST만 허용
        if (!"POST".equalsIgnoreCase(request.getMethod())) {
            request.setAttribute("message", "비정상적인 접근입니다.");
            request.setAttribute("loc", "javascript:history.back()");
            setRedirect(false);
            setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        // POST 데이터
        String impUid = request.getParameter("imp_uid");
        String merchantUid = request.getParameter("merchant_uid");

        if (impUid == null || merchantUid == null) {
            request.setAttribute("message", "결제 정보 누락");
            request.setAttribute("loc", "javascript:history.back()");
            setRedirect(false);
            setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        // 🔥 여기서 DB 처리 / 결제 검증

        setRedirect(false);
        setViewPage("/WEB-INF/payment/paymentSuccess.jsp");
    }
}

