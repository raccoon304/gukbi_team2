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

	      String seqSql = "SELECT SEQ_TBL_ORDERS_ORDER_ID.nextval FROM dual";
	      String insertSql =
	          " INSERT INTO tbl_orders "
	        + " (order_id, fk_member_id, total_amount, discount_amount, delivery_address, order_status, order_date) "
	        + " VALUES (?, ?, ?, ?, ?, ?, sysdate) ";

	      Connection conn = null;
	      PreparedStatement pstmt = null;
	      PreparedStatement seqPstmt = null;
	      ResultSet rs = null;

	      try {
	          conn = ds.getConnection();

	          // 1️⃣ 시퀀스 먼저 받기
	          seqPstmt = conn.prepareStatement(seqSql);
	          rs = seqPstmt.executeQuery();
	          if (rs.next()) {
	              orderId = rs.getInt(1);
	          }

	          // 2️⃣ 받은 orderId로 insert
	          pstmt = conn.prepareStatement(insertSql);
	          pstmt.setInt(1, orderId);
	          pstmt.setString(2, order.getMemberId());
	          pstmt.setInt(3, order.getTotalAmount());
	          pstmt.setInt(4, order.getDiscountAmount());
	          pstmt.setString(5, order.getDeliveryAddress());
	          pstmt.setString(6, order.getOrderStatus());

	          pstmt.executeUpdate();

	      } finally {
	          if (rs != null) rs.close();
	          if (seqPstmt != null) seqPstmt.close();
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
			    + " ( "
			    + "  order_detail_id, "
			    + "  fk_order_id, "
			    + "  fk_option_id, "
			    + "  quantity, "
			    + "  unit_price, "
			    + "  is_review_written, "
			    + "  product_name, "
			    + "  brand_name "
			    + " ) "
			    + " VALUES "
			    + " ( "
			    + "  SEQ_TBL_ORDER_DETAIL_ORDER_DETAIL_ID.nextval, "
			    + "  ?, ?, ?, ?, 0, ?, ? "
			    + " ) ";

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
	          + " (total_amount - discount_amount) AS final_amount, "
	          + "        delivery_address, order_status "
	          + " FROM tbl_orders "
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
	                map.put("final_amount", rs.getInt("final_amount"));
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
		        " SELECT product_name, brand_name, quantity, unit_price, " +
		        " (quantity * unit_price) AS total_price  " +
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
		            map.put("total_price", rs.getInt("total_price"));
		            list.add(map);
		        }

		    } finally {
		        if (rs != null) rs.close();
		        if (pstmt != null) pstmt.close();
		        if (conn != null) conn.close();
		    }

		    return list;
		}
	
		
		// 결제 완료가 되었을때 사용한 해당 쿠폰은 더 이상 사용하지 못하게 하기
		@Override
		public int updateCouponUsed(String memberId, int couponId) throws SQLException {

		    int result = 0;

		    String sql =
		        " update tbl_coupon_issue " +
		        " set used_yn = 1 " +
		        " where fk_member_id = ? " +
		        "   and coupon_id = ? " +
		        "   and used_yn = 0 ";

		    Connection conn = null;
		    PreparedStatement pstmt = null;

		    try {
		        conn = ds.getConnection();
		        pstmt = conn.prepareStatement(sql);
		        pstmt.setString(1, memberId);
		        pstmt.setInt(2, couponId);

		        result = pstmt.executeUpdate(); // 1이면 성공

		    } finally {
		        if (pstmt != null) pstmt.close();
		        if (conn != null) conn.close();
		    }

		    return result;
		}
	
}