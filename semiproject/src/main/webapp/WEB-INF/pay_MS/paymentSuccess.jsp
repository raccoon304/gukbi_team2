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

    <!-- 결제 완료 -->
    <div class="complete-header mb-2 d-flex align-items-center">
        <div class="complete-icon mr-3">✓</div>
        <div class="complete-title">결제 완료</div>
    </div>
    <p class="text-muted">감사합니다. 결제가 완료되었습니다. 결제 완료 페이지이므로 장바구니에 담겨있는 데이터가 삭제되었기 때문에 실제로는 주문 DAO를 이용 List (CartDTO) cartList =
        cartDao.selectCartListByMember(memberId);

for (CartDTO cart : cartList) {
    orderDetailDao.insertOrderDetail(orderId, cart);
}() --> cartDao.deleteCartByMember(memberId);
    </p>

    <!-- 배송 정보 -->
    <div class="info-box my-4">
        <p><b>주문번호</b> ${orderList[0].order_id}</p>
        <p><b>배송지</b> ${orderList[0].delivery_address}</p>
    </div>

    <!-- 주문 상품 -->
    <div class="section-title mb-3">주문 상품</div>

    <table class="order-table table bg-white"> <!-- table 추가 -->
        <tr>
            <th>상품정보</th>
            <th class="text-center">수량</th>
            <th class="text-center">결제금액</th>
        </tr>

        <c:forEach var="item" items="${orderList}">
            <tr>
                <td>
                    <div class="product-cell d-flex align-items-center">
                        <div class="product-img mr-3"></div>
                        <div class="product-info">
                            <div class="name font-weight-bold">${item.product_name}</div>
                            <div class="text-muted">${item.brand_name}</div>
                        </div>
                    </div>
                </td>
                <td class="text-center">${item.quantity}개</td>
                <td class="text-center">
                    <fmt:formatNumber value="${item.unit_price * item.quantity}" />원
                </td>
            </tr>
        </c:forEach>
    </table>

    <!-- 결제 요약 -->
    <div class="summary-box my-4">
        <p>
            주문금액 <fmt:formatNumber value="${orderList[0].total_amount}" />원
            − 할인금액 <fmt:formatNumber value="${orderList[0].discount_amount}" />원
        </p>
        <p class="final">
            실결제금액
            <fmt:formatNumber value="${orderList[0].total_amount - orderList[0].discount_amount}" />원
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