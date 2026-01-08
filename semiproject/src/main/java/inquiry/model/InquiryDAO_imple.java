package inquiry.model;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import inquiry.domain.InquiryDTO;
import member.domain.MemberDTO;

public class InquiryDAO_imple implements InquiryDAO {
    
    private DataSource ds;
    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;
    
    // 기본 생성자
    public InquiryDAO_imple() {
        try {
            Context initContext = new InitialContext();
            Context envContext = (Context) initContext.lookup("java:/comp/env");
            ds = (DataSource) envContext.lookup("SemiProject");
        } catch (NamingException e) {
            e.printStackTrace();
        }
    }
    
    // 자원 반납
    private void close() {
        try {
            if (rs != null) {
                rs.close();
                rs = null;
            }
            if (pstmt != null) {
                pstmt.close();
                pstmt = null;
            }
            if (conn != null) {
                conn.close();
                conn = null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    // 1. 문의 등록 (기본 상태: 1-접수)
    @Override
    public int insertInquiry(InquiryDTO inquiry) throws SQLException {
        int result = 0;
        
        try {
            conn = ds.getConnection();
            
            String sql = " INSERT INTO tbl_inquiry (inquiry_number, fk_member_id, inquiry_type, title, " +
                         " inquiry_content, reply_status) " +
                         " VALUES (SEQ_TBL_INQUIRY_INQUIRY_NUMBER.NEXTVAL, ?, ?, ?, ?, 1) ";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, inquiry.getMemberid());
            pstmt.setString(2, inquiry.getInquiryType());
            pstmt.setString(3, inquiry.getTitle());
            pstmt.setString(4, inquiry.getInquiryContent());
            
            result = pstmt.executeUpdate();
            
        } finally {
            close();
        }
        
        return result;
    }
    
    // 2. 문의 목록 조회 (전체)
    @Override
    public List<InquiryDTO> selectAllInquiries() throws SQLException {
        List<InquiryDTO> inquiryList = new ArrayList<>();
        
        try {
            conn = ds.getConnection();
            
            String sql = " SELECT inquiry_number, fk_member_id, inquiry_type, title " 
                       + "      , to_char(registerday, 'yyyy-mm-dd') AS registerday "
                       + "      , inquiry_content, reply_content"
                       + "      , to_char(reply_registerday, 'yyyy-mm-dd') AS reply_registerday"
                       + "      , reply_status "
                       + " FROM tbl_inquiry "
                       + " ORDER BY inquiry_number DESC ";
            
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                InquiryDTO inquiry = new InquiryDTO();
                inquiry.setInquiryNumber(rs.getInt("inquiry_number"));
                inquiry.setMemberid(rs.getString("fk_member_id"));
                inquiry.setInquiryType(rs.getString("inquiry_type"));
                inquiry.setTitle(rs.getString("title"));
                
                inquiry.setRegisterday(rs.getString("registerday"));
                
                inquiry.setInquiryContent(rs.getString("inquiry_content"));
                inquiry.setReplyContent(rs.getString("reply_content"));
                
                inquiry.setReplyRegisterday(rs.getString("reply_registerday"));
                
                inquiry.setReplyStatus(rs.getInt("reply_status"));
                
                inquiryList.add(inquiry);
            }
            
        } finally {
            close();
        }
        
        return inquiryList;
    }
    
    
    // 3. 특정 회원의 문의 목록 조회
    @Override
    public List<InquiryDTO> selectInquiriesByMember(String memberID) throws SQLException {
        List<InquiryDTO> inquiryList = new ArrayList<>();
        
        try {
            conn = ds.getConnection();
            
            String sql = " SELECT inquiry_number, fk_member_id, inquiry_type, title "
            		       + "      , to_char(registerday, 'yyyy-mm-dd') AS registerday "
                       + "      , inquiry_content, reply_content"
                       + "      , to_char(reply_registerday, 'yyyy-mm-dd') AS reply_registerday "
                       + "      , REPLY_STATUS "
                       + " FROM tbl_inquiry "
                       + " WHERE fk_member_id = ? "
                       + " ORDER BY inquiry_number DESC ";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, memberID);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                InquiryDTO inquiry = new InquiryDTO();
                inquiry.setInquiryNumber(rs.getInt("inquiry_number"));
                inquiry.setMemberid(rs.getString("fk_member_id"));
                inquiry.setInquiryType(rs.getString("inquiry_type"));
                inquiry.setTitle(rs.getString("title"));
                
                inquiry.setRegisterday(rs.getString("registerday"));
                
                inquiry.setInquiryContent(rs.getString("inquiry_content"));
                inquiry.setReplyContent(rs.getString("reply_content"));
                
                inquiry.setReplyRegisterday(rs.getString("reply_registerday"));
                
                inquiry.setReplyStatus(rs.getInt("reply_status"));
                
                inquiryList.add(inquiry);
            }
            
        } finally {
            close();
        }
        
        return inquiryList;
    }
    
    // 4. 문의 상세 조회
    @Override
    public InquiryDTO selectInquiryDetail(int inquiryNumber) throws SQLException {
        InquiryDTO inquiry = null;
        
        try {
            conn = ds.getConnection();
            
            String sql = " SELECT inquiry_number, fk_member_id, inquiry_type, title "
                       + "       , to_char(registerday, 'yyyy-mm-dd') AS registerday "
                       + "       , inquiry_content, reply_content "
                       + "       , to_char(reply_registerday, 'yyyy-mm-dd') AS reply_registerday "
                       + "       , reply_status "
                       + " FROM tbl_inquiry " 
                       + " WHERE inquiry_number = ? ";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, inquiryNumber);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                inquiry = new InquiryDTO();
                inquiry.setInquiryNumber(rs.getInt("INQUIRY_NUMBER"));
                inquiry.setMemberid(rs.getString("FK_MEMBER_ID"));
                inquiry.setInquiryType(rs.getString("INQUIRY_TYPE"));
                inquiry.setTitle(rs.getString("TITLE"));
                inquiry.setRegisterday(rs.getString("REGISTERDAY"));
                
                inquiry.setInquiryContent(rs.getString("INQUIRY_CONTENT"));
                inquiry.setReplyContent(rs.getString("REPLY_CONTENT"));
                
                inquiry.setReplyRegisterday(rs.getString("REPLY_REGISTERDAY"));
              
                inquiry.setReplyStatus(rs.getInt("REPLY_STATUS"));
            }
            
        } finally {
            close();
        }
        
        return inquiry;
    }
    
    // 5. 문의 수정 (사용자)
    @Override
    public int updateInquiry(InquiryDTO inquiry) throws SQLException {
        int result = 0;
        
        try {
            conn = ds.getConnection();
            
            String sql = " UPDATE TBL_INQUIRY " +
                        " SET INQUIRY_TYPE = ?, TITLE = ?, INQUIRY_CONTENT = ? " +
                        " WHERE INQUIRY_NUMBER = ? AND FK_MEMBER_ID = ? ";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, inquiry.getInquiryType());
            pstmt.setString(2, inquiry.getTitle());
            pstmt.setString(3, inquiry.getInquiryContent());
            pstmt.setInt(4, inquiry.getInquiryNumber());
            pstmt.setString(5, inquiry.getMemberid());
            
            result = pstmt.executeUpdate();
            
        } finally {
            close();
        }
        
        return result;
    }
    
    // 6. 문의 삭제
    @Override
    public int deleteInquiry(int inquiryNumber) throws SQLException {
        int result = 0;
        
        try {
            conn = ds.getConnection();
            
            String sql = " DELETE FROM TBL_INQUIRY WHERE INQUIRY_NUMBER = ? ";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, inquiryNumber);
            
            result = pstmt.executeUpdate();
            
        } finally {
            close();
        }
        
        return result;
    }
    
    // 7. 관리자 답변 등록/수정 (답변 등록 시 자동으로 상태를 2-답변완료로 변경)
    @Override
    public int updateReply(Map<String, String> paraMap) throws SQLException {
        int result = 0;
        
        try {
            conn = ds.getConnection();
            
            String sql = " UPDATE TBL_INQUIRY "
                       + " SET REPLY_CONTENT = ?, REPLY_REGISTERDAY = SYSDATE, REPLY_STATUS = 2 "
                       + " WHERE INQUIRY_NUMBER = ? ";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, paraMap.get("replyContent"));
            pstmt.setInt(2, Integer.parseInt(paraMap.get("inquiryNumber")));
            
            result = pstmt.executeUpdate();
            
        } finally {
            close();
        }
        
        return result;
    }// end of public int updateReply(Map<String, String> paraMap) throws SQLException -------
    
    
    // 8. 답변 상태 변경 (관리자용)
    @Override
    public int updateReplyStatus(int inquiryNumber, int replyStatus) throws SQLException {
        int result = 0;
        
        try {
            conn = ds.getConnection();
            
            String sql = " UPDATE TBL_INQUIRY SET REPLY_STATUS = ? WHERE INQUIRY_NUMBER = ? ";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, replyStatus);
            pstmt.setInt(2, inquiryNumber);
            
            result = pstmt.executeUpdate();
            
        } finally {
            close();
        }
        
        return result;
    }

    
    // 문의 총 개수
	@Override
	public int getTotalCount(Map<String, String> paraMap) throws SQLException {
		
		int totalCount = 0;

		String isAdmin = paraMap.get("isAdmin");      // "true" or "false"
	    String memberid = paraMap.get("memberid");    // 일반회원일 때만 사용
	    String inquiryType = paraMap.get("inquiryType"); // "" 또는 null 이면 전체

	    try {
	        conn = ds.getConnection();

	        String sql = " SELECT count(*) "
	        		       + " FROM tbl_inquiry "
	        		       + " WHERE 1=1 ";
	        
	        // 일반회원이면 내 문의만
	        if (!"true".equals(isAdmin)) {
	            sql += " AND fk_member_id = ? ";
	        }

	        // 유형 필터
	        if (inquiryType != null && !inquiryType.trim().isEmpty()) {
	        	sql += " AND INQUIRY_TYPE = ? ";
	        }
	        
	        pstmt = conn.prepareStatement(sql);
	        
	        if (!"true".equals(isAdmin)) {
	        		pstmt.setString(1, memberid);
	        		
	        		if(inquiryType != null && !inquiryType.isEmpty()) {
	        			pstmt.setString(2, inquiryType);
	        		}
	        		
	        }
	        else {
	        	
		        	if(inquiryType != null && !inquiryType.isEmpty()) {
	        			pstmt.setString(2, inquiryType);
	        		}
	        	
	        }
	        
	        rs = pstmt.executeQuery();
	        
	        rs.next();
	        totalCount = rs.getInt(1);
	        
		} finally {
			close();
		}		
		
		return totalCount;
	
	}// end of public int getTotalCount(Map<String, String> paraMap) throws SQLException -------

	
	// 문의 페이징 리스트
	@Override
	public List<InquiryDTO> selectInquiriesPaging(Map<String, String> paraMap) throws SQLException {
		
		List<InquiryDTO> list = new ArrayList<>();

	    String isAdmin = paraMap.get("isAdmin"); // 관리자 여부     
	    String memberid = paraMap.get("memberid");    
	    String inquiryType = paraMap.get("inquiryType");

	    int startRno = Integer.parseInt(paraMap.get("startRno"));
	    int endRno = Integer.parseInt(paraMap.get("endRno"));

	    try {
	        conn = ds.getConnection();

	        String sql = " SELECT inquiry_number, fk_member_id, inquiry_type, title "
	        		       + "      , to_char(registerday, 'yyyy-mm-dd') AS registerday "
	        		       + "      , inquiry_content, reply_content "
	        		       + "      , to_char(reply_registerday, 'yyyy-mm-dd') AS reply_registerday, reply_status "
	        		       + " FROM ( "
	        		       + " SELECT ROW_NUMBER() OVER(ORDER BY Inquiry_number DESC) AS rno "
	        		       + "      , inquiry_number, fk_member_id, inquiry_type, title, registerday "
	        		       + "      , inquiry_content, reply_content, reply_registerday, reply_status "
	        		       + " FROM tbl_inquiry "
	        		       + " WHERE 1=1 ";
	        
	        if (!"true".equals(isAdmin)) {
	        		sql += " AND fk_member_id = ? ";
	        }
	        if (inquiryType != null && !inquiryType.isEmpty()) {
	        		sql += " AND inquiry_type = ? ";
	        }

	        sql += " ) "
	        		 + " WHERE rno BETWEEN ? AND ? ";
	         
	        pstmt = conn.prepareStatement(sql);

	        if (!"true".equals(isAdmin)) {
	        	
	            pstmt.setString(1, memberid);
	            
	            if (inquiryType != null && !inquiryType.isEmpty()) {
		            pstmt.setString(2, inquiryType);
		        }
	            
	            pstmt.setInt(3, startRno);
		        pstmt.setInt(4, endRno);
	            
	        }
	        else {
	        	
	        	 	if (inquiryType != null && !inquiryType.isEmpty()) {
		            pstmt.setString(1, inquiryType);
		        }
	            
	            pstmt.setInt(2, startRno);
		        pstmt.setInt(3, endRno);
	        	
	        }

	       
	        rs = pstmt.executeQuery();

	        while (rs.next()) {
	            InquiryDTO dto = new InquiryDTO();

	            dto.setInquiryNumber(rs.getInt("inquiry_number"));
	            dto.setMemberid(rs.getString("fk_member_id"));
	            dto.setInquiryType(rs.getString("inquiry_type"));
	            dto.setTitle(rs.getString("title"));
	            dto.setRegisterday(rs.getString("registerday"));	            
	            dto.setInquiryContent(rs.getString("inquiry_content"));
	            dto.setReplyContent(rs.getString("reply_content"));
	            dto.setReplyRegisterday(rs.getString("reply_registerday"));	  
	            dto.setReplyStatus(rs.getInt("reply_status"));

	            list.add(dto);
	        }

	    } finally {
	        close();
	    }
		
		return list;
	
	}// end of public List<InquiryDTO> selectInquiriesPaging(Map<String, String> paraMap) throws SQLException -------






}