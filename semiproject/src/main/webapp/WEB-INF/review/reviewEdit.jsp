<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<% String ctxPath = request.getContextPath(); %>

<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.1/css/all.min.css">
<link href="<%=ctxPath%>/css/review/review.css" rel="stylesheet" />

<script type="text/javascript" src="<%= ctxPath%>/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript" src="<%= ctxPath%>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js"></script>

<!-- ctxPath 전역 -->
<script>window.ctxPath = "<%=ctxPath%>";</script>

<!-- 내가 만든 JS -->
<script src="<%=ctxPath%>/js/review/reviewEdit.js"></script>

<jsp:include page="../header.jsp"/>

<c:url var="backToList" value="/review/reviewList.hp">
  <c:param name="productCode" value="${empty productCode ? 'ALL' : productCode}" />
  <c:param name="sort" value="${empty sort ? 'latest' : sort}" />
  <c:param name="sizePerPage" value="${empty sizePerPage ? '10' : sizePerPage}" />
  <c:param name="currentShowPageNo" value="${empty currentShowPageNo ? '1' : currentShowPageNo}" />
</c:url>

<div class="container" style="max-width: 760px; margin-top:5%;">

  <div class="d-flex justify-content-between align-items-center mb-3">
    <h4 class="mb-0"><i class="fa-solid fa-pen mr-2"></i>리뷰 수정</h4>
    <a class="btn btn-outline-secondary btn-sm" href="${backToList}">목록으로</a>
  </div>

  <div class="card">
    <div class="card-body">

      <c:if test="${not empty errMsg}">
        <div class="alert alert-danger mb-3">
          <c:out value="${errMsg}" />
        </div>
      </c:if>

      <c:if test="${empty review}">
        <div class="alert alert-warning mb-0">
          수정할 리뷰 정보가 없습니다.
        </div>
      </c:if>

      <c:if test="${not empty review}">
        <form id="reviewEditFrm"
              method="post"
              action="<%=ctxPath%>/review/reviewUpdate.hp"
              enctype="multipart/form-data">

          <input type="hidden" name="reviewNumber" value="${reviewNumber}" />

          <!-- 목록 복귀용 -->
          <input type="hidden" name="productCode" value="${empty productCode ? 'ALL' : productCode}" />
          <input type="hidden" name="sort" value="${empty sort ? 'latest' : sort}" />
          <input type="hidden" name="sizePerPage" value="${empty sizePerPage ? '10' : sizePerPage}" />
          <input type="hidden" name="currentShowPageNo" value="${empty currentShowPageNo ? '1' : currentShowPageNo}" />

          <!-- 제목 -->
          <div class="form-group">
            <label class="font-weight-bold">리뷰 제목</label>
            <input type="text"
                   name="reviewTitle"
                   class="form-control"
                   maxlength="100"
                   required
                   value="<c:out value='${review.reviewTitle}'/>">
            <small class="text-muted">최대 100자</small>
          </div>

          <!-- 별점 -->
          <div class="form-group mt-3">
            <label class="font-weight-bold">별점</label>
            <input type="hidden" name="rating" id="rating" value="<c:out value='${review.rating}'/>" required>

            <div id="starBox" class="star-fa">
              <c:forEach begin="1" end="5" var="i">
                <div class="star-one" data-star="${i}">
                  <i class="fa-solid fa-star star-bg"></i>
                  <span class="star-fill"><i class="fa-solid fa-star"></i></span>
                  <span class="hit hit-left"  data-value="${i - 0.5}"></span>
                  <span class="hit hit-right" data-value="${i * 1.0}"></span>
                </div>
              </c:forEach>
            </div>

            <small class="text-muted">클릭해서 0.5 단위로 선택</small>
          </div>

          <!-- 내용 -->
          <div class="form-group mt-3">
            <label class="font-weight-bold">리뷰 내용</label>
            <textarea name="reviewContent"
                      class="form-control"
                      rows="7"
                      maxlength="1000"
                      required><c:out value='${review.reviewContent}'/></textarea>
            <small class="text-muted">최대 1000자</small>
          </div>

          <!-- 이미지 -->
          <div class="form-group mt-3">
            <label class="font-weight-bold">리뷰 이미지 (최대 5장)</label>

            <!-- 기존 이미지 -->
            <c:if test="${not empty imgList}">
              <div class="d-flex flex-wrap mb-2" id="oldImageWrap">
                <c:forEach var="img" items="${imgList}" varStatus="st">
                  <div class="rv-item old-img"
                       data-imgid="${img.reviewImageId}">
                    <img class="rv-thumb"
                         src="<%=ctxPath%><c:out value='${img.imagePath}'/>"
                         alt="old">
                    <button type="button" class="rv-del old-del" title="삭제">&times;</button>
                    <span class="rv-badge">${st.index + 1}</span>
                  </div>
                </c:forEach>
              </div>
            </c:if>

            <!-- 삭제할 이미지 id 누적 -->
            <div id="delOldIds"></div>

            <!-- 컨트롤러로 보낼 새 이미지 경로(hidden) -->
            <div id="pickedInputs"></div>

            <!-- 진짜 file input(숨김) -->
            <input type="file"
                   id="reviewImages"
                   accept="image/*"
                   multiple
                   style="display:none;">

            <!-- write처럼 보이는 UI -->
            <div class="input-group">
              <input type="text" class="form-control" id="fakeFileName" placeholder="파일을 선택하세요" readonly>
              <div class="input-group-append">
                <button type="button" class="btn btn-outline-secondary" id="btnPickFile">
                  <i class="fa-solid fa-paperclip mr-1"></i>파일첨부
                </button>
              </div>
            </div>

            <small class="text-muted">jpg / jpeg / png / webp (기존 포함 최대 5장)</small>

            <!-- 새 이미지 미리보기 -->
            <div id="previewWrap" class="mt-3 d-flex flex-wrap"></div>
          </div>

          <div class="d-flex justify-content-end mt-4" style="gap:8px;">
            <a class="btn btn-light" href="javascript:history.back()">취소</a>
            <button type="submit" class="btn btn-primary">
              <i class="fa-solid fa-check mr-1"></i>수정 저장
            </button>
          </div>

        </form>
      </c:if>

    </div>
  </div>
</div>

<jsp:include page="../footer.jsp"/>
