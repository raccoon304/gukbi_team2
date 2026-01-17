package map.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import map.domain.StoreDTO;

public class StoreDAO_imple implements StoreDAO {

    private DataSource ds;
    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;

    public StoreDAO_imple() {
        try {
            Context initContext = new InitialContext();
            Context envContext = (Context) initContext.lookup("java:/comp/env");
            ds = (DataSource) envContext.lookup("SemiProject");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // === 자원 반납 ===
    private void close() {
        try {
            if (rs != null)    { rs.close(); rs = null; }
            if (pstmt != null) { pstmt.close(); pstmt = null; }
            if (conn != null)  { conn.close(); conn = null; }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // === 사용중 매장 목록 조회 (좌측 탭/지도/우측패널용) ===
    @Override
    public List<StoreDTO> selectActiveStores() throws SQLException {

        List<StoreDTO> list = new ArrayList<>();

        try {
            conn = ds.getConnection();

            String sql =
                  " SELECT store_id, store_code, store_name, address, lat, lng, "
                + "        NVL(description,'') AS description, "
                + "        NVL(kakao_url,'') AS kakao_url, "
                + "        NVL(phone,'') AS phone, "
                + "        is_active, "
                + "        NVL(business_hours,'') AS business_hours, "
                + "        sort_no "
                + "   FROM tbl_store "
                + "  WHERE is_active = 1 "
                + "  ORDER BY sort_no ASC, store_id ASC ";

            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                StoreDTO dto = new StoreDTO();

                dto.setStoreId(rs.getInt("store_id"));
                dto.setStoreCode(rs.getString("store_code"));
                dto.setStoreName(rs.getString("store_name"));
                dto.setAddress(rs.getString("address"));
                dto.setLat(rs.getDouble("lat"));
                dto.setLng(rs.getDouble("lng"));
                dto.setDescription(rs.getString("description"));
                dto.setKakaoUrl(rs.getString("kakao_url"));
                dto.setPhone(rs.getString("phone"));
                dto.setIsActive(rs.getInt("is_active"));
                dto.setBusinessHours(rs.getString("business_hours"));
                dto.setSortNo(rs.getInt("sort_no"));

                list.add(dto);
            }

        } finally {
            close();
        }

        return list;
    }
}
