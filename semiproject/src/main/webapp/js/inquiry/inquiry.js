// ====== 전역 변수 (JSP에서 내려줌) ======
// const ctxPath
// const isLoggedIn
// const currentUser

let editingInquiryId = null;  // inquiryNumber를 넣을 거야
let inquiries = [];           // 목록 데이터(서버에서 받아서 채움)

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
// 1) 목록 불러오기 (POST /inquiry/inquiryList.hp)
// ================================
function loadInquiryList() {
    $.ajax({
        url: ctxPath + "/inquiry/inquiryList.hp",
        type: "POST",
        dataType: "json",
        success: function (jsonArr) {
            // InquiryList가 배열로 내려줌 :contentReference[oaicite:6]{index=6}
            inquiries = (jsonArr || []).map(item => {
                const statusText = item.replyStatusString || replyStatusToText(item.replyStatus);
                return {
                    // 기존 네 JS 흐름 유지 위해 키를 이렇게 통일
                    id: Number(item.inquiryNumber),                 // inquiryNumber
                    type: item.inquiryType,
                    title: item.title,
                    content: item.inquiryContent,
                    status: statusText,
                    date: (item.registerday || "").split("T")[0],
                    author: item.memberID,
                    adminReply: item.replyContent || null,

                    // 원본도 필요하면 남겨둠
                    replyRegisterday: item.replyRegisterday
                };
            });

            renderInquiryList();

            // 상세 영역 초기화
            $("#inquiryDetail").hide();
            $("#inquiryDetailPlaceholder").show();
        },
        error: function () {
            alert("문의 목록을 불러오지 못했습니다.");
        }
    });
}

// ================================
// 2) 목록 렌더링
// ================================
function renderInquiryList() {
    if (!inquiries || inquiries.length === 0) {
        $("#inquiryList").html(`<div class="p-3 text-muted">문의가 없습니다.</div>`);
        return;
    }

    const listHtml = inquiries.map(inquiry => `
        <div class="inquiry-item p-3 border-bottom" data-id="${inquiry.id}">
            <div class="d-flex justify-content-between align-items-center mb-2">
                <span class="badge badge-primary">${inquiry.type}</span>
                <span class="badge status-badge ${getStatusBadgeClass(inquiry.status)}">${inquiry.status}</span>
            </div>
            <h6 class="mb-1">${escapeHtml(inquiry.title)}</h6>
            <small class="text-muted">${escapeHtml(inquiry.date)}</small>
        </div>
    `).join("");

    $("#inquiryList").html(listHtml);
}

// ================================
// 3) 상세 불러오기 (POST /inquiry/inquiryDetail.hp)
// ================================
function loadInquiryDetail(inquiryNumber) {
    $.ajax({
        url: ctxPath + "/inquiry/inquiryDetail.hp",
        type: "POST",
        dataType: "json",
        data: { inquiryNumber: inquiryNumber }, // 컨트롤러가 이 이름으로 받음 :contentReference[oaicite:7]{index=7}
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
// 4) 상세 렌더링 (관리자 답변은 표시만)
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
// 5) 등록/수정 모달 오픈
// ================================
window.editInquiry = function (inquiryNumber) {
    // 목록에서 찾아서 모달에 채움
    const inquiry = inquiries.find(i => i.id === inquiryNumber);
    if (!inquiry) return;

    if (!(isLoggedIn && currentUser === inquiry.author)) {
        alert("본인이 작성한 문의만 수정할 수 있습니다.");
        return;
    }

    editingInquiryId = inquiryNumber;
    $("#modalTitle").text("문의 수정");
    $("#inquiryType").val(inquiry.type);
    $("#inquiryTitle").val(inquiry.title);
    $("#inquiryContent").val(inquiry.content);
    $("#inquiryModal").modal("show");
};

// ================================
// 6) 삭제 (POST /inquiry/inquiryDelete.hp)
// ================================
window.deleteInquiry = function (inquiryNumber) {
    if (!confirm("정말 삭제하시겠습니까?")) return;

    $.ajax({
        url: ctxPath + "/inquiry/inquiryDelete.hp",
        type: "POST",
        dataType: "json",
        data: { inquiryNumber: inquiryNumber }, // 컨트롤러가 이 이름으로 받음 :contentReference[oaicite:8]{index=8}
        success: function (json) {
            if (json.needLogin) {
                alert(json.message || "로그인이 필요합니다.");
                return;
            }

            if (json.success) {
                alert(json.message || "문의가 삭제되었습니다.");
                loadInquiryList();
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
// 7) 등록 버튼
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
// 8) 저장(등록/수정)
// - 등록: POST /inquiry/inquiryInsert.hp
// - 수정: POST /inquiry/inquiryUpdate.hp
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

    // 컨트롤러가 받는 파라미터명 그대로 사용 :contentReference[oaicite:9]{index=9} :contentReference[oaicite:10]{index=10}
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
                loadInquiryList();

                // 수정이면 해당 상세 다시 보여주기(선택 UX)
                if (isEdit) loadInquiryDetail(editingInquiryId);
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
// 9) 목록 클릭 -> 상세 로드
// ================================
$(document).on("click", ".inquiry-item", function () {
    $(".inquiry-item").removeClass("active");
    $(this).addClass("active");

    const inquiryNumber = parseInt($(this).data("id"), 10);
    loadInquiryDetail(inquiryNumber);
});

// ================================
// 10) 초기 로딩
// ================================
$(document).ready(function () {
    loadInquiryList();
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

