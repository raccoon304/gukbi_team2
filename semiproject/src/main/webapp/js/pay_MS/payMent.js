// 우편번호 검색 클릭 여부
let b_zipcodeSearch_click = false;

// 다음 우편번호 검색
function execDaumPostcode() {
    b_zipcodeSearch_click = true;

    new daum.Postcode({
        oncomplete: function (data) {
            const addr = data.roadAddress || data.jibunAddress;
            $("#address").val(addr);
            $("#detailAddress").focus();
        }
    }).open();
}

// 쿠폰 금액 적용 할인
let couponApplied = false;

$(function () {

    $("#applyCouponBtn").on("click", function () {

        if (couponApplied) {
            alert("이미 쿠폰이 적용되었습니다.");
            return;
        }

        const discount = Number($("#couponDiscount").val() || 0);
        const totalPrice = Number($("#totalPrice").val() || 0);

        if (discount <= 0) {
            alert("적용 가능한 쿠폰이 없습니다.");
            return;
        }

        const finalPrice = totalPrice - discount;

        // 쿠폰 적용금액 표시
        $("#discountAmount").text(
            "- " + discount.toLocaleString() + " 원"
        );

        // 총 주문금액 표시
        $("#finalAmount").text(
            finalPrice.toLocaleString() + " 원"
        );

        // 🔥 hidden 값도 반드시 갱신
        $("#finalPrice").val(finalPrice);

        couponApplied = true;
    });

});

// ✅ 결제 팝업 열기 (GET 방식)
function openPaymentPopup(ctxPath, userid) {

    const finalPrice = Number($("#finalPrice").val());
    const address = $.trim($("#address").val());
    const detailAddress = $.trim($("#detailAddress").val());

    if (!finalPrice || finalPrice <= 0) {
        alert("결제 금액 오류");
        return;
    }

    if (!address) {
        alert("주소를 입력해주세요.");
        return;
    }

    const url =
        ctxPath +
        "/payment/coinPaymentPopup.hp" +
        "?finalPrice=" + encodeURIComponent(finalPrice);

    const popup = window.open(
        url,
        "inicisPopup",
        "width=500,height=700,resizable=no,scrollbars=yes"
    );

    if (!popup) {
        alert("팝업 차단을 해제해주세요.");
    }
}