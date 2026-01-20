$(function () {

  const MAX_FILES = 5;
  const $input = $("#reviewImages");
  const $wrap  = $("#previewWrap");

  let selectedFiles = []; 
  let previewUrls = [];  

  // 같은 파일 다시 선택해도 change 되게
  $input.on("click", function () {
    this.value = "";
  });

  function rebuildInputFiles() {
    const dt = new DataTransfer();
    selectedFiles.forEach(f => dt.items.add(f));
    $input[0].files = dt.files;
  }

  function isAllowedImage(file) {
    const name = (file.name || "").toLowerCase();
    const extOk =
      name.endsWith(".jpg")  ||
      name.endsWith(".jpeg") ||
      name.endsWith(".png")  ||
      name.endsWith(".webp");

    const typeOk = (file.type && file.type.startsWith("image/")) || (!file.type && extOk);
    return typeOk && extOk;
  }

  function cleanupPreviewUrls() {
    previewUrls.forEach(u => { try { URL.revokeObjectURL(u); } catch(e) {} });
    previewUrls = [];
  }

  function renderPreviews() {
    cleanupPreviewUrls();
    $wrap.empty();

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

      $item.find(".rv-del").on("click", function () {
        selectedFiles.splice(idx, 1);
        rebuildInputFiles();
        renderPreviews();
      });

      $wrap.append($item);
    });
  }

  // 파일 선택(누적)
  $input.on("change", function () {
    const files = Array.from(this.files || []);

    for (const f of files) {

      if (!isAllowedImage(f)) {
        alert("허용되지 않는 파일 형식입니다. (jpg/jpeg/png/webp)");
        continue;
      }

      if (selectedFiles.length >= MAX_FILES) {
        alert("이미지는 최대 " + MAX_FILES + "장까지 업로드할 수 있어요.");
        break;
      }

      // 중복 방지(이름+사이즈)
      const dup = selectedFiles.some(x => x.name === f.name && x.size === f.size);
      if (dup) continue;

      selectedFiles.push(f);
    }

    rebuildInputFiles();
    renderPreviews();
  });

  // ===== 별점 =====
  function paintStars(val){
    $("#starBox .star-one").each(function(idx){
      const starNo = idx + 1;
      let percent = 0;

      if (val >= starNo) percent = 100;
      else if (val >= starNo - 0.5) percent = 50;
      else percent = 0;

      $(this).find(".star-fill").css("width", percent + "%");
    });
  }

  const initVal = parseFloat($("#rating").val() || "0");
  if (initVal > 0) paintStars(initVal);

  $("#starBox").on("click", ".hit", function(){
    const val = parseFloat($(this).data("value"));
    if (!(val >= 0.5 && val <= 5.0 && (val * 2 === Math.floor(val * 2)))) return;

    $("#rating").val(val.toFixed(1));
    paintStars(val);
  });

  // ===== submit 검증 =====
  $("#reviewWriteFrm").on("submit", function () {

    const title = $("input[name='reviewTitle']").val().trim();
    const rating = $("#rating").val();
    const content = $("textarea[name='reviewContent']").val().trim();

    if (!title) { alert("리뷰 제목을 입력하세요."); return false; }
    if (title.length > 100) { alert("리뷰 제목은 최대 100자까지 가능합니다."); return false; }

    if (!rating) { alert("별점을 선택하세요."); return false; }

    if (!content) { alert("리뷰 내용을 입력하세요."); return false; }
    if (content.length > 1000) { alert("리뷰 내용은 최대 1000자까지 가능합니다."); return false; }

    if (selectedFiles.length > MAX_FILES) {
      alert("이미지는 최대 " + MAX_FILES + "장까지 업로드할 수 있어요.");
      return false;
    }

    return true;
  });

  // 메모리 정리
  $(window).on("beforeunload", function(){
    cleanupPreviewUrls();
  });

});
