package review.model;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import review.domain.ReviewDTO;

public interface ReviewDAO {

	// 리뷰 총 개수 (선택 상품 기준)
	int getTotalReviewCount(Map<String, String> paraMap) throws SQLException;

	// 총 페이지 수
    int getTotalPage(Map<String, String> paraMap) throws SQLException;

    // 통계(총개수/평균/별점분포)
    Map<String, Object> getReviewStat(Map<String, String> paraMap) throws SQLException;

    // 리뷰 리스트(페이징처리)
    List<ReviewDTO> selectReviewPaging(Map<String, String> paraMap) throws SQLException;
    
    // 내 구매(PAID)인지, 이미 리뷰 있는지 확인
    boolean canWriteReview(String memberId, int orderDetailId) throws Exception; // 내 주문상세(PAID)인지
    
    // 리뷰 작성
    int insertReview(int optionId, int orderDetailId, String content, double rating) throws Exception;
    
    int insertReviewWithImages(String memberId, int optionId, int orderDetailId, String title, String content, double rating,
                               List<Map<String, Object>> images) throws Exception;

    
    // 리뷰에 이미지 insert
    int insertReviewImage(int reviewNumber, String imagePath, int sortNo) throws Exception;
    
    // 리뷰 작성 가능한 주문 상세 목록
    List<Map<String, Object>> getWritableOrderDetailList(String memberId, String productCode) throws SQLException;
    
    // ORDER_DETAIL_ID 로 OPTION_ID 조회
    int getOptionIdByOrderDetailId(String memberId, int orderDetailId) throws SQLException;
    
    // 리뷰 상세 1건 조회
    ReviewDTO selectReviewDetail(int reviewNumber) throws SQLException;
    
    // 리뷰 이미지 전체 조회
    List<String> selectReviewImageList(int reviewNumber) throws SQLException;

    // 리뷰 삭제(소프트삭제)
	int deleteReview(String memberid, int reviewNumber) throws SQLException;
		
	// 수정용: 내 리뷰 1건 가져오기
    Map<String, String> getReviewForEdit(int reviewNumber, String memberId) throws SQLException;

    // 리뷰 수정
    boolean updateReview(int reviewNumber, String memberId, String title, String content, double rating) throws SQLException;

    // 리뷰 이미지 조회(리뷰 수정용)
    List<Map<String, Object>> selectReviewImageInfoList(int reviewNumber) throws SQLException;

    // 리뷰 수정+이미지
    boolean updateReviewWithImages(int reviewNumber, String memberId,
                                   String title, String content, double rating,
                                   List<Integer> deleteImageIds,
                                   List<Map<String, Object>> newImages) throws Exception;
	
}
