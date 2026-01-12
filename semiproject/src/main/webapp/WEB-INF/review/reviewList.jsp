<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% String ctxPath = request.getContextPath(); %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<!-- Bootstrap CSS -->
<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css">

<!-- Font Awesome 6 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.1/css/all.min.css">
<!-- <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">-->

<!-- 직접 만든 CSS -->
<link href="<%=ctxPath%>/css/admin/admin.css" rel="stylesheet" />

<!-- Optional JavaScript -->
<script type="text/javascript" src="<%= ctxPath%>/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript" src="<%= ctxPath%>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js" ></script> 

<%-- jQueryUI CSS 및 JS --%>
<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/jquery-ui-1.13.1.custom/jquery-ui.min.css" />
<script type="text/javascript" src="<%=ctxPath%>/jquery-ui-1.13.1.custom/jquery-ui.min.js"></script>

<jsp:include page="../header.jsp"/>

<div class="container" style="margin-top:5%;">
  <div class="d-flex justify-content-between align-items-center mb-3">
    <h4 class="mb-0"><i class="fas fa-star mr-2"></i>구매 리뷰</h4>
    <a class="btn btn-outline-secondary btn-sm"
       href="<%=ctxPath%>/product/productOption.hp?productCode=${productCode}">
      상품상세로
    </a>
  </div>

  <div class="mb-2 text-muted">
    총 <b>${totalCount}</b>건 / ${currentShowPageNo}페이지 (총 ${totalPage}페이지)
  </div>

  <c:if test="${empty reviewList}">
    <div class="alert alert-light border text-center py-5">
      아직 등록된 리뷰가 없습니다.
    </div>
  </c:if>

  <c:forEach var="rv" items="${reviewList}">
    <div class="card mb-3">
      <div class="card-body">
        <div class="d-flex justify-content-between">
          <div>
            <b>${rv.memberName}</b>
            <span class="ml-2">
              <c:forEach begin="1" end="5" var="i">
                <c:choose>
                  <c:when test="${i <= rv.rating}">
                    <i class="fas fa-star"></i>
                  </c:when>
                  <c:otherwise>
                    <i class="far fa-star"></i>
                  </c:otherwise>
                </c:choose>
              </c:forEach>
            </span>
          </div>
          <small class="text-muted">${rv.regDate}</small>
        </div>

        <hr/>

        <div style="white-space:pre-wrap;">${rv.content}</div>
      </div>
    </div>
  </c:forEach>
  
  <a class="btn btn-review"
   href="<%=ctxPath%>/review/reviewList.hp?productCode=${proOptionDto.fkProductCode}">
  <i class="fas fa-star mr-2"></i>구매 리뷰 보기
</a>

  <div class="mt-4">
    ${pageBar}
  </div>
</div>

<jsp:include page="../footer.jsp"/>