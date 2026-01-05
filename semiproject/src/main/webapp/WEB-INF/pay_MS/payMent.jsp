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
            <input type="text"
                   id="address"
                   class="form-control"
                   value="${address}"
                   placeholder="주소 검색을 눌러주세요"
                   readonly>
            <button type="button"
                    class="btn btn-outline-secondary"
                    onclick="execDaumPostcode()">
              검색
            </button>
          </div>

          <input type="text"
                 id="detailAddress"
                 class="form-control mt-2"
                 placeholder="상세주소를 입력하세요">
        </div>
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
              <img src="<%= ctxPath %>/images/${item.image_path}"
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
            <fmt:formatNumber value="${finalPrice}" pattern="#,###"/> 원
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
          <span>쿠폰 할인금액</span>
          <span>- <fmt:formatNumber value="${discountPrice}" pattern="#,###"/> 원</span>
        </div>

        <div class="price-row total">
          <span>총 주문금액</span>
          <span class="amount">
            <fmt:formatNumber value="${finalPrice}" pattern="#,###"/> 원
          </span>
        </div>
      </div>

      <button class="confirm-btn"
              onclick="openPaymentPopup('<%=ctxPath%>', '${loginUser}')">
        결제하기
      </button>

    </div>
    <!-- ===== 오른쪽 끝 ===== -->

  </div>
  <!-- ================= 본문 끝 ================= -->

</div>


<!-- ================= 결제 모달 ================= -->
<div class="modal fade" id="payModal" tabindex="-1">
  <div class="modal-dialog modal-dialog-centered">
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
            <span id="modalTotalPrice">
              <fmt:formatNumber value="${finalPrice}" pattern="#,###"/> 원
            </span>
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