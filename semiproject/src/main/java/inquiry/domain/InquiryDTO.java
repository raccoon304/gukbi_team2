package inquiry.domain;

import java.time.LocalDateTime;

public class InquiryDTO {
    private int inquiryNumber;
    private String memberid;          // DB: FK_MEMBER_ID
    private String inquiryType;
    private String title;
    private String registerday;
    private String inquiryContent;
    private String replyContent;
    private String replyRegisterday;
    private int replyStatus;          // 0:보류, 1:접수, 2:답변완료
    
    // Getter & Setter
    public int getInquiryNumber() {
        return inquiryNumber;
    }
    
    public void setInquiryNumber(int inquiryNumber) {
        this.inquiryNumber = inquiryNumber;
    }
    
    public String getMemberid() {
        return memberid;
    }
    
    public void setMemberid(String memberid) {
        this.memberid = memberid;
    }
    
    public String getInquiryType() {
        return inquiryType;
    }
    
    public void setInquiryType(String inquiryType) {
        this.inquiryType = inquiryType;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getRegisterday() {
        return registerday;
    }
    
    public void setRegisterday(String registerday) {
        this.registerday = registerday;
    }
    
    public String getInquiryContent() {
        return inquiryContent;
    }
    
    public void setInquiryContent(String inquiryContent) {
        this.inquiryContent = inquiryContent;
    }
    
    public String getReplyContent() {
        return replyContent;
    }
    
    public void setReplyContent(String replyContent) {
        this.replyContent = replyContent;
    }
    
    public String getReplyRegisterday() {
        return replyRegisterday;
    }
    
    public void setReplyRegisterday(String replyRegisterday) {
        this.replyRegisterday = replyRegisterday;
    }
    
    public int getReplyStatus() {
        return replyStatus;
    }
    
    public void setReplyStatus(int replyStatus) {
        this.replyStatus = replyStatus;
    }
    
    // 답변 상태를 문자열로 반환하는 헬퍼 메소드
    public String getReplyStatusString() {
        switch(this.replyStatus) {
            case 0: return "보류";
            case 1: return "접수";
            case 2: return "답변완료";
            default: return "알수없음";
        }
    }
}