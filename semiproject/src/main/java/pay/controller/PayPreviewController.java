package pay.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import org.json.JSONObject;
import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;
import cart.model.CartDAO;
import cart.model.CartDAO_imple;

public class PayPreviewController extends AbstractController {
    
    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");
        
        HttpSession session = request.getSession();
        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
        
        JSONObject json = new JSONObject();
        
        /* ===== 로그인 체크 ===== */
        if (loginUser == null) {
            json.put("success", false);
            json.put("message", "로그인이 필요합니다.");
            response.getWriter().print(json.toString());
            return;
        }
        
       
        System.out.println("cartList in session = " + session.getAttribute("cartList"));
        System.out.println("directOrderList in session = " + session.getAttribute("directOrderList"));
        
        /* ===== 파라미터 ===== */
        String productCode = request.getParameter("productCode");
        String optionIdStr = request.getParameter("optionId");
        String quantityStr = request.getParameter("quantity");
        
        if (productCode == null || optionIdStr == null || quantityStr == null) {
            json.put("success", false);
            json.put("message", "잘못된 요청입니다.");
            response.getWriter().print(json.toString());
            return;
        }
        
        int optionId;
        int quantity;
        
        try {
            optionId = Integer.parseInt(optionIdStr);
            quantity = Integer.parseInt(quantityStr);
        } catch (NumberFormatException e) {
            json.put("success", false);
            json.put("message", "수량 또는 옵션 오류");
            response.getWriter().print(json.toString());
            return;
        }
        
        /* ===== DB 조회 ===== */
        CartDAO cartDao = new CartDAO_imple();
        Map<String, Object> item = cartDao.selectDirectProduct(productCode, optionId, quantity);
        
        if (item == null) {
            json.put("success", false);
            json.put("message", "상품 조회 실패");
            response.getWriter().print(json.toString());
            return;
        }
        
        // 
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> directOrderList =
            (List<Map<String, Object>>) session.getAttribute("directOrderList");

        if (directOrderList == null) {
            directOrderList = new ArrayList<>();
        }

        // 중복 체크 (product_code + option_id)
        boolean isDuplicate = false;
        for (Map<String, Object> existing : directOrderList) {
            String existingCode = String.valueOf(existing.get("product_code"));
            int existingOptionId = Integer.parseInt(String.valueOf(existing.get("option_id")));

            if (existingCode.equals(productCode) && existingOptionId == optionId) {
                int existingQty = Integer.parseInt(String.valueOf(existing.get("quantity")));
                int newQty = existingQty + quantity;

                existing.put("quantity", newQty);
                existing.put("total_price",
                    Integer.parseInt(String.valueOf(existing.get("unit_price"))) * newQty);

                isDuplicate = true;
                break;
            }
        }

        if (!isDuplicate) {
            directOrderList.add(item);
        }

        session.setAttribute("directOrderList", directOrderList);
        
        json.put("success", true);
        json.put("redirect", request.getContextPath() + "/pay/payMent.hp");
        response.getWriter().print(json.toString());
    }
}
