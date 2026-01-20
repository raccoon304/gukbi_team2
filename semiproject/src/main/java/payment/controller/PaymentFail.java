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

   //     System.out.println("=== PaymentFail 시작 ===");
        
        HttpSession session = request.getSession();
        Integer orderId = (Integer) session.getAttribute("readyOrderId");

        if (orderId == null) {
 //         System.out.println("readyOrderId가 null - 처리할 주문 없음");
            return;
        }

   //     System.out.println("처리할 주문 ID: " + orderId);

        // PG 거래번호 받기 (있을 수도, 없을 수도)
        String pgTid = request.getParameter("pgTid");
        String errorMessage = request.getParameter("errorMessage");
        
  //    System.out.println("PG TID: " + pgTid);
  //    System.out.println("실패 사유: " + errorMessage);

        OrderDAO odao = new OrderDAO_imple();

        try {
            // 1. 주문 상세 조회 (재고 복구용)
            List<Map<String, Object>> orderDetails = odao.selectOrderDetailForPayment(orderId);

            if (orderDetails == null || orderDetails.isEmpty()) {
        //        System.out.println(" 주문 상세 정보 없음!");
                return;
            }

        //    System.out.println("주문 상세 개수: " + orderDetails.size());

            // 2. PG 결제 취소 시도 (PG 거래번호가 있는 경우)
            if (pgTid != null && !pgTid.isBlank()) {
         //       System.out.println(">>> PG 결제 취소 시도");
                boolean cancelSuccess = cancelPGPayment(pgTid, orderId);
                
                if (cancelSuccess) {
         //           System.out.println("PG 결제 취소 성공");
                } else {
         //           System.out.println("PG 결제 취소 실패 - 수동 환불 필요!");
          //          System.out.println("   주문번호: " + orderId);
         //           System.out.println("   PG TID: " + pgTid);
                }
            } else {
          //      System.out.println("PG TID 없음 - 결제 전 단계 실패");
            }

            // 3. READY 상태일 때만 FAIL 처리
            int statusUpdateResult = odao.updateOrderStatusIfReady(orderId, "FAIL");

            if (statusUpdateResult > 0) {
       //         System.out.println("주문 상태 FAIL로 변경 성공");
                
                // 배송 상태도 실패로 변경
                odao.updateDeliveryStatus(orderId, 4);
         //       System.out.println("배송 상태 4(실패)로 변경 완료");

                // 4. 재고 복구
                int totalRestored = 0;
                int totalFailed = 0;
                
                for (Map<String, Object> detail : orderDetails) {
                    int optionId = getInt(detail, "option_id");
                    int quantity = getInt(detail, "quantity");

                    if (optionId == 0 || quantity == 0) {
         //               System.out.println("잘못된 데이터: optionId=" + optionId + ", quantity=" + quantity);
                        totalFailed++;
                        continue;
                    }

                    int result = odao.increaseStock(optionId, quantity);

                    if (result > 0) {
                        totalRestored++;
           //             System.out.println("재고 복구 성공: optionId=" + optionId + ", 수량=" + quantity);
                    } else {
                        totalFailed++;
          //              System.out.println("재고 복구 실패: optionId=" + optionId);
                    }
                }

         //       System.out.println("재고 복구 완료: 성공 " + totalRestored + "개, 실패 " + totalFailed + "개");
                
                if (totalFailed > 0) {
          //          System.out.println(" 재고 복구 실패 항목 있음 - 수동 확인 필요!");
                }

          //      System.out.println(" 결제 실패 처리 완료 (orderId: " + orderId + ")");
                
            } else {
        //        System.out.println(" 이미 처리된 주문 또는 READY 상태 아님 (orderId: " + orderId + ")");
            }

        } catch (Exception e) {
     //       System.out.println(" 결제 실패 처리 중 오류 발생!");
            e.printStackTrace();
            
        } finally {
            // 세션 정리
            session.removeAttribute("readyOrderId");
            session.removeAttribute("payCartList");
      //      System.out.println("결제 관련 세션 정리 완료");
        }

    //    System.out.println("=== PaymentFail 종료 ===");
    }

    /**
     * PG 결제 취소 API 호출
     * @param pgTid PG사 거래번호
     * @param orderId 주문번호
     * @return 취소 성공 여부
     */
    private boolean cancelPGPayment(String pgTid, int orderId) {
        try {
    //        System.out.println("=== PG 결제 취소 프로세스 시작 ===");
    //        System.out.println("PG TID: " + pgTid);
    //       System.out.println("주문번호: " + orderId);
            
            // ===== Phase 1: 로그만 남기고 수동 처리 =====
    //        System.out.println(" PG 결제 취소 API 미구현 상태");
    //        System.out.println(" 관리자 페이지에서 수동 환불 처리 필요:");
    //        System.out.println("   - 주문번호: " + orderId);
    //        System.out.println("   - PG 거래번호: " + pgTid);
    //         System.out.println("   - 환불 사유: 사용자 결제 취소");
             
    //        System.out.println("=== PG 결제 취소 프로세스 종료 ===");
            
            return false; // Phase 1에서는 수동 처리 필요
            
        } catch (Exception e) {
   //         System.out.println(" PG 결제 취소 중 예외 발생: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /*
      
     */
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
