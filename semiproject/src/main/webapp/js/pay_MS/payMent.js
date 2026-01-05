// ===============================
// 우편번호 검색 클릭 여부
// ===============================
let b_zipcodeSearch_click = false;

// ===============================
// 다음 우편번호 검색
// ===============================
function execDaumPostcode() {
    b_zipcodeSearch_click = true;

    new daum.Postcode({
        oncomplete: function (data) {

            const addr = data.roadAddress || data.jibunAddress;

            // 기본 주소 세팅
            $("#address").val(addr);

            // 상세주소 입력으로 포커스
            $("#detailAddress").focus();
        }
    }).open();
}


// ===============================
// 결제 팝업 열기
// ===============================
function openPaymentPopup(ctxPath, userid) {

    const address = $.trim($("#address").val());
    const detailAddress = $.trim($("#detailAddress").val());

    // 주소 검색 버튼 클릭 여부 확인
    if (!b_zipcodeSearch_click) {
        alert("주소 검색 버튼을 눌러 주소를 선택해주세요.");
        return;
    }

    // 주소 입력값 검증
    if (address === "" || detailAddress === "") {
        alert("주소와 상세주소를 모두 입력해주세요.");
        return;
    }

    const popupWidth  = 500;
    const popupHeight = 700;

    const left = (window.screen.width / 2) - (popupWidth / 2);
    const top  = (window.screen.height / 2) - (popupHeight / 2);

    const url =
        ctxPath
        + "/payment/coinPaymentPopup.hp"
        + "?userid=" + encodeURIComponent(userid)
        + "&address=" + encodeURIComponent(address)
        + "&detailAddress=" + encodeURIComponent(detailAddress);

    window.open(
        url,
        "inicisPopup",
        `width=${popupWidth},height=${popupHeight},left=${left},top=${top},resizable=no,scrollbars=yes`
    );
}