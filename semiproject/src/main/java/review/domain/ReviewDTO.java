package review.domain;

public class ReviewDTO {

	 private int reviewNumber; // 리뷰번호
	 private int optionId; 
	 private int orderDetailId;
	 private String reviewContent; // 내용
	 private String writeday; 
	 private double rating; // 평점
	 private int deletedYn;
	 private String deletedAt;
	 private String deletedBy;
	 
	 private String memberId;
     private String name;
     private String thumbPath; // 대표이미지  
	 
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
	 public String getThumbPath() {
		 return thumbPath;
	 }
	 public void setThumbPath(String thumbPath) {
		 this.thumbPath = thumbPath;
	 }
	
	 
	 
	
}
