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
    
</head>
    <body>
     <div class="container">

    <h1>장바구니</h1>

    <!-- ================= 장바구니 테이블 ================= -->
    <table class="cart-table">
        <thead>
            <tr>
                <th>
                    <input type="checkbox" onclick="toggleSelectAll(this)">
                </th>
                <th>이미지</th>
                <th>상품명</th>
                <th>가격</th>
                <th>수량</th>
                <th>합계</th>
                <th>삭제</th>
            </tr>
        </thead>

        <tbody>
            <!-- 예시 1개 (나중에 c:forEach로 교체) -->
            <tr>
                <td>
                    <input type="checkbox"
                           class="item-checkbox"
                           value="1"
                           onchange="updateTotal()">
                </td>

                <td>
                    <img src="<%= ctxPath %>/images/sample.png"
                         class="product-image"
                         alt="상품">
                </td>

                <td class="product-info">
                    <div class="product-details">
                        <div class="product-name">장비명</div>
                    </div>
                </td>

                <td class="price">10,000원</td>

                <td>
                    <div class="quantity-control">
                        <button class="quantity-btn" onclick="updateQuantity(1, -1)">-</button>
                        <input type="text" id="quantity-1" class="quantity-input" value="1" readonly>
                        <button class="quantity-btn" onclick="updateQuantity(1, 1)">+</button>
                    </div>
                </td>

                <td id="subtotal-1" class="price">10,000원</td>

                <td>
                    <button class="delete-btn" onclick="deleteItem(1)">삭제</button>
                </td>
            </tr>
        </tbody>
    </table>

    <!-- ================= 요약 영역 ================= -->
    <div class="summary-section">

        <button class="delete-selected" onclick="deleteSelected()">선택삭제</button>

        <div class="summary-box">

            <div class="summary-item">
                <span>전체 상품 금액</span>
                <span id="totalProductPrice">0원</span>
            </div>

            <div class="summary-item">
                <span>총 할인 금액</span>
                <span id="totalDiscount">0원</span>
            </div>

            <div class="summary-item">
                <span>배송비</span>
                <span id="shippingFee">0원</span>
            </div>

            <div class="summary-item total">
                <span>총 주문금액</span>
                <span id="finalTotal">0원</span>
            </div>

            <button class="checkout-btn" onclick="checkout()">구매하기</button>
        </div>
    </div>

</div>
    
    <script>
        // 전체 선택/해제
        function toggleSelectAll(checkbox) {
            const checkboxes = document.querySelectorAll('.item-checkbox');
            checkboxes.forEach(cb => cb.checked = checkbox.checked);
            updateTotal();
        }
        
        // 수량 변경
        function updateQuantity(cartId, change) {
            const input = document.getElementById('quantity-' + cartId);
            let quantity = parseInt(input.value) + change;
            
            if (quantity < 1) quantity = 1;
            
            // AJAX로 서버에 수량 업데이트 요청
            fetch('updateCart.jsp', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: 'cartId=' + cartId + '&quantity=' + quantity
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    input.value = quantity;
                    location.reload();
                }
            });
        }
        
        // 개별 상품 삭제
        function deleteItem(cartId) {
            if (confirm('상품을 삭제하시겠습니까?')) {
                location.href = 'deleteCart.jsp?cartId=' + cartId;
            }
        }
        
        // 선택 상품 삭제
        function deleteSelected() {
            const selected = document.querySelectorAll('.item-checkbox:checked');
            if (selected.length === 0) {
                alert('삭제할 상품을 선택해주세요.');
                return;
            }
            
            if (confirm('선택한 상품을 삭제하시겠습니까?')) {
                const ids = Array.from(selected).map(cb => cb.value).join(',');
                location.href = 'deleteCart.jsp?cartIds=' + ids;
            }
        }
        
        // 합계 금액 업데이트
        function updateTotal() {
            let total = 0;
            const checkboxes = document.querySelectorAll('.item-checkbox:checked');
            
            checkboxes.forEach(cb => {
                const cartId = cb.value;
                const subtotalText = document.getElementById('subtotal-' + cartId).textContent;
                const subtotal = parseInt(subtotalText.replace(/[^0-9]/g, ''));
                total += subtotal;
            });
            
            document.getElementById('totalProductPrice').textContent = total.toLocaleString() + '원';
            document.getElementById('totalDiscount').textContent = '0원';
            document.getElementById('shippingFee').textContent = '0원';
            document.getElementById('finalTotal').textContent = total.toLocaleString() + '원';
        }
        
        // 구매하기
        function checkout() {
            const selected = document.querySelectorAll('.item-checkbox:checked');
            if (selected.length === 0) {
                alert('구매할 상품을 선택해주세요.');
                return;
            }
            
            const ids = Array.from(selected).map(cb => cb.value).join(',');
            location.href = 'checkout.jsp?cartIds=' + ids;
        }
        
        // 페이지 로드 시 합계 계산
        window.onload = function() {
            updateTotal();
        };
    </script>
</body>
</html>