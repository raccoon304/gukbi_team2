$(function () {

	let couponApplied = false;
	
   //  주소 검색 버튼
  
  $("#addressSearchBtn").on("click", function () {

    new daum.Postcode({
      oncomplete: function (data) {

        // 도로명 / 지번 주소
        const addr = data.roadAddress || data.jibunAddress;

        // 주소 input
        $("#address").val(addr);

        // 우편번호 input
        $("#zipcode").val(data.zonecode);

        // 상세주소로 포커스
        $("#detailAddress").focus();
      }
    }).open();

  });

  // 쿠폰 버튼을 누르면 작동되는 코드
  $("#applyCouponBtn").on("click", function () {

    const discount = Number($("#couponDiscount").val()) || 0;
    const finalPrice = Number($("#finalPrice").val()) || 0;

	
    if (discount === 0) {
      alert("적용 가능한 쿠폰이 없습니다.");
      return;
    }

	const newFinalPrice = totalPrice - discount;
	
    $("#discountAmount").text("- " + discount.toLocaleString() + " 원");
    $("#finalAmount").text(finalPrice.toLocaleString() + " 원");

	$("#finalPrice").val(newFinalPrice);
	
    couponApplied = true; // 
  });
  

   //  결제 버튼
  $("#coinPayBtn").on("click", function () {

    const address = $("#address").val().trim();
    const detailAddress = $("#detailAddress").val().trim();
    const finalPrice = Number($("#finalPrice").val());
	const discount = Number($("#couponDiscount").val()) || 0;

    if (!address) {
      alert("주소를 검색해주세요.");
      return;
    }

    if (!detailAddress) {
      alert("상세주소를 입력해주세요.");
      $("#detailAddress").focus();
      return; 
    }
	
	if (discount > 0 && !couponApplied) {
	    alert("쿠폰 적용금액 버튼을 눌러주세요.");
	    return;
	  }


    if (!finalPrice || finalPrice <= 0) {
      alert("결제 금액 오류");
      return;
    }

    window.open(
       ctx_path + "/payment/coinPaymentPopup.hp?finalPrice=" + finalPrice,
      "paymentPopup",
      "width=1000,height=700,scrollbars=yes"
    );
  });

});