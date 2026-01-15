<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/header.jsp" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/member_YD/myPage.css" />

<div class="container my-5">
  <div class="card shadow-sm">
    <div class="card-body">
      <h4 class="font-weight-bold mb-3">휴면 계정 해제</h4>

      <p class="text-muted mb-4">
        3개월 이상 접속 기록이 없어 계정이 휴면 처리되었습니다.<br/>
        아래 이메일 인증 후 해제가 가능합니다.
      </p>

      <div class="mb-3">
        <small class="text-muted d-block">대상 아이디</small>
        <div class="font-weight-bold">
          <c:out value="${dormantMemberId}" />
        </div>
      </div>

      <div class="mb-3">
        <button type="button" class="btn btn-outline-primary" onclick="sendDormantCode();">
          인증번호 발송
        </button>
        <small class="text-muted d-block mt-2">
          ※ 회원정보에 등록된 이메일로 발송됩니다.
        </small>
      </div>

      <!-- 남은시간 표시 -->
	  <div class="mb-3">
	     <small class="text-muted d-block">인증번호 유효시간</small>
	     <span id="expireTimer" class="font-weight-bold" data-expire="<c:out value='${sessionScope.dormant_cert_expire}'/>">--:--</span>
	  </div>


      <form method="post" action="${pageContext.request.contextPath}/member/dormantUnlockEnd.hp">
        <div class="form-group">
          <label class="font-weight-bold">인증번호</label>
          <input type="text"
                 name="certCode"
                 class="form-control"
                 maxlength="10"
                 placeholder="10자리 인증번호 입력"
                 required />
        </div>

        <button type="submit" class="btn btn-primary">
          인증 후 휴면 해제하기
        </button>

        <a class="btn btn-outline-secondary"
           href="${pageContext.request.contextPath}/index.hp">
          취소
        </a>
      </form>

    </div>
  </div>
</div>

<jsp:include page="/WEB-INF/footer.jsp" />

<script>
let timerInterval = null;

function startExpireTimer(expireMs) {
  const el = document.getElementById("expireTimer");
  if (!el) return;

  if (!expireMs || isNaN(expireMs)) {
    el.textContent = "--:--";
    return;
  }

  if (timerInterval) clearInterval(timerInterval);

  function tick() {
    const diff = expireMs - Date.now();

    if (diff <= 0) {
      el.textContent = "00:00";
      clearInterval(timerInterval);
      timerInterval = null;
      return;
    }

    const totalSec = Math.floor(diff / 1000);
    const min = String(Math.floor(totalSec / 60)).padStart(2, "0");
    const sec = String(totalSec % 60).padStart(2, "0");

    // EL 간섭 없는 방식
    el.textContent = min + ":" + sec;
  }

  tick();
  timerInterval = setInterval(tick, 1000);
}

// 인증번호 발송
function sendDormantCode() {
  fetch("${pageContext.request.contextPath}/member/dormantSendCode.hp", {
    method: "POST",
    headers: {"Content-Type":"application/x-www-form-urlencoded; charset=UTF-8"},
    body: ""
  })
  .then(res => res.text())
  .then(text => {
    console.log("dormantSendCode responseText:", text);
    if (!text) throw new Error("EMPTY_RESPONSE");
    return JSON.parse(text);
  })
  .then(json => {
    if (json.success) {
      alert("인증번호를 이메일로 발송했습니다.");
      const exp = Number(json.expireAt);
      startExpireTimer(exp);

      // 화면에도 저장(새로고침해도 유지되게)
      const el = document.getElementById("expireTimer");
      if (el) el.dataset.expire = String(exp);
    } else {
      alert(json.message || "인증번호 발송에 실패했습니다.");
    }
  })
  .catch(err => {
    console.log(err);
    alert("인증번호 발송 중 오류가 발생했습니다.");
  });
}

// 로드시 data-expire에서 읽어서 시작
document.addEventListener("DOMContentLoaded", function() {
  const el = document.getElementById("expireTimer");
  const exp = el ? Number(el.dataset.expire) : NaN;
  startExpireTimer(exp);
});
</script>