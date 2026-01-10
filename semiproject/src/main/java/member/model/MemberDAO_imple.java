package member.model;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Map;

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

	        // 회원 insert
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
	        pstmt.close();   // sql1 pstmt 닫기

	        // 배송지 insert 
	        String sql2 = " INSERT INTO tbl_delivery(DELIVERY_ADDRESS_ID, FK_MEMBER_ID, ADDRESS_NAME, RECIPIENT_NAME, RECIPIENT_PHONE, " 
	                    + " ADDRESS, ADDRESS_DETAIL, IS_DEFAULT, POSTAL_CODE) " 
	                    + " VALUES(SEQ_TBL_DELIVERY_DELIVERY_ADDRESS_ID.nextval, ?, ?, ?, ?, ?, ?, ?, ?) ";

	        pstmt = conn.prepareStatement(sql2); 

	        pstmt.setString(1, devDto.getMemberId());
	        pstmt.setString(2, devDto.getAddressName());
	        pstmt.setString(3, devDto.getRecipientName());
	        pstmt.setString(4, aes.encrypt(devDto.getRecipientPhone()));
	        pstmt.setString(5, devDto.getAddress());
	        pstmt.setString(6, devDto.getAddressDetail());
	        pstmt.setInt(7, devDto.getIsDefault());
	        pstmt.setString(8, devDto.getPostalCode());

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

	
	
	// email 중복검사
	@Override
	public boolean emailDuplicateCheck(String email) throws SQLException {
		boolean isExists = false;
		
		try {
			conn = ds.getConnection();
			String sql = " select email "
					   + " from tbl_member "
					   + " where email = ? ";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, aes.encrypt(email));
			
			rs = pstmt.executeQuery();
			
			isExists = rs.next();
			
			// 행이 있으면 true  없으면 false 로, 있을경우 중복된 email이 있다는거임.
		} catch (UnsupportedEncodingException | GeneralSecurityException e) {
			e.printStackTrace();
		}  finally {
			close();
		}
		return isExists;
	}

	@Override
	public boolean mobileDuplicateCheck(String mobile) throws SQLException {
		boolean isExists = false;
		
		try {
			conn = ds.getConnection();
			String sql = " select mobile_phone "
					   + " from tbl_member "
					   + " where mobile_phone = ? ";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, aes.encrypt(mobile));
			
			rs = pstmt.executeQuery();
			
			isExists = rs.next();
			
			// 행이 있으면 true  없으면 false 로, 있을경우 중복된 휴대전화 번호가 있다는거임.
		} catch (UnsupportedEncodingException | GeneralSecurityException e) {
			e.printStackTrace();
		}  finally {
			close();
		}
		return isExists;
	}

	
	
	// 로그인 
	@Override
	public MemberDTO login(Map<String, String> paraMap) throws SQLException {
		MemberDTO memberDto = null;
	
	    try {
	    	conn = ds.getConnection();

	        String sql =
	              " SELECT "
	            + " 	USERSEQ, MEMBER_ID, NAME, MOBILE_PHONE, EMAIL, BIRTH_DATE, GENDER, STATUS, IDLE, "
	            + " 	TO_CHAR(CREATED_AT, 'YYYYMMDD') AS CREATED_AT "
	            + " FROM TBL_MEMBER "
	            + " WHERE STATUS = 0 "
	            + "   AND MEMBER_ID = ? "
	            + "   AND PASSWORD  = ? ";

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, paraMap.get("loginId"));
	        pstmt.setString(2, Sha256.encrypt(paraMap.get("loginPw")));

	        rs = pstmt.executeQuery();
	        
	        if (rs.next()) {
	            memberDto = new MemberDTO();
	            memberDto.setUserseq(rs.getInt("USERSEQ"));
	            memberDto.setMemberid(rs.getString("MEMBER_ID"));
	            memberDto.setName(rs.getString("NAME"));

	            // 회원가입에서 AES로 저장했으니 로그인 시 복호화해서 DTO에 담기
	            memberDto.setMobile(aes.decrypt(rs.getString("MOBILE_PHONE")));
	            memberDto.setEmail(aes.decrypt(rs.getString("EMAIL")));

	            memberDto.setBirthday(rs.getString("BIRTH_DATE"));
	            memberDto.setGender(rs.getInt("GENDER"));
	            memberDto.setStatus(rs.getInt("STATUS"));
	            memberDto.setIdle(rs.getInt("IDLE"));
	            memberDto.setRegisterday(rs.getString("CREATED_AT"));
	        }

	    } catch (GeneralSecurityException | UnsupportedEncodingException e) {
	        e.printStackTrace();
	        throw new SQLException(e);
	    } finally {
	        close();
	    }

	    return memberDto;
	}

	
	//회원 정보 수정
	@Override
	public int updateMember(Map<String, String> paraMap) throws SQLException {

	    int n = 0;

	    try {
	        conn = ds.getConnection();

	        String password = paraMap.get("password");
	        boolean changePw = (password != null && !password.trim().isEmpty());

	        String sql = " update tbl_member "
	                   + " set NAME = ?, EMAIL = ?, MOBILE_PHONE = ? "
	                   + (changePw ? ", PASSWORD = ? " : "")
	                   + " where MEMBER_ID = ? ";

	        pstmt = conn.prepareStatement(sql);

	        pstmt.setString(1, paraMap.get("name"));

	        String email = paraMap.get("email");
	        pstmt.setString(2, aes.encrypt(email));

	        String mobile = paraMap.get("mobile");
	        pstmt.setString(3, aes.encrypt(mobile));

	        int idx = 4;

	        if (changePw) {
	            pstmt.setString(idx++, Sha256.encrypt(password));
	        }

	        pstmt.setString(idx, paraMap.get("memberid"));

	        n = pstmt.executeUpdate();

	    } catch (UnsupportedEncodingException | GeneralSecurityException e) {
	        e.printStackTrace();
	    } finally {
	        close();
	    }

	    return n;
	}
}
