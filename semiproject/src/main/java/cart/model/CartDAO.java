package cart.model;

import java.util.List;
import java.util.Map;

import java.sql.SQLException;

public interface CartDAO {

    // option 기준 cart 1건 조회 (있으면 cart_id, quantity)
    Map<String, Object> selectCartByOption(String memberId, int optionId) throws SQLException;

    // 장바구니 목록 조회
    List<Map<String, Object>> selectCartList(String memberId) throws SQLException;

    // cart_id 기준 단건 조회
    Map<String, Object> selectCartById(int cartId, String memberId) throws SQLException;

    // 수량 변경
    int setQuantity(int cartId, String memberId, int quantity) throws SQLException;

    // cart insert 후 생성된 cart_id 반환
    int insertCartAndReturnId(String memberId, int optionId, int quantity) throws SQLException;

    // 바로 구매를 눌렀을때 완전히 똑같은 제품, 용량, 색깔이 아니면 행 자체에 올림
    int upsertCartAndReturnId(String memberId, int optionId, int quantity) throws SQLException;
    
    // 결제 성공 후 cart 삭제
    int deleteSuccessCartId(List<Integer> cartIdList) throws SQLException;

    // 장바구니 개별 삭제
    int deleteCart(int cartId, String memberId) throws SQLException;

    // JOIN 실패 시 fallback
	Map<String, Object> selectRawCartById(int cartId, String memberid) throws SQLException;

	
}