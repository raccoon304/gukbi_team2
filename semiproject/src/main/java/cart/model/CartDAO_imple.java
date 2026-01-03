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
     
        
            String sql = 
                " SELECT COUNT(*) " +
                " from tbl_cart " +
                " where fk_member_id = ? " +
                " AND fk_option_id = ? ";
            
            try (
            Connection conn = ds.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql)) {
            		
            pstmt.setString(1, memberId);
            pstmt.setInt(2, optionId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                rs.next();
                return rs.getInt(1) > 0;
            }
        }
    }
    
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


    @Override
    public List<Map<String, Object>> selectCartList(String memberId) throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();

        // (product, product_option 등
        String sql =
            " select c.cart_id, "
            + "       c.quantity, "
            + "       p.product_name, "
            + "       o.price, "
            + "       p.image_path, "
            + "       (o.price * c.quantity) as total_price "
            + " from tbl_cart c "
            + " join tbl_product_option o "
            + "  on c.fk_option_id = o.option_id "
            + " join tbl_product p "
            + "  on o.fk_product_code = p.product_code "
            + " where c.fk_member_id = ? "
            + " order by c.added_date desc ";

        try (Connection conn = ds.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, memberId);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("cart_id", rs.getInt("cart_id"));
                    map.put("quantity", rs.getInt("quantity"));
                    map.put("product_name", rs.getString("product_name"));
                    map.put("price", rs.getInt("price"));
                    map.put("image_path", rs.getString("image_path"));
                    map.put("total_price", rs.getInt("total_price"));
                    list.add(map);
                }
            }
        }

        return list;
    }

    
    @Override
    public int updateQuantity(int cartId, String memberId, int quantity) throws SQLException {
    	int n = 0;
    	
        String sql =
            " update tbl_cart " +
            " set quantity = ? " +
            " where cart_id = ? and fk_member_id = ? ";

        try (Connection conn = ds.getConnection();
		         PreparedStatement pstmt = conn.prepareStatement(sql)) {
        	
        pstmt.setInt(1, quantity);
        pstmt.setInt(2, cartId);
        pstmt.setString(3, memberId);
        
        n =  pstmt.executeUpdate();
        
        }
        
        return n; // 👉 1이면 성공, 0이면 실패
    }
   
	// 행에 해당되는 칸 대상으로만 선택 삭제
	@Override
	public int deleteCart(int cartId, String memberId) throws SQLException {
		int n = 0;
		
	    String sql =
	        " delete from tbl_cart " +
	        " where cart_id = ? " +
	        " and fk_member_id = ? ";

	    try (Connection conn = ds.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setInt(1, cartId);
	        pstmt.setString(2, memberId);

	        n = pstmt.executeUpdate();
	    }
		return n;
	}

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

	@Override
	public Map<String, Object> selectCartById(int cartId, String memberId) throws SQLException {

	    Map<String, Object> map = null;

	    String sql =
	        " select c.cart_id, c.quantity, (o.price * c.quantity) as total_price " +
	        " from tbl_cart c " +
	        " join tbl_product_option o on c.fk_option_id = o.option_id " +
	        " where c.cart_id = ? and c.fk_member_id = ? ";

	    try (Connection conn = ds.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setInt(1, cartId);
	        pstmt.setString(2, memberId);

	        try (ResultSet rs = pstmt.executeQuery()) {
	            if (rs.next()) {
	                map = new HashMap<>();
	                map.put("cart_id", rs.getInt("cart_id"));
	                map.put("quantity", rs.getInt("quantity"));
	                map.put("total_price", rs.getInt("total_price"));
	            }
	        }
	    }

	    return map;
	}

	
}