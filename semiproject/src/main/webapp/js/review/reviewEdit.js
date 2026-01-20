$(function () {

  var MAX_FILES = 5;
  var STATIC_PREFIX = "/image/review_image/";

  // ===== 별점 =====
  function paintStars(val) {
    $("#starBox .star-one").each(function (idx) {
      var starNo = idx + 1;
      var percent = 0;

      if (val >= starNo) percent = 100;
      else if (val >= starNo - 0.5) percent = 50;

      $(this).find(".star-fill").css("width", percent + "%");
    });
  }

  var initVal = parseFloat($("#rating").val() || "0");
  if (initVal > 0) paintStars(initVal);

  $("#starBox").on("click", ".hit", function () {
    var val = parseFloat($(this).data("value"));
    if (!(val >= 0.5 && val <= 5.0 && (val * 2 === Math.floor(val * 2)))) return;

    $("#rating").val(val.toFixed(1));
    paintStars(val);
  });

  // ===== 기존 이미지 삭제 =====
  $(document).on("click", ".old-del", function (e) {
    e.preventDefault();
    e.stopPropagation();

    var $item = $(this).closest(".old-img");
    var imgId = $item.data("imgid");

    $item.remove();

    if ($("#delOldIds input[value='" + imgId + "']").length === 0) {
      $("#delOldIds").append(
        $("<input>", { type: "hidden", name: "delImageId", value: imgId })
      );
    }

    updateFakeName();
  });

  // ===== 새 이미지 =====
  var $fileInput = $("#reviewImages");
  var $btnPick   = $("#btnPickFile");
  var $fakeName  = $("#fakeFileName");
  var $preview   = $("#previewWrap");
  var $inputs    = $("#pickedInputs");

  // filename -> webPath
  var pickedNew = {};

  function pickedCount() {
    var c = 0;
    for (var k in pickedNew) {
      if (pickedNew.hasOwnProperty(k)) c++;
    }
    return c;
  }

  function isAllowedByName(filename) {
    var name = (filename || "").toLowerCase();
    return (
      name.indexOf(".jpg",  name.length - 4)  !== -1 ||
      name.indexOf(".png",  name.length - 4)  !== -1 ||
      name.indexOf(".webp", name.length - 5)  !== -1 ||
      name.indexOf(".jpeg", name.length - 5)  !== -1
    );
  }

  // 서버 파일 존재 체크
  function existsOnServerSync(webPath) {
    var ok = false;
    try {
      $.ajax({
        url: (window.ctxPath || "") + webPath,
        type: "HEAD",
        cache: false,
        async: false,
        success: function () { ok = true; },
        error: function () { ok = false; }
      });
    } catch (e) {
      ok = false;
    }
    return ok;
  }

  function syncHiddenInputs() {
    $inputs.empty();
    for (var fn in pickedNew) {
      if (!pickedNew.hasOwnProperty(fn)) continue;
      $inputs.append($("<input>", { type: "hidden", name: "imagePath", value: pickedNew[fn] }));
    }
  }

  function updateFakeName() {
    var oldCnt = $("#oldImageWrap .old-img").length;
    var newCnt = pickedCount();
    var total  = oldCnt + newCnt;

    if (total === 0) $fakeName.val("");
    else if (total === 1) $fakeName.val("1개 선택됨");
    else $fakeName.val(total + "개 선택됨");
  }

  function renderPreview() {
    $preview.empty();

    for (var filename in pickedNew) {
      if (!pickedNew.hasOwnProperty(filename)) continue;

      var webPath = pickedNew[filename];
      var src = (window.ctxPath || "") + webPath;

      var $item = $(
        '<div class="rv-item new-img" data-fn="' + filename + '">' +
          '<img class="rv-thumb" alt="preview">' +
          '<button type="button" class="rv-del new-del" title="삭제">&times;</button>' +
          '<span class="rv-badge">NEW</span>' +
        '</div>'
      );

      $item.find("img").attr("src", src);

      $item.find(".new-del").on("click", function () {
        var fn = $(this).closest(".rv-item").data("fn");
        if (fn && pickedNew.hasOwnProperty(fn)) {
          delete pickedNew[fn];
          syncHiddenInputs();
          renderPreview();
          updateFakeName();
        }
      });

      $preview.append($item);
    }
  }

  $btnPick.on("click", function () {
    $fileInput.trigger("click");
  });

  $fileInput.on("click", function () {
    this.value = "";
  });

  $fileInput.on("change", function () {
    var files = this.files || [];
    if (!files.length) return;

    for (var i = 0; i < files.length; i++) {

      var oldCnt = $("#oldImageWrap .old-img").length;
      if (oldCnt + pickedCount() >= MAX_FILES) {
        alert("이미지는 기존 이미지 포함 최대 " + MAX_FILES + "장까지 선택할 수 있어요.");
        break;
      }

      var filename = (files[i].name || "").replace(/^\s+|\s+$/g, "");
      if (!filename) continue;

      if (!isAllowedByName(filename)) {
        alert("허용되지 않는 파일 형식입니다. (jpg/jpeg/png/webp)");
        continue;
      }

      if (pickedNew.hasOwnProperty(filename)) continue;

      var webPath = STATIC_PREFIX + filename;

      // 서버에 실제 존재 확인
      if (!existsOnServerSync(webPath)) {
        alert(
          "서버(" + STATIC_PREFIX + ")에 '" + filename + "' 파일이 없어요.\n" +
          "정적이미지 폴더에 파일을 추가하고 git 공유 후 다시 선택해줘!"
        );
        continue;
      }

      pickedNew[filename] = webPath;
    }

    // 비우기
    this.value = "";

    syncHiddenInputs();
    renderPreview();
    updateFakeName();
  });

  // ===== submit 검증 =====
  $("#reviewEditFrm").on("submit", function () {
    var title = $("input[name='reviewTitle']").val().replace(/^\s+|\s+$/g, "");
    var content = $("textarea[name='reviewContent']").val().replace(/^\s+|\s+$/g, "");
    var rating = $("#rating").val();

    if (!title) { alert("리뷰 제목을 입력하세요."); return false; }
    if (title.length > 100) { alert("리뷰 제목은 최대 100자까지 가능합니다."); return false; }

    if (!rating) { alert("별점을 선택하세요."); return false; }

    if (!content) { alert("리뷰 내용을 입력하세요."); return false; }
    if (content.length > 1000) { alert("리뷰 내용은 최대 1000자까지 가능합니다."); return false; }

    var oldCnt = $("#oldImageWrap .old-img").length;
    if (oldCnt + pickedCount() > MAX_FILES) {
      alert("이미지는 기존 이미지 포함 최대 " + MAX_FILES + "장까지 선택할 수 있어요.");
      return false;
    }

    return true;
  });

  // 초기 표시
  updateFakeName();
});
