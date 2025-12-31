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



}
