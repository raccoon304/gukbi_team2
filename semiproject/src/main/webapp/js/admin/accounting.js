let dailyChart = null;

$(function () {
  // datepicker
  $("#startDate, #endDate").datepicker({
    dateFormat: "yy-mm-dd"
  });
  
  initDailyChart(); // 차트

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

  // 상품 정렬 변경 시
  $("#productSort").on("change", function () {
    const period = $("#periodSelect").val();
    if (period === "CUSTOM") {
      fetchAccounting("CUSTOM", $("#startDate").val(), $("#endDate").val());
    } else {
      fetchAccounting(period);
    }
  });
  
  
  
  // 상품 행 클릭 -> 옵션별 판매수량 모달
  $("#productStatsBody").on("click", "tr.product-row", function () {
    const productNo = $(this).data("product-no");
    const productName = $(this).data("product-name");
    const brand = $(this).data("brand");

    openOptionSalesModal(productNo, productName, brand);
  });
  
  
  
});// end of $(function(){}) -------

function fetchAccounting(period, startDate, endDate) {
  const sort = $("#productSort").val();

  $.ajax({
    url: ctxPath + "/admin/accountingData.hp",
    method: "GET",
    dataType: "json",
    data: {
      period,
      startDate,  // CUSTOM일 때만 사용
      endDate,    // CUSTOM일 때만 사용
      sort
    },
    success: function (res) {

		
	   const t = (res && res.totals) ? res.totals : { orders:0, qty:0, gross:0, discount:0, net:0 };
      // 기간 라벨
      $("#rangeLabel").text(res.rangeLabel || "");

      // 상단 카드
      $("#totalOrders").text(numberFormat(res.totals.orders) + "건");
      $("#totalSales").text(numberFormat(res.totals.qty) + "개");
      $("#totalRevenue").text("₩" + numberFormat(res.totals.gross));
      $("#totalDiscount").text("₩" + numberFormat(res.totals.discount));
      $("#finalPayment").text("₩" + numberFormat(res.totals.net));
	  
	  renderDaily(res && res.daily ? res.daily : []);
	    renderProducts(res && res.products ? res.products : []);

      // 기간별 집계
	  $("#baseDateHeader").text(res.unit === "MONTH" ? "기준월" : "기준일");
      renderDaily(res.daily);
	  
	  // 차트
	  updateDailyChart(res.daily);

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
		<tr class="product-row" style="cursor:pointer;"
	        data-product-no="${r.productNo}"
	        data-product-name="${escapeHtml(r.productName)}"
	        data-brand="${escapeHtml(r.brand)}">
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


/*상품별 모달*/
function openOptionSalesModal(productNo, productName, brand) {
  // 모달 타이틀/기간 라벨
  $("#modalProductTitle").text(`${productName} (${brand}) / ${productNo}`);
  $("#modalRangeLabel").text($("#rangeLabel").text() || "");

  // 로딩 표시
  $("#optionSalesBody").html(`<tr><td colspan="5" class="text-center text-muted">불러오는 중...</td></tr>`);

  // 현재 선택된 기간 파라미터
  const period = $("#periodSelect").val();
  const sort = $("#productSort").val();

  let params = { productNo, period };

  if (period === "CUSTOM") {
    params.startDate = $("#startDate").val();
    params.endDate = $("#endDate").val();
  }

  $.ajax({
    url: ctxPath + "/admin/accountingOptionSales.hp",
    method: "GET",
    dataType: "json",
    data: params,
    success: function(res) {
      renderOptionSales(res.options);
      $("#optionSalesModal").modal("show");
    },
    error: function(xhr) {
      console.log(xhr.responseText);
      $("#optionSalesBody").html(`<tr><td colspan="5" class="text-center text-danger">옵션 데이터를 불러오지 못했습니다.</td></tr>`);
      $("#optionSalesModal").modal("show");
    }
  });
}


function renderOptionSales(rows) {
  const $tbody = $("#optionSalesBody");
  $tbody.empty();

  if (!rows || rows.length === 0) {
    $tbody.append(`<tr><td colspan="5" class="text-center text-muted">데이터가 없습니다.</td></tr>`);
    return;
  }

  rows.forEach(r => {
    $tbody.append(`
      <tr>
        <td>${r.optionId}</td>
        <td>${escapeHtml(r.color)}</td>
        <td>${escapeHtml(r.storageSize)}</td>
        <td class="text-right">${numberFormat(r.qty)}</td>
		<td class="text-right">₩${numberFormat(r.amount)}</td>
      </tr>
    `);
  });
}



// 차트 함수
function initDailyChart() {
  const el = document.getElementById("dailyChart");
  if (!el) return;

  // 있으면 재생성 방지
  if (dailyChart) return;

  dailyChart = new Chart(el, {
    type: "line",
    data: {
      labels: [],
      datasets: [
        {
          label: "할인 전 판매금액",
          data: [],
          yAxisID: "yAmount",
          tension: 0.25,
          pointRadius: 2
        },
        {
          label: "주문건수",
          data: [],
          yAxisID: "yOrders",
          tension: 0.25,
          pointRadius: 2
        }
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
        yAmount: {
          position: "left",
          ticks: { callback: (v) => numberFormat(v) }
        },
        yOrders: {
          position: "right",
          grid: { drawOnChartArea: false },
          ticks: { precision: 0 }
        }
      }
    }
  });
}// end of function initDailyChart() -------

function updateDailyChart(rows) {
  if (!dailyChart) return;

  rows = rows || [];

  // 다시 정렬 (테이블은 DESC로 -> 차트는 ASC)
  const sorted = [...rows].reverse();

  dailyChart.data.labels = sorted.map(r => r.baseDate);
  dailyChart.data.datasets[0].data = sorted.map(r => Number(r.amount || 0));
  dailyChart.data.datasets[1].data = sorted.map(r => Number(r.orders || 0));

  dailyChart.update();
}// end of function updateDailyChart(rows) -------


