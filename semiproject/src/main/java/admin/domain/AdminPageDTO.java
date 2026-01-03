package admin.domain;

public class AdminPageDTO {

	 private String productName;
	 private String brandName;
	 private String color;
	 private String storageSize;
	 private int stockQty;
	 
	 private int orderId;
	 private String memberId;
	 private String name;
	 private int quantity;
	 
	 private int payAmount; // 주문 결제액 totalAmount - discountAmount
	 private String orderDate;
	 
	 private int detailCnt; // 주문상세 건수
	 
	 public String getProductName() {
		 return productName;
	 }
	 public void setProductName(String productName) {
		 this.productName = productName;
	 }
	 public String getBrandName() {
		 return brandName;
	 }
	 public void setBrandName(String brandName) {
		 this.brandName = brandName;
	 }
	 public String getColor() {
		 return color;
	 }
	 public void setColor(String color) {
		 this.color = color;
	 }
	 public String getStorageSize() {
		 return storageSize;
	 }
	 public void setStorageSize(String storageSize) {
		 this.storageSize = storageSize;
	 }
	 public int getStockQty() {
		 return stockQty;
	 }
	 public void setStockQty(int stockQty) {
		 this.stockQty = stockQty;
	 }
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
	 public String getName() {
		 return name;
	 }
	 public void setName(String name) {
		 this.name = name;
	 }
	 public int getQuantity() {
		 return quantity;
	 }
	 public void setQuantity(int quantity) {
		 this.quantity = quantity;
	 }
	 public int getPayAmount() {
		 return payAmount;
	 }
	 public void setPayAmount(int payAmount) {
		 this.payAmount = payAmount;
	 }
	 public String getOrderDate() {
		 return orderDate;
	 }
	 public void setOrderDate(String orderDate) {
		 this.orderDate = orderDate;
	 }
	 public int getDetailCnt() {
		 return detailCnt;
	 }
	 public void setDetailCnt(int detailCnt) {
		 this.detailCnt = detailCnt;
	 }
	
	
	 
	 
}
