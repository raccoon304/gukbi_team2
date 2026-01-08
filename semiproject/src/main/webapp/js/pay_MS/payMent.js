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

    // hidden 값 세팅 (서버로 보낼 값)
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

    // 주소 체크 (최소 방어)
    if (!$("#address").val() || !$("#detailAddress").val()) {
      alert("배송 주소를 입력해주세요.");
      return;
    }

    // 실제 결제 요청
    const form = $("<form>", {
      method: "post",
      action: ctxpath + "/pay/paymentSuccess.hp"
    });

    form.append($("<input>", { type: "hidden", name: "couponId", value: $("#couponId").val() }));
    form.append($("<input>", { type: "hidden", name: "discountPrice", value: $("#couponDiscount").val() }));
    form.append($("<input>", { type: "hidden", name: "finalPrice", value: $("#finalPrice").val() }));
    form.append($("<input>", { type: "hidden", name: "address", value: $("#address").val() }));
    form.append($("<input>", { type: "hidden", name: "detailAddress", value: $("#detailAddress").val() }));

    $("body").append(form);
    form.submit();
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