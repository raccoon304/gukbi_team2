package member.model;

import java.sql.SQLException;
import java.util.Map;

import delivery.domain.DeliveryDTO;
import member.domain.MemberDTO;

public interface MemberDAO {

	// 회원가입
	int registerMember(MemberDTO mbrDto, DeliveryDTO devDto) throws SQLException;

	// ID 중복검사
	boolean idDuplicateCheck(String memberid) throws SQLException;

	// email 중복검사
	boolean emailDuplicateCheck(String email) throws SQLException;

	// 휴대폰번호 중복검사
	boolean mobileDuplicateCheck(String mobile) throws SQLException;

	//로그인
	MemberDTO login(Map<String, String> paraMap) throws SQLException;

	// 회원 정보 수정 
	int updateMember(Map<String, String> paraMap) throws SQLException;



}
