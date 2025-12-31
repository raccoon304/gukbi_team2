package cart.model;

import java.sql.SQLException;
import java.util.Map;

public interface CartDAO {

	// 이미 장바구니에 있는지 확인
	boolean isOptionInCart(String memberId, int optionId) throws SQLException; 

	// 있으면 수량만 증가
	void updateQuantity(String memberId, int optionId, int quantity) throws SQLException;
	
	// 없으면 새로 insert
	void insertCart(String memberId, int optionId, int quantity) throws SQLException;
	
}
