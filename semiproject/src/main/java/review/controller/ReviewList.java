package review.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import product.domain.ProductDTO;
import product.model.ProductDAO;
import product.model.ProductDAO_imple;
import review.domain.ReviewDTO;
import review.model.ReviewDAO;
import review.model.ReviewDAO_imple;

public class ReviewList extends AbstractController {

	 private ProductDAO pdao = new ProductDAO_imple();
	 private ReviewDAO rdao = new ReviewDAO_imple();
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		
        String productCode = request.getParameter("productCode");
        String sort = request.getParameter("sort"); // latest/high/low
        String sizePerPage = request.getParameter("sizePerPage");
        String currentShowPageNo = request.getParameter("currentShowPageNo");

        if (sort == null || (!"latest".equals(sort) && !"high".equals(sort) && !"low".equals(sort))) {
            sort = "latest";
        }

        if (sizePerPage == null || (!"10".equals(sizePerPage) && !"5".equals(sizePerPage) && !"3".equals(sizePerPage))) {
            sizePerPage = "10";
        }

        if (currentShowPageNo == null) {
            currentShowPageNo = "1";
        }

        // ===== 전체 상품 리스트 ===== //
        List<ProductDTO> productList = pdao.selectProduct();

        if (productList == null || productList.isEmpty()) {
            request.setAttribute("msg", "등록된 상품이 없습니다.");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/review/reviewList.jsp");
            return;
        }

        // ProductDAO 쿼리에 ORDER BY 가 없어서 컨트롤러에서 정렬
        productList.sort((a, b) -> {
            String an = (a.getProductName() == null) ? "" : a.getProductName();
            String bn = (b.getProductName() == null) ? "" : b.getProductName();
            return an.compareToIgnoreCase(bn);
        });

        request.setAttribute("productList", productList);

        // productCode가 없거나, 리스트에 없는 값이면 첫 상품으로
        if (productCode == null || productCode.trim().isEmpty()) {
            productCode = productList.get(0).getProductCode();
        } else {
            boolean exists = false;
            for (ProductDTO p : productList) {
                if (productCode.equals(p.getProductCode())) {
                    exists = true;
                    break;
                }
            }
            if (!exists) {
                productCode = productList.get(0).getProductCode();
            }
        }

        
        Map<String, String> paraMap = new HashMap<>();
        paraMap.put("productCode", productCode);
        paraMap.put("sort", sort);
        paraMap.put("sizePerPage", sizePerPage);
        paraMap.put("currentShowPageNo", currentShowPageNo);

        // ===== 총페이지수 구하기 ===== //
        int totalPage = rdao.getTotalPage(paraMap);

        // totalPage가 0이면(리뷰가 0이면) 1로
        if (totalPage == 0) totalPage = 1;

        // ===== 장난 방지 ===== //
        try {
            if (Integer.parseInt(currentShowPageNo) > totalPage || Integer.parseInt(currentShowPageNo) <= 0) {
                currentShowPageNo = "1";
                paraMap.put("currentShowPageNo", currentShowPageNo);
            }
        } catch (NumberFormatException e) {
            currentShowPageNo = "1";
            paraMap.put("currentShowPageNo", currentShowPageNo);
        }

        // ===== 페이지바 만들기 ===== //
        String ctxPath = request.getContextPath();

        String pageBar = "";
        int blockSize = 10;

        int loop = 1;
        int pageNo = ((Integer.parseInt(currentShowPageNo) - 1) / blockSize) * blockSize + 1;

        // [처음]
        pageBar += "<li class='page-item'><a class='page-link' href='" + ctxPath
                + "/review/reviewList.hp?productCode=" + productCode
                + "&sort=" + sort
                + "&sizePerPage=" + sizePerPage
                + "&currentShowPageNo=1'>[처음]</a></li>";

        // [이전]
        if (pageNo != 1) {
            pageBar += "<li class='page-item'><a class='page-link' href='" + ctxPath
                    + "/review/reviewList.hp?productCode=" + productCode
                    + "&sort=" + sort
                    + "&sizePerPage=" + sizePerPage
                    + "&currentShowPageNo=" + (pageNo - 1) + "'>[이전]</a></li>";
        }

        while (!(loop > blockSize || pageNo > totalPage)) {

            if (pageNo == Integer.parseInt(currentShowPageNo)) {
                pageBar += "<li class='page-item active'><a class='page-link' href='#'>" + pageNo + "</a></li>";
            } else {
                pageBar += "<li class='page-item'><a class='page-link' href='" + ctxPath
                        + "/review/reviewList.hp?productCode=" + productCode
                        + "&sort=" + sort
                        + "&sizePerPage=" + sizePerPage
                        + "&currentShowPageNo=" + pageNo + "'>" + pageNo + "</a></li>";
            }

            loop++;
            pageNo++;
        }

        // [다음]
        if (pageNo <= totalPage) {
            pageBar += "<li class='page-item'><a class='page-link' href='" + ctxPath
                    + "/review/reviewList.hp?productCode=" + productCode
                    + "&sort=" + sort
                    + "&sizePerPage=" + sizePerPage
                    + "&currentShowPageNo=" + pageNo + "'>[다음]</a></li>";
        }

        // [마지막]
        pageBar += "<li class='page-item'><a class='page-link' href='" + ctxPath
                + "/review/reviewList.hp?productCode=" + productCode
                + "&sort=" + sort
                + "&sizePerPage=" + sizePerPage
                + "&currentShowPageNo=" + totalPage + "'>[마지막]</a></li>";

        // ===== 리뷰 목록 조회 ===== //
        List<ReviewDTO> reviewList = rdao.selectReviewPaging(paraMap);

        // ===== 통계/총개수 ===== //
        int totalReviewCount = rdao.getTotalReviewCount(paraMap);
        Map<String, Object> statMap = rdao.getReviewStat(paraMap);

        request.setAttribute("reviewList", reviewList);

        request.setAttribute("productCode", productCode);
        request.setAttribute("sort", sort);
        request.setAttribute("sizePerPage", sizePerPage);
        request.setAttribute("currentShowPageNo", currentShowPageNo);

        request.setAttribute("pageBar", pageBar);

        request.setAttribute("totalReviewCount", totalReviewCount);
        request.setAttribute("statMap", statMap);

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/review/reviewList.jsp");
		
	}

}
