// 수량, 가격, 총합을 연산하는 곳
function updateTotal() {
  let total = 0;

  document.querySelectorAll("tr[data-cartid]").forEach(row => {
    const price = Number(row.dataset.price);
    const qty = Number(row.querySelector(".quantity-input").value);

    const lineTotal = price * qty;

    row.querySelector(".row-total").innerText =
      lineTotal.toLocaleString() + "원";

    total += lineTotal;
  });

  const discount = 0; // 나중에 쿠폰 붙일 자리

  document.querySelector("#totalProductPrice").innerText =
    total.toLocaleString() + "원";

  document.querySelector("#totalDiscount").innerText =
    discount.toLocaleString() + "원";

  document.querySelector("#finalTotal").innerText =
    (total - discount).toLocaleString() + "원";
}

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