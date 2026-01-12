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
	
}
