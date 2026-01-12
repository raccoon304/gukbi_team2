package inquiry.controller;

import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import common.controller.AbstractController;
import inquiry.domain.InquiryDTO;
import inquiry.model.InquiryDAO;
import inquiry.model.InquiryDAO_imple;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;

public class InquiryList extends AbstractController {

	private InquiryDAO dao = new InquiryDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

    		HttpSession session = request.getSession();
        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

        boolean isAdmin = (loginUser != null && "admin".equalsIgnoreCase(loginUser.getMemberid()));
        String memberid = (loginUser != null ? loginUser.getMemberid() : "");

        
        String inquiryType = request.getParameter("inquiryType");  // 필터 (""이면 전체)
        String currentShowPageNo = request.getParameter("currentShowPageNo");

        if (inquiryType == null) inquiryType = "";
        if (currentShowPageNo == null) currentShowPageNo = "1";

        // 한 페이지에 5개 고정
        String sizePerPage = "5";
        int sizePerPageInt = 5;

/*
        // 로그인 안 한 경우 -> 로그인 유도 메시지
        if (loginUser == null) {
            
          String message = "로그인 후 이용 가능합니다.";
			String loc = request.getContextPath()+"/member/login.hp";
			
			request.setAttribute("message", message);
			request.setAttribute("loc", loc);
			
			super.setRedirect(false);
			super.setViewPage("/WEB-INF/admin/admin_msg.jsp");
			
            return;
        }
*/
        
        // 미답변 필터
        String onlyUnanswered = request.getParameter("onlyUnanswered"); // "Y" 또는 null
        
        if (!isAdmin) {// 일반회원일때
           
            onlyUnanswered = "";
        } else {// 관리자일때
            if (!"Y".equals(onlyUnanswered)) onlyUnanswered = "";
        }

        
        
        // totalCount 구하기
        
        Map<String, String> paraMap = new HashMap<>();
        paraMap.put("isAdmin", String.valueOf(isAdmin));  // "true" / "false"
        paraMap.put("memberid", memberid);
        paraMap.put("inquiryType", inquiryType);
        paraMap.put("onlyUnanswered", onlyUnanswered);
        
        int totalCount = dao.getTotalCount(paraMap);

        // totalPage 계산
        int totalPage = 0;
        if (totalCount > 0) {
            totalPage = (int) Math.ceil((double) totalCount / sizePerPageInt);
        }

        
        // currentShowPageNo 조정
     
        try {
            int cPage = Integer.parseInt(currentShowPageNo);

            if (totalPage == 0) {
                currentShowPageNo = "1";
            } else if (cPage > totalPage || cPage <= 0) {
                currentShowPageNo = "1";
            }
        } catch (NumberFormatException e) {
            currentShowPageNo = "1";
        }

        
        // startRno/endRno 계산
        
        int startRno = (Integer.parseInt(currentShowPageNo) - 1) * sizePerPageInt + 1;
        int endRno = startRno + sizePerPageInt - 1;

        paraMap.put("startRno", String.valueOf(startRno));
        paraMap.put("endRno", String.valueOf(endRno));

        
        // 리스트 조회
      
        List<InquiryDTO> inquiryList = new ArrayList<>();
        if (totalCount > 0) {
            inquiryList = dao.selectInquiriesPaging(paraMap);
        }

     
        
        
        
        // 페이지바 만들기 
      
        String pageBar = "";
        if (totalPage > 0) {

            int blockSize = 3;
            int loop = 1;
            int pageNo = ((Integer.parseInt(currentShowPageNo) - 1) / blockSize) * blockSize + 1;

            String ctxPath = request.getContextPath();
            String encInquiryType = URLEncoder.encode(inquiryType, "UTF-8");

            String baseUrl = ctxPath + "/inquiry/inquiryList.hp"
                           + "?inquiryType=" + encInquiryType
                           + "&sizePerPage=" + sizePerPage
                           + "&onlyUnanswered=" + onlyUnanswered;
            // [처음]
            pageBar += "<li class='page-item'><a class='page-link' href='"
                    + baseUrl + "&currentShowPageNo=1'>처음</a></li>";

            // [이전]
            if (pageNo != 1) {
                pageBar += "<li class='page-item'><a class='page-link' href='"
                        + baseUrl + "&currentShowPageNo=" + (pageNo - 1) + "'>이전</a></li>";
            }

            // 페이지 번호들
            while (!(loop > blockSize || pageNo > totalPage)) {

                if (pageNo == Integer.parseInt(currentShowPageNo)) {
                    pageBar += "<li class='page-item active'><a class='page-link' href='#'>"
                            + pageNo + "</a></li>";
                } else {
                    pageBar += "<li class='page-item'><a class='page-link' href='"
                            + baseUrl + "&currentShowPageNo=" + pageNo + "'>"
                            + pageNo + "</a></li>";
                }

                loop++;
                pageNo++;
            }

            // [다음]
            if (pageNo <= totalPage) {
                pageBar += "<li class='page-item'><a class='page-link' href='"
                        + baseUrl + "&currentShowPageNo=" + pageNo + "'>다음</a></li>";
            }

            // [마지막]
            pageBar += "<li class='page-item'><a class='page-link' href='"
                    + baseUrl + "&currentShowPageNo=" + totalPage + "'>마지막</a></li>";
        }
        
        
        
        
       
        request.setAttribute("inquiryList", inquiryList);
        request.setAttribute("pageBar", pageBar);

        request.setAttribute("inquiryType", inquiryType);
        request.setAttribute("currentShowPageNo", currentShowPageNo);
        request.setAttribute("sizePerPage", sizePerPage);
        request.setAttribute("totalCount", totalCount);

        request.setAttribute("onlyUnanswered", onlyUnanswered);
       
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/inquiry/inquiry.jsp");
    }
}
