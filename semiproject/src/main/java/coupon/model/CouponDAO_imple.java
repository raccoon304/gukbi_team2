package coupon.model;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import coupon.domain.CouponDTO;


public class CouponDAO_imple implements CouponDAO {

	private DataSource ds;//(context.xml내) javax.sql.DataSource아파치톰캣이 제공하는 DBCP(DB Connection Pool)이다.
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	public CouponDAO_imple() { // 기본생성자
		Context initContext;
		try {
			initContext = new InitialContext();
		    Context envContext  = (Context)initContext.lookup("java:/comp/env");
		    ds = (DataSource)envContext.lookup("SemiProject");
		    
		    // SecretMyKey.KEY 은 우리가 만든 암호화/복호화 키이다.
		    
		} catch (NamingException e) {
			e.printStackTrace();
		}
	}
	
	
	// 사용한 자원을 반납하는 close() 메소드 생성하기
	private void close() {
		try {
			if(rs    != null) {rs.close();     rs=null;}
			if(pstmt != null) {pstmt.close(); pstmt=null;}
			if(conn  != null) {conn.close();  conn=null;}
		} catch(SQLException e) {
			e.printStackTrace();
		}
	}// end of private void close()---------------
	
	
	// 쿠폰 생성 메서드
	@Override
	public int CouponCreate(CouponDTO cpDto) throws SQLException {
		
		int result = 0;
		
		try {
			conn = ds.getConnection();
			
			String sql = " insert into tbl_coupon(COUPON_CATEGORY_NO, COUPON_NAME, DISCOUNT_TYPE, DISCOUNT_VALUE) "
					   + " values(SEQ_TBL_COUPON_COUPON_CATEGORY_NO.nextval, ?, ?, ?) ";
			
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, cpDto.getCouponName());
			pstmt.setInt(2, cpDto.getDiscountType());
			pstmt.setInt(3, cpDto.getDiscountValue());
			
			
			result = pstmt.executeUpdate();
			
		}finally {
			close();
		}
		
		return result;
	}


	// 쿠폰 리스트를 보여주는 메서드
	@Override
	public List<CouponDTO> selectCouponList() throws SQLException {
		
		List<CouponDTO> couponList = new ArrayList<>();
		
		try {
			conn = ds.getConnection();
			
			String sql = " SELECT coupon_category_no, coupon_name, discount_type, discount_value "
					   + " FROM tbl_coupon "
					   + " ORDER BY coupon_category_no DESC ";

			pstmt = conn.prepareStatement(sql);
			
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				
				CouponDTO cpDto = new CouponDTO();
				
				cpDto.setCouponCategoryNo(rs.getInt("coupon_category_no"));
				cpDto.setCouponName(rs.getString("coupon_name"));
				cpDto.setDiscountType(rs.getInt("discount_type"));
				cpDto.setDiscountValue(rs.getInt("discount_value"));
				
				couponList.add(cpDto);
				
			}// end of while(rs.next()) -------
			
		}finally {
			close();
		}
		
		return couponList;
	}

}
