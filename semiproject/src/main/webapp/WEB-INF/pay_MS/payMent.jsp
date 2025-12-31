<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%String ctxPath = request.getContextPath();%>
    
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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

    <div class="container">
        <div class="header">
         
        </div>

        <div class="recipient-info">
            <div class="info-row">
                <span class="info-label"> </span>
                <span style="margin-left: auto; font-size: 12px; color: #999;">결제 페이지 입니다.</span>
            </div>
            <div class="info-row">
                <span class="info-label">받는분 정보</span>
                <span class="info-value">${RequestScope.name}, ${RequestScope.Mobile_phone}</span>    
            </div>
            <div class="info-row">
                <span class="info-label">주소</span>
                <span class="address-box">${address} </span>
            </div>                      
        </div>

        <div class="price-summary">
            <div class="price-row">
                <span>총 상품금액</span>
                <span>23,940 원</span>
            </div>
            <div class="price-row">
                <span>쿠폰 할인금액</span>
                <span>- 6,000 원</span>
            </div>
            <div class="price-row total">
                <span>총 주문금액</span>
                <span class="amount">17,940원</span>
            </div>
        </div>

        <button class="confirm-btn">결제하기</button>
       
        <div class="product-section">
            <div class="product-item">
                <img src="https://via.placeholder.com/60" alt="상품 이미지" class="product-image">
                <div class="product-details">
                    <div class="product-name">[롯데칠성][구매] 유유히긴 박달국수 20팩 (423g)</div>
                    <div class="product-price-info">
                        <span class="product-quantity">수량 x ${seq}</span>
                        <span class="product-price">${price}</span>
                    </div>
                </div>
            </div>

            <div class="subtotal-section">
                <div class="subtotal-row">
                    <span class="subtotal-label">주문금액</span>
                    <span class="subtotal-amount"></span>
                </div>
            </div>
        </div>
    </div>
</body>
</html>