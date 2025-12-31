let b_idcheck_click = false;  // 아이디 중복확인을 클릭했는지 클릭하지 않았는지 여부를 알아오기 위한 용도 
let b_email_click = false;  // 이메일 중복확인을 클릭했는지 클릭하지 않았는지 여부를 알아오기 위한 용도 

const $modal = $('#termsModal');
const $terms = $('#terms');

$(function () {
	//alert("js로드댐");
	
	// ===== 우편번호 및 주소 디자인처리, 직접 기입 못하게 ===== // 
	$('#address, #postalCode').prop('readonly', true).addClass('readonly-gray').on('keydown paste', function(e){
		e.preventDefault();
	});
	
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
	        	$('#postalCode').val(data.zonecode);
	       	 	$('#address').val(addr);
	        	// extra항목 input이 없다면 아래 줄은 제거하거나, input을 만들어야 함
	        	// $('#address-extra').val(extraAddr);
	        	$('#detailed-address').focus();
	      	}
    	}).open();
  	});  
	
	// ===== 우편번호찾기를 클릭했을 때 이벤트 처리하기 끝 =====
	
	
	// ===== 회원가입 약관동의 모달 시작 ===== //
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
	// ===== 회원가입 약관동의 모달 끝 ===== //
	
	
	
	// ===== 회원가입 유효성 검사 시작 ====== //
	// 유효성검사 + submit
	$('form[name="registerFrm"]').on('submit', function (e) {
	  	e.preventDefault(); // 검증 후 통과하면 아래에서 submit 시킴

	  	// 각 value값 공백 제거 후 가져오기.
	  	const memberid = $('#memberid').val().trim();
	  	const name = $('#name').val().trim();
	  	const mobile = $('#mobile').val().trim();
	  	const postalCode = $('#postalCode').val().trim();
	  	const address = $('#address').val().trim();
	 	const addressDetail = $('#addressDetail').val().trim();
	  	const gender = $('#gender').val();            // male/female 또는 ""
	  	const birthday = $('#birthday').val().trim();   // YYYY-MM-DD
	  	const email = $('#email').val().trim();
	  	const password = $('#password').val();
	  	const confirmpw = $('#confirmpassword').val();
	  	const termsChecked = $('#terms').is(':checked');

	  	// 입력 및 선택 여부 확인.
	  	if (memberid === "") { 
			alert("아이디를 입력해주세요."); 
			$('#memberid').focus(); 
		return; 
	  	}
		
	  	if (name === "") { 
			alert("성명을 입력해주세요."); 
			$('#name').focus(); 
			return; 
		}
	  	if (mobile === "") { 
			alert("전화번호를 입력해주세요."); 
			$('#mobile').focus(); 
			return; 
		}
	  	if (postalCode === "") { 
			alert("우편번호를 입력해주세요.(우편번호 찾기 이용)"); 
			$('#postalCode').focus(); 
			return; 
		}
	  	if (address === "") { 
			alert("주소를 입력해주세요.(우편번호 찾기 이용)"); 
			$('#address').focus(); 
			return; 
		}
	  	if (addressDetail === "") { 
			alert("상세 주소를 입력해주세요."); 
			$('#addressDetail').focus(); 
			return; 
		}
	  	if (!gender) { alert("성별을 선택해주세요."); 
			$('#gender').focus(); 
			return; 
		}
	  	if (birthday === "") { 
			alert("생년월일을 선택해주세요."); 
			$('#birthday').focus(); 
			return; 
		}
	  	if (email === "") { alert("이메일을 입력해주세요."); 
			$('#email').focus(); 
			return; 
		}
	  	if (password === "") { 
			alert("비밀번호를 입력해주세요."); 
			$('#password').focus(); 
			return; 
		}
	  	if (confirmpw === "") { 
			alert("비밀번호 확인을 입력해주세요."); 
			$('#confirmpassword').focus(); 
			return; 
		}
	  	if (!termsChecked) { 
			alert("약관에 동의해야 합니다."); 
			return; 
		}

	  	// 성명 유효성 검사 ( 한글, 영문만 가능하게 )
	  	const regName = /^[가-힣a-zA-Z]+$/;
	  	if (!regName.test(name)) {
	    	alert("성명은 한글 또는 영문자만 입력 가능합니다. (공백/특수문자/숫자 불가)");
	    	$('#name').focus();
	    return;
	  	}

	  	// 전화번호 유효성 검사( 010으로 시작해서, 8자리 숫자만 가능하도록 )
	  	const regMobile = /^010\d{8}$/;
	  	if (!regMobile.test(mobile)) {
	    	alert("전화번호는 010으로 시작하는 11자리 숫자만 가능합니다.\n예) 01012341234");
	    	$('#mobile').focus();
	    	return;
	  	}

	  	// 생년월일 유효성 검사 ( 아래 isValidRealDate 함수 확인 )
	  	if (!isValidRealDate(birthday)) {
	    	alert("생년월일이 올바르지 않습니다. 실제 존재하는 날짜를 선택해주세요.");
	    	$('#birthday').focus();
	    	return;
	  	}

	  	// 이메일 유효성 검사 
	  	const regEmail = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,}$/;
	  	if (!regEmail.test(email)) {
	    	alert("이메일 형식이 올바르지 않습니다.\n예) you@example.com");
	    	$('#email').focus();
	    return;
	  	}

	  	// 비밀번호 유효성 검사 ( 특수문자, 영 대/소문자, 숫자 포함 8자 - 15자 이내로  )
	  	const regPwd = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^\w\s]).{8,15}$/;
	  	if (!regPwd.test(password)) {
	    	alert("비밀번호는 8~15자이며, 영문 대/소문자, 숫자, 특수문자를 모두 포함해야 합니다.");
		    $('#password').focus();
		    return;
	  	}

	  	// 비밀번호 확인 유효성 검사 
	  	if (password !== confirmpw) {
	    	alert("비밀번호가 일치하지 않습니다.");
	    	$('#confirmpassword').focus();
	    return;
	  	}

		// 위 유효성 검사에서 문제가 없다면( return 되지 않았다ㅓ면.) post 방식으로 submit 하게됨.
	  	this.method = "post";
	  	this.submit();
	});
	
	// =====  날짜 검증 함수 =====
	function isValidRealDate(yyyy_mm_dd) {
	  // YYYY-MM-DD 형식
	  const m = yyyy_mm_dd.match(/^(\d{4})-(\d{2})-(\d{2})$/);
	  if (!m) return false;

	  const y = Number(m[1]);
	  const mo = Number(m[2]);
	  const d = Number(m[3]);

	  // 월/일 기본 범위
	  if (mo < 1 || mo > 12) return false;
	  if (d < 1 || d > 31) return false;

	  // 실제 날짜인지 체크
	  const dt = new Date(y, mo - 1, d);
	  return dt.getFullYear() === y && (dt.getMonth() + 1) === mo && dt.getDate() === d;
	
	};
	
	
	
	
	// --- 아이디중복확인을 클릭했을 때 이벤트 처리하기 시작 ---
	$('button#id_check').click(function(){
		// 입력하고자 하는 아이디가 데이터베이스 테이블에 존재하는지, 존재하지 않는지 알아오기
		if( $('#memberid').val().trim() != ""){
			$.ajax({
				url: "idDuplicateCheck.hp" ,
				data: {"memberid" : $('#memberid').val()} ,
				// idDuplicateCheck.hp 로 jsp의 memberid 밸류값 전송 
				type: "post" , 
				async: true , // 동기방식으로 보낸다.
				success:function(text){				
					const json = JSON.parse(text);
				
					if(json.isExists){
						//입력한 memberid가 이미 사용중인 경우.
						alert($('#memberid').val() + "은 이미 사용중이므로 다른 아이디를 입력하세요.");	
						$('#memberid').val("");
						b_idcheck_click = true;
					}
					else{
						//입력한 memberid가 아직 사용되지 않은 경우.
						alert($('#memberid').val() + "은 사용가능합니다.");	
					}
				},
				error:function(request, status, error){
					alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		        }
			});
		}// EoP if( $('input#userid').val().trim() != ""){}
	});	
	// --- 아이디 중복확인을 클릭했을 때 이벤트 처리하기 끝 ---
	
	
	
	// --- 아이디값이 변경되면 가입하기 버튼 클릭시 아이디 중복확인을 클릭했는지 알아보기 위한 용도 초기화 시키기---
	$('input#userid').bind("change", function(){
		b_idcheck_click = false;
	})
	
	// --- 이메일값이 변경되면 가입하기 버튼 클릭시 아이디 중복확인을 클릭했는지 알아보기 위한 용도 초기화 시키기---
	$('input#email').bind("change", function(){
		b_email_click = false;
	})		
	
	
	
	
});

