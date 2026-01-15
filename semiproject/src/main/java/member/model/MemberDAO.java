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

	// 성명 + 이메일 으로 아이디 찾기 
	String findMemberIdByNameAndEmail(String name, String email) throws SQLException;

	// 성명 + 휴대폰 으로 아이디 찾기
	String findMemberIdByNameAndMobile(String name, String mobile) throws SQLException;

	// Email을 통한 계정 존재 유무 확인 메서드
	boolean isUserExistsForPwdFindEmail(Map<String, String> paraMap) throws SQLException;

	// 인증 완료 이후 비밀번호 변경 메일 보내고 해당 값(난수값)으로 비밀번호 업데이트 
	int updatePasswordByUserid(String userid, String hashedPwd) throws SQLException;

	// 회원 탈퇴 메서드
	int updateMemberStatusWithdraw(String memberId) throws SQLException;

	// 휴면 계정 확인(마지막 로그인 시점에서 3개월이 지났는지)
	boolean isDormantTarget(String memberId) throws SQLException;

	// 휴면 전환 메서드
	int updateMemberIdle(String memberId) throws SQLException;

	//정상 로그인시 마지막 접속일 업데이트 
	int updateLastLoginYmd(String memberId) throws SQLException;

	//휴면 해제용 메서드 
	int unlockDormant(String memberId) throws SQLException;



}
