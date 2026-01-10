$(function () {
  let couponApplied = false;

  // =========================
  // 쿠폰 적용 버튼
  // =========================
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

    // 화면
    $("#discountAmount").text("- " + discount.toLocaleString() + " 원");
    $("#finalAmount").text(finalPrice.toLocaleString() + " 원");

    // 서버 전송용 hidden
    $("#discountAmountHidden").val(discount);   // name="discountAmount"인 hidden
    $("#couponDiscount").val(discount);
    $("#finalPrice").val(finalPrice);
    $("#totalAmount").val(finalPrice);
    $("#couponId").val(selectedOption.val());

    couponApplied = true;
  });

  // =========================
  // 결제 버튼
  // =========================
  $("#coinPayBtn").on("click", function (e) {
    // form 안에 button이면 기본 submit 방지
    e.preventDefault();

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

    // 팝업 오픈 (성공 시 팝업이 opener의 #payForm 을 submit 하게 만들 것)
    window.open(
      ctxpath + "/payment/coinPaymentPopup.hp?finalPrice=" + encodeURIComponent(finalPrice),
      "paymentPopup",
      "width=1000,height=700,scrollbars=yes"
    );
  });

  // =========================
  // 주소 검색 (다음 API)
  // =========================
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
});