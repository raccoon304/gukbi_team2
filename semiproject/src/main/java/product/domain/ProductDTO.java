package product.domain;

//제품테이블의 컬럼
public class ProductDTO {
	  private String productCode;	//상품코드
	  private String productName;	//상품명
	  private String brandName;		//브랜드명
	  private String productDesc;	//상품설명
	  private String saleStatus;		//판매상태
	  private String imagePath;		//제품이미지경로
	  private int price;				//제품가격
	  
	  
	  public String getProductCode() {
		  return productCode;
	  }
	  public void setProductCode(String productCode) {
		  this.productCode = productCode;
	  }
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
	  public String getProductDesc() {
		  return productDesc;
	  }
	  public void setProductDesc(String productDesc) {
		  this.productDesc = productDesc;
	  }
	  public String getSaleStatus() {
		  return saleStatus;
	  }
	  public void setSaleStatus(String saleStatus) {
		  this.saleStatus = saleStatus;
	  }
	  public String getImagePath() {
		  return imagePath;
	  }
	  public void setImagePath(String imagePath) {
		  this.imagePath = imagePath;
	  }
	  public int getPrice() {
		  return price;
	  }
	  public void setPrice(int price) {
		  this.price = price;
	  }
	  
}
