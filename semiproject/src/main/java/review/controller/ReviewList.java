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


	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		ProductDAO pdao = new ProductDAO_imple();
		ReviewDAO rdao = new ReviewDAO_imple();
		
		String productCode = request.getParameter("productCode"); // ALL or 특정상품
		String sort = request.getParameter("sort"); // latest/high/low
		String sizePerPage = request.getParameter("sizePerPage");
		String currentShowPageNo = request.getParameter("currentShowPageNo");

		if (productCode == null || productCode.trim().isEmpty()) {
			productCode = "ALL";
		}

		if (sort == null || (!"latest".equals(sort) && !"old".equals(sort) && !"high".equals(sort) && !"low".equals(sort))) {
			sort = "latest";
		}

		if (sizePerPage == null || (!"10".equals(sizePerPage) && !"5".equals(sizePerPage) && !"3".equals(sizePerPage))) {
			sizePerPage = "10";
		}

		if (currentShowPageNo == null || currentShowPageNo.trim().isEmpty()) {
			currentShowPageNo = "1";
		}

		// ===== 상품 리스트(필터용) =====
		List<ProductDTO> productList = pdao.selectProduct();
		if (productList != null && !productList.isEmpty()) {
			productList.sort((a, b) -> {
				String an = (a.getProductName() == null) ? "" : a.getProductName();
				String bn = (b.getProductName() == null) ? "" : b.getProductName();
				return an.compareToIgnoreCase(bn);
			});
		}
		request.setAttribute("productList", productList);

		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("productCode", productCode);
		paraMap.put("sort", sort);
		paraMap.put("sizePerPage", sizePerPage);
		paraMap.put("currentShowPageNo", currentShowPageNo);

		// ===== 총페이지수 =====
		int totalPage = rdao.getTotalPage(paraMap);
		if (totalPage == 0) totalPage = 1;

		// ===== 장난 방지 =====
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
		String ctxPath = request.getContextPath();
		String pageBar = "";
		int blockSize = 10;

		int loop = 1;
		int pageNo = ((Integer.parseInt(currentShowPageNo) - 1) / blockSize) * blockSize + 1;

		pageBar += "<li class='page-item'><a class='page-link' href='" + ctxPath
				+ "/review/reviewList.hp?productCode=" + productCode
				+ "&sort=" + sort
				+ "&sizePerPage=" + sizePerPage
				+ "&currentShowPageNo=1'>처음</a></li>";

		if (pageNo != 1) {
			pageBar += "<li class='page-item'><a class='page-link' href='" + ctxPath
					+ "/review/reviewList.hp?productCode=" + productCode
					+ "&sort=" + sort
					+ "&sizePerPage=" + sizePerPage
					+ "&currentShowPageNo=" + (pageNo - 1) + "'>이전</a></li>";
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

		if (pageNo <= totalPage) {
			pageBar += "<li class='page-item'><a class='page-link' href='" + ctxPath
					+ "/review/reviewList.hp?productCode=" + productCode
					+ "&sort=" + sort
					+ "&sizePerPage=" + sizePerPage
					+ "&currentShowPageNo=" + pageNo + "'>다음</a></li>";
		}

		pageBar += "<li class='page-item'><a class='page-link' href='" + ctxPath
				+ "/review/reviewList.hp?productCode=" + productCode
				+ "&sort=" + sort
				+ "&sizePerPage=" + sizePerPage
				+ "&currentShowPageNo=" + totalPage + "'>마지막</a></li>";

		// ===== 리스트 =====
		List<ReviewDTO> reviewList = rdao.selectReviewPaging(paraMap);

		// ===== 카운트/통계 =====
		int totalCount = rdao.getTotalReviewCount(paraMap);
		Map<String, Object> statMap = rdao.getReviewStat(paraMap);

		request.setAttribute("reviewList", reviewList);
		request.setAttribute("productCode", productCode);
		request.setAttribute("sort", sort);
		request.setAttribute("sizePerPage", sizePerPage);
		request.setAttribute("currentShowPageNo", currentShowPageNo);

		request.setAttribute("pageBar", pageBar);
		request.setAttribute("totalCount", totalCount);
		request.setAttribute("totalPage", totalPage);
		request.setAttribute("statMap", statMap);

		super.setRedirect(false);
		super.setViewPage("/WEB-INF/review/reviewList.jsp");
	}

}
