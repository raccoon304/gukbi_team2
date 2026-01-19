$(function () {

  // feather 아이콘 초기화
  if (window.feather) feather.replace();

  const $tabIdFind   = $('#tabIdFind');
  const $tabPwdFind  = $('#tabPwdFind');
  const $idFindForm  = $('#idFindForm');
  const $pwdFindForm = $('#pwdFindForm');

  // ===== 로딩 오버레이 =====
  function showLoading(desc) {
    if (desc) $("#loadingDesc").text(desc);
    $("#loadingOverlay").removeClass("hidden");
  }
  function hideLoading() {
    $("#loadingOverlay").addClass("hidden");
  }

  // ===== 결과 영역 UI 제어 =====
  function openPwdResultArea() {
    $("#pwdFindResultArea").removeClass("hidden");
    if (window.feather) feather.replace();
  }
  function showPwdSuccess(message) {
    openPwdResultArea();
    $("#pwdResultFail").addClass("hidden");
    $("#pwdFailMsg").text("");

    $("#pwdResultSuccess").removeClass("hidden");
    $("#pwdVerifyBox").removeClass("hidden");
    $("#pwdSendMsg").text(message || "인증코드를 발송했습니다.");
  }
  function showPwdFail(message) {
    openPwdResultArea();
    $("#pwdResultSuccess").addClass("hidden");
    $("#pwdVerifyBox").addClass("hidden");
    $("#pwdSendMsg").text("");

    $("#pwdResultFail").removeClass("hidden");
    $("#pwdFailMsg").text(message || "처리 중 오류가 발생했습니다.");
  }

  // ===== 비밀번호찾기 인증 타이머(5분) =====
  let pwdTimerInterval = null;

  function startPwdExpireTimer(expireMs) {
    const el = document.getElementById("pwdExpireTimer");
    if (!el) return;

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

      el.textContent = min + ":" + sec;
    }

    tick();
    pwdTimerInterval = setInterval(tick, 1000);
  }

  // 서버 렌더링으로 돌아왔을 때(기존 흐름)도 타이머 유지
  function tryStartPwdTimerIfNeeded() {
    const st = String(window.PWD_STATUS || "").toUpperCase();
    if (!(st === "MAIL_SENT" || st === "SMS_SENT")) return;

    const expireAtMs = Number(window.PWD_EXPIRE_AT_MS);
    startPwdExpireTimer(expireAtMs);
  }

  // ===== 탭 전환 =====
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

    // 기존 서버 POST 후 돌아온 경우도 보여주기(하위호환)
    const posted = (window.PWD_POSTED === true || String(window.PWD_POSTED).toLowerCase() === "true");
    if (posted) {
      $("#pwdFindResultArea").removeClass("hidden");
      $("#pwdResultFail").addClass("hidden");
      $("#pwdResultSuccess").removeClass("hidden");
      $("#pwdVerifyBox").removeClass("hidden");
      if (window.feather) feather.replace();
      tryStartPwdTimerIfNeeded();
    }
  });

  // ===== 아이디 찾기 라디오 토글 =====
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

  // ===== 비밀번호 찾기 라디오 토글 =====
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

  // ===== 숫자만 입력 =====
  function onlyDigits($el) {
    $el.on('input', function () {
      this.value = this.value.replace(/\D/g, '');
    });
  }
  onlyDigits($('#idfind_phone'));
  onlyDigits($('#pwdfind_phone'));

  // ===== 서버에서 내려준 pwdFindType 유지 =====
  const serverPwdType = String(window.PWD_FIND_TYPE || "").toLowerCase();
  if (serverPwdType === "phone" || serverPwdType === "email") {
    $('input[name="pwdFindType"][value="' + serverPwdType + '"]').prop('checked', true);
    $('input[name="pwdFindType"]').trigger('change');
  }

  // ===== 서버에서 activeTab=pwd면 비밀번호 탭 유지 =====
  if (String(window.ACTIVE_TAB).toLowerCase() === "pwd") {
    $tabPwdFind.trigger('click');
  } else {
    tryStartPwdTimerIfNeeded();
  }

  // AJAX 비밀번호 찾기(메일/문자 발송) 버튼 클릭
  $(document).on("click", "#pwdFindBtn", function () {

    const pwdFindType = $('input[name="pwdFindType"]:checked').val() || "email";
    const memberid = $('#pwdfind_id').val().trim();
    const name     = $('#pwdfind_name').val().trim();
    const email    = $('#pwdfind_email').val().trim();
    const mobile   = ($('#pwdfind_phone').val() || "").trim();

    if (!memberid || !name) {
      alert("아이디/성명을 입력하세요.");
      return;
    }
    if (pwdFindType === "email" && !email) {
      alert("이메일을 입력하세요.");
      return;
    }
    if (pwdFindType === "phone" && !mobile) {
      alert("휴대폰 번호를 입력하세요.");
      return;
    }

    showLoading("인증코드를 발송하고 있습니다.");

    $.ajax({
      url: ctxPath + "/member/pwdFindSend.hp",
      type: "post",
      dataType: "json",
      data: {
        pwdFindType: pwdFindType,
        memberid: memberid,
        name: name,
        email: email,
        mobile: mobile
      },
      success: function (json) {
        hideLoading();

        if (!json) {
          showPwdFail("처리 중 오류가 발생했습니다.");
          return;
        }

        if (json.success) {
          // 성공 UI
          const msg = (json.status === "MAIL_SENT")
            ? "이메일로 인증코드를 발송했습니다."
            : "문자로 인증코드를 발송했습니다.";

          showPwdSuccess(msg);

          // hidden form 세팅(VerifyCertification용)
          const frm = document.forms["verifyCertificationFrm"];
          frm.userid.value = json.memberid || memberid;
          frm.channel.value = json.channel || pwdFindType;

          // 타이머 시작
          startPwdExpireTimer(Number(json.expireAtMs));

        } else {
          showPwdFail(json.msg || "일치하는 회원정보가 없습니다.");
        }

        if (window.feather) feather.replace();
      },
      error: function () {
        hideLoading();
        showPwdFail("서버 통신 오류입니다. 다시 시도해주세요.");
      }
    });
  });


  // 인증하기 버튼 처리(VerifyCertification AJAX)
   $(document).on('click', '#btnPwdVerify', function () {

     const inputCode = $('#pwd_input_confirmCode').val().trim();
     if (inputCode === "") {
       alert("인증코드를 입력하세요.");
       return;
     }

     const frm = document.forms["verifyCertificationFrm"];
     if (!frm) {
       alert("인증 폼이 없습니다. 메일/문자 발송 후에 인증해주세요.");
       return;
     }

     // hidden 값(메일/문자 발송 성공 시 세팅되어 있어야 함)
     const userid = (frm.userid && frm.userid.value) ? frm.userid.value : $('#pwdfind_id').val().trim();
     const channel = (frm.channel && frm.channel.value) ? frm.channel.value : ($('input[name="pwdFindType"]:checked').val() || "email");

     if (!userid) {
       alert("아이디가 비어있습니다. 다시 시도해주세요.");
       return;
     }

     showLoading("인증코드를 확인하고 임시비밀번호를 발급중입니다...");

     $.ajax({
       url: ctxPath + "/member/verifyCertificationAjax.hp",
       type: "post",
       dataType: "json",
       data: {
         userCertificationCode: inputCode,
         userid: userid,
         channel: channel
       },
       success: function (json) {
         hideLoading();

         if (!json) {
           showPwdFail("처리 중 오류가 발생했습니다.");
           return;
         }

         if (json.success) {
           // 이메일 인증일경우 임시비번 발송까지 끝난 결과를 받게 설계함
           // SMS 인증일 경우 이미 VerifyCertification에서 임시비번 발송 처리함
           $("#pwdResultFail").addClass("hidden");
           $("#pwdResultSuccess").removeClass("hidden");
           $("#pwdVerifyBox").addClass("hidden");

           $("#pwdSendMsg").text(json.msg || "처리가 완료되었습니다.");
           startPwdExpireTimer(0); // 타이머 종료처럼 보이게
           $("#pwdExpireTimer").text("--:--");

           alert(json.msg || "처리가 완료되었습니다.");
           // 원하면 자동 이동
           if (json.loc) location.href = json.loc;

         } else {
           showPwdFail(json.msg || "인증코드가 올바르지 않습니다.");
         }

         if (window.feather) feather.replace();
       },
       error: function () {
         hideLoading();
         showPwdFail("서버 통신 오류입니다. 다시 시도해주세요.");
       }
     });

   });

});
