<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<div class="od-wrap">

  <!-- 주문 정보 -->
  <div class="od-section">
    <h4 class="od-title">주문 정산</h4>

    <div class="od-row">
      <span>주문 번호</span>
      <span>${order.order_id}</span>
    </div>
    <div class="od-row">
      <span>주문 일시</span>
      <span>${order.order_date}</span>
    </div>
    <div class="od-row">
      <span>총 금액</span>
      <span><fmt:formatNumber value="${order.total_amount}" />원</span>
    </div>
    <div class="od-row">
      <span>할인 금액</span>
      <span><fmt:formatNumber value="${order.discount_amount}" />원</span>
    </div>
    <div class="od-row">
      <span>결제 금액</span>
      <span class="strong">
        <fmt:formatNumber value="${order.final_amount}" />원
      </span>
    </div>
    <div class="od-row">
      <span>주문 상태</span>
      <span class="status">${order.order_status}</span>
    </div>
  </div>

  <!-- 상품 정보 -->
  <div class="od-section">
    <h4 class="od-title">상품 정보</h4>

    <c:forEach var="item" items="${orderDetailList}">
      <div class="od-product">
        <div class="name">${item.product_name}</div>
        <div class="option">
          브랜드: ${item.brand}<br>
          색상: ${item.color} / 용량: ${item.capacity}
        </div>
        <div class="price">
          수량 ${item.quantity} ·
          <fmt:formatNumber value="${item.total_price}" />원
        </div>
      </div>
    </c:forEach>
  </div>

  <!-- 배송 정보 -->
  <div class="od-section">
    <h4 class="od-title">배송 정보</h4>

    <div class="od-row">
      <span>수령인</span>
      <span>${order.receiver}</span>
    </div>
    <div class="od-row">
      <span>연락처</span>
      <span>${order.phone}</span>
    </div>
    <div class="od-row">
      <span>주소</span>
      <span>${order.address}</span>
    </div>
    <div class="od-row">
      <span>배송 상태</span>
      <span>${order.delivery_status}</span>
    </div>
  </div>

</div>
