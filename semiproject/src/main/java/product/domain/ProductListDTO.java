package product.domain;

public class ProductListDTO {
	//상품페이지의 카드 UI에 띄울 내용을 가져오는 DTO
	private String productCode;		//상품코드
	private String productName;		//상품명
	private String brandName;		//브랜드명
	private String imagePath;		//제품이미지경로
	private int minPrice;			//옵션 중 제일 낮은 가격
	
	
	
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
	public String getImagePath() {
		return imagePath;
	}
	public void setImagePath(String imagePath) {
		this.imagePath = imagePath;
	}
	public int getMinPrice() {
		return minPrice;
	}
	public void setMinPrice(int minPrice) {
		this.minPrice = minPrice;
	}
}
