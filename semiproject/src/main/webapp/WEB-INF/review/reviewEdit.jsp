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

    const oldCnt = $("#oldImageWrap .old-img").length;
    if(oldCnt + selectedFiles.length > MAX_FILES){
      alert("이미지는 기존 이미지 포함 최대 " + MAX_FILES + "장까지 업로드할 수 있어요.");
      return false;
    }
    
    return true;
  });
  
  
  // 이전 사진 삭제
  $(document).on("click", ".old-del", function(e){
	    e.preventDefault();
	    e.stopPropagation();

	    const $item = $(this).closest(".old-img");
	    const imgId = $item.data("imgid");

	    // 화면에서 제거
	    $item.remove();

	    // hidden input 누적(중복 방지)
	    if ($("#delOldIds input[value='"+imgId+"']").length === 0) {
	      $("#delOldIds").append(
	        $("<input>", { type:"hidden", name:"delImageId", value: imgId })
	      );
	    }
	  });

  
  
  // ===== 새 이미지 미리보기 =====
  const MAX_FILES = 5;
  const $input = $("#reviewImages");
  const $wrap  = $("#previewWrap");

  let selectedFiles = [];   // 새로 추가한 파일만 관리
  let previewUrls = [];

  // 같은 파일 다시 선택해도 change 발생하도록
  $input.on("click", function(){
    this.value = "";
  });

  function rebuildInputFiles(){
    const dt = new DataTransfer();
    selectedFiles.forEach(f => dt.items.add(f));
    $input[0].files = dt.files;
  }

  function isAllowedImage(file){
    const name = (file.name || "").toLowerCase();
    const extOk =
      name.endsWith(".jpg")  ||
      name.endsWith(".jpeg") ||
      name.endsWith(".png")  ||
      name.endsWith(".webp");

    const typeOk =
      (file.type && file.type.startsWith("image/")) ||
      (!file.type && extOk);

    return typeOk && extOk;
  }

  function cleanupPreviewUrls(){
    previewUrls.forEach(u => {
      try { URL.revokeObjectURL(u); } catch(e) {}
    });
    previewUrls = [];
  }

  function renderPreviews(){
    cleanupPreviewUrls();
    $wrap.empty();

    selectedFiles.forEach((file, idx) => {
      const url = URL.createObjectURL(file);
      previewUrls.push(url);

      const $item = $(`
        <div class="rv-item new-img">
          <img class="rv-thumb" alt="preview">
          <button type="button" class="rv-del new-del" title="삭제">&times;</button>
          <span class="rv-badge">NEW</span>
        </div>
      `);

      $item.find("img").attr("src", url);

      // 새 파일 X 삭제
      $item.find(".new-del").on("click", function(){
        selectedFiles.splice(idx, 1);
        rebuildInputFiles();
        renderPreviews();
      });

      $wrap.append($item);
    });
  }

  // 파일 선택 시 누적
  $input.on("change", function(){
    const files = Array.from(this.files || []);

    for(const f of files){

      if(!isAllowedImage(f)){
        alert("허용되지 않는 파일 형식입니다. (jpg/jpeg/png/webp)");
        continue;
      }

      // 전체(기존+새거) 합쳐서 5장 제한
      const oldCnt = $("#oldImageWrap .old-img").length; // 남아있는 기존이미지 개수
      if(oldCnt + selectedFiles.length + 1 > MAX_FILES){
        alert("이미지는 기존 이미지 포함 최대 " + MAX_FILES + "장까지 업로드할 수 있어요.");
        break;
      }

      // 중복 방지(이름+사이즈 기준)
      const dup = selectedFiles.some(x => x.name === f.name && x.size === f.size);
      if(dup) continue;

      selectedFiles.push(f);
    }

    rebuildInputFiles();
    renderPreviews();
  });

  // 페이지 떠날 때 ObjectURL 정리
  $(window).on("beforeunload", function(){
    cleanupPreviewUrls();
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

      <!-- 서버 검증 에러 메시지 -->
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
              action="<%=ctxPath%>/review/reviewUpdate.hp" enctype="multipart/form-data">

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

            <!-- 서버로 보내는 값 -->
            <input type="hidden" name="rating" id="rating" value="<c:out value='${review.rating}'/>" required>

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

		  <!-- 이미지 수정 -->
		  <div class="form-group mt-3">
		    <label class="font-weight-bold">리뷰 이미지 (최대 5장)</label>
		
		    <!-- 기존 이미지 -->
		    <c:if test="${not empty imgList}">
			  <div class="d-flex flex-wrap mb-2" id="oldImageWrap">
			    <c:forEach var="img" items="${imgList}" varStatus="st">
			      <div class="rv-item old-img"
			           data-imgid="${img.reviewImageId}"
			           data-imgpath="<c:out value='${img.imagePath}'/>">
			
			        <img class="rv-thumb"
			             src="<%=ctxPath%><c:out value='${img.imagePath}'/>"
			             alt="old">
			
			        <!-- X 버튼 -->
			        <button type="button" class="rv-del old-del" title="삭제">&times;</button>
			
			        <!-- 순번 배지 -->
			        <span class="rv-badge">${st.index + 1}</span>
			      </div>
			    </c:forEach>
			  </div>
			</c:if>
			
			<!-- 삭제할 이미지 id들을 여기에 hidden으로 추가 -->
			<div id="delOldIds"></div>
		
		    <!-- 새 이미지 추가 -->
		    <input type="file"
		           id="reviewImages"
		           name="reviewImages"
		           accept="image/*"
		           multiple
		           class="form-control-file">
		    <small class="text-muted">jpg / jpeg / png / webp (최대 5장)</small>
		
		    <!-- 새로 추가하는 파일 미리보기 -->
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
