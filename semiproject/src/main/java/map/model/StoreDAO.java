package map.model;

import java.sql.SQLException;
import java.util.List;
import map.domain.StoreDTO;

public interface StoreDAO {
	// 활성화된 매장 가져오기 
    List<StoreDTO> selectActiveStores() throws SQLException;
    
    // 매장 추가.
    int insertStore(StoreDTO dto) throws SQLException;
    
    // 유효성 검사( 매장 추가시 store_code 가 중복되는지 )
    boolean existsStoreCode(String storeCode) throws SQLException;
    
    // 유효성검사 ( 매장 추가시 stoer_no가 중복되는지 ) 
    boolean existsSortNo(int sortNo) throws SQLException;
    
    // 초기에는 active를 0,1 로 바꾸는걸 따로 만들었다가, 토글형식으로 하게 변경 
    //int deactivateStore(int storeId) throws SQLException; 
    
    // 모든 스토어 확인
    List<StoreDTO> selectAllStoresForAdmin() throws SQLException;
        
    // 활성,비활성 토글 할 수 있도록 
    int toggleStoreActive(int storeId) throws SQLException;

}
