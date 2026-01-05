<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%String ctxPath = request.getContextPath();%>
    
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
    
<!DOCTYPE html>
<html lang="ko">
<head>
<link rel="stylesheet" href="<%= ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css">
<link rel="stylesheet" href="<%= ctxPath%>/css/pay_MS/payMent.css">

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>배송방법 선택</title>
    <style>
        
    </style>
</head>
<body>
	<jsp:include page="/WEB-INF/header.jsp" />

    <div class="container payment-container">
        <div class="header">
         
        </div>
		
		<!-- 상단 영역 flex wrapper -->
		<div class="payment-top-flex">
		<!--  받는분 정보 -->
         <div class="recipient-info">
        <div class="info-row">
            <span class="info-label"> </span>
            <span style="margin-left:auto;font-size:12px;color:#999;">
                결제 페이지 입니다.
            </span>
        </div>

        <div class="info-row">
            <span class="info-label">받는분 정보</span>
            <span class="info-value">
                ${memberName}, ${mobilePhone}
            </span>
        </div>

        <div class="info-row">
    <span class="info-label">주소</span>

	    <div style="flex:1;">
	        <div style="display:flex; gap:8px;">
	            <!-- 기본주소 (직접 입력 X) -->
	            <input type="text"
	                   id="address"
	                   name="address"
	                   class="form-control"
	                   value="${address}"
	                   placeholder="주소 검색을 눌러주세요"
	                   readonly>
	
	            <!-- 검색 버튼 -->
	            <button type="button"
	                    class="btn btn-outline-secondary"
	                    onclick="execDaumPostcode()">
	                검색
	            </button>
	        </div>
	
	        <!-- 상세주소 -->
	        <input type="text"
	               id="detailAddress"
	               name="detailAddress"
	               class="form-control mt-2"
	               placeholder="상세주소를 입력하세요">
	    </div>
	</div>
    </div>

	    <!-- 금액 정보 -->
	    <div class="price-summary">
	        <div class="price-row">
	            <span>총 상품금액</span>
	            <span>
				  <fmt:formatNumber value="${totalPrice}" pattern="#,###"/> 원
				</span>
	        </div>
	
	        <div class="price-row">
	            <span>쿠폰 할인금액</span>
	            <span>
			     	- <fmt:formatNumber value="${discountPrice}" pattern="#,###"/> 원
			    </span>
	        </div>
	
	        <div class="price-row total">
	            <span>총 주문금액</span>
	            <span class="amount">
	            <fmt:formatNumber value="${finalPrice}" pattern="#,###"/> 원
	            </span>
	        </div>
	    </div>
	</div>
    <button class="confirm-btn"
        onclick="openPaymentPopup('<%=ctxPath%>', '${loginUser}')">
    결제하기
	</button>

	<div class = "produce-row">
    <!-- 상품 목록 -->
    <div class="product-section">
	        <c:forEach var="item" items="${orderList}">
	            <div class="product-item">
	                <img src="<%= ctxPath %>/images/${item.imagePath}"
	                     alt="상품 이미지"
	                     class="product-image">
	
	                <div class="product-details">
	                    <div class="product-name">
	                        ${item.productName}
	                    </div>
	
	                    <div class="product-price-info">
	                        <span class="product-quantity">
							  <fmt:formatNumber value="${item.price}" pattern="#,###"/> x ${item.quantity}
							</span>
	                        <span class="product-price">
							  <fmt:formatNumber value="${item.totalPrice}" pattern="#,###"/>원
							</span>
	                    </div>
	                </div>
	            </div>
	        </c:forEach>
	
	        <div class="subtotal-section">
	            <div class="subtotal-row">
	                <span class="subtotal-label">주문금액</span>
	                <span class="subtotal-amount">
					  ${calcExpr} =
					  <fmt:formatNumber value="${finalPrice}" pattern="#,###"/>
					</span>
	            </div>
	        </div>
	    </div>
	</div>
</div>
<!-- 결제 모달 -->
<div class="modal fade" id="payModal" tabindex="-1" role="dialog">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">결제하기</h5>
        <button type="button" class="close" data-dismiss="modal">
          <span>&times;</span>
        </button>
      </div>

      <div class="modal-body">
        <p>결제를 진행하시겠습니까?</p>
        <p>
            <strong>
                결제 금액 :
                <span id="modalTotalPrice">${finalPrice} 원</span>
            </strong>
        </p>
      </div>

      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
        <button type="button" class="btn btn-primary" onclick="doPay()">결제 진행</button>
      </div>
    </div>
  </div>
</div>

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="<%= ctxPath %>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js"></script>
<script src="<%= ctxPath %>/js/pay_MS/payMent.js"></script>

</body>
</html>