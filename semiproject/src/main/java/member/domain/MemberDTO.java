package member.domain;

public class MemberDTO { 
	private String memberid;		// 회원아이디
	private String name;			// 회원명
	private String password;		// 비밀번호 (SHA-256 암호화 대상)	
	private String mobile;			// 휴대폰 번호(AES-256 암호화/복호화 대상) 
	private String email;			// 이메일 (AES-256 암호화/복호화 대상) 
	private String birthday;		// 생년월일  
	private int gender;				// 성별
	private String registerday;		// 가입일자 	

   	private int status;             // 회원탈퇴유무   1: 사용가능(가입중) / 0:사용불능(탈퇴) 
   	private int idle;               // 휴면유무      0 : 활동중  /  1 : 휴면중
    // 마지막으로 로그인 한 날짜시간이 현재시각으로 부터 1년이 지났으면 휴면으로 지정 
//===============================================================================================================================
}
