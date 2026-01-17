$(function () {
  let couponApplied = false;
  let paymentInProgress = false;

  // 쿠폰 적용 버튼
  $("#applyCouponBtn").on("click", function () {
    const selectedOption = $("#couponSelect option:selected");

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
  });

  // 결제 버튼
  $("#coinPayBtn").on("click", function (e) {
    e.preventDefault();

    // 쿠폰 적용 확인
    if (!couponApplied && $("#couponSelect").val()) {
      alert("쿠폰 적용 버튼을 눌러주세요.");
      return;
    }

    const address = $("#address").val();
    const detailAddress = $("#detailAddress").val();
    const finalPrice = Number($("#finalPrice").val()) || 0;

    if (!address) {
      alert("주소를 입력하세요.");
      return;
    }
    if (!detailAddress) {
      alert("상세주소를 입력하세요.");
      return;
    }

    if (finalPrice <= 0) {
      alert("결제 금액 오류");
      return;
    }

    // 서버 필수 값 확정
    $("#deliveryAddress").val(address + " " + detailAddress);
    $("#totalAmount").val(finalPrice);

    // 결제 진행 중 플래그 설정
    paymentInProgress = true;

    // 결제 팝업
    const popup = window.open(
      ctxpath + "/payment/coinPaymentPopup.hp?finalPrice=" + encodeURIComponent(finalPrice),
      "paymentPopup",
      "width=1000,height=700,scrollbars=yes"
    );

    // 팝업이 닫힐 때 플래그 해제
    const checkPopup = setInterval(function() {
      if (popup.closed) {
        paymentInProgress = false;
        clearInterval(checkPopup);
      }
    }, 500);
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

  // 로그아웃 버튼 차단 - 가장 먼저 실행되도록
  $("#logoutBtn").on("click", function(e) {
    if (paymentInProgress) {
      e.preventDefault();
      e.stopPropagation();
      alert("결제 진행 중에는 로그아웃할 수 없습니다.");
      return false;
    }
  });
});