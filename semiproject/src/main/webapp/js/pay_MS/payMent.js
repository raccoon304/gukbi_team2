function openPaymentPopup(ctxPath, userid) {

    const popupWidth  = 500;
    const popupHeight = 700;

    const left = (window.screen.width / 2) - (popupWidth / 2);
    const top  = (window.screen.height / 2) - (popupHeight / 2);

    window.open(
        ctxPath + "/payment/coinPaymentPopup.hp",
        "inicisPopup",
        `width=${popupWidth},height=${popupHeight},left=${left},top=${top},resizable=no,scrollbars=yes`
    );
}