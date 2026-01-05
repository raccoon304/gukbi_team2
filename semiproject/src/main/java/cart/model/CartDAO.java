package cart.model;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import cart.domain.CartDTO;

public interface CartDAO {

	// 이미 장바구니에 있는지 확인
	boolean isOptionInCart(String memberId, int optionId) throws SQLException; 

	// 있으면 수량만 증가
	int updateQuantity(String memberId, int optionId, int quantity) throws SQLException;
	
	// 없으면 새로 insert
	int insertCart(String memberId, int optionId, int quantity) throws SQLException;
	
	// 장바구니 목록 조회 (체크박스/이미지/가격)
    List<Map<String, Object>> selectCartList(String memberId) throws SQLException;

    
    // 선택 삭제
    int deleteCart(int cartId, String memberId) throws SQLException;
     
    /*
    // 전체 삭제
    int deleteAll(String memberId) throws SQLException;
    */
    
    // 장바구니 내부에서 수량 변경
	int updateQuantity(int cartId, String memberId, int quantity) throws SQLException;
	
	// 특정 회원(memberId)의 장바구니에서, 특정 행(cartId) 하나의 정보를 조회
	Map<String, Object> selectCartById(int cartId, String memberId) throws SQLException;
	
	// 결제 페이지 전용 (DTO)
	List<CartDTO> selectCartListForPay(String memberId) throws SQLException;

}
