document.addEventListener('DOMContentLoaded', function() {
    // Form validation
    const form = document.querySelector('form');
    
    form.addEventListener('submit', function(e) {
        e.preventDefault();
        const memberId = document.getElementById('member-id').value;
        const fullName = document.getElementById('full-name').value;
        const mobile = document.getElementById('mobile').value;
        const zipCode = document.getElementById('zip-code').value;
        const address = document.getElementById('address').value;
        const detailedAddress = document.getElementById('detailed-address').value;
        const gender = document.getElementById('gender').value;
        const dob = document.getElementById('dob').value;
        const password = document.getElementById('password').value;
        const confirmPassword = document.getElementById('confirm-password').value;
        const termsChecked = document.getElementById('terms').checked;
        
        // Simple validation
        if (!memberId) {
            alert('Please enter your member ID!');
            return;
        }
        
        if (!fullName) {
            alert('Please enter your full name!');
            return;
        }
        
        if (!mobile) {
            alert('Please enter your mobile number!');
            return;
        }
        
        if (!dob) {
            alert('Please select your date of birth!');
            return;
        }
        
        if (password !== confirmPassword) {
alert('Passwords do not match!');
            return;
        }
        
        if (!termsChecked) {
            alert('You must agree to the terms and conditions!');
            return;
        }
        
        // Form is valid - in a real app you would submit to server here
        alert('Account created successfully! Redirecting...');
        
        // Reset form
        form.reset();
    });
    
    // Password strength indicator - would be enhanced in production
    const passwordInput = document.getElementById('password');
    passwordInput.addEventListener('input', function() {
        const strengthIndicator = document.createElement('div');
        strengthIndicator.className = 'text-xs mt-1';
        
        if (passwordInput.value.length > 0 && passwordInput.value.length < 6) {
            strengthIndicator.textContent = 'Weak';
            strengthIndicator.className += ' text-red-500';
        } else if (passwordInput.value.length >= 6 && passwordInput.value.length < 10) {
            strengthIndicator.textContent = 'Medium';
            strengthIndicator.className += ' text-yellow-500';
        } else if (passwordInput.value.length >= 10) {
            strengthIndicator.textContent = 'Strong';
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

$(function () {
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

        // ✅ 너 HTML에 맞춘 id
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
  
  
});

// ===== 우편번호찾기를 클릭했을 때 이벤트 처리하기 끝 =====