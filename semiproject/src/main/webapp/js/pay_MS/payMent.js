$(function () {
  let couponApplied = false;

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

  // 배송지 체크박스 (1개만 선택)
  const deliveryChecks = document.querySelectorAll(
    'input[name="deliveryType"]'
  );

  deliveryChecks.forEach(cb => {
    cb.addEventListener("change", function () {
      if (this.checked) {
        deliveryChecks.forEach(other => {
          if (other !== this) {
            other.checked = false;
          }
        });
      }
    });
  });

  // 결제 버튼
  $("#coinPayBtn").on("click", function (e) {
    e.preventDefault();

    // 배송지 선택 필수
    const checkedDelivery =
      document.querySelector('input[name="deliveryType"]:checked');

    if (!checkedDelivery) {
      alert("배송지 체크 박스를 선택해주세요.");
      return;
    }
	
	$("#deliveryTypeSelected").val(checkedDelivery.value);
	
    // 쿠폰 적용 확인
    if (!couponApplied && $("#couponSelect").val()) {
      alert("쿠폰 적용 버튼을 눌러주세요.");
      return;
    }

    const address = $("#address").val();
    const detailAddress = $("#detailAddress").val();
    const finalPrice = Number($("#finalPrice").val()) || 0;
	const addressRegex = /^[가-힣0-9\s\-()]+$/;

    if (!address) {
      alert("주소를 입력하세요.");
      return;
    }
    if (!detailAddress) {
      alert("상세주소를 입력하세요.");
      return;
    }
	
	if (!addressRegex.test(detailAddress)) {
	  alert("상세주소 형식이 올바르지 않습니다.");
	  return;
	}
	
    if (finalPrice <= 0) {
      alert("결제 금액 오류");
      return;
    }

    // 서버 필수 값 확정
    $("#deliveryAddress").val(address + " " + detailAddress);
    $("#totalAmount").val(finalPrice);

    // 결제 팝업
    window.open(
      ctxpath + "/payment/coinPaymentPopup.hp?finalPrice=" + encodeURIComponent(finalPrice),
      "paymentPopup",
      "width=1000,height=700,scrollbars=yes"
    );
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
});