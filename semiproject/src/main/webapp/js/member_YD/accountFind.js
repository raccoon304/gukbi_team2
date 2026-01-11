$(function () {

  if (window.feather) feather.replace();

  const $tabIdFind  = $('#tabIdFind');
  const $tabPwdFind = $('#tabPwdFind');
  const $idFindForm = $('#idFindForm');
  const $pwdFindForm = $('#pwdFindForm');

  // ID 찾기 탭. 
  $tabIdFind.on('click', function () {
    $tabIdFind.addClass('active');
    $tabPwdFind.removeClass('active');
    $idFindForm.removeClass('hidden');
    $pwdFindForm.addClass('hidden');
    $('input[name="idFindType"]:checked').trigger('change');
  });

  // 비밀번호 찾기 탭 
  $tabPwdFind.on('click', function () {
    $tabPwdFind.addClass('active');
    $tabIdFind.removeClass('active');
    $pwdFindForm.removeClass('hidden');
    $idFindForm.addClass('hidden');
    $('input[name="pwdFindType"]:checked').trigger('change');
  });

  // 이름+휴대폰번호 or 이름+이메일 
  $('input[name="idFindType"]').on('change', function () {
    const v = $('input[name="idFindType"]:checked').val();

    if (v === 'email') {
      $('#idFindByEmail').removeClass('hidden');
      $('#idFindByPhone').addClass('hidden');
      $('#idfind_email').prop('required', true);
      $('#idfind_phone').prop('required', false).val('');
    } else {
      $('#idFindByPhone').removeClass('hidden');
      $('#idFindByEmail').addClass('hidden');
      $('#idfind_phone').prop('required', true);
      $('#idfind_email').prop('required', false).val('');
    }
  });

  $('input[name="idFindType"]:checked').trigger('change');

  $('input[name="pwdFindType"]').on('change', function () {
    const v = $('input[name="pwdFindType"]:checked').val();

    if (v === 'email') {
      $('#pwdFindByEmail').removeClass('hidden');
      $('#pwdFindByPhone').addClass('hidden');
      $('#pwdfind_email').prop('required', true);
      $('#pwdfind_phone').prop('required', false).val('');
    } else {
      $('#pwdFindByPhone').removeClass('hidden');
      $('#pwdFindByEmail').addClass('hidden');
      $('#pwdfind_phone').prop('required', true);
      $('#pwdfind_email').prop('required', false).val('');
    }
  });

  $('input[name="pwdFindType"]:checked').trigger('change');

  // 휴대폰 번호 입력시 숫자만 입력하도록.
  function onlyDigits($el) {
    $el.on('input', function () {
      this.value = this.value.replace(/\D/g, '');
    });
  }

  onlyDigits($('#idfind_phone'));
  onlyDigits($('#pwdfind_phone'));
});
