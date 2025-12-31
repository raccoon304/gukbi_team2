package cart.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

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
    public boolean isOptionInCart(String memberId, int optionId) {
        boolean exists = false;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = ds.getConnection();
            
            String sql = 
                " SELECT COUNT(*) " +
                " FROM cart " +
                " WHERE fk_member_id = ? " +
                " AND fk_option_id = ? ";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, memberId);
            pstmt.setInt(2, optionId);
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                exists = rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (pstmt != null) pstmt.close(); } catch (SQLException e) {}
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }
        
        return exists;
    }
    
    // 이미 있으면 수량만 추가
    @Override
    public void updateQuantity(String memberId, int optionId, int quantity) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = ds.getConnection();
            
            String sql =
                " update cart " +
                " set quantity = quantity + ? " +
                " where fk_member_id = ? " +
                " and fk_option_id = ? ";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, quantity);
            pstmt.setString(2, memberId);
            pstmt.setInt(3, optionId);
            
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (SQLException e) {}
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }
    }
    
    // 아예 비어있으면 상품 자체를 추가
    @Override
    public void insertCart(String memberId, int optionId, int quantity) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = ds.getConnection();
            
            String sql =
                " insert into cart (cart_id, fk_member_id, fk_option_id, quantity, added_date) " +
                " values (seq_cart.nextval, ?, ?, ?, SYSDATE) ";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, memberId);
            pstmt.setInt(2, optionId);
            pstmt.setInt(3, quantity);
            
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (SQLException e) {}
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }
    }
}