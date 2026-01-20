<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String ctxPath = request.getContextPath(); %>

<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.1/css/all.min.css">
<link href="<%=ctxPath%>/css/review/review.css" rel="stylesheet" />

<script type="text/javascript" src="<%=ctxPath%>/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript" src="<%=ctxPath%>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js"></script>

<script>window.ctxPath = "<%=ctxPath%>";</script>
<script src="<%=ctxPath%>/js/review/reviewWrite.js"></script>

<jsp:include page="../header.jsp"/>

<div class="container" style="max-width: 760px; margin-top: 5%;">
  <div class="d-flex justify-content-between align-items-center mb-3">
    <h4 class="mb-0"><i class="fa-solid fa-pen-to-square mr-2"></i>리뷰 작성</h4>

    <div>
      <a class="btn btn-outline-secondary btn-sm"
         href="<%=ctxPath%>/review/reviewList.hp?productCode=${productCode}">
        목록
      </a>
      <button type="button" class="btn btn-outline-secondary btn-sm" onclick="history.back()">뒤로</button>
    </div>
  </div>

  <div class="card">
    <div class="card-body">

      <c:if test="${not empty errMsg}">
        <div class="alert alert-danger mb-3">
          <c:out value="${errMsg}" />
        </div>
      </c:if>

      <form id="reviewWriteFrm"
            method="post"
            action="<%=ctxPath%>/review/reviewWrite.hp"
            enctype="multipart/form-data"
            novalidate>

        <input type="hidden" name="productCode" value="${productCode}">

        <c:if test="${empty writableList}">
          <div class="alert alert-warning mb-3">
            작성 할 수 있는 리뷰가 없습니다.
          </div>

          <select class="form-control mb-3" disabled>
            <option>선택할 수 있는 구매옵션이 없습니다</option>
          </select>

          <input class="form-control mb-3" disabled placeholder="리뷰 제목"/>

          <textarea class="form-control mb-3" rows="5" disabled placeholder="리뷰 내용"></textarea>

          <div class="d-flex justify-content-end">
            <button type="button" class="btn btn-light" onclick="history.back()" disabled>취소</button>
            <button type="button" class="btn btn-secondary ml-2" disabled>등록</button>
          </div>
        </c:if>

        <c:if test="${not empty writableList}">

          <!-- 구매옵션 선택 -->
          <div class="form-group">
            <label class="font-weight-bold">구매 옵션</label>
            <select name="orderDetailId" class="form-control" required>
              <option value="">구매한 옵션을 선택하세요</option>
              <c:forEach var="w" items="${writableList}">
                <c:set var="odid" value="${w.orderDetailId}" />
                <option value="${odid}"
                  <c:if test="${not empty formOrderDetailId and formOrderDetailId == odid}">selected</c:if>>
                  ${w.optionName}
                </option>
              </c:forEach>
            </select>
          </div>

          <!-- 제목 -->
          <div class="form-group mt-3">
            <label class="font-weight-bold">리뷰 제목</label>
            <input type="text"
                   name="reviewTitle"
                   class="form-control"
                   maxlength="100"
                   placeholder="제목을 입력해주세요 (최대 100자)"
                   required
                   value="${empty formTitle ? '' : formTitle}" />
            <small class="text-muted">최대 100자</small>
          </div>

          <!-- 별점 -->
          <div class="form-group mt-3">
            <label class="font-weight-bold">별점</label>
            <input type="hidden" name="rating" id="rating" value="${formRating}">

            <div id="starBox" class="star-fa">
              <c:forEach begin="1" end="5" var="i">
                <div class="star-one" data-star="${i}">
                  <i class="fa-solid fa-star star-bg"></i>
                  <span class="star-fill"><i class="fa-solid fa-star"></i></span>
                  <span class="hit hit-left"  data-value="${i - 0.5}" title="${i - 0.5}점"></span>
                  <span class="hit hit-right" data-value="${i * 1.0}" title="${i * 1.0}점"></span>
                </div>
              </c:forEach>
            </div>
          </div>

          <!-- 내용 -->
          <div class="form-group">
            <label class="font-weight-bold">리뷰 내용</label>
            <textarea name="reviewContent"
                      class="form-control"
                      rows="6"
                      maxlength="1000"
                      placeholder="사용 후기를 입력해주세요(최대 1000자)"
                      required><c:out value="${formContent}"/></textarea>
            <small class="text-muted">최대 1000자</small>
          </div>

        
          
			
			<!-- 이미지 -->
			<div class="form-group">
			  <label class="font-weight-bold">리뷰 이미지 (최대 5장)</label>
			
			  <!-- 진짜 file input  -->
			  <input type="file"
			         id="reviewImages"
			         name="reviewImages"
			         accept="image/*"
			         multiple
			         style="display:none;">
			
			  <!-- 파일첨부처럼 보이는 UI -->
			  <div class="input-group">
			    <input type="text" class="form-control" id="fakeFileName" placeholder="파일을 선택하세요" readonly>
			    <div class="input-group-append">
			      <button type="button" class="btn btn-outline-secondary" id="btnPickFile">
			        <i class="fa-solid fa-paperclip mr-1"></i>파일첨부
			      </button>
			    </div>
			  </div>
			
			  <!-- 미리보기 -->
			  <div id="previewWrap" class="mt-3 d-flex flex-wrap"></div>
			
			  <!-- 컨트롤러로 보낼 hidden -->
			  <div id="pickedInputs"></div>
			</div>

		  <small class="text-muted">jpg / jpeg / png / webp</small>
		
          <!-- 버튼 -->
          <div class="d-flex justify-content-end mt-4" style="gap:8px;">
            <button type="button" class="btn btn-light" onclick="history.back()">취소</button>
            <button type="submit" class="btn btn-primary">
              <i class="fa-solid fa-check mr-1"></i>등록
            </button>
          </div>

        </c:if>

      </form>

    </div>
  </div>
</div>

<jsp:include page="../footer.jsp"/>
