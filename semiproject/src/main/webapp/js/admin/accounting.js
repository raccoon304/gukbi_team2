var dailyChart = null;

$(function () {
  // datepicker
  $("#startDate, #endDate").datepicker({ dateFormat: "yy-mm-dd" });

  // 차트 생성
  initDailyChart();

  // 초기 로딩
  fetchAccounting($("#periodSelect").val());

  // 기간 변경
  $("#periodSelect").on("change", function () {
    var period = $(this).val();

    if (period === "CUSTOM") {
      $("#customRange").show();
      return;
    }

    $("#customRange").hide();
    fetchAccounting(period);
  });

  // 사용자 지정 적용
  $("#applyCustom").on("click", function () {
    var s = $("#startDate").val();
    var e = $("#endDate").val();

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

  // 상품 정렬 변경
  $("#productSort").on("change", function () {
    var period = $("#periodSelect").val();
    if (period === "CUSTOM") {
      fetchAccounting("CUSTOM", $("#startDate").val(), $("#endDate").val());
    } else {
      fetchAccounting(period);
    }
  });

  // 상품 행 클릭 -> 옵션별 판매수량 모달
  $("#productStatsBody").on("click", "tr.product-row", function () {
    var productNo = $(this).data("product-no");
    var productName = $(this).data("product-name");
    var brand = $(this).data("brand");

    openOptionSalesModal(productNo, productName, brand);
  });
});

function fetchAccounting(period, startDate, endDate) {
  var sort = $("#productSort").val();

  $.ajax({
    url: ctxPath + "/admin/accountingData.hp",
    method: "GET",
    dataType: "json",
    data: { period: period, startDate: startDate, endDate: endDate, sort: sort },
    success: function (res) {
      var t = (res && res.totals) ? res.totals : { orders: 0, qty: 0, gross: 0, discount: 0, net: 0 };
      var daily = (res && $.isArray(res.daily)) ? res.daily : [];
      var products = (res && $.isArray(res.products)) ? res.products : [];
      var unit = (res && res.unit) ? res.unit : "DAY";

      // 기간 라벨
      $("#rangeLabel").text((res && res.rangeLabel) ? res.rangeLabel : "");

      // 상단 카드(0이라도 표시)
      $("#totalOrders").text(numberFormat(t.orders) + "건");
      $("#totalSales").text(numberFormat(t.qty) + "개");
      $("#totalRevenue").text("₩" + numberFormat(t.gross));
      $("#totalDiscount").text("₩" + numberFormat(t.discount));
      $("#finalPayment").text("₩" + numberFormat(t.net));

      // 기간별 헤더
      $("#baseDateHeader").text(unit === "MONTH" ? "기준월" : "기준일");

      // 테이블 렌더
      renderDaily(daily);
      renderProducts(products);

      // 차트 업데이트
      updateDailyChart(daily, unit);
    },
    error: function (xhr) {
      console.log(xhr.responseText);

      //  0/없음 표시
      $("#rangeLabel").text("");
      $("#totalOrders").text("0건");
      $("#totalSales").text("0개");
      $("#totalRevenue").text("₩0");
      $("#totalDiscount").text("₩0");
      $("#finalPayment").text("₩0");

      renderDaily([]);
      renderProducts([]);
      updateDailyChart([], "DAY");
    }
  });
}

function renderDaily(rows) {
  var $tbody = $("#dailyStatsBody");
  $tbody.empty();

  if (!rows || rows.length === 0) {
    $tbody.append('<tr><td colspan="4" class="text-center text-muted">데이터가 없습니다.</td></tr>');
    return;
  }

  for (var i = 0; i < rows.length; i++) {
    var r = rows[i];
    $tbody.append(
      '<tr>' +
        '<td>' + escapeHtml(r.baseDate) + '</td>' +
        '<td class="text-right">' + numberFormat(r.orders) + '</td>' +
        '<td class="text-right">' + numberFormat(r.qty) + '</td>' +
        '<td class="text-right">₩' + numberFormat(r.amount) + '</td>' +
      '</tr>'
    );
  }
}

function renderProducts(rows) {
  var $tbody = $("#productStatsBody");
  $tbody.empty();

  if (!rows || rows.length === 0) {
    $tbody.append('<tr><td colspan="5" class="text-center text-muted">데이터가 없습니다.</td></tr>');
    return;
  }

  for (var i = 0; i < rows.length; i++) {
    var r = rows[i];
    $tbody.append(
      '<tr class="product-row" style="cursor:pointer;"' +
        ' data-product-no="' + escapeHtml(r.productNo) + '"' +
        ' data-product-name="' + escapeHtml(r.productName) + '"' +
        ' data-brand="' + escapeHtml(r.brand) + '">' +
        '<td>' + escapeHtml(r.productNo) + '</td>' +
        '<td>' + escapeHtml(r.productName) + '</td>' +
        '<td>' + escapeHtml(r.brand) + '</td>' +
        '<td class="text-right">' + numberFormat(r.qty) + '</td>' +
        '<td class="text-right">₩' + numberFormat(r.amount) + '</td>' +
      '</tr>'
    );
  }
}

function numberFormat(n) {
  if (n === null || n === undefined) n = 0;
  var num = Number(n);
  if (isNaN(num)) return "0";
  return String(num).replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function escapeHtml(str) {
  if (str === null || str === undefined) return "";
  return String(str)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#039;");
}

/* 상품별 모달 */
function openOptionSalesModal(productNo, productName, brand) {
  $("#modalProductTitle").text(productName + " (" + brand + ") / " + productNo);
  $("#modalRangeLabel").text($("#rangeLabel").text() || "");

  $("#optionSalesBody").html('<tr><td colspan="5" class="text-center text-muted">불러오는 중...</td></tr>');

  var period = $("#periodSelect").val();
  var params = { productNo: productNo, period: period };

  if (period === "CUSTOM") {
    params.startDate = $("#startDate").val();
    params.endDate = $("#endDate").val();
  }

  $.ajax({
    url: ctxPath + "/admin/accountingOptionSales.hp",
    method: "GET",
    dataType: "json",
    data: params,
    success: function (res) {
      var rows = (res && $.isArray(res.options)) ? res.options : [];
      renderOptionSales(rows);
      $("#optionSalesModal").modal("show");
    },
    error: function (xhr) {
      console.log(xhr.responseText);
      $("#optionSalesBody").html('<tr><td colspan="5" class="text-center text-danger">옵션 데이터를 불러오지 못했습니다.</td></tr>');
      $("#optionSalesModal").modal("show");
    }
  });
}

function renderOptionSales(rows) {
  var $tbody = $("#optionSalesBody");
  $tbody.empty();

  if (!rows || rows.length === 0) {
    $tbody.append('<tr><td colspan="5" class="text-center text-muted">데이터가 없습니다.</td></tr>');
    return;
  }

  for (var i = 0; i < rows.length; i++) {
    var r = rows[i];
    $tbody.append(
      '<tr>' +
        '<td>' + escapeHtml(r.optionId) + '</td>' +
        '<td>' + escapeHtml(r.color) + '</td>' +
        '<td>' + escapeHtml(r.storageSize) + '</td>' +
        '<td class="text-right">' + numberFormat(r.qty) + '</td>' +
        '<td class="text-right">₩' + numberFormat(r.amount) + '</td>' +
      '</tr>'
    );
  }
}

/* 차트 */
function initDailyChart() {
  var el = document.getElementById("dailyChart");
  if (!el) return;
  if (dailyChart) return;

  dailyChart = new Chart(el, {
    type: "line",
    data: {
      labels: [],
      datasets: [
        { label: "할인 전 판매금액", data: [], yAxisID: "yAmount", tension: 0.25, pointRadius: 2 },
        { label: "주문건수", data: [], yAxisID: "yOrders", tension: 0.25, pointRadius: 2 }
      ]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      interaction: { mode: "index", intersect: false },
      plugins: {
        legend: { display: true }
      },
      scales: {
        x: {
          ticks: { autoSkip: true, maxTicksLimit: 10, maxRotation: 0 }
        },
        yAmount: {
          position: "left",
          ticks: { callback: function (v) { return numberFormat(v); } }
        },
        yOrders: {
          position: "right",
          grid: { drawOnChartArea: false },
          ticks: { precision: 0 }
        }
      }
    }
  });
}

function updateDailyChart(rows, unit) {
  if (!dailyChart) return;

  rows = rows || [];
  var sorted = rows.slice().reverse(); // DESC -> ASC

  var labels = [];
  var amountData = [];
  var ordersData = [];

  for (var i = 0; i < sorted.length; i++) {
    labels.push(sorted[i].baseDate);
    amountData.push(Number(sorted[i].amount || 0));
    ordersData.push(Number(sorted[i].orders || 0));
  }

  dailyChart.data.labels = labels;
  dailyChart.data.datasets[0].data = amountData;
  dailyChart.data.datasets[1].data = ordersData;

  dailyChart.update();
}
