package coupon.model;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import coupon.domain.CouponDTO;
import coupon.domain.CouponIssueDTO;

public interface CouponDAO {

	// 쿠폰 생성 메서드
	int CouponCreate(CouponDTO cpDto) throws SQLException;

	// 쿠폰 리스트를 보여주는 메서드
	List<CouponDTO> selectCouponList() throws SQLException;
	public List<CouponDTO> selectCouponList(String userid) throws SQLException;
	
	// 쿠폰 총 페이지수
	int getTotalPageCoupon(Map<String,String> paraMap) throws SQLException;
	
	// 페이지별 쿠폰 리스트 가져오기
	List<CouponDTO> selectCouponPaging(Map<String,String> paraMap) throws SQLException;

	// 쿠폰을 발급 받은 회원 목록 조회
	List<CouponIssueDTO> selectIssuedMembersByCouponCategoryNo(int couponCategoryNo) throws SQLException;
	
	// 회원에게 쿠폰을 전송하는 메서드
	int issueCouponToMembers(int couponCategoryNo, List<String> memberIdList, String expireDateStr) throws SQLException;
	
	// 전체 회원 조회 메서드
	List<String> selectMemberIdsForIssue(Map<String,String> paraMap) throws SQLException;

	// 쿠폰 발급 받은 회원 총 페이지수
	int getTotalPageIssuedMembers(int couponCategoryNo, int sizePerPage, String filter) throws SQLException;

	// 페이지별 쿠폰을 발급 받은 회원 리스트 가져오기
	List<CouponIssueDTO> selectIssuedMembersPaging(Map<String, String> paraMap) throws SQLException;
	
	// 미사용 발급건수(만료전)
	int getUnusedIssuedCount(int couponCategoryNo) throws SQLException;
	
	// 쿠폰 사용 안함 처리
	int disableCoupon(int couponCategoryNo) throws SQLException;
	
	// 쿠폰 사용안함 → 사용함 처리
	int enableCoupon(int couponCategoryNo) throws SQLException;
	
	// 쿠폰의 총개수 알아오기
	int getTotalCouponCount(Map<String, String> paraMap) throws SQLException;
	
	public static class IssueResult {
	    public int issuedCount;
	    public int skippedCount;   // 미사용+미만료 있어서 스킵
	    public int invalidCount;   // 빈값 등 걸러진 경우
	}


	
	
}
