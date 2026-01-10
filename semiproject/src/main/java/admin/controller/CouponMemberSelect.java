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

        String searchType = request.getParameter("searchType");      // member_id , name , email
        String searchWord = request.getParameter("searchWord");
        String sizePerPage = request.getParameter("sizePerPage");    // 5 , 10
        String currentShowPageNo = request.getParameter("currentShowPageNo");

        String sortKey = request.getParameter("sortKey"); // order_cnt , real_pay_sum , ""
        String sortDir = request.getParameter("sortDir"); // desc , ""

    
        boolean hasSearchType =
                "member_id".equals(searchType) || "name".equals(searchType) || "email".equals(searchType);

        if (!hasSearchType) searchType = "";
        if (searchWord == null) searchWord = "";
        searchWord = searchWord.trim();

        if (!"5".equals(sizePerPage) && !"10".equals(sizePerPage)) sizePerPage = "5";
        if (currentShowPageNo == null || currentShowPageNo.trim().isEmpty()) currentShowPageNo = "1";

        // 정렬(없음/내림차순만)
        boolean okSortKey = "order_cnt".equals(sortKey) || "real_pay_sum".equals(sortKey);
        if (!okSortKey) sortKey = "";

        if (!"desc".equals(sortDir)) sortDir = ""; // desc 아니면 정렬 안함

        Map<String, String> paraMap = new HashMap<>();
        paraMap.put("searchType", searchType);
        paraMap.put("searchWord", searchWord);
        paraMap.put("sizePerPage", sizePerPage);
        paraMap.put("currentShowPageNo", currentShowPageNo);
        paraMap.put("sortKey", sortKey);
        paraMap.put("sortDir", sortDir);

        // ===== 총 건수/총 페이지 =====
        int totalCount = mdao.getTotalCountMemberForCoupon(paraMap);

        int size = Integer.parseInt(sizePerPage);
        int totalPage = (int) Math.ceil((double) totalCount / size);
        if (totalPage == 0) totalPage = 1; // 장난방지용(페이지 계산 깨짐 방지)

        // ===== 페이지 장난 방지 =====
        try {
            int c = Integer.parseInt(currentShowPageNo);
            if (c < 1) c = 1;
            if (c > totalPage) c = 1;
            currentShowPageNo = String.valueOf(c);
        } catch (NumberFormatException e) {
            currentShowPageNo = "1";
        }
        paraMap.put("currentShowPageNo", currentShowPageNo);

        // ===== 페이지바 =====
        String pageBar = "";
        int blockSize = 10;
        int loop = 1;

        int pageNo = ((Integer.parseInt(currentShowPageNo) - 1) / blockSize) * blockSize + 1;

        // 결과가 0건이면 pageBar는 비움
        if (totalCount > 0) {
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

        // ===== 목록 조회(쿠폰 발급 모달용) =====
        List<MemberDTO> memberList = mdao.selectMemberPagingForCoupon(paraMap);

        // ===== 통계(주문건수, 구매액) =====
        Map<String, Map<String, Long>> statMap = new HashMap<>();

        if (memberList != null && !memberList.isEmpty()) {
            List<String> memberIds = new ArrayList<>();
            for (MemberDTO m : memberList) {
                memberIds.add(m.getMemberid());
            }
            statMap = mdao.orderCountAndPaymentAmount(memberIds);
        }

        
        request.setAttribute("memberList", memberList);
        request.setAttribute("statMap", statMap);
        request.setAttribute("pageBar", pageBar);
        request.setAttribute("totalCount", totalCount);

        request.setAttribute("sortKey", sortKey);
        request.setAttribute("sortDir", sortDir);

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/admin/coupons/memberSelect_fragment.jsp");

		
	}

}
