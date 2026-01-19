<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%String ctxPath = request.getContextPath();%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="<%= ctxPath %>/bootstrap-4.6.2-dist/css/bootstrap.min.css">
<link rel="stylesheet" href="<%= ctxPath %>/css/pay_MS/payMentSuccess.css">
<link rel="stylesheet" href="<%= ctxPath %>/css/pay_MS/payMentSuccessModal.css">

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>

<!-- 결제 완료 -->
<div class="container my-5">

    <!-- 결제 완료 -->
    <div class="complete-header mb-2 d-flex align-items-center">
        <div class="complete-icon mr-3">✓</div>
        <div class="complete-title">결제 완료</div>
    </div>

    <!-- 배송 정보 -->
    <div class="info-box my-4">
        <p><b>주문번호</b> ${order.order_id}</p>
        <p><b>배송지</b> ${order.delivery_address}</p>
    </div>

    <!-- 주문 상품 -->
    <div class="section-title mb-3">주문 상품</div>

    <table class="order-table table bg-white">
        <tr>
            <th>상품정보</th>
            <th class="text-center">옵션</th>
            <th class="text-center">수량</th>
            <th class="text-center">결제금액</th>
        </tr>

        <c:forEach var="item" items="${orderDetailList}">
            <tr>
                <td>
                    <div class="product-cell d-flex align-items-center">
                    
                         <img src="<%=ctxPath%>/image/product_TH/${item.image_path}" 
	                         alt="${item.product_name}"
	                         class="product-img"
	                         onerror="this.src='<%=ctxPath%>/image/no-image.png'">
                        
                        <div class="product-info">
                            <div class="name font-weight-bold">${item.product_name}</div>
                        </div>
                    </div>
                </td>
                <td class="text-center">
	                <div style="font-size: 13px; line-height: 1.5;">
	                    <div>브랜드: ${item.brand}</div>
	                    <div>색상: ${item.color}</div>
	                    <div>용량: ${item.capacity}</div>
	                </div>
                </td>
                <td class="text-center">${item.quantity}개</td>          
                <td class="text-center">
                    <fmt:formatNumber value="${item.total_price}" />원
                </td>
            </tr>
        </c:forEach>
    </table>

    <!-- 결제 요약 -->
    <div class="summary-box my-4">
        <p>
            주문금액 <fmt:formatNumber value="${order.total_amount}" />원
            − 할인금액 <fmt:formatNumber value="${order.discount_amount}" />원
        </p>
        <p class="final">
            실제금액
            <fmt:formatNumber value="${order.final_amount}" />원
        </p>
    </div>

    <!-- 버튼 -->
    <div class="btn-area text-center mt-5">
        <button type="button" 
                class="btn btn-outline-secondary px-4 py-2 mr-2 js-open-order-modal">
           주문상세 보기
        </button>
        <a href="<%=ctxPath%>/index.hp"
           class="btn btn-warning px-4 py-2 text-white">
           계속 쇼핑하기
        </a>
    </div>

</div>

<!-- =================== 주문 상세 모달 =================== -->
<div id="ydOrderModalBackdrop" class="yd-modal-backdrop" aria-hidden="true">
    <div class="yd-modal" role="dialog" aria-modal="true" aria-labelledby="ydModalTitle">
        <div class="yd-modal-header">
            <h3 class="yd-modal-title" id="ydModalTitle">주문 내역 상세</h3>
            <button type="button" class="yd-modal-close js-close-order-modal" aria-label="Close">&times;</button>
        </div>

        <div class="yd-modal-body">
            <div id="ydModalContent"></div>
        </div>

        <div class="yd-modal-footer">
            <button type="button" class="btn btn-secondary js-close-order-modal">닫기</button>
        </div>
    </div>
</div>

<script>
(function() {
    const backdrop = document.getElementById("ydOrderModalBackdrop");
    const contentEl = document.getElementById("ydModalContent");

    // 페이지에 이미 있는 데이터를 JavaScript 객체로 변환
    const orderData = {
        order_id: "${order.order_id}",
        order_date: "${order.order_date}",
        total_amount: ${order.total_amount},
        discount_amount: ${order.discount_amount},
        final_amount: ${order.final_amount},
        order_status: "${order.order_status}",
        delivery_address: "${order.delivery_address}"
    };

    const orderItems = [
        <c:forEach var="item" items="${orderDetailList}" varStatus="status">
        {
            product_name: "${item.product_name}",
            brand: "${item.brand}",
            color: "${item.color}",
            capacity: "${item.capacity}",
            quantity: ${item.quantity},
            total_price: ${item.total_price},
            image_path: "${item.image_path}"
        }<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];

    function openModal() {
        backdrop.style.display = "flex";
        backdrop.setAttribute("aria-hidden", "false");
        document.body.style.overflow = "hidden";
    }

    function closeModal() {
        backdrop.style.display = "none";
        backdrop.setAttribute("aria-hidden", "true");
        document.body.style.overflow = "";
    }

    function renderOrderDetail() {
        let html = '<div class="od-wrap">';
        
        // 주문 정보 섹션
        html += '<div class="od-section">';
        html += '<h4 class="od-title">주문 정산</h4>';
        html += '<div class="od-row"><span>주문 번호</span><span>' + orderData.order_id + '</span></div>';
        html += '<div class="od-row"><span>주문 일시</span><span>' + orderData.order_date + '</span></div>';
        html += '<div class="od-row"><span>총 금액</span><span>' + orderData.total_amount.toLocaleString() + '원</span></div>';
        html += '<div class="od-row"><span>할인 금액</span><span>' + orderData.discount_amount.toLocaleString() + '원</span></div>';
        html += '<div class="od-row"><span>결제 금액</span><span class="strong">' + orderData.final_amount.toLocaleString() + '원</span></div>';
        html += '<div class="od-row"><span>주문 상태</span><span class="status">' + orderData.order_status + '</span></div>';
        html += '</div>';
        
        // 상품 정보 섹션
        html += '<div class="od-section">';
        html += '<h4 class="od-title">상품 정보</h4>';
        orderItems.forEach(function(item) {
            html += '<div class="od-product">';
            
            html += '<img src="<%=ctxPath%>/image/product_TH/' + item.image_path + '" ';
            html += 'alt="' + item.product_name + '" ';
            html += 'style="width:60px; height:60px; border-radius:8px; margin-bottom:10px;">';
            
            html += '<div class="name">' + item.product_name + '</div>';
            html += '<div class="option">브랜드: ' + item.brand + '<br>색상: ' + item.color + ' / 용량: ' + item.capacity + '</div>';
            html += '<div class="price">수량 ' + item.quantity + ' · ' + item.total_price.toLocaleString() + '원</div>';
            html += '</div>';
        });
        html += '</div>';
        
        // 배송 정보 섹션
        html += '<div class="od-section">';
        html += '<h4 class="od-title">배송 정보</h4>';
        html += '<div class="od-row"><span>배송지</span><span>' + orderData.delivery_address + '</span></div>';
        html += '</div>';
        
        html += '</div>';
        
        contentEl.innerHTML = html;
    }

    // 클릭 이벤트
    document.addEventListener("click", function(e) {
        if (e.target.closest(".js-open-order-modal")) {
            e.preventDefault();
            openModal();
            renderOrderDetail();
            return;
        }

        if (e.target.closest(".js-close-order-modal")) {
            closeModal();
            return;
        }

        if (e.target === backdrop) {
            closeModal();
        }
    });

    // ESC 키로 닫기
    document.addEventListener("keydown", function(e) {
        if (e.key === "Escape" && backdrop.style.display === "flex") {
            closeModal();
        }
    });
})();
</script>

</body>
</html>