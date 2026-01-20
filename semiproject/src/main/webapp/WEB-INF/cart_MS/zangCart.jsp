<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%String ctxPath = request.getContextPath();%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!-- 헤더부분 가져오기 -->
<jsp:include page="../header.jsp" />



<!-- 사용자 CSS -->
<link rel="stylesheet" href="<%= ctxPath %>/css/cart_MS/zangCart.css">

    
<div class="container">
        <c:if test="${empty cartList}">
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

        <c:if test="${not empty cartList}">
            <!-- ================= 장바구니 테이블 ================= -->
            <div id="minsoo">
                <table class="cart-table">
                        <thead>
                            <tr>
                                <th><input type="checkbox" onclick="toggleSelectAll(this)"></th>
                                <th>이미지</th>
                                <th>상품명</th>
                                <th>브랜드명</th>
                                <th>가격</th>
                                <th>색상</th>
                                <th>수량</th>
                                <th>합계</th>
                            </tr>
                        </thead>

                        <tbody>
                            <c:forEach var="cart" items="${cartList}">
                                <tr data-cartid="${cart.cart_id}"
                                    data-unit-price="${cart.unit_price}">

                                    <!-- 선택 -->
                                    <td>
                                        <input type="checkbox"
                                               class="item-checkbox"
                                               value="${cart.cart_id}">
                                    </td>
                                
                                    <!-- 이미지 -->
                                    <td>
                                        <img src="<%= ctxPath %>/image/product_TH/${cart.image_path}"
                                             class="product-image"
                                             alt="${cart.product_name}">
                                    </td>
                                
                                    <!-- 상품명 -->
                                    <td class="product-info">
                                        <div class="product-name">
                                            ${cart.product_name}
                                        </div>
                                        <div class="product-storage">
                                            ${cart.storage_size}
                                        </div>
                                    </td>
                                    
                                    <!-- 브랜드명 -->
                                    <td class="product-brand">
                                        ${cart.brand_name}
                                    </td>
                                    
                                    <!-- 가격 -->
                                    <td class="price">
                                        <span class="unit-price">
                                            <fmt:formatNumber value="${cart.unit_price}" pattern="#,###"/>
                                        </span>원
                                    </td>
                                
                                    <!-- 색상 -->
                                    <td class="color">
                                        <span class="badge badge-light">${cart.color}</span>
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
                                        <span class="row-total">
                                            <fmt:formatNumber value="${cart.total_price}" pattern="#,###"/>
                                        </span>원
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                <!-- 오른쪽: 요약 영역 -->
                <div class="summary-section">
                    <div class="summary-box">            
                        <div class="summary-item total">
                            <span>총 주문금액</span>
                            <span id="finalTotal">0원</span>
                        </div>

                        <button class="checkout-btn btn-info">구매하기</button>
                        <button type="button" id="btnDeleteSelected" class="btn btn-danger my-3">삭제</button>
                    </div>
                </div>

            </div>
        </c:if>
    
</div>

    <!-- 사용자 JS -->
<script src="<%= ctxPath %>/js/cart_MS/zangCart.js"></script>

