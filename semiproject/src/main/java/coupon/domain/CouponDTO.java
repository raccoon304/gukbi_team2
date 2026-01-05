package coupon.domain;

public class CouponDTO {

	private int couponCategoryNo;
	private String couponName;
	private int discountValue;
	private int discountType; 
	private int usable;
	
	
	public int getCouponCategoryNo() {
		return couponCategoryNo;
	}
	public void setCouponCategoryNo(int couponCategoryNo) {
		this.couponCategoryNo = couponCategoryNo;
	}
	public String getCouponName() {
		return couponName;
	}
	public void setCouponName(String couponName) {
		this.couponName = couponName;
	}
	public int getDiscountValue() {
		return discountValue;
	}
	public void setDiscountValue(int discountValue) {
		this.discountValue = discountValue;
	}
	public int getDiscountType() {
		return discountType;
	}
	public void setDiscountType(int discountType) {
		this.discountType = discountType;
	}
	public int getUsable() {
		return usable;
	}
	public void setUsable(int usable) {
		this.usable = usable;
	}
	
	
	
	
}
