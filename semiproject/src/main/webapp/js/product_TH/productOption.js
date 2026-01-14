
$(document).ready(function () {
	/* =======================
	   🔹 전역 상태 변수
	======================= */

	// 🔹 pageData에서 "변하지 않는 값"만 구조분해
	const { 
	    isLoggedIn, 
	    loginUserId, 
	    productCode, 
	    unitPrice 
	} = pageData;

	// 🔹 옵션에 따라 바뀌는 상태값은 let
	let productOptionId = pageData.productOptionId;
	let plusPrice = pageData.plusPrice;
	let maxStock = pageData.maxStock;

	// 🔹 수량/가격 관련
	let quantity = parseInt($('#quantity').val(), 10) || 1;
	let totalPrice = 0;

	// 🔹 옵션 선택 상태
	let selectStorageSize = "256GB";   // 초기 표시용
	let selectedColor = "";

	// 🔹 기본 가격 캐싱
	const l_unitPrice = Number(unitPrice);

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

	//최종금액을 계산해주기
	function updateTotalPrice() {
	    totalPrice = (l_unitPrice + plusPrice) * quantity;
	    $('#totalPrice').text(totalPrice.toLocaleString() + ' 원');
	}//end of function updateTotalPrice()-----

	
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
	//용량선택
	$('#sortSelectStorageSize').change(function () {
	    selectStorageSize = $(this).val();
	    applySelectedOption();
	});
	//색상선택
	$('#sortSelectColor').change(function () {
	    selectedColor = $(this).val();
	    applySelectedOption();
	});
	
	
	function applySelectedOption() {
	    const color = $('#sortSelectColor').val();
	    const storage = $('#sortSelectStorageSize').val();

	    if (!color || !storage) {
	        plusPrice = 0;
	        updateTotalPrice();
	        return;
	    }

	    const selected = optionList.find(opt =>
	        opt.color === color && opt.storage === storage
	    );

	    if (!selected) return;

	    // 옵션 반영
	    plusPrice = Number(selected.plusPrice);
	    maxStock = Number(selected.stock);
	    
	    // 수량 보정
	    if (quantity > maxStock) {
	        quantity = maxStock;
	        $('#quantity').val(quantity);
	    }

	    // 재고 표시
	    $('.badge-stock')
	        .removeClass('badge-danger badge-success')
	        .addClass(maxStock > 0 ? 'badge-success' : 'badge-danger')
	        .html(
	            maxStock > 0
	                ? `<i class="fas fa-check mr-1"></i>재고 있음 (${maxStock})`
	                : `<i class="fas fa-times mr-1"></i>품절`
	        );

	    updateTotalPrice();
	}//end of function applySelectedOption()-----

	
	
	
	
	
	
    /* =======================
       🔹 장바구니
    ======================= */
    $('#cartBtn').click(function() {
		updateTotalPrice();
		
        if (!isLoggedIn) {
            alert('로그인이 필요합니다.');
            $('#loginModal').modal('show');
            return;
        }

        if (confirm(quantity+'개의 상품을 장바구니에 담으시겠습니까?\n'+'총 금액: '+totalPrice.toLocaleString()+'원')) {
            alert('장바구니에 상품이 추가되었습니다!');
			
			$.ajax({
				url:"productInsertCart.hp",
				data:{
					"loginUserId":loginUserId, //회원아이디
					"productOptionId": productOptionId, //옵션아이디
					"quantity":quantity //상품개수
				},
				type: "post",
				dataType:"json",
				success:function(json){
					if(confirm(json.message)) {
						location.href = json.loc;
					} 
				},
				error:function(request, status, error){
					alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				}
			});
        }//end of if()-----
    });//end of $('#cartBtn').click(function() {} -----

	
	
    /* =======================
       🔹 구매하기
    ======================= */
    $('#purchaseBtn').click(function() {
        if (!isLoggedIn) {
            alert('로그인이 필요합니다.');
            $('#loginModal').modal('show');
            return;
        }

        if (confirm('상품을 구매하시겠습니까?\n'+'수량: '+quantity+'개\n'+
				    '총 금액: '+totalPrice.toLocaleString()+'원\n확인 버튼을 누르면 상품 구매 페이지로 이동합니다.')) {
            //alert('상품 구매 페이지로 이동합니다.');
			
			//보내줘야 할 데이터: 옵션ID, 상품개수, 상품코드
			$.ajax({
				//url:"productInsertPay.hp",
				url:"/semiproject/pay/payMent.hp",
				data:{
					"loginUserId":loginUserId, //회원아이디
					"productCode":productCode, //상품코드
					"optionId": productOptionId, //옵션 아이디
					"quantity":quantity //상품개수
				},
				type: "post",
				dataType:"text",
				success:function(){
					window.location.href = '/semiproject/pay/payMent.hp';
				},
				error:function(request, status, error){
					alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				}
			});
        }
    });//end of $('#purchaseBtn').click(function()-----

	
	
    /* =======================
       🔹 리뷰
    ======================= */
    $('#reviewBtn').click(function () {
        if (confirm('상품 리뷰 페이지로 이동하시겠습니까?')) {
            console.log("리뷰페이지 이동");
        }
    });

	
	
	
});//end of function(){}----------
