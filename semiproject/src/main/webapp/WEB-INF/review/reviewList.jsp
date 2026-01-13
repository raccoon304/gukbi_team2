<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<% String ctxPath = request.getContextPath(); %>

<!-- Bootstrap CSS -->
<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css">

<!-- Font Awesome 6 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.1/css/all.min.css">

<!-- 직접 만든 CSS -->
<link href="<%=ctxPath%>/css/review/review.css" rel="stylesheet" />

<!-- Optional JavaScript -->
<script type="text/javascript" src="<%= ctxPath%>/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript" src="<%= ctxPath%>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js" ></script>

<!-- jQueryUI -->
<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/jquery-ui-1.13.1.custom/jquery-ui.min.css" />
<script type="text/javascript" src="<%=ctxPath%>/jquery-ui-1.13.1.custom/jquery-ui.min.js"></script>

<jsp:include page="../header.jsp"/>

<c:url var="backUrl" value="/product/productOption.hp">
  <c:param name="productCode" value="${productCode}" />
</c:url>

<div class="container" style="margin-top:5%;">
  <div class="d-flex justify-content-between align-items-center mb-3">
    <h4 class="mb-0"><i class="fa-solid fa-star mr-2"></i>구매 리뷰</h4>
    <a class="btn btn-outline-secondary btn-sm" href="${backUrl}">상품상세로</a>
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
    
    <c:choose>
      <c:when test="${not empty rv.memberName}">
        <c:set var="writerName" value="${rv.memberName}" />
      </c:when>
      <c:otherwise>
        <c:set var="writerName" value="${rv.name}" />
      </c:otherwise>
    </c:choose>

    <c:choose>
      <c:when test="${not empty rv.regDate}">
        <c:set var="writeDay" value="${rv.regDate}" />
      </c:when>
      <c:otherwise>
        <c:set var="writeDay" value="${rv.writeday}" />
      </c:otherwise>
    </c:choose>

    <c:choose>
      <c:when test="${not empty rv.content}">
        <c:set var="content" value="${rv.content}" />
      </c:when>
      <c:otherwise>
        <c:set var="content" value="${rv.reviewContent}" />
      </c:otherwise>
    </c:choose>

    <c:set var="r" value="${rv.rating}" />

    <div class="card mb-3">
      <div class="card-body">

        <div class="d-flex justify-content-between align-items-start">
          <div class="d-flex align-items-center">

            <%-- 썸네일 --%>
            <c:if test="${not empty rv.thumbPath}">
              <img src="<%=ctxPath%>${rv.thumbPath}"
                   alt="thumb"
                   style="width:42px;height:42px;border-radius:50%;object-fit:cover;"
                   class="mr-2"/>
            </c:if>

            <div>
              <div>
                <b><c:out value="${writerName}" /></b>

                <span class="ml-2">
                  <%-- 별점 --%>
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
              </div>
              <small class="text-muted"><c:out value="${writeDay}" /></small>
            </div>
          </div>
        </div>

        <hr/>

        <%-- deletedYn 처리 --%>
        <c:choose>
          <c:when test="${rv.deletedYn == 1}">
            <div class="text-muted">삭제된 리뷰입니다.</div>
          </c:when>
          <c:otherwise>
            <div style="white-space:pre-wrap;">
              <c:out value="${content}" />
            </div>
          </c:otherwise>
        </c:choose>

      </div>
    </div>
  </c:forEach>

  <div class="mt-4 d-flex justify-content-center">
	  <nav aria-label="Page navigation">
	    <ul class="pagination pagination-sm mb-0">
	      ${pageBar}
	    </ul>
	  </nav>
  </div>
</div>

<jsp:include page="../footer.jsp"/>