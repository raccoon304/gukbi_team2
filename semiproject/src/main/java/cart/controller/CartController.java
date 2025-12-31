package cart.controller;

import cart.model.CartDAO_imple;
import cart.model.CartDAO;
import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class CartController extends AbstractController {

	private CartDAO mdao = new CartDAO_imple();
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

	    HttpSession session = request.getSession();
	    String memberId = (String) session.getAttribute("loginUser");

	    // 🔒 로그인 안 했으면 튕김
	    if (memberId == null) {
	        super.setRedirect(true);
	        super.setViewPage(request.getContextPath() + "/member/login.hp");
	        return;
	    }

	    String method = request.getMethod();

	    
	    //  GET : 장바구니 페이지 조회 
	    if ("GET".equalsIgnoreCase(method)) {

	        // optionId / quantity 는 보존
	        super.setRedirect(false);
	        super.setViewPage("/WEB-INF/cart_MS/zangCart.jsp");
	        return;
	    }

	    // =====================
	    // 2️⃣ POST : 장바구니 담기
	    // =====================
	    if ("POST".equalsIgnoreCase(method)) {

	        String optionIdStr = request.getParameter("optionId");
	        String quantityStr = request.getParameter("quantity");

	        // 방어코드 
	        if (optionIdStr == null || quantityStr == null) {
	            super.setRedirect(true);
	            super.setViewPage(request.getContextPath() + "/cart/zangCart.hp");
	            return;
	        }

	        int optionId = Integer.parseInt(optionIdStr);
	        int quantity = Integer.parseInt(quantityStr);

	        // 이미 장바구니에 있는지 확인
	        boolean exists = mdao.isOptionInCart(memberId, optionId);

	        if (exists) {
	            // 👉 있으면 수량 증가
	            mdao.updateQuantity(memberId, optionId, quantity);
	        } else {
	            // 👉 없으면 새로 insert
	            mdao.insertCart(memberId, optionId, quantity);
	        }

	        // POST → Redirect (새로고침 중복 방지)
	        super.setRedirect(true);
	        super.setViewPage(request.getContextPath() + "/cart/zangCart.hp");
	        return;
	    }
	}
}

