package payment.controller;

import java.io.BufferedReader;

import org.json.JSONObject;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import order.model.OrderDAO;
import order.model.OrderDAO_imple;
import payment.service.PGPayment;
import payment.service.PGService;

public class PaymentBehind extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        if (!"POST".equalsIgnoreCase(request.getMethod())) {
            response.setStatus(405);
            return;
        }

        try {
            BufferedReader reader = request.getReader();
            StringBuilder json = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                json.append(line);
            }
            
            JSONObject data = new JSONObject(json.toString());
            String impUid = data.getString("imp_uid");
            String merchantUid = data.getString("merchant_uid");
            String status = data.getString("status");
            
            if (!"paid".equals(status)) {
                response.setStatus(200);
                response.getWriter().write("ok");
                return;
            }
            
            // merchant_uid에서 order_id 추출 (예: "order_532" → 532)
            int orderId = Integer.parseInt(merchantUid.replace("order_", ""));
            
            // PG 서버에서 실제 결제 정보 조회
            PGService pgService = new PGService();
            PGPayment payment = pgService.getPaymentInfo(impUid);
            
            if (!payment.isPaid()) {
                response.setStatus(200);
                response.getWriter().write("pg_verify_failed");
                return;
            }
            
            OrderDAO odao = new OrderDAO_imple();
            String currentStatus = odao.getOrderStatus(orderId);
            
            if (currentStatus == null) {
                response.setStatus(200);
                response.getWriter().write("order_not_found");
                return;
            }
            
            // READY 또는 FAIL 상태인 경우에만 복구
            if ("READY".equals(currentStatus) || "FAIL".equals(currentStatus)) {
                
                // 금액 검증
                int dbAmount = odao.getOrderAmount(orderId);
                if (payment.getAmount() != dbAmount) {
                    response.setStatus(200);
                    response.getWriter().write("amount_mismatch");
                    return;
                }
                
                // PAID로 업데이트
                int updated = odao.updateOrderStatusToPaid(orderId, impUid);
                
                // FAIL에서 복구된 경우 재고 차감 (결제 완료 시점 재고 차감이라 > 0으로 변경)
                if (updated > 0) {
                    odao.decreaseStockByOrderId(orderId);
                }
            }
            
            response.setStatus(200);
            response.getWriter().write("success");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(500);
            response.getWriter().write("error");
        }
    }
}