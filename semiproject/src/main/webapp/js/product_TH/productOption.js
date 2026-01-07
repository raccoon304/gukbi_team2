
$(document).ready(function () {
    /* =======================
       🔹 전역 상태 변수
    ======================= */
    const { isLoggedIn, productCode, unitPrice, plusPrice, maxStock } = pageData;
	//const defaultPrice = unitPrice;
	
    let quantity = parseInt($('#quantity').val()) || 1; //기본 수량
    let totalPrice = 0;  //총 금액
    let selectStorageSize = "";  //선택한 용량
    let selectedColor = "";  //선택한 색깔

    /* =======================
       🔹 초기 실행
    ======================= */
    updateLoginStatus();  //로그인상태
    updateTotalPrice();  //금액업데이트(수량 증가/감소)

	
    /* =======================
       🔹 공통 함수
    ======================= */
	//로그인 처리
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

    function updateTotalPrice() {
        totalPrice = unitPrice * quantity;
        $('#totalPrice').text(totalPrice.toLocaleString() + '원');
    }

	// 수량 입력값을 검증·보정하고, 총 금액을 다시 계산
	function syncQuantity() {
	    let inputVal = parseInt($('#quantity').val(), 10);

	    if (isNaN(inputVal) || inputVal < 1) inputVal = 1;
	    if (inputVal > maxStock) inputVal = maxStock;

	    quantity = inputVal;
	    $('#quantity').val(quantity);
	    updateTotalPrice();
	}

    /* =======================
       🔹 수량 컨트롤
    ======================= */

	// 수량 증가
	$('#increaseBtn').click(function () {
	    if (!isLoggedIn) return;

	    if (quantity < maxStock) {
	        quantity++;
	        $('#quantity').val(quantity);
	        updateTotalPrice();
	    } else {
	        alert('최대 재고 수량입니다.');
	    }
	});
	// 수량 감소
	$('#decreaseBtn').click(function () {
	    if (!isLoggedIn) return;

	    if (quantity > 1) {
	        quantity--;
	        $('#quantity').val(quantity);
	        updateTotalPrice();
	    }
	});
	
    $('#quantity').on('input', function () {
        syncQuantity();
    });

    /* =======================
       🔹 옵션 선택
    ======================= */

    $('#sortSelectStorageSize').change(function () {
        selectStorageSize = $(this).val();
    });

    $('#sortSelectColor').change(function () {
        selectedColor = $(this).val();
    });

    /* =======================
       🔹 장바구니
    ======================= */
    $('#cartBtn').click(function () {
        if (!isLoggedIn) {
            alert('로그인이 필요합니다.');
            $('#loginModal').modal('show');
            return;
        }

        if (confirm(
            quantity + '개의 상품을 장바구니에 담으시겠습니까?\n' +
            '총 금액: ' + totalPrice.toLocaleString() + '원'
        )) {
            alert('장바구니에 상품이 추가되었습니다!');
            console.log({
                productCode,
                quantity,
                unitPrice,
                totalPrice,
                storage: selectStorageSize,
                color: selectedColor
            });
        }
    });

    /* =======================
       🔹 구매하기
    ======================= */
    $('#purchaseBtn').click(function () {
        if (!isLoggedIn) {
            alert('로그인이 필요합니다.');
            $('#loginModal').modal('show');
            return;
        }

        if (confirm(
            '상품을 구매하시겠습니까?\n' +
            '수량: ' + quantity + '개\n' +
            '총 금액: ' + totalPrice.toLocaleString() + '원'
        )) {
            alert('구매가 완료되었습니다!');
            console.log({
                action: 'purchase',
                productCode,
                quantity,
                unitPrice,
                totalPrice,
                storage: selectStorageSize,
                color: selectedColor,
                timestamp: new Date()
            });
        }
    });

    /* =======================
       🔹 리뷰
    ======================= */
    $('#reviewBtn').click(function () {
        if (confirm('상품 리뷰 페이지로 이동하시겠습니까?')) {
            console.log({
                productCode,
                storage: selectStorageSize,
                color: selectedColor,
                totalPrice,
				quantity,
				plusPrice
            });
        }
		
		$.ajax({
			url:"testJSON.hp",
			data:{
				"productCode":productCode,
				"storage":selectStorageSize,
				"color":selectedColor,
				"totalPrice":totalPrice,
				"quantity":quantity,
				"plusPrice":plusPrice
			},
			dataType:"json",
			success:function(json){
				console.log("확인용 json:" ,json);
			},
			error:function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
			
		});
		
    });

});
