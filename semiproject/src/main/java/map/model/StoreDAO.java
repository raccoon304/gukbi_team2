package map.model;

import java.sql.SQLException;
import java.util.List;
import map.domain.StoreDTO;

public interface StoreDAO {
	// 활성화된 매장 가져오기 
    List<StoreDTO> selectActiveStores() throws SQLException;
    
    // 매장 추가.
    int insertStore(StoreDTO dto) throws SQLException;
}
