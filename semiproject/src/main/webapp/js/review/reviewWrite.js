$(function () {


  const MAX_FILES = 5;                 // 최대 업로드 이미지 개수
  const $input = $("#reviewImages");   // 파일 input
  const $wrap  = $("#previewWrap");    // 미리보기 출력 영역

  let selectedFiles = [];              // 사용자가 선택한 파일 목록(직접 관리)
  let previewUrls = [];                // createObjectURL()로 만든 URL 목록(메모리 해제용)


  // 같은 파일을 다시 선택해도 change 이벤트가 발생하도록 input 값 초기화
  $input.on("click", function(){
    this.value = ""; 
  });


// input.files 재구성(삭제/순서 변경 등 반영)
  function rebuildInputFiles() {
    const dt = new DataTransfer();
    selectedFiles.forEach(f => dt.items.add(f));
    $input[0].files = dt.files;
  }


  // 이미지 파일 허용 여부 검사
  function isAllowedImage(file) {
    const name = (file.name || "").toLowerCase();
    const extOk =
      name.endsWith(".jpg")  ||
      name.endsWith(".jpeg") ||
      name.endsWith(".png")  ||
      name.endsWith(".webp");

    const typeOk =
      (file.type && file.type.startsWith("image/")) ||
      (!file.type && extOk); // type이 없으면 extOk로 대체 판단

    return typeOk && extOk;
  }


  // 미리보기 URL(ObjectURL) 정리
  function cleanupPreviewUrls() {
    previewUrls.forEach(u => {
      try { URL.revokeObjectURL(u); } catch(e) {}
    });
    previewUrls = [];
  }


   // 이미지 미리보기 렌더링
   // 삭제 버튼 클릭 시 해당 파일 제거
  function renderPreviews() {
    cleanupPreviewUrls();  // 이전 URL 해제
    $wrap.empty();         // 기존 미리보기 제거

    selectedFiles.forEach((file, idx) => {
      const url = URL.createObjectURL(file);
      previewUrls.push(url);

      const $item = $(`
        <div class="rv-item">
          <img class="rv-thumb" alt="preview">
          <button type="button" class="rv-del" title="삭제">&times;</button>
          <span class="rv-badge">${idx + 1}</span>
        </div>
      `);

      $item.find("img").attr("src", url);

      // 미리보기 삭제 버튼
      $item.find(".rv-del").on("click", function () {
        selectedFiles.splice(idx, 1); // 해당 파일 제거
        rebuildInputFiles();          // input.files 동기화
        renderPreviews();             // 미리보기
      });

      $wrap.append($item);
    });
  }


  // 선택된 파일들을 selectedFiles에 누적 - 형식/중복/최대개수 체크 후 input.files와 미리보기 갱신
  $input.on("change", function () {
    const files = Array.from(this.files || []);

    for (const f of files) {

      // 파일 형식 검사
      if (!isAllowedImage(f)) {
        alert("허용되지 않는 파일 형식입니다. (jpg/jpeg/png/webp)");
        continue;
      }

      // 최대 개수 제한
      if (selectedFiles.length >= MAX_FILES) {
        alert("이미지는 최대 " + MAX_FILES + "장까지 업로드할 수 있어요.");
        break;
      }

      // 중복 파일 방지(이름+사이즈 기준)
      const dup = selectedFiles.some(x => x.name === f.name && x.size === f.size);
      if (dup) continue;

      selectedFiles.push(f);
    }

    rebuildInputFiles(); // input.files
    renderPreviews();    // 미리보기
  });


  
  // 별점 표시(채움) 처리
  function paintStars(val){
    $("#starBox .star-one").each(function(idx){
      const starNo = idx + 1; // 1~5
      let percent = 0;

      if (val >= starNo) percent = 100;
      else if (val >= starNo - 0.5) percent = 50;
      else percent = 0;

      $(this).find(".star-fill").css("width", percent + "%");
    });
  }

  
  // 초기 별점 반영 (서버에서 내려준 rating 값이 있으면 별 채워주기)
    const initVal = parseFloat($("#rating").val() || "0");
    if (initVal > 0) {
      paintStars(initVal);
    }
  
 
  // 별점 클릭 이벤트
  $("#starBox").on("click", ".hit", function(){
    const val = parseFloat($(this).data("value"));

    // 0.5 단위 + 범위 체크
    if (!(val >= 0.5 && val <= 5.0 && (val * 2 === Math.floor(val * 2)))) return;

    // 서버로 보낼 값
    $("#rating").val(val.toFixed(1));

    // 화면에 수치 표시하는 요소 갱신
    const $rt = $("#ratingText");
    if ($rt.length) $rt.text(val.toFixed(1));

    // 별 채움 UI 갱신
    paintStars(val);
  });


 
   // ObjectURL 정리(메모리 누수 방지)
  $(window).on("beforeunload", function(){
    cleanupPreviewUrls();
  });


  
  // submit 검증
  //  제목/별점/내용/이미지 개수 검사
  // 유효하지 않으면 alert 후 submit 막기
  $("#reviewWriteFrm").on("submit", function () {

    const title = $("input[name='reviewTitle']").val().trim();
    const rating = $("#rating").val();
    const content = $("textarea[name='reviewContent']").val().trim();

    // 제목 필수(최대 100자)
    if (!title) {
      alert("리뷰 제목을 입력하세요.");
      return false;
    }
    if (title.length > 100) {
      alert("리뷰 제목은 최대 100자까지 가능합니다.");
      return false;
    }

    // 별점 필수
    if (!rating) {
      alert("별점을 선택하세요.");
      return false;
    }

    // 내용 필수(최대 1000자)
    if (!content) {
      alert("리뷰 내용을 입력하세요.");
      return false;
    }
    if (content.length > 1000) {
      alert("리뷰 내용은 최대 1000자까지 가능합니다.");
      return false;
    }

    // 이미지 최대 개수 제한
    if (selectedFiles.length > MAX_FILES) {
      alert("이미지는 최대 " + MAX_FILES + "장까지 업로드할 수 있어요.");
      return false;
    }

    return true; // 통과 → submit 진행
  });

});
