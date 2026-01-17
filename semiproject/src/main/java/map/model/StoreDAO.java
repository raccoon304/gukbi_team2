package map.model;

import java.sql.SQLException;
import java.util.List;
import map.domain.StoreDTO;

public interface StoreDAO {
    List<StoreDTO> selectActiveStores() throws SQLException;
}
