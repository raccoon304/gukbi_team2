$(function () {

  // feather 아이콘 초기화
  if (window.feather) {
    feather.replace();
  }

  const $tabIdFind   = $('#tabIdFind');
  const $tabPwdFind  = $('#tabPwdFind');
  const $idFindForm  = $('#idFindForm');
  const $pwdFindForm = $('#pwdFindForm');

  // 비밀번호찾기 인증 타이머(5분)
  let pwdTimerInterval = null;

  function startPwdExpireTimer(expireMs) {
    const el = document.getElementById("pwdExpireTimer");
    if (!el) return; // MAIL_SENT 영역이 아닐 때는 없을 수 있음

    if (!expireMs || isNaN(expireMs)) {
      el.textContent = "--:--";
      return;
    }

    if (pwdTimerInterval) clearInterval(pwdTimerInterval);

    function tick() {
      const diff = expireMs - Date.now();

      if (diff <= 0) {
        el.textContent = "00:00";
        clearInterval(pwdTimerInterval);
        pwdTimerInterval = null;
        return;
      }

      const totalSec = Math.floor(diff / 1000);
      const min = String(Math.floor(totalSec / 60)).padStart(2, "0");
      const sec = String(totalSec % 60).padStart(2, "0");

      // JSP EL 충돌 방지 템플릿리터럴(${}) 안씀 
      el.textContent = min + ":" + sec;
    }

    tick();
    pwdTimerInterval = setInterval(tick, 1000);
  }

  // 페이지 로드시(또는 탭 전환으로 영역 표시시) 타이머 시작
  function tryStartPwdTimerIfNeeded() {
    if (String(PWD_STATUS) !== "MAIL_SENT") return;

    // JSP에서 주입한 window 값 사용
    const expireAtMs = Number(window.PWD_EXPIRE_AT_MS);

    console.log("[PWD TIMER] PWD_STATUS=", PWD_STATUS);
    console.log("[PWD TIMER] expireAtMs=", expireAtMs);

    startPwdExpireTimer(expireAtMs);
  }

  // 탭 전환
  $tabIdFind.on('click', function () {
    $tabIdFind.addClass('active');
    $tabPwdFind.removeClass('active');
    $idFindForm.removeClass('hidden');
    $pwdFindForm.addClass('hidden');
    $('#pwdFindResultArea').addClass('hidden');
  });

  $tabPwdFind.on('click', function () {
    $tabPwdFind.addClass('active');
    $tabIdFind.removeClass('active');
    $pwdFindForm.removeClass('hidden');
    $idFindForm.addClass('hidden');

    // 서버에서 POST 후 돌아온 경우 결과 영역 보여주기
    if (String(PWD_POSTED) === "true") {
      $('#pwdFindResultArea').removeClass('hidden');
      if (window.feather) feather.replace();

      // 결과영역이 열렸으니 타이머도 시작
      tryStartPwdTimerIfNeeded();
    }
  });

  // 아이디 찾기 라디오 토글
  $('input[name="idFindType"]').on('change', function () {
    const v = $('input[name="idFindType"]:checked').val();
    if (v === 'email') {
      $('#idFindByEmail').removeClass('hidden');
      $('#idFindByPhone').addClass('hidden');
      $('#idfind_email').prop('required', true);
      $('#idfind_phone').prop('required', false);
    } else {
      $('#idFindByPhone').removeClass('hidden');
      $('#idFindByEmail').addClass('hidden');
      $('#idfind_phone').prop('required', true);
      $('#idfind_email').prop('required', false);
    }
  }).trigger('change');

  // 비밀번호 찾기 라디오 토글
  $('input[name="pwdFindType"]').on('change', function () {
    const v = $('input[name="pwdFindType"]:checked').val();
    if (v === 'email') {
      $('#pwdFindByEmail').removeClass('hidden');
      $('#pwdFindByPhone').addClass('hidden');
      $('#pwdfind_email').prop('required', true);
      $('#pwdfind_phone').prop('required', false);
    } else {
      $('#pwdFindByPhone').removeClass('hidden');
      $('#pwdFindByEmail').addClass('hidden');
      $('#pwdfind_phone').prop('required', true);
      $('#pwdfind_email').prop('required', false);
    }
  }).trigger('change');

  // 숫자만 입력
  function onlyDigits($el) {
    $el.on('input', function () {
      this.value = this.value.replace(/\D/g, '');
    });
  }
  onlyDigits($('#idfind_phone'));
  onlyDigits($('#pwdfind_phone'));

  // 서버에서 activeTab=pwd 로 내려오면 비밀번호 탭 유지
  if (String(ACTIVE_TAB) === "pwd") {
    $tabPwdFind.trigger('click');
  } else {
    // 혹시 비밀번호 탭이 이미 열려있는 경우를 대비
    tryStartPwdTimerIfNeeded();
  }

  // !!!!!!!! 휴대폰 미구현 현재는 submit 막기
  $('#pwdFindForm').on('submit', function (e) {
    const v = $('input[name="pwdFindType"]:checked').val();
    if (v === 'phone') {
      e.preventDefault();
      alert("휴대폰 인증은 추후 구현 예정입니다. 현재는 이메일로만 가능합니다.");
      $('input[name="pwdFindType"][value="email"]').prop('checked', true).trigger('change');
      return false;
    }
    return true;
  });

  // 인증하기 버튼 처리(VerifyCertification.hp로 POST)
  $(document).on('click', '#btnPwdVerify', function () {

    const inputCode = $('#pwd_input_confirmCode').val().trim();
    if (inputCode === "") {
      alert("인증코드를 입력하세요.");
      return;
    }

    const userid = $('#pwdfind_id').val().trim();
    if (userid === "") {
      alert("아이디가 비어있습니다. 다시 시도해주세요.");
      return;
    }

    if (!document.verifyCertificationFrm) {
      alert("인증 폼이 없습니다. 메일 발송 후에 인증해주세요.");
      return;
    }

    const frm = document.verifyCertificationFrm;
    frm.userCertificationCode.value = inputCode;
    frm.userid.value = userid;
    frm.action = ctxPath + "/member/verifyCertification.hp";
    frm.method = "post";
    frm.submit();
  });

});
