<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!-- header.jsp (수정 금지) -->
<jsp:include page="/WEB-INF/header.jsp" />

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/member_YD/myPage.css" />

<style>
  	/* 이미지 느낌의 카드 스타일 */
  	.order-list-wrap { border-radius: .75rem; }
  	.order-card {
    	border: 1px solid #e9ecef;
    	border-radius: .5rem;
  	}
  	.order-title { font-size: 18px; font-weight: 700; }
  	.order-subtitle { font-size: 12px; color: #6c757d; }

  	.total-text { font-size: 13px; color: #6c757d; }
  	.total-price { font-weight: 700; color: #212529; }
  	.view-details { font-size: 13px; font-weight: 600; cursor: pointer; }

  	/* 부드러운 pill badge */
  	.badge-soft-success {
    	background: rgba(40,167,69,.12);
	    color: #1e7e34;
	    border: 1px solid rgba(40,167,69,.18);
	    padding: .28rem .6rem;
	    border-radius: 999px;
	    font-size: 11px;
	    font-weight: 700;
  	}
  	.badge-soft-primary {
	    background: rgba(0,123,255,.12);
	    color: #0056b3;
	    border: 1px solid rgba(0,123,255,.18);
	    padding: .28rem .6rem;
	    border-radius: 999px;
	    font-size: 11px;
	    font-weight: 700;
  	}
  	.badge-soft-secondary {
	    background: rgba(108,117,125,.12);
	    color: #495057;
	    border: 1px solid rgba(108,117,125,.18);
	    padding: .28rem .6rem;
	    border-radius: 999px;
	    font-size: 11px;
	    font-weight: 700;
  	}

    /* ===== Modal (Bootstrap 없이 직접) ===== */
    .yd-modal-backdrop {
        position: fixed; inset: 0;
        background: rgba(0,0,0,.5);
        display: none;
        align-items: center;
        justify-content: center;
        z-index: 1050;
        padding: 1rem;
    }
    .yd-modal {
        width: 100%;
        max-width: 900px;
        background: #fff;
        border-radius: .75rem;
        overflow: hidden;
        box-shadow: 0 10px 30px rgba(0,0,0,.2);
        max-height: 90vh;
        display: flex;
        flex-direction: column;
    }
    .yd-modal-header {
        padding: 1rem 1.25rem;
        border-bottom: 1px solid #e9ecef;
        display: flex;
        align-items: center;
        justify-content: space-between;
    }
    .yd-modal-title {
        font-size: 18px;
        font-weight: 700;
        margin: 0;
    }
    .yd-modal-close {
        background: transparent;
        border: 0;
        font-size: 22px;
        line-height: 1;
        color: #6c757d;
        cursor: pointer;
    }
    .yd-modal-body {
        padding: 1.25rem;
        overflow: auto;
    }
    .yd-modal-footer {
        padding: 1rem 1.25rem;
        border-top: 1px solid #e9ecef;
        display: flex;
        justify-content: flex-end;
        gap: .5rem;
        background: #fff;
    }
    .yd-section-title {
        font-weight: 700;
        font-size: 16px;
        margin-bottom: .75rem;
    }
    .yd-box {
        background: #f8f9fa;
        border: 1px solid #e9ecef;
        border-radius: .5rem;
        padding: 1rem;
    }
    .yd-kv {
        display: grid;
        grid-template-columns: 160px 1fr;
        gap: .35rem .75rem;
        font-size: 14px;
    }
    .yd-kv .k { color: #6c757d; }
    .yd-item {
        padding: .9rem 0;
        border-bottom: 1px solid #e9ecef;
        display: grid;
        grid-template-columns: 1fr auto;
        gap: .5rem;
        align-items: start;
        font-size: 14px;
    }
    .yd-item:last-child { border-bottom: 0; }
    .yd-item-name { font-weight: 700; }
    .yd-item-opt { color: #6c757d; font-size: 13px; }
    .yd-item-price { font-weight: 700; }
    .yd-loading { color: #6c757d; font-size: 14px; }
</style>

<div class="container my-5">
	<div class="row">

	    <!-- 사이드바 -->
	    <div class="col-md-3 mb-4">
	    	<div class="card shadow-sm position-sticky" style="top: 100px;">
	        	<div class="card-body text-center">
	          		<h5 class="font-weight-bold mb-1">
	            		<c:out value="${memberInfo.name}" />
	          		</h5>
	          		<small class="text-muted">
	            		<c:out value="${memberInfo.memberid}" />
	          		</small>
	        	</div>

	        	<div class="list-group list-group-flush">
	         	 	<a href="${pageContext.request.contextPath}/myPage/myPage.hp" class="list-group-item list-group-item-action">
	            		<i class="fa-regular fa-user mr-2"></i> 내 정보
	          		</a>

	          		<a href="${pageContext.request.contextPath}/myPage/orders.hp" class="list-group-item list-group-item-action active">
	            		<i class="fa-solid fa-bag-shopping mr-2"></i> 주문내역
	          		</a>

	        		<a href="${pageContext.request.contextPath}/myPage/delivery.hp" class="list-group-item list-group-item-action">
	            		<i class="fa-solid fa-truck mr-2"></i> 배송지 관리
	          		</a>
	        	</div>
	      	</div>
	    </div>

	    <!-- 메인 컨텐츠 -->
	    <div class="col-md-9">
	      	<div class="card shadow-sm order-list-wrap">
	        	<div class="card-body">

	          		<div class="mb-4">
	            		<div class="order-title">Order History</div>
	          		</div>

	          		<!-- 주문 없을 때 -->
	          		<c:if test="${empty orderList}">
	            		<div class="text-center py-5 text-muted">주문내역이 없습니다.</div>
	          		</c:if>

	          		<!-- 주문 있을 때 -->
	          		<c:if test="${not empty orderList}">
	            		<c:forEach var="order" items="${orderList}">
	              			<div class="order-card p-4 mb-3">

	                			<!-- 상단 -->
	                			<div class="d-flex justify-content-between align-items-start">
	                  				<div>
	                    				<div class="font-weight-bold"> Order #<c:out value="${order.orderId}" /> </div>
	                    				<div class="order-subtitle">Placed on <c:out value="${order.orderDate}" /></div>
	                  				</div>

	                				<div>
	                    				<c:choose>
										    <c:when test="${order.orderStatus eq 'READY'}">
										        <span class="badge-soft-secondary">준비중</span>
										    </c:when>
										    <c:when test="${order.orderStatus eq 'SHIPPING'}">
										        <span class="badge-soft-primary">배송중</span>
										    </c:when>
										    <c:when test="${order.orderStatus eq 'DONE'}">
										        <span class="badge-soft-success">완료</span>
										    </c:when>
										    <c:otherwise>
										        <span class="badge-soft-secondary"><c:out value="${order.orderStatus}" /></span>
										    </c:otherwise>
										</c:choose>
				                  	</div>
			                	</div>

				                <!-- 하단 -->
				                <div class="d-flex justify-content-between align-items-center mt-4">
			                  		<div class="total-text"> Total:
				                    	<span class="total-price">
				                      		$<fmt:formatNumber value="${order.totalAmount}" type="number" minFractionDigits="2" maxFractionDigits="2" />
			                    		</span>
				                  	</div>

									<button type="button"
                                            class="btn btn-link p-0 view-details js-open-order-modal"
                                            data-orderid="${order.orderId}">
				                    	View Details
				                  	</button>
				                </div>

	              			</div>
	            		</c:forEach>
	          		</c:if>

	       		</div>
	      	</div>
	   	</div>
	</div>
</div>

<!-- =================== 주문 상세 모달 =================== -->
<div id="ydOrderModalBackdrop" class="yd-modal-backdrop" aria-hidden="true">
    <div class="yd-modal" role="dialog" aria-modal="true" aria-labelledby="ydModalTitle">
        <div class="yd-modal-header">
            <h3 class="yd-modal-title" id="ydModalTitle">Order Details</h3>
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
    // ✅ JSP EL을 JS 문자열로 안전하게 받음
    const ctxPath = "${pageContext.request.contextPath}";
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

    function mapStatusText(status) {
        if (!status) return "-";
        if (status === "READY") return "준비중";
        if (status === "SHIPPING") return "배송중";
        if (status === "DONE") return "완료";
        return status;
    }

    function fmtMoney(amount) {
        if (amount === null || amount === undefined || amount === "") return "-";
        const n = Number(amount);
        if (Number.isNaN(n)) return String(amount);
        return "$" + n.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 });
    }

    function safeText(v, fallback) {
        if (v === null || v === undefined || v === "") return (fallback ? fallback : "-");
        return String(v);
    }

    function fillModal(data) {
        // 제목
        document.getElementById("ydModalTitle").textContent = "Order #" + safeText(data.orderId, "-");

        document.getElementById("mOrderNo").textContent = safeText(data.orderId, "-");
        document.getElementById("mOrderDate").textContent = safeText(data.orderDate, "-");
        document.getElementById("mOrderTotal").textContent = fmtMoney(data.totalAmount);
        document.getElementById("mOrderStatus").textContent = mapStatusText(data.orderStatus);

        // items
        const itemsWrap = document.getElementById("mItemsWrap");
        itemsWrap.innerHTML = "";

        if (data.items && data.items.length > 0) {
            for (let i = 0; i < data.items.length; i++) {
                const item = data.items[i];

                const div = document.createElement("div");
                div.className = "yd-item";

                const left = document.createElement("div");
                left.innerHTML =
                    '<div class="yd-item-name">' + safeText(item.productName, '-') + '</div>' +
                    '<div class="yd-item-opt">' +
                        '색상: ' + safeText(item.color, '-') + ' / 용량: ' + safeText(item.storage, '-') + '<br/>' +
                        '수량: ' + safeText(item.qty, '-') +
                    '</div>';

                const right = document.createElement("div");
                right.className = "yd-item-price";
                right.textContent = fmtMoney(item.price);

                div.appendChild(left);
                div.appendChild(right);
                itemsWrap.appendChild(div);
            }
        } else {
            itemsWrap.innerHTML = '<div class="text-muted">상품 정보가 없습니다.</div>';
        }

        // shipping
        const ship = data.shipping ? data.shipping : {};
        document.getElementById("mRecipient").textContent = safeText(ship.recipient, "-");
        document.getElementById("mPhone").textContent = safeText(ship.phone, "-");
        document.getElementById("mAddress").textContent = safeText(ship.address, "-");

        // Tracking Number: READY면 "준비중"
        const status = data.orderStatus;
        const tracking = ship.trackingNumber;
        if (status === "READY") {
            document.getElementById("mTracking").textContent = "준비중";
        } else {
            document.getElementById("mTracking").textContent = tracking ? tracking : "-";
        }
    }

    async function loadOrderDetail(orderId) {
        loadingEl.style.display = "block";
        loadingEl.textContent = "불러오는 중...";
        contentEl.style.display = "none";
        contentEl.innerHTML = "";

        try {
            const url = "${pageContext.request.contextPath}" + "/myPage/orderDetailFragment.hp?orderNo=" + encodeURIComponent(orderId);
            console.log("FETCH URL =>", url);
            console.log("orderId =>", orderId);

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

<!-- footer.jsp (수정 금지) -->
<jsp:include page="/WEB-INF/footer.jsp" />
