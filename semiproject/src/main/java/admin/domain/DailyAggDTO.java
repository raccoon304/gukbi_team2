package admin.domain;

public class DailyAggDTO {

	private String baseDate;
	private long orders;
	private long qty;
	private long amount; // 할인전 판매금액(total_amount 합)
	
	public DailyAggDTO() {}

	public DailyAggDTO(String baseDate, long orders, long qty, long amount) {
		super();
		this.baseDate = baseDate;
		this.orders = orders;
		this.qty = qty;
		this.amount = amount;
	}

	public String getBaseDate() {
		return baseDate;
	}

	public void setBaseDate(String baseDate) {
		this.baseDate = baseDate;
	}

	public long getOrders() {
		return orders;
	}

	public void setOrders(long orders) {
		this.orders = orders;
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
