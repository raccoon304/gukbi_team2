<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String ctxPath = request.getContextPath(); %>

<!-- Bootstrap CSS -->
<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css">
<!-- Font Awesome 6 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.1/css/all.min.css">

<!-- 직접 만든 CSS -->
<link href="<%=ctxPath%>/css/review/review.css" rel="stylesheet" />

<script type="text/javascript" src="<%=ctxPath%>/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript" src="<%=ctxPath%>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js"></script>

<script src="<%=ctxPath%>/js/review/reviewWrite.js"></script>

<jsp:include page="../header.jsp"/>

<div class="container" style="max-width: 760px; margin-top: 5%;">
  <div class="d-flex justify-content-between align-items-center mb-3">
    <h4 class="mb-0"><i class="fa-solid fa-pen-to-square mr-2"></i>리뷰 작성</h4>
    <button type="button" class="btn btn-outline-secondary btn-sm" onclick="history.back()">뒤로</button>
  </div>

  <div class="card">
    <div class="card-body">

      <form id="reviewWriteFrm"
            method="post"
            action="<%=ctxPath%>/review/reviewWrite.hp"
            enctype="multipart/form-data">

        <!-- 필수 파라미터: 컨트롤러에서 받는 이름과 일치해야 함 -->
        <input type="hidden" name="orderDetailId" value="${orderDetailId}">
        <input type="hidden" name="optionId" value="${optionId}">

        <div class="form-group">
          <label class="font-weight-bold">별점</label>
          <select name="rating" class="form-control" required>
            <option value="">선택하세요</option>
            <option value="5.0">5.0</option>
            <option value="4.5">4.5</option>
            <option value="4.0">4.0</option>
            <option value="3.5">3.5</option>
            <option value="3.0">3.0</option>
            <option value="2.5">2.5</option>
            <option value="2.0">2.0</option>
            <option value="1.5">1.5</option>
            <option value="1.0">1.0</option>
            <option value="0.5">0.5</option>
          </select>
          <small class="text-muted">0.5 단위로 선택 가능합니다.</small>
        </div>

        <div class="form-group">
          <label class="font-weight-bold">리뷰 내용</label>
          <textarea name="reviewContent"
                    class="form-control"
                    rows="6"
                    maxlength="1000"
                    placeholder="사용 후기를 입력해주세요(최대 1000자)"
                    required></textarea>
          <small class="text-muted">최대 1000자</small>
        </div>

        <div class="form-group">
          <label class="font-weight-bold">리뷰 이미지 (최대 5장)</label>
          <input type="file"
                 id="reviewImages"
                 name="reviewImages"
                 accept="image/*"
                 multiple
                 class="form-control-file">
          <small class="text-muted">jpg/jpeg/png 권장</small>

          <div id="previewWrap" class="mt-3 d-flex flex-wrap"></div>
        </div>

        <div class="d-flex justify-content-end">
          <button type="button" class="btn btn-light mr-2" onclick="history.back()">취소</button>
          <button type="submit" class="btn btn-primary">
            <i class="fa-solid fa-check mr-1"></i>등록
          </button>
        </div>

      </form>

    </div>
  </div>
</div>

<jsp:include page="../footer.jsp"/>