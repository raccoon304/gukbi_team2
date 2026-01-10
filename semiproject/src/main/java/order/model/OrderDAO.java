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

	

}
