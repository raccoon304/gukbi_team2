<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%String ctxPath = request.getContextPath();%>
    
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<link rel="stylesheet" href="<%= ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css">
<link rel="stylesheet" href="<%= ctxPath%>/css/cart_MS/zangCart.css">

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>배송방법 선택</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Malgun Gothic", sans-serif;
            background-color: #f5f5f5;
            padding: 20px;
        }

        .container {
            max-width: 740px;
            margin: 0 auto;
            background-color: white;
            border: 1px solid #ddd;
            border-radius: 8px;
        }

        .header {
            padding: 24px 24px 16px;
            border-bottom: 2px solid #333;
        }

        .header h2 {
            font-size: 18px;
            font-weight: 600;
            color: #333;
        }

        .recipient-info {
            padding: 24px;
            border-bottom: 1px solid #e5e5e5;
        }

        .info-row {
            display: flex;
            align-items: center;
            margin-bottom: 12px;
            font-size: 14px;
        }

        .info-label {
            font-weight: 600;
            color: #333;
            min-width: 80px;
        }

        .info-value {
            color: #666;
        }

        .address-box {
            background-color: #ff9c5c;
            color: white;
            padding: 4px 12px;
            border-radius: 4px;
            display: inline-block;
            margin-left: 8px;
        }

        .change-btn {
            background-color: white;
            border: 1px solid #ddd;
            padding: 4px 12px;
            border-radius: 4px;
            font-size: 12px;
            color: #666;
            cursor: pointer;
            margin-left: 8px;
        }

        .delivery-method {
            padding: 16px 24px;
        }

        .delivery-method-label {
            font-size: 13px;
            color: #666;
            margin-bottom: 8px;
        }

        .price-summary {
            padding: 24px;
            background-color: #fafafa;
            border-top: 1px solid #e5e5e5;
            border-bottom: 1px solid #e5e5e5;
        }

        .price-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 8px;
            font-size: 14px;
            color: #666;
        }

        .price-row.total {
            margin-top: 16px;
            padding-top: 16px;
            border-top: 1px solid #ddd;
            font-size: 16px;
            font-weight: 600;
            color: #333;
        }

        .price-row.total .amount {
            color: #ff6b00;
            font-size: 20px;
        }

        .confirm-btn {
            margin: 24px;
            width: calc(100% - 48px);
            padding: 16px;
            background-color: #7bc141;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
        }

        .confirm-btn:hover {
            background-color: #6db032;
        }

        .delivery-section {
            padding: 24px;
            border-bottom: 1px solid #e5e5e5;
        }

        .delivery-header {
            display: flex;
            align-items: center;
            margin-bottom: 16px;
        }

        .delivery-icon {
            width: 6px;
            height: 6px;
            border-radius: 50%;
            background-color: #333;
            margin-right: 8px;
        }

        .delivery-title {
            font-size: 14px;
            font-weight: 600;
            color: #333;
        }

        .delivery-note {
            font-size: 12px;
            color: #999;
            margin-left: 14px;
        }

        .delivery-date {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 16px;
        }

        .date-badge {
            background-color: #333;
            color: white;
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 13px;
            font-weight: 500;
            white-space: nowrap;
        }

        .date-text {
            font-size: 13px;
            color: #666;
        }

        .delivery-option {
            display: flex;
            align-items: center;
            margin-bottom: 12px;
        }

        .radio-wrapper {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .radio-wrapper input[type="radio"] {
            width: 18px;
            height: 18px;
            cursor: pointer;
        }

        .option-label {
            font-size: 14px;
            color: #333;
        }

        .badge-delivery {
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .badge {
            background-color: #e8f5e9;
            color: #4caf50;
            padding: 2px 8px;
            border-radius: 3px;
            font-size: 11px;
            font-weight: 500;
        }

        .product-section {
            padding: 24px;
        }

        .product-item {
            display: flex;
            gap: 16px;
            align-items: center;
        }

        .product-image {
            width: 60px;
            height: 60px;
            border: 1px solid #e5e5e5;
            border-radius: 4px;
            flex-shrink: 0;
        }

        .product-details {
            flex: 1;
        }

        .product-name {
            font-size: 14px;
            color: #333;
            margin-bottom: 8px;
        }

        .product-price-info {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .product-quantity {
            font-size: 13px;
            color: #999;
        }

        .product-price {
            font-size: 15px;
            font-weight: 600;
            color: #333;
        }

        .subtotal-section {
            margin-top: 24px;
            padding-top: 24px;
            border-top: 1px solid #e5e5e5;
        }

        .subtotal-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .subtotal-label {
            font-size: 14px;
            color: #666;
        }

        .subtotal-amount {
            font-size: 18px;
            font-weight: 600;
            color: #333;
        }

        .change-link {
            color: #666;
            font-size: 12px;
            text-decoration: underline;
            cursor: pointer;
            margin-left: 8px;
        }
    </style>
</head>
<body>
	<jsp:include page="/WEB-INF/header.jsp" />

    <div class="container">
        <div class="header">
            <h2>배송방법 선택</h2>
        </div>

        <div class="recipient-info">
            <div class="info-row">
                <span class="info-label"> </span>
                <span style="margin-left: auto; font-size: 12px; color: #999;">골라 엮요크격</span>
            </div>
            <div class="info-row">
                <span class="info-label">받는분 정보</span>
                <span class="info-value">${RequestScope.name}, ${RequestScope.Mobile_phone}</span>    
            </div>
            <div class="info-row">
                <span class="info-label">주소</span>
                <span class="address-box">${address} </span>
            </div>            
            <div class="info-row">
                <span class="info-label">배송가능정보 </span>
                <span class="info-value">빠른 시일내에 배송하겠습니다 '~'</span>
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

        <div class="delivery-section">
            <div class="delivery-header">
                <span class="delivery-icon"></span>
                <span class="delivery-title">일반배송</span>
            </div>
            <div class="delivery-note">배송비무료 변경 배송메세지입력 반품 수 있습니다</div>
            
            <div class="delivery-date">
                <span class="date-badge">지금 결제시 {}</span>
                <span class="date-text">까지 도착 예정</span>
            </div>

            <div class="delivery-option">
                <div class="radio-wrapper">
                    <input type="radio" name="delivery" id="direct" checked>
                    <label for="direct" class="option-label">
                        <div class="badge-delivery">
                            <span class="badge"></span>
                            <span>{sysdate+1} 오전 7시까지 도착 예정</span>
                        </div>
                    </label>
                </div>
            </div>

            <div class="delivery-option">
                <div class="radio-wrapper">
                    <input type="radio" name="delivery" id="parcel">
                    <label for="parcel" class="option-label">택배배송 {sysdate + 1} 까지 도착 예정</label>
                </div>
            </div>
        </div>

        <div class="product-section">
            <div class="product-item">
                <img src="https://via.placeholder.com/60" alt="상품 이미지" class="product-image">
                <div class="product-details">
                    <div class="product-name">[롯데칠성][구매] 유유히긴 박달국수 20팩 (423g)</div>
                    <div class="product-price-info">
                        <span class="product-quantity">수량 x ${seq}</span>
                        <span class="product-price">17,940</span>
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