<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%String ctxPath=request.getContextPath();%>
<!-- 사용자 CSS -->
<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/product_TH/productDetail.css">

<!-- 헤더부분 가져오기 -->
<jsp:include page="../header.jsp"/>


<div class="container" style="margin-top: 5%">

	<%-- <h3>확인차 받은 데이터 확인합니다.</h3>
	<p>${proDetilDto.optionId}</p><br>
	<p>${proDetilDto.fkProductCode}</p><br>
	<p>${proDetilDto.color}</p><br>
	<p>${proDetilDto.storageSize}</p><br>
	<p>${proDetilDto.price}</p><br>
	<p>${proDetilDto.stockQty}</p><br>
	<p>${proDetilDto.imagePath}</p><br> --%>


    <div class="product-container mt-4">
        <div class="product-header">
            <h4 class="mb-0"><i class="fas fa-box mr-2"></i>상품 상세 정보</h4>
        </div>

        <div class="product-content">
            <div class="row">
                <!-- 상품 이미지 -->
                <div class="col-md-5">
                    <div class="product-image-section">
                        <img src="${proDetilDto.imagePath}" alt="${proDto.productName}" class="product-image" id="productImage">
                    </div>
                </div>

                <!-- 상품 정보 -->
                <div class="col-md-7">
                    <div class="product-info">
                        <h1 class="product-title" id="productTitle">${proDto.productName}</h1>

                        <div class="product-price">
                            <span id="unitPrice">${proDetilDto.price}</span><small>원</small>
                        </div>

                        <!-- 상품 스펙 -->
                        <div class="product-specs">
                            <div class="spec-item">
                                <div class="spec-label">브랜드</div>
                                <div class="spec-value">${proDto.brandName}</div>
                            </div>
                            <div class="spec-item">
                                <div class="spec-label">모델명</div>
                                <div class="spec-value">${proDto.productName}</div>
                            </div>
                            <div class="spec-item">
                                <div class="spec-label">저장용량</div>
                                <div class="spec-value">${proDetilDto.storageSize}</div>
                            </div>
                            <div class="spec-item">
                                <div class="spec-label">색상</div>
                                <div class="spec-value">${proDetilDto.color}</div>
                            </div>
                            <div class="spec-item">
                                <div class="spec-label">재고상태</div>
                                <div class="spec-value">
                                    <span class="badge badge-success badge-stock">
                                        <i class="fas fa-check mr-1"></i>재고 있음 (${proDetilDto.stockQty})
                                    </span>
                                </div>
                            </div>
                        </div>

                        <!-- 수량 조절 및 가격 -->
                        <div class="quantity-section" id="quantitySection">
                            <div class="quantity-control">
                                <label>수량</label>
                                <div class="quantity-input-group">
                                    <button class="quantity-btn" id="decreaseBtn">
                                        <i class="fas fa-minus"></i>
                                    </button>
                                    <input type="number" class="quantity-input" id="quantity" value="1" min="1" max="48" readonly>
                                    <button class="quantity-btn" id="increaseBtn">
                                        <i class="fas fa-plus"></i>
                                    </button>
                                </div>
                            </div>

                            <div class="total-price-section">
                                <span class="total-label">총 상품 금액</span>
                                <span class="total-price" id="totalPrice">1,590,000원</span>
                            </div>
                        </div>

                        <!-- 구매 버튼 영역 -->
                        <div class="login-required-overlay" id="purchaseArea">
                            <div class="action-buttons">
                                <button class="btn btn-cart" id="cartBtn">
                                    <i class="fas fa-shopping-cart mr-2"></i>장바구니
                                </button>
                                <button class="btn btn-purchase" id="purchaseBtn">
                                    <i class="fas fa-credit-card mr-2"></i>구매하기
                                </button>
                            </div>

                            <!-- 로그인 필요 메시지 -->
                            <div class="login-required-message" id="loginRequiredMsg">
                                <i class="fas fa-lock"></i>
                                <p>로그인이 필요한 서비스입니다</p>
                            </div>
                        </div>

                        <!-- 리뷰 보기 버튼 -->
                        <button class="btn btn-review" id="reviewBtn">
                            <i class="fas fa-star mr-2"></i>구매 리뷰 보기
                        </button>
                    </div>
                </div>
            </div>

            <!-- 상품 설명 -->
            <div class="row mt-5">
                <div class="col-12">
                    <h4 class="mb-4"><i class="fas fa-info-circle mr-2"></i>상품 설명</h4>
                    <div class="product-description">
                    	<p>${proDto.productDesc}</p>
                        <!-- <p><strong>최신 A18 Pro 칩 탑재</strong></p>
                        <p>혁신적인 성능과 전력 효율성을 자랑하는 A18 Pro 칩으로 모든 작업이 빠르고 부드럽습니다.</p>
                        
                        <p class="mt-4"><strong>ProMotion 디스플레이</strong></p>
                        <p>120Hz 주사율의 Super Retina XDR 디스플레이로 생생하고 선명한 화면을 경험하세요.</p>
                        
                        <p class="mt-4"><strong>프로급 카메라 시스템</strong></p>
                        <p>48MP 메인 카메라와 향상된 야간 모드로 어떤 환경에서도 완벽한 사진을 촬영할 수 있습니다.</p>
                        
                        <p class="mt-4"><strong>오래가는 배터리</strong></p>
                        <p>하루 종일 사용 가능한 배터리 성능과 빠른 충전을 지원합니다.</p>
                        
                        <p class="mt-4"><strong>티타늄 디자인</strong></p>
                        <p>견고하면서도 가벼운 티타늄 소재로 프리미엄 디자인을 완성했습니다.</p> -->
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function() {
        // 로그인 상태 변수
        var isLoggedIn = true;
        var unitPrice = 1590000;
        var maxStock = 48;

        // 페이지 로드 시 로그인 상태 확인
        updateLoginStatus();

        // 로그인 상태 업데이트
        function updateLoginStatus() {
            if (isLoggedIn) {
                $('#loginBtn').hide();
                $('#logoutBtn').show();
                $('#userInfo').show();
                $('#loginRequiredMsg').hide();
                $('#quantitySection').removeClass('disabled-section');
            } else {
                $('#loginBtn').show();
                $('#logoutBtn').hide();
                $('#userInfo').hide();
                $('#loginRequiredMsg').show();
                $('#quantitySection').addClass('disabled-section');
            }
        }

        // 수량 증가
        $('#increaseBtn').click(function() {
            if (!isLoggedIn) return;
            
            var currentQty = parseInt($('#quantity').val());
            if (currentQty < maxStock) {
                $('#quantity').val(currentQty + 1);
                updateTotalPrice();
            } else {
                alert('최대 재고 수량입니다.');
            }
        });

        // 수량 감소
        $('#decreaseBtn').click(function() {
            if (!isLoggedIn) return;
            
            var currentQty = parseInt($('#quantity').val());
            if (currentQty > 1) {
                $('#quantity').val(currentQty - 1);
                updateTotalPrice();
            }
        });

        // 총 가격 업데이트
        function updateTotalPrice() {
            var quantity = parseInt($('#quantity').val());
            var total = unitPrice * quantity;
            $('#totalPrice').text(total.toLocaleString() + '원');
        }

        // 장바구니 버튼
        $('#cartBtn').click(function() {
            if (!isLoggedIn) {
                alert('로그인이 필요합니다.');
                $('#loginModal').modal('show');
                return;
            }

            var quantity = $('#quantity').val();
            var total = unitPrice * quantity;
            
            if (confirm(quantity + '개의 상품을 장바구니에 담으시겠습니까?\n총 금액: ' + total.toLocaleString() + '원')) {
                alert('장바구니에 상품이 추가되었습니다!');
                console.log({
                    product: '아이폰 16 Pro Max',
                    quantity: quantity,
                    unitPrice: unitPrice,
                    totalPrice: total
                });
            }
        });

        // 구매하기 버튼
        $('#purchaseBtn').click(function() {
            if (!isLoggedIn) {
                alert('로그인이 필요합니다.');
                $('#loginModal').modal('show');
                return;
            }

            var quantity = $('#quantity').val();
            var total = unitPrice * quantity;
            
            if (confirm('상품을 구매하시겠습니까?\n\n수량: ' + quantity + '개\n총 금액: ' + total.toLocaleString() + '원')) {
                alert('구매가 완료되었습니다!\n주문 내역은 마이페이지에서 확인하실 수 있습니다.');
                console.log({
                    action: '구매하기',
                    product: '아이폰 16 Pro Max',
                    quantity: quantity,
                    unitPrice: unitPrice,
                    totalPrice: total,
                    timestamp: new Date()
                });
            }
        });

        // 리뷰 보기 버튼
        $('#reviewBtn').click(function() {
            // 실제로는 리뷰 페이지로 이동
            if (confirm('상품 리뷰 페이지로 이동하시겠습니까?')) {
                // window.location.href = 'review.html?productId=1';
                alert('리뷰 페이지로 이동합니다.\n(실제로는 review.html?productId=1 으로 이동)');
                console.log('리뷰 페이지 이동: review.html?productId=1');
            }
        });

        // 수량 직접 입력 방지 (readonly 해제 시)
        $('#quantity').on('input', function() {
            var val = parseInt($(this).val());
            if (val < 1) $(this).val(1);
            if (val > maxStock) $(this).val(maxStock);
            updateTotalPrice();
        });

        // 초기 가격 표시
        updateTotalPrice();
    });
</script>

<!-- 푸터부분 가져오기 -->
<jsp:include page="../footer.jsp"/>