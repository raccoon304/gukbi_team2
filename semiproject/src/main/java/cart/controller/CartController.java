package cart.controller;

import cart.model.CarDAO_imple;
import cart.model.CartDAO;
import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class CartController extends AbstractController {

	private CartDAO mdao = new CarDAO_imple();
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		
		HttpSession session = request.getSession();
		Object loginuser = session.getAttribute("loginuser");

		// 만약 로그아웃 상태이면
		if (loginuser == null) {
			super.setRedirect(true);
			super.setViewPage(request.getContextPath() + "/login/login.hp");
			return;
		}
		 String method = request.getMethod();

		    if ("GET".equalsIgnoreCase(method)) {

		        // 장바구니에 있는 내용 조회하기
		        // request.setAttribute("cartList", cartList);

		        super.setRedirect(false);
		        super.setViewPage("/WEB-INF/cart_MS/zangCart.jsp");
		    }
		    else { // 로그인 상태일때

		        // 👉 수량 + / - / 삭제 처리
		        // String action = request.getParameter("action");

		        super.setRedirect(true);
		        super.setViewPage("zangCart.hp");
		        return;
		    }
	}
}
