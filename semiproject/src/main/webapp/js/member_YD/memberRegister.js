let b_idcheck_click = false;  // 아이디 중복확인을 클릭했는지 클릭하지 않았는지 여부를 알아오기 위한 용도 
let b_email_click = false;  // 이메일 중복확인을 클릭했는지 클릭하지 않았는지 여부를 알아오기 위한 용도 

$(function () {
	// 우편번호를 읽기전용(readonly)로 만들기
	$('input#address').attr('readonly', true);
	$('input#zip-code').attr('readonly', true);
	
	// ===== 우편번호찾기를 클릭했을 때 이벤트 처리하기 시작 =====
  	$('img#zipcodeSearch').on('click', function () {
    	new daum.Postcode({
	      	oncomplete: function (data) {
	        	let addr = '';
	        	let extraAddr = '';
	
		        if (data.userSelectedType === 'R') addr = data.roadAddress;
		        else addr = data.jibunAddress;
		
		        if (data.userSelectedType === 'R') {
	          		if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) extraAddr += data.bname;
	          		if (data.buildingName !== '' && data.apartment === 'Y')
	            		extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
	          		if (extraAddr !== '') extraAddr = ' (' + extraAddr + ')';
	        	}
	        	$('#zip-code').val(data.zonecode);
	       	 	$('#address').val(addr);
	        	// extra항목 input이 없다면 아래 줄은 제거하거나, input을 만들어야 함
	        	// $('#address-extra').val(extraAddr);
	        	$('#detailed-address').focus();
	      	}
    	}).open();
  	});  
  	const $modal = $('#termsModal');
    const $terms = $('#terms');
	// ===== 우편번호찾기를 클릭했을 때 이벤트 처리하기 끝 =====
	
	// ===== 회원가입 약관동의 모달 시작 ===== //
    function openModal() {
      	$modal.removeClass('hidden').attr('aria-hidden', 'false');
      	$('body').addClass('overflow-hidden'); // 배경 스크롤 방지
    }

    function closeModal() {
      	$modal.addClass('hidden').attr('aria-hidden', 'true');
      	$('body').removeClass('overflow-hidden');
    }

    $('#openTerms').on('click', function (e) {
      	e.preventDefault();
      	openModal();
    });

    $('#closeTerms, #closeTerms2, #termsBackdrop').on('click', function () {
      	closeModal();
    });

    // ESC로 닫기
    $(document).on('keydown', function (e) {
      	if (e.key === 'Escape' && !$modal.hasClass('hidden')) closeModal();
    });

    // 모달에서 Agree 누르면 체크박스 자동 체크 후 닫기
    $('#agreeAndClose').on('click', function () {
     	 $terms.prop('checked', true);
      	closeModal();
    });
	// ===== 회원가입 약관동의 모달 끝 ===== //
	
	
	
	// ===== 회원가입 유효성 검사 시작 ====== //
	
	
	
	
});




function goRegister(){
	
	const frm = document.registerFrm;
	//frm.action = "memberRegister.up"; 따로 작성해놓지 않으면 디폴트
	frm.method = "post";
	frm.submit();
}




document.addEventListener('DOMContentLoaded', function() {
    // Form validation
    const form = document.querySelector('form');
    
    form.addEventListener('submit', function(e) {
        e.preventDefault();
        const memberId = document.getElementById('memberid').value;
        const name = document.getElementById('name').value;
        const mobile = document.getElementById('mobile').value;
        const postalCode = document.getElementById('postalCode').value;
        const address = document.getElementById('address').value;
        const addressDetail = document.getElementById('addressDetail').value;

        const gender = document.getElementById('gender').value;
        const birthday = document.getElementById('birthday').value;
        const password = document.getElementById('password').value;
        const confirmPassword = document.getElementById('confirmpassword').value;
        const termsChecked = document.getElementById('terms').checked;
        
        // Simple validation
        if (!memberId) {
            alert('아이디를 입력해주세요.');
            return;
        }
        
        if (!name) {
            alert('이름을 입력해주세요.');
            return;
        }
        
        if (!mobile) {
            alert('휴대전화 번호를 입력해주세요.');
            return;
        }
        
        if (!birthday) {
            alert('생년월일을 선택해 주세요.');
            return;
        }
        
        if (password !== confirmPassword) {
			alert('비밀번호가 일치하지 않습니다.');
            return;
        }
        
        if (!termsChecked) {
            alert('약관 및 운영 동의를 해야합니다.');
            return;
        }
        
        // Form is valid - in a real app you would submit to server here
        alert('계정 생성 완료.');
        
        // Reset form
        form.reset();
    });
    
    // Password strength indicator - would be enhanced in production
    const passwordInput = document.getElementById('password');
    passwordInput.addEventListener('input', function() {
        const strengthIndicator = document.createElement('div');
        strengthIndicator.className = 'text-xs mt-1';
        
        if (passwordInput.value.length > 0 && passwordInput.value.length < 6) {
            strengthIndicator.textContent = '취약';
            strengthIndicator.className += ' text-red-500';
        } else if (passwordInput.value.length >= 6 && passwordInput.value.length < 10) {
            strengthIndicator.textContent = '보통';
            strengthIndicator.className += ' text-yellow-500';
        } else if (passwordInput.value.length >= 10) {
            strengthIndicator.textContent = '강력';
            strengthIndicator.className += ' text-green-500';
        }
        
        // Update or create indicator
        const existingIndicator = passwordInput.nextElementSibling;
        if (existingIndicator && existingIndicator.className.includes('text-xs')) {
            existingIndicator.replaceWith(strengthIndicator);
        } else {
            passwordInput.insertAdjacentElement('afterend', strengthIndicator);
        }
    });
});