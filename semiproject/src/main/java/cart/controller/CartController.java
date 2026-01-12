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

    private CartDAO cdao = new CartDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

    	try {
    	        HttpSession session = request.getSession();
    	        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

    	        if (loginUser == null) {
    	            response.setContentType("text/html; charset=UTF-8");
    	            response.getWriter().println("""
    	                <script>
    	                    alert('로그인이 필요합니다.');
    	                    history.back();
    	                </script>
    	            """);
    	            return;
    	        }

    	        String memberId = loginUser.getMemberid();
    	        String method = request.getMethod();

    	        
    	        // GET : 장바구니 조회	       
    	        if ("GET".equalsIgnoreCase(method)) {

    	            List<Map<String, Object>> cartList = cdao.selectCartList(memberId);
    	            request.setAttribute("cartList", cartList);

    	            setRedirect(false);
    	            setViewPage("/WEB-INF/cart_MS/zangCart.jsp");
    	            return;
    	        }

    	        
    	        // POST : 장바구니 내부 처리       
    	        String action = request.getParameter("action");

    	        // 수량 변경 (+ / -)
    	        if ("updateQty".equals(action)) {

    	            int cartId   = Integer.parseInt(request.getParameter("cartId"));
    	            int quantity = Integer.parseInt(request.getParameter("quantity"));

    	            if (quantity < 1 || quantity > 50) {
    	                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
    	                return;
    	            }

    	            int n = cdao.updateQuantity(cartId, memberId, quantity);
    	            if (n == 0) {
    	            	throw new IllegalStateException("수량 변경 실패");                
    	            }

    	            Map<String, Object> cart = cdao.selectCartById(cartId, memberId);

    	            response.setContentType("application/json; charset=UTF-8");
    	            response.getWriter().printf(
    	            	    "{\"quantity\":%d,\"unitPrice\":%d,\"total\":%d}",
    	            	    cart.get("quantity"),
    	            	    cart.get("unit_price"),
    	            	    cart.get("total_price")
    	            	);
    	            return;
    	        }

    	        // 개별 삭제
    	        if ("delete".equals(action)) {

    	            int cartId = Integer.parseInt(request.getParameter("cartId"));
    	            int n = cdao.deleteCart(cartId, memberId);

    	            response.setContentType("application/json; charset=UTF-8");
    	            response.getWriter().print("{\"result\":" + n + "}");
    	            return;
    	        }

    	        response.sendError(HttpServletResponse.SC_BAD_REQUEST);
    	        
	    } catch (NumberFormatException e) {
	        response.sendError(HttpServletResponse.SC_BAD_REQUEST); 
	
	    } catch (IllegalStateException e) {
	        response.setContentType("text/html; charset=UTF-8");
	        response.getWriter().println("""
	            <script>
	                alert('요청 처리 중 문제가 발생했습니다.');
	                history.back();
	            </script>
	        """);
	
	    } catch (Exception e) {
	        e.printStackTrace(); // 로그용
	
	        response.setContentType("text/html; charset=UTF-8");
	        response.getWriter().println("""
	            <script>
	                alert('서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
	                history.back();
	            </script>
	        """);
	    }
	}
}
	    	