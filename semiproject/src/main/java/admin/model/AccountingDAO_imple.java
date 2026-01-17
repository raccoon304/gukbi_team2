package admin.model;

import java.io.UnsupportedEncodingException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import admin.domain.DailyAggDTO;
import admin.domain.OptionAggDTO;
import admin.domain.ProductAggDTO;
import admin.domain.TotalsDTO;
import util.security.AES256;
import util.security.SecretMyKey;

public class AccountingDAO_imple implements AccountingDAO {

	
	private DataSource ds; // DataSource ds 는 아파치톰캣이 제공하는 DBCP(DB Connection Pool)이다.
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	private AES256 aes;
	
	public AccountingDAO_imple() {
		
		try {
	    		Context initContext = new InitialContext();
	        Context envContext  = (Context)initContext.lookup("java:/comp/env");
	        ds = (DataSource)envContext.lookup("SemiProject");
	        
	        aes = new AES256(SecretMyKey.KEY);
	        // SecretMyKey.KEY 은 우리가 만든 암호화/복호화 키이다.
	        
	    	} catch(NamingException e) {
	    		e.printStackTrace();
	    	} catch(UnsupportedEncodingException e) {
	    		e.printStackTrace();
	    	}
	}
		
		
	// 사용한 자원을 반납하는 close() 메소드 생성하기
 	private void close() {
 		try {
 			if(rs    != null) {rs.close();	  rs=null;}
 			if(pstmt != null) {pstmt.close(); pstmt=null;}
 			if(conn  != null) {conn.close();  conn=null;}
 		} catch(SQLException e) {
 			e.printStackTrace();
 		}
 	}// end of private void close()---------------


   // 상단 카드 합계금액 구하기
	@Override
	public TotalsDTO selectTotals(LocalDate start, LocalDate end) throws Exception {
		
		TotalsDTO tdto = new TotalsDTO();
		
		String sql = " WITH orders_in_range AS ( "
				   + "   SELECT order_id, total_amount, discount_amount "
				   + "    FROM tbl_orders "
				   + "    WHERE order_date >= ? AND order_date < ? "
				   + "    AND order_status = 'PAID' "
				   + " ), detail_sum AS ( "
				   + "   SELECT d.fk_order_id AS order_id, "
				   + "          SUM(d.quantity) AS qty, "
				   + "          SUM(d.quantity * d.unit_price) AS gross "
				   + "     FROM tbl_order_detail d "
				   + "     JOIN orders_in_range o ON o.order_id = d.fk_order_id "
				   + "    GROUP BY d.fk_order_id "
				   + " ) "
				   + " SELECT "
				   + "   COUNT(*) AS orders, "
				   + "   NVL(SUM(ds.qty),0) AS qty, "
				   + "   NVL(SUM(ds.gross),0) AS gross, "            // 할인 전
				   + "   NVL(SUM(o.discount_amount),0) AS discount, "
				   + "   NVL(SUM(o.total_amount),0) AS net "         // 할인 후
				   + " FROM orders_in_range o "
				   + " LEFT JOIN detail_sum ds ON ds.order_id = o.order_id ";


        try {
        		 conn = ds.getConnection();
             pstmt = conn.prepareStatement(sql);

             pstmt.setDate(1, Date.valueOf(start));
             pstmt.setDate(2, Date.valueOf(end));

             rs = pstmt.executeQuery();
            	
             if (rs.next()) {
                	
            	 	tdto.setOrders(rs.getLong("orders"));
            	 	tdto.setQty(rs.getLong("qty"));
            	 	tdto.setGross(rs.getLong("gross")); 
            	 	tdto.setDiscount(rs.getLong("discount"));
            	 	tdto.setNet(rs.getLong("net"));
                    
             }
            
        }finally{
        		close();
        }
        return tdto;
		
	}// end of public Map<String, Object> selectTotals(LocalDate start, LocalDate end) throws Exception -------


	// 기간별 집계(일별)
	@Override
	public List<DailyAggDTO> selectDaily(LocalDate start, LocalDate end) throws Exception {
		
		String sql = " WITH orders_in_range AS ( "
				   + "   SELECT order_id, TRUNC(order_date) AS base_date "
				   + "    FROM tbl_orders "
				   + "    WHERE order_date >= ? AND order_date < ? "
				   + "    AND order_status = 'PAID' "
				   + " ) "
				   + " SELECT "
				   + "   TO_CHAR(o.base_date, 'YYYY-MM-DD') AS baseDate, "
				   + "   COUNT(DISTINCT o.order_id) AS orders, "
				   + "   NVL(SUM(d.quantity),0) AS qty, "
				   + "   NVL(SUM(d.quantity * d.unit_price),0) AS amount "  // 할인 전
				   + " FROM orders_in_range o "
				   + " JOIN tbl_order_detail d ON d.fk_order_id = o.order_id "
				   + " GROUP BY o.base_date "
				   + " ORDER BY o.base_date DESC ";

	    List<DailyAggDTO> list = new ArrayList<>();

	    try { 
	    		  conn = ds.getConnection();
	          pstmt = conn.prepareStatement(sql);

	          pstmt.setDate(1, Date.valueOf(start));
	          pstmt.setDate(2, Date.valueOf(end));

	          rs = pstmt.executeQuery();
	          
	          while (rs.next()) {
	        	  
	        	    DailyAggDTO ddto = new DailyAggDTO();
	        	    
	        	    ddto.setBaseDate(rs.getString("baseDate"));
	        	    ddto.setOrders(rs.getLong("orders"));
	        	    ddto.setQty(rs.getLong("qty"));
	        	    ddto.setAmount(rs.getLong("amount"));
	        	    
                list.add(ddto);
	          }
	        
	    }finally {
	    		close();
	    }

	    return list;
	}// end of public List<Map<String, Object>> selectDaily(LocalDate start, LocalDate end) throws Exception -------

	
	// 기간별 집계(월별)
	@Override
	public List<DailyAggDTO> selectMonthly(LocalDate start, LocalDate end) throws Exception {

	    String sql = " WITH orders_in_range AS ( "
	        		   + "   SELECT order_id, TRUNC(order_date,'MM') AS base_month, total_amount "
	        		   + "     FROM tbl_orders "
	        		   + "    WHERE order_date >= ? AND order_date < ? "
	        		   + "      AND order_status = 'PAID' "
	        		   + " ), order_qty AS ( "
	        		   + "   SELECT d.fk_order_id AS order_id, SUM(d.quantity) AS qty "
	        		   + "     FROM tbl_order_detail d "
	        		   + "     JOIN orders_in_range o ON o.order_id = d.fk_order_id "
	        		   + "    GROUP BY d.fk_order_id "
	        		   + " ) "
	        		   + " SELECT "
	        		   + "   TO_CHAR(o.base_month, 'YYYY-MM') AS baseDate, "
	        		   + "   COUNT(*) AS orders, "
	        		   + "   NVL(SUM(q.qty),0) AS qty, "
	        		   + "   NVL(SUM(o.total_amount),0) AS amount "
	        		   + " FROM orders_in_range o "
	        		   + " LEFT JOIN order_qty q ON q.order_id = o.order_id "
	        		   + " GROUP BY o.base_month "
	        		   + " ORDER BY o.base_month DESC ";

	    List<DailyAggDTO> list = new ArrayList<>();

	    try {
	        conn = ds.getConnection();
	        pstmt = conn.prepareStatement(sql);

	        pstmt.setDate(1, Date.valueOf(start));
	        pstmt.setDate(2, Date.valueOf(end));

	        rs = pstmt.executeQuery();

	        while (rs.next()) {
	            DailyAggDTO ddto = new DailyAggDTO();
	            ddto.setBaseDate(rs.getString("baseDate")); // YYYY-MM
	            ddto.setOrders(rs.getLong("orders"));
	            ddto.setQty(rs.getLong("qty"));
	            ddto.setAmount(rs.getLong("amount"));
	            list.add(ddto);
	        }
	    } finally {
	        close();
	    }

	    return list;
	}// end of public List<DailyAggDTO> selectMonthly(LocalDate start, LocalDate end) throws Exception -------
	

	// 상품별 집계
	@Override
	public List<ProductAggDTO> selectProducts(LocalDate start, LocalDate end, String sort) throws Exception {
		
		// 정렬
	    String orderBy;
	    if ("quantity".equals(sort)) orderBy = " ORDER BY qty DESC ";
	    else if ("name".equals(sort)) orderBy = " ORDER BY productName ASC ";
	    else orderBy = " ORDER BY amount DESC "; // revenue 기본

	    // 할인 반영 전: amount = SUM(quantity * unit_price)
	    String sql = " WITH orders_in_range AS ( "
	    			   + "   SELECT order_id "
	    			   + "     FROM tbl_orders "
	    			   + "    WHERE order_date >= ? AND order_date < ? "
	    			   + "      AND order_status = 'PAID' "  // 추후에 추가
	    			   + " ) "
	    			   + " SELECT "
	    			   + "   p.product_code AS productNo, "
	    			   + "   p.product_name AS productName, "
	    			   + "   p.brand_name  AS brand, "
	    			   + "   NVL(SUM(d.quantity),0) AS qty, "
	    			   + "   NVL(SUM(d.quantity * d.unit_price),0) AS amount "
	    			   + " FROM orders_in_range o "
	    			   + " JOIN tbl_order_detail d ON d.fk_order_id = o.order_id "
	    			   + " JOIN tbl_product_option po ON po.option_id = d.fk_option_id "
	    			   + " JOIN tbl_product p ON p.product_code = po.fk_product_code "
	    			   + " GROUP BY p.product_code, p.product_name, p.brand_name "
	    			   + orderBy;

	    List<ProductAggDTO> list = new ArrayList<>();

	    try {
	    	    conn = ds.getConnection();
	        pstmt = conn.prepareStatement(sql);

	        pstmt.setDate(1, Date.valueOf(start));
	        pstmt.setDate(2, Date.valueOf(end));

	        rs = pstmt.executeQuery();
	        
            while (rs.next()) {
            		ProductAggDTO pdto = new ProductAggDTO();
            		
            		pdto.setProductNo(rs.getString("productNo"));
            		pdto.setProductName(rs.getString("productName"));
            		pdto.setBrand(rs.getString("brand"));
                pdto.setQty(rs.getLong("qty"));
                pdto.setAmount(rs.getLong("amount"));
                
                list.add(pdto);            
	        }
	    }finally {
	    		close();
	    }
	    return list;
	}// end of public List<Map<String, Object>> selectProducts(LocalDate start, LocalDate end, String sort) throws Exception -------
	
	
	// 상품별 옵션 상세 집계
	@Override
	public List<OptionAggDTO> selectOptionSales(LocalDate start, LocalDate end, String productNo) throws Exception {

	    String sql = " WITH orders_in_range AS ( "
		        	   + "   SELECT order_id "
		           + "     FROM tbl_orders "
		           + "    WHERE order_date >= ? AND order_date < ? "
		           + "      AND order_status = 'PAID' "
		           + " ) "
		           + " SELECT "
		           + "   po.option_id AS optionId, "
		           + "   po.color AS color, "
		           + "   po.storage_size AS storageSize, "
		           + "   NVL(SUM(d.quantity),0) AS qty,"
		           + "   NVL(SUM(d.quantity * d.unit_price),0) AS amount "
		           + " FROM orders_in_range o "
		           + " JOIN tbl_order_detail d ON d.fk_order_id = o.order_id "
		           + " JOIN tbl_product_option po ON po.option_id = d.fk_option_id "
		           + " WHERE po.fk_product_code = ? "
		           + " GROUP BY po.option_id, po.color, po.storage_size "
		           + " ORDER BY qty DESC ";

	    List<OptionAggDTO> list = new ArrayList<>();

	    try {
	        conn = ds.getConnection();
	        pstmt = conn.prepareStatement(sql);

	        pstmt.setDate(1, java.sql.Date.valueOf(start));
	        pstmt.setDate(2, java.sql.Date.valueOf(end));
	        pstmt.setString(3, productNo);

	        rs = pstmt.executeQuery();

	        while (rs.next()) {
	            OptionAggDTO odto = new OptionAggDTO();
	            odto.setOptionId(rs.getInt("optionId"));
	            odto.setColor(rs.getString("color"));
	            odto.setStorageSize(rs.getString("storageSize"));
	            odto.setQty(rs.getInt("qty"));
	            odto.setAmount(rs.getLong("amount"));
	            list.add(odto);
	        }
	    } finally {
	        close();
	    }
	    return list;
	}// end of public List<OptionAggDTO> selectOptionSales(LocalDate start, LocalDate end, String productNo) throws Exception -------
	
}
