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
    
    // 이미 장바구니에 있는지 확인
    @Override
    public boolean isOptionInCart(String memberId, int optionId) throws SQLException {

        boolean exists = false;

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql =
            " SELECT COUNT(*) " +
            " FROM tbl_cart " +
            " WHERE fk_member_id = ? " +
            " AND fk_option_id = ? ";

        try {
            conn = ds.getConnection();
            pstmt = conn.prepareStatement(sql);

            pstmt.setString(1, memberId);
            pstmt.setInt(2, optionId);

            rs = pstmt.executeQuery();

            if (rs.next()) {
                exists = rs.getInt(1) > 0;
            }

        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) {}
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
            if (conn != null) try { conn.close(); } catch (SQLException e) {}
        }

        return exists;
    }
  
    /*
    // 이미 있으면 수량만 추가
    @Override
    public int updateQuantity(String memberId, int optionId, int quantity) throws SQLException {
       
  
            int n = 0;
            
            String sql =
                " update tbl_cart " +
                " set quantity = quantity + ? " +
                " where fk_member_id = ? " +
                " and fk_option_id = ? ";
            
            try (Connection conn = ds.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(sql)) {

                   pstmt.setInt(1, quantity);
                   pstmt.setString(2, memberId);
                   pstmt.setInt(3, optionId);

                   n = pstmt.executeUpdate();
               }

               return n;
    }
    
    // 아예 비어있으면 상품 자체를 추가
    @Override
    public int insertCart(String memberId, int optionId, int quantity) throws SQLException {
        int n = 0;

        String sql =
            " insert into tbl_cart (cart_id, fk_member_id, fk_option_id, quantity, added_date) " +
            " values (seq_cart.nextval, ?, ?, ?, sysdate) ";

        try (Connection conn = ds.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, memberId);
            pstmt.setInt(2, optionId);
            pstmt.setInt(3, quantity);

            n = pstmt.executeUpdate();
        }

        return n;
    }
*/

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
    public int updateQuantity(int cartId, String memberId, int quantity) throws SQLException {

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
     
    
    /*
	// 선택한 내용을 대상으로 전체 삭제
	@Override
	public int deleteAll(String memberId) throws SQLException {

		int n = 0;
		
	    String sql =
	        " delete from tbl_cart " +
	        " where fk_member_id = ? ";

	    try (Connection conn = ds.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setString(1, memberId);
	        n =  pstmt.executeUpdate();
	    }
		return n;
	}
	*/

	// 장바구니에서 결제페이지로 넘어가는 쿼리 (부분 결제 가능하게 하는 기능)
	@Override
	public Map<String, Object> selectCartById(int cartId, String memberId) throws SQLException {
	    Map<String, Object> map = new HashMap<>();
	    
	    String sql =
	    	    " SELECT " +
	    	    "   c.cart_id, " +
	    	    "   c.quantity, " + 
	    	    "   c.fk_option_id AS option_id, " +
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
	        	    map.put("option_id", rs.getInt("option_id"));
	        	}
	        }
	    }
	    
	    return map.isEmpty() ? null : map;
	}

	/*
	// 전체 결제가 가능하게 하는 기능
	@Override
	public List<CartDTO> selectCartListForPay(String memberId) throws SQLException {
		
		 List<CartDTO> list = new ArrayList<>();

		    String sql =
		        " SELECT "
		        + "    c.cart_id, "
		        + "    c.quantity, "
		        + "    p.product_name, "	       
		        + "    (p.price + o.plus_price) AS unit_price, "
		        + "    p.image_path, "
		        + "    (p.price + o.plus_price) * c.quantity AS total_price "
		        + " From tbl_cart c "
		        + " JOIN tbl_product_option o "
		        + "    ON c.fk_option_id = o.option_id "
		        + " JOIN tbl_product p "
		        + "    ON o.fk_product_code = p.product_code "
		        + " WHERE c.fk_member_id = ? "
		        + " ORDER BY c.added_date DESC ";

		    try (Connection conn = ds.getConnection();
		         PreparedStatement pstmt = conn.prepareStatement(sql)) {

		        pstmt.setString(1, memberId);

		        try (ResultSet rs = pstmt.executeQuery()) {
		            while (rs.next()) {
		                CartDTO dto = new CartDTO();
		                dto.setCartId(rs.getInt("cart_id"));
		                dto.setQuantity(rs.getInt("quantity"));
		                dto.setPrice(rs.getInt("price"));
		                dto.setProductName(rs.getString("product_name"));
		                dto.setImagePath(rs.getString("image_path"));
		                
		                
		                list.add(dto);
		            }
		        }
		    }
		    return list;
	}
*/
	
	// 상품상세에서 구매하기를 눌렀을때 떠야 될것
	@Override
	public Map<String, Object> selectDirectProduct(
	        String productCode, int optionId, int quantity) throws SQLException {

	    Map<String, Object> map = new HashMap<>();

	    String sql =
	        " SELECT "
	      + "   p.product_name, "
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
	                map.put("image_path", rs.getString("image_path"));
	                map.put("unit_price", rs.getInt("unit_price"));
	                map.put("quantity", rs.getInt("quantity"));
	                map.put("total_price", rs.getInt("total_price"));
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
		
	
}