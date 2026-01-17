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

    // 매장 추가하기 
    @Override
    public int insertStore(StoreDTO dto) throws SQLException {

        int n = 0;

        try {
            conn = ds.getConnection();

            // store_id는 시퀀스로 넣는다고 가정 (네 시퀀스명에 맞게 수정)
            // 예: SEQ_TBL_STORE_STORE_ID.nextval
            String sql =
                  " INSERT INTO tbl_store ( "
                + "   store_id, store_code, store_name, address, lat, lng, "
                + "   description, kakao_url, phone, is_active, business_hours, sort_no "
                + " ) VALUES ( "
                + "   SEQ_TBL_STORE_ID.nextval, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? "
                + " ) ";

            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, dto.getStoreCode());
            pstmt.setString(2, dto.getStoreName());
            pstmt.setString(3, dto.getAddress());
            pstmt.setDouble(4, dto.getLat());
            pstmt.setDouble(5, dto.getLng());
            pstmt.setString(6, dto.getDescription());
            pstmt.setString(7, dto.getKakaoUrl());
            pstmt.setString(8, dto.getPhone());
            pstmt.setInt(9, dto.getIsActive());
            pstmt.setString(10, dto.getBusinessHours());
            pstmt.setInt(11, dto.getSortNo());

            n = pstmt.executeUpdate();

        } finally {
            close();
        }

        return n;
    }

    // 유효성 검사( 매장 추가시 store_code 가 중복되는지 )
    @Override
    public boolean existsStoreCode(String storeCode) throws SQLException {

        boolean exists = false;

        try {
            conn = ds.getConnection();

            String sql = " select 1 from tbl_store where store_code = ? ";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, storeCode);

            rs = pstmt.executeQuery();
            exists = rs.next();

        } finally {
            close();
        }

        return exists;
    }

    // 유효성검사 ( 매장 추가시 stoer_no가 중복되는지 ) 
    @Override
    public boolean existsSortNo(int sortNo) throws SQLException {

        boolean exists = false;

        try {
            conn = ds.getConnection();

            String sql = " select 1 from tbl_store where sort_no = ? ";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, sortNo);

            rs = pstmt.executeQuery();
            exists = rs.next();

        } finally {
            close();
        }

        return exists;
    }
    
    // 모든 스토어 확인
    @Override
    public List<StoreDTO> selectAllStoresForAdmin() throws SQLException {

        List<StoreDTO> list = new ArrayList<>();

        try {
            conn = ds.getConnection();

            String sql =
                  " SELECT store_id, store_code, store_name, address, lat, lng, "
                + "        NVL(description,'') AS description, "
                + "        NVL(kakao_url,'') AS kakao_url, "
                + "        NVL(phone,'') AS phone, "
                + "        NVL(is_active,1) AS is_active, "
                + "        NVL(business_hours,'') AS business_hours, "
                + "        NVL(sort_no,999) AS sort_no "
                + "   FROM tbl_store "
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
	/*
	 * @Override public int deactivateStore(int storeId) throws SQLException {
	 * 
	 * int n = 0;
	 * 
	 * try { conn = ds.getConnection();
	 * 
	 * String sql = " UPDATE tbl_store " + "    SET is_active = 0 " +
	 * "  WHERE store_id = ? ";
	 * 
	 * pstmt = conn.prepareStatement(sql); pstmt.setInt(1, storeId);
	 * 
	 * n = pstmt.executeUpdate();
	 * 
	 * } finally { close(); }
	 * 
	 * return n; }
	 */

    // 활성,비활성 토글 할 수 있도록 
    @Override
    public int toggleStoreActive(int storeId) throws SQLException {

        int n = 0;

        try {
            conn = ds.getConnection();

            // ✅ 현재 값이 1이면 0으로, 0이면 1로
            String sql =
                  " UPDATE tbl_store "
                + "    SET is_active = CASE WHEN NVL(is_active,1) = 1 THEN 0 ELSE 1 END "
                + "  WHERE store_id = ? ";

            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, storeId);

            n = pstmt.executeUpdate();

        } finally {
            close();
        }

        return n;
    }


}
