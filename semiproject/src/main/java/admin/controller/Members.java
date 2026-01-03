package admin.controller;

import java.net.URLEncoder;
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



public class Members extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		AdminDAO mdao = new AdminDAO_imple();
		
		// 관리자(admin) 로 로그인 했을때만 접속 가능하도록 한다
		
//		HttpSession session = request.getSession();
		
//		MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");
		
//		if(loginuser != null && "admin".equals(loginuser.getUserid())) {
			// 관리자로 로그인 했을 경우
			
		String searchType = request.getParameter("searchType");
        String searchWord = request.getParameter("searchWord");
        String sizePerPage = request.getParameter("sizePerPage");
        String currentShowPageNo = request.getParameter("currentShowPageNo");

        if (searchType == null ||
           (!"name".equals(searchType) && !"userid".equals(searchType) && !"email".equals(searchType))) {
            searchType = "";
        }

        if (searchWord == null || searchWord.isBlank()) {
            searchWord = "";
        }

        if (sizePerPage == null ||
           (!"10".equals(sizePerPage) && !"5".equals(sizePerPage) && !"3".equals(sizePerPage))) {
            sizePerPage = "10";
        }

        if (currentShowPageNo == null) {
            currentShowPageNo = "1";
        }

        Map<String, String> paraMap = new HashMap<>();
        paraMap.put("searchType", searchType);
        paraMap.put("searchWord", searchWord);
        paraMap.put("sizePerPage", sizePerPage);
        paraMap.put("currentShowPageNo", currentShowPageNo);

        int totalPage = mdao.getTotalPage(paraMap);

        try {
            int cPage = Integer.parseInt(currentShowPageNo);
            if (cPage > totalPage || cPage <= 0) {
                currentShowPageNo = "1";
                paraMap.put("currentShowPageNo", currentShowPageNo);
            }
        } catch (NumberFormatException e) {
            currentShowPageNo = "1";
            paraMap.put("currentShowPageNo", currentShowPageNo);
        }

        // ===== 페이지바 =====
        String pageBar = "";
        int blockSize = 10;
        int loop = 1;
        int pageNo = ((Integer.parseInt(currentShowPageNo) - 1) / blockSize) * blockSize + 1;

        String ctxPath = request.getContextPath();
        String encSearchWord = URLEncoder.encode(searchWord, "UTF-8");

        String baseUrl = ctxPath + "/admin/members.hp"
                + "?searchType=" + searchType
                + "&searchWord=" + encSearchWord
                + "&sizePerPage=" + sizePerPage;

        pageBar += "<li class='page-item'><a class='page-link' href='" + baseUrl + "&currentShowPageNo=1'>[맨처음]</a></li>";

        if (pageNo != 1) {
            pageBar += "<li class='page-item'><a class='page-link' href='" + baseUrl + "&currentShowPageNo=" + (pageNo - 1) + "'>[이전]</a></li>";
        }

        while (!(loop > blockSize || pageNo > totalPage)) {
            if (pageNo == Integer.parseInt(currentShowPageNo)) {
                pageBar += "<li class='page-item active'><a class='page-link' href='#'>" + pageNo + "</a></li>";
            } else {
                pageBar += "<li class='page-item'><a class='page-link' href='" + baseUrl + "&currentShowPageNo=" + pageNo + "'>" + pageNo + "</a></li>";
            }
            loop++;
            pageNo++;
        }

        if (pageNo <= totalPage) {
            pageBar += "<li class='page-item'><a class='page-link' href='" + baseUrl + "&currentShowPageNo=" + pageNo + "'>[다음]</a></li>";
        }
        pageBar += "<li class='page-item'><a class='page-link' href='" + baseUrl + "&currentShowPageNo=" + totalPage + "'>[마지막]</a></li>";

        // ===== 리스트 =====
        List<MemberDTO> memberList = mdao.selectMemberPaging(paraMap);
        request.setAttribute("memberList", memberList);

        request.setAttribute("searchType", searchType);
        request.setAttribute("searchWord", searchWord);
        request.setAttribute("sizePerPage", sizePerPage);
        request.setAttribute("currentShowPageNo", currentShowPageNo);
        request.setAttribute("pageBar", pageBar);

        int totalMemberCount = mdao.getTotalMemberCount(paraMap);
        request.setAttribute("totalMemberCount", totalMemberCount);

        // ===== 주문 통계(현재 페이지에 나온 회원들만) =====
        List<String> memberIds = new ArrayList<>();
        for (MemberDTO m : memberList) {
            memberIds.add(m.getMemberid());
        }

        Map<String, Map<String, Long>> orderStatMap = mdao.orderCountAndPaymentAmount(memberIds);

        // 주문 없는 회원은 0 처리
        for (String id : memberIds) {
            orderStatMap.putIfAbsent(id, new HashMap<>());
            orderStatMap.get(id).putIfAbsent("order_cnt", 0L);
            orderStatMap.get(id).putIfAbsent("real_pay_sum", 0L);
        }

        request.setAttribute("orderStatMap", orderStatMap);

        // ===== 회원 상세(모달용) =====
        String detailMemberId = request.getParameter("detailMemberId");
        if (detailMemberId != null && !detailMemberId.isBlank()) {
            Map<String, String> detailMember = mdao.memberDetail(detailMemberId);
            request.setAttribute("detailMember", detailMember);

            // 상세 모달에서도 주문 통계 보여주고 싶으면 같이 실어줌(있으면 재사용)
            Map<String, Long> stat = orderStatMap.get(detailMemberId);
            if (stat == null) {
                Map<String, Map<String, Long>> oneMap = mdao.orderCountAndPaymentAmount(List.of(detailMemberId));
                stat = oneMap.getOrDefault(detailMemberId, Map.of("order_cnt", 0L, "real_pay_sum", 0L));
            }
            request.setAttribute("detailOrderCnt", stat.getOrDefault("order_cnt", 0L));
            request.setAttribute("detailRealPaySum", stat.getOrDefault("real_pay_sum", 0L));
        }

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/admin/admin_members.jsp");
			
//		}
//		else {
			// 관리자로 로그인 하지 않은 경우
//			String message = "관리자만 접근이 가능합니다";
//			String loc = "javascript:history.back()";
			
//			request.setAttribute("message", message);
//			request.setAttribute("loc", loc);
			
//			super.setRedirect(false);
//			super.setViewPage("/WEB-INF/admin/admin_msg.jsp");
			
//		}
		
	}

}
