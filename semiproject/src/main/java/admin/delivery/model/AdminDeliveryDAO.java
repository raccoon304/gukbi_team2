package admin.delivery.model;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import admin.delivery.domain.AdminDeliveryDTO;

public interface AdminDeliveryDAO {

	 // 총 주문건수(검색/필터 포함)
    int getTotalOrderCount(Map<String, String> paraMap) throws SQLException;

    // 총 페이지수
    int getTotalPageOrder(Map<String, String> paraMap) throws SQLException;

    // 페이지별 주문/배송 리스트
    List<AdminDeliveryDTO> selectOrderDeliveryPaging(Map<String, String> paraMap) throws SQLException;

    // 배송상태 일괄 변경(결제실패 제외)
    int updateDeliveryStatus(List<Long> orderIdList, int newStatus) throws SQLException;
    
}
