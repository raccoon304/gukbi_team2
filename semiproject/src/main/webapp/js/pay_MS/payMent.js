$(function () {
  let couponApplied = false;
  let paymentInProgress = false;

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

    console.log("쿠폰 취소됨, 원래 금액으로 복구:", totalPrice);
  }

  // 결제 버튼
  $("#coinPayBtn").on("click", function (e) {
    e.preventDefault();

    // 쿠폰 적용 확인
    if (!couponApplied && $("#couponSelect").val() && $("#couponSelect").val() !== "cancel") {
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

	// 상품명 가져오기
	const productName = $("#productName").val() || "상품";

	// 결제 팝업
	const popup = window.open(
	  ctxpath + "/payment/coinPaymentPopup.hp?finalPrice=" + encodeURIComponent(finalPrice) + 
	  "&productName=" + encodeURIComponent(productName),
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

  // 로그아웃 버튼 차단
  $("#logoutBtn").on("click", function(e) {
    if (paymentInProgress) {
      e.preventDefault();
      e.stopPropagation();
      alert("결제 진행 중에는 로그아웃할 수 없습니다.");
      return false;
    }
  });
});