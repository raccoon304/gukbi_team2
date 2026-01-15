package pay.controller;

import java.util.Map;
import org.json.JSONObject;
import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;
import order.model.OrderDAO;
import order.model.OrderDAO_imple;

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

        /* ===== 파라미터 ===== */
        String productCode = request.getParameter("productCode");
        String optionIdStr = request.getParameter("optionId");
        String quantityStr = request.getParameter("quantity");

        // 디버깅 로그
        System.out.println("========================================");
        System.out.println("PayPreviewController - Parameters:");
        System.out.println("productCode: [" + productCode + "]");
        System.out.println("optionIdStr: [" + optionIdStr + "]");
        System.out.println("quantityStr: [" + quantityStr + "]");
        System.out.println("========================================");

        if (productCode == null || optionIdStr == null || quantityStr == null) {
            System.out.println("ERROR: Parameter is null!");
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
            System.out.println("Parsed - optionId: " + optionId + ", quantity: " + quantity);
        } catch (NumberFormatException e) {
            System.out.println("ERROR: Number format exception!");
            json.put("success", false);
            json.put("message", "수량 또는 옵션 오류");
            response.getWriter().print(json.toString());
            return;
        }

        /* ===== DB 조회 ===== */
        OrderDAO odao = new OrderDAO_imple();
        Map<String, Object> item = odao.selectDirectProduct(productCode, optionId, quantity);

        System.out.println("========================================");
        System.out.println("DB Query Result:");
        System.out.println("item: " + item);
        System.out.println("item is null? " + (item == null));
        System.out.println("========================================");

        if (item == null) {
            System.out.println("ERROR: Item is null - DB query failed!");
            json.put("success", false);
            json.put("message", "상품 조회 실패");
            response.getWriter().print(json.toString());
            return;
        }

        // 세션에 저장
        session.setAttribute("directOrderItem", item);
        
        // 세션 저장 확인
        Object savedItem = session.getAttribute("directOrderItem");
        System.out.println("========================================");
        System.out.println("Session saved item: " + savedItem);
        System.out.println("Session ID: " + session.getId());
        System.out.println("========================================");

        json.put("success", true);
        json.put("redirect", request.getContextPath() + "/pay/payMent.hp");

        response.getWriter().print(json.toString());
    }
}