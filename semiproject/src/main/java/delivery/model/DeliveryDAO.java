package delivery.model;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import delivery.domain.DeliveryDTO;

public interface DeliveryDAO {

	// 배송지 목록 가져오기 
	List<DeliveryDTO> selectDeliveryList(String memberid) throws SQLException;

	// 배송지 삭제 메서드
	int deleteDelivery(Map<String, String> paraMap) throws SQLException;

	// 선택된 체크박스중에 기본배송지가 있는지 확인해주는 메서드.
	boolean hasDefaultAddressInSelection(Map<String, String> paraMap) throws SQLException;

	// 배송지 추가일 경우
	int insertDelivery(Map<String, String> paraMap) throws SQLException;
	
	// 배송지를 수정하는 메서드
	int updateDelivery(Map<String, String> paraMap) throws SQLException;

	// 기본배송지를 변경 하는 메서드 
	int setDefaultDelivery(Map<String, String> paraMap) throws SQLException;

}
