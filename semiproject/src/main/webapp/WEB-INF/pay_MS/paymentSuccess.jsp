<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%String ctxPath = request.getContextPath();%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="<%= ctxPath %>/bootstrap-4.6.2-dist/css/bootstrap.min.css">
<link rel="stylesheet" href="<%= ctxPath %>/css/pay_MS/payMentSuccess.css">

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <style>
        /* 페이지 배경 */
	        	 
		    </style>
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
            <th class="text-center">수량</th>
            <th class="text-center">결제금액</th>
        </tr>

        <c:forEach var="item" items="${orderDetailList}">
            <tr>
                <td>
                    <div class="product-cell d-flex align-items-center">
                        <div class="product-img mr-3"></div>
                        <div class="product-info">
                            <div class="name font-weight-bold">${item.product_name}</div>
                        </div>
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
                class="btn btn-outline-secondary px-4 py-2 mr-2 js-open-order-modal"
                data-orderid="${order.order_id}">
           주문상세 보기
        </button>
        <a href="<%=ctxPath%>/index.hp"
           class="btn btn-warning px-4 py-2 text-white">
           계속 쇼핑하기
        </a>
    </div>

</div>

<!-- =================== 주문 상세 모달 (마이페이지와 동일) =================== -->
<div id="ydOrderModalBackdrop" class="yd-modal-backdrop" aria-hidden="true">
    <div class="yd-modal" role="dialog" aria-modal="true" aria-labelledby="ydModalTitle">
        <div class="yd-modal-header">
            <h3 class="yd-modal-title" id="ydModalTitle">주문 내역 상세</h3>
            <button type="button" class="yd-modal-close js-close-order-modal" aria-label="Close">&times;</button>
        </div>

        <div class="yd-modal-body">
            <div id="ydModalLoading" class="yd-loading">불러오는 중...</div>
            <div id="ydModalContent" style="display:none;"></div>
        </div>

        <div class="yd-modal-footer">
            <button type="button" class="btn btn-secondary js-close-order-modal">닫기</button>
        </div>
    </div>
</div>

<script>
(function() {
    const ctxPath = "<%=ctxPath%>";
    const backdrop = document.getElementById("ydOrderModalBackdrop");
    const loadingEl = document.getElementById("ydModalLoading");
    const contentEl = document.getElementById("ydModalContent");

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

    async function loadOrderDetail(orderId) {
        loadingEl.style.display = "block";
        loadingEl.textContent = "불러오는 중...";
        contentEl.style.display = "none";
        contentEl.innerHTML = "";

        try {
            const url = ctxPath + "/myPage/orderDetailFragment.hp?orderNo=" + encodeURIComponent(orderId);
  //        console.log("FETCH URL =>", url);
  //        console.log("orderId =>", orderId);

            const res = await fetch(url, {
                method: "GET",
                headers: { "X-Requested-With": "XMLHttpRequest" }
            });

            if (!res.ok) throw new Error("HTTP " + res.status);

            const html = await res.text();
            contentEl.innerHTML = html;

            loadingEl.style.display = "none";
            contentEl.style.display = "block";
        } catch (err) {
            loadingEl.style.display = "block";
            loadingEl.textContent = "상세 정보를 불러오지 못했습니다. (" + err.message + ")";
        }
    }

    // 클릭 이벤트 위임
    document.addEventListener("click", function(e) {
        const btn = e.target.closest(".js-open-order-modal");
        if (btn) {
            e.preventDefault();
            const orderId = btn.getAttribute("data-orderid");
            openModal();
            loadOrderDetail(orderId);
            return;
        }

        if (e.target.closest(".js-close-order-modal")) {
            closeModal();
            return;
        }

        // 바깥 클릭 닫기
        if (e.target === backdrop) {
            closeModal();
        }
    });

    // ESC 닫기
    document.addEventListener("keydown", function(e) {
        if (e.key === "Escape" && backdrop.style.display === "flex") {
            closeModal();
        }
    });
})();
</script>

</body>
</html>
