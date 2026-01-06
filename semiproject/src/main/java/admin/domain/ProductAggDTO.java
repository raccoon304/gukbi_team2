package admin.domain;

public class ProductAggDTO {

	
	private String ProductNo;
	private String productName;
	private String brand;
	private long qty;
	private long amount; // 할인전 판매금액(quantity*unit_price)
	
	public ProductAggDTO () {}

	public ProductAggDTO(String productNo, String productName, String brand, long qty, long amount) {
		super();
		ProductNo = productNo;
		this.productName = productName;
		this.brand = brand;
		this.qty = qty;
		this.amount = amount;
	}

	public String getProductNo() {
		return ProductNo;
	}

	public void setProductNo(String productNo) {
		ProductNo = productNo;
	}

	public String getProductName() {
		return productName;
	}

	public void setProductName(String productName) {
		this.productName = productName;
	}

	public String getBrand() {
		return brand;
	}

	public void setBrand(String brand) {
		this.brand = brand;
	}

	public long getQty() {
		return qty;
	}

	public void setQty(long qty) {
		this.qty = qty;
	}

	public long getAmount() {
		return amount;
	}

	public void setAmount(long amount) {
		this.amount = amount;
	}
	
	
	
}
