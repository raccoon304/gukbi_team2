<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<% String ctxPath = request.getContextPath(); %>

<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.1/css/all.min.css">
<link href="<%=ctxPath%>/css/review/review.css" rel="stylesheet" />

<script type="text/javascript" src="<%= ctxPath%>/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript" src="<%= ctxPath%>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js"></script>

<jsp:include page="../header.jsp"/>

<style>
  .rv-thumb-lg{
    width: 110px;
    height: 110px;
    object-fit: cover;
    border-radius: 10px;
    border: 1px solid #e5e5e5;
    background: #fafafa;
  }
  tr.rv-row{ cursor:pointer; }
  tr.rv-row:hover{ background:#f8f9fa; }
</style>

<div class="container" style="margin-top:5%;">

  <div class="d-flex justify-content-between align-items-center mb-3">
    <h4 class="mb-0"><i class="fa-solid fa-star mr-2"></i>구매 리뷰</h4>

    <div>
      <a class="btn btn-primary btn-sm"
         href="<%=ctxPath%>/review/reviewWrite.hp?productCode=ALL"> <%-- href="<%=ctxPath%>/review/reviewWrite.hp?productCode=${productCode}"> --%>
        <i class="fa-solid fa-pen-to-square mr-1"></i>리뷰 작성
      </a>
    </div>
  </div>

  <!-- 상품 선택 필터 -->
  <form method="get" action="<%=ctxPath%>/review/reviewList.hp" class="form-inline mb-3">
    <input type="hidden" name="sort" value="${sort}"/>
    <input type="hidden" name="sizePerPage" value="${sizePerPage}"/>
    <input type="hidden" name="currentShowPageNo" value="1"/>

    <label class="mr-2 font-weight-bold">상품선택</label>
    <select name="productCode" id="productCodeSel" class="form-control form-control-sm" style="min-width:260px;">
      <option value="ALL" <c:if test="${productCode == 'ALL'}">selected</c:if>>전체 상품</option>

      <c:forEach var="p" items="${productList}">
        <option value="${p.productCode}" <c:if test="${productCode == p.productCode}">selected</c:if>>
          <c:out value="${p.brandName}" /> <c:out value="${p.productName}" />
        </option>
      </c:forEach>
    </select>
  </form>

  <div class="mb-2 text-muted">
    총 <b>${totalCount}</b>건 / ${currentShowPageNo}페이지 (총 ${totalPage}페이지)
  </div>

  <c:if test="${empty reviewList}">
    <div class="alert alert-light border text-center py-5">
      아직 등록된 리뷰가 없습니다.
    </div>
  </c:if>

  <c:if test="${not empty reviewList}">
    <div class="table-responsive">
    <fmt:parseNumber var="currentShowPageNo" value="${requestScope.currentShowPageNo}"/>
	<fmt:parseNumber var="sizePerPage" value="${requestScope.sizePerPage}"/>
      <table class="table table-hover align-middle">
        <thead class="thead-light">
          <tr>
            <th style="width:50px;">No</th>
            <th style="width:140px;"></th>
            <th style="width:200px;">제목</th>
            <th style="width:150px;">작성자</th>
            <th style="width:240px;">구매 상품</th>
            <th style="width:140px;">별점</th>
            <th style="width:170px;">작성일</th>
          </tr>
        </thead>

        <tbody>
        <c:forEach var="rv" items="${reviewList}" varStatus="status">
          <tr class="rv-row"
              data-no="${rv.reviewNumber}"
              data-productcode="${productCode}"
              data-sort="${sort}"
              data-size="${sizePerPage}"
              data-page="${currentShowPageNo}">

			<td>${totalCount - ((curPage - 1) * perPage) - status.index}</td>
            
            <td>
              <c:choose>
                <c:when test="${not empty rv.thumbPath}">
                  <img src="<%=ctxPath%>${rv.thumbPath}" class="rv-thumb-lg" alt="thumb"/>
                </c:when>
                <c:otherwise>
                  <div class="rv-thumb-lg d-flex align-items-center justify-content-center text-muted">
                    NO IMAGE
                  </div>
                </c:otherwise>
              </c:choose>
            </td>

            <td>
              <div class="font-weight-bold">
                <c:out value="${rv.reviewTitle}" />
              </div>
              <div class="text-muted small" style="white-space:nowrap; overflow:hidden; text-overflow:ellipsis; max-width:420px;">
                <c:out value="${rv.reviewContent}" />
              </div>
            </td>

            <td>
              <div class="font-weight-bold">
                <c:out value="${rv.mdto.memberid}" />
              </div>
              <small class="text-muted"><c:out value="${rv.mdto.name}" /></small>
            </td>

            <td class="small">
              <div>
                <b><c:out value="${rv.pdto.brandName}" /></b>
                <b><c:out value="${rv.pdto.productName}" /></b>
              </div>
              <div class="text-muted">
                <b><c:out value="${rv.podto.color}" /></b>
                <b><c:out value="${rv.podto.storageSize}" /></b>
              </div>
            </td>

            <td>
              <c:set var="r" value="${rv.rating}" />
              <span>
                <c:forEach begin="1" end="5" var="i">
                  <c:choose>
                    <c:when test="${i <= r}">
                      <i class="fa-solid fa-star"></i>
                    </c:when>
                    <c:when test="${(i - 0.5) <= r && i > r}">
                      <i class="fa-solid fa-star-half-stroke"></i>
                    </c:when>
                    <c:otherwise>
                      <i class="fa-regular fa-star"></i>
                    </c:otherwise>
                  </c:choose>
                </c:forEach>
              </span>
              <div class="small text-muted"><c:out value="${rv.rating}" /></div>
            </td>

            <td class="text-muted">
              <c:out value="${rv.writeday}" />
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </div>
  </c:if>

  <div class="mt-4 d-flex justify-content-center">
    <nav aria-label="Page navigation">
      <ul class="pagination pagination-sm mb-0">
        ${pageBar}
      </ul>
    </nav>
  </div>

</div>

<script>
$(function(){

  // 상품 필터 변경시 바로 submit
  $("#productCodeSel").on("change", function(){
    $(this).closest("form").submit();
  });

  // 행 클릭 -> 상세로
  $(document).on("click", "tr.rv-row", function(){
    const reviewNumber = $(this).data("no");
    const productCode = $(this).data("productcode");
    const sort = $(this).data("sort");
    const sizePerPage = $(this).data("size");
    const currentShowPageNo = $(this).data("page");

    location.href = "<%=ctxPath%>/review/reviewDetail.hp"
                  + "?reviewNumber=" + reviewNumber
                  + "&productCode=" + encodeURIComponent(productCode)
                  + "&sort=" + encodeURIComponent(sort)
                  + "&sizePerPage=" + encodeURIComponent(sizePerPage)
                  + "&currentShowPageNo=" + encodeURIComponent(currentShowPageNo);
  });

});
</script>

<jsp:include page="../footer.jsp"/>
