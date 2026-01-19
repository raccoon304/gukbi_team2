$(document).ready(function () {
   /* 
      🔹 전역 상태 변수
    */
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
   let selectedColor = "";

   // 🔹 기본 가격 캐싱
   const l_unitPrice = Number(unitPrice);

   //  최대 주문 수량 상수 추가!
   const MAX_ORDER_QUANTITY = 50;

   
    /* =======================
       🔹 초기 실행
    ======================= */
   // 🔹 로그인 상태
   updateLoginStatus();

   // 🔹 기본 용량
   const defaultStorage = "256GB";
   selectStorageSize = defaultStorage;
   $('#sortSelectStorageSize').val(defaultStorage);

   // 🔹 해당 용량에 맞는 첫 옵션 선택
   const defaultOption = optionList.find(
       opt => opt.storage === defaultStorage
   );
   //첫 상품상세 들어왔을 때 기본옵션
   if (defaultOption) {
       selectedColor = defaultOption.color;
       $('#sortSelectColor').val(selectedColor);

       // 여기서 옵션 확정
       applySelectedOption();
      
      updateColorOptionsByStorage(defaultStorage);
   }
   
   
   
   /* =======================
      🔹 썸네일 클릭 → 메인 이미지 변경
   ======================= */

   function setMainImage(fullSrc, $thumb){
     if(!fullSrc) return;

     $('#productImage').attr('src', fullSrc);

     // active 표시
     if($thumb && $thumb.length){
       $('.thumb-img').removeClass('active');
       $thumb.addClass('active');
     }
   }

   $(document).on('click', '.thumb-img', function(){
     const fullSrc = $(this).data('full') || $(this).attr('src');
     setMainImage(fullSrc, $(this));
   });
   
   
   
   
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

   
   // 수량 입력값을 검증·보정하고, 총 금액을 다시 계산 (수정!)
   function syncQuantity() {
       let inputVal = parseInt($('#quantity').val(), 10);

       if (isNaN(inputVal) || inputVal < 1) inputVal = 1;
       
       // 최대값은 재고와 50 중 작은 값
       const maxAllowed = Math.min(maxStock, MAX_ORDER_QUANTITY);
       if (inputVal > maxAllowed) inputVal = maxAllowed;

       quantity = inputVal;
       $('#quantity').val(quantity);
       updateTotalPrice();
   }

    /* 
       🔹 수량 컨트롤
    */

   // 🔥 수량 증가 (수정!)
   $('#increaseBtn').click(function () {
       if (!isLoggedIn) return;

       const maxAllowed = Math.min(maxStock, MAX_ORDER_QUANTITY);

       if (quantity < maxAllowed) {
           quantity++;
           $('#quantity').val(quantity);
           updateTotalPrice();
       } else {
           if (maxStock <= MAX_ORDER_QUANTITY) {
               alert('최대 재고 수량입니다.');
           } else {
               alert(`최대 주문 수량은 ${MAX_ORDER_QUANTITY}개입니다.`);
           }
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
   
   //재고량이 입력될 때마다 계산해주기
    $('#quantity').on('input', function () {
        syncQuantity();
    });

   
    /* 
       🔹 옵션 선택
     */
   //용량선택
   $('#sortSelectStorageSize').change(function () {
       const storage = $(this).val();
       
      if (!storage) return;
       updateColorOptionsByStorage(storage);
   });
   //색상 선택
   $('#sortSelectColor').change(function () {
       selectedColor = $(this).val();
       applySelectedOption();
   });
   
   //용량에 해당되는 색상 출력 및 선택
   function updateColorOptionsByStorage(storage) {
       const $colorSelect = $('#sortSelectColor');

       // 해당 용량의 옵션만 필터
       const filtered = optionList.filter(opt => opt.storage === storage);

       // 중복 제거한 색상 목록
       const colors = [...new Set(filtered.map(opt => opt.color))];

       // 셀렉트 초기화
       $colorSelect.empty();

       // 색상 옵션 추가
       colors.forEach(color => {
           $colorSelect.append(`<option value="${color}">${color}</option>`);
       });

       // 자동 선택 (첫 번째 색상)
       if (colors.length > 0) {
           $colorSelect.val(colors[0]);
           applySelectedOption();
       }
   }
   
   //옵션 적용 함수
   function applySelectedOption() {
       const color = $('#sortSelectColor').val();
       const storage = $('#sortSelectStorageSize').val();

       if (!storage) {
           plusPrice = 0;
           updateTotalPrice();
           return;
       }

      // 용량 또는 색상이 없으면 중단
       if (!storage || !color) return;

       //  용량 + 색상 기준으로 옵션 찾기
       const selected = optionList.find(opt =>
           opt.storage === storage && opt.color === color
       );

       if (!selected) return;

       // 옵션 반영
      productOptionId = Number(selected.optionId);
       plusPrice = Number(selected.plusPrice);
       maxStock = Number(selected.stock);
       
       // 🔥 수량 보정 (수정!)
       const maxAllowed = Math.min(maxStock, MAX_ORDER_QUANTITY);
       if (quantity > maxAllowed) {
           quantity = maxAllowed;
           $('#quantity').val(quantity);
       }

      updateStockBadge(maxStock);
       updateTotalPrice();
   }//end of function applySelectedOption()-----

   // 재고 표시
   function updateStockBadge(stock) {
       $('.badge-stock')
           .removeClass('badge-danger badge-success')
           .addClass(stock > 0 ? 'badge-success' : 'badge-danger')
           .html(
               stock > 0
                   ? `<i class="fas fa-check mr-1"></i>재고 있음 (${stock})`
                   : `<i class="fas fa-times mr-1"></i>품절`);
   }
   
   
   
   
    /*
        장바구니
   */
    $('#cartBtn').click(function() {
        if (!isLoggedIn) {
            alert('로그인이 필요합니다.');
            $('#loginModal').modal('show');
            return;
        }
        if(maxStock == 0) {
            alert("품절인 상품은 장바구니에 담을 수 없습니다!");
            return;
        }
        if(quantity == 0) {
            alert("한 개 이상의 주문 수량이 필요합니다!")
            return;
        }
        
        // 🔥 최종 수량 검증 및 보정
        syncQuantity();
        
        // 🔥 보정된 값으로 다시 읽기
        const finalQuantity = parseInt($('#quantity').val(), 10);
        const finalTotalPrice = (l_unitPrice + plusPrice) * finalQuantity;
        
        if (confirm(finalQuantity+'개의 상품을 장바구니에 담으시겠습니까?\n'+'총 금액: '+finalTotalPrice.toLocaleString()+'원')) {
            alert('장바구니에 상품이 추가되었습니다!');
         
            $.ajax({
                url:"productInsertCart.hp",
                data:{
                    "loginUserId":loginUserId, //회원아이디
                    "productOptionId": productOptionId, //옵션아이디
                    "quantity":finalQuantity //🔥 보정된 수량 사용
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

   
   
    /* 
       🔹 구매하기 
     */
    $('#purchaseBtn').click(function() {
        if (!isLoggedIn) {
            alert('로그인이 필요합니다.');
            $('#loginModal').modal('show');
            return;
        }
        if(maxStock == 0) {
            alert("품절인 상품은 구매할 수 없습니다!");
            return;
        }
        if(quantity == 0) {
            alert("한 개 이상의 주문 수량이 필요합니다!")
            return;
        }
        
        // 🔥 최종 수량 검증 및 보정
        syncQuantity();
        
        // 🔥 보정된 값으로 다시 읽기
        const finalQuantity = parseInt($('#quantity').val(), 10);
        const finalTotalPrice = (l_unitPrice + plusPrice) * finalQuantity;
        
        if (confirm('상품을 구매하시겠습니까?\n'+'수량: '+finalQuantity+'개\n'+
                    '총 금액: '+finalTotalPrice.toLocaleString()+'원\n확인 버튼을 누르면 상품 구매 페이지로 이동합니다.')) {
            
            // 현재 페이지에서 form submit으로 이동
            const form = $('<form>', {
                method: 'POST',
                action: '/semiproject/pay/preview.hp'
            });
            
            form.append($('<input>', {type: 'hidden', name: 'optionId', value: productOptionId}));
            form.append($('<input>', {type: 'hidden', name: 'quantity', value: finalQuantity})); // 🔥 보정된 수량 사용
            
            $('body').append(form);
            form.submit();
        }
    });//end of $('#purchaseBtn').click(function()-----

   
   
    /* 
       리뷰
   */
    $('#reviewBtn').click(function () {
        if (confirm('상품 리뷰 페이지로 이동하시겠습니까?')) {
            console.log("리뷰페이지 이동");
        }
    });

   
   
   
});