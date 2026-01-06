
// 우편번호 검색 클릭 여부
let b_zipcodeSearch_click = false;


// 다음 우편번호 검색
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

		        // 총 주문금액 차감 반영
		        $("#finalAmount").text(
		            finalPrice.toLocaleString() + " 원"
		        );

		        couponApplied = true;
		    });
		});

		
		// 결제 팝업 열기
		function openPaymentPopup(ctxPath, userid) {

		    const address = $.trim($("#address").val());
		    const detailAddress = $.trim($("#detailAddress").val());
			const finalPrice = $("#finalPrice").val();
			
			// 상세주소 정규식
			const detailAddrRegex = /^[가-힣a-zA-Z0-9\s\-#,()]+$/;
			
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
			
			// 길이 체크
		    if (detailAddress.length < 2 || detailAddress.length > 50) {
		        alert("상세주소는 2자 이상 50자 이하로 입력해주세요.");
		        $("#detailAddress").focus();
		        return;
		    }
			
			// 정규식 검사
		    if (!detailAddrRegex.test(detailAddress)) {
		        alert("상세주소에 사용할 수 없는 문자가 포함되어 있습니다.");
		        $("#detailAddress").focus();
		        return;
		    }
			
			// 같은 글자 3번 이상 반복 방지 ⭐
			if (/(.)\1\1/.test(detailAddress)) {
			    alert("상세주소를 너무 반복적으로 입력했습니다.");
			    $("#detailAddress").focus();
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
				+ "&finalPrice=" + encodeURIComponent(finalPrice)
		        + "&address=" + encodeURIComponent(address)
		        + "&detailAddress=" + encodeURIComponent(detailAddress);

		    window.open(
		        url,
		        "inicisPopup",
		        `width=${popupWidth},height=${popupHeight},left=${left},top=${top},resizable=no,scrollbars=yes`
		    );
		}
