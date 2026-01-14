package order.model;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import cart.domain.CartDTO;
import order.domain.OrderDTO;

public interface OrderDAO {

	// 주문 생성 → orderId 받기
	int insertOrder(OrderDTO order) throws SQLException;
	
	// 주문 상세 생성 (장바구니 기준)
	int insertOrderDetail(int orderId, CartDTO cart) throws SQLException;

	
	
	// 주문 1건의 요약 정보(주문번호, 금액, 배송지, 상태 등)를 조회
	Map<String, Object> selectOrderHeader(int orderId) throws SQLException;

	// 해당 주문에 포함된 상품 목록(상품/옵션/수량/주문시점 가격)을 조회
	List<Map<String, Object>> selectOrderDetailForPayment(int orderId) throws SQLException;

	// 결제 완료가 되었을때 사용한 해당 쿠폰은 더 이상 사용하지 못하게 하기
	int updateCouponUsed(String memberId, int couponId) throws SQLException;

	// 로그인 한 사용자의 주문내역 가져오기 
	List<OrderDTO> selectOrderSummaryList(String memberid) throws SQLException;

	// 모달용 헤더(내 주문 검증까지)
	Map<String, Object> selectOrderHeaderForModal(int orderId, String memberId) throws SQLException;

	// 모달용 아이템(색상/용량 포함)
	List<Map<String, Object>> selectOrderItemsForModal(int orderId) throws SQLException;
	
	

	

	

	

}
