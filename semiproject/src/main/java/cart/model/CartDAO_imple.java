package cart.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

public class CartDAO_imple implements CartDAO {
    
    private DataSource ds;
     
    // 생성자: DataSource 초기화
    public CartDAO_imple() {
        try {
            Context initContext = new InitialContext();
            Context envContext = (Context) initContext.lookup("java:/comp/env");
            ds = (DataSource) envContext.lookup("SemiProject");
        } catch (NamingException e) {
            e.printStackTrace();
        }
    }
    
    // 장바구니 페이지 내역 조회
    @Override
    public List<Map<String, Object>> selectCartList(String memberId) throws SQLException {

        List<Map<String, Object>> list = new ArrayList<>();

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql =
              " SELECT "
            + "    c.cart_id, "
            + "    c.quantity, "
            + "    c.fk_option_id, "
            + "    p.product_name, "
            + "    p.brand_name, "
            + "    p.price AS base_price, "
            + "    o.plus_price, "
            + "	   o.color, "	
            + "    (p.price + o.plus_price) AS unit_price, "
            + "    p.image_path, "
            + "    (p.price + o.plus_price) * c.quantity AS total_price "
            + " FROM tbl_cart c "
            + " LEFT JOIN tbl_product_option o "
            + "    ON c.fk_option_id = o.option_id "
            + " LEFT JOIN tbl_product p "
            + "    ON o.fk_product_code = p.product_code "
            + " WHERE c.fk_member_id = ? "
            + " ORDER BY c.added_date DESC ";

        try {
            conn = ds.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, memberId);

            rs = pstmt.executeQuery();

            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("cart_id", rs.getInt("cart_id"));
                map.put("quantity", rs.getInt("quantity"));
                map.put("product_name", rs.getString("product_name"));
                map.put("price", rs.getInt("base_price"));
                map.put("plus_price", rs.getInt("plus_price"));
                map.put("unit_price", rs.getInt("unit_price"));
                map.put("image_path", rs.getString("image_path"));
                map.put("total_price", rs.getInt("total_price"));
                map.put("brand_name", rs.getString("brand_name"));
                map.put("color", rs.getString("color"));
                map.put("option_id", rs.getInt("fk_option_id"));
                
                list.add(map);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) {}
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
            if (conn != null) try { conn.close(); } catch (SQLException e) {}
        }

        return list;
    }

    // 장바구니 내부에서 수량 변경
    @Override
    public int setQuantity(int cartId, String memberId, int quantity) throws SQLException {

        int n = 0;
        Connection conn = null;
        PreparedStatement pstmt = null;

        String sql =
            " update tbl_cart " +
            " set quantity = ? " +
            " where cart_id = ? and fk_member_id = ? ";

        try {
            conn = ds.getConnection();
            pstmt = conn.prepareStatement(sql);

            pstmt.setInt(1, quantity);
            pstmt.setInt(2, cartId);
            pstmt.setString(3, memberId);

            n = pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
            if (conn != null) try { conn.close(); } catch (SQLException e) {}
        }

        return n;
    }
       
 // 장바구니 내에서 선택 삭제
 	@Override
 	public int deleteCart(int cartId, String memberId) throws SQLException {

 	    int deleted = 0;

 	    Connection conn = null;
 	    PreparedStatement pstmt = null;

 	    String sql =
 	        " DELETE FROM tbl_cart " +
 	        " WHERE cart_id = ? " +
 	        "   AND fk_member_id = ? ";

 	    try {
 	        conn = ds.getConnection();
 	        pstmt = conn.prepareStatement(sql);

 	        pstmt.setInt(1, cartId);
 	        pstmt.setString(2, memberId);

 	        deleted = pstmt.executeUpdate();

 	    } catch (SQLException e) {
 	        e.printStackTrace();
 	        throw e;
 	    } finally {
 	        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
 	        if (conn != null) try { conn.close(); } catch (SQLException e) {}
 	    }

 	    return deleted; // 1이면 성공, 0이면 실패
 	}
     
 
	// 장바구니에서 결제페이지로 넘어가는 쿼리 (부분 결제 가능하게 하는 기능)
	@Override
	public Map<String, Object> selectCartById(int cartId, String memberId) throws SQLException {
	    Map<String, Object> map = new HashMap<>();
	    
	    String sql =
	    	    " SELECT " +
	    	    "   c.cart_id, " +
	    	    "   c.quantity, " + 
	    	    "   c.fk_option_id, " +
	    	    "   p.product_name, " +
	    	    "	o.option_id,	" +
	    	    "   o.plus_price,   " +
	    	    "   p.image_path, " +
	    	    "   p.brand_name,  " +
	    	    "   (p.price + o.plus_price) AS unit_price, " +
	    	    "   (p.price + o.plus_price) * c.quantity AS total_price " +
	    	    " FROM tbl_cart c " +
	    	    " JOIN tbl_product_option o ON c.fk_option_id = o.option_id " +
	    	    " JOIN tbl_product p ON o.fk_product_code = p.product_code " +
	    	    " WHERE c.cart_id = ? " +
	    	    " AND c.fk_member_id = ? ";
	    
	    try (Connection conn = ds.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {
	        
	        pstmt.setInt(1, cartId);
	        pstmt.setString(2, memberId);
	        
	        try (ResultSet rs = pstmt.executeQuery()) {
	        	if (rs.next()) {
	        	    map.put("cart_id", rs.getInt("cart_id"));
	        	    map.put("quantity", rs.getInt("quantity"));
	        	    map.put("product_name", rs.getString("product_name"));
	        	    map.put("image_path", rs.getString("image_path"));
	        	    map.put("unit_price", rs.getInt("unit_price"));
	        	    map.put("total_price", rs.getInt("total_price"));
	        	    map.put("brand_name", rs.getString("brand_name"));
	        	    map.put("option_id", rs.getInt("fk_option_id"));
	        	   
	        	}
	        }
	    }
	    
	    return map.isEmpty() ? null : map;
	}

	// 결제 완료가 되었을때 선택한 장바구니 항목에 있는 행을 지우기
	@Override
	public int deleteSuccessCartId(List<Integer> cartIdList) throws SQLException {
		if (cartIdList == null || cartIdList.isEmpty()) {
	        return 0;
	    }

	    int result = 0;

	    // ?, ?, ? 형태 만들기
	    String placeholders = String.join(
	        ",", 
	        cartIdList.stream().map(id -> "?").toArray(String[]::new)
	    );

	    String sql =
	        " DELETE FROM tbl_cart " +
	        " WHERE cart_id IN (" + placeholders + ") ";

	    Connection conn = null;
	    PreparedStatement pstmt = null;

	    try {
	        conn = ds.getConnection();
	        pstmt = conn.prepareStatement(sql);

	        for (int i = 0; i < cartIdList.size(); i++) {
	            pstmt.setInt(i + 1, cartIdList.get(i));
	        }

	        result = pstmt.executeUpdate();

	    } finally {
	        if (pstmt != null) pstmt.close();
	        if (conn != null) conn.close();
	    }

	    return result;
	}
	

	/* ================= 바로구매 → cart 흡수 ================= */
	@Override
	public Map<String, Object> selectCartByOption(String memberId, int optionId) throws SQLException {

		String sql =
		        " SELECT cart_id, quantity " +
		        " FROM tbl_cart " +
		        " WHERE fk_member_id = ? " +
		        "   AND fk_option_id = ? ";

		    try (Connection conn = ds.getConnection();
		         PreparedStatement pstmt = conn.prepareStatement(sql)) {

		        pstmt.setString(1, memberId);
		        pstmt.setInt(2, optionId);

		        try (ResultSet rs = pstmt.executeQuery()) {
		            if (rs.next()) {
		                Map<String, Object> map = new HashMap<>();
		                map.put("cart_id", rs.getInt("cart_id"));
		                map.put("quantity", rs.getInt("quantity"));
		                return map;
		            }
		        }
		    }

		    return null; // 없으면 null
		}

	// cart insert 후 생성된 cart_id 반환
	@Override
	public int insertCartAndReturnId(String memberId, int optionId, int quantity) throws SQLException {

	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    int cartId = 0;

	    String sql =
	        " INSERT INTO tbl_cart (cart_id, fk_member_id, fk_option_id, quantity) " +
	        " VALUES ((SELECT NVL(MAX(cart_id), 0) + 1 FROM tbl_cart), ?, ?, ?) ";

	    String getIdSql =
	        " SELECT MAX(cart_id) FROM tbl_cart WHERE fk_member_id = ? ";

	    try {
	        conn = ds.getConnection();

	        // insert
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, memberId);
	        pstmt.setInt(2, optionId);
	        pstmt.setInt(3, Math.max(quantity, 1));
	        pstmt.executeUpdate();
	        pstmt.close();

	        // 생성된 cart_id 조회
	        pstmt = conn.prepareStatement(getIdSql);
	        pstmt.setString(1, memberId);
	        rs = pstmt.executeQuery();

	        if (rs.next()) {
	            cartId = rs.getInt(1);
	        }

	    } catch (SQLException e) {
	        e.printStackTrace();
	        throw e;

	    } finally {
	        if (rs != null) try { rs.close(); } catch (SQLException e) {}
	        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
	        if (conn != null) try { conn.close(); } catch (SQLException e) {}
	    }

	    if (cartId == 0) {
	        throw new SQLException("cart_id 생성 실패");
	    }

	    return cartId;
	}

	// 바로 구매를 눌렀을때 완전히 똑같은 제품, 용량, 색깔이 아니면 행 자체에 올림
	// 바로구매 전용: 수량 교체
	@Override
	public int upsertCartAndReturnId(String memberId, int optionId, int quantity) throws SQLException {

	    int cartId = 0;
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        conn = ds.getConnection();

	        // 1. 기존 cart 조회
	        String selectSql =
	            " SELECT cart_id FROM tbl_cart " +
	            " WHERE fk_member_id = ? AND fk_option_id = ? ";

	        pstmt = conn.prepareStatement(selectSql);
	        pstmt.setString(1, memberId);
	        pstmt.setInt(2, optionId);
	        rs = pstmt.executeQuery();

	        if (rs.next()) {
	            // === 이미 있으면 수량 교체 ===
	            cartId = rs.getInt("cart_id");
	            rs.close();
	            pstmt.close();

	            String updateSql =
	                " UPDATE tbl_cart " +
	                " SET quantity = ? " +  // ✅ 교체 (누적 아님)
	                " WHERE cart_id = ? ";

	            pstmt = conn.prepareStatement(updateSql);
	            pstmt.setInt(1, quantity);  // oldQty + quantity ❌
	            pstmt.setInt(2, cartId);
	            pstmt.executeUpdate();

	        } else {
	            // === 없으면 INSERT ===
	            rs.close();
	            pstmt.close();

	            String insertSql =
	                " INSERT INTO tbl_cart (cart_id, fk_member_id, fk_option_id, quantity) " +
	                " VALUES ( (SELECT NVL(MAX(cart_id),0)+1 FROM tbl_cart), ?, ?, ? ) ";

	            pstmt = conn.prepareStatement(insertSql);
	            pstmt.setString(1, memberId);
	            pstmt.setInt(2, optionId);
	            pstmt.setInt(3, quantity);
	            pstmt.executeUpdate();
	            pstmt.close();

	            // 방금 넣은 cart_id 조회
	            String idSql =
	                " SELECT cart_id FROM tbl_cart " +
	                " WHERE fk_member_id = ? AND fk_option_id = ? ";

	            pstmt = conn.prepareStatement(idSql);
	            pstmt.setString(1, memberId);
	            pstmt.setInt(2, optionId);
	            rs = pstmt.executeQuery();

	            if (rs.next()) {
	                cartId = rs.getInt("cart_id");
	            }
	        }

	    } catch (SQLException e) {
	        e.printStackTrace();
	        throw e;
	    } finally {
	        if (rs != null) try { rs.close(); } catch (Exception e) {}
	        if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
	        if (conn != null) try { conn.close(); } catch (Exception e) {}
	    }

	    return cartId;
	}
	
	
	@Override
	public Map<String, Object> selectRawCartById(int cartId, String memberid) throws SQLException {

	    Map<String, Object> map = null;

	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    String sql =
	        " SELECT " +
	        "   c.cart_id, " +
	        "   c.quantity, " +
	        "   c.fk_option_id " +
	        " FROM tbl_cart c " +
	        " WHERE c.cart_id = ? " +
	        " AND c.fk_member_id = ? ";

	    try {
	        conn = ds.getConnection();
	        pstmt = conn.prepareStatement(sql);

	        pstmt.setInt(1, cartId);
	        pstmt.setString(2, memberid);

	        rs = pstmt.executeQuery();

	        if (rs.next()) {
	            map = new HashMap<>();
	            map.put("cart_id", rs.getInt("cart_id"));
	            map.put("quantity", rs.getInt("quantity"));
	            map.put("option_id", rs.getInt("fk_option_id"));
	        }

	    } catch (SQLException e) {
	        e.printStackTrace();
	        throw e;

	    } finally {
	        if (rs != null) try { rs.close(); } catch (SQLException e) {}
	        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
	        if (conn != null) try { conn.close(); } catch (SQLException e) {}
	    }

	    return map; // 없으면 null
	}

	@Override
	public Map<String, Object> selectDirectProduct(String productCode, int optionId, int quantity) throws SQLException {

	    Map<String, Object> map = new HashMap<>();

	    String sql =
	        " SELECT "
	      + "   p.product_name, "
	      + "   p.brand_name, "
	      + "   p.image_path, "
	      + "   (p.price + o.plus_price) AS unit_price, "
	      + "   ? AS quantity, "
	      + "   (p.price + o.plus_price) * ? AS total_price "
	      + " FROM tbl_product p "
	      + " JOIN tbl_product_option o "
	      + "   ON p.product_code = o.fk_product_code "
	      + " WHERE p.product_code = ? "
	      + " AND o.option_id = ? ";

	    try (Connection conn = ds.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setInt(1, quantity);
	        pstmt.setInt(2, quantity);
	        pstmt.setString(3, productCode);
	        pstmt.setInt(4, optionId);

	        try (ResultSet rs = pstmt.executeQuery()) {
	            if (rs.next()) {
	                map.put("product_name", rs.getString("product_name"));
	                map.put("brand_name", rs.getString("brand_name"));
	                map.put("image_path", rs.getString("image_path"));
	                map.put("unit_price", rs.getInt("unit_price"));
	                map.put("quantity", rs.getInt("quantity"));
	                map.put("total_price", rs.getInt("total_price"));
	                
	                System.out.println(" selectDirectProduct 성공:");
	                System.out.println("  - product_name: " + rs.getString("product_name"));
	                System.out.println("  - unit_price: " + rs.getInt("unit_price"));
	                System.out.println("  - quantity: " + quantity);
	                System.out.println("  - total_price: " + rs.getInt("total_price"));
	            } else {
	                System.out.println("❌ selectDirectProduct 조회 결과 없음");
	                System.out.println("  - productCode: " + productCode);
	                System.out.println("  - optionId: " + optionId);
	            }
	        }
	    } catch (SQLException e) {
	        System.err.println("selectDirectProduct SQL 오류: " + e.getMessage());
	        e.printStackTrace();
	        throw e;
	    }

	    return map.isEmpty() ? null : map;
	}

	
}