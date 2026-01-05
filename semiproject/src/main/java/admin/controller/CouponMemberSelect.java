package admin.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import admin.model.AdminDAO;
import admin.model.AdminDAO_imple;
import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import member.domain.MemberDTO;

public class CouponMemberSelect extends AbstractController {
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		 AdminDAO mdao = new AdminDAO_imple();

        String searchType = request.getParameter("searchType");      // member_id / name / email
        String searchWord = request.getParameter("searchWord");
        String sizePerPage = request.getParameter("sizePerPage");    // 5 / 10
        String currentShowPageNo = request.getParameter("currentShowPageNo");

        // === 유효성 ===
        if (searchType == null ||
            (!"member_id".equals(searchType) && !"name".equals(searchType) && !"email".equals(searchType))) {
            searchType = "";
        }

        if (searchWord == null) searchWord = "";
        searchWord = searchWord.trim();

        if (sizePerPage == null || (!"5".equals(sizePerPage) && !"10".equals(sizePerPage))) {
            sizePerPage = "5";
        }

        if (currentShowPageNo == null || currentShowPageNo.trim().isEmpty()) {
            currentShowPageNo = "1";
        }

        Map<String, String> paraMap = new HashMap<>();
        paraMap.put("searchType", searchType);
        paraMap.put("searchWord", searchWord);
        paraMap.put("sizePerPage", sizePerPage);
        paraMap.put("currentShowPageNo", currentShowPageNo);

        // === 총 페이지/총 건수 ===
        int totalPage = mdao.getTotalPage(paraMap);
        int totalCount = mdao.getTotalMemberCount(paraMap);

        // 장난 방지(페이지 범위)
        try {
            int c = Integer.parseInt(currentShowPageNo);
            if (c <= 0) {
                currentShowPageNo = "1";
            } else if (totalPage > 0 && c > totalPage) {
                currentShowPageNo = "1";
            }
        } catch (NumberFormatException e) {
            currentShowPageNo = "1";
        }
        paraMap.put("currentShowPageNo", currentShowPageNo);

        // === 페이지바 만들기 ===
        String pageBar = "";
        int blockSize = 10;
        int loop = 1;

        int pageNo = ((Integer.parseInt(currentShowPageNo) - 1) / blockSize) * blockSize + 1;

        // totalPage=0(검색결과 없음)인 경우 pageBar 비우기
        if (totalPage > 0) {

            pageBar += "<li class='page-item'><a class='page-link modal-page' data-page='1' href='#'>[맨처음]</a></li>";

            if (pageNo != 1) {
                pageBar += "<li class='page-item'><a class='page-link modal-page' data-page='" + (pageNo - 1) + "' href='#'>[이전]</a></li>";
            }

            while (!(loop > blockSize || pageNo > totalPage)) {

                if (pageNo == Integer.parseInt(currentShowPageNo)) {
                    pageBar += "<li class='page-item active'><a class='page-link' href='#'>" + pageNo + "</a></li>";
                } else {
                    pageBar += "<li class='page-item'><a class='page-link modal-page' data-page='" + pageNo + "' href='#'>" + pageNo + "</a></li>";
                }

                loop++;
                pageNo++;
            }

            if (pageNo <= totalPage) {
                pageBar += "<li class='page-item'><a class='page-link modal-page' data-page='" + pageNo + "' href='#'>[다음]</a></li>";
            }

            pageBar += "<li class='page-item'><a class='page-link modal-page' data-page='" + totalPage + "' href='#'>[마지막]</a></li>";
        }

        // === 목록 ===
        List<MemberDTO> memberList = mdao.selectMemberPaging(paraMap);

        request.setAttribute("memberList", memberList);
        request.setAttribute("pageBar", pageBar);
        request.setAttribute("totalCount", totalCount);
        
        
        List<String> memberIds = new ArrayList<>();
        for(MemberDTO m : memberList) {
            memberIds.add(m.getMemberid());   //
        }

        // 주문건수/총구매액 Map 가져오기
        Map<String, Map<String, Long>> statMap = mdao.orderCountAndPaymentAmount(memberIds);

        // request에 담기
        request.setAttribute("memberList", memberList);
        request.setAttribute("statMap", statMap);
        
        

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/admin/coupons/memberSelect_fragment.jsp");

		
	}

}
