<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% String ctxPath = request.getContextPath(); %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<link rel="stylesheet" href="<%= ctxPath %>/bootstrap-4.6.2-dist/css/bootstrap.min.css">
<link rel="stylesheet" href="<%= ctxPath %>/css/pay_MS/payMent.css">

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>배송방법 선택</title>
</head>

<body>
<jsp:include page="/WEB-INF/header.jsp" />

<form action="<%= ctxPath %>/payment/paymentSuccess.hp"
      method="post"
      id="payForm">

<div class="container payment-container">

  <!-- ================= 상단 : 받는분 정보 ================= -->
  <div class="payment-top-flex">

    <div class="recipient-info">

      <div class="info-row">
        <span class="info-label"></span>
        <span style="margin-left:auto;font-size:12px;color:#999;">
          결제 페이지 입니다.
        </span>
      </div>
		<div class="info-row two-col">
		  <div class="half">
		    <span class="info-label">받는분 이름</span>
		    <span class="info-value">${loginUser.name}</span>
		  </div>
		  <div class="half">
		    <span class="info-label">전화번호</span>
		    <span class="info-value">${loginUser.mobile}</span>
		  </div>
		</div>

		      <div class="info-row address-row">
		  <span class="info-label">주소</span>
		
		  <div class="address-fields">
		    <div class="address-main">
		      <input type="text"
		             id="address"
		             class="form-control"
		             value="${address}"
		             placeholder="주소 검색을 눌러주세요"
		             readonly>
		
		      <button type="button"
		              class="btn btn-outline-secondary"
		              id="addressSearchBtn">
		        검색
		      </button>
		    </div>
		
		    <input type="text"
		           id="detailAddress"
		           class="form-control"
		           placeholder="상세주소를 입력하세요">
		  </div>
		</div>
      
		<div class="info-row two-col">
		  <div class="half">
		    <span class="info-label">우편번호</span>
		    <input type="text" id="zipcode" class="form-control" readonly>
		  </div>
		
		  <div class="half">
		    <button type="button"
		            id="selectAddressBtn"
		            class="btn btn-outline-secondary w-80">
		      정보 변경 및 배송지 추가
		    </button>
		  </div>
		</div>
		
		<!-- 배송지 선택 -->
		<div class="delivery-radio-group">
		
		  <label class="delivery-radio">
		    <input type="checkbox" name="deliveryType" value="HOME">
		    <span class="circle"></span>
		    <span class="text">Home</span>
		  </label>
		
		  <label class="delivery-radio">
		    <input type="checkbox" name="deliveryType" value="OFFICE">
		    <span class="circle"></span>
		    <span class="text">Office</span>
		  </label>
		
		  <label class="delivery-radio">
		    <input type="checkbox" name="deliveryType" value="SCHOOL">
		    <span class="circle"></span>
		    <span class="text">School</span>
		  </label>
		
		</div>
		
    </div>

  </div>
  <!-- ================= 상단 끝 ================= -->


  <!-- ================= 본문 : 좌 / 우 ================= -->
  <div class="payment-body">

    <!-- ===== 왼쪽 : 상품 목록 ===== -->
    <div class="payment-left">

      <div class="product-section">

        <div class="product-header-row">
          <div class="col-image">상품정보</div>
          <div class="col-name"></div>
          <div class="col-qty">수량</div>
          <div class="col-price">주문금액</div>
        </div>

        <c:forEach var="item" items="${orderList}">
          <div class="product-row">

            <div class="col-image">
              <img src="<%= ctxPath %>/image/product_TH/${item.image_path}"
                   alt="상품 이미지"
                   class="product-image">
            </div>

            <div class="col-name">${item.product_name}</div>
            <div class="col-qty">${item.quantity}</div>

            <div class="col-price">
              <fmt:formatNumber value="${item.total_price}" pattern="#,###"/> 원
            </div>

          </div>
        </c:forEach>

        <div class="product-total-row">
          <span>주문금액</span>
          <span>
            <fmt:formatNumber value="${totalPrice}" pattern="#,###"/> 원
          </span>
        </div>

      </div>
    </div>
    <!-- ===== 왼쪽 끝 ===== -->


    <!-- ===== 오른쪽 : 금액 요약 + 결제 ===== -->
    <div class="payment-right">


      <div class="price-summary">
        <div class="price-row">
          <span>총 상품금액</span>
          <span><fmt:formatNumber value="${totalPrice}" pattern="#,###"/> 원</span>
        </div>
        
        
	<div class="price-row">
			
<select id="couponSelect" class="form-control">
  <option value="">쿠폰 선택</option>

  <c:forEach var="row" items="${couponList}">
    <c:set var="coupon" value="${row.coupon}" />
    <c:set var="issue" value="${row.issue}" />

    <%-- 정액 할인 --%>
    <c:if test="${coupon.discountType == 0}">
      <option value="${issue.couponId}"
              data-discount="${coupon.discountValue}">
        ${coupon.couponName}
        ( <fmt:formatNumber value="${coupon.discountValue}" pattern="#,###"/>원 할인 )
      </option>
    </c:if>

    <%-- 정률 할인 --%>
    <c:if test="${coupon.discountType == 1}">
      <option value="${issue.couponId}"
              data-discount="${totalPrice * coupon.discountValue / 100}">
        ${coupon.couponName}
        ( ${coupon.discountValue}% 할인 )
      </option>
    </c:if>

  </c:forEach>
</select>
		</div>

        <div class="price-row">
          <button type = "button" id="applyCouponBtn">쿠폰 적용금액</button>
           <span id="discountAmount">- 0 원</span>
        </div>
		<input type="hidden" name="couponDiscount" id="couponDiscount" value="0">
		<input type="hidden" id="totalPrice" value="${totalPrice}" />	
		<input type="hidden" id="finalPrice" value="${totalPrice}" />
		<input type="hidden" id="couponId" name="couponId" />
		
        <div class="price-row total">
          <span>총 주문금액</span>
          <span class="amount" id="finalAmount">
            <fmt:formatNumber value="${finalPrice}" pattern="#,###"/> 원
          </span>
        </div>
      </div>
		
		<button class="confirm-btn" id="coinPayBtn">
		 결제하기
		</button>

    </div>
    <!-- ===== 오른쪽 끝 ===== -->

  </div>
  <!-- ================= 본문 끝 ================= -->

</div>

<input type="hidden" name="totalAmount" id="totalAmount" value="${totalPrice}">
<input type="hidden" name="discountAmount" id="discountAmountHidden" value="0">
<input type="hidden" name="deliveryAddress" id="deliveryAddress" value="">
<input type="hidden" name="deliveryTypeSelected" id="deliveryTypeSelected" value="">

</form>


<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="<%= ctxPath %>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js"></script>

<script>
  const ctxpath = '<%= ctxPath %>';
</script>

<script src="<%= ctxPath %>/js/pay_MS/payMent.js"></script>


</body>




</html>