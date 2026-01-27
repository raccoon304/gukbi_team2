package order.model;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import order.domain.OrderDTO;

public interface OrderDAO {
    
    /* ================= 오래된 READY 주문 FAIL 처리 ================= */
	int expireReadyOrders() throws SQLException;
  
    // 주문 + 주문상세 (트랜잭션 통합, PG 결제용)
    int insertOrderWithDetailsAnd(OrderDTO order, List<Map<String, Object>> orderDetails);
    
    /* ================= 주문 조회 ================= */
    // 주문 1건의 요약 정보(주문번호, 금액, 배송지, 상태 등)
    Map<String, Object> selectOrderHeader(int orderId) throws SQLException;
    
    // 해당 주문에 포함된 상품 목록(상품/옵션/수량/주문시점 가격)
    List<Map<String, Object>> selectOrderDetailForPayment(int orderId) throws SQLException;
    
    // 로그인 한 사용자의 주문내역 가져오기 
    List<OrderDTO> selectOrderSummaryList(String memberid) throws SQLException;
    
    // 모달용 헤더(내 주문 검증까지)
    Map<String, Object> selectOrderHeaderForModal(int orderId, String memberId) throws SQLException;
    
    // 모달용 아이템(색상/용량 포함)
    List<Map<String, Object>> selectOrderItemsForModal(int orderId) throws SQLException;
    
    // 손영대의 orderpage용
    Map<String, Object> selectOrderHeaderforYD(int orderId) throws SQLException;
    
    /* ================= 주문 상태 관리 ================= */
    // 주문이 최종적으로 성공했는지 실패했는지를 기록
    void updateOrderStatus(int orderId, String status) throws SQLException;
    
    // PG 결제 실패 발생 시 주문 상태를 FAIL로 업데이트 (READY 상태만)
    int updateOrderStatusIfReady(Integer orderId, String status) throws SQLException;
    
    // 주문의 배송 상태를 코드값(0: 준비, 4: 실패 등)으로 업데이트
    void updateDeliveryStatus(Integer orderId, int status) throws SQLException;
    
    // 주문 업데이트 (할인금액, 배송지)
    int updateOrderDiscountAndAddress(int orderId, int discountAmount, String deliveryAddress) throws SQLException;
    
    /* ================= 쿠폰 관리 ================= */
    // 쿠폰 할인 서버 계산
    Map<String, Object> selectCouponInfo(String memberId, int couponId) throws SQLException;
    
    // 결제 완료가 되었을때 사용한 해당 쿠폰은 더 이상 사용하지 못하게 하기
    int updateCouponUsed(String memberId, int couponId) throws SQLException;
    
    // 결제 완료 이후 쿠폰을 결제페이지 화면에서 안보이게 하는 기능
    List<Map<String, Object>> selectAvailableCoupons(String memberid) throws SQLException;
    
    /* ================= 재고 관리 ================= */
    // 재고 조회
    int selectStock(int optionId) throws SQLException;
    
    // 결제 성공 시 재고 차감
    int decreaseStock(int optionId, int quantity) throws SQLException;
    
    // 결제 실패 시 재고 반환
    int increaseStock(int optionId, int quantity) throws SQLException;

    // 해킹 방지 
	boolean isOrderOwner(int orderId, String memberid) throws SQLException;
	
	/* ================ 주문 불일치 수습 =============== */
	// 주문 상태 조회
	String getOrderStatus(Integer orderId) throws SQLException;

	// 주문 금액 조회
	int getOrderAmount(Integer orderId) throws SQLException;

	// 주문 상태를 PAID로 업데이트 (imp_uid 포함)
	int updateOrderStatusToPaid(Integer orderId, String impUid) throws SQLException;

	// 주문 ID 기준 재고 일괄 차감
	int decreaseStockByOrderId(Integer orderId) throws SQLException;


}