package order.model;

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

    /* ================= 오래된 READY 주문 FAIL 처리 ================= */
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
            "   AND order_date < (SYSDATE - INTERVAL '10' MINUTE) ";

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
    
    /* ================= 1. 주문 생성 (기존 - 호환성 유지) ================= */
    @Override
    public int insertOrder(OrderDTO order) throws SQLException {

        int orderId = 0;

        String seqSql = " SELECT SEQ_TBL_ORDERS_ORDER_ID.nextval FROM dual ";
        String insertSql =
            " INSERT INTO tbl_orders ( " +
            "   order_id, fk_member_id, total_amount, discount_amount, " +
            "   delivery_address, recipient_name, recipient_phone, " +
            "   delivery_status, order_status, order_date ) " +
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

    /* ================= 1-1. 트랜잭션으로 주문 + 주문 상세 생성 (신규 추가) ================= */
    @Override
    public int insertOrderWithDetails(
        OrderDTO order,
        List<Map<String, Object>> orderDetails
    ) throws SQLException {
        
        Connection conn = null;
        int orderId = 0;
        
        try {
            conn = ds.getConnection();
            conn.setAutoCommit(false);  // 트랜잭션 시작
            
            System.out.println("=== 트랜잭션 시작: 주문 생성 ===");
            
            // 1. 시퀀스로 주문 ID 생성
            String seqSql = " SELECT SEQ_TBL_ORDERS_ORDER_ID.nextval FROM dual ";
            String insertOrderSql =
                " INSERT INTO tbl_orders ( " +
                "   order_id, fk_member_id, total_amount, discount_amount, " +
                "   delivery_address, recipient_name, recipient_phone, " +
                "   delivery_status, order_status, order_date ) " +
                " VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, SYSDATE ) ";
            
            try (PreparedStatement seqPstmt = conn.prepareStatement(seqSql);
                 ResultSet rs = seqPstmt.executeQuery()) {
                
                if (rs.next()) {
                    orderId = rs.getInt(1);
                }
            }
            
            if (orderId == 0) {
                throw new SQLException("주문 ID 생성 실패");
            }
            
            System.out.println("생성된 주문 ID: " + orderId);
            
            // 2. 주문 헤더 생성
            try (PreparedStatement pstmt = conn.prepareStatement(insertOrderSql)) {
                pstmt.setInt(1, orderId);
                pstmt.setString(2, order.getMemberId());
                pstmt.setInt(3, order.getTotalAmount());
                pstmt.setInt(4, order.getDiscountAmount());
                pstmt.setString(5, order.getDeliveryAddress());
                pstmt.setString(6, order.getRecipientName());
                pstmt.setString(7, order.getRecipientPhone());
                pstmt.setInt(8, 0);
                pstmt.setString(9, order.getOrderStatus());
                
                int orderResult = pstmt.executeUpdate();
                if (orderResult == 0) {
                    throw new SQLException("주문 생성 실패");
                }
            }
            
            System.out.println("주문 헤더 생성 완료");
            
            // 3. 주문 상세 생성
            String insertDetailSql =
                " INSERT INTO tbl_order_detail ( " +
                "   order_detail_id, fk_order_id, fk_option_id, " +
                "   quantity, unit_price, product_name, brand_name " +
                " ) VALUES ( " +
                "   SEQ_TBL_ORDER_DETAIL_ORDER_DETAIL_ID.nextval, ?, ?, ?, ?, ?, ? ) ";
            
            int detailCount = 0;
            
            try (PreparedStatement pstmt = conn.prepareStatement(insertDetailSql)) {
                for (Map<String, Object> detail : orderDetails) {
                    pstmt.setInt(1, orderId);
                    int optionId = getInt(detail, "option_id");
                    if (optionId <= 0) {
                        throw new SQLException("유효하지 않은 option_id");
                    }
                    pstmt.setInt(2, optionId);
                    
                    pstmt.setInt(3, getInt(detail, "quantity"));
                    pstmt.setInt(4, getInt(detail, "unit_price"));
                    pstmt.setString(5, String.valueOf(detail.get("product_name")));
                    pstmt.setString(6, String.valueOf(detail.get("brand_name")));
                    
                    int result = pstmt.executeUpdate();
                    if (result > 0) {
                        detailCount++;
                        System.out.println("  - 주문 상세 추가: " + detail.get("product_name"));
                    } else {
                        throw new SQLException("주문 상세 생성 실패: " + detail.get("product_name"));
                    }
                }
            }
            
            System.out.println("주문 상세 생성 완료: " + detailCount + "개");
            
            // 4. 재고 차감
            String decreaseStockSql =
                " UPDATE tbl_product_option " +
                " SET stock_qty = stock_qty - ? " +
                " WHERE option_id = ? " +
                "   AND stock_qty >= ? ";
            
            int stockUpdateCount = 0;
            
            try (PreparedStatement pstmt = conn.prepareStatement(decreaseStockSql)) {
                for (Map<String, Object> detail : orderDetails) {
                    int optionId = getInt(detail, "option_id");
                    int quantity = getInt(detail, "quantity");
                    
                    pstmt.setInt(1, quantity);
                    pstmt.setInt(2, optionId);
                    pstmt.setInt(3, quantity);
                    
                    int result = pstmt.executeUpdate();
                    if (result > 0) {
                        stockUpdateCount++;
                        System.out.println("  - 재고 차감: 옵션ID=" + optionId + ", 수량=" + quantity);
                    } else {
                        throw new SQLException("재고 부족: 옵션ID=" + optionId);
                    }
                }
            }
            
            System.out.println("재고 차감 완료: " + stockUpdateCount + "개");
            
            // 5. 검증
            if (detailCount != orderDetails.size()) {
                throw new SQLException("주문 상세 개수 불일치: 예상=" + orderDetails.size() + ", 실제=" + detailCount);
            }
            
            if (stockUpdateCount != orderDetails.size()) {
                throw new SQLException("재고 차감 개수 불일치: 예상=" + orderDetails.size() + ", 실제=" + stockUpdateCount);
            }
            
            // ✅ 모두 성공 - 커밋
            conn.commit();
            System.out.println("=== 트랜잭션 커밋 완료 ===");
            
        } catch (SQLException e) {
            System.out.println("❌ 트랜잭션 롤백 실행!");
            e.printStackTrace();
            
            if (conn != null) {
                try {
                    conn.rollback();
                    System.out.println("롤백 완료");
                } catch (SQLException ex) {
                    System.out.println("롤백 실패: " + ex.getMessage());
                    ex.printStackTrace();
                }
            }
            throw e;
            
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        
        return orderId;
    }

    /* ================= 2. 주문 헤더 조회 ================= */
    @Override
    public Map<String, Object> selectOrderHeader(int orderId) throws SQLException {

        Map<String, Object> map = new HashMap<>();

        String sql =
            " SELECT order_id, order_date, total_amount, discount_amount, " +
            "        (total_amount - discount_amount) AS final_amount, " +
            "        delivery_address, order_status, recipient_name, recipient_phone " +
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
                    map.put("recipient_name", rs.getString("recipient_name"));
                    map.put("recipient_phone", rs.getString("recipient_phone"));
                }
            }
        }

        return map;
    }

    /* ================= 3. 주문 상세 조회 (재고 복구용 option_id 포함) ================= */
    @Override
    public List<Map<String, Object>> selectOrderDetailForPayment(int orderId) throws SQLException {

        List<Map<String, Object>> list = new ArrayList<>();

        String sql =
            " SELECT fk_option_id, product_name, brand_name, quantity, unit_price, " +  // ✅ fk_option_id 추가
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
                    map.put("option_id", rs.getInt("fk_option_id"));  // ✅ 추가
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

    /* ================= 4. 쿠폰 사용 처리 ================= */
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
            pstmt.setInt(2, couponIssueId);
            return pstmt.executeUpdate();
        }
    }

    /* ================= 5. 재고 차감 ================= */
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

    /* ================= 6. 주문 상세 생성 ================= */
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

    /* ================= 7. 주문 상태 변경 ================= */
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

    /* ================= 8. 쿠폰 정보 조회 ================= */
    @Override
    public Map<String, Object> selectCouponInfo(String memberId, int couponIssueId) throws SQLException {

        Map<String, Object> result = null;

        String sql =
            " SELECT c.discount_type, c.discount_value " +
            " FROM tbl_coupon_issue ci " +
            " JOIN tbl_coupon c " +
            "   ON ci.fk_coupon_category_no = c.coupon_category_no " +
            " WHERE ci.fk_member_id = ? " +
            "   AND ci.coupon_id = ? " +
            "   AND ci.used_yn = 0 " +
            "   AND ci.expire_date >= SYSDATE ";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = ds.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, memberId);
            pstmt.setInt(2, couponIssueId);

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

    /* ================= 9. 사용 가능한 쿠폰 조회 ================= */
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
            "   AND ci.used_yn = 0 " +
            "   AND ci.expire_date >= SYSDATE " +
            "   AND c.usable = 1 " +
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
                CouponDTO coupon = new CouponDTO();
                coupon.setCouponCategoryNo(rs.getInt("coupon_category_no"));
                coupon.setCouponName(rs.getString("coupon_name"));
                coupon.setDiscountType(rs.getInt("discount_type"));
                coupon.setDiscountValue(rs.getInt("discount_value"));

                CouponIssueDTO issue = new CouponIssueDTO();
                issue.setCouponId(rs.getInt("coupon_id"));
                issue.setUsedYn(rs.getInt("used_yn"));
                issue.setExpireDate(rs.getString("expire_date"));

                Map<String, Object> map = new HashMap<>();
                map.put("coupon", coupon);
                map.put("issue", issue);

                list.add(map);
            }

        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }

        return list;
    }

    /* ================= 10. 배송 상태 업데이트 ================= */
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
            throw e;
        
        } finally {
            if (pstmt != null) {
                try { pstmt.close(); } catch (SQLException ignore) {}
            }
            if (conn != null) {
                try { conn.close(); } catch (SQLException ignore) {}
            }
        }
    }

    /* ================= 11. 할인 금액 및 배송지 업데이트 ================= */
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

    /* ================= 12. 주문 요약 목록 조회 ================= */
    @Override
    public List<OrderDTO> selectOrderSummaryList(String memberid) throws SQLException {

        List<OrderDTO> list = new ArrayList<>();

        try {
            conn = ds.getConnection();

            String sql =
                " SELECT ORDER_ID, " +
                "        FK_MEMBER_ID, " +
                "        TO_CHAR(ORDER_DATE, 'YY/MM/DD') AS ORDER_DATE, " +
                "        TOTAL_AMOUNT, DISCOUNT_AMOUNT, ORDER_STATUS, " +
                "        DELIVERY_ADDRESS, RECIPIENT_NAME, RECIPIENT_PHONE, DELIVERY_STATUS " +
                " FROM TBL_ORDERS " +
                " WHERE FK_MEMBER_ID = ? " +
                " ORDER BY ORDER_DATE DESC, ORDER_ID DESC ";

            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, memberid);

            rs = pstmt.executeQuery();

            while (rs.next()) {
                OrderDTO dto = new OrderDTO();

                dto.setOrderId(rs.getInt("ORDER_ID"));
                dto.setMemberId(rs.getString("FK_MEMBER_ID"));
                dto.setOrderDate(rs.getString("ORDER_DATE"));
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

    /* ================= 13. 모달용 주문 헤더 조회 ================= */
    @Override
    public Map<String, Object> selectOrderHeaderForModal(int orderId, String memberId) throws SQLException {

        Map<String, Object> map = new HashMap<>();

        String sql =
            " SELECT order_id, " +
            "        TO_CHAR(order_date, 'YYYY-MM-DD HH24:MI') AS order_date, " +
            "        total_amount, discount_amount, " +
            "        (total_amount - discount_amount) AS final_amount, " +
            "        delivery_address, order_status " +
            " FROM tbl_orders " +
            " WHERE order_id = ? " +
            "   AND fk_member_id = ? ";

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

    /* ================= 14. 모달용 주문 아이템 조회 ================= */
    @Override
    public List<Map<String, Object>> selectOrderItemsForModal(int orderId) throws SQLException {

        List<Map<String, Object>> list = new ArrayList<>();

        String sql =
            " SELECT od.product_name, od.brand_name, od.quantity, od.unit_price, " +
            "        po.fk_product_code, od.is_review_written, " +
            "        (od.quantity * od.unit_price) AS total_price, " +
            "        NVL(po.color,'') AS color, " +
            "        NVL(po.storage_size,'') AS storage " +
            " FROM tbl_order_detail od " +
            " LEFT JOIN tbl_product_option po " +
            "   ON od.fk_option_id = po.option_id " +
            " WHERE od.fk_order_id = ? " +
            " ORDER BY od.order_detail_id ASC ";

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
                m.put("fkProductCode", rs.getString("fk_product_code"));
                m.put("is_review_written", rs.getInt("is_review_written"));
                list.add(m);
            }

        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }

        return list;
    }

    /* ================= 15. READY 상태인 주문만 FAIL로 업데이트 ================= */
    @Override
    public int updateOrderStatusIfReady(Integer orderId, String status) throws SQLException {
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        int result = 0;

        try {
            conn = ds.getConnection();

            String sql =
                " UPDATE tbl_orders " +
                " SET order_status = ? " +
                " WHERE order_id = ? " +
                "   AND order_status = 'READY' ";

            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, status);
            pstmt.setInt(2, orderId);

            result = pstmt.executeUpdate();
        }
        finally {
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
            if (conn != null) try { conn.close(); } catch (SQLException e) {}
        }

        return result;
    }

    /* ================= 16. 주문 헤더 조회 (배송 정보 포함) ================= */
    @Override
    public Map<String, Object> selectOrderHeaderforYD(int orderId) throws SQLException {

        Map<String, Object> map = new HashMap<>();

        String sql = 
            " SELECT order_id, order_date, total_amount, discount_amount, " +
            "        delivery_number, " +
            "        TO_CHAR(delivery_startdate, 'YYYY-MM-DD') AS delivery_startdate, " +
            "        NVL(TO_CHAR(delivery_enddate, 'YYYY-MM-DD'), '') AS delivery_enddate, " +
            "        (total_amount - discount_amount) AS final_amount, " +
            "        delivery_address, order_status, recipient_name, recipient_phone, delivery_status " +
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
                    map.put("recipient_name", rs.getString("recipient_name"));
                    map.put("recipient_phone", rs.getString("recipient_phone"));
                    map.put("delivery_status", rs.getInt("delivery_status"));
                    map.put("delivery_number", rs.getString("delivery_number"));
                    map.put("delivery_startdate", rs.getString("delivery_startdate"));
                    map.put("delivery_enddate", rs.getString("delivery_enddate"));
                }
            }
        }

        return map;
    }

    /* ================= 17. 재고 조회 ================= */
    @Override
    public int selectStock(int optionId) throws SQLException {

        int stockQty = 0;

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = ds.getConnection();

            String sql = 
                " SELECT stock_qty " +
                " FROM tbl_product_option " +
                " WHERE option_id = ? ";

            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, optionId);

            rs = pstmt.executeQuery();

            if (rs.next()) {
                stockQty = rs.getInt("stock_qty");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return stockQty;
    }

    /* ================= 18. 재고 복구 ================= */
    @Override
    public int increaseStock(int optionId, int quantity) throws SQLException {
        int result = 0;
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = ds.getConnection();
            
            String sql = 
                " UPDATE tbl_product_option " +
                " SET stock_qty = stock_qty + ? " +
                " WHERE option_id = ? ";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, quantity);
            pstmt.setInt(2, optionId);
            
            result = pstmt.executeUpdate();
            
        } finally {
            if (pstmt != null) {
                try { pstmt.close(); } catch (SQLException e) {}
            }
            if (conn != null) {
                try { conn.close(); } catch (SQLException e) {}
            }
        }
        
        return result;
    }

    /* ================= 유틸리티: 안전한 int 파싱 ================= */
    private int getInt(Map<String, Object> map, String key) {
        Object v = map.get(key);
        if (v == null) return 0;
        if (v instanceof Number) return ((Number) v).intValue();
        try {
            return Integer.parseInt(String.valueOf(v));
        } catch (Exception e) {
            return 0;
        }
    }
}