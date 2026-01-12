package product.domain;

//제품상세 테이블의 컬럼
public class ProductOptionDTO {
	  private int optionId;				//옵션번호
	  private String fkProductCode;		//상품코드참조키
	  private String color;				//색상
	  private String storageSize;		//저장용량
	  private int plusPrice;			//추가금액
	  private int totalPrice;			//최종금액
	  private int stockQty;				//재고량
	  
	  private ProductDTO proDto;	//상품명과 가격을 가져오기 위함
	  
	  
	  
	  
	  public int getOptionId() {
		return optionId;
	  }
	  public void setOptionId(int optionId) {
		  this.optionId = optionId;
	  }
	  public String getFkProductCode() {
		return fkProductCode;
	  }
	  public void setFkProductCode(String fkProductCode) {
		  this.fkProductCode = fkProductCode;
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
	  public int getPlusPrice() {
		return plusPrice;
	  }
	  public void setPlusPrice(int plusPrice) {
		  this.plusPrice = plusPrice;
	  }
	  public int getStockQty() {
		  return stockQty;
	  }
	  public void setStockQty(int stockQty) {
		  this.stockQty = stockQty;
	  }
	  
	  public int getTotalPrice() {
		  return totalPrice;
	  }
	  public void setTotalPrice(int totalPrice) {
		  this.totalPrice = totalPrice;
	  }
	  
	  
	  public ProductDTO getProDto() {
		  return proDto;
	  }
	  public void setProDto(ProductDTO proDto) {
		  this.proDto = proDto;
	  }
	  
	  
	  
	  
	  
}
