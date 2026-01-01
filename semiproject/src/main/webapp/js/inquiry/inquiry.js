// ====== 전역 변수 (JSP에서 내려줌) ======
// const ctxPath
// const isLoggedIn
// const currentUser

let editingInquiryId = null;

// replyStatus(int) -> 화면 문자열
function replyStatusToText(replyStatus) {
    switch (Number(replyStatus)) {
        case 0: return '보류';
        case 1: return '접수';
        case 2: return '답변완료';
        default: return '';
    }
}

// 상태별 뱃지 색상
function getStatusBadgeClass(statusText) {
    switch (statusText) {
        case '보류': return 'badge-secondary';
        case '접수': return 'badge-info';
        case '답변완료': return 'badge-success';
        default: return 'badge-secondary';
    }
}

// ================================
// 1) 상세 불러오기 (POST /inquiry/inquiryDetail.hp)
// ================================
function loadInquiryDetail(inquiryNumber) {
    $.ajax({
        url: ctxPath + "/inquiry/inquiryDetail.hp",
        type: "POST",
        dataType: "json",
        data: { inquiryNumber: inquiryNumber },
        success: function (json) {
            if (!json || json.success === false) {
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
                author: json.memberID,
                adminReply: json.replyContent || null,
                replyRegisterday: json.replyRegisterday
            };

            renderInquiryDetail(inquiry);
        },
        error: function () {
            alert("문의 상세를 불러오지 못했습니다.");
        }
    });
}

// ================================
// 2) 상세 렌더링
// ================================
function renderInquiryDetail(inquiry) {
    const canEdit = isLoggedIn && currentUser === inquiry.author;

    const detailHtml = `
        <div class="inquiry-detail border rounded p-3">
            <div class="d-flex justify-content-between align-items-start mb-3">
                <div>
                    <h4>${escapeHtml(inquiry.title)}</h4>
                    <span class="badge badge-primary mr-2">${escapeHtml(inquiry.type)}</span>
                    <span class="badge ${getStatusBadgeClass(inquiry.status)}">${escapeHtml(inquiry.status)}</span>
                </div>

                ${canEdit ? `
                <div>
                    <button class="btn btn-sm btn-outline-primary mr-1" onclick="editInquiry(${inquiry.id})">수정</button>
                    <button class="btn btn-sm btn-outline-danger" onclick="deleteInquiry(${inquiry.id})">삭제</button>
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

            ${inquiry.adminReply ? `
            <div class="message-box admin-message">
                <div class="d-flex justify-content-between mb-2">
                    <strong>관리자 답변</strong>
                    <small class="text-muted">${escapeHtml((inquiry.replyRegisterday || "").split("T")[0])}</small>
                </div>
                <p class="mb-0">${escapeHtml(inquiry.adminReply).replace(/\n/g, "<br>")}</p>
            </div>
            ` : `<p class="text-muted mt-3 mb-0">아직 관리자 답변이 없습니다.</p>`}
        </div>
    `;

    $("#inquiryDetail").html(detailHtml).show();
    $("#inquiryDetailPlaceholder").hide();
}

// ================================
// 3) 수정 모달 오픈
//  - 렌더링형에서는 목록 데이터(inquiries 배열)가 없으므로
//  - 상세에서 다시 가져오거나, hidden input에 박아두는 방식이 필요
//  - 가장 간단: 상세 다시 조회해서 모달 채움
// ================================
window.editInquiry = function (inquiryNumber) {
    if (!isLoggedIn) {
        alert("로그인이 필요합니다.");
        return;
    }

    // 상세를 서버에서 다시 받아서 모달 채우기
    $.ajax({
        url: ctxPath + "/inquiry/inquiryDetail.hp",
        type: "POST",
        dataType: "json",
        data: { inquiryNumber: inquiryNumber },
        success: function (json) {
            if (!json || json.success === false) {
                alert(json && json.message ? json.message : "문의를 찾을 수 없습니다.");
                return;
            }

            if (!(currentUser === json.memberID)) {
                alert("본인이 작성한 문의만 수정할 수 있습니다.");
                return;
            }

            editingInquiryId = inquiryNumber;
            $("#modalTitle").text("문의 수정");
            $("#inquiryType").val(json.inquiryType);
            $("#inquiryTitle").val(json.title);
            $("#inquiryContent").val(json.inquiryContent);
            $("#inquiryModal").modal("show");
        },
        error: function () {
            alert("수정 정보를 불러오지 못했습니다.");
        }
    });
};

// ================================
// 4) 삭제
// ================================
window.deleteInquiry = function (inquiryNumber) {
    if (!confirm("정말 삭제하시겠습니까?")) return;

    $.ajax({
        url: ctxPath + "/inquiry/inquiryDelete.hp",
        type: "POST",
        dataType: "json",
        data: { inquiryNumber: inquiryNumber },
        success: function (json) {
            if (json.needLogin) {
                alert(json.message || "로그인이 필요합니다.");
                return;
            }

            if (json.success) {
                alert(json.message || "문의가 삭제되었습니다.");
                // 렌더링형: 페이지 새로고침으로 목록 재조회
                location.reload();
            } else {
                alert(json.message || "문의 삭제에 실패했습니다.");
            }
        },
        error: function () {
            alert("문의 삭제 중 오류가 발생했습니다.");
        }
    });
};

// ================================
// 5) 등록 버튼
// ================================
$(document).on("click", "#addInquiryBtn", function () {
    if (!isLoggedIn) {
        alert("로그인이 필요합니다.");
        return;
    }

    editingInquiryId = null;
    $("#modalTitle").text("문의 등록");
    $("#inquiryForm")[0].reset();
    $("#inquiryModal").modal("show");
});

// ================================
// 6) 저장(등록/수정)
// ================================
$(document).on("click", "#submitInquiry", function () {
    if (!isLoggedIn) {
        alert("로그인이 필요합니다.");
        return;
    }

    const inquiryType = $("#inquiryType").val();
    const title = $("#inquiryTitle").val();
    const inquiryContent = $("#inquiryContent").val();

    if (!inquiryType || !title || !inquiryContent) {
        alert("모든 항목을 입력해주세요.");
        return;
    }

    const isEdit = (editingInquiryId !== null);

    const url = isEdit
        ? (ctxPath + "/inquiry/inquiryUpdate.hp")
        : (ctxPath + "/inquiry/inquiryInsert.hp");

    const data = isEdit
        ? { inquiryNumber: editingInquiryId, inquiryType, title, inquiryContent }
        : { inquiryType, title, inquiryContent };

    $.ajax({
        url,
        type: "POST",
        dataType: "json",
        data,
        success: function (json) {
            if (json.needLogin) {
                alert(json.message || "로그인이 필요합니다.");
                return;
            }

            if (json.success) {
                alert(json.message || (isEdit ? "문의가 수정되었습니다." : "문의가 등록되었습니다."));
                $("#inquiryModal").modal("hide");
                // 렌더링형: 새로고침으로 목록 반영
                location.reload();
            } else {
                alert(json.message || "처리에 실패했습니다.");
            }
        },
        error: function () {
            alert("저장 중 오류가 발생했습니다.");
        }
    });
});

// ================================
// 7) 목록 클릭 -> 상세 로드
//   (목록은 JSP에서 이미 렌더링되어 있음)
// ================================
$(document).on("click", ".inquiry-item", function () {
    $(".inquiry-item").removeClass("active");
    $(this).addClass("active");

    const inquiryNumber = parseInt($(this).data("id"), 10);
    loadInquiryDetail(inquiryNumber);
});

// ================================
// util: XSS 방지
// ================================
function escapeHtml(str) {
    if (str === null || str === undefined) return "";
    return String(str)
        .replaceAll("&", "&amp;")
        .replaceAll("<", "&lt;")
        .replaceAll(">", "&gt;")
        .replaceAll('"', "&quot;")
        .replaceAll("'", "&#039;");
}
