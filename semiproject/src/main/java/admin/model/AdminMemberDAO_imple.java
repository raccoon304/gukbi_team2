package admin.model;

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


public class AdminMemberDAO_imple implements AdminMemberDAO {
	
	private DataSource ds; // DataSource ds 는 아파치톰캣이 제공하는 DBCP(DB Connection Pool)이다.
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
//	private AES256 aes;
	
	public AdminMemberDAO_imple() {
		
		try {
	    	Context initContext = new InitialContext();
	        Context envContext  = (Context)initContext.lookup("java:/comp/env");
	        ds = (DataSource)envContext.lookup("jdbc/myoracle");
	        
//	        aes = new AES256(SecretMyKey.KEY);
	        // SecretMyKey.KEY 은 우리가 만든 암호화/복호화 키이다.
	        
    	} catch(NamingException e) {
    		e.printStackTrace();
//    	} catch(UnsupportedEncodingException e) {
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

	// 페이징 처리를 위한 검색이 있는 또는 검색이 없는 회원에 대한 총페이지수 알아오기 //
	@Override
	public int getTotalPage(Map<String, String> paraMap) throws Exception {
		
		int totalPage = 0;

		try {
			conn = ds.getConnection();
			
			String sql = " SELECT ceil(count(*)/?) "
					   + " FROM tbl_member "
					   + " WHERE userid != 'admin' "; 
			
			String colname = paraMap.get("searchType");
			String searchWord = paraMap.get("searchWord");
			
			if("email".equals(colname) && !"".equals(searchWord)) {
				// 검색대상이 email 인 경우
//				searchWord = aes.encrypt(searchWord);
			}
			
			if(!"".equals(colname) && !"".equals(searchWord)) {
				// 검색대상 및 검색어가 있는 경우
				
				if("email".equals(colname)) {
					// 검색대상이 email 인 경우
					sql += " AND email = ? ";
				}
				else {
					// 검색대상이 email 이 아닌 경우
					sql += " AND "+colname+" LIKE '%'|| ? ||'%' ";
					// 컬럼명과 테이블명은 위치홀더(?)로 사용하면 꽝!!! 이다.
					// 위치홀더(?)로 들어오는 것은 컬럼명과 테이블명이 아닌 오로지 데이터값만 들어온다.!!!!
				}
			}
			
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setInt(1, Integer.parseInt(paraMap.get("sizePerPage")));
			
			
			if(!"".equals(colname) && !"".equals(searchWord)) {
				// 검색대상 및 검색어가 있는 경우
				pstmt.setString(2, searchWord);
			}
			
			rs = pstmt.executeQuery();
			
			rs.next();
			
			totalPage = rs.getInt(1);
			
//		} catch(GeneralSecurityException | UnsupportedEncodingException e) {
//			  e.printStackTrace();
		} finally {
			close();
		}		
		
		return totalPage;
	}

}
