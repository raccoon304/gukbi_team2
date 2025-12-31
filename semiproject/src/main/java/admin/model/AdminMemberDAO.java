package admin.model;

import java.util.Map;

public interface AdminMemberDAO {

	// 페이징 처리를 위한 검색이 있는 또는 검색이 없는 회원에 대한 총페이지수 알아오기 //
	int getTotalPage(Map<String, String> paraMap) throws Exception;

}
