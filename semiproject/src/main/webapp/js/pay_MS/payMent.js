// 수량, 가격, 총합을 연산하는 곳
let appliedCoupon = null; // 쿠폰이 없는 상태가 초기 상태

function updatePayTotal() {
  let total = 0;

  document.querySelectorAll("tr[data-cartid]").forEach(row => {
    const price = Number(row.dataset.price);
    const qty = Number(row.querySelector(".quantity-input").value);
    total += price * qty;
  });

  let discount = 0;

  if (appliedCoupon) {
    if (appliedCoupon.type === 0) {
      discount = appliedCoupon.value; // 정액
    } else if (appliedCoupon.type === 1) {
      discount = Math.floor(total * appliedCoupon.value / 100); // 정률
    }
  }

  if (discount > total) discount = total;

  document.querySelector("#totalProductPrice").innerText =
    total.toLocaleString() + "원";
  document.querySelector("#totalDiscount").innerText =
    discount.toLocaleString() + "원";
  document.querySelector("#finalTotal").innerText =
    (total - discount).toLocaleString() + "원";
}

document.addEventListener("DOMContentLoaded", () => {

	updatePayTotal();
	
  document.querySelectorAll(".btn-apply-coupon").forEach(btn => {
    btn.addEventListener("click", () => {
      appliedCoupon = {
        type: Number(btn.dataset.type),   // 0: 정액, 1: 정률
        value: Number(btn.dataset.value)  // 금액 or %
      };

      updatePayTotal();
    });
  });

});


// 최종 결제 팝업창을 여는 코드
function openPaymentPopup(ctxPath, userid) {

    const popupWidth  = 500;
    const popupHeight = 700;

    const left = (window.screen.width / 2) - (popupWidth / 2);
    const top  = (window.screen.height / 2) - (popupHeight / 2);

    const url = ctxPath + "/payment/coinPaymentPopup.hp?userid=" + encodeURIComponent(userid);

    window.open(
        url,
        "inicisPopup",
        `width=${popupWidth},height=${popupHeight},left=${left},top=${top},resizable=no,scrollbars=yes`
    );
}