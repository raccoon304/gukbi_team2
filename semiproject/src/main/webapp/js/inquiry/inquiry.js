
let editingInquiryId = null;

//  화면 문자열
function replyStatusToText(replyStatus) {
  switch (Number(replyStatus)) {
    case 0: return "보류";
    case 1: return "접수";
    case 2: return "답변완료";
    default: return "";
  }
}

// 상태별 뱃지색
function getStatusBadgeClass(statusText) {
  switch (statusText) {
    case "보류": return "badge-secondary";
    case "접수": return "badge-info";
    case "답변완료": return "badge-success";
    default: return "badge-secondary";
  }
}


// 목록으로 이동(필터/페이지 유지)
function goList() {
  location.href = ctxPath + "/inquiry/inquiryList.hp" + location.search;
}


// XSS 방지
function escapeHtml(str) {
  if (str === null || str === undefined) return "";
  return String(str)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#039;");
}


// 상세 불러오기
function loadInquiryDetail(inquiryNumber) {
  $.ajax({
    url: ctxPath + "/inquiry/inquiryDetail.hp",
    type: "POST",
    dataType: "json",
    data: { inquiryNumber },
    success: function (json) {
      if (!json || json.success === false) {
        // 비밀글 차단이면 메시지로 안내
        if (json && json.secretBlocked) {
        //  alert(json.message || "비밀글은 작성자만 조회 가능합니다.");
          return;
        }
        alert(json && json.message ? json.message : "문의를 찾을 수 없습니다.");
        return;
      }

      const statusText = json.replyStatusString || replyStatusToText(json.replyStatus);

      const inquiry = {
        id: Number(json.inquiryNumber),
        type: json.inquiryType,
        title: json.title,
        content: json.inquiryContent,
        status: statusText,
        date: (json.registerday || "").split("T")[0],
        author: json.memberid,
        canEdit: !!json.canEdit,
        canDelete: !!json.canDelete,
        adminReply: json.replyContent || null,
        replyRegisterday: json.replyRegisterday,
        canReply: !!json.canReply,
        isAdmin: !!json.isAdmin
      };

      renderInquiryDetail(inquiry);
    },
    error: function (xhr, status, err) {
		console.log("detail error status:", status);      // parsererror / error / timeout ...
		  console.log("http status:", xhr.status);          // 200 / 302 / 500 ...
		  console.log("responseText:", xhr.responseText); 
      alert("문의 상세를 불러오지 못했습니다.");
    }
  });
}


// 문의 상세
function renderInquiryDetail(inquiry) {
  const canEdit = !!inquiry.canEdit;
  const canDelete = !!inquiry.canDelete;
  const canReply = !!inquiry.canReply;

  const adminReplyViewHtml = `
    <div id="adminReplyViewWrap" class="message-box admin-message mt-3">
      <div class="d-flex justify-content-between mb-2">
        <strong>관리자 답변</strong>
        ${
          inquiry.adminReply
            ? `<small class="text-muted">${escapeHtml((inquiry.replyRegisterday || "").split("T")[0])}</small>`
            : ``
        }
      </div>

      ${
        inquiry.adminReply
          ? `<p class="mb-0">${escapeHtml(inquiry.adminReply).replace(/\n/g, "<br>")}</p>`
          : `<p class="text-muted mb-0">아직 관리자 답변이 없습니다.</p>`
      }

      ${
        canReply
          ? `<div class="text-right mt-2">
              <button type="button" class="btn btn-sm btn-outline-primary"
                onclick="openAdminReplyEditor(${inquiry.id})">
                ${inquiry.adminReply ? "수정" : "답변 등록"}
              </button>
            </div>`
          : ``
      }
    </div>
  `;

  const adminReplyEditorHtml = canReply
    ? `
    <div id="adminReplyEditorWrap" class="message-box admin-message mt-3" style="display:none;">
      <div class="d-flex justify-content-between mb-2 align-items-center">
        <strong>관리자 답변 ${inquiry.adminReply ? "(수정)" : "(등록)"}</strong>
        ${
          inquiry.adminReply
            ? `<small class="text-muted">${escapeHtml((inquiry.replyRegisterday || "").split("T")[0])}</small>`
            : ``
        }
      </div>

      <textarea id="adminReplyContent" class="form-control" rows="5"
        placeholder="답변 내용을 입력하세요">${inquiry.adminReply ? escapeHtml(inquiry.adminReply) : ""}</textarea>

      <div class="mt-2 text-right">
        <button type="button" class="btn btn-sm btn-outline-secondary mr-2"
          onclick="closeAdminReplyEditor()">취소</button>

        <button type="button" class="btn btn-sm btn-primary"
          onclick="saveAdminReply(${inquiry.id})">저장</button>
      </div>
    </div>
  `
    : ``;

  const detailHtml = `
    <div class="inquiry-detail border rounded p-3">
      <div class="d-flex justify-content-between align-items-start mb-3">
        <div>
          <h4>${escapeHtml(inquiry.title)}</h4>
          <span class="badge badge-primary mr-2">${escapeHtml(inquiry.type)}</span>
          <span id="detailStatusBadge" class="badge ${getStatusBadgeClass(inquiry.status)}">${escapeHtml(inquiry.status)}</span>
        </div>

        ${(canEdit || canDelete) ? `
          <div>
            ${canEdit ? `<button class="btn btn-sm btn-outline-primary mr-1" onclick="editInquiry(${inquiry.id})">수정</button>` : ``}
            ${canDelete ? `<button class="btn btn-sm btn-outline-danger" onclick="deleteInquiry(${inquiry.id})">삭제</button>` : ``}
          </div>
        ` : ``}
      </div>

      <div class="message-box">
        <div class="d-flex justify-content-between mb-2">
          <strong>작성자: ${escapeHtml(inquiry.author)}</strong>
          <small class="text-muted">${escapeHtml(inquiry.date)}</small>
        </div>
        <p class="mb-0">${escapeHtml(inquiry.content).replace(/\n/g, "<br>")}</p>
      </div>

      ${adminReplyViewHtml}
      ${adminReplyEditorHtml}
    </div>
  `;

  $("#inquiryDetail").html(detailHtml).show();
  $("#inquiryDetailPlaceholder").hide();
}

// 관리자 답변 편집 열기, 닫기
window.openAdminReplyEditor = function () {
  $("#adminReplyViewWrap").hide();
  $("#adminReplyEditorWrap").show();
  $("#adminReplyContent").focus();
};

window.closeAdminReplyEditor = function () {
  $("#adminReplyEditorWrap").hide();
  $("#adminReplyViewWrap").show();
};


// 수정 모달
window.editInquiry = function (inquiryNumber) {
  if (!isLoggedIn) {
    alert("로그인이 필요합니다.");
    return;
  }

  $.ajax({
    url: ctxPath + "/inquiry/inquiryDetail.hp",
    type: "POST",
    dataType: "json",
    data: { inquiryNumber },
    success: function (json) {
      if (!json || json.success === false) {
        if (json && json.secretBlocked) {
          alert(json.message || "비밀글은 작성자만 조회 가능합니다.");
          return;
        }
        alert(json && json.message ? json.message : "문의를 찾을 수 없습니다.");
        return;
      }

      if (!json.canEdit) {
        alert("본인이 작성한 문의만 수정할 수 있습니다.");
        return;
      }

      editingInquiryId = inquiryNumber;
      $("#modalTitle").text("문의 수정");
      $("#inquiryType").val(json.inquiryType);
      $("#inquiryTitle").val(json.title);
      $("#inquiryContent").val(json.inquiryContent);

      // 비밀글 체크박스가 모달에 있으면 같이 세팅 (있을 때만)
      if ($("#isSecret").length) {
        $("#isSecret").prop("checked", Number(json.isSecret) == 1);
      }

      $("#inquiryModal").modal("show");
    },
    error: function () {
      alert("수정 정보를 불러오지 못했습니다.");
    }
  });
};


// 문의 삭제
window.deleteInquiry = function (inquiryNumber) {
  if (!confirm("정말 삭제하시겠습니까?")) return;

  $.ajax({
    url: ctxPath + "/inquiry/inquiryDelete.hp",
    type: "POST",
    dataType: "json",
    data: { inquiryNumber },
    success: function (json) {
      if (json && json.needLogin) {
        alert(json.message || "로그인이 필요합니다.");
        return;
      }

      if (json && json.success) {
        alert(json.message || "문의가 삭제되었습니다.");
        goList();
      } else {
        alert(json && json.message ? json.message : "문의 삭제에 실패했습니다.");
      }
    },
    error: function () {
      alert("문의 삭제 중 오류가 발생했습니다.");
    }
  });
};


// 등록 버튼
$(document).on("click", "#addInquiryBtn", function () {
  if (!isLoggedIn) {
    alert("로그인이 필요합니다.");
    return;
  }

  editingInquiryId = null;
  $("#modalTitle").text("문의 등록");
  $("#inquiryForm")[0].reset();

  // 비밀글 체크박스가 모달에 있으면 기본 false
  if ($("#isSecret").length) {
    $("#isSecret").prop("checked", false);
  }

  $("#inquiryModal").modal("show");
});


// 저장 버튼 클릭
$(document).on("click", "#submitInquiry", function () {
  if (!isLoggedIn) {
    alert("로그인이 필요합니다.");
    return;
  }

  const inquiryType = $("#inquiryType").val();
  const title = $("#inquiryTitle").val();
  const inquiryContent = $("#inquiryContent").val();

  // 비밀글 체크박스가 있으면 반영, 없으면 0
  const isSecret = ($("#isSecret").length && $("#isSecret").is(":checked")) ? 1 : 0;

  if (!inquiryType || !title || !inquiryContent) {
    alert("모든 항목을 입력해주세요.");
    return;
  }

  const isEdit = (editingInquiryId !== null);
  const url = isEdit ? (ctxPath + "/inquiry/inquiryUpdate.hp") : (ctxPath + "/inquiry/inquiryInsert.hp");

  const data = isEdit
    ? { inquiryNumber: editingInquiryId, inquiryType, title, inquiryContent, isSecret }
    : { inquiryType, title, inquiryContent, isSecret };

  $.ajax({
    url,
    type: "POST",
    dataType: "json",
    data,
    success: function (json) {
      if (json && json.needLogin) {
        alert(json.message || "로그인이 필요합니다.");
        return;
      }

      if (json && json.success) {
        alert(json.message || (isEdit ? "문의가 수정되었습니다." : "문의가 등록되었습니다."));
        $("#inquiryModal").modal("hide");
        goList();
      } else {
        alert(json && json.message ? json.message : "처리에 실패했습니다.");
      }
    },
    error: function () {
      alert("저장 중 오류가 발생했습니다.");
    }
  });
});


// 목록 클릭 -> 상세
$(document).on("click", ".inquiry-item", function () {
  const inquiryNumber = parseInt($(this).data("id"), 10);
  const isSecret = Number($(this).data("secret")) == 1;

  // 제목이 '비밀글입니다'로 내려온 경우 막기
  const titleText = $(this).find("h6").text().trim();
  if (isSecret && titleText.includes("비밀글입니다")) {
	
	if (!isLoggedIn) {
	    alert("비밀글은 작성자만 조회 가능합니다.\n로그인을 해주세요.");
	    return;
	  }
	else{
		alert("비밀글은 작성자만 조회 가능합니다.");
	}  
    
    return;
  }

  $(".inquiry-item").removeClass("active");
  $(this).addClass("active");
  loadInquiryDetail(inquiryNumber);
});


// 관리자 답변 저장
window.saveAdminReply = function (inquiryNumber) {
  if (!isLoggedIn) {
    alert("로그인이 필요합니다.");
    return;
  }

  const replyContent = ($("#adminReplyContent").val() || "").trim();
  if (!replyContent) {
    alert("답변 내용을 입력하세요.");
    return;
  }

  $.ajax({
    url: ctxPath + "/inquiry/inquiryReply.hp",
    type: "POST",
    dataType: "json",
    data: { inquiryNumber, replyContent },
    success: function (json) {
      if (json && json.needLogin) {
        alert(json.message || "로그인이 필요합니다.");
        return;
      }
      if (json && json.needAdmin) {
        alert(json.message || "관리자만 답변할 수 있습니다.");
        return;
      }

      if (json && json.success) {
        alert(json.message || "관리자 답변이 저장되었습니다.");
		
		// 목록 뱃지 즉시 변경
		 const $item = $(`.inquiry-item[data-id="${inquiryNumber}"]`);
		 $item.find(".status-badge")
		      .removeClass("badge-secondary badge-info badge-success")
		      .addClass("badge-success")
		      .text("답변완료");

		 // 상세 뱃지 즉시 변경
		 $("#detailStatusBadge")
		      .removeClass("badge-secondary badge-info badge-success")
		      .addClass("badge-success")
		      .text("답변완료");
		
		closeAdminReplyEditor();
        loadInquiryDetail(inquiryNumber);
      } else {
        alert(json && json.message ? json.message : "답변 저장에 실패했습니다.");
      }
    },
    error: function () {
      alert("답변 저장 중 오류가 발생했습니다.");
    }
  });
};

$(document).on("click", "#reviewBtn", function () {
 location.href = ctxPath + "/review/reviewList.hp?productCode=" + pageData.productCode
              + "&optionId=" + pageData.productOptionId;
});
