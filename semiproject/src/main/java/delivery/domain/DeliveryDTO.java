package delivery.domain;

public class DeliveryDTO {
	private int deliveryAddressId;  // 배송지ID 시퀀스로 될꺼임. 
	private String memberId; 		// 사용자아이디 ( FK ) 
	private String recipientName; 	// 수신자명
	private String recipientPhone;  // 수신자 핸드폰 
	private String address;			// 주소
	private String addressdetail;	// 상세주소
	private int isDefault;			// 기본배송지 유무 ( 1=> 기본배송지, 0 => 기본배송지x )
    private String postalCode;		// 우편번호
	private String addressExtra;    // 참고항목
	
	public int getDeliveryAddressId() {
		return deliveryAddressId;
	}
	public void setDeliveryAddressId(int deliveryAddressId) {
		this.deliveryAddressId = deliveryAddressId;
	}
	
	public String getMemberId() {
		return memberId;
	}
	public void setMemberId(String memberId) {
		this.memberId = memberId;
	}
	
	public String getRecipientName() {
		return recipientName;
	}
	public void setRecipientName(String recipientName) {
		this.recipientName = recipientName;
	}
	
	public String getRecipientPhone() {
		return recipientPhone;
	}
	public void setRecipientPhone(String recipientPhone) {
		this.recipientPhone = recipientPhone;
	}
	
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	
	public String getAddressdetail() {
		return addressdetail;
	}
	public void setAddressdetail(String addressdetail) {
		this.addressdetail = addressdetail;
	}
	
	public int getIsDefault() {
		return isDefault;
	}
	public void setIsDefault(int isDefault) {
		this.isDefault = isDefault;
	}
	
	public String getPostalCode() {
		return postalCode;
	}
	public void setPostalCode(String postalCode) {
		this.postalCode = postalCode;
	}
	
	public String getAddressExtra() {
		return addressExtra;
	}
	public void setAddressExtra(String addressExtra) {
		this.addressExtra = addressExtra;
	}
	
	
	
}
