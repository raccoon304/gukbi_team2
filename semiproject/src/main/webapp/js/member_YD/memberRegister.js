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
	// ===== 우편번호찾기를 클릭했을 때 이벤트 처리하기 끝 =====
	
	
});




function goRegister(){
	
	const frm = document.registerFrm;
	//frm.action = "memberRegister.up"; 따로 작성해놓지 않으면 디폴트
	frm.method = "post";
	frm.submit();
}
