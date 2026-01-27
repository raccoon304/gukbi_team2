package payment.controller;


import java.util.List;
import java.util.Map;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import order.model.OrderDAO;
import order.model.OrderDAO_imple;

public class PaymentFail extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        HttpSession session = request.getSession();
        Integer orderId = (Integer) session.getAttribute("readyOrderId");

        if (orderId == null) {
            return;
        }


        // PG 거래번호 받기 (있을 수도, 없을 수도)
        String pgTid = request.getParameter("pgTid");
        String errorMessage = request.getParameter("errorMessage");
        
        OrderDAO odao = new OrderDAO_imple();

        try {
            // 1. 주문 상세 조회 (재고 복구용)
            List<Map<String, Object>> orderDetails = odao.selectOrderDetailForPayment(orderId);

            if (orderDetails == null || orderDetails.isEmpty()) {
                return;
            }


            // 2. PG 결제 취소 시도 (PG 거래번호가 있는 경우)
            if (pgTid != null && !pgTid.isBlank()) {
         
                boolean cancelSuccess = cancelPGPayment(pgTid, orderId);
                
                if (cancelSuccess) {
         
                } else {
         
                }
            } else {
         
            }

            // 3. READY 상태일 때만 FAIL 처리
            int statusUpdateResult = odao.updateOrderStatusIfReady(orderId, "FAIL");

            if (statusUpdateResult > 0) {
     
                
                
                odao.updateDeliveryStatus(orderId, 4);
        
                // 4. 재고 복구
                int totalRestored = 0;
                int totalFailed = 0;
                
                for (Map<String, Object> detail : orderDetails) {
                    int optionId = getInt(detail, "option_id");
                    int quantity = getInt(detail, "quantity");

                    if (optionId == 0 || quantity == 0) {
         
                        totalFailed++;
                        continue;
                    }

                    int result = odao.increaseStock(optionId, quantity);

                    if (result > 0) {
                        totalRestored++;
           
                    } else {
                        totalFailed++;
          
                    }
                }

        
                
                if (totalFailed > 0) {
         
                }

        
                
            } else {
       
            }

        } catch (Exception e) {
  
            e.printStackTrace();
            
        } finally {
         
            session.removeAttribute("readyOrderId");
            session.removeAttribute("payCartList");
     
        }

    
    }

 
    private boolean cancelPGPayment(String pgTid, int orderId) {
        try {
    
            
            return false; // Phase 1에서는 수동 처리 필요
            
        } catch (Exception e) {
   
            e.printStackTrace();
            return false;
        }
    }

    private int getInt(Map<String, Object> map, String key) {
        Object v = map.get(key);
        if (v == null) return 0;
        if (v instanceof Number) return ((Number) v).intValue();
        try {
            return Integer.parseInt(String.valueOf(v));
        } catch (Exception e) {
            return 0;
        }
    }
}
