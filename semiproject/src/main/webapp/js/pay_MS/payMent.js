$(function () {

  
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


   //  결제 버튼
 
  $("#coinPayBtn").on("click", function () {

    const address = $("#address").val().trim();
    const detailAddress = $("#detailAddress").val().trim();
    const finalPrice = Number($("#finalPrice").val());

    if (!address) {
      alert("주소를 검색해주세요.");
      return;
    }

    if (!detailAddress) {
      alert("상세주소를 입력해주세요.");
      $("#detailAddress").focus();
      return; 
    }

    if (!finalPrice || finalPrice <= 0) {
      alert("결제 금액 오류");
      return;
    }

    window.open(
      ctxPath + "/payment/coinPaymentPopup.hp?finalPrice=" + finalPrice,
      "paymentPopup",
      "width=1000,height=700,scrollbars=yes"
    );
  });

});