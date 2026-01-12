package cart.domain;

import java.time.LocalDateTime;

public class CartDTO {
	
private int cartId;
private String memberId;
private int optionId;
private LocalDateTime addedDate;
private int quantity;

// 상품 상세에서 가져온 것
private int price;

// 상품에서 가져온 것
private String productName;
private String imagePath;
private String brand_name;



	public String getBrand_name() {
		return brand_name;
	}
	
	public void setBrand_name(String brand_name) {
		this.brand_name = brand_name;
	}
	
	public int getCartId() {
		
	return cartId;
	}
	
	public void setCartId(int cartId) {
		
		this.cartId = cartId;
	}
	
	public String getMemberId() {
		
		return memberId;
	}
	
	public void setMemberId(String memberId) {
		
		this.memberId = memberId;
	}
	
	public int getOptionId() {
		
		return optionId;
	}
	
	public void setOptionId(int optionId) {
		
		this.optionId = optionId;
	}
	
	public LocalDateTime getAddedDate() {
		
		return addedDate;
	}
	
	public void setAddedDate(LocalDateTime addedDate) {
		
		this.addedDate = addedDate;
	}
	
	public int getQuantity() {
		
		return quantity;
	}
	
	public void setQuantity(int quantity) {
		
		this.quantity = quantity;
	}
	
	// 상품 상세에서 가져온것
	public int getPrice() {
		
		return price;
	}
	
	public void setPrice(int price) {
		this.price = price;
	}
	
	// 상품에서 가져온 것
	public String getProductName() {
		return productName;
	}
	
	public void setProductName(String productName) {
		this.productName = productName;
	}
	
	public String getImagePath() {
		return imagePath;
	}
	
	public void setImagePath(String imagePath) {
		this.imagePath = imagePath;
	}
	
	// 총액은 별도 메서드
	public int getTotalPrice() {
	    return price * quantity;
	}


}

