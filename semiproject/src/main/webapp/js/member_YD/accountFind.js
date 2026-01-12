$(function () {
	
  // feather 아이콘 초기화
  if (window.feather) {
    feather.replace();
  }
  const $tabIdFind   = $('#tabIdFind');
  const $tabPwdFind  = $('#tabPwdFind');
  const $idFindForm  = $('#idFindForm');
  const $pwdFindForm = $('#pwdFindForm');

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
