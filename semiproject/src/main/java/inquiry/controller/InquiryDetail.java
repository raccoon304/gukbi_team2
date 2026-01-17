package inquiry.controller;

import org.json.JSONObject;

import common.controller.AbstractController;
import inquiry.domain.InquiryDTO;
import inquiry.model.InquiryDAO;
import inquiry.model.InquiryDAO_imple;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;

public class InquiryDetail extends AbstractController {

	 private InquiryDAO dao = new InquiryDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	
        String method = request.getMethod();

        if (!"POST".equalsIgnoreCase(method)) {
            JSONObject json = new JSONObject();
            json.put("success", false);
            json.put("message", "잘못된 요청입니다.");
            request.setAttribute("json", json.toString());
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/admin/admin_jsonview.jsp");
            return;
        }

        JSONObject json = new JSONObject();

        HttpSession session = request.getSession();
	    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

	    
//        if (loginUser == null) {
//            json.put("success", false);
//           json.put("needLogin", true);
//            json.put("message", "로그인이 필요합니다.");
//            request.setAttribute("json", json.toString());
//            super.setRedirect(false);
//            super.setViewPage("/WEB-INF/admin/admin_jsonview.jsp");
//            return;
//        }

        int inquiryNumber = 0;
        try {
            inquiryNumber = Integer.parseInt(request.getParameter("inquiryNumber"));
            
            if (inquiryNumber <= 0) {
            		throw new NumberFormatException();
            }
            
        } catch (Exception e) {
            json.put("success", false);
            json.put("message", "문의번호가 올바르지 않습니다.");
            request.setAttribute("json", json.toString());
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/admin/admin_jsonview.jsp");
            return;
        }

        InquiryDTO dto = dao.selectInquiryDetail(inquiryNumber); // 상세내역 불러오기

        if (dto == null) {
            json.put("success", false);
            json.put("message", "해당 문의가 존재하지 않습니다.");
            request.setAttribute("json", json.toString());
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/admin/admin_jsonview.jsp");
            return;
        }

        boolean isAdmin = (loginUser != null) && "admin".equalsIgnoreCase(loginUser.getMemberid());
        boolean isOwner = (loginUser != null) && loginUser.getMemberid().equals(dto.getMemberid());

        // 비밀글 차단: 작성자/관리자 아니면 상세 조회 자체를 막음
        if (dto.getIsSecret() == 1 && !(isAdmin || isOwner)) {
            json.put("success", false);
            json.put("secretBlocked", true);
            
            if (loginUser == null) {
            	
            		json.put("message", "비밀글은 작성자만 조회 가능합니다. 로그인을 해주세요.");
            }
            else {
            		json.put("message", "비밀글은 작성자만 조회 가능합니다.");
            }
            request.setAttribute("json", json.toString());
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/admin/admin_jsonview.jsp");
            return;
        }
       
        

        // 정상 상세 반환
        json.put("success", true);
        json.put("inquiryNumber", dto.getInquiryNumber());
        json.put("memberid", dto.getMemberid());
        json.put("inquiryType", dto.getInquiryType());
        json.put("title", dto.getTitle());
        json.put("inquiryContent", dto.getInquiryContent());
        json.put("registerday", dto.getRegisterday());
        json.put("replyStatus", dto.getReplyStatus());
        json.put("replyContent", dto.getReplyContent());
        json.put("replyRegisterday", dto.getReplyRegisterday());
        json.put("isSecret", dto.getIsSecret());

        // 버튼 노출 권한
        boolean canEdit = isOwner && dto.getReplyStatus() != 2; // 답변완료면 수정 불가
        boolean canDelete = isOwner || isAdmin;
        boolean canReply = isAdmin; // 관리자만 답변

        json.put("canEdit", canEdit);
        json.put("canDelete", canDelete);
        json.put("canReply", canReply);
        json.put("isAdmin", isAdmin);

        request.setAttribute("json", json.toString());
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/admin/admin_jsonview.jsp");
    }
}
