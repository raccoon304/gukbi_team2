/*
btnOpenAdd:			배송지 추가 버튼
btnOpenAddEmpty:	첫 배송지 추가하기 버튼(배송지 없을 때)

checkAll:			전체 선택 체크박스
btnDeleteSelected:	선택 삭제 버튼
btnSetDefault:		기본 배송지로 설정 버튼

deleteForm:			선택 삭제 전송 폼
defaultForm:			기본 배송지 설정 전송 폼
defaultDeliveryId:	기본 배송지 설정용 hidden input(선택된 배송지 id 저장)

addressModal:		배송지 추가/수정 모달 전체 영역
addressModalLabel:	모달 제목(h5)

addressForm:		배송지 추가/수정 전송 폼
mode:				추가/수정 모드 hidden input(add/edit)
deliveryAddressId:	수정 대상 배송지 id hidden input

addressName:		배송지명 입력 input
recipientName:		수령인 입력 input
postalCode:			우편번호 입력 input
btnPostcodeSearch:	우편번호 검색 버튼
recipientPhone:		연락처 입력 input
address:			주소 입력 input
addressDetail:		상세주소 입력 input
*/


(function () {
	// ===== 우편번호 및 주소 디자인처리, 직접 기입 못하게 ===== // 
	$('#address, #postalCode').prop('readonly', true).addClass('readonly-gray').on('keydown paste', function(e){
		e.preventDefault();
	});
	
	function resetModalToAdd() {
	    document.querySelector('#addressModalLabel').innerText = '배송지 추가';
	    document.querySelector('#mode').value = 'add';
	    document.querySelector('#deliveryAddressId').value = '';
	
	    document.querySelector('#addressName').value = '';
	    document.querySelector('#recipientName').value = '';
	    document.querySelector('#postalCode').value = '';
	    document.querySelector('#recipientPhone').value = '';
	    document.querySelector('#address').value = '';
	    document.querySelector('#addressDetail').value = '';
  	}

  	function fillModalToEdit(btn) {
	    document.querySelector('#addressModalLabel').innerText = '배송지 수정';
	    document.querySelector('#mode').value = 'edit';
	
	    document.querySelector('#deliveryAddressId').value = btn.dataset.id || '';
	    document.querySelector('#addressName').value = btn.dataset.addressname || '';
	    document.querySelector('#recipientName').value = btn.dataset.recipientname || '';
	    document.querySelector('#postalCode').value = btn.dataset.postalcode || '';
	    document.querySelector('#recipientPhone').value = btn.dataset.phone || '';
	    document.querySelector('#address').value = btn.dataset.address || '';
	    document.querySelector('#addressDetail').value = btn.dataset.addressdetail || '';
  	}

  	function getCheckedIds() {
	    // disabled(기본배송지) 제외하고 체크된 것만 가져오기
	    const checked = document.querySelectorAll('.addr-check:not(:disabled):checked');
	    return Array.from(checked).map(ch => ch.value);
  	}

  	document.addEventListener('DOMContentLoaded', function () {
	    // 추가 버튼들 -> 모달 초기화
	    const btnOpenAdd = document.querySelector('#btnOpenAdd');
	    if (btnOpenAdd) btnOpenAdd.addEventListener('click', resetModalToAdd);

	    const btnOpenAddEmpty = document.querySelector('#btnOpenAddEmpty');
	    if (btnOpenAddEmpty) btnOpenAddEmpty.addEventListener('click', resetModalToAdd);

    	// 수정 버튼들 -> data-* 기반으로 모달 채우기
    	document.querySelectorAll('.btnOpenEdit').forEach(function (btn) {
      		btn.addEventListener('click', function () {
        		fillModalToEdit(btn);
      		});
    	});

		// 전체선택
	    const checkAll = document.querySelector('#checkAll');
	    if (checkAll) {
	  		checkAll.addEventListener('change', function () {
				// 기본배송지(disabled) 체크박스는 전체선택에서 제외
	        	document.querySelectorAll('.addr-check:not(:disabled)').forEach(function (ch) {
	          		ch.checked = checkAll.checked;
	        	});
	      	});
		}

	    // 개별 체크 변경 시 전체선택 상태 동기화(기본배송지 제외)
	    document.querySelectorAll('.addr-check').forEach(function (ch) {
	  		ch.addEventListener('change', function () {
	        	const total = document.querySelectorAll('.addr-check:not(:disabled)').length;
	        	const checked = document.querySelectorAll('.addr-check:not(:disabled):checked').length;
				
	        	if (total === 0) {
	          		if (checkAll) checkAll.checked = false;
	          		return;
	        	}
	        	if (checkAll) checkAll.checked = (total === checked);
	      	});
		});

	    // 선택 삭제
	    const btnDeleteSelected = document.querySelector('#btnDeleteSelected');
	    if (btnDeleteSelected) {
	  		btnDeleteSelected.addEventListener('click', function () {
		        const ids = getCheckedIds();
		        if (ids.length === 0) {
		      		alert('삭제할 배송지를 선택하세요.');
		          	return;
		        }
		        if (!confirm('선택한 배송지를 삭제하시겠습니까?')) return;
		
		        const form = document.querySelector('#deleteForm');
		        form.innerHTML = ''; // hidden 초기화
		
		        ids.forEach(function (id) {
		      		const input = document.createElement('input');
		          	input.type = 'hidden';
		          	input.name = 'deliveryAddressId';
		          	input.value = id;
		          	form.appendChild(input);
		        });
		        form.submit();
	  		});
		}

	    // 기본 배송지 설정 (1개만)
	    const btnSetDefault = document.querySelector('#btnSetDefault');
	    if (btnSetDefault) {
	  		btnSetDefault.addEventListener('click', function () {
	        	const ids = getCheckedIds();
	
	        	if (ids.length === 0) {
	          		alert('기본으로 설정할 배송지를 선택하세요.');
	          		return;
	        	}
	        	if (ids.length > 1) {
	          		alert('기본 배송지는 1개만 선택할 수 있습니다.');
	          		return;
	        	}
	        	if (!confirm('선택한 배송지를 기본 배송지로 설정하시겠습니까?')) return;
	
	        	document.querySelector('#defaultDeliveryId').value = ids[0];
	        	document.querySelector('#defaultForm').submit();
	      	});
	    }

	    // ===== 연락처 유효성검사 ===== //
	    const $phone = $('#recipientPhone');
	    $phone.attr({
	    	inputmode: 'numeric',
	    	pattern: '[0-9]*',
	    	autocomplete: 'tel',
	    	maxlength: 11
	    });

	    $phone.on('keydown', function (e) {
	    	const allowedKeys = [
	    		'Backspace', 'Delete', 'Tab', 'Escape', 'Enter',
	    		'ArrowLeft', 'ArrowRight', 'ArrowUp', 'ArrowDown',
	    		'Home', 'End'
	    	];

	    	if (allowedKeys.includes(e.key)) return;

	    	if ((e.ctrlKey || e.metaKey) && ['a', 'c', 'v', 'x'].includes(e.key.toLowerCase())) return;

	    	if (!/^\d$/.test(e.key)) {
	    		e.preventDefault();
	    	}
	    });

	    $phone.on('input', function () {
	    	const onlyDigits = this.value.replace(/\D/g, '');
	    	if (this.value !== onlyDigits) this.value = onlyDigits;
	    });

	    $('#addressForm').on('submit', function (e) {
	    	const v = $('#recipientPhone').val().trim();
	    	if (!/^\d{10,11}$/.test(v)) {
	    		alert('연락처는 10~11자리 숫자만 입력 가능합니다.');
	    		$('#recipientPhone').focus();
	    		e.preventDefault();
	    	}
	    });

	    // 우편번호 검색(프로젝트 방식에 맞게 연결)
	    const btnPostcodeSearch = document.querySelector('#btnPostcodeSearch');
	    if (btnPostcodeSearch) {
	  		btnPostcodeSearch.addEventListener('click', function () {
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
			        	$('#postalCode').val(data.zonecode);
			       	 	$('#address').val(addr);
			        	// extra항목 input이 없다면 아래 줄은 제거하거나, input을 만들어야 함
			        	// $('#address-extra').val(extraAddr);
	
			        	// 실제 존재하는 id로 포커스 이동
			        	$('#addressDetail').focus();
		      		}	
		  		}).open();
			});
  		}
	});  
})();
