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
</head>
<body>



<!-- 결제 완료 -->
    <div class="container my-5">   <!-- ⭐ 핵심 -->

<%--
결제 완료 페이지이므로
장바구니 데이터는 컨트롤러에서 삭제 처리함
--%>

    <!-- 결제 완료 -->
    <div class="complete-header mb-2 d-flex align-items-center">
        <div class="complete-icon mr-3">✓</div>
        <div class="complete-title">결제 완료</div>
    </div>

    <!-- 배송 정보 -->
    <div class="info-box my-4">
        <p><b>주문번호</b> ${order.order_id}</p>
        <p><b>배송지</b> ${order.delivery_address}</p>
        <p>
		  <b>배송지 유형</b>
		  <c:choose>
		    <c:when test="${deliveryType == 'HOME'}">Home</c:when>
		    <c:when test="${deliveryType == 'OFFICE'}">Office</c:when>
		    <c:when test="${deliveryType == 'SCHOOL'}">School</c:when>
		  </c:choose>
		</p>
    </div>

    <!-- 주문 상품 -->
    <div class="section-title mb-3">주문 상품</div>

    <table class="order-table table bg-white"> <!-- table 추가 -->
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
        <a href="<%=ctxPath%>/order/orderDetail.hp"
           class="btn btn-outline-secondary px-4 py-2 mr-2">
           주문상세 보기
        </a>
        <a href="<%=ctxPath%>/index.hp"
           class="btn btn-warning px-4 py-2 text-white">
           계속 쇼핑하기
        </a>
    </div>

</div>
</body>
</html>