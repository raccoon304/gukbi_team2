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

        // 로그인 안 했으면 경고만 띄우고 접근 차단
        if (memberId == null) {
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().println("""
                <script>
                    alert('로그인한 회원만 장바구니를 이용할 수 있습니다.');
                    history.back();
                </script>
            """);
            return;
        }

        String method = request.getMethod();

        // GET : 장바구니 페이지 조회
        if ("GET".equalsIgnoreCase(method)) {
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/cart_MS/zangCart.jsp");
            return;
        }

        // POST : 장바구니 담기
        if ("POST".equalsIgnoreCase(method)) {
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

                // 있으면 수량만 증가
                if (exists) {
                    mdao.updateQuantity(memberId, optionId, quantity);
                    
                // 없으면 새로 insert
                } else {
                    mdao.insertCart(memberId, optionId, quantity);
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