package order.domain;

import java.util.ArrayList;
import java.util.List;

public class OrderDTO {

    private int orderId;
    private String memberId;
    private String orderDate;      // to_char로 받으면 String
    private int totalAmount;
    private int discountAmount;
    private String deliveryAddress;
    private String orderStatus;
    
    
	public int getOrderId() {
		return orderId;
	}
	
	public void setOrderId(int orderId) {
		this.orderId = orderId;
	}
	
	public String getMemberId() {
		return memberId;
	}
	
	public void setMemberId(String memberId) {
		this.memberId = memberId;
	}
	
	public String getOrderDate() {
		return orderDate;
	}
	
	public void setOrderDate(String orderDate) {
		this.orderDate = orderDate;
	}
	
	public int getTotalAmount() {
		return totalAmount;
	}
	
	public void setTotalAmount(int totalAmount) {
		this.totalAmount = totalAmount;
	}
	
	public int getDiscountAmount() {
		return discountAmount;
	}
	
	public void setDiscountAmount(int discountAmount) {
		this.discountAmount = discountAmount;
	}
	
	public String getDeliveryAddress() {
		return deliveryAddress;
	}
	
	public void setDeliveryAddress(String deliveryAddress) {
		this.deliveryAddress = deliveryAddress;
	}
	
	public String getOrderStatus() {
		return orderStatus;
	}
	
	public void setOrderStatus(String orderStatus) {
		this.orderStatus = orderStatus;
	}



}

