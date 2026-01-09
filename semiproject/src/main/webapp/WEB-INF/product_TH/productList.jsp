<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%String ctxPath=request.getContextPath();%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!-- 헤더부분 가져오기 -->
<jsp:include page="../header.jsp"/>

<!-- 사용자 CSS -->
<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/product_TH/productList.css">

<!-- 사용자 JS -->
<script type="text/javascript" src="<%=ctxPath%>/js/product_TH/productList.js"></script>


<!-- 페이지 헤더 -->
<div class="page-header" style="margin-top: 5%">
    <div class="container">
        <h1><i class="fas fa-mobile-alt mr-3"></i>전체 상품</h1>
        <p class="mb-0">최신 스마트폰을 만나보세요</p>
        
	    <%-- <a href="<%=ctxPath%>/product/TESTproductList.hp" style="font-size: 15pt; font-weight: bold; color: black;">
			<i class="fa-solid fa-list"></i> 테스트상품페이지 가기
		</a> --%>
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
                    <!-- <option value="latest">최신순</option> -->
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
	
	
	<!-- 제품 정보를 ForEach를 사용해 card 형태로 나타내기 -->
	<div class="row">
		<c:forEach var="product" items="${productCardList}">
			<!-- data- 를 이용하여 해당값을 js에서 사용할 수 있도록 추가해주기 -->
			<div class="col-md-3 mb-4 product-item"
						data-name="${product.productName}"
						data-brand="${product.brandName}"
						data-price="${product.price}">
				<div class="card h-100">
					<img src="<%=ctxPath%>/image/product_TH/${product.imagePath}" class="card-img-top">
					<div class="card-body">
						<h5 class="card-title">${product.productName}</h5>
						<p class="card-text">${product.brandName}</p>
						<p class="card-text">Black&nbsp;/&nbsp;White&nbsp;/&nbsp;red&nbsp;/&nbsp;blue</p>
						<p class="card-text">256GB&nbsp;/&nbsp;512GB</p>
						<p class="card-text">
							<fmt:formatNumber value="${product.price}" pattern="###,###"/>&nbsp;원
						</p>
					</div>
					
					<div class="card-footer">
						<a href="<%=ctxPath%>/product/productOption.hp?productCode=${product.productCode}" 
							class="btn btn-primary w-100">상세보기</a>
					</div>
				</div>
			</div>
		</c:forEach>
	</div>

</div>


<!-- 원래는 제품정보를 보내기 위해 사용했지만 추후 장바구니/구매하기 기능에 사용할 예정 -->
<!-- 특정 회원 정보를 보기 위해 전송 방식을 POST 방식으로 사용하려면 form 태그를 사용해야 함!!
		 POST 방식으로 하려면 form 태그 속에 전달해야할 데이터를 넣고 보내야 함!! -->
<form name="productCodeFrm">
	<input type="hidden" name="productCode"/>
</form>


<!-- 푸터부분 가져오기 -->
<jsp:include page="../footer.jsp"/>
