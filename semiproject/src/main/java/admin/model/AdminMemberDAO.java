package admin.model;

import java.util.List;
import java.util.Map;

import member.domain.MemberDTO;

public interface AdminMemberDAO {

	// 페이징 처리를 위한 검색이 있는 또는 검색이 없는 회원에 대한 총페이지수 알아오기 //
	int getTotalPage(Map<String, String> paraMap) throws Exception;

	// 페이징 처리를 한 모든 회원 또는 검색한 회원 목록 보여주기
	List<MemberDTO> selectMemberPaging(Map<String, String> paraMap) throws Exception;

	/* >>> 뷰단(memberList.jsp)에서 "페이징 처리시 보여주는 순번 공식" 에서 사용하기 위해 
    검색이 있는 또는 검색이 없는 회원의 총개수 알아오기 시작 <<< */
	int getTotalMemberCount(Map<String, String> paraMap) throws Exception;

}
