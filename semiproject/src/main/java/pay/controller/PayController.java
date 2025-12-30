package pay.controller;

	import common.controller.AbstractController;
	import jakarta.servlet.http.HttpServletRequest;
	import jakarta.servlet.http.HttpServletResponse;

	public class PayController extends AbstractController {

		@Override
		public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
			
			
			String method = request.getMethod();
			
			
			super.setRedirect(false);
			super.setViewPage("/WEB-INF/pay_MS/payMent.jsp");
		}

	}


