package pay.model;

import java.util.Map;

public interface CheckoutDAO {
	
	// cardId 파싱
	Map<String, Object> selectCartItemForCheckout(int cartId, String memberId);

}
