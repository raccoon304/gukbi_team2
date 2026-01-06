<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%String ctxPath = request.getContextPath();%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- 헤더부분 가져오기 -->
<jsp:include page="../header.jsp"/>

<!-- 사용자 CSS -->
<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/product_TH/TESTProductList.css">
    
<!-- 사용자 JS -->
<script type="text/javascript" src="<%=ctxPath%>/js/product_TH/TESTProductList.js"></script>


<!-- 임시 수정본 주석처리 -->
<!-- 임시 수정본 주석처리 한번 더 해보기 -->
<!-- 임시 수정본 주석처리 제발좀 -->

<!-- 페이지 헤더 -->
<div class="page-header" style="margin-top: 5%">
    <div class="container">
        <h1><i class="fas fa-mobile-alt mr-3"></i>전체 상품</h1>
        <p class="mb-0">최신 스마트폰을 만나보세요</p>
    </div>
</div>

<div class="container">
    <!-- 검색 및 필터 -->
    <div class="filter-section">
        <!-- 검색 -->
        <div class="search-box">
            <input type="text" class="search-input" id="searchInput" placeholder="상품명을 검색하세요...">
            <button class="search-btn" id="searchBtn">
                <i class="fas fa-search"></i>
            </button>
        </div>

        <div class="row">
            <!-- 브랜드 필터 -->
            <div class="col-md-6 mb-3">
                <label class="filter-label">
                    <i class="fas fa-tag mr-2"></i>브랜드
                </label>
                <div class="brand-filter">
                    <button class="brand-btn active" data-brand="all">
                        <i class="fas fa-th mr-2"></i>전체
                    </button>
                    <button class="brand-btn" data-brand="Apple">
                        <i class="fab fa-apple mr-2"></i>애플
                    </button>
                    <button class="brand-btn" data-brand="Samsung">
                        <i class="fas fa-mobile-alt mr-2"></i>삼성
                    </button>
                </div>
            </div>

            <!-- 정렬 -->
            <div class="col-md-6 mb-3">
                <label class="filter-label">
                    <i class="fas fa-sort mr-2"></i>정렬
                </label>
                <select class="sort-select form-control" id="sortSelect">
                    <option value="latest">최신순</option>
                    <option value="price_high">고가순</option>
                    <option value="price_low">저가순</option>
                </select>
            </div>
            
        </div>
    </div>

    <!-- 결과 정보 -->
    <div class="result-info">
        <div class="result-count">
            총 <span id="totalCount">60</span>개의 상품
        </div>
        <div class="text-muted">
            <span id="currentPage">1</span> / 5 페이지
        </div>
    </div>

    <!-- 상품 그리드 -->
    <div class="products-grid" id="productsGrid">
        <!-- 상품 카드들이 여기에 동적으로 생성됩니다 -->
    </div>

    <!-- 페이지네이션 -->
    <div class="pagination-wrapper">
        <ul class="pagination" id="pagination">
            <li class="page-item disabled">
                <a class="page-link" href="#" data-page="prev">
                    <i class="fas fa-chevron-left"></i>
                </a>
            </li>
            <li class="page-item active">
                <a class="page-link" href="#" data-page="1">1</a>
            </li>
            <li class="page-item">
                <a class="page-link" href="#" data-page="2">2</a>
            </li>
            <li class="page-item">
                <a class="page-link" href="#" data-page="3">3</a>
            </li>
            <li class="page-item">
                <a class="page-link" href="#" data-page="4">4</a>
            </li>
            <li class="page-item">
                <a class="page-link" href="#" data-page="5">5</a>
            </li>
            <li class="page-item">
                <a class="page-link" href="#" data-page="next">
                    <i class="fas fa-chevron-right"></i>
                </a>
            </li>
        </ul>
    </div>
</div>


<!-- 푸터부분 가져오기 -->
<jsp:include page="../footer.jsp"/>