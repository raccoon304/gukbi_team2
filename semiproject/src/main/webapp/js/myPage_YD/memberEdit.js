$(function () {

  // 최초 로딩 시 기존값 저장( 유효성 검사 값 비교하려고 )
  const originalMobile = ($('#mobile').val() || '').trim();
  const originalEmail  = ($('#email').val()  || '').trim();

  // 휴대폰 입력시 숫자만 남기기(공란 방지와 별개로 UX)
  $('#mobile').on('input', function(){
    this.value = this.value.replace(/\D/g, '');
  });

  $('#memberEditEndForm').on('submit', function(e){
    e.preventDefault();

    const $form = $(this);

    const name   = ($('#name').val()   || '').trim();
    const mobile = ($('#mobile').val() || '').trim();
    const email  = ($('#email').val()  || '').trim();

    const password    = $('#password').val();
    const passwordChk = $('#passwordChk').val();

    // 필수값 공란(공백 포함) 방지
    if(name === ""){
      alert("성명을 입력하세요.");
      $('#name').val('').focus();
      return;
    }

    if(mobile === ""){
      alert("전화번호를 입력하세요.");
      $('#mobile').val('').focus();
      return;
    }

    if(email === ""){
      alert("이메일을 입력하세요.");
      $('#email').val('').focus();
      return;
    }

    // 유효성 검사
    const regName = /^[가-힣a-zA-Z]+$/;
    if(!regName.test(name)){
      alert("성명은 한글 또는 영문자만 입력 가능합니다. (공백/특수문자/숫자 불가)");
      $('#name').focus();
      return;
    }

    const regMobile = /^010\d{8}$/;
    if(!regMobile.test(mobile)){
      alert("전화번호는 010으로 시작하는 11자리 숫자만 가능합니다.\n예) 01012341234");
      $('#mobile').focus();
      return;
    }

    const regEmail = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,}$/;
    if(!regEmail.test(email)){
      alert("이메일 형식이 올바르지 않습니다.\n예) you@example.com");
      $('#email').focus();
      return;
    }

    // 비밀번호 검사
    const changePw = (password != null && password.trim() !== "");

    if(changePw){
      const regPwd = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^\w\s]).{8,15}$/;

      if(!regPwd.test(password)){
        alert("비밀번호는 8~15자이며, 영문 대/소문자, 숫자, 특수문자를 모두 포함해야 합니다.");
        $('#password').focus();
        return;
      }

      if(passwordChk == null || passwordChk.trim() === ""){
        alert("비밀번호 확인을 입력해주세요.");
        $('#passwordChk').focus();
        return;
      }

      if(password !== passwordChk){
        alert("비밀번호가 일치하지 않습니다.");
        $('#passwordChk').focus();
        return;
      }
    } else {
      if(passwordChk != null && passwordChk.trim() !== ""){
        alert("비밀번호를 변경하려면 비밀번호도 함께 입력해주세요.");
        $('#password').focus();
        return;
      }
    }

    // 제출 시점 중복검사 변경된 경우에만 검사
    const tasks = [];

    // 이메일이 기존 이메일과 다를 때만 중복검사
    if(email !== originalEmail){
      tasks.push(
        $.ajax({
          url: ctxPath + "/member/emailDuplicateCheck.hp",
          type: "post",
          data: { email: email },
          async: true
        }).then(function(text){
          const json = JSON.parse(text);
          if(json.isExists){
            alert(email + " 은(는) 이미 사용중인 이메일입니다.");
            $('#email').focus();
            return $.Deferred().reject("email-dup");
          }
        })
      );
    }

    // 휴대폰이 기존 휴대폰과 다를 때만 중복검사
    if(mobile !== originalMobile){
      tasks.push(
        $.ajax({
          url: ctxPath + "/member/mobileDuplicateCheck.hp",
          type: "post",
          data: { mobile: mobile },
          async: true
        }).then(function(text){
          const json = JSON.parse(text);
          if(json.isExists){
            alert(mobile + " 은(는) 이미 사용중인 휴대폰번호입니다.");
            $('#mobile').focus();
            return $.Deferred().reject("mobile-dup");
          }
        })
      );
    }

    // 중복검사 통과(또는 스킵)하면 submit
    $.when.apply($, tasks)
      .done(function(){
        $form.off('submit');   // 무한루프 방지
        $form.submit();
      })
      .fail(function(err){
        if(err !== "email-dup" && err !== "mobile-dup"){
          alert("중복검사 중 오류가 발생했습니다.\n잠시 후 다시 시도해주세요.");
        }
      });

  });

});
