document.addEventListener('click', function(e) {
  const link = e.target.closest('a, button');

  if (!link) return;
  if (link.closest('.modal')) return;
  
  if (window.paymentInProgress) {
    if (link.id === 'coinPayBtn') return;

    e.preventDefault();
    e.stopPropagation();
    e.stopImmediatePropagation();
    alert("결제 진행 중에는 페이지 이동이 불가합니다.");
  }
}, true);

$(function () {
  let payClicked = false;
  let couponApplied = false;
  window.paymentInProgress = false;
  let paymentPopup = null;
  let popupCheckInterval = null;
  
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
  
  // 쿠폰 적용
  $("#applyCouponBtn").on("click", function () {
    const selectedOption = $("#couponSelect option:selected");
    const selectedValue = $("#couponSelect").val();

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

    $("#discountAmount").text("- " + discount.toLocaleString() + " 원");
    $("#finalAmount").text(finalPrice.toLocaleString() + " 원");
    $("#discountAmountHidden").val(discount);
    $("#couponDiscount").val(discount);
    $("#finalPrice").val(finalPrice);
    $("#totalAmount").val(finalPrice);
    $("#couponId").val(selectedOption.val());

    couponApplied = true;
    $("#couponSelect option[value='cancel']").show();
  });

  function resetCoupon() {
    const totalPrice = Number($("#totalPrice").val()) || 0;

    $("#discountAmount").text("- 0 원");
    $("#finalAmount").text(totalPrice.toLocaleString() + " 원");
    $("#discountAmountHidden").val(0);
    $("#couponDiscount").val(0);
    $("#finalPrice").val(totalPrice);
    $("#totalAmount").val(totalPrice);
    $("#couponId").val("");

    couponApplied = false;
    $("#couponSelect").prop("selectedIndex", 0);
    $("#couponSelect option[value='cancel']").hide();
  }

  // 결제 버튼
  $("#coinPayBtn").on("click", function (e) {
    e.preventDefault();

    if (payClicked) return;
    payClicked = true;
    
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

    $("#deliveryAddress").val(address + " " + detailAddress);
    $("#totalAmount").val(finalPrice);

    const productName = $("#productName").val() || "상품";

    paymentPopup = window.open(
      ctxpath + "/payment/coinPaymentPopup.hp?finalPrice=" + encodeURIComponent(finalPrice) + 
      "&productName=" + encodeURIComponent(productName),
      "paymentPopup",
      "width=1000,height=700,scrollbars=yes"
    );
    
    if (!paymentPopup) {
      alert("팝업 차단을 해제해주세요.");
      resetPaymentState();
      return;
    }

    window.paymentInProgress = true;
    
    popupCheckInterval = setInterval(function() {
      if (paymentPopup && paymentPopup.closed) {
        console.log("결제 팝업이 닫혔습니다. 상태 초기화");
        resetPaymentState();
      }
    }, 500);
  });

  // 주소 검색
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
  
  // ===== 페이지 이탈 감지 (1번만!) =====
  
  // 1. 브라우저 닫기, 새로고침
  window.addEventListener('beforeunload', function(e) {
    if (window.paymentInProgress) {
      if (paymentPopup && !paymentPopup.closed) {
        paymentPopup.close();
      }
      e.preventDefault();
      e.returnValue = '결제가 진행 중입니다. 페이지를 나가시겠습니까?';
      return e.returnValue;
    }
  });
  
  // 2. 뒤로가기
  if (window.history && window.history.pushState) {
    window.history.pushState(null, null, window.location.href);
    
    window.addEventListener('popstate', function() {
      if (window.paymentInProgress) {
        alert('결제 진행 중에는 페이지를 이동할 수 없습니다.');
        window.history.pushState(null, null, window.location.href);
      }
    });
  }
  
  // 3. 탭 전환/페이지 숨김
  document.addEventListener('visibilitychange', function() {
    if (document.hidden && window.paymentInProgress) {
      if (paymentPopup && !paymentPopup.closed) {
        paymentPopup.close();
      }
    }
  });
  // ===== 페이지 진입 시 기본배송지 자동 반영 =====
  (function applyDefaultAddressOnLoad() {

    // 기본 배송지 카드 (isDefault == 1)
    const defaultItem = $('.list-group-item.border-primary').first();
    if (defaultItem.length === 0) return;

    const btn = defaultItem.find('.btnSelectAddress');
    if (btn.length === 0) return;

    // 결제페이지 input에 바로 세팅
    $('#recipientName').val(btn.data('name'));
    $('#recipientPhone').val(btn.data('phone'));
    $('#zipcode').val(btn.data('zipcode'));
    $('#address').val(btn.data('address'));
    $('#detailAddress').val(btn.data('detail'));

    // hidden 값도 같이 동기화
    syncHiddenDeliveryAddress();

  })();
  
  function syncHiddenDeliveryAddress() {
    const fullAddress =
      $('#zipcode').val() + '|' +
      $('#address').val() + '|' +
      $('#detailAddress').val();

    $('#deliveryAddress').val(fullAddress);
  }
});