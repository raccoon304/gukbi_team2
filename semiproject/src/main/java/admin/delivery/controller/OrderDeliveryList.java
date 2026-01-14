package admin.delivery.controller;

import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import admin.delivery.domain.AdminDeliveryDTO;
import admin.delivery.model.AdminDeliveryDAO;
import admin.delivery.model.AdminDeliveryDAO_imple;
import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;

public class OrderDeliveryList extends AbstractController {

    private AdminDeliveryDAO dao = new AdminDeliveryDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {


        // 관리자 로그인 체크
        HttpSession session = request.getSession();
        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

        if (loginUser == null || !"admin".equals(loginUser.getMemberid())) {
            String message = "관리자만 접근이 가능합니다";
            String loc = "javascript:history.back()";

            request.setAttribute("message", message);
            request.setAttribute("loc", loc);

            super.setRedirect(false);
            super.setViewPage("/WEB-INF/admin/admin_msg.jsp");
            return;
        }


        //redirect 후 메시지
        String flashMsg = (String) session.getAttribute("flashMsg");
        if (flashMsg != null) {
            request.setAttribute("msg", flashMsg);
            session.removeAttribute("flashMsg");
        }

  
        String deliveryStatus    = request.getParameter("deliveryStatus");   // ALL / 0 / 1 / 2 / 4
        String sort              = request.getParameter("sort");             // latest / oldest
        String sizePerPage       = request.getParameter("sizePerPage");      // 10 / 5
        String currentShowPageNo = request.getParameter("currentShowPageNo");
        String searchType        = request.getParameter("searchType");       // member_id / name / recipient_name
        String searchWord        = request.getParameter("searchWord");

       
        if (deliveryStatus == null || deliveryStatus.trim().isEmpty()) {
            deliveryStatus = "ALL";
        } else {
            deliveryStatus = deliveryStatus.trim();
            if (!"ALL".equals(deliveryStatus) &&
                !"0".equals(deliveryStatus) &&
                !"1".equals(deliveryStatus) &&
                !"2".equals(deliveryStatus) &&
                !"4".equals(deliveryStatus)) {
                deliveryStatus = "ALL";
            }
        }

        if (sort == null || (!"latest".equals(sort) && !"oldest".equals(sort))) {
            sort = "latest";
        }

        if (sizePerPage == null || (!"10".equals(sizePerPage) && !"5".equals(sizePerPage))) {
            sizePerPage = "10";
        }

        if (currentShowPageNo == null || currentShowPageNo.trim().isEmpty()) {
            currentShowPageNo = "1";
        }

        if (searchType == null) searchType = "";
        if (searchWord == null) searchWord = "";
        searchType = searchType.trim();
        searchWord = searchWord.trim();

        if (!"".equals(searchType)) {
            if (!"member_id".equals(searchType) &&
                !"name".equals(searchType) &&
                !"recipient_name".equals(searchType) &&
                !"order_id".equals(searchType)) {
                searchType = "";
                searchWord = "";
            }
        }

        if (!"".equals(searchType) && "".equals(searchWord)) {
            searchType = "";
        }

  
        Map<String, String> paraMap = new HashMap<>();
        paraMap.put("deliveryStatus", deliveryStatus);
        paraMap.put("sort", sort);
        paraMap.put("sizePerPage", sizePerPage);
        paraMap.put("currentShowPageNo", currentShowPageNo);
        paraMap.put("searchType", searchType);
        paraMap.put("searchWord", searchWord);


        // 총페이지수 + 장난방지
        int totalPage = dao.getTotalPageOrder(paraMap);
        if (totalPage == 0) totalPage = 1;

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

 
        // 페이지바
        String ctxPath = request.getContextPath();
        String pageBar = "";
        int blockSize = 10;

        int loop = 1;
        int pageNo = ((Integer.parseInt(currentShowPageNo) - 1) / blockSize) * blockSize + 1;

        String encodedWord = "";
        if (!"".equals(searchWord)) {
            encodedWord = URLEncoder.encode(searchWord, "UTF-8");
        }

        String baseUrl = ctxPath + "/admin/delivery/orderDeliveryList.hp"
                + "?deliveryStatus=" + deliveryStatus
                + "&sort=" + sort
                + "&sizePerPage=" + sizePerPage
                + "&searchType=" + searchType
                + "&searchWord=" + encodedWord;

        pageBar += "<li class='page-item'><a class='page-link' href='" + baseUrl
                + "&currentShowPageNo=1'>[처음]</a></li>";

        if (pageNo != 1) {
            pageBar += "<li class='page-item'><a class='page-link' href='" + baseUrl
                    + "&currentShowPageNo=" + (pageNo - 1) + "'>[이전]</a></li>";
        }

        while (!(loop > blockSize || pageNo > totalPage)) {
            if (pageNo == Integer.parseInt(currentShowPageNo)) {
                pageBar += "<li class='page-item active'><a class='page-link' href='#'>" + pageNo + "</a></li>";
            } else {
                pageBar += "<li class='page-item'><a class='page-link' href='" + baseUrl
                        + "&currentShowPageNo=" + pageNo + "'>" + pageNo + "</a></li>";
            }
            loop++;
            pageNo++;
        }

        if (pageNo <= totalPage) {
            pageBar += "<li class='page-item'><a class='page-link' href='" + baseUrl
                    + "&currentShowPageNo=" + pageNo + "'>[다음]</a></li>";
        }

        pageBar += "<li class='page-item'><a class='page-link' href='" + baseUrl
                + "&currentShowPageNo=" + totalPage + "'>[마지막]</a></li>";


        // 리스트/카운트
        List<AdminDeliveryDTO> orderList = dao.selectOrderDeliveryPaging(paraMap);
        int totalCount = dao.getTotalOrderCount(paraMap);

        request.setAttribute("orderList", orderList);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("totalPage", totalPage);
        request.setAttribute("pageBar", pageBar);

        request.setAttribute("deliveryStatus", deliveryStatus);
        request.setAttribute("sort", sort);
        request.setAttribute("sizePerPage", sizePerPage);
        request.setAttribute("currentShowPageNo", currentShowPageNo);
        request.setAttribute("searchType", searchType);
        request.setAttribute("searchWord", searchWord);

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/admin/delivery/orderDeliveryList.jsp");
    }
}