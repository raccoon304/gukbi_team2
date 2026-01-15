<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<% String ctxPath = request.getContextPath(); %>

<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.1/css/all.min.css">
<link href="<%=ctxPath%>/css/review/review.css" rel="stylesheet" />

<script type="text/javascript" src="<%= ctxPath%>/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript" src="<%= ctxPath%>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js"></script>

<jsp:include page="../header.jsp"/>

<c:url var="backToList" value="/review/reviewList.hp">
  <c:param name="productCode" value="${empty productCode ? 'ALL' : productCode}" />
  <c:param name="sort" value="${empty sort ? 'latest' : sort}" />
  <c:param name="sizePerPage" value="${empty sizePerPage ? '10' : sizePerPage}" />
  <c:param name="currentShowPageNo" value="${empty currentShowPageNo ? '1' : currentShowPageNo}" />
</c:url>

<style>
  .rv-detail-img{
    width: 240px;
    height: 240px;
    object-fit: cover;
    border-radius: 12px;
    border: 1px solid #e5e5e5;
    margin-right: 10px;
    margin-bottom: 10px;
    background:#fafafa;
  }
</style>

<div class="container" style="max-width: 900px; margin-top:5%;">

  <div class="d-flex justify-content-between align-items-center mb-3">
    <h4 class="mb-0"><i class="fa-solid fa-file-lines mr-2"></i>리뷰 상세</h4>
    <a class="btn btn-outline-secondary btn-sm" href="${backToList}">목록으로</a>
  </div>

  <div class="card">
    <div class="card-body">

      <h5 class="font-weight-bold mb-2">
        <c:out value="${dto.reviewTitle}" />
      </h5>

      <div class="text-muted mb-2">
        작성자: <b><c:out value="${dto.mdto.memberid}" /></b>
        <span class="mx-2">|</span>
        작성일: <c:out value="${dto.writeday}" />
      </div>

      <div class="mb-2 small">
        <b><c:out value="${dto.pdto.brandName}" /></b>
        <c:out value="${dto.pdto.productName}" />
        <span class="text-muted">
          ( <c:out value="${dto.podto.color}" /> / <c:out value="${dto.podto.storageSize}" /> )
        </span>
      </div>

      <div class="mb-3">
        <c:set var="r" value="${dto.rating}" />
        <span class="mr-2">
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
        <span class="text-muted"><c:out value="${dto.rating}" /></span>
      </div>

      <hr/>

      <div style="white-space:pre-wrap;" class="mb-4">
        <c:out value="${dto.reviewContent}" />
      </div>

      <c:if test="${not empty imgList}">
        <div class="d-flex flex-wrap">
          <c:forEach var="img" items="${imgList}">
            <img src="<%=ctxPath%>${img}" class="rv-detail-img" alt="review image"/>
          </c:forEach>
        </div>
      </c:if>

      <%-- 로그인 유저 확인(작성자만 수정/삭제) --%>
      <c:set var="isOwner"
             value="${not empty sessionScope.loginUser and dto.mdto.memberid == sessionScope.loginUser.memberid}" />

      <c:if test="${isOwner}">
        <div class="d-flex justify-content-end align-items-center mt-4 pt-3"
             style="border-top:1px solid #eee; gap:8px;">

          <c:url var="editUrl" value="/review/reviewUpdate.hp">
			  <c:param name="reviewNumber" value="${dto.reviewNumber}" />
			  <c:param name="productCode" value="${empty productCode ? 'ALL' : productCode}" />
			  <c:param name="sort" value="${empty sort ? 'latest' : sort}" />
			  <c:param name="sizePerPage" value="${empty sizePerPage ? '10' : sizePerPage}" />
			  <c:param name="currentShowPageNo" value="${empty currentShowPageNo ? '1' : currentShowPageNo}" />
			</c:url>
			
			<a class="btn btn-outline-primary btn-sm" href="${editUrl}">
			  <i class="fa-regular fa-pen-to-square mr-1"></i>수정
			</a>

          <form method="post"
                action="<%=ctxPath%>/review/reviewDelete.hp"
                class="m-0"
                onsubmit="return confirm('정말 삭제하시겠습니까?');">

            <input type="hidden" name="reviewNumber" value="${dto.reviewNumber}" />
            <input type="hidden" name="productCode" value="${productCode}" />
            <input type="hidden" name="sort" value="${sort}" />
            <input type="hidden" name="sizePerPage" value="${sizePerPage}" />
            <input type="hidden" name="currentShowPageNo" value="${currentShowPageNo}" />

            <button type="submit" class="btn btn-danger btn-sm">
              <i class="fa-regular fa-trash-can mr-1"></i>삭제
            </button>
          </form>

        </div>
      </c:if>

    </div>
  </div>
</div>

<jsp:include page="../footer.jsp"/>
