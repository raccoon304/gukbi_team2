<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%String ctxPath=request.getContextPath();%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- 헤더부분 가져오기 -->
<jsp:include page="../header.jsp"/>

<!-- 사용자 CSS -->
<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/product_TH/productOption.css">

<!-- 사용자 JS 맨 아래단에 추가했음!! -->



<!-- <div class="product-header">
    <h4 class="mb-0"><i class="fas fa-box mr-2"></i>상품 상세 정보</h4>
</div> -->

<!-- 페이지 헤더 -->
<div class="page-header">
    <div class="container">
        <h4 class="mb-0"><i class="fas fa-box mr-2"></i>상품 상세 정보</h4>
        <p class="mb-0">최신 스마트폰을 만나보세요</p>
        
	    <%-- <a href="<%=ctxPath%>/product/TESTproductList.hp" style="font-size: 15pt; font-weight: bold; color: black;">
			<i class="fa-solid fa-list"></i> 테스트상품페이지 가기
		</a> --%>
    </div>
</div>

<div class="container">
    <div class="product-container mt-4">
		

        <div class="product-content">
            <div class="row">
                <!-- 상품 이미지 -->
                <div class="col-md-5">
				  <div class="product-image-section">
				  
				  	<div class="product-image-frame">
					    <img src="<%=ctxPath%>/image/product_TH/${proDto.imagePath}" alt="${proDto.productName}" class="product-image" id="productImage"/>
				    </div>
					
				    <!-- 썸네일은 메인이미지 '바로 아래' 같은 박스 안 plusProductImages-->
				    <div class="thumbs" id="thumbs">
				      <img class="thumb-img active"
				           src="<%=ctxPath%>/image/product_TH/${proDto.imagePath}"
				           data-full="<%=ctxPath%>/image/product_TH/${proDto.imagePath}" />
				     
				      <c:forEach var="plusImage" items="${plusProductImages}">
					      <img class="thumb-img"
					           src="<%=ctxPath%>/image/product_TH/${plusImage}"
					           data-full="<%=ctxPath%>/image/product_TH/${plusImage}" />
				      </c:forEach>
				      
				      <%-- <img class="thumb-img"
				           src="<%=ctxPath%>/image/product_TH/iphone172.png"
				           data-full="<%=ctxPath%>/image/product_TH/iphone172.png" /> --%>
				  	</div> 
				  </div>
				</div>


                <!-- 상품 정보 -->
                <div class="col-md-7">
                    <div class="product-info">
                        <h1 class="product-title" id="productTitle">${proDto.productName}</h1>

                        <div class="product-price">
                            <span id="unitPrice">
                            	<fmt:formatNumber value="${proOptionDto.totalPrice}" pattern="###,###"/>
                            </span><small>원</small>
                        </div>

                        <!-- 상품 스펙 -->
                        <div class="product-specs">
                            <div class="spec-item">
                                <div class="spec-label">브랜드</div>
                                <div class="spec-value">${proDto.brandName}</div>
                            </div>
                            <div class="spec-item">
                                <div class="spec-label">모델명</div>
                                <div class="spec-value">${proDto.productName}</div>
                            </div>
                            
                            
                            <c:set var="storageSet" value="" />
                            <div class="spec-item">
                                <div class="spec-label">저장용량</div>
                                <select class="sort-select form-control" id="sortSelectStorageSize">
                                		<!-- <option value="">용량 선택</option> -->
								    <c:forEach var="opt" items="${proOptionList}">
								        <c:if test="${not fn:contains(storageSet, opt.storageSize)}">
								            <option value="${opt.storageSize}">
								            ${opt.storageSize}
								            <c:if test="${opt.plusPrice > 0}">
								            		<span>&nbsp;+&nbsp;
									            <fmt:formatNumber value="${opt.plusPrice}" pattern="###,###"/>원</span>
								            </c:if>
								            
								            
								            </option>
								            <c:set var="storageSet" value="${storageSet}${opt.storageSize}," />
								        </c:if>
								    </c:forEach>
				                    
				                </select>
                            </div>
                            
                            
                            <c:set var="colorSet" value=""/>
                            <div class="spec-item">
                                <div class="spec-label">색상</div>
                                <select class="sort-select form-control" id="sortSelectColor">
                                		<option value="">색상 선택</option>
								    <c:forEach var="opt" items="${proOptionList}">
								        <c:if test="${not fn:contains(colorSet, opt.color)}">
								            <option value="${opt.color}">${opt.color}</option>
								            <c:set var="colorSet" value="${colorSet}${opt.color}," />
								        </c:if>
								    </c:forEach>
				                </select>
                            </div>
                            
                            
                            <div class="spec-item">
                                <div class="spec-label">재고상태</div>
                                <div class="spec-value">
                                    <span class="badge badge-success badge-stock">
                                        <i class="fas fa-check mr-1"></i>재고 있음 (${proOptionDto.stockQty})
                                    </span>
                                </div>
                            </div>
                        

	                        <!-- 수량 조절 및 가격 -->
	                        <div class="quantity-section" id="quantitySection">
	                            <div class="quantity-control">
	                                <label>수량</label>
	                                <div class="quantity-input-group">
	                                    <button class="quantity-btn" id="decreaseBtn">
	                                        <i class="fas fa-minus"></i>
	                                    </button>
	                                    <!-- 스크립트 단에서 수량 증가/감소된 값이 올라옴! -->
	                                    <input type="number" class="quantity-input" id="quantity" value="1" min="1" max="48" readonly>
	                                    <button class="quantity-btn" id="increaseBtn">
	                                        <i class="fas fa-plus"></i>
	                                    </button>
	                                </div>
	                            </div>
	
	                            <div class="total-price-section">
	                                <span class="total-label">총 상품 금액</span>
	                                <span class="total-price" id="totalPrice">
	                                		<fmt:formatNumber value="${proOptionDto.totalPrice}" pattern="###,###"/>&nbsp;원
	                                </span>
	                            </div>
	                        </div>

	                        <!-- 구매 버튼 영역 -->
	                        <div class="login-required-overlay" id="purchaseArea">
	                            <div class="action-buttons">
	                                <button class="btn btn-cart" id="cartBtn">
	                                    <i class="fas fa-shopping-cart mr-2"></i>장바구니
	                                </button>
	                                <button class="btn btn-purchase" id="purchaseBtn">
	                                    <i class="fas fa-credit-card mr-2"></i>구매하기
	                                </button>
	                            </div>
	
	                            <!-- 로그인 필요 메시지 -->
	                            <div class="login-required-message" id="loginRequiredMsg">
	                                <i class="fas fa-lock"></i>
	                                <p>로그인이 필요한 서비스입니다</p>
	                            </div>
	                        </div>
	
	                        <!-- 리뷰 보기 버튼 -->
	                        <a class="btn btn-review"
							   href="<%=ctxPath%>/review/reviewList.hp?productCode=${proOptionDto.fkProductCode}">
							  <i class="fas fa-star mr-2"></i>구매 리뷰 보기
							</a>
                        
	                    </div>
	                </div>
	            </div>
	
	            <!-- 상품 설명 -->
	            <div class="row desc-row">
	                <div class="col-12">
	                    <h4 class="mb-4"><i class="fas fa-info-circle mr-2"></i>상품 설명</h4>
	                    <div class="product-description">
	                    		<p>${proDto.productDesc}</p>
	                    </div>
	                </div>
	            </div>
            
	        </div>
	        
	    </div>
	</div>
</div>

<script>
    const pageData = { 
    	isLoggedIn: "${loginUser.name}" !== "", 		//사용자가 로그인을 했는지 true/false 값
        loginUserId: "${loginUser.memberid}",  			//장바구니에 보낼 회원아이디
        productCode: "${proOptionDto.fkProductCode}",	//상품코드 
        unitPrice: Number("${proDto.price}")			// 기본금액(상품 초기 설정가격)
   	};

   	// 옵션에 따라 바뀌는 값들은 let
   	let productOptionId = Number("${proOptionDto.optionId}"); //옵션아이디
   	let plusPrice = Number("${plusPrice}");  //512GB에 따른 추가금액
   	let maxStock = Number("${proOptionDto.stockQty}"); // 재고 수량(수량을 증가할 때 재고수량은 넘길 수 없음)
    
    const optionList = [
        <c:forEach var="opt" items="${proOptionList}" varStatus="st">
        {
        		optionId: ${opt.optionId},
            color: "${opt.color}",
            storage: "${opt.storageSize}",
            stock: ${opt.stockQty},
            plusPrice: ${opt.plusPrice}
        }${!st.last ? ',' : ''}
        </c:forEach>
    ];
   	
    const basePrice = ${proDto.price};
</script>

<!-- 사용자 정의 JS -->
<script type="text/javascript" src="<%=ctxPath%>/js/product_TH/productOption.js"></script>



<!-- 푸터부분 가져오기 -->
<jsp:include page="../footer.jsp"/>