package inquiry.model;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import inquiry.domain.InquiryDTO;

public interface InquiryDAO {
    
    // 문의 등록
    int insertInquiry(InquiryDTO inquiry) throws SQLException;
    
    // 문의 목록 조회 (전체)
    // List<InquiryDTO> selectAllInquiries() throws SQLException;
    
    // 특정 회원의 문의 목록 조회
    // List<InquiryDTO> selectInquiriesByMember(String memberID) throws SQLException;
    
    // 문의 상세 조회
    InquiryDTO selectInquiryDetail(int inquiryNumber) throws SQLException;
    
    // 문의 수정 (사용자)
    int updateInquiry(InquiryDTO inquiry) throws SQLException;
    
    // 문의 삭제
    int softDeleteInquiry(int inquiryNumber, String deletedBy, boolean isAdmin, String ownerMemberId) throws SQLException;
    
    // 관리자 답변 등록/수정
    int updateReply(Map<String, String> paraMap) throws SQLException;
    
    // 답변 상태 변경
    int updateReplyStatus(int inquiryNumber, int replyStatus) throws SQLException;
    
    // 문의 총 개수
    int getTotalCount(Map<String, String> paraMap) throws SQLException;

    // 문의 페이징 리스트
    List<InquiryDTO> selectInquiriesPaging(Map<String, String> paraMap) throws SQLException;

    
    
}