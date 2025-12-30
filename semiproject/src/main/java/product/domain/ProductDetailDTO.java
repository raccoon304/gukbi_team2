package product.domain;

//제품상세 테이블의 컬럼
public class ProductDetailDTO {
	  private int optionId;				//옵션번호
	  private String fkProductCode;	//상품코드참조키
	  private String color;				//색상
	  private String storageSize;		//저장용량
	  private int price;				//가격
	  private int stockQty;			//재고량
	  private String imagePath;			//제품이미지경로
	  
	  
	  
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
	  public int getPrice() {
		  return price;
	  }
	  public void setPrice(int price) {
		  this.price = price;
	  }
	  public int getStockQty() {
		  return stockQty;
	  }
	  public void setStockQty(int stockQty) {
		  this.stockQty = stockQty;
	  }
	  public String getImagePath() {
		  return imagePath;
	  }
	  public void setImagePath(String imagePath) {
		  this.imagePath = imagePath;
	  }
}
