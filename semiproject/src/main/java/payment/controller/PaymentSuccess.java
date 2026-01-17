package payment.controller;

import java.util.List;
import java.util.Map;

import cart.domain.CartDTO;
import cart.model.CartDAO;
import cart.model.CartDAO_imple;
import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;
import order.model.OrderDAO;
import order.model.OrderDAO_imple;

public class PaymentSuccess extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginUser");

        /* ================= GET : 결제 완료 페이지 조회 ================= */
        if ("GET".equalsIgnoreCase(request.getMethod())) {

            Integer orderId = (Integer) session.getAttribute("lastOrderId");
            
            if (loginuser == null || orderId == null) {
                request.setAttribute("message", "이미 처리된 주문입니다.");
                request.setAttribute("loc", request.getContextPath() + "/index.hp");
                setRedirect(false);
                setViewPage("/WEB-INF/msg.jsp");
                return;
            }

            OrderDAO odao = new OrderDAO_imple();
            request.setAttribute("order", odao.selectOrderHeader(orderId));
            request.setAttribute("orderDetailList", odao.selectOrderDetailForPayment(orderId));

            session.removeAttribute("lastOrderId");

            setRedirect(false);
            setViewPage("/WEB-INF/pay_MS/paymentSuccess.jsp");
            return;
        }

        /* ================= POST : PG사 결제 완료 콜백 처리 ================= */
        if (!"POST".equalsIgnoreCase(request.getMethod()) || loginuser == null) {
            request.setAttribute("message", "비정상 접근");
            request.setAttribute("loc", "javascript:history.back()");
            setRedirect(false);
            setViewPage("/WEB-INF/msg.jsp");
            return;
        }

    //    System.out.println("=== PaymentSuccess 시작 ===");
        
        CartDAO cdao = new CartDAO_imple();
        OrderDAO odao = new OrderDAO_imple();

        /* ================= 주문 ID 확인 ================= */
        Integer orderId = (Integer) session.getAttribute("readyOrderId");

        if (orderId == null) {
    //      System.out.println(" readyOrderId가 null!");
            request.setAttribute("message", "유효하지 않은 결제 요청입니다.");
            request.setAttribute("loc", request.getContextPath() + "/index.hp");
            setRedirect(false);
            setViewPage("/WEB-INF/msg.jsp");
            return;
        }

     //   System.out.println("처리할 주문 ID: " + orderId);

        /* ================= PG사 결제 결과 확인 ================= */
        String paymentStatus = request.getParameter("paymentStatus");
        String pgTid = request.getParameter("pgTid");
        
    //    System.out.println("PG 결제 상태: " + paymentStatus);
    //    System.out.println("PG 거래번호: " + pgTid);

        // paymentStatus 검증
        if (paymentStatus == null || paymentStatus.isBlank()) {
    //        System.out.println(" PG 결제 상태 정보 없음!");
            
            @SuppressWarnings("unchecked")
            List<CartDTO> cartList = (List<CartDTO>) session.getAttribute("payCartList");
            rollbackOrder(odao, orderId, cartList, null);
            clearPaymentSession(session);
            
            request.setAttribute("message", "결제 정보가 올바르지 않습니다.");
            request.setAttribute("loc", request.getContextPath() + "/pay/payMent.hp");
            setRedirect(false);
            setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        /* ================= 결제 실패 처리 ================= */
        if (!"success".equals(paymentStatus)) {
     //      System.out.println(" PG 결제 실패!");
            
            @SuppressWarnings("unchecked")
            List<CartDTO> cartList = (List<CartDTO>) session.getAttribute("payCartList");
            
            rollbackOrder(odao, orderId, cartList, pgTid);
            clearPaymentSession(session);
            
            request.setAttribute("message", "결제가 취소되었습니다.");
            request.setAttribute("loc", request.getContextPath() + "/pay/payMent.hp");
            setRedirect(false);
            setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        /* ================= 결제 성공 처리 ================= */
   //     System.out.println(" PG 결제 성공! 주문 정보 업데이트 시작");
        
        @SuppressWarnings("unchecked")
        List<CartDTO> cartList = (List<CartDTO>) session.getAttribute("payCartList");

        // payCartList 검증
        if (cartList == null || cartList.isEmpty()) {
   //          System.out.println(" payCartList가 null 또는 비어있음!");
            rollbackOrder(odao, orderId, null, pgTid);
            clearPaymentSession(session);
            
            request.setAttribute("message", "주문 상품 정보가 없습니다.");
            request.setAttribute("loc", request.getContextPath() + "/index.hp");
            setRedirect(false);
            setViewPage("/WEB-INF/msg.jsp");
            return;
        }

   //     System.out.println("처리할 상품 수: " + cartList.size());
        for (CartDTO cart : cartList) {
   //         System.out.println("  - " + cart.getProductName() 
   //                          + ", 수량: " + cart.getQuantity()
   //                          + ", 가격: " + cart.getPrice());
        }

        /* ================= 쿠폰 정보 ================= */
        String couponIdParam = request.getParameter("couponId");
        String discountAmountParam = request.getParameter("discountAmount");

        int couponIssueId = 0;
        int discountAmount = 0;

        if (couponIdParam != null && !couponIdParam.isBlank()) {
            try {
                couponIssueId = Integer.parseInt(couponIdParam);
                
                if (couponIssueId > 0) {
                    Map<String, Object> couponInfo =
                        odao.selectCouponInfo(loginuser.getMemberid(), couponIssueId);

                    if (couponInfo == null) {
   //                     System.out.println(" 유효하지 않은 쿠폰");
                        couponIssueId = 0;
                    }
                }
            } catch (NumberFormatException e) {
                couponIssueId = 0;
            }
        }

        if (discountAmountParam != null && !discountAmountParam.isBlank()) {
            try {
                discountAmount = Integer.parseInt(discountAmountParam);
            } catch (NumberFormatException e) {
                discountAmount = 0;
            }
        }

   //     System.out.println("쿠폰ID: " + couponIssueId + ", 할인금액: " + discountAmount);

        /* ================= 배송지 ================= */
        String deliveryAddress = request.getParameter("deliveryAddress");
        if (deliveryAddress == null || deliveryAddress.isBlank()) {
   //         System.out.println(" 배송지 정보 없음!");
            rollbackOrder(odao, orderId, cartList, pgTid);
            clearPaymentSession(session);
            
            request.setAttribute("message", "배송지 정보가 필요합니다.");
            request.setAttribute("loc", request.getContextPath() + "/pay/payMent.hp");
            setRedirect(false);
            setViewPage("/WEB-INF/msg.jsp");
            return;
        }

   //     System.out.println("배송지: " + deliveryAddress);

        /* ================= 주문 최종 처리 ================= */
        try {
    //        System.out.println(">>> 주문 정보 업데이트 시작");

            // 1. 주문 정보 업데이트
            int updateResult = odao.updateOrderDiscountAndAddress(
                orderId, discountAmount, deliveryAddress
            );

            if (updateResult == 0) {
                throw new Exception("주문 정보 업데이트 실패");
            }

     //       System.out.println(" 주문 정보 업데이트 완료");

            // 2. 주문 상태 변경: READY → PAID           
            int updated = odao.updateOrderStatusIfReady(orderId, "PAID");
            if (updated == 0) {
                throw new Exception("이미 처리된 주문이거나 READY 상태가 아님");
            }

            odao.updateDeliveryStatus(orderId, 0);
            
     //       System.out.println(" 주문 상태 업데이트 완료");

            // 3. 쿠폰 사용 처리
            if (couponIssueId > 0) {
                int couponResult = odao.updateCouponUsed(
                    loginuser.getMemberid(), couponIssueId
                );
                if (couponResult > 0) {
      //              System.out.println(" 쿠폰 사용 처리 완료");
                } else {
      //          System.out.println(" 쿠폰 사용 처리 실패 (이미 사용됨?)");
                }
            }

            // 4. 장바구니에서 삭제 (cartId > 0인 것만)
            List<Integer> cartIdsToDelete = cartList.stream()
                    .map(CartDTO::getCartId)
                    .filter(id -> id > 0)
                    .toList();

            if (!cartIdsToDelete.isEmpty()) {
                cdao.deleteSuccessCartId(cartIdsToDelete);
     //           System.out.println(" 장바구니에서 삭제 완료: " + cartIdsToDelete);
            } else {
     //         System.out.println(" 삭제할 장바구니 항목 없음 (바로구매)");
            }

            // 5. 세션 정리
            clearPaymentSession(session);

     //       System.out.println("PaymentSuccess 완료 ===");

        } catch (Exception e) {
     //       System.out.println(" 결제 처리 중 오류 발생!");
            e.printStackTrace();

            rollbackOrder(odao, orderId, cartList, pgTid);

            request.setAttribute("message", "결제 처리 중 문제가 발생했습니다. 다시 시도해주세요.");
            request.setAttribute("loc", request.getContextPath() + "/pay/payMent.hp");
            setRedirect(false);
            setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        /* ================= 완료 페이지로 리다이렉트 ================= */
        session.setAttribute("lastOrderId", orderId);
        setRedirect(true);
        setViewPage(request.getContextPath() + "/payment/paymentSuccess.hp");
    }

    /* ================= 헬퍼 메소드들 ================= */
    
    /**
     * 재고 복구
     */
    private void restoreStock(OrderDAO odao, List<CartDTO> cartList) {
        try {
            int totalRestored = 0;
            int totalFailed = 0;
            
            for (CartDTO cart : cartList) {
                int result = odao.increaseStock(cart.getOptionId(), cart.getQuantity());
                if (result > 0) {
                    totalRestored++;
    //                System.out.println("재고 복구 성공: 옵션ID=" + cart.getOptionId() 
    //                                 + ", 수량=" + cart.getQuantity());
                } else {
                    totalFailed++;
    //               System.out.println(" 재고 복구 실패: 옵션ID=" + cart.getOptionId());
                }
            }
    //          System.out.println("재고 복구 완료: 성공 " + totalRestored + "개, 실패 " + totalFailed + "개");
            
            if (totalFailed > 0) {
    //            System.out.println(" 재고 복구 실패 항목 있음 - 수동 확인 필요!");
            }
        } catch (Exception ex) {
    //        System.out.println(" 재고 복구 중 오류: " + ex.getMessage());
            ex.printStackTrace();
        }
    }
    
    /**
     * 주문 롤백 (실패 처리 + 재고 복구 + PG 결제 취소)
     */
    private void rollbackOrder(OrderDAO odao, int orderId, List<CartDTO> cartList, String pgTid) {
        try {
            // 1. PG 결제 취소 시도 (PG 결제가 완료된 경우만)
            if (pgTid != null && !pgTid.isBlank()) {
     //           System.out.println(">>> PG 결제 취소 시도");
                boolean cancelSuccess = cancelPGPayment(pgTid, orderId);
                
                if (cancelSuccess) {
          //          System.out.println(" PG 결제 취소 성공: " + pgTid);
                } else {
          //          System.out.println(" PG 결제 취소 실패 - 수동 환불 필요!");
           //         System.out.println("   주문번호: " + orderId);
          //          System.out.println("   PG TID: " + pgTid);
                }
            } else {
   //             System.out.println("PG 거래번호 없음 - 결제 전 단계");
            }
            
            // 2. DB 주문 상태 변경
            int updated = odao.updateOrderStatusIfReady(orderId, "FAIL");
            if (updated == 0) {
   //            System.out.println("이미 처리된 주문 - 롤백 스킵");
                return;
            }

            odao.updateDeliveryStatus(orderId, 4); // 배송불가/취소 상태
   //         System.out.println("주문 상태를 FAIL로 변경");

            // 3. 재고 복구 (FAIL 최초 1회만)
            if (cartList != null && !cartList.isEmpty()) {
                restoreStock(odao, cartList);
            }
            
        } catch (Exception e) {
    //        System.out.println("롤백 처리 중 오류: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * PG 결제 취소 API 호출
     */
    private boolean cancelPGPayment(String pgTid, int orderId) {
        try {
    //        System.out.println("=== PG 결제 취소 프로세스 시작 ===");
    //        System.out.println("PG TID: " + pgTid);
    //        System.out.println("주문번호: " + orderId);
            
    //        System.out.println(" PG 결제 취소 API 미구현 상태");
    //        System.out.println(" 관리자 페이지에서 수동 환불 처리 필요:");
    //        System.out.println("   주문번호: " + orderId);
    //        System.out.println("   PG 거래번호: " + pgTid);
    //        System.out.println("   환불 사유: 시스템 오류");
            
    //        System.out.println(" PG 결제 취소 프로세스 종료 ===");
            
            return false;
            
        } catch (Exception e) {
    //        System.out.println(" PG 결제 취소 중 예외 발생: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 세션 정리
     */
    private void clearPaymentSession(HttpSession session) {
        session.removeAttribute("payCartList");
        session.removeAttribute("readyOrderId");
        System.out.println("결제 관련 세션 정리 완료");
    }
}