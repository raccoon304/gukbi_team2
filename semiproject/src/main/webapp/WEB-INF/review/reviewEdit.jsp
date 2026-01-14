<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<% String ctxPath = request.getContextPath(); %>

<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.1/css/all.min.css">
<link href="<%=ctxPath%>/css/review/review.css" rel="stylesheet" />

<script type="text/javascript" src="<%= ctxPath%>/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript" src="<%= ctxPath%>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js"></script>

<script>
$(function(){

  // 별점 채움 표시 함수
  function paintStars(val){
    $("#starBox .star-one").each(function(idx){
      const starNo = idx + 1;
      let percent = 0;

      if(val >= starNo) percent = 100;
      else if(val >= starNo - 0.5) percent = 50;
      else percent = 0;

      $(this).find(".star-fill").css("width", percent + "%");
    });
  }

  // 초기 별점 반영
  const initVal = parseFloat($("#rating").val() || "0");
  if(initVal > 0) paintStars(initVal);

  // 별점 클릭 이벤트
  $("#starBox").on("click", ".hit", function(){
    const val = parseFloat($(this).data("value"));
    if (!(val >= 0.5 && val <= 5.0 && (val * 2 === Math.floor(val * 2)))) return;

    $("#rating").val(val.toFixed(1));
    paintStars(val);
  });

  // submit 검증
  $("#reviewEditFrm").on("submit", function(){
    const title = $("input[name='reviewTitle']").val().trim();
    const content = $("textarea[name='reviewContent']").val().trim();
    const rating = $("#rating").val();

    if(!title){ alert("리뷰 제목을 입력하세요."); return false; }
    if(title.length > 100){ alert("리뷰 제목은 최대 100자까지 가능합니다."); return false; }

    if(!rating){ alert("별점을 선택하세요."); return false; }

    if(!content){ alert("리뷰 내용을 입력하세요."); return false; }
    if(content.length > 1000){ alert("리뷰 내용은 최대 1000자까지 가능합니다."); return false; }

    return true;
  });

});
</script>

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

      <c:if test="${empty review}">
        <div class="alert alert-warning mb-0">
          수정할 리뷰 정보가 없습니다.
        </div>
      </c:if>

      <c:if test="${not empty review}">
        <form id="reviewEditFrm"
              method="post"
              action="<%=ctxPath%>/review/reviewUpdate.hp">
         
          <input type="hidden" name="reviewNumber" value="${review.reviewNumber}" />
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

            <!-- 서버로 보내는 값 -->
            <input type="hidden" name="rating" id="rating" value="${review.rating}" required>

            <!-- 별 UI -->
            <div id="starBox" class="star-fa">
              <c:forEach begin="1" end="5" var="i">
                <div class="star-one" data-star="${i}">
                  <i class="fa-solid fa-star star-bg"></i>
                  <span class="star-fill">
                    <i class="fa-solid fa-star"></i>
                  </span>
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
