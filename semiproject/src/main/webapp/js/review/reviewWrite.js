$(function () {

  const MAX_FILES = 5;

  const $input = $("#reviewImages");
  const $wrap  = $("#previewWrap");

  let selectedFiles = [];

  function rebuildInputFiles() {
    const dt = new DataTransfer();
    selectedFiles.forEach(f => dt.items.add(f));
    $input[0].files = dt.files;
  }

  function renderPreviews() {
    $wrap.empty();

    selectedFiles.forEach((file, idx) => {
      const url = URL.createObjectURL(file);

      const $item = $(`
        <div class="rv-item">
          <img class="rv-thumb" alt="preview">
          <button type="button" class="rv-del" title="삭제">&times;</button>
          <span class="rv-badge">${idx + 1}</span>
        </div>
      `);

      $item.find("img").attr("src", url);

      $item.find(".rv-del").on("click", function () {
        URL.revokeObjectURL(url);
        selectedFiles.splice(idx, 1);
        rebuildInputFiles();
        renderPreviews();
      });

      $wrap.append($item);
    });
  }

  function isAllowedImage(file) {
    const typeOk = file.type && file.type.startsWith("image/");
    const name = (file.name || "").toLowerCase();
    const extOk = name.endsWith(".jpg") || name.endsWith(".jpeg") || name.endsWith(".png") || name.endsWith(".webp");
    return typeOk && extOk;
  }

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

      const dup = selectedFiles.some(x => x.name === f.name && x.size === f.size);
      if (dup) continue;

      selectedFiles.push(f);
    }

    rebuildInputFiles();
    renderPreviews();

    // 같은 파일 다시 선택해도 change 발생하도록 초기화
    $(this).val("");
  });

  $("#reviewWriteFrm").on("submit", function () {
    const rating = $("select[name='rating']").val();
    const content = $("textarea[name='reviewContent']").val().trim();

    if (!rating) {
      alert("별점을 선택하세요.");
      return false;
    }
    if (!content) {
      alert("리뷰 내용을 입력하세요.");
      return false;
    }
    if (content.length > 1000) {
      alert("리뷰 내용은 최대 1000자까지 가능합니다.");
      return false;
    }
    if (selectedFiles.length > MAX_FILES) {
      alert("이미지는 최대 " + MAX_FILES + "장까지 업로드할 수 있어요.");
      return false;
    }
    return true;
  });

});