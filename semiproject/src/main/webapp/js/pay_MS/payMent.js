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

    const discount = Number(selectedOption.data("discount")) || 0;
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

    // hidden 값 세팅
    $("#couponDiscount").val(discount);
    $("#finalPrice").val(finalPrice);
    $("#couponId").val(selectedOption.val());

    couponApplied = true;
  });

  // =========================
  // 결제 버튼
  // =========================
  $("#coinPayBtn").on("click", function () {

    if (!couponApplied && $("#couponSelect").val()) {
      alert("쿠폰 적용 버튼을 눌러주세요.");
      return;
    }

    const address = $("#address").val();
    const detailAddress = $("#detailAddress").val();
    const finalPrice = Number($("#finalPrice").val());

    if (!address) {
      alert("주소를 입력하세요.");
      return;
    }

    if (!detailAddress) {
      alert("상세주소를 입력하세요.");
      return;
    }

    if (!finalPrice || finalPrice <= 0) {
      alert("결제 금액 오류");
      return;
    }

    window.open(
      ctxpath + "/payment/coinPaymentPopup.hp?finalPrice=" + finalPrice,
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