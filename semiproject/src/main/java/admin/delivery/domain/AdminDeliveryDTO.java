package admin.delivery.domain;

import member.domain.MemberDTO;
import order.domain.OrderDTO;
import product.domain.ProductDTO;
import product.domain.ProductOptionDTO;

public class AdminDeliveryDTO {

    private int rownum;
    private int detailCnt;
    private long payAmount;          // total_amount - discount_amount

    private OrderDTO odto = new OrderDTO();

    // OrderDTO에 없는 값(orders 테이블에 있음)
    private String recipientName;
    private String recipientPhone;
    private int deliveryStatus;      // 0/1/2/4
    private String deliveryNumber;
    private String deliveryStartdate;
    private String deliveryEnddate;

    // 조합용 DTO
    private MemberDTO mdto = new MemberDTO();
    private ProductDTO pdto = new ProductDTO();
    private ProductOptionDTO podto = new ProductOptionDTO();
	public int getRownum() {
		return rownum;
	}
	public void setRownum(int rownum) {
		this.rownum = rownum;
	}
	public int getDetailCnt() {
		return detailCnt;
	}
	public void setDetailCnt(int detailCnt) {
		this.detailCnt = detailCnt;
	}
	public long getPayAmount() {
		return payAmount;
	}
	public void setPayAmount(long payAmount) {
		this.payAmount = payAmount;
	}
	public OrderDTO getOdto() {
		return odto;
	}
	public void setOdto(OrderDTO odto) {
		this.odto = odto;
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
	public int getDeliveryStatus() {
		return deliveryStatus;
	}
	public void setDeliveryStatus(int deliveryStatus) {
		this.deliveryStatus = deliveryStatus;
	}
	public MemberDTO getMdto() {
		return mdto;
	}
	public void setMdto(MemberDTO mdto) {
		this.mdto = mdto;
	}
	public ProductDTO getPdto() {
		return pdto;
	}
	public void setPdto(ProductDTO pdto) {
		this.pdto = pdto;
	}
	public ProductOptionDTO getPodto() {
		return podto;
	}
	public void setPodto(ProductOptionDTO podto) {
		this.podto = podto;
	}
	public String getDeliveryNumber() {
		return deliveryNumber;
	}
	public void setDeliveryNumber(String deliveryNumber) {
		this.deliveryNumber = deliveryNumber;
	}
	public String getDeliveryStartdate() {
		return deliveryStartdate;
	}
	public void setDeliveryStartdate(String deliveryStartdate) {
		this.deliveryStartdate = deliveryStartdate;
	}
	public String getDeliveryEnddate() {
		return deliveryEnddate;
	}
	public void setDeliveryEnddate(String deliveryEnddate) {
		this.deliveryEnddate = deliveryEnddate;
	}

    
    
    
}
