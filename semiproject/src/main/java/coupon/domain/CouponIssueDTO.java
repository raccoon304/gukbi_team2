package coupon.domain;

public class CouponIssueDTO {

	private int couponCategoryNo; // 쿠폰카테고리번호(pk, fk)
	private int couponId;         // 쿠폰발급번호(pk)  
	private String memberId;      // 회원아이디(fk)
	private String issueDate;     // 발급일  DEFAULT SYSDATE
	private String expireDate;    // 만료일
	private int usedYn;          // 사용여부 미사용 0, 사용 1 DEFAULT 0
	
	// --------------------------- 화면용 --------------------------------- //
	
	private String memberName; // 회원명
	
	
	
	
	public int getCouponCategoryNo() {
		return couponCategoryNo;
	}
	public void setCouponCategoryNo(int couponCategoryNo) {
		this.couponCategoryNo = couponCategoryNo;
	}
	public int getCouponId() {
		return couponId;
	}
	public void setCouponId(int couponId) {
		this.couponId = couponId;
	}
	public String getMemberId() {
		return memberId;
	}
	public void setMemberId(String memberId) {
		this.memberId = memberId;
	}
	public String getIssueDate() {
		return issueDate;
	}
	public void setIssueDate(String issueDate) {
		this.issueDate = issueDate;
	}
	public String getExpireDate() {
		return expireDate;
	}
	public void setExpireDate(String expireDate) {
		this.expireDate = expireDate;
	}
	public int getUsedYn() {
		return usedYn;
	}
	public void setUsedYn(int usedYn) {
		this.usedYn = usedYn;
	}
	public String getMemberName() {
		return memberName;
	}
	public void setMemberName(String memberName) {
		this.memberName = memberName;
	}
	
	
	
	
	
	
}
