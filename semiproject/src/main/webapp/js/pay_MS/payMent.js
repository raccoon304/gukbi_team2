
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

		  const finalPrice = Number($("#finalPrice").val());
		  const address = $.trim($("#address").val());
		  const detailAddress = $.trim($("#detailAddress").val());

		  // 1️⃣ 팝업 먼저 열기 (가장 중요)
		  const popup = window.open(
		    "",
		    "inicisPopup",
		    "width=500,height=700,resizable=no,scrollbars=yes"
		  );

		  if (!popup) {
		    alert("팝업 차단을 해제해주세요.");
		    return;
		  }

		  // 2️ form 생성
		  const form = document.createElement("form");
		  form.method = "POST";
		  form.action = ctxPath + "/payment/coinPaymentPopup.hp";
		  form.target = "inicisPopup";

		  [
		    ["userid", userid],
		    ["finalPrice", finalPrice],
		    ["address", address],
		    ["detailAddress", detailAddress]
		  ].forEach(([name, value]) => {
		    const input = document.createElement("input");
		    input.type = "hidden";
		    input.name = name;
		    input.value = value;
		    form.appendChild(input);
		  });

		  document.body.appendChild(form);

		  // 3️ POST 전송
		  form.submit();

		  // 4️ cleanup
		  document.body.removeChild(form);
		}
