$(document).ready(function () {

 
  /* ================= 전체 선택 ================= */
  window.toggleSelectAll = function (allChk) {
    $(".item-checkbox").prop("checked", allChk.checked);
    updateTotal();  // 체크박스 클릭 시 금액 계산
  };

  const $allCheck = $("thead input[type='checkbox']");

  //* ================= 개별 체크 ================= */
  $(document).on("click", ".item-checkbox", function () {
    const isAllChecked =
      $(".item-checkbox:checked").length === $(".item-checkbox").length;
    $("thead input[type='checkbox']").prop("checked", isAllChecked); // 전체 선택 체크박스 반영
    updateTotal();  // 개별 체크 시 금액 계산
  });

  
  /* ================= 선택 삭제 ================= */
  $("#btnDeleteSelected").on("click", function () {
    const $checked = $(".item-checkbox:checked");

    if ($checked.length === 0) {
      alert("삭제할 상품을 선택하세요.");
      return;
    }

    if (!confirm("정말로 선택한 상품을 삭제하시겠습니까?")) return;

    const requests = [];

    $checked.each(function () {
      const cartId = $(this).val();
      requests.push(
        $.post("zangCart.hp", { action: "delete", cartId })
      );
    });

    $.when.apply($, requests).done(function () {
      location.reload();
    });
  });

  /* ================= 금액 계산 ================= */
  window.updateTotal = function () {
    let total = 0;

    $(".item-checkbox:checked").each(function () {
      const $row = $(this).closest("tr");
	  const unitPrice = Number($row.data("price"));
	  const qty = Number($row.find(".quantity-input").val());
	  total += unitPrice * qty;
    });

 
	$("#totalProductPrice").text(total.toLocaleString() + "원");
	$("#totalDiscount").text("0원");
	$("#finalTotal").text(total.toLocaleString() + "원");
  };

  /* ================= 수량 + / - ================= */
  window.changeQty = function (cartId, diff) {
    const $row = $(`tr[data-cartid='${cartId}']`);
    const $input = $row.find(".quantity-input");

    let qty = Number($input.val()) + diff;

    if (qty < 1) {
      alert("수량은 1개 이상이어야 합니다.");
      return;
    }
    if (qty > 50) {
      alert("최대 구매 수량은 50개입니다.");
      return;
    }

    $input.val(qty);
    updateRowTotal($row);
    updateTotal();
    sendQtyToServer(cartId, qty);
  };

  /* ================= 직접 입력 ================= */
  $(".quantity-input")
    .on("input", function () {
      let val = $(this).val().replace(/[^0-9]/g, "");
      if (val === "") val = 1;
      val = Math.min(50, Math.max(1, Number(val)));
      $(this).val(val);
    })
    .on("blur", function () {
      const $row = $(this).closest("tr");
      const qty = Number($(this).val());

      updateRowTotal($row);
      updateTotal();
      sendQtyToServer($row.data("cartid"), qty);
    });

  /* ================= 행 합계 ================= */
  function updateRowTotal($row) {
    const price = Number($row.data("price"));
    const qty = Number($row.find(".quantity-input").val());
    $row.find(".row-total").text((price * qty).toLocaleString());
  }

  /* ================= 서버 전송 ================= */
  function sendQtyToServer(cartId, qty) {
    return $.post("zangCart.hp", {
      action: "updateQty",
      cartId,
      quantity: qty
    });
  }

  /* ================= 구매하기 ================= */
  $(".checkout-btn").on("click", function () {
    const selectedItems = $(".item-checkbox:checked");

    if (selectedItems.length === 0) {
      alert("주문할 상품을 선택하세요.");
      return;
    }

    const cartIds = selectedItems
      .map(function () { return this.value; })
      .get()
      .join(",");

    location.href = ctxPath + "/pay/payMent.hp?cartIds=" + cartIds;
  });

  /* ================= 최초 1회 계산 (중요) ================= */
  updateTotal();
});