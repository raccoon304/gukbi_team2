<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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

<script src="<%=ctxPath%>/js/admin/delivery.js"></script>

<style>
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

  /* ==== select 폭 줄이기 ==== */
  .sel-sm { width: 140px !important; min-width: 140px !important; }
  .sel-xs { width: 120px !important; min-width: 120px !important; }

  /* 검색줄 간격 */
  .toolbar-row + .toolbar-row { margin-top: 8px; }
  
  
</style>

<script>
$(function(){

  // 엔터 검색
  $("#searchWord").keydown(function(e){
    if(e.keyCode === 13) goSearch();
  });

  // sizePerPage 변경
  $("#sizePerPage").change(function(){
    $("input[name='currentShowPageNo']").val("1");
    document.order_search_frm.submit();
  });

  // 정렬/배송상태 변경
  $("#sort, #deliveryStatus").change(function(){
    $("input[name='currentShowPageNo']").val("1");
    document.order_search_frm.submit();
  });

  // 체크박스 클릭시 행 클릭 방지
  $(document).on("click", ".orderChk, #chkAll", function(e){
    e.stopPropagation();
  });

  // 전체 선택
  $("#chkAll").on("change", function(){
    const checked = $(this).prop("checked");
    $(".orderChk").prop("checked", checked);
  });

  // 개별 체크 변경시 전체선택 갱신
  $(document).on("change", ".orderChk", function(){
    const total = $(".orderChk").length;
    const checkedCnt = $(".orderChk:checked").length;
    $("#chkAll").prop("checked", total > 0 && total === checkedCnt);
  });

  // 행 클릭
  $(document).on("click", "tr.orderRow", function(){
    const orderId = $(this).data("orderid");
    console.log("clicked orderId =", orderId);
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

    // 결제실패 제외
    const invalid = $checked.filter(function(){
      return String($(this).data("status")) === "4";
    });
    if(invalid.length > 0){
      alert("결제실패 주문은 배송상태 변경 대상이 아닙니다.");
      return;
    }

    const orderIds = $checked.map(function(){ return $(this).val(); }).get();

    if(!confirm(orderIds.length + "건의 배송상태를 변경할까요?")) return;

    $("#bulk_newStatus").val(newStatus);
    $("#bulk_orderIds").val(orderIds.join(","));
    document.delivery_update_frm.submit();
  });

});

function goSearch() {
  const searchType = $("#searchType").val();
  const searchWord = $("#searchWord").val().trim();

  if(searchType !== "" && searchWord === "") {
    alert("검색어를 입력하세요");
    return;
  }

  $("input[name='currentShowPageNo']").val("1");
  document.order_search_frm.submit();
}
</script>
</head>

<body>
<div class="wrapper">
  <jsp:include page="/WEB-INF/admin/admin_sidebar.jsp" />

  <div class="main-content">
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

            <!-- flash 메시지 -->
            <c:if test="${not empty msg}">
              <div class="alert ${msg eq '변경 완료' ? 'alert-success' : 'alert-danger'} alert-dismissible fade show" role="alert">
                ${msg}
                <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                  <span aria-hidden="true">&times;</span>
                </button>
              </div>
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
                  </div>

                  <div class="d-flex align-items-center mb-2">
                    <select class="custom-select sel-sm mr-2" id="bulkDeliveryStatus">
                      <option value="">배송상태 선택</option>
                      <option value="0">배송준비중</option>
                      <option value="1">배송중</option>
                      <option value="2">배송완료</option>
                    </select>

                    <button type="button" class="btn btn-primary" id="btnBulkUpdate">
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

              <input type="hidden" name="currentShowPageNo" value="${empty currentShowPageNo ? '1' : currentShowPageNo}" />
            </form>

            <!-- 테이블 -->
            <div class="table-responsive">
              <table class="table table-hover table-fixed">
                <thead>
                  <tr>
                    <th style="width:50px;" class="text-center">
                      <input type="checkbox" id="chkAll" />
                    </th>
                    <th style="width:70px;">주문번호</th>
                    <th style="width:120px;">아이디</th>
                    <th style="width:120px;">이름</th>
                    <th style="width:120px;">주문상품</th>
                    <th style="width:150px;">결제금액</th>
                    <th style="min-width:270px;">배송지</th>
                    <th style="width:110px;">수령인</th>
                    <th style="width:150px;">수령인 번호</th>
                    <th style="width:110px;">배송상태</th>
                    <th style="width:140px;">주문일자</th>
                  </tr>
                </thead>

                <tbody>
                  <c:set var="orderList" value="${requestScope.orderList}" />

                  <c:if test="${empty orderList}">
                    <tr>
                      <td colspan="11" class="text-center text-muted py-4">주문 내역이 없습니다.</td>
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

				   <%-- <td>${r.rownum}</td> --%> <%-- 1부터 시작하는 그냥 번호 --%>
						<td>${r.odto.orderId}</td>
                        <td>${r.odto.memberId}</td>
                        <td>${r.mdto.name}</td>

                        <td class="orderSummaryCell">
                          <div>
                            <div class="small text-muted">
                              <small class="text-muted">${r.pdto.brandName}</small>
                            </div>

                            <strong>${r.pdto.productName}</strong>

                            <c:if test="${r.detailCnt > 1}">
                              <span class="text-dark"> 외 ${r.detailCnt - 1}건</span>
                            </c:if>

                            <div class="small text-muted">
                              ${r.podto.color} / ${r.podto.storageSize}
                            </div>
                          </div>
                        </td>

                        <td class="text-right">
                          <fmt:formatNumber value="${r.payAmount}" pattern="#,###"/>원
                        </td>

                        <td>${r.odto.deliveryAddress}</td>
                        <td>${r.recipientName}</td>
                        <td>${r.recipientPhone}</td>

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

                        <td>${r.odto.orderDate}</td>
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
