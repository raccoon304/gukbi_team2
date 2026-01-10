package admin.model;

import java.util.List;
import java.util.Map;

import admin.domain.AdminPageDTO;
import member.domain.MemberDTO;

public interface AdminDAO {

	// 페이징 처리를 위한 검색이 있는 또는 검색이 없는 회원에 대한 총페이지수 알아오기 //
	int getTotalPage(Map<String, String> paraMap) throws Exception;

	// 페이징 처리를 한 모든 회원 또는 검색한 회원 목록 보여주기
	List<MemberDTO> selectMemberPaging(Map<String, String> paraMap) throws Exception;

	/* >>> 뷰단(memberList.jsp)에서 "페이징 처리시 보여주는 순번 공식" 에서 사용하기 위해 
    검색이 있는 또는 검색이 없는 회원의 총개수 알아오기 시작 <<< */
	int getTotalMemberCount(Map<String, String> paraMap) throws Exception;
	
	// 쿠폰 관리 - 쿠폰을 발급해 줄 회원 리스트	
	List<MemberDTO> selectMemberPagingForCoupon(Map<String, String> paraMap) throws Exception;
		
	// 쿠폰 관리 - 쿠폰을 발급 받을 수 있는 총 회원 수 (정렬기능포함)
	int getTotalCountMemberForCoupon(Map<String, String> paraMap) throws Exception;

	// 결제금액, 주문건수 구하기
	Map<String, Map<String, Long>> orderCountAndPaymentAmount (List<String> memberIds) throws Exception;
	
	// 회원 1명 상세 정보
	Map<String, String> memberDetail(String memberId) throws Exception;
	
	// 회원 1명 주문 정보
	Map<String, Long> orderStatOne(String memberId) throws Exception;

	// 오늘 가입한 회원 리스트
	List<MemberDTO> todayNewMembers() throws Exception;

	// 품절 임박 상품 리스트
	List<AdminPageDTO> lowStockProducts() throws Exception;

	// 최근 주문 5건
	List<AdminPageDTO> currentOrders() throws Exception;

	// 오늘 주문 수
	int todayOrderCount() throws Exception;

	// 오늘 매출액
	long todaySales() throws Exception;
	
	
}
