package order.model;

import java.util.List;
import java.util.Map;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import cart.domain.CartDTO;
import order.domain.OrderDTO;

//JDBC
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

//컬렉션 구현체
import java.util.ArrayList;
import java.util.HashMap;

public class OrderDAO_imple implements OrderDAO {

	
	  private DataSource ds;

	  public OrderDAO_imple() {
		    try {
		        Context initContext = new InitialContext();
		        Context envContext = (Context) initContext.lookup("java:/comp/env");
		        ds = (DataSource) envContext.lookup("SemiProject");
		    } catch (Exception e) {
		        e.printStackTrace();
		    }
		}
	    
	// 주문 생성 → orderId 받기  
	@Override
	public int insertOrder(OrderDTO order) throws SQLException {
		int orderId = 0;

        String sql =
            " Insert into tbl_order "
          + " (order_id, fk_member_id, total_amount, discount_amount, delivery_address, order_status, order_date) "
          + " Values (seq_order.nextval, ?, ?, ?, ?, ?, sysdate) ";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = ds.getConnection();
            pstmt = conn.prepareStatement(sql, new String[] { "order_id" });

            pstmt.setString(1, order.getMemberId());
            pstmt.setInt(2, order.getTotalAmount());
            pstmt.setInt(3, order.getDiscountAmount());
            pstmt.setString(4, order.getDeliveryAddress());
            pstmt.setString(5, order.getOrderStatus());

            pstmt.executeUpdate();

            rs = pstmt.getGeneratedKeys();
            if (rs.next()) {
                orderId = rs.getInt(1);
            }

        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }

        return orderId;
    }

	// 주문 상세 생성 (장바구니 기준)
	@Override
	public int insertOrderDetail(int orderId, CartDTO cart) throws SQLException {
		int result = 0;

		String sql =
			    " INSERT INTO tbl_order_detail "
			  + " (order_detail_id, fk_order_id, fk_option_id, quantity, unit_price, is_review_written, product_name, brand_name) "
			  + " VALUES (seq_order_detail.nextval, ?, ?, ?, ?, 0, ?, ?) ";

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = ds.getConnection();
            pstmt = conn.prepareStatement(sql);

            pstmt.setInt(1, orderId);
            pstmt.setInt(2, cart.getOptionId());
            pstmt.setInt(3, cart.getQuantity());
            pstmt.setInt(4, cart.getPrice());          // 주문 시점 단가
            pstmt.setString(5, cart.getProductName()); // 스냅샷
            pstmt.setString(6, cart.getBrand_name());  // 스냅샷

            result = pstmt.executeUpdate();

        } finally {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }

        return result;
    }

	// 주문 1건의 요약 정보(주문번호, 금액, 배송지, 상태 등)를 조회
	@Override
	public Map<String, Object> selectOrderHeader(int orderId) throws SQLException {
		
		 Map<String, Object> map = new HashMap<>();

	        String sql =
	            " SELECT order_id, order_date, total_amount, discount_amount, "
	          + "        delivery_address, order_status "
	          + " FROM tbl_order "
	          + " WHERE order_id = ? ";

	        Connection conn = null;
	        PreparedStatement pstmt = null;
	        ResultSet rs = null;

	        try {
	            conn = ds.getConnection();
	            pstmt = conn.prepareStatement(sql);
	            pstmt.setInt(1, orderId);

	            rs = pstmt.executeQuery();

	            if (rs.next()) {
	                map.put("order_id", rs.getInt("order_id"));
	                map.put("order_date", rs.getString("order_date"));
	                map.put("total_amount", rs.getInt("total_amount"));
	                map.put("discount_amount", rs.getInt("discount_amount"));
	                map.put("delivery_address", rs.getString("delivery_address"));
	                map.put("order_status", rs.getString("order_status"));
	            }

	        } finally {
	            if (rs != null) rs.close();
	            if (pstmt != null) pstmt.close();
	            if (conn != null) conn.close();
	        }

	        return map;
	    }

	// 해당 주문에 포함된 상품 목록(상품/옵션/수량/주문시점 가격)을 조회
	@Override
	public List<Map<String, Object>> selectOrderDetailForPayment(int orderId) throws SQLException {
		
		 List<Map<String, Object>> list = new ArrayList<>();

		    String sql =
		        " SELECT product_name, brand_name, quantity, unit_price " +
		        " FROM tbl_order_detail " +
		        " WHERE fk_order_id = ? ";

		    Connection conn = null;
		    PreparedStatement pstmt = null;
		    ResultSet rs = null;

		    try {
		        conn = ds.getConnection();
		        pstmt = conn.prepareStatement(sql);
		        pstmt.setInt(1, orderId);

		        rs = pstmt.executeQuery();

		        while (rs.next()) {
		            Map<String, Object> map = new HashMap<>();
		            map.put("product_name", rs.getString("product_name"));
		            map.put("brand_name", rs.getString("brand_name"));
		            map.put("quantity", rs.getInt("quantity"));
		            map.put("unit_price", rs.getInt("unit_price"));
		            list.add(map);
		        }

		    } finally {
		        if (rs != null) rs.close();
		        if (pstmt != null) pstmt.close();
		        if (conn != null) conn.close();
		    }

		    return list;
		}
}