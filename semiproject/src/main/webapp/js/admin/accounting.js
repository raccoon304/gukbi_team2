$(function () {
  // datepicker
  $("#startDate, #endDate").datepicker({
    dateFormat: "yy-mm-dd"
  });

  // 초기 로딩
  fetchAccounting($("#periodSelect").val());

  // 기간 변경
  $("#periodSelect").on("change", function () {
    const period = $(this).val();

    if (period === "CUSTOM") {
      $("#customRange").show();
      return;
    }
    $("#customRange").hide();
	
	
    fetchAccounting(period);
  });

  
  // 사용자 지정 적용
  $("#applyCustom").on("click", function () {
    const s = $("#startDate").val();
    const e = $("#endDate").val();

    if (!s || !e) {
      alert("시작일/종료일을 입력해주세요.");
      return;
    }
    if (s > e) {
      alert("시작일은 종료일보다 클 수 없습니다.");
      return;
    }

    fetchAccounting("CUSTOM", s, e);
  });

  // 상품 정렬 변경 시(서버에서 정렬하거나, 프론트에서 정렬해도 됨)
  $("#productSort").on("change", function () {
    const period = $("#periodSelect").val();
    if (period === "CUSTOM") {
      fetchAccounting("CUSTOM", $("#startDate").val(), $("#endDate").val());
    } else {
      fetchAccounting(period);
    }
  });
});

function fetchAccounting(period, startDate, endDate) {
  const sort = $("#productSort").val();

  $.ajax({
    url: ctxPath + "/admin/accountingData.hp",   // ★ 너 매핑으로 수정
    method: "GET",
    dataType: "json",
    data: {
      period,
      startDate,  // CUSTOM일 때만 사용
      endDate,    // CUSTOM일 때만 사용
      sort
    },
    success: function (res) {
      // 기간 라벨
      $("#rangeLabel").text(res.rangeLabel || "");

      // 상단 카드
      $("#totalOrders").text(numberFormat(res.totals.orders) + "건");
      $("#totalSales").text(numberFormat(res.totals.qty) + "개");
      $("#totalRevenue").text("₩" + numberFormat(res.totals.gross));
      $("#totalDiscount").text("₩" + numberFormat(res.totals.discount));
      $("#finalPayment").text("₩" + numberFormat(res.totals.net));

      // 기간별 집계
      renderDaily(res.daily);

      // 상품별 집계
      renderProducts(res.products);
    },
    error: function (xhr) {
      console.log(xhr.responseText);
    //  alert("회계 데이터를 불러오지 못했습니다.");
    }
  });
}

function renderDaily(rows) {
  const $tbody = $("#dailyStatsBody");
  $tbody.empty();

  if (!rows || rows.length === 0) {
    $tbody.append(`<tr><td colspan="4" class="text-center text-muted">데이터가 없습니다.</td></tr>`);
    return;
  }

  rows.forEach(r => {
    $tbody.append(`
      <tr>
        <td>${r.baseDate}</td>
        <td class="text-right">${numberFormat(r.orders)}</td>
        <td class="text-right">${numberFormat(r.qty)}</td>
        <td class="text-right">₩${numberFormat(r.amount)}</td>
      </tr>
    `);
  });
}

function renderProducts(rows) {
  const $tbody = $("#productStatsBody");
  $tbody.empty();

  if (!rows || rows.length === 0) {
    $tbody.append(`<tr><td colspan="5" class="text-center text-muted">데이터가 없습니다.</td></tr>`);
    return;
  }

  rows.forEach(r => {
    $tbody.append(`
      <tr>
        <td>${r.productNo}</td>
        <td>${escapeHtml(r.productName)}</td>
        <td>${escapeHtml(r.brand)}</td>
        <td class="text-right">${numberFormat(r.qty)}</td>
        <td class="text-right">₩${numberFormat(r.amount)}</td>
      </tr>
    `);
  });
}

function numberFormat(n) {
  n = n || 0;
  return n.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function escapeHtml(str) {
  if (!str) return "";
  return String(str)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#039;");
}