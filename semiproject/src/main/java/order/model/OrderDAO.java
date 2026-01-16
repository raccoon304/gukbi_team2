package order.model;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import order.domain.OrderDTO;

public interface OrderDAO {

     /* ================= 오래된 READY 주문 FAIL 처리 (본인 것만) ================= */
     int expireReadyOrders(String memberid) throws SQLException;
   
     // 주문 생성 → orderId 받기
      int insertOrder(OrderDTO order) throws SQLException;
   
   	  // 주문 상세 생성
      int insertOrderDetail(int orderId, int optionId, int quantity, int unitPrice, String productName, String brandName)
            throws SQLException;

      // 주문 1건의 요약 정보(주문번호, 금액, 배송지, 상태 등)를 조회
      Map<String, Object> selectOrderHeader(int orderId) throws SQLException;

      // 해당 주문에 포함된 상품 목록(상품/옵션/수량/주문시점 가격)을 조회
      List<Map<String, Object>> selectOrderDetailForPayment(int orderId) throws SQLException;

	  // 결제 완료가 되었을때 사용한 해당 쿠폰은 더 이상 사용하지 못하게 하기
	  int updateCouponUsed(String memberId, int couponId) throws SQLException;
 
   	  // 결제 완료가 되었을때 주문한 수량만큼 재고 차감하기
      int decreaseStock(int optionId, int quantity) throws SQLException;
	
	  // 쿠폰 할인 서버 계산
	  Map<String, Object> selectCouponInfo(String memberid, int couponId) throws SQLException;
	  
	  // 주문이 최종적으로 성공했는지 실패했는지를 기록하는 메서드
	  void updateOrderStatus(int orderId, String string) throws SQLException;

     // 결제 완료 이후 쿠폰을 결제페이지 화면에서 안보이게 하는 기능
     List<Map<String, Object>> selectAvailableCoupons(String memberid) throws SQLException;

     // 주문의 배송 상태를 코드값(0: 준비, 4: 실패 등)으로 업데이트
     void updateDeliveryStatus(Integer orderId, int i) throws SQLException;
 
     // 주문 업데이트
     int updateOrderDiscountAndAddress(int orderId, int discountAmount, String deliveryAddress) throws SQLException;
   
     // 로그인 한 사용자의 주문내역 가져오기 
 	 List<OrderDTO> selectOrderSummaryList(String memberid) throws SQLException;

 	 // 모달용 헤더(내 주문 검증까지)
 	 Map<String, Object> selectOrderHeaderForModal(int orderId, String memberId) throws SQLException;

 	 // 모달용 아이템(색상/용량 포함)
 	 List<Map<String, Object>> selectOrderItemsForModal(int orderId) throws SQLException;

 	 // PG 결제 실패 발생 시 주문 상태를 FAIL로 업데이트 (READY 상태만)
  	 int updateOrderStatusIfReady(Integer orderId, String string) throws SQLException;

  	 // 재고 조회
  	 int selectStock(int optionId) throws SQLException;
  	 
	 // 손영대의 orderpage용
	 Map<String, Object> selectOrderHeaderforYD(int orderId) throws SQLException;

	 // 결제 실패 시 재고 반환
	 int increaseStock(int optionId, int quantity) throws SQLException;

	 int insertOrderWithDetails(OrderDTO order, List<Map<String, Object>> orderDetails) throws SQLException;
	 
	 

	 
    

     
   
   

   

   

   

}
