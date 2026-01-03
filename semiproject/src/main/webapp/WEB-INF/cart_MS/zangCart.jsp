<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%String ctxPath = request.getContextPath();%>



<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>



<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="<%= ctxPath %>/bootstrap-4.6.2-dist/css/bootstrap.min.css">
<link rel="stylesheet" href="<%= ctxPath %>/css/cart_MS/zangCart.css">

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>장바구니</title>
    
    
    
    <!-- 헤더부분 가져오기 -->
</head>
    <body>
    
    
    <jsp:include page="/WEB-INF/header.jsp" />
    
     <div class="container">
	
	
    <h4>장바구니</h4>

	<c:if test="${not empty cartList}">
  <div class="cart-empty-wrapper">
    <h4 class="cart-title"></h4>

    <div class="cart-empty">
      주문한 상품이 없습니다.
      <br/><br/>
      <button type="button"
        class="cart-empty-btn"
        onclick="location.href='${pageContext.request.contextPath}/product/productList.hp'">
        상품 보러가기
      </button>
    </div>
  </div>
</c:if>

<c:if test="${empty cartList}">
    <!-- ================= 장바구니 테이블 ================= -->
    <table class="cart-table">
        <thead>
            <tr>
                <th><input type="checkbox" onclick="toggleSelectAll(this)"></th>
                <th>이미지</th>
                <th>상품명</th>
                <th>가격</th>
                <th>수량</th>
                <th>합계</th>
                <th>삭제</th>
            </tr>
        </thead>

        <tbody>

<c:forEach var="cart" items="${cartList}">
    <tr data-cartid="${cart.cart_id}"
    data-price="${cart.price}">
    <!-- data-quantity="${cart.quantity}">  -->

	    <!-- 선택 -->
	    <td>
	        <input type="checkbox"
	               class="item-checkbox"
	               value="${cart.cart_id}">
	    </td>
	
	    <!-- 이미지 -->
	    <td>
	        <img src="<%= ctxPath %>/images/${cart.image_path}"
	             class="product-image">
	    </td>
	
	    <!-- 상품명 -->
	    <td class="product-info">
	        <div class="product-name">
	            ${cart.product_name}
	        </div>
	    </td>
	
	    <!-- 가격 -->
	    <td class="price">
	        <span class="unit-price">${cart.price}</span>원
	    </td>
	
	    <!-- 수량 -->
	    <td>
	        <div class="quantity-control">
	            <button type="button"
	                    class="quantity-btn"
	                    onclick="changeQty(${cart.cart_id}, -1)">−</button>
	
	            <input type="number"
				       class="quantity-input"
				       value="${cart.quantity}"
				       min="1"
				       max="50">
	
	            <button type="button"
	                    class="quantity-btn"
	                    onclick="changeQty(${cart.cart_id}, 1)">+</button>
	        </div>
	    </td>
	
	    <!-- 합계 -->
	    <td class="price">
	        <span class="row-total">${cart.total_price}</span>원
	    </td>
	
	    <!-- 삭제 -->
	    <td>
	        <button type="button"
        	class="btn btn-danger btn-sm btn-delete">
	            삭제
	        </button>
	    </td>
	</tr>
</c:forEach>

</tbody>
    </table>

		    <!-- ================= 요약 영역 ================= -->
		    <div class="summary-section">
		
		        <div class="summary-box">
		            <div class="summary-item">
		                <span>전체 상품 금액</span>
		                <span id="totalProductPrice">0원</span>
		            </div>
		
		            <div class="summary-item">
		                <span>-총 할인 금액</span>
		                <span id="totalDiscount">0원</span>
		            </div>  		
		            <div class="summary-item total">
		                <span>총 주문금액</span>
		                <span id="finalTotal">0원</span>
		            </div>
		
		            <button class="checkout-btn">구매하기</button>
		            <button type="button" id="btnDeleteSelected" class="btn btn-danger my-3">선택삭제</button>
		        </div>
		    </div>
		</c:if>
    
    </div>


	
    <script src="<%= ctxPath %>/js/cart_MS/zangCart.js"></script>
 
</body>
</html>