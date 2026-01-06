package admin.domain;

public class TotalsDTO {

	private long orders;
	private long qty;
	private long gross; // 할인전 매출 합계
	private long discount; // 할인액 합계
	private long net; // 최종결제액 합계
	
	public TotalsDTO() {}

	public TotalsDTO(long orders, long qty, long gross, long discount, long net) {
		super();
		this.orders = orders;
		this.qty = qty;
		this.gross = gross;
		this.discount = discount;
		this.net = net;
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

	public long getGross() {
		return gross;
	}

	public void setGross(long gross) {
		this.gross = gross;
	}

	public long getDiscount() {
		return discount;
	}

	public void setDiscount(long discount) {
		this.discount = discount;
	}

	public long getNet() {
		return net;
	}

	public void setNet(long net) {
		this.net = net;
	}
	
	
	
	
	
	
}
