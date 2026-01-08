package delivery.model;

import java.sql.SQLException;
import java.util.List;

import delivery.domain.DeliveryDTO;

public interface DeliveryDAO {

	// 배송지 목록 가져오기 
	List<DeliveryDTO> selectDeliveryList(String memberid) throws SQLException;

}
