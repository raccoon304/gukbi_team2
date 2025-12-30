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
	
	
    <h2>장바구니</h2>

	<c:if test="${empty cartItems}">
    <!-- 장바구니 비어있을 때 -->
    <div class="cart-empty">
        주문한 상품이 없습니다.
        <br/><br/>
        
         <button type="button"
         	class="cart-empty-btn"
                onclick="location.href='<%= request.getContextPath() %>/product/productList.hp'"> 
            상품 보러가기
       </button>
    </div>
</c:if>

<c:if test="${empty cartItems}">
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
            <tr>
                <td>
                    <input type="checkbox" class="item-checkbox" onchange="updateTotal()">
                </td>
                <td>
                    <img src="<%= ctxPath %>/images/sample.png" class="product-image">
                </td>
                <td class="product-info">
                    <div class="product-name">장비명</div>
                </td>
                
                <td class="price">10,000원</td>
                <td>
                
                    <div class="quantity-control">
                        <button class="quantity-btn">-</button>
                        <input type="text" class="quantity-input" value="1" readonly>
                        <button class="quantity-btn">+</button>
                    </div>
                </td>
                <td class="price">10,000원</td>
                <td>
                    <button type="button" class="btn btn-danger">삭제</button>
                </td>
            </tr>
            
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
		            <button type="button" class="btn btn-danger my-3">선택삭제</button>
		        </div>
		    </div>
		</c:if>
    
    </div>


    
    <script> const ctxPath = "<%= request.getContextPath() %>"; </script>
    <script src="<%= ctxPath %>/js/cart_MS/zangCart.js"></script>
 
</body>
</html>