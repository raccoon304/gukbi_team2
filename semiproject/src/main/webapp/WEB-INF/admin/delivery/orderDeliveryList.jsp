<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<% String ctxPath = request.getContextPath(); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주문/배송 관리</title>

<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.1/css/all.min.css">
<link href="<%=ctxPath%>/css/admin/admin.css" rel="stylesheet" />

<script type="text/javascript" src="<%= ctxPath%>/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript" src="<%= ctxPath%>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js"></script>

<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/jquery-ui-1.13.1.custom/jquery-ui.min.css" />
<script type="text/javascript" src="<%=ctxPath%>/jquery-ui-1.13.1.custom/jquery-ui.min.js"></script>

<script src="<%=ctxPath%>/js/admin/admin_common.js"></script>
<%-- <script src="<%=ctxPath%>/js/admin/delivery.js"></script> --%>

<style>

	/* 모바일에서 테이블 가로 스크롤  */
	.yd-table-mobile { 
	  -webkit-overflow-scrolling: touch; /* 부드러운 스크롤 */
	}
	
	@media (max-width: 767.98px){
	  .yd-table-mobile table { min-width: auto !important; width: 100%; }
	  .yd-table-mobile th,
	  .yd-table-mobile td { white-space: nowrap; font-size: 12px; }
	
	}
		
		
	@media (max-width: 767.98px){
	  .col-hide-sm { display:none !important; }
	}	
	

  td.orderSummaryCell {
    min-width: 0;
    width: 240px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }
  tr.orderRow { cursor: pointer; }

  .admin-toolbar{
    background:#f8f9fa;
    border:1px solid #e9ecef;
    border-radius:12px;
    padding:12px;
  }

  .table thead th{
    background:#f8fafc;
    border-top:0;
    font-weight:600;
    color:#495057;
    white-space:nowrap;
    vertical-align:middle;
  }
  .table td{ vertical-align: middle; }
  .table td.text-center, .table th.text-center{ vertical-align: middle; }
  .orderSummaryCell strong{ font-size:0.95rem; }
  .orderSummaryCell .small{ line-height:1.2; }
  input[type="checkbox"]{ transform: translateY(1px); }

  .sel-sm { width: 140px !important; min-width: 140px !important; }
  .sel-xs { width: 120px !important; min-width: 120px !important; }

  .toolbar-row + .toolbar-row { margin-top: 8px; }

  /* ===== 주문상세 모달(관리자) 전용 ===== */
  .yd-modal-backdrop{
    position: fixed; inset: 0;
    background: rgba(0,0,0,.5);
    display: none;
    align-items: center;
    justify-content: center;
    z-index: 1050;
    padding: 1rem;
  }
  .yd-modal{
    width: 100%;
    max-width: 900px;
    background: #fff;
    border-radius: .75rem;
    overflow: hidden;
    box-shadow: 0 10px 30px rgba(0,0,0,.2);
    max-height: 90vh;
    display: flex;
    flex-direction: column;
  }
  .yd-modal-header{
    padding: 1rem 1.25rem;
    border-bottom: 1px solid #e9ecef;
    display: flex;
    align-items: center;
    justify-content: space-between;
  }
  .yd-modal-title{ font-size: 18px; font-weight: 700; margin: 0; }
  .yd-modal-close{
    background: transparent;
    border: 0;
    font-size: 22px;
    line-height: 1;
    color: #6c757d;
    cursor: pointer;
  }
  .yd-modal-body{ padding: 1.25rem; overflow: auto; }
  .yd-modal-footer{
    padding: 1rem 1.25rem;
    border-top: 1px solid #e9ecef;
    display: flex;
    justify-content: flex-end;
    gap: .5rem;
    background: #fff;
  }
  .yd-loading{ color:#6c757d; font-size:14px; }
  
  /* ===== 모바일에서 주문상세 모달 최적화 ===== */
@media (max-width: 767.98px){

  /* backdrop 여백 줄이기 */
  .yd-modal-backdrop{
    padding: .5rem;
    align-items: flex-end; /* 아래에서 올라오는 느낌(덜 답답) */
  }

  /* 모달을 화면에 맞게 */
  .yd-modal{
    max-width: 100%;
    width: 100%;
    max-height: 92vh;          /* 살짝 여유 */
    border-radius: 12px 12px 0 0;  /* 아래에서 올라오는 스타일 */
  }

  /* 헤더/바디/푸터 패딩 줄이기 */
  .yd-modal-header{
    padding: .75rem 1rem;
  }
  .yd-modal-title{
    font-size: 16px;
  }

  .yd-modal-body{
    padding: .75rem 1rem;
  }

  .yd-modal-footer{
    padding: .75rem 1rem;
  }

  /* 버튼을 꽉 차게(터치 편함) */
  .yd-modal-footer .btn{
    flex: 1;
  }

  /* 닫기 버튼 크기 조정 */
  .yd-modal-close{
    font-size: 26px;
  }
}
  
  
</style>


<script>
$(function(){

   // 주문실패 제외 토글
   $("#excludeFailToggle").on("change", function(){
	  $("#excludeFail").val(this.checked ? "1" : "0");   // hidden 값 업데이트
	  clearAllCheckedStorage();                          // 체크 초기화
	  $("input[name='currentShowPageNo']").val("1");
	  document.order_search_frm.submit();
   });

	
 
  // 체크박스 유지(페이지바 이동만 유지)
  const PREFIX = "admin_delivery_checked::";

  const STORAGE_KEY = (function(){
    const ds = $("#deliveryStatus").val() || "";
    const so = $("#sort").val() || "";
    const sp = $("#sizePerPage").val() || "";
    const st = $("#searchType").val() || "";
    const sw = ($("#searchWord").val() || "").trim();
    return PREFIX + [ds, so, sp, st, sw].join("|");
  })();

  function clearAllCheckedStorage(){
    Object.keys(sessionStorage).forEach(k => {
      if(k.indexOf(PREFIX) === 0) sessionStorage.removeItem(k);
    });
  }

  function loadSet(){
    try {
      return new Set(JSON.parse(sessionStorage.getItem(STORAGE_KEY) || "[]"));
    } catch(e){
      return new Set();
    }
  }

  function saveSet(set){
    sessionStorage.setItem(STORAGE_KEY, JSON.stringify(Array.from(set)));
  }

  function syncChkAll(){
    const total = $(".orderChk").length;
    const checkedCnt = $(".orderChk:checked").length;
    $("#chkAll").prop("checked", total > 0 && total === checkedCnt);
  }

  // 페이지바 눌러서 이동할 때만 체크 유지
  $(document).on("click", "#pageBar a, ul.pagination a", function(){
    sessionStorage.setItem("admin_delivery_fromPageBar", "1");
  });

  // 페이지바로 온게 아니면 체크 저장값 삭제
  (function clearIfNotPageBarNav(){
    const fromPageBar = (sessionStorage.getItem("admin_delivery_fromPageBar") === "1");
    sessionStorage.removeItem("admin_delivery_fromPageBar");

    if(!fromPageBar){
     // sessionStorage.removeItem(STORAGE_KEY); // 현재 조건의 저장만 삭제
       clearAllCheckedStorage(); //  전체 조건 저장까지 싹 지우고 싶으면 이 줄로 교체
    }
  })();

  // 페이지 로드되면 저장된 체크 복원
  (function restoreChecks(){
    const saved = loadSet();
    $(".orderChk").each(function(){
      if(saved.has(String(this.value))) this.checked = true;
    });
    syncChkAll();
  })();



  // 엔터 검색
  $("#searchWord").keydown(function(e){
    if(e.keyCode === 13) goSearch();
  });

  // sizePerPage 변경 -> 체크 초기화 + 1페이지로
  $("#sizePerPage").change(function(){
    clearAllCheckedStorage();
    $("input[name='currentShowPageNo']").val("1");
    document.order_search_frm.submit();
  });

  // 정렬/배송상태 변경 -> 체크 초기화 + 1페이지로
  $("#sort, #deliveryStatus").change(function(){
    clearAllCheckedStorage();
    $("input[name='currentShowPageNo']").val("1");
    document.order_search_frm.submit();
  });

  // 체크박스 클릭시 행 클릭 방지
  $(document).on("click", ".orderChk, #chkAll", function(e){
    e.stopPropagation();
  });

  // 전체 선택
  $("#chkAll").on("change", function(){
    const checked = this.checked;
    const set = loadSet();

    $(".orderChk").each(function(){
      const id = String(this.value);
      this.checked = checked;
      checked ? set.add(id) : set.delete(id); // 현재 페이지에 보이는 것만 반영
    });

    saveSet(set);
    syncChkAll();
  });

  // 개별 체크
  $(document).on("change", ".orderChk", function(){
    const set = loadSet();
    const id = String(this.value);

    this.checked ? set.add(id) : set.delete(id);

    saveSet(set);
    syncChkAll();
  });

  // ===== 행 클릭 -> 주문상세 모달 =====
  $(document).on("click", "tr.orderRow", function(e){
    if($(e.target).closest("input, button, a, label").length) return;

    const orderId = $(this).data("orderid");
    if(!orderId) return;

    openOrderModal();
    loadOrderDetail(orderId);
  });

  // 모달 닫기
  $(document).on("click", ".js-close-order-modal", function(){
    closeOrderModal();
  });

  // 바깥 클릭 닫기
  $(document).on("click", "#ydOrderModalBackdrop", function(e){
    if(e.target === this) closeOrderModal();
  });

  // ESC 닫기
  $(document).on("keydown", function(e){
    if(e.key === "Escape" && $("#ydOrderModalBackdrop").css("display") === "flex") {
      closeOrderModal();
    }
  });

  // 일괄 변경
  $("#btnBulkUpdate").off("click").on("click", function(){

    const newStatus = $("#bulkDeliveryStatus").val();
    if(newStatus === ""){
      alert("변경할 배송상태를 선택하세요.");
      return;
    }

    const $checked = $(".orderChk:checked");
    if($checked.length === 0){
      alert("변경할 주문을 체크하세요.");
      return;
    }

    // 주문실패 제외
    const invalid = $checked.filter(function(){
      return String($(this).data("status")) === "4";
    });
    if(invalid.length > 0){
      alert("주문실패 주문은 배송상태 변경 대상이 아닙니다.");
      return;
    }

    // 1(배송중)으로 바꾸려면 현재가 0만 가능
    if(String(newStatus) === "1") {
      const wrong = $checked.filter(function(){
        return String($(this).data("status")) !== "0";
      });
      if(wrong.length > 0){
        alert("배송준비중인 주문만 배송중으로 변경할 수 있습니다.");
        return;
      }
    }

    // 2(배송완료)로 바꾸려면 현재가 1만 가능
    if(String(newStatus) === "2") {
      const wrong = $checked.filter(function(){
        return String($(this).data("status")) !== "1";
      });
      if(wrong.length > 0){
        alert("배송중인 주문만 배송완료로 변경할 수 있습니다.");
        return;
      }
    }

    const orderIds = $checked.map(function(){ return $(this).val(); }).get();

    if(!confirm(orderIds.length + "건의 배송상태를 변경할까요?")) return;

    // 변경 성공 후에는 체크 초기화
    clearAllCheckedStorage();

    $("#bulk_newStatus").val(newStatus);
    $("#bulk_orderIds").val(orderIds.join(","));
    document.delivery_update_frm.submit();
  });

});


// 검색
function goSearch() {
  const searchType = $("#searchType").val();
  const searchWord = $("#searchWord").val().trim();

  if(searchType !== "" && searchWord === "") {
    alert("검색어를 입력하세요");
    return;
  }

  // 검색시 체크 초기화
  Object.keys(sessionStorage).forEach(k => {
    if(k.indexOf("admin_delivery_checked::") === 0) sessionStorage.removeItem(k);
  });

  $("input[name='currentShowPageNo']").val("1");
  document.order_search_frm.submit();
}

function openOrderModal(){
  $("#ydOrderModalBackdrop").css("display","flex").attr("aria-hidden","false");
  $("body").css("overflow","hidden");
}

function closeOrderModal(){
  $("#ydOrderModalBackdrop").hide().attr("aria-hidden","true");
  $("body").css("overflow","");
}

function loadOrderDetail(orderId){
  $("#ydModalLoading").show().text("불러오는 중...");
  $("#ydModalContent").hide().empty();

  fetch("<%=ctxPath%>/admin/delivery/orderDetailFragment.hp?orderNo=" + encodeURIComponent(orderId), {
    method: "GET",
    headers: { "X-Requested-With": "XMLHttpRequest" }
  })
  .then(res => {
    if(!res.ok) throw new Error("HTTP " + res.status);
    return res.text();
  })
  .then(html => {
    $("#ydModalContent").html(html).show();
    $("#ydModalLoading").hide();
  })
  .catch(err => {
    $("#ydModalLoading").show().text("상세 정보를 불러오지 못했습니다. (" + err.message + ")");
  });
}
</script>

</head>

<body>

<!-- 메시지: 성공이면 div, 실패면 alert() -->
<c:if test="${not empty msg}">
  <c:set var="isSuccess" value="${fn:contains(msg, '완료')}" />
  <c:if test="${!isSuccess}">
    <script>
      alert("${fn:escapeXml(msg)}");
    </script>
  </c:if>
</c:if>

<div class="wrapper">
  <jsp:include page="/WEB-INF/admin/admin_sidebar.jsp" />
  <div class="sidebar-overlay" id="sidebarOverlay"></div>

  <div class="main-content">
	<div class="mobile-topbar d-lg-none">
	  <button type="button" class="btn btn-light btn-sm" id="btnSidebarToggle">
	    <i class="fas fa-bars"></i>
	  </button>
	  <span class="ml-2 font-weight-bold">관리자</span>
	</div>
    <div class="content-wrapper">
      <div class="container-fluid p-4">

        <div class="mb-4">
          <h2 class="mb-2">주문/배송 관리</h2>
          <p class="text-muted">주문 및 배송 정보를 조회/관리할 수 있습니다</p>
        </div>

        <div class="card">
          <div class="card-header d-flex justify-content-between align-items-center">
            <h5 class="mb-0">주문 목록</h5>
            <span class="text-muted small">
              <c:if test="${not empty requestScope.totalCount}">
                총 ${requestScope.totalCount}건
              </c:if>
            </span>
          </div>

          <div class="card-body">

            <!-- 성공 메시지만 상단 div로 보여주기 -->
            <c:if test="${not empty msg}">
              <c:set var="isSuccess" value="${fn:contains(msg, '완료')}" />
              <c:if test="${isSuccess}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                  ${msg}
                  <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                  </button>
                </div>
              </c:if>
            </c:if>

            <!-- 검색/필터 -->
            <form name="order_search_frm" method="get" action="<%=ctxPath%>/admin/delivery/orderDeliveryList.hp">
              <div class="admin-toolbar mb-3">

                <!-- 필터 + 일괄변경 -->
                <div class="d-flex flex-wrap align-items-center justify-content-between toolbar-row">

                  <div class="d-flex flex-wrap align-items-center">
                    <select class="custom-select sel-sm mr-2 mb-2" name="deliveryStatus" id="deliveryStatus">
                      <option value="ALL" <c:if test="${empty deliveryStatus || deliveryStatus == 'ALL'}">selected</c:if>>배송상태(전체)</option>
                      <option value="0"   <c:if test="${deliveryStatus == '0'}">selected</c:if>>배송준비중</option>
                      <option value="1"   <c:if test="${deliveryStatus == '1'}">selected</c:if>>배송중</option>
                      <option value="2"   <c:if test="${deliveryStatus == '2'}">selected</c:if>>배송완료</option>
                      <option value="4"   <c:if test="${deliveryStatus == '4'}">selected</c:if>>주문실패</option>
                    </select>

                    <select class="custom-select sel-sm mr-2 mb-2" name="sort" id="sort">
                      <option value="latest" <c:if test="${empty sort || sort == 'latest'}">selected</c:if>>주문일 최신순</option>
                      <option value="oldest" <c:if test="${sort == 'oldest'}">selected</c:if>>주문일 오래된순</option>
                    </select>

                    <select class="custom-select sel-xs mr-2 mb-2" name="sizePerPage" id="sizePerPage">
                      <option value="10" <c:if test="${empty sizePerPage || sizePerPage == '10'}">selected</c:if>>10건씩</option>
                      <option value="5"  <c:if test="${sizePerPage == '5'}">selected</c:if>>5건씩</option>
                    </select>
                    
                    <div class="custom-control custom-switch mr-3 mb-2">
					  <input type="checkbox" class="custom-control-input" id="excludeFailToggle"
					         <c:if test="${excludeFail == '1'}">checked</c:if>>
					  <label class="custom-control-label" for="excludeFailToggle">주문실패 제외</label>
					</div>
                    
                  </div>

                  <div class="d-flex align-items-center mb-2">
                    <select class="custom-select sel-sm mr-2" id="bulkDeliveryStatus">
                      <option value="">배송상태 선택</option>
                      <%-- <option value="0">배송준비중</option> --%>
                      <option value="1">배송중</option>
                      <option value="2">배송완료</option>
                    </select>

                    <button type="button" class="btn btn-primary" id="btnBulkUpdate" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                      <i class="fas fa-pen-to-square mr-1"></i> 상태변경
                    </button>
                  </div>

                </div>

                <!-- 검색 -->
                <div class="d-flex flex-wrap align-items-center toolbar-row">

                  <select class="custom-select mr-2 mb-2" name="searchType" id="searchType" style="width:130px;">
                    <option value="" <c:if test="${empty searchType}">selected</c:if>>검색대상</option>
                    <option value="member_id" <c:if test="${searchType == 'member_id'}">selected</c:if>>아이디</option>
                    <option value="name" <c:if test="${searchType == 'name'}">selected</c:if>>회원명</option>
                    <option value="recipient_name" <c:if test="${searchType == 'recipient_name'}">selected</c:if>>수령인명</option>
                    <option value="order_id" <c:if test="${searchType == 'order_id'}">selected</c:if>>주문번호</option>
                  </select>

                  <div class="input-group mr-2 mb-2" style="width:560px;">
                    <input type="text" class="form-control" name="searchWord" id="searchWord"
                           value="${searchWord}" placeholder="검색어 입력">
                    <div class="input-group-append">
                      <button type="button" class="btn btn-outline-secondary" onclick="goSearch()">
                        <i class="fas fa-search"></i>
                      </button>
                    </div>
                  </div>

                </div>

              </div>

			  <input type="hidden" name="excludeFail" id="excludeFail" value="${empty excludeFail ? '0' : excludeFail}" />			  
              <input type="hidden" name="currentShowPageNo" value="${empty currentShowPageNo ? '1' : currentShowPageNo}" />
            </form>

            <!-- 테이블 -->       
            <div class="table-responsive yd-table-mobile">
             <table class="table table-hover table-fixed">
               <thead>
                 <tr>
                   <th style="width:50px;" class="text-center">
                     <input type="checkbox" id="chkAll" />
                   </th>

                   <th style="width:90px;">주문번호</th>
                   <th style="width:130px;">주문일</th>
                   <th class="col-hide-sm" style="width:120px;">아이디</th>
                   <th class="col-hide-sm" style="width:120px;">이름</th>
                   <th style="width:210px;">주문상품</th>
                   <th style="width:140px;">결제금액</th>
                   <th class="col-hide-sm" style="width:110px;">수령인</th>
                   <th class="col-hide-sm" style="width:140px;">배송번호</th>
                   <th class="col-hide-sm" style="width:120px;">배송시작일</th>
                   <th  class="col-hide-sm" style="width:120px;">배송완료일</th>
                   <th style="width:110px;">배송상태</th>
                 </tr>
               </thead>

               <tbody>
                 <c:set var="orderList" value="${requestScope.orderList}" />

                 <c:if test="${empty orderList}">
                   <tr>
                     <td colspan="12" class="text-center text-muted py-4">주문 내역이 없습니다.</td>
                   </tr>
                 </c:if>

                 <c:if test="${not empty orderList}">
                   <c:forEach var="r" items="${orderList}">
                     <tr class="orderRow" data-orderid="${r.odto.orderId}">
                       <td class="text-center">
                         <input type="checkbox" class="orderChk"
                                value="${r.odto.orderId}"
                                data-status="${r.deliveryStatus}" />
                       </td>

                       <td >${r.odto.orderId}</td>
                       <td>${r.odto.orderDate}</td>
                       <td class="col-hide-sm">${r.odto.memberId}</td>
                       <td class="col-hide-sm">${r.mdto.name}</td>

                       <td class="orderSummaryCell">
                         <div>
                           <div class="small text-muted"><small class="text-muted">${r.pdto.brandName}</small></div>
                           <strong>${r.pdto.productName}</strong>
                           <c:if test="${r.detailCnt > 1}">
                             <span class="text-dark"> 외 ${r.detailCnt - 1}건</span>
                           </c:if>
                           <div class="small text-muted">${r.podto.color} / ${r.podto.storageSize}</div>
                         </div>
                       </td>

                       <td class="text-right">
                         <fmt:formatNumber value="${r.payAmount}" pattern="#,###"/>원
                       </td>

                       <td class="col-hide-sm">${r.recipientName}</td>

                       <td class="col-hide-sm">${r.deliveryNumber}</td>
                       <td class="col-hide-sm">${r.deliveryStartdate}</td>
                       <td class="col-hide-sm">${r.deliveryEnddate}</td>

                       <td>
                         <c:choose>
                           <c:when test="${r.deliveryStatus == 0}">
                             <span class="badge badge-pill badge-info">배송준비중</span>
                           </c:when>
                           <c:when test="${r.deliveryStatus == 1}">
                             <span class="badge badge-pill badge-warning">배송중</span>
                           </c:when>
                           <c:when test="${r.deliveryStatus == 2}">
                             <span class="badge badge-pill badge-secondary">배송완료</span>
                           </c:when>
                           <c:otherwise>
                             <span class="badge badge-pill badge-danger">주문실패</span>
                           </c:otherwise>
                         </c:choose>
                       </td>
                     </tr>
                   </c:forEach>
                 </c:if>

               </tbody>
               </table>
            </div>  
            

            <!-- pageBar -->
            <c:if test="${not empty requestScope.pageBar}">
              <div id="pageBar" class="mt-3">
                <nav>
                  <ul class="pagination justify-content-center">${requestScope.pageBar}</ul>
                </nav>
              </div>
            </c:if>

          </div>
        </div>

      </div>
    </div>
  </div>
</div>

<!-- ===== 주문상세 모달 ===== -->
<div id="ydOrderModalBackdrop" class="yd-modal-backdrop" aria-hidden="true">
  <div class="yd-modal" role="dialog" aria-modal="true" aria-labelledby="ydModalTitle">
    <div class="yd-modal-header">
      <h3 class="yd-modal-title" id="ydModalTitle">주문 내역 상세</h3>
      <button type="button" class="yd-modal-close js-close-order-modal" aria-label="Close">&times;</button>
    </div>

    <div class="yd-modal-body">
      <div id="ydModalLoading" class="yd-loading">불러오는 중...</div>
      <div id="ydModalContent" style="display:none;"></div>
    </div>

    <div class="yd-modal-footer">
      <button type="button" class="btn btn-secondary js-close-order-modal">닫기</button>
    </div>
  </div>
</div>

<!-- submit용 폼 -->
<form name="delivery_update_frm" method="post" action="<%=ctxPath%>/admin/delivery/deliveryStatusUpdate.hp">
  <input type="hidden" name="newStatus" id="bulk_newStatus" />
  <input type="hidden" name="orderIds"  id="bulk_orderIds" />

  <input type="hidden" name="deliveryStatus" value="${deliveryStatus}" />
  <input type="hidden" name="sort" value="${sort}" />
  <input type="hidden" name="sizePerPage" value="${sizePerPage}" />
  <input type="hidden" name="currentShowPageNo" value="${currentShowPageNo}" />
  <input type="hidden" name="searchType" value="${searchType}" />
  <input type="hidden" name="searchWord" value="${searchWord}" />
</form>

</body>
</html>
