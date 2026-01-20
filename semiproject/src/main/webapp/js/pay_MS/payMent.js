
document.addEventListener('click', function(e) {
  const link = e.target.closest('a, button');

  if (!link) return;

  if (link.closest('.modal')) return;
  
  if (window.paymentInProgress) {
    // 결제 버튼만 예외
    if (link.id === 'coinPayBtn') return;

    e.preventDefault();
    e.stopPropagation();
    e.stopImmediatePropagation();
    alert("결제 진행 중에는 페이지 이동이 불가합니다.");
  }
}, true);

// 2. jQuery 준비 완료 후 실행

$(function () {
  let payClicked = false;
  let couponApplied = false;
  window.paymentInProgress = false;
  let paymentPopup = null;
  let popupCheckInterval = null;
  
  // 팝업 상태 초기화 함수
  function resetPaymentState() {
    window.paymentInProgress = false;
    payClicked = false;
    
    if (popupCheckInterval) {
      clearInterval(popupCheckInterval);
      popupCheckInterval = null;
    }
    
    paymentPopup = null;
    console.log("결제 상태 초기화 완료");
  }
  
  // 쿠폰 적용 버튼
  $("#applyCouponBtn").on("click", function () {
    const selectedOption = $("#couponSelect option:selected");
    const selectedValue = $("#couponSelect").val();

    // "쿠폰 X (0원)" 선택 시
    if (selectedValue === "cancel") {
      resetCoupon();
      return;
    }

    if ($("#couponSelect").prop("selectedIndex") === 0) {
      alert("쿠폰을 선택해주세요.");
      return;
    }

    const discount = Number(selectedOption.attr("data-discount")) || 0;
    const totalPrice = Number($("#totalPrice").val()) || 0;

    if (discount <= 0) {
      alert("적용할 수 없는 쿠폰입니다.");
      return;
    }

    let finalPrice = totalPrice - discount;
    if (finalPrice < 0) finalPrice = 0;

    // 화면 반영
    $("#discountAmount").text("- " + discount.toLocaleString() + " 원");
    $("#finalAmount").text(finalPrice.toLocaleString() + " 원");

    // 서버 전송용 hidden
    $("#discountAmountHidden").val(discount);
    $("#couponDiscount").val(discount);
    $("#finalPrice").val(finalPrice);
    $("#totalAmount").val(finalPrice);
    $("#couponId").val(selectedOption.val());

    couponApplied = true;

    // 쿠폰이 적용되면 "쿠폰 X (0원)" 옵션 표시
    $("#couponSelect option[value='cancel']").show();
  });

  // 쿠폰 초기화 함수
  function resetCoupon() {
    const totalPrice = Number($("#totalPrice").val()) || 0;

    // 화면 반영
    $("#discountAmount").text("- 0 원");
    $("#finalAmount").text(totalPrice.toLocaleString() + " 원");

    // 서버 전송용 hidden 초기화
    $("#discountAmountHidden").val(0);
    $("#couponDiscount").val(0);
    $("#finalPrice").val(totalPrice);
    $("#totalAmount").val(totalPrice);
    $("#couponId").val("");

    couponApplied = false;

    // "쿠폰 선택"으로 되돌리기
    $("#couponSelect").prop("selectedIndex", 0);

    // "쿠폰 X (0원)" 옵션 숨기기
    $("#couponSelect option[value='cancel']").hide();

   // console.log("쿠폰 취소됨, 원래 금액으로 복구:", totalPrice);
  }

  // 결제 버튼
  $("#coinPayBtn").on("click", function (e) {
    e.preventDefault();

    if (payClicked) return;
    payClicked = true;	 
	 
    // 쿠폰 적용 확인
    if (!couponApplied && $("#couponSelect").val() && $("#couponSelect").val() !== "cancel") {
      alert("쿠폰 적용 버튼을 눌러주세요.");
      payClicked = false;
      return;
    }

    const address = $("#address").val();
    const detailAddress = $("#detailAddress").val();
    const finalPrice = Number($("#finalPrice").val()) || 0;

    if (!address) {
      alert("주소를 입력하세요.");
      payClicked = false;
      return;
    }
    if (!detailAddress) {
      alert("상세주소를 입력하세요.");
      payClicked = false;
      return;
    }
    if (finalPrice <= 0) {
      alert("결제 금액 오류");
      payClicked = false;
      return;
    }

    // 서버 필수 값 확정
    $("#deliveryAddress").val(address + " " + detailAddress);
    $("#totalAmount").val(finalPrice);

    // 상품명 가져오기
    const productName = $("#productName").val() || "상품";

    // 결제 팝업
    paymentPopup = window.open(
      ctxpath + "/payment/coinPaymentPopup.hp?finalPrice=" + encodeURIComponent(finalPrice) + 
      "&productName=" + encodeURIComponent(productName),
      "paymentPopup",
      "width=1000,height=700,scrollbars=yes"
    );
    
    // 팝업 차단 대응
    if (!paymentPopup) {
      alert("팝업 차단을 해제해주세요.");
      resetPaymentState();
      return;
    }

    window.paymentInProgress = true;
    
    // 팝업이 닫혔는지 주기적으로 체크
    popupCheckInterval = setInterval(function() {
      if (paymentPopup && paymentPopup.closed) {
        console.log("결제 팝업이 닫혔습니다. 상태 초기화");
        resetPaymentState();
      }
    }, 500); // 0.5초마다 체크
  });

  // 주소 검색 (다음 API)
  $("#addressSearchBtn").on("click", function () {
    new daum.Postcode({
      oncomplete: function (data) {
        const addr = data.roadAddress || data.jibunAddress;
        $("#address").val(addr);
        $("#zipcode").val(data.zonecode);
        $("#detailAddress").focus();
      }
    }).open();
  });
  
  // 페이지 이탈 방지 (브라우저 닫기, 새로고침 등)
  window.addEventListener('beforeunload', function(e) {
    if (window.paymentInProgress) {
      e.preventDefault();
      e.returnValue = '결제 불일치가 발생 할 수 있습니다. 페이지를 나가시겠습니까?';
      return e.returnValue;
    }
  });
  
  // 뒤로가기 방지 (history API)
  if (window.history && window.history.pushState) {
    window.history.pushState(null, null, window.location.href);
    
    window.addEventListener('popstate', function() {
      if (window.paymentInProgress) {
        alert('결제 진행 중에는 페이지를 이동할 수 없습니다.');
        window.history.pushState(null, null, window.location.href);
      }
    });
  }
});