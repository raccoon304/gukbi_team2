package cart.controller;

import cart.model.CartDAO_imple;

import java.util.List;
import java.util.Map;

import cart.model.CartDAO;
import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;

public class CartController extends AbstractController {

    private CartDAO mdao = new CartDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

    HttpSession session = request.getSession();
        

    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
        
    if (loginUser == null) {
        loginUser = new MemberDTO();
        loginUser.setMemberid("testuser");
        loginUser.setName("테스트유저");
        loginUser.setMobile("010-0000-0000");

        session.setAttribute("loginUser", loginUser);
    }
    
    
        // 로그인 안 했으면 경고만 띄우고 접근 차단
		/*    
		    if (loginUser == null) {
		        response.setContentType("text/html; charset=UTF-8");
		        response.getWriter().println(
		            "<script>" +
		            "alert('로그인한 회원만 장바구니를 이용할 수 있습니다.');" +
		            "location.href = '\" + request.getContextPath() + \"/login/login.jsp';" +
		            "</script>"
		        );
		        return;
		    }
		*/
		    // DAO에서 쓰는 memberId (String)
		    String memberId = loginUser.getMemberid();
		
		    String method = request.getMethod();


        // GET : 장바구니 페이지 조회
        if ("GET".equalsIgnoreCase(method)) {

            // 장바구니 목록 조회 (체크박스/이미지/가격)
            List<Map<String, Object>> cartList = mdao.selectCartList(memberId);

            request.setAttribute("cartList", cartList);

            super.setRedirect(false);
            super.setViewPage("/WEB-INF/cart_MS/zangCart.jsp");
            return;
        }

        // POST : 장바구니 담기
        if ("POST".equalsIgnoreCase(method)) {
        	String action = request.getParameter("action");

        	// + / − 버튼 (AJAX)
        	if ("updateQty".equals(action)) {

        		int cartId   = Integer.parseInt(request.getParameter("cartId"));
        		int quantity = Integer.parseInt(request.getParameter("quantity"));

        		 if (quantity < 1 || quantity > 50) {
        		        response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        		        return;
        		 }
        		
        		int n = mdao.updateQuantity(cartId, memberId, quantity);
        		if (n == 0) {
        	        response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        	        return;
        	    }
        		
        		Map<String, Object> cart = mdao.selectCartById(cartId, memberId);
        		if (cart == null) {
        	        response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        	        return;
        	    }

        		response.setContentType("application/json; charset=UTF-8");
        		response.getWriter().printf(
        		    "{\"quantity\":%d,\"total\":%d}",
        		    cart.get("quantity"),
        		    cart.get("total_price")
        		);
        	    return;
        	}
        	
        	/*
        	// 개별 삭제
        	if ("delete".equals(action)) {

        	    int cartId = Integer.parseInt(request.getParameter("cartId"));

        	    int n = mdao.deleteCart(cartId, memberId);

        	    response.setContentType("application/json; charset=UTF-8");
        	    response.getWriter().print("{\"result\":" + n + "}");
        	    return;
        	}
        	*/
        	
        	// 전체 삭제
        	if ("deleteAll".equals(action)) {

        		 int n = mdao.deleteAll(memberId);

        		    response.setContentType("application/json; charset=UTF-8");
        		    response.getWriter().print("{\"result\":" + n + "}");
        		    return;
        		
        	}
        	
            String optionIdStr = request.getParameter("optionId");
            String quantityStr = request.getParameter("quantity");

            // 파라미터 null 체크
            if (optionIdStr == null || quantityStr == null) {
                response.setContentType("text/html; charset=UTF-8");
                response.getWriter().println("""
                    <script>
                        alert('필수 정보가 누락되었습니다.');
                        history.back();
                    </script>
                """);
                return;
            }

            try {
                int optionId = Integer.parseInt(optionIdStr);
                int quantity = Integer.parseInt(quantityStr);

                // 입력값 유효성 검증
                if (optionId <= 0 || quantity <= 0) {
                    response.setContentType("text/html; charset=UTF-8");
                    response.getWriter().println("""
                        <script>
                            alert('잘못된 입력값입니다.');
                            history.back();
                        </script>
                    """);
                    return;
                }

                // 장바구니에 이미 있는지 확인 후 처리
                boolean exists = mdao.isOptionInCart(memberId, optionId);

                int n;
                // 있으면 수량만 증가
                if (exists) {
                    n = mdao.updateQuantity(memberId, optionId, quantity);
                    
                // 없으면 새로 insert
                } else {
                    n = mdao.insertCart(memberId, optionId, quantity);
                }
                
                if (n == 0) {
                    throw new RuntimeException("장바구니 처리 실패");
                }
                // 성공 시 장바구니 페이지로 리다이렉트
                super.setRedirect(true);
                super.setViewPage(request.getContextPath() + "/cart/zangCart.hp");

            } catch (NumberFormatException e) {
                // 숫자 변환 실패
                response.setContentType("text/html; charset=UTF-8");
                response.getWriter().println("""
                    <script>
                        alert('올바른 형식의 데이터가 아닙니다.');
                        history.back();
                    </script>
                """);
            } catch (Exception e) {
                // 기타 예외 처리
                e.printStackTrace();
                response.setContentType("text/html; charset=UTF-8");
                response.getWriter().println("""
                    <script>
                        alert('장바구니 담기에 실패했습니다. 잠시 후 다시 시도해주세요.');
                        history.back();
                    </script>
                """);
            }
        }
    }
}