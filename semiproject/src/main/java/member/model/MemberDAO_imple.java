package member.model;

import java.io.UnsupportedEncodingException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import delivery.domain.DeliveryDTO;
import member.domain.MemberDTO;
import util.security.AES256;
import util.security.SecretMyKey;
import util.security.Sha256;

public class MemberDAO_imple implements MemberDAO {

	private DataSource ds;//(context.xml내) javax.sql.DataSource아파치톰캣이 제공하는 DBCP(DB Connection Pool)이다.
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	private AES256 aes;
	
	public MemberDAO_imple() { //기본생성자 
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

	
	// 회원가입 메서드 
	@Override
	public int registerMember(MemberDTO mbrDto, DeliveryDTO devDto) throws SQLException {
		int result = 0;
	    try {
	        conn = ds.getConnection();
	        conn.setAutoCommit(false);

	        // 1) 회원 insert
	        String sql1 = " INSERT INTO tbl_member(userseq, member_id, name, password, mobile_phone, email, birth_date, gender) "
	        		+ " VALUES(SEQ_TBL_MEMBER_USERSEQ.nextval, ?, ?, ?, ?, ?, ?, ?) ";
	        pstmt = conn.prepareStatement(sql1);
	        pstmt.setString(1, mbrDto.getMemberid());
	        pstmt.setString(2, mbrDto.getName());
	        pstmt.setString(3, Sha256.encrypt(mbrDto.getPassword()));
	        pstmt.setString(4, aes.encrypt(mbrDto.getMobile()));
	        pstmt.setString(5, aes.encrypt(mbrDto.getEmail()));
	        pstmt.setString(6, mbrDto.getBirthday());
	        pstmt.setInt(7, mbrDto.getGender());
	        result = pstmt.executeUpdate();
	        pstmt.close();

	        // 2) 배송지 insert (기본배송지 1건)
	        String sql2 = "INSERT INTO tbl_delivery(DELIVERY_ADDRESS_ID, FK_MEMBER_ID, RECIPIENT_NAME, RECIPIENT_PHONE,"
	                    + " address, ADDRESS_DETAIL , IS_DEFAULT, POSTAL_CODE) "
	                    + "VALUES(SEQ_TBL_DELIVERY_DELIVERY_ADDRESS_ID.nextval, ?, ?, ?, ?, ?, ?, ?)";
	        pstmt = conn.prepareStatement(sql2);
	        pstmt.setString(1, devDto.getMemberId());
	        pstmt.setString(2, devDto.getRecipientName());
	        pstmt.setString(3, aes.encrypt(devDto.getRecipientPhone())); // 암호화 대상이면
	        pstmt.setString(4, devDto.getAddress());
	        pstmt.setString(5, devDto.getAddressDetail());
	        pstmt.setInt(6, devDto.getIsDefault());
	        pstmt.setString(7, devDto.getPostalCode());
	        result += pstmt.executeUpdate();

	        conn.commit();
	        return result;

	    } catch (Exception e) {
	        if (conn != null) conn.rollback();
	        throw new SQLException(e);
	    } finally {
	        close(); 
	    }
	}

	
	// ID 중복검사
	@Override
	public boolean idDuplicateCheck(String memberid) throws SQLException {
		boolean isExists = false;
		
		try {
			conn = ds.getConnection();
			String sql = " select member_id "
					   + " from tbl_member "
					   + " where member_id = ? ";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, memberid);
			
			rs = pstmt.executeQuery();
			
			isExists = rs.next();
			// 행이 있으면 true  없으면 false 로, 있을경우 중복된 ID 가 있다는거임.
		} finally {
			close();
		}
		return isExists;
	}
}
