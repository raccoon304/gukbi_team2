package delivery.model;

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

import delivery.domain.DeliveryDTO;
import util.security.AES256;
import util.security.SecretMyKey;

public class DeliveryDAO_imple implements DeliveryDAO {

	
	private DataSource ds;//(context.xml내) javax.sql.DataSource아파치톰캣이 제공하는 DBCP(DB Connection Pool)이다.
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	private AES256 aes;
	
	public DeliveryDAO_imple() { //기본생성자 
		Context initContext;
		try {
			initContext = new InitialContext();
		    Context envContext  = (Context)initContext.lookup("java:/comp/env");
		    ds = (DataSource)envContext.lookup("SemiProject");
		    
		    // SecretMyKey.KEY 은 우리가 만든 암호화/복호화 키이다.
		    aes = new AES256(SecretMyKey.KEY);
 
		} catch (NamingException e) {
			e.printStackTrace();
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
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
	
	

	// 배송지 목록 가져오기 
	@Override
	public List<DeliveryDTO> selectDeliveryList(String memberid) throws SQLException {
		List<DeliveryDTO> deliveryList = new ArrayList<>();
		
		try {
			conn = ds.getConnection();
			
			String sql = " select delivery_address_id, recipient_name, recipient_phone, address, address_detail, is_default, postal_code, address_name "
					+ " from tbl_delivery "
					+ " where fk_member_id = ? ";
			
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, memberid);
			rs = pstmt.executeQuery();
			
			
			while(rs.next()) {
				DeliveryDTO dDto = new DeliveryDTO();
				dDto.setDeliveryAddressId(rs.getInt("delivery_address_id"));
				dDto.setRecipientName(rs.getString("recipient_name"));
				
				String recipientPhone = rs.getString("recipient_phone");
				dDto.setRecipientPhone(aes.decrypt(recipientPhone));
				
				dDto.setAddress(rs.getString("address"));
				dDto.setAddressDetail(rs.getString("address_detail"));
				dDto.setIsDefault(rs.getInt("is_default"));
				dDto.setPostalCode(rs.getString("postal_code"));
				dDto.setAddressName(rs.getString("address_name"));
				
				deliveryList.add(dDto);
			}// EoP while
			
		} catch (UnsupportedEncodingException | GeneralSecurityException e) {
			e.printStackTrace();
		} finally {
			close();
		}
		
		return deliveryList;
	}

	// 배송지를 삭제하는 메서드
	@Override
	public int deleteDelivery(String memberid) throws SQLException {
		int n = 0;
		
		conn = ds.getConnection();
		
		String sql = " select delivery_address_id, recipient_name, recipient_phone, address, address_detail, is_default, postal_code, address_name "
				+ " from tbl_delivery "
				+ " where fk_member_id = ? ";
		
		pstmt = conn.prepareStatement(sql);
		
		pstmt.setString(1, memberid);
		rs = pstmt.executeQuery();
		
		
		
		return 0;
	}

}
