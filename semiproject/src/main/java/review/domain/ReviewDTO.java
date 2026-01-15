package review.domain;

import member.domain.MemberDTO;
import product.domain.ProductDTO;
import product.domain.ProductOptionDTO;

public class ReviewDTO {

	 private int reviewNumber; // 리뷰번호
	 private int optionId; 
	 private int orderDetailId;
	 private String reviewTitle;
	 private String reviewContent; // 내용
	 private String writeday; 
	 private double rating; // 평점
	 private int deletedYn;
	 private String deletedAt;
	 private String deletedBy;
	 
     private String thumbPath; // 대표이미지  
     
     private ProductDTO pdto = new ProductDTO();
     private ProductOptionDTO podto = new ProductOptionDTO();
     private MemberDTO mdto = new MemberDTO();
     
	 
	 public int getReviewNumber() {
		 return reviewNumber;
	 }
	 public void setReviewNumber(int reviewNumber) {
		 this.reviewNumber = reviewNumber;
	 }
	 public int getOptionId() {
		 return optionId;
	 }
	 public void setOptionId(int optionId) {
		 this.optionId = optionId;
	 }
	 public int getOrderDetailId() {
		 return orderDetailId;
	 }
	 public void setOrderDetailId(int orderDetailId) {
		 this.orderDetailId = orderDetailId;
	 }
	 public String getReviewContent() {
		 return reviewContent;
	 }
	 public void setReviewContent(String reviewContent) {
		 this.reviewContent = reviewContent;
	 }
	 public String getWriteday() {
		 return writeday;
	 }
	 public void setWriteday(String writeday) {
		 this.writeday = writeday;
	 }
	 public double getRating() {
		 return rating;
	 }
	 public void setRating(double rating) {
		 this.rating = rating;
	 }
	 public int getDeletedYn() {
		 return deletedYn;
	 }
	 public void setDeletedYn(int deletedYn) {
		 this.deletedYn = deletedYn;
	 }
	 public String getDeletedAt() {
		 return deletedAt;
	 }
	 public void setDeletedAt(String deletedAt) {
		 this.deletedAt = deletedAt;
	 }
	 public String getDeletedBy() {
		 return deletedBy;
	 }
	 public void setDeletedBy(String deletedBy) {
		 this.deletedBy = deletedBy;
	 }

	 public String getThumbPath() {
		 return thumbPath;
	 }
	 public void setThumbPath(String thumbPath) {
		 this.thumbPath = thumbPath;
	 }
	 public String getReviewTitle() {
		 return reviewTitle;
	 }
	 public void setReviewTitle(String reviewTitle) {
		 this.reviewTitle = reviewTitle;
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
	 public MemberDTO getMdto() {
		 return mdto;
	 }
	 public void setMdto(MemberDTO mdto) {
		 this.mdto = mdto;
	 }
	
	 
	 
	
}
