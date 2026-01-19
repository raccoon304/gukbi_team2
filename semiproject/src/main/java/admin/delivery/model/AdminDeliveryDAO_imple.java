package admin.delivery.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import admin.delivery.domain.AdminDeliveryDTO;

public class AdminDeliveryDAO_imple implements AdminDeliveryDAO {

    private DataSource ds;
    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;

    public AdminDeliveryDAO_imple() {
        try {
            Context initContext = new InitialContext();
            Context envContext  = (Context)initContext.lookup("java:/comp/env");
            ds = (DataSource)envContext.lookup("SemiProject");
        } catch (NamingException e) {
            e.printStackTrace();
        }
    }

    private void close() {
        try {
            if(rs    != null) { rs.close();    rs=null; }
            if(pstmt != null) { pstmt.close(); pstmt=null; }
            if(conn  != null) { conn.close();  conn=null; }
        } catch(SQLException e) {
            e.printStackTrace();
        }
    }

    // 총 주문건수
    @Override
    public int getTotalOrderCount(Map<String, String> paraMap) throws SQLException {

        int totalCount = 0;

        String deliveryStatus = paraMap.get("deliveryStatus");
        String searchType     = paraMap.get("searchType");
        String searchWord     = paraMap.get("searchWord");
        String excludeFail = paraMap.get("excludeFail");
        
        if(excludeFail == null) excludeFail = "0";
        excludeFail = excludeFail.trim();
        boolean isExcludeFail = "1".equals(excludeFail);

        if (deliveryStatus == null) deliveryStatus = "";
        if (searchType == null) searchType = "";
        if (searchWord == null) searchWord = "";

        deliveryStatus = deliveryStatus.trim();
        searchType = searchType.trim();
        searchWord = searchWord.trim();

        boolean hasDeliveryFilter = (!"".equals(deliveryStatus) && !"ALL".equalsIgnoreCase(deliveryStatus));

        boolean validSearchType =
                "member_id".equals(searchType) ||
                "name".equals(searchType) ||
                "recipient_name".equals(searchType) ||
                "order_id".equals(searchType);

        boolean hasSearch = (!"".equals(searchType) && !"".equals(searchWord) && validSearchType);

        try {
            conn = ds.getConnection();

            String sql = " SELECT COUNT(*) "
                       + "   FROM tbl_orders o "
                       + "   JOIN tbl_member m "
                       + "     ON m.member_id = o.fk_member_id "
                       + "  WHERE 1=1 ";

            
            if (isExcludeFail) {
                sql += " AND o.delivery_status != 4 ";
            }
            
            if (hasDeliveryFilter) {
                sql += " AND o.delivery_status = ? ";
            }

            if (hasSearch) {
                if ("member_id".equals(searchType)) {
                    sql += " AND o.fk_member_id LIKE '%'||?||'%' ";
                }
                else if ("name".equals(searchType)) {
                    sql += " AND m.name LIKE '%'||?||'%' ";
                }
                else if ("recipient_name".equals(searchType)) {
                    sql += " AND o.recipient_name LIKE '%'||?||'%' ";
                }
                else if ("order_id".equals(searchType)) {
                    sql += " AND TO_CHAR(o.order_id) LIKE '%'||?||'%' ";
                }
            }

            pstmt = conn.prepareStatement(sql);

            if (hasDeliveryFilter && hasSearch) {
                pstmt.setInt(1, Integer.parseInt(deliveryStatus));
                pstmt.setString(2, searchWord);
            }
            else if (hasDeliveryFilter && !hasSearch) {
                pstmt.setInt(1, Integer.parseInt(deliveryStatus));
            }
            else if (!hasDeliveryFilter && hasSearch) {
                pstmt.setString(1, searchWord);
            }

            rs = pstmt.executeQuery();
            if (rs.next()) totalCount = rs.getInt(1);

        } finally {
            close();
        }

        return totalCount;
    }

    // 총 페이지수
    @Override
    public int getTotalPageOrder(Map<String, String> paraMap) throws SQLException {

        int totalPage = 0;

        String deliveryStatus = paraMap.get("deliveryStatus");
        String searchType     = paraMap.get("searchType");
        String searchWord     = paraMap.get("searchWord");
        String excludeFail = paraMap.get("excludeFail");
        
        if(excludeFail == null) excludeFail = "0";
        excludeFail = excludeFail.trim();
        boolean isExcludeFail = "1".equals(excludeFail);

        if (deliveryStatus == null) deliveryStatus = "";
        if (searchType == null) searchType = "";
        if (searchWord == null) searchWord = "";

        deliveryStatus = deliveryStatus.trim();
        searchType = searchType.trim();
        searchWord = searchWord.trim();

        boolean hasDeliveryFilter = (!"".equals(deliveryStatus) && !"ALL".equalsIgnoreCase(deliveryStatus));

        boolean validSearchType =
                "member_id".equals(searchType) ||
                "name".equals(searchType) ||
                "recipient_name".equals(searchType) ||
                "order_id".equals(searchType);

        boolean hasSearch = (!"".equals(searchType) && !"".equals(searchWord) && validSearchType);

        try {
            conn = ds.getConnection();

            String sql = " SELECT CEIL(COUNT(*)/?) "
                       + "   FROM tbl_orders o "
                       + "   JOIN tbl_member m "
                       + "     ON m.member_id = o.fk_member_id "
                       + "  WHERE 1=1 ";

            if (isExcludeFail) {
                sql += " AND o.delivery_status != 4 ";
            }
            
            if (hasDeliveryFilter) {
                sql += " AND o.delivery_status = ? ";
            }

            if (hasSearch) {
                if ("member_id".equals(searchType)) {
                    sql += " AND o.fk_member_id LIKE '%'||?||'%' ";
                }
                else if ("name".equals(searchType)) {
                    sql += " AND m.name LIKE '%'||?||'%' ";
                }
                else if ("recipient_name".equals(searchType)) {
                    sql += " AND o.recipient_name LIKE '%'||?||'%' ";
                }
                else if ("order_id".equals(searchType)) {
                    sql += " AND TO_CHAR(o.order_id) LIKE '%'||?||'%' ";
                }
            }

            pstmt = conn.prepareStatement(sql);

            pstmt.setInt(1, Integer.parseInt(paraMap.get("sizePerPage")));

            if (hasDeliveryFilter && hasSearch) {
                pstmt.setInt(2, Integer.parseInt(deliveryStatus));
                pstmt.setString(3, searchWord);
            }
            else if (hasDeliveryFilter && !hasSearch) {
                pstmt.setInt(2, Integer.parseInt(deliveryStatus));
            }
            else if (!hasDeliveryFilter && hasSearch) {
                pstmt.setString(2, searchWord);
            }

            rs = pstmt.executeQuery();
            if (rs.next()) totalPage = rs.getInt(1);

        } finally {
            close();
        }

        return totalPage;
    }

    // 페이지별 주문/배송 리스트
    @Override
    public List<AdminDeliveryDTO> selectOrderDeliveryPaging(Map<String, String> paraMap) throws SQLException {

        List<AdminDeliveryDTO> list = new ArrayList<>();

        int sizePerPage = Integer.parseInt(paraMap.get("sizePerPage"));
        int currentShowPageNo = Integer.parseInt(paraMap.get("currentShowPageNo"));

        int begin = (currentShowPageNo - 1) * sizePerPage + 1;
        int end   = begin + sizePerPage - 1;

        String deliveryStatus = paraMap.get("deliveryStatus");
        String sort           = paraMap.get("sort");
        String searchType     = paraMap.get("searchType");
        String searchWord     = paraMap.get("searchWord");
        String excludeFail = paraMap.get("excludeFail");
        
        if(excludeFail == null) excludeFail = "0";
        excludeFail = excludeFail.trim();
        boolean isExcludeFail = "1".equals(excludeFail);

        if (deliveryStatus == null) deliveryStatus = "";
        if (sort == null) sort = "";
        if (searchType == null) searchType = "";
        if (searchWord == null) searchWord = "";

        deliveryStatus = deliveryStatus.trim();
        sort = sort.trim();
        searchType = searchType.trim();
        searchWord = searchWord.trim();

        boolean hasDeliveryFilter = (!"".equals(deliveryStatus) && !"ALL".equalsIgnoreCase(deliveryStatus));

        boolean validSearchType =
                "member_id".equals(searchType) ||
                "name".equals(searchType) ||
                "recipient_name".equals(searchType) ||
                "order_id".equals(searchType);

        boolean hasSearch = (!"".equals(searchType) && !"".equals(searchWord) && validSearchType);

        String orderBy = " o.order_date DESC, o.order_id DESC ";
        if ("oldest".equals(sort)) {
            orderBy = " o.order_date ASC, o.order_id ASC ";
        }

        try {
            conn = ds.getConnection();

            String sql = " SELECT rno, order_id, member_id, member_name, order_date, "
                       + "        total_amount, discount_amount, order_status, pay_amount, "
                       + "        recipient_name, recipient_phone, delivery_status, "
                       + "        delivery_number, delivery_startdate, delivery_enddate, "
                       + "        product_name, brand_name, detail_cnt, color, storage_size "
                       + " FROM ( "
                       + "   SELECT ROW_NUMBER() OVER(ORDER BY " + orderBy + ") AS rno, "
                       + "          o.order_id, "
                       + "          o.fk_member_id AS member_id, "
                       + "          m.name AS member_name, "
                       + "          TO_CHAR(o.order_date,'YYYY-MM-DD') AS order_date, "
                       + "          o.total_amount, "
                       + "          o.discount_amount, "
                       + "          o.order_status, "
                       + "          (NVL(o.total_amount,0) - NVL(o.discount_amount,0)) AS pay_amount, "
                       + "          o.recipient_name, "
                       + "          o.recipient_phone, "
                       + "          o.delivery_status, "
                       + "          o.delivery_number, "
                       + "          TO_CHAR(o.delivery_startdate,'YYYY-MM-DD') AS delivery_startdate, "
                       + "          TO_CHAR(o.delivery_enddate,'YYYY-MM-DD') AS delivery_enddate, "
                       + "          dr.product_name, "
                       + "          dr.brand_name, "
                       + "          dr.detail_cnt, "
                       + "          po.color, "
                       + "          po.storage_size "
                       + "     FROM tbl_orders o "
                       + "     JOIN tbl_member m "
                       + "       ON m.member_id = o.fk_member_id "
                       + "     LEFT JOIN ( "
                       + "                   SELECT fk_order_id, product_name, brand_name, fk_option_id, detail_cnt "
                       + "                   FROM ( "
                       + "                   		SELECT d.fk_order_id, "
                       + "                                  d.product_name, "
                       + "                                  d.brand_name, "
                       + "                                  d.fk_option_id, "
                       + "                                  ROW_NUMBER() OVER(PARTITION BY d.fk_order_id "
                       + "                                                    ORDER BY d.unit_price DESC, d.order_detail_id DESC) AS rn, "
                       + "                                  COUNT(*) OVER(PARTITION BY d.fk_order_id) AS detail_cnt "
                       + "                           FROM tbl_order_detail d "
                       + "                         ) "
                       + "                    WHERE rn = 1 ) dr "
                       + "       ON dr.fk_order_id = o.order_id "
                       + "     LEFT JOIN tbl_product_option po "
                       + "       ON po.option_id = dr.fk_option_id "
                       + "    WHERE 1=1 ";
            
            if (isExcludeFail) {
                sql += " AND o.delivery_status != 4 ";
            }

            if (hasDeliveryFilter) {
                sql += " AND o.delivery_status = ? ";
            }

            if (hasSearch) {
                if ("member_id".equals(searchType)) {
                    sql += " AND o.fk_member_id LIKE '%'||?||'%' ";
                }
                else if ("name".equals(searchType)) {
                    sql += " AND m.name LIKE '%'||?||'%' ";
                }
                else if ("recipient_name".equals(searchType)) {
                    sql += " AND o.recipient_name LIKE '%'||?||'%' ";
                }
                else if ("order_id".equals(searchType)) {
                    sql += " AND TO_CHAR(o.order_id) LIKE '%'||?||'%' ";
                }
            }

            sql += " ) "
                 + " WHERE rno BETWEEN ? AND ? ";

            pstmt = conn.prepareStatement(sql);

            if (hasDeliveryFilter && hasSearch) {
                pstmt.setInt(1, Integer.parseInt(deliveryStatus));
                pstmt.setString(2, searchWord);
                pstmt.setInt(3, begin);
                pstmt.setInt(4, end);
            }
            else if (hasDeliveryFilter && !hasSearch) {
                pstmt.setInt(1, Integer.parseInt(deliveryStatus));
                pstmt.setInt(2, begin);
                pstmt.setInt(3, end);
            }
            else if (!hasDeliveryFilter && hasSearch) {
                pstmt.setString(1, searchWord);
                pstmt.setInt(2, begin);
                pstmt.setInt(3, end);
            }
            else {
                pstmt.setInt(1, begin);
                pstmt.setInt(2, end);
            }

            rs = pstmt.executeQuery();

            while (rs.next()) {

                AdminDeliveryDTO dto = new AdminDeliveryDTO();

                dto.setRownum(rs.getInt("rno"));
                dto.setDetailCnt(rs.getInt("detail_cnt"));
                dto.setPayAmount(rs.getLong("pay_amount"));
                dto.setDeliveryNumber(rs.getString("delivery_number"));
                dto.setDeliveryStartdate(rs.getString("delivery_startdate"));
                dto.setDeliveryEnddate(rs.getString("delivery_enddate"));

                dto.getOdto().setOrderId(rs.getInt("order_id"));
                dto.getOdto().setMemberId(rs.getString("member_id"));
                dto.getOdto().setOrderDate(rs.getString("order_date"));
                dto.getOdto().setTotalAmount(rs.getInt("total_amount"));
                dto.getOdto().setDiscountAmount(rs.getInt("discount_amount"));
             // dto.getOdto().setDeliveryAddress(rs.getString("delivery_address"));
                dto.getOdto().setOrderStatus(rs.getString("order_status"));

                dto.setRecipientName(rs.getString("recipient_name"));
                dto.setRecipientPhone(rs.getString("recipient_phone"));
                dto.setDeliveryStatus(rs.getInt("delivery_status"));

                dto.getMdto().setName(rs.getString("member_name"));
                dto.getPdto().setProductName(rs.getString("product_name"));
                dto.getPdto().setBrandName(rs.getString("brand_name"));
                dto.getPodto().setColor(rs.getString("color"));
                dto.getPodto().setStorageSize(rs.getString("storage_size"));

                list.add(dto);
            }

        } finally {
            close();
        }

        return list;
    }

    
    // 배송상태 일괄 변경 (결제실패는 제외 / 0,1,2만 허용)
    @Override
    public int updateDeliveryStatus(List<Long> orderIdList, int newStatus) throws SQLException {

    	 	if (orderIdList == null || orderIdList.isEmpty()) return 0;
    	    if (newStatus != 1 && newStatus != 2) return 0;

    	    int updated = 0;

    	    try {
    	        conn = ds.getConnection();
    	        conn.setAutoCommit(false);

    	       
    	        if (newStatus == 1) {
    	            // 테이블 락
    	            pstmt = conn.prepareStatement("LOCK TABLE tbl_orders IN EXCLUSIVE MODE");
    	            pstmt.executeUpdate();
    	            pstmt.close(); pstmt = null;

    	            String ymd = new SimpleDateFormat("yyyyMMdd").format(new Date());

    	            // 오늘 배송번호의 최대 뒷번호 + 1
    	            int nextNo = 1;
    	            String sqlMax =
    	                    " SELECT NVL(MAX(TO_NUMBER(SUBSTR(delivery_number, INSTR(delivery_number,'-')+1))),0) + 1 "
    	                  + "   FROM tbl_orders "
    	                  + "  WHERE delivery_number LIKE ? ";

    	            pstmt = conn.prepareStatement(sqlMax);
    	            pstmt.setString(1, "D" + ymd + "-%");
    	            rs = pstmt.executeQuery();
    	            if (rs.next()) nextNo = rs.getInt(1);
    	            rs.close(); rs = null;
    	            pstmt.close(); pstmt = null;

    	            // 0 -> 1 만 허용
    	            String sqlUpd =
    	                    " UPDATE tbl_orders "
    	                  + "    SET delivery_status = 1 "
    	                  + "      , delivery_startdate = SYSDATE "
    	                  + "      , delivery_number = ? "
    	                  + "  WHERE order_id = ? "
    	                  + "    AND delivery_status = 0 "
    	                  + "    AND delivery_status != 4 ";

    	            pstmt = conn.prepareStatement(sqlUpd);

    	            for (Long orderId : orderIdList) {
    	                String deliveryNo = "D" + ymd + "-" + nextNo;
    	                nextNo++;

    	                pstmt.setString(1, deliveryNo);
    	                pstmt.setLong(2, orderId);

    	                updated += pstmt.executeUpdate();
    	            }
    	        }
    	        else { // newStatus == 2
    	            // 1 -> 2 만 허용
    	            String sqlUpd =
    	                    " UPDATE tbl_orders "
    	                  + "    SET delivery_status = 2 "
    	                  + "      , delivery_enddate = SYSDATE "
    	                  + "  WHERE order_id = ? "
    	                  + "    AND delivery_status = 1 "
    	                  + "    AND delivery_status != 4 ";

    	            pstmt = conn.prepareStatement(sqlUpd);

    	            for (Long orderId : orderIdList) {
    	                pstmt.setLong(1, orderId);
    	                updated += pstmt.executeUpdate();
    	            }
    	        }

    	        conn.commit();

    	    } catch (SQLException e) {
    	        if (conn != null) {
    	        		try { 
    	        			conn.rollback(); 
    	        		} catch (SQLException er) {}
    	        }
    	        throw e;
    	    } finally {
    	        if (conn != null) {
	    	        	try { 
	    	        		conn.setAutoCommit(true);
	    	        	} catch (SQLException e) {}
    	        }
    	        close();
    	    }

    	    return updated;
    }
    
    
    // 배송 상태 조회
    @Override
    public Map<Long, Integer> selectDeliveryStatusMap(List<Long> orderIdList) throws SQLException {

        Map<Long, Integer> map = new java.util.HashMap<>();
        if (orderIdList == null || orderIdList.isEmpty()) return map;

        try {
            conn = ds.getConnection();

            String placeholders = "";
            for (int i = 0; i < orderIdList.size(); i++) {
                placeholders += (i == 0 ? "?" : ",?");
            }

            String sql = " SELECT order_id, delivery_status "
                       + "   FROM tbl_orders "
                       + "  WHERE order_id IN (" + placeholders + ") ";

            pstmt = conn.prepareStatement(sql);

            for (int i = 0; i < orderIdList.size(); i++) {
                pstmt.setLong(i + 1, orderIdList.get(i));
            }

            rs = pstmt.executeQuery();
            while (rs.next()) {
                map.put(rs.getLong("order_id"), rs.getInt("delivery_status"));
            }

        } finally {
            close();
        }

        return map;
    }
    
    
}
