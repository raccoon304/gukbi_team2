package inquiry.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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
    
    
    
    // 문의 등록
    @Override
    public int insertInquiry(InquiryDTO idto) throws SQLException {
        int result = 0;
        
        try {
            conn = ds.getConnection();
            
            String sql = " INSERT INTO tbl_inquiry (inquiry_number, fk_member_id, inquiry_type, title "
                       + "           , inquiry_content, is_secret) "
                       + " VALUES (seq_tbl_inquiry_inquiry_number.nextval, ?, ?, ?, ?, ?) ";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, idto.getMemberid());
            pstmt.setString(2, idto.getInquiryType());
            pstmt.setString(3, idto.getTitle());
            pstmt.setString(4, idto.getInquiryContent());
            pstmt.setInt(5, idto.getIsSecret());
            
            result = pstmt.executeUpdate();
            
        } finally {
            close();
        }
        
        return result;
    }

/*    
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
                       + "      , reply_status, is_secret, deleted_yn, deleted_at, deleted_by "
                       + " FROM tbl_inquiry "
                       + " WHERE deleted_yn = 0 "
                       + " ORDER BY inquiry_number DESC ";
            
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                InquiryDTO idto = new InquiryDTO();
                idto.setInquiryNumber(rs.getInt("inquiry_number"));
                idto.setMemberid(rs.getString("fk_member_id"));
                idto.setInquiryType(rs.getString("inquiry_type"));
                idto.setTitle(rs.getString("title"));
                
                idto.setRegisterday(rs.getString("registerday"));
                
                idto.setInquiryContent(rs.getString("inquiry_content"));
                idto.setReplyContent(rs.getString("reply_content"));
                
                idto.setReplyRegisterday(rs.getString("reply_registerday"));
                
                idto.setReplyStatus(rs.getInt("reply_status"));
                
                idto.setIsSecret(rs.getInt("is_secret"));
                
                inquiryList.add(idto);
            }
            
        } finally {
            close();
        }
        
        return inquiryList;
    }
*/    
 /*   
    // 3. 특정 회원의 문의 목록 조회
    @Override
    public List<InquiryDTO> selectInquiriesByMember(String memberid) throws SQLException {
        List<InquiryDTO> inquiryList = new ArrayList<>();
        
        try {
            conn = ds.getConnection();
            
            String sql = " SELECT inquiry_number, fk_member_id, inquiry_type, title "
            		       + "      , to_char(registerday, 'yyyy-mm-dd') AS registerday "
                       + "      , inquiry_content, reply_content"
                       + "      , to_char(reply_registerday, 'yyyy-mm-dd') AS reply_registerday "
                       + "      , reply_status, is_secret "
                       + " FROM tbl_inquiry "
                       + " WHERE deleted_yn = 0 "
                       + " AND fk_member_id = ? "
                       + " ORDER BY inquiry_number DESC ";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, memberid);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                InquiryDTO idto = new InquiryDTO();
                idto.setInquiryNumber(rs.getInt("inquiry_number"));
                idto.setMemberid(rs.getString("fk_member_id"));
                idto.setInquiryType(rs.getString("inquiry_type"));
                idto.setTitle(rs.getString("title"));
                
                idto.setRegisterday(rs.getString("registerday"));
                
                idto.setInquiryContent(rs.getString("inquiry_content"));
                idto.setReplyContent(rs.getString("reply_content"));
                
                idto.setReplyRegisterday(rs.getString("reply_registerday"));
                
                idto.setReplyStatus(rs.getInt("reply_status"));
                idto.setIsSecret(rs.getInt("is_secret"));
                
                inquiryList.add(idto);
            }
            
        } finally {
            close();
        }
        
        return inquiryList;
    }
*/
    
    // 4. 문의 상세 조회
    @Override
    public InquiryDTO selectInquiryDetail(int inquiryNumber) throws SQLException {
        InquiryDTO idto = null;
        
        try {
            conn = ds.getConnection();
            
            String sql = " SELECT inquiry_number, fk_member_id, inquiry_type, title "
                       + "       , to_char(registerday, 'yyyy-mm-dd') AS registerday "
                       + "       , inquiry_content, reply_content "
                       + "       , to_char(reply_registerday, 'yyyy-mm-dd') AS reply_registerday "
                       + "       , reply_status, is_secret "
                       + " FROM tbl_inquiry " 
                       + " WHERE inquiry_number = ? "
                       + " AND deleted_yn = 0 ";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, inquiryNumber);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
            		idto = new InquiryDTO();
            		idto.setInquiryNumber(rs.getInt("inquiry_number"));
            		idto.setMemberid(rs.getString("fk_member_id"));
            		idto.setInquiryType(rs.getString("inquiry_type"));
            		idto.setTitle(rs.getString("title"));
            		idto.setRegisterday(rs.getString("registerday"));
                
            		idto.setInquiryContent(rs.getString("inquiry_content"));
            		idto.setReplyContent(rs.getString("reply_content"));
                
            		idto.setReplyRegisterday(rs.getString("reply_registerday"));
              
            		idto.setReplyStatus(rs.getInt("reply_status"));
            		idto.setIsSecret(rs.getInt("is_secret"));
            }
            
        } finally {
            close();
        }
        
        return idto;
    }
    
    // 5. 문의 수정 (사용자)
    @Override
    public int updateInquiry(InquiryDTO idto) throws SQLException {
        int result = 0;
        
        try {
            conn = ds.getConnection();
            
            String sql = " UPDATE tbl_inquiry "
                       + " SET inquiry_type = ?, title = ?, inquiry_content = ?, is_secret = ? "
                       + " WHERE inquiry_number = ? "
                       + " AND fk_member_id = ? "
                       + " AND deleted_yn = 0 ";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, idto.getInquiryType());
            pstmt.setString(2, idto.getTitle());
            pstmt.setString(3, idto.getInquiryContent());
            pstmt.setInt(4, idto.getIsSecret());
            pstmt.setInt(5, idto.getInquiryNumber());
            pstmt.setString(6, idto.getMemberid());
            
            result = pstmt.executeUpdate();
            
        } finally {
            close();
        }
        
        return result;
    }
    
    // 문의 삭제
    @Override
    public int softDeleteInquiry(int inquiryNumber, String deletedBy, boolean isAdmin, String ownerMemberId) throws SQLException {
        int result = 0;
        
        try {
        		conn = ds.getConnection();
        		String sql = "";
        		
            if (isAdmin) {// 관리자일때
            	
                sql = " UPDATE tbl_inquiry "
                    + " SET deleted_yn = 1, deleted_at = sysdate, deleted_by = ? "
                    + " WHERE inquiry_number = ? "
                    + " AND deleted_yn = 0 ";
                
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, deletedBy);
                pstmt.setInt(2, inquiryNumber);
                
            } else {// 작성자일때
            	
                sql = " UPDATE tbl_inquiry "
                    + " SET deleted_yn = 1, deleted_at = sysdate, deleted_by = ? "
                    + " WHERE inquiry_number = ? "
                    + "   AND fk_member_id = ? "
                    + "   AND deleted_yn = 0 ";
                
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, deletedBy);
                pstmt.setInt(2, inquiryNumber);
                pstmt.setString(3, ownerMemberId);
            }

            result = pstmt.executeUpdate();

            
        } finally {
            close();
        }
        
        return result;
    }
    
    // 7. 관리자 답변 등록/수정 (답변 등록시 상태를 답변완료로 변경)
    @Override
    public int updateReply(Map<String, String> paraMap) throws SQLException {
        int result = 0;
        
        try {
            conn = ds.getConnection();
            
            String sql = " UPDATE tbl_inquiry "
                       + " SET reply_content = ?, reply_registerday = sysdate, reply_status = 2 "
                       + " WHERE inquiry_number = ? "
                       + " AND deleted_yn = 0 ";
            
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
            
            String sql = " UPDATE tbl_inquiry SET reply_status = ? "
            		       + " WHERE inquiry_number = ? "
            		       + " AND deleted_yn = 0 ";
            
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
	    String inquiryType = paraMap.get("inquiryType"); // "" 또는 null 이면 전체
	    String onlyUnanswered = paraMap.get("onlyUnanswered");
	    
	    boolean hasType = (inquiryType != null && !inquiryType.trim().isEmpty()); // 문의 유형 필터 있,없
        boolean unanswered = ("true".equals(isAdmin) && "Y".equals(onlyUnanswered)); // 관리자일때 미답변 적용

        try {
            conn = ds.getConnection();

            String sql;

            if (!hasType && !unanswered) {// 필터없, 미답변 적용없
                sql = " SELECT COUNT(*) "
                    + " FROM tbl_inquiry "
                    + " WHERE deleted_yn = 0 ";
                    
                pstmt = conn.prepareStatement(sql);
            }
            else if (hasType && !unanswered) {// 필터있, 미답변 적용없
                sql = " SELECT COUNT(*) "
                    + " FROM tbl_inquiry "
                    + " WHERE deleted_yn = 0 "
                    + " AND inquiry_type = ? ";
                    
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, inquiryType.trim());
            }
            else if (!hasType && unanswered) {// 필터없, 미답변 적용있
                sql = " SELECT COUNT(*) "
                    + " FROM tbl_inquiry "
                    + " WHERE deleted_yn = 0 "
                    + " AND reply_status = 1 ";
                      
                pstmt = conn.prepareStatement(sql);
            }
            else { // hasType && unanswered -> 필터있, 미답변 적용있
                sql = " SELECT COUNT(*) "
                    + " FROM tbl_inquiry "
                    + " WHERE deleted_yn = 0 "
                    + "   AND inquiry_type = ? "
                    + "   AND reply_status = 1 ";
                      
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, inquiryType.trim());
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

		String viewerId = paraMap.get("memberid");                // 로그인한 사용자 id
        String isAdmin = paraMap.get("isAdmin");                  // 관리자 여부 "true","false"
        String inquiryType = paraMap.get("inquiryType");          // "" 이면 필터 적용 없이 전체
        String onlyUnanswered = paraMap.get("onlyUnanswered");    // "Y" 또는 "" (관리자 미답변 적용 여부)

        int startRno = Integer.parseInt(paraMap.get("startRno"));
        int endRno   = Integer.parseInt(paraMap.get("endRno"));

        boolean hasType = (inquiryType != null && !inquiryType.trim().isEmpty()); // 문의 유형 필터 있,없
        boolean unanswered = ("true".equals(isAdmin) && "Y".equals(onlyUnanswered)); // 관리자일때 미답변 적용

        try {
            conn = ds.getConnection();

            String base = " SELECT inquiry_number, fk_member_id, inquiry_type, title_display, is_secret, "
                    	    + "        to_char(registerday,'yyyy-mm-dd') AS registerday, reply_status "
	                    + " FROM ( "
	                    + "   SELECT ROW_NUMBER() OVER(ORDER BY inquiry_number DESC) AS rno, "
	                    + "          inquiry_number, fk_member_id, inquiry_type, title, is_secret, registerday, reply_status, "
	                    + "          CASE "
	                    + "            WHEN is_secret = 1 "
	                    + "             AND NVL(?, '###') != fk_member_id "
	                    + "             AND ? != 'true' "
	                    + "            THEN '비밀글입니다' "
	                    + "            ELSE title "
	                    + "          END AS title_display "
	                    + "   FROM tbl_inquiry "
	                    + "   WHERE deleted_yn = 0 ";
                  

            String tail = " ) "
                        + " WHERE rno BETWEEN ? AND ? ";
                  

            String sql = "";

            if (!hasType && !unanswered) {// 필터없, 미답변 적용없
                sql = base + tail;

                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, viewerId);
                pstmt.setString(2, isAdmin);
                pstmt.setInt(3, startRno);
                pstmt.setInt(4, endRno);
            }
            else if (hasType && !unanswered) {// 필터있, 미답변 적용없
                sql = base
                    + "   AND inquiry_type = ? "
                    + tail;

                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, viewerId);
                pstmt.setString(2, isAdmin);
                pstmt.setString(3, inquiryType.trim());
                pstmt.setInt(4, startRno);
                pstmt.setInt(5, endRno);
            }
            else if (!hasType && unanswered) {// 필터없, 미답변 적용있
                sql = base
                    + "   AND reply_status = 1 "
                    + tail;

                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, viewerId);
                pstmt.setString(2, isAdmin);
                pstmt.setInt(3, startRno);
                pstmt.setInt(4, endRno);
            }
            else { // hasType && unanswered -> // 필터있, 미답변 적용있
                sql = base
                    + "   AND inquiry_type = ? "
                    + "   AND reply_status = 1 "
                    + tail;

                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, viewerId);
                pstmt.setString(2, isAdmin);
                pstmt.setString(3, inquiryType.trim());
                pstmt.setInt(4, startRno);
                pstmt.setInt(5, endRno);
            }

            rs = pstmt.executeQuery();

            while (rs.next()) {
                InquiryDTO dto = new InquiryDTO();

                dto.setInquiryNumber(rs.getInt("inquiry_number"));
                dto.setMemberid(rs.getString("fk_member_id"));
                dto.setInquiryType(rs.getString("inquiry_type"));

                // 마스킹된 제목
                dto.setTitle(rs.getString("title_display"));

                dto.setRegisterday(rs.getString("registerday"));
                dto.setReplyStatus(rs.getInt("reply_status"));

                dto.setIsSecret(rs.getInt("is_secret"));

                list.add(dto);
            }

	    } finally {
	        close();
	    }
		
		return list;
	
	}// end of public List<InquiryDTO> selectInquiriesPaging(Map<String, String> paraMap) throws SQLException -------






}