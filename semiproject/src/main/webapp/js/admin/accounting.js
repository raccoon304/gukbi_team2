// 차트 객체
var dailyChart = null;

$(function () {

  // datepicker 초기화 + 달력 닫힐 때 입력값 검증
  $("#startDate, #endDate").datepicker({
    dateFormat: "yy-mm-dd",
    changeMonth: true,
    changeYear: true,
    showButtonPanel: true,
    onClose: function () {
      validateDateInput($(this)); // 달력 닫힐 때 검사
    }
  });

  // 키보드로 입력 후 포커스 빠질 때 날짜 검증
  $("#startDate, #endDate").on("blur", function () {
    validateDateInput($(this));
  });

  // 차트 생성
  initDailyChart();

  // 기본 기간으로 데이터 조회
  fetchAccounting($("#periodSelect").val());

  // 기간 셀렉트 변경 시(사용자 지정이면 입력창만 보여줌)
  $("#periodSelect").on("change", function () {
    var period = $(this).val();

    if (period === "CUSTOM") {
      $("#customRange").show();
      $("#customRangeError").hide().text("");
      $("#startDate, #endDate").removeClass("is-invalid");
      return; // CUSTOM은 적용 버튼으로만 조회
    }

    $("#customRange").hide();
    fetchAccounting(period);
  });

  // 사용자 지정 날짜 적용 버튼 클릭 시 검증 후 조회
  $("#applyCustom").on("click", function () {
    var $sd = $("#startDate");
    var $ed = $("#endDate");

    var s = ($sd.val() || "").trim();
    var e = ($ed.val() || "").trim();

    // 빈값 체크
    if (!s || !e) {
      showRangeError("시작일/종료일을 입력해주세요.");
      if (!s) $sd.addClass("is-invalid"); else $sd.removeClass("is-invalid");
      if (!e) $ed.addClass("is-invalid"); else $ed.removeClass("is-invalid");
      return;
    }

    // 형식/실제날짜 체크
    var okS = validateDateInput($sd);
    var okE = validateDateInput($ed);

    if (!okS || !okE) {
      return; // validateDateInput에서 메시지 처리
    }

    // 시작/종료 비교(종료일이 시작일보다 빠르면 막기)
    var d1 = parseYmdToDate(s);
    var d2 = parseYmdToDate(e);

    if (d1.getTime() > d2.getTime()) {
      $sd.addClass("is-invalid");
      $ed.addClass("is-invalid");
      showRangeError("시작일은 종료일보다 클 수 없습니다.");
      return;
    }

    // 통과하면 에러 초기화 후 조회
    $("#customRangeError").hide().text("");
    $sd.removeClass("is-invalid");
    $ed.removeClass("is-invalid");

    fetchAccounting("CUSTOM", s, e);
  });

  // 상품 정렬 변경 시 현재 기간으로 다시 조회
  $("#productSort").on("change", function () {
    var period = $("#periodSelect").val();
    if (period === "CUSTOM") {
      fetchAccounting("CUSTOM", $("#startDate").val(), $("#endDate").val());
    } else {
      fetchAccounting(period);
    }
  });

  // 상품 행 클릭 시 옵션별 집계 모달 열기
  $("#productStatsBody").on("click", "tr.product-row", function () {
    var productNo = $(this).data("product-no");
    var productName = $(this).data("product-name");
    var brand = $(this).data("brand");
    openOptionSalesModal(productNo, productName, brand);
  });

});

// 회계 데이터 AJAX 조회 후 상단카드/테이블/차트 갱신
function fetchAccounting(period, startDate, endDate) {
  var sort = $("#productSort").val();

  $.ajax({
    url: ctxPath + "/admin/accountingData.hp",
    method: "GET",
    dataType: "json",
    data: { period: period, startDate: startDate, endDate: endDate, sort: sort },
    success: function (res) {

      // 응답이 없거나 누락돼도 기본값 유지
      var t = (res && res.totals) ? res.totals : { orders: 0, qty: 0, gross: 0, discount: 0, net: 0 };
      var daily = (res && $.isArray(res.daily)) ? res.daily : [];
      var products = (res && $.isArray(res.products)) ? res.products : [];
      var unit = (res && res.unit) ? res.unit : "DAY";

      // 기간 라벨 표시
      $("#rangeLabel").text((res && res.rangeLabel) ? res.rangeLabel : "");

      // 상단 카드 표시
      $("#totalOrders").text(numberFormat(t.orders) + "건");
      $("#totalSales").text(numberFormat(t.qty) + "개");
      $("#totalRevenue").text("₩" + numberFormat(t.gross));
      $("#totalDiscount").text("₩" + numberFormat(t.discount));
      $("#finalPayment").text("₩" + numberFormat(t.net));

      // 기간별 헤더
      $("#baseDateHeader").text(unit === "MONTH" ? "기준월" : "기준일");

      // 테이블 렌더링
      renderDaily(daily);
      renderProducts(products);

      // 차트 업데이트
      updateDailyChart(daily, unit);
    },
    error: function (xhr) {
      console.log(xhr.responseText);

      // 실패 시 0/없음으로 표시
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

// 기간별 집계 테이블 렌더링
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

// 상품별 집계 테이블 렌더링
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

// 숫자 천단위 콤마
function numberFormat(n) {
  if (n === null || n === undefined) n = 0;
  var num = Number(n);
  if (isNaN(num)) return "0";
  return String(num).replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

// XSS 방지용 HTML 이스케이프
function escapeHtml(str) {
  if (str === null || str === undefined) return "";
  return String(str)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#039;");
}

// 상품 클릭 시 옵션별 집계 모달 데이터 조회 + 표시
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

// 옵션별 집계 모달 테이블 렌더링
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

// Chart.js 라인 차트 최초 생성
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
        x: { ticks: { autoSkip: true, maxTicksLimit: 10, maxRotation: 0 } },
        yAmount: { position: "left", ticks: { callback: function (v) { return numberFormat(v); } } },
        yOrders: { position: "right", grid: { drawOnChartArea: false }, ticks: { precision: 0 } }
      }
    }
  });
}

// 응답 데이터로 차트 라벨/데이터 갱신
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

/* ===== 날짜 키보드 입력 검증 ===== */

// YYYY-MM-DD 형식 + 실제 존재 날짜인지 검증 후 에러 표시
function validateDateInput($input) {
  var v = ($input.val() || "").trim();

  // 빈값이면 invalid 해제 + 메시지 정리
  if (!v) {
    $input.removeClass("is-invalid");
    clearRangeErrorIfAllValid();
    return true;
  }

  // 형식 체크
  if (!/^\d{4}-\d{2}-\d{2}$/.test(v)) {
    markInvalid($input, "날짜 형식은 YYYY-MM-DD 입니다.");
    return false;
  }

  // 실제 날짜 체크
  var parts = v.split("-");
  var y = parseInt(parts[0], 10);
  var m = parseInt(parts[1], 10);
  var d = parseInt(parts[2], 10);

  var dt = new Date(y, m - 1, d);
  var ok = (dt.getFullYear() === y && dt.getMonth() === (m - 1) && dt.getDate() === d);

  if (!ok) {
    markInvalid($input, "존재하지 않는 날짜입니다.");
    return false;
  }

  // 유효하면 invalid 해제 + 에러 박스 정리
  $input.removeClass("is-invalid");
  clearRangeErrorIfAllValid();

  // datepicker 내부 날짜 맞춤
  try { $input.datepicker("setDate", v); } catch (e) {}

  return true;
}

// input에 invalid 표시 + 에러박스 메시지 출력
function markInvalid($input, msg) {
  $input.addClass("is-invalid");
  var who = ($input.attr("id") === "startDate") ? "시작일" : "종료일";
  showRangeError(who + "을(를) 올바르게 입력해주세요. " + msg);
}

// #customRangeError 박스에 메시지 출력
function showRangeError(msg) {
  $("#customRangeError").text(msg).show();
}

// 두 입력이 모두 정상일 때 에러 박스 숨김
function clearRangeErrorIfAllValid() {
  var ok1 = !$("#startDate").hasClass("is-invalid");
  var ok2 = !$("#endDate").hasClass("is-invalid");

  if (ok1 && ok2) {
    $("#customRangeError").hide().text("");
  }
}

// YYYY-MM-DD 문자열을 Date로 변환
function parseYmdToDate(v) {
  var p = v.split("-");
  return new Date(parseInt(p[0], 10), parseInt(p[1], 10) - 1, parseInt(p[2], 10));
}
