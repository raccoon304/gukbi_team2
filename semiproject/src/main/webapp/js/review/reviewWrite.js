$(function () {
  var MAX_FILES = 5;

  var $file    = $("#reviewImages");
  var $btn     = $("#btnPickFile");
  var $fake    = $("#fakeFileName");
  var $preview = $("#previewWrap");
  var $inputs  = $("#pickedInputs");

 
  var picked = {};

  $btn.on("click", function () {
    $file.trigger("click");
  });

  function pickedCount() {
    var n = 0;
    for (var k in picked) { if (picked.hasOwnProperty(k)) n++; }
    return n;
  }

  function syncFakeName() {
    var n = pickedCount();
    if (n === 0) $fake.val("");
    else if (n === 1) $fake.val("1개 선택됨");
    else $fake.val(n + "개 선택됨");
  }

  function syncHidden() {
    $inputs.empty();
    for (var fn in picked) {
      if (!picked.hasOwnProperty(fn)) continue;
      $inputs.append($("<input>", { type: "hidden", name: "imagePath", value: picked[fn] }));
    }
  }

  function renderPreview() {
    $preview.empty();
    var idx = 1;

    for (var fn in picked) {
      if (!picked.hasOwnProperty(fn)) continue;

      var webPath = picked[fn];
      var src = (window.ctxPath || "") + webPath;

      var $item = $(
        '<div class="rv-item" data-fn="' + fn + '">' +
          '<img class="rv-thumb" src="' + src + '" alt="preview">' +
          '<button type="button" class="rv-del" title="삭제">&times;</button>' +
          '<span class="rv-badge">' + idx + '</span>' +
        '</div>'
      );

      $preview.append($item);
      idx++;
    }
  }

  // 삭제 위임
  $preview.on("click", ".rv-del", function () {
    var fn = String($(this).closest(".rv-item").data("fn") || "");
    if (fn && picked.hasOwnProperty(fn)) delete picked[fn];

    syncHidden();
    renderPreview();
    syncFakeName();
  });

  $file.on("change", function () {
    var files = this.files;
    if (!files || files.length === 0) return;

    for (var i = 0; i < files.length; i++) {
      if (pickedCount() >= MAX_FILES) {
        alert("이미지는 최대 " + MAX_FILES + "장까지 선택할 수 있어요.");
        break;
      }

      var f = files[i];
      var filename = (f.name || "").replace(/^\s+|\s+$/g, "");
      if (!filename) continue;

      // 정적 경로로만 저장(업로드 X)
      var webPath = "/image/review_image/" + filename;

      // 중복 방지
      if (picked.hasOwnProperty(filename)) continue;

      picked[filename] = webPath;
    }

    // input 비우기
    this.value = "";

    syncHidden();
    renderPreview();
    syncFakeName();
  });

  // ===== 별점 =====
  function paintStars(val){
    $("#starBox .star-one").each(function(idx){
      var starNo = idx + 1;
      var percent = 0;
      if (val >= starNo) percent = 100;
      else if (val >= starNo - 0.5) percent = 50;
      $(this).find(".star-fill").css("width", percent + "%");
    });
  }

  var initVal = parseFloat($("#rating").val() || "0");
  if (initVal > 0) paintStars(initVal);

  $("#starBox").on("click", ".hit", function(){
    var val = parseFloat($(this).data("value"));
    if (!(val >= 0.5 && val <= 5.0 && (val * 2 === Math.floor(val * 2)))) return;
    $("#rating").val(val.toFixed(1));
    paintStars(val);
  });

  // submit 검증 
  $("#reviewWriteFrm").on("submit", function () {
    var orderDetailId = $("select[name='orderDetailId']").val();
    var title = $("input[name='reviewTitle']").val().trim();
    var rating = $("#rating").val();
    var content = $("textarea[name='reviewContent']").val().trim();

    if (!orderDetailId) { alert("구매 옵션을 선택하세요."); return false; }
    if (!title) { alert("리뷰 제목을 입력하세요."); return false; }
    if (title.length > 100) { alert("리뷰 제목은 최대 100자까지 가능합니다."); return false; }
    if (!rating) { alert("별점을 선택하세요."); return false; }
    if (!content) { alert("리뷰 내용을 입력하세요."); return false; }
    if (content.length > 1000) { alert("리뷰 내용은 최대 1000자까지 가능합니다."); return false; }

    if (pickedCount() > MAX_FILES) {
      alert("이미지는 최대 " + MAX_FILES + "장까지 선택할 수 있어요.");
      return false;
    }
    return true;
  });
});
