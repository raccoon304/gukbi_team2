package order.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.net.Inet4Address;

import java.util.LinkedHashMap;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import coupon.domain.CouponDTO;
import coupon.domain.CouponIssueDTO;
import order.domain.OrderDTO;



public class OrderDAO_imple implements OrderDAO {

    private DataSource ds;
    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;
    
    
    public OrderDAO_imple() {
        try {
            Context initContext = new InitialContext();
            Context envContext = (Context) initContext.lookup("java:/comp/env");
            ds = (DataSource) envContext.lookup("SemiProject");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /* ================= 오래된 READY 주문 FAIL 처리 (본인 것만) ================= */
   @Override
   public int expireReadyOrders(String memberid) {
       Connection conn = null;
          PreparedStatement pstmt = null;
          int result = 0;

          String sql =
                 " UPDATE tbl_orders " +
                 " SET order_status = 'FAIL', " +
                 "     delivery_status = 4 " +
                 " WHERE order_status = 'READY' " +
                 "   AND fk_member_id = ? " +
                 "   AND order_date < (SYSDATE - INTERVAL '3' second) ";

          try {
              conn = ds.getConnection();
              pstmt = conn.prepareStatement(sql);

              pstmt.setString(1, memberid);

              result = pstmt.executeUpdate();

          } catch (SQLException e) {
              e.printStackTrace();

          } finally {
              try {
                  if (pstmt != null) pstmt.close();
                  if (conn != null) conn.close();
              } catch (SQLException e) {
                  e.printStackTrace();
              }
          }

          return result;
      }
    
    /* 
       1. 주문 생성 (order_id 반환)
       */
    @Override
    public int insertOrder(OrderDTO order) throws SQLException {

        int orderId = 0;

        String seqSql = " SELECT SEQ_TBL_ORDERS_ORDER_ID.nextval FROM dual ";
        String insertSql =
              " INSERT INTO tbl_orders ( " +
                     " order_id, fk_member_id, total_amount, discount_amount, " +
                     " delivery_address, recipient_name, recipient_phone, " +
                     " delivery_status, order_status, order_date ) " +
                     " VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, SYSDATE ) ";

        try (
            Connection conn = ds.getConnection();
            PreparedStatement seqPstmt = conn.prepareStatement(seqSql);
            ResultSet rs = seqPstmt.executeQuery()
        ) {
            if (rs.next()) {
                orderId = rs.getInt(1);
            }

            try (PreparedStatement pstmt = conn.prepareStatement(insertSql)) {
                pstmt.setInt(1, orderId);
                pstmt.setString(2, order.getMemberId());
                pstmt.setInt(3, order.getTotalAmount());
                pstmt.setInt(4, order.getDiscountAmount());
                pstmt.setString(5, order.getDeliveryAddress());
                pstmt.setString(6, order.getRecipientName());
                pstmt.setString(7, order.getRecipientPhone());
                pstmt.setInt(8, 0); 
                pstmt.setString(9, order.getOrderStatus());
                
                pstmt.executeUpdate();
            }
        }

        return orderId;
    }

    /* 
       2. 주문 헤더 조회
        */
    @Override
    public Map<String, Object> selectOrderHeader(int orderId) throws SQLException {

        Map<String, Object> map = new HashMap<>();

        String sql =
            " SELECT order_id, order_date, total_amount, discount_amount, " +
            "        (total_amount - discount_amount) AS final_amount, " +
            "        delivery_address, order_status " +
            " FROM tbl_orders " +
            " WHERE order_id = ? ";

        try (
            Connection conn = ds.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql);
        ) {
            pstmt.setInt(1, orderId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    map.put("order_id", rs.getInt("order_id"));
                    map.put("order_date", rs.getString("order_date"));
                    map.put("total_amount", rs.getInt("total_amount"));
                    map.put("discount_amount", rs.getInt("discount_amount"));
                    map.put("final_amount", rs.getInt("final_amount"));
                    map.put("delivery_address", rs.getString("delivery_address"));
                    map.put("order_status", rs.getString("order_status"));
                }
            }
        }

        return map;
    }
    /* 
       3. 주문 상세 조회
      */
    @Override
    public List<Map<String, Object>> selectOrderDetailForPayment(int orderId) throws SQLException {

        List<Map<String, Object>> list = new ArrayList<>();

        String sql =
            " SELECT product_name, brand_name, quantity, unit_price, " +
            "        (quantity * unit_price) AS total_price " +
            " FROM tbl_order_detail " +
            " WHERE fk_order_id = ? ";

        try (
            Connection conn = ds.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql);
        ) {
            pstmt.setInt(1, orderId);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("product_name", rs.getString("product_name"));
                    map.put("brand_name", rs.getString("brand_name"));
                    map.put("quantity", rs.getInt("quantity"));
                    map.put("unit_price", rs.getInt("unit_price"));
                    map.put("total_price", rs.getInt("total_price"));
                    list.add(map);
                }
            }
        }

        return list;
    }

    /*
     
     */
   
    
    /* 
       4. 결제 완료 이후 기준 쿠폰 사용 처리
        */
    @Override
    public int updateCouponUsed(String memberId, int couponIssueId) throws SQLException {

        String sql =
              " UPDATE tbl_coupon_issue " +
                      " SET used_yn = 1 " +
                      " WHERE ROWID = ( " +
                      "   SELECT ROWID " +
                      "   FROM tbl_coupon_issue " +
                      "   WHERE fk_member_id = ? " +
                      "     AND coupon_id = ? " +
                      "     AND used_yn = 0 " +
                      "     AND expire_date >= SYSDATE " +
                      "   FETCH FIRST 1 ROW ONLY " +
                      " ) ";

        try (
            Connection conn = ds.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql);
        ) {
            pstmt.setString(1, memberId);
            pstmt.setInt(2, couponIssueId);  // 파라미터명 변경
            return pstmt.executeUpdate();
        }
    }

    /* =========================
       5. 재고 차감
       ========================= */
    @Override
    public int decreaseStock(int optionId, int quantity) throws SQLException {

        String sql =
            " UPDATE tbl_product_option " +
            " SET stock_qty = stock_qty - ? " +
            " WHERE option_id = ? " +
            "   AND stock_qty >= ? ";

        try (
            Connection conn = ds.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql);
        ) {
            pstmt.setInt(1, quantity);
            pstmt.setInt(2, optionId);
            pstmt.setInt(3, quantity);
            return pstmt.executeUpdate();
        }
    }

    /* 
       6. 주문 상세 생성
        */
    @Override
    public int insertOrderDetail(
            int orderId,
            int optionId,
            int quantity,
            int unitPrice,
            String productName,
            String brandName
    ) throws SQLException {

        String sql =
            " INSERT INTO tbl_order_detail ( " +
            "   order_detail_id, fk_order_id, fk_option_id, " +
            "   quantity, unit_price, product_name, brand_name " +
            " ) VALUES ( " +
            "   SEQ_TBL_ORDER_DETAIL_ORDER_DETAIL_ID.nextval, ?, ?, ?, ?, ?, ? ) ";

        try (
            Connection conn = ds.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql);
        ) {
            pstmt.setInt(1, orderId);
            pstmt.setInt(2, optionId);
            pstmt.setInt(3, quantity);
            pstmt.setInt(4, unitPrice);
            pstmt.setString(5, productName);
            pstmt.setString(6, brandName);
            return pstmt.executeUpdate();
        }
    }

    /* =========================
       7. 주문 상태 변경
       ========================= */
    @Override
    public void updateOrderStatus(int orderId, String status) throws SQLException {

        String sql =
            " UPDATE tbl_orders " +
            " SET order_status = ? " +
            " WHERE order_id = ? ";

        try (
            Connection conn = ds.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql);
        ) {
            pstmt.setString(1, status);
            pstmt.setInt(2, orderId);
            pstmt.executeUpdate();
        }
    }

    /* 
        8. 결제 완료 이후 쿠폰 정보 조회 (핵심 수정)
        */
    @Override
    public Map<String, Object> selectCouponInfo(String memberId, int couponIssueId) throws SQLException {

        Map<String, Object> result = null;

        String sql =
            " SELECT c.discount_type, c.discount_value " +
            " FROM tbl_coupon_issue ci " +
            " JOIN tbl_coupon c " +
            "   ON ci.fk_coupon_category_no = c.coupon_category_no " +
            " WHERE ci.fk_member_id = ? " +
            "   AND ci.coupon_id = ? " +        //  coupon_id는 발급쿠폰 PK
            "   AND ci.used_yn = 0 " +
            "   AND ci.expire_date >= SYSDATE ";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = ds.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, memberId);
            pstmt.setInt(2, couponIssueId);  // 파라미터명 변경

            rs = pstmt.executeQuery();

            if (rs.next()) {
                result = new HashMap<>();
                result.put("discountType", rs.getInt("discount_type"));
                result.put("discountValue", rs.getInt("discount_value"));
            }

        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }

        return result;
    }

    // 결제 전 기준이지만 결제 도메인에 속해서 OrderDAO에 포함시킴, 
    // 기간만료가 아닌 쿠폰을 "결제페이지"에서 조회하는 곳
    @Override
    public List<Map<String, Object>> selectAvailableCoupons(String memberid) throws SQLException {

        List<Map<String, Object>> list = new ArrayList<>();

        String sql =
            " SELECT " +
            "   ci.coupon_id, ci.used_yn, ci.expire_date, " +
            "   c.coupon_category_no, c.coupon_name, c.discount_type, c.discount_value " +
            " FROM tbl_coupon_issue ci " +
            " JOIN tbl_coupon c " +
            "   ON ci.fk_coupon_category_no = c.coupon_category_no " +
            " WHERE ci.fk_member_id = ? " +
            "   AND ci.used_yn = 0 " +                  // ⭐ 사용 안 한 쿠폰
            "   AND ci.expire_date >= SYSDATE " +       // ⭐ 만료 안 된 쿠폰
            "  AND c.usable = 1 " +
            " ORDER BY ci.expire_date ASC ";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = ds.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, memberid);

            rs = pstmt.executeQuery();

            while (rs.next()) {

                // ===== CouponDTO =====
                CouponDTO coupon = new CouponDTO();
                coupon.setCouponCategoryNo(rs.getInt("coupon_category_no"));
                coupon.setCouponName(rs.getString("coupon_name"));
                coupon.setDiscountType(rs.getInt("discount_type"));
                coupon.setDiscountValue(rs.getInt("discount_value"));

                // ===== CouponIssueDTO =====
                CouponIssueDTO issue = new CouponIssueDTO();
                issue.setCouponId(rs.getInt("coupon_id"));
                issue.setUsedYn(rs.getInt("used_yn"));
                issue.setExpireDate(rs.getString("expire_date"));

                // ===== Map 묶기 =====
                Map<String, Object> map = new HashMap<>();
                map.put("coupon", coupon);
                map.put("issue", issue);

                list.add(map);
            }

        } finally {
            if (rs != null)    rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null)  conn.close();
        }

        return list;
    }

 // 주문의 배송 상태를 코드값(0: 준비, 4: 실패 등)으로 업데이트
    @Override
    public void updateDeliveryStatus(Integer orderId, int status) throws SQLException {

        Connection conn = null;
        PreparedStatement pstmt = null;

        String sql =
            " UPDATE tbl_orders " +
            " SET delivery_status = ? " +
            " WHERE order_id = ? ";

        try {
            conn = ds.getConnection();
            pstmt = conn.prepareStatement(sql);

            pstmt.setInt(1, status);
            pstmt.setInt(2, orderId);

            pstmt.executeUpdate();

        } catch (SQLException e) {
            // 그대로 상위로 던짐 (트랜잭션 제어는 컨트롤러/서비스 책임)
            throw e;
        
        } finally {
            if (pstmt != null) {
                try { pstmt.close(); } catch (SQLException ignore) {}
            }
            if (conn != null) {
                try { conn.close(); } catch (SQLException ignore)  {}
            }
        }
    }

    @Override
    public int updateOrderDiscountAndAddress(int orderId, int discountAmount, String deliveryAddress) 
            throws SQLException {
        int result = 0;
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        String sql = " UPDATE tbl_orders "
                   + " SET discount_amount = ?, "
                   + "     delivery_address = ? "
                   + " WHERE order_id = ? ";
        
        try {
            conn = ds.getConnection();
            pstmt = conn.prepareStatement(sql);
            
            pstmt.setInt(1, discountAmount);
            pstmt.setString(2, deliveryAddress);
            pstmt.setInt(3, orderId);
            
            result = pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
            
        } finally {
            if (pstmt != null) {
                try { pstmt.close(); } catch (SQLException ignore) {}
            }
            if (conn != null) {
                try { conn.close(); } catch (SQLException ignore) {}
            }
        }
        
        return result;
    }

    
   
    
 
	 
	@Override
	public List<OrderDTO> selectOrderSummaryList(String memberid) throws SQLException {
		
		
		
		 List<OrderDTO> list = new ArrayList<>();
		
		
		 
		    try {
		    	
		    	
		        conn = ds.getConnection();

		        String sql =
		              " SELECT ORDER_ID, "
		            + "        FK_MEMBER_ID, "
		            + "        TO_CHAR(ORDER_DATE, 'YY/MM/DD') AS ORDER_DATE, "
		            + "        TOTAL_AMOUNT, DISCOUNT_AMOUNT, ORDER_STATUS, DELIVERY_ADDRESS, RECIPIENT_NAME, RECIPIENT_PHONE, DELIVERY_STATUS"
		            + "  FROM TBL_ORDERS "           
		            + "  WHERE FK_MEMBER_ID = ? "
		            + "  ORDER BY ORDER_DATE DESC, ORDER_ID DESC ";

		        pstmt = conn.prepareStatement(sql);
		        pstmt.setString(1, memberid);

		        rs = pstmt.executeQuery();

		        while (rs.next()) {
		            OrderDTO dto = new OrderDTO();

		            dto.setOrderId(rs.getInt("ORDER_ID"));
		            dto.setMemberId(rs.getString("FK_MEMBER_ID"));
		            dto.setOrderDate(rs.getString("ORDER_DATE"));          // String
		            dto.setTotalAmount(rs.getInt("TOTAL_AMOUNT"));
		            dto.setDiscountAmount(rs.getInt("DISCOUNT_AMOUNT"));
		            dto.setOrderStatus(rs.getString("ORDER_STATUS"));
		            dto.setDeliveryAddress(rs.getString("DELIVERY_ADDRESS"));
		            dto.setRecipientName(rs.getString("RECIPIENT_NAME"));
		            dto.setRecipientPhone(rs.getString("RECIPIENT_PHONE"));
		            dto.setDeliveryStatus(rs.getInt("DELIVERY_STATUS"));
		            
		            
		            list.add(dto);
		        }

		    } finally {
		        if (rs != null) rs.close();
		        if (pstmt != null) pstmt.close();
		        if (conn != null) conn.close();
		    }

		    return list;
		}


	@Override
	public Map<String, Object> selectOrderHeaderForModal(int orderId, String memberId) throws SQLException {

		    Map<String, Object> map = new HashMap<>();

		    String sql =
		        " SELECT order_id, "
		      + "        TO_CHAR(order_date, 'YYYY-MM-DD HH24:MI') AS order_date, "
		      + "        total_amount, discount_amount, "
		      + "        (total_amount - discount_amount) AS final_amount, "
		      + "        delivery_address, order_status "
		      + "   FROM tbl_orders "
		      + "  WHERE order_id = ? "
		      + "    AND fk_member_id = ? ";

		    Connection conn = null;
		    PreparedStatement pstmt = null;
		    ResultSet rs = null;

		    try {
		        conn = ds.getConnection();
		        pstmt = conn.prepareStatement(sql);
		        pstmt.setInt(1, orderId);
		        pstmt.setString(2, memberId);

		        rs = pstmt.executeQuery();

		        if (rs.next()) {
		            map.put("order_id", rs.getInt("order_id"));
		            map.put("order_date", rs.getString("order_date"));
		            map.put("total_amount", rs.getInt("total_amount"));
		            map.put("discount_amount", rs.getInt("discount_amount"));
		            map.put("final_amount", rs.getInt("final_amount"));
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


	@Override
	public List<Map<String, Object>> selectOrderItemsForModal(int orderId) throws SQLException {

		    List<Map<String, Object>> list = new ArrayList<>();

		    String sql =
		        " SELECT od.product_name, od.brand_name, od.quantity, od.unit_price, "
		      + "        (od.quantity * od.unit_price) AS total_price, "
		      + "        NVL(po.color,'') AS color, "
		      + "        NVL(po.storage_size,'') AS storage "
		      + "   FROM tbl_order_detail od "
		      + "   LEFT JOIN tbl_product_option po "
		      + "          ON od.fk_option_id = po.option_id "
		      + "  WHERE od.fk_order_id = ? "
		      + "  ORDER BY od.order_detail_id ASC ";

		    Connection conn = null;
		    PreparedStatement pstmt = null;
		    ResultSet rs = null;

		    try {
		        conn = ds.getConnection();
		        pstmt = conn.prepareStatement(sql);
		        pstmt.setInt(1, orderId);

		        rs = pstmt.executeQuery();

		        while (rs.next()) {
		            Map<String, Object> m = new HashMap<>();
		            m.put("product_name", rs.getString("product_name"));
		            m.put("brand_name", rs.getString("brand_name"));
		            m.put("quantity", rs.getInt("quantity"));
		            m.put("unit_price", rs.getInt("unit_price"));
		            m.put("total_price", rs.getInt("total_price"));
		            m.put("color", rs.getString("color"));
		            m.put("storage", rs.getString("storage"));
		            
		            list.add(m);
		        }

		    } finally {
		        if (rs != null) rs.close();
		        if (pstmt != null) pstmt.close();
		        if (conn != null) conn.close();
		    }

		    return list;
		}
	}
    