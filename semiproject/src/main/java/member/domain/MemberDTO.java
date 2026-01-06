package member.domain;

public class MemberDTO { 
	private String memberid;		// 회원아이디
	private String name;			// 회원명
	private String password;		// 비밀번호 (SHA-256 암호화 대상)	
	private String mobile;			// 휴대폰 번호(AES-256 암호화/복호화 대상) 
	private String email;			// 이메일 (AES-256 암호화/복호화 대상) 
	private String birthday;		// 생년월일  
	private int gender;				// 성별		0:남자 1:여자
	private String registerday;		// 가입일자 										DB 디폴트 (sysdate)

   	private int status;             // 회원탈퇴유무   0: 사용가능(가입중) / 1:사용불능(탈퇴) 	DB 디폴트 ( 0 ) 
   	private int idle;               // 휴면유무      0 : 활동중  /  1 : 휴면중				DB 디폴트 ( 0 )
   	private int userseq;
//===============================================================================================================================
	public String getMemberid() {
		return memberid;
	}
	public void setMemberid(String memberid) {
		this.memberid = memberid;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getMobile() {
		return mobile;
	}
	public void setMobile(String mobile) {
		this.mobile = mobile;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getBirthday() {
		return birthday;
	}
	public void setBirthday(String birthday) {
		this.birthday = birthday;
	}
	public int getGender() {
		return gender;
	}
	public void setGender(int gender) {
		this.gender = gender;
	}
	public String getRegisterday() {
		return registerday;
	}
	public void setRegisterday(String registerday) {
		this.registerday = registerday;
	}
	public int getStatus() {
		return status;
	}
	public void setStatus(int status) {
		this.status = status;
	}
	public int getIdle() {
		return idle;
	}
	public void setIdle(int idle) {
		this.idle = idle;
	}
	public int getUserseq() {
		return userseq;
	}
	public void setUserseq(int userseq) {
		this.userseq = userseq;
	}
   	
}
