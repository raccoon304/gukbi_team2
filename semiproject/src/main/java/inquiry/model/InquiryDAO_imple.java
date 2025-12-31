package inquiry.model;

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

public class InquiryDAO_imple implements InquiryDAO {
    
    private DataSource ds;
    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;
    
    // 생성자에서 DataSource 초기화
    public InquiryDAO_imple() {
        try {
            Context initContext = new InitialContext();
            Context envContext = (Context) initContext.lookup("java:/comp/env");
            ds = (DataSource) envContext.lookup("jdbc/myoracle");
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
            
            String sql = " INSERT INTO TBL_INQUIRY (INQUIRY_NUMBER, FK_MEMBER_ID, INQUIRY_TYPE, TITLE, " +
                        " INQUIRY_CONTENT, REPLY_STATUS) " +
                        " VALUES (SEQ_TBL_INQUIRY_INQUIRY_NUMBER.NEXTVAL, ?, ?, ?, ?, 1) ";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, inquiry.getMemberID());
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
            
            String sql = " SELECT INQUIRY_NUMBER, FK_MEMBER_ID, INQUIRY_TYPE, TITLE, " +
                        " REGISTERDAY, INQUIRY_CONTENT, REPLY_CONTENT, REPLY_REGISTERDAY, REPLY_STATUS " +
                        " FROM TBL_INQUIRY " +
                        " ORDER BY INQUIRY_NUMBER DESC ";
            
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                InquiryDTO inquiry = new InquiryDTO();
                inquiry.setInquiryNumber(rs.getInt("INQUIRY_NUMBER"));
                inquiry.setMemberID(rs.getString("FK_MEMBER_ID"));
                inquiry.setInquiryType(rs.getString("INQUIRY_TYPE"));
                inquiry.setTitle(rs.getString("TITLE"));
                
                Timestamp registerday = rs.getTimestamp("REGISTERDAY");
                if (registerday != null) {
                    inquiry.setRegisterday(registerday.toLocalDateTime());
                }
                
                inquiry.setInquiryContent(rs.getString("INQUIRY_CONTENT"));
                inquiry.setReplyContent(rs.getString("REPLY_CONTENT"));
                
                Timestamp replyRegisterday = rs.getTimestamp("REPLY_REGISTERDAY");
                if (replyRegisterday != null) {
                    inquiry.setReplyRegisterday(replyRegisterday.toLocalDateTime());
                }
                
                inquiry.setReplyStatus(rs.getInt("REPLY_STATUS"));
                
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
            
            String sql = " SELECT INQUIRY_NUMBER, FK_MEMBER_ID, INQUIRY_TYPE, TITLE, " +
                        " REGISTERDAY, INQUIRY_CONTENT, REPLY_CONTENT, REPLY_REGISTERDAY, REPLY_STATUS " +
                        " FROM TBL_INQUIRY " +
                        " WHERE FK_MEMBER_ID = ? " +
                        " ORDER BY INQUIRY_NUMBER DESC ";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, memberID);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                InquiryDTO inquiry = new InquiryDTO();
                inquiry.setInquiryNumber(rs.getInt("INQUIRY_NUMBER"));
                inquiry.setMemberID(rs.getString("FK_MEMBER_ID"));
                inquiry.setInquiryType(rs.getString("INQUIRY_TYPE"));
                inquiry.setTitle(rs.getString("TITLE"));
                
                Timestamp registerday = rs.getTimestamp("REGISTERDAY");
                if (registerday != null) {
                    inquiry.setRegisterday(registerday.toLocalDateTime());
                }
                
                inquiry.setInquiryContent(rs.getString("INQUIRY_CONTENT"));
                inquiry.setReplyContent(rs.getString("REPLY_CONTENT"));
                
                Timestamp replyRegisterday = rs.getTimestamp("REPLY_REGISTERDAY");
                if (replyRegisterday != null) {
                    inquiry.setReplyRegisterday(replyRegisterday.toLocalDateTime());
                }
                
                inquiry.setReplyStatus(rs.getInt("REPLY_STATUS"));
                
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
            
            String sql = " SELECT INQUIRY_NUMBER, FK_MEMBER_ID, INQUIRY_TYPE, TITLE, " +
                        " REGISTERDAY, INQUIRY_CONTENT, REPLY_CONTENT, REPLY_REGISTERDAY, REPLY_STATUS " +
                        " FROM TBL_INQUIRY " +
                        " WHERE INQUIRY_NUMBER = ? ";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, inquiryNumber);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                inquiry = new InquiryDTO();
                inquiry.setInquiryNumber(rs.getInt("INQUIRY_NUMBER"));
                inquiry.setMemberID(rs.getString("FK_MEMBER_ID"));
                inquiry.setInquiryType(rs.getString("INQUIRY_TYPE"));
                inquiry.setTitle(rs.getString("TITLE"));
                
                Timestamp registerday = rs.getTimestamp("REGISTERDAY");
                if (registerday != null) {
                    inquiry.setRegisterday(registerday.toLocalDateTime());
                }
                
                inquiry.setInquiryContent(rs.getString("INQUIRY_CONTENT"));
                inquiry.setReplyContent(rs.getString("REPLY_CONTENT"));
                
                Timestamp replyRegisterday = rs.getTimestamp("REPLY_REGISTERDAY");
                if (replyRegisterday != null) {
                    inquiry.setReplyRegisterday(replyRegisterday.toLocalDateTime());
                }
                
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
            pstmt.setString(5, inquiry.getMemberID());
            
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
    public int updateReply(Map<String, Object> replyMap) throws SQLException {
        int result = 0;
        
        try {
            conn = ds.getConnection();
            
            String sql = " UPDATE TBL_INQUIRY " +
                        " SET REPLY_CONTENT = ?, REPLY_REGISTERDAY = SYSDATE, REPLY_STATUS = 2 " +
                        " WHERE INQUIRY_NUMBER = ? ";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, (String) replyMap.get("replyContent"));
            pstmt.setInt(2, (Integer) replyMap.get("inquiryNumber"));
            
            result = pstmt.executeUpdate();
            
        } finally {
            close();
        }
        
        return result;
    }
    
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
}