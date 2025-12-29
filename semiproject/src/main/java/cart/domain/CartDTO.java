package cart.domain;

import java.time.LocalDateTime;

public class CartDTO {
private int cartId;
private String memberId;
private int optionId;
private LocalDateTime registerDate;

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

public LocalDateTime getRegisterDate() {
	return registerDate;
}

public void setRegisterDate(LocalDateTime registerDate) {
	this.registerDate = registerDate;
}

public int getQuantity() {
	return quantity;
}

public void setQuantity(int quantity) {
	this.quantity = quantity;
}

private int quantity;

}
