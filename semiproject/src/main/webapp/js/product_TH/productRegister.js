$(document).ready(function() {
    let isDuplicateCheckCode = false; //상품코드 중복체크
	let isDuplicateCheckName = false; //상품명 중복체크
    let uploadedFile = null; //이미지경로
	let isImageFileANDPath = false; //이미지파일, 이미지경로 올렸는지 검사
	
	let isSendData = false; //중복된 상품코드와 새로운 상품코드를 구분하는 값
	let productCode = "";

    // 색상 클래스 매핑
    const colorClassMap = {
        '블랙': 'Black',
        '화이트': 'White',
        '블루': 'Blue',
        '레드': 'Red',
    };

	//처음엔 입력란들 모두 비활성화해주기
	disableImageUpload();

	
	//비활성화 함수
	function disableImageUpload() {
		$('#brand').val("").prop('disabled', true);; //브랜드 입력란 비활성화
		$('#productName').val("").prop('readonly', true); //상품명 입력한 비활성화
		$('#checkDuplicateNameBtn').prop('disabled', true); //상품명 중복체크 비활성화
		$('#basePrice').val("").prop('readonly', true); //기본가격 비활성화
		$("#description").val("").prop('readonly', true); //상품설명 비활성화
	    $('#imageFile').prop('disabled', true); //파일업로드 비활성화
	    $('#imagePath').prop('disabled', true); //이미지경로 URL 입력 비활성화
	    $('#removeImageBtn').prop('disabled', true); //제거 버튼 비활성화
	    //드롭존 전체 클릭/드래그 비활성화
		$('#dropZone').css({
	        'pointer-events': 'none',
	        'opacity': '0.4'
	    });
	    //$('#imagePreview').hide();
	}
	
	//활성화 함수	
	function enableImageUpload() {
		$('#brand').val("").prop('disabled', false);; //브랜드 입력란 활성화
		$('#productName').val("").prop('readonly', false); //상품명 입력한 활성화
		$('#checkDuplicateNameBtn').prop('disabled', false); //상품명 중복체크 활성화
		$('#basePrice').val("").prop('readonly', false); //기본가격 활성화
		$("#description").val("").prop('readonly', false); //상품설명 활성화
	    $('#imageFile').prop('disabled', false);
	    $('#imagePath').prop('disabled', false);
	    $('#removeImageBtn').prop('disabled', false);

	    $('#dropZone').css({
	        'pointer-events': 'auto',
	        'opacity': '1'
	    });
		//$('#imagePreview').show();
	}
	
	
    // 상품 코드 입력 시 비활성화 항목들 활성화해주기
    $('#productCode').on('input', function(e) {
        isDuplicateCheckCode = false; //상품코드 중복체크 거짓값으로 바꾸기
		isDuplicateCheckName = false; //상품명 중복체크를 거짓값으로 바꾸기
    });

    // 형식 및 중복 체크
    $('#checkDuplicateCodeBtn').click(function() {
		//상품코드 중복버튼을 눌렀을 때 활성화 함수를 실행
		enableImageUpload();
		
        const productCode = $('#productCode').val().trim();
        if (!productCode) {
            alert('상품 코드를 입력해주세요.');
            return;
        }
        const codePattern = /^\d{4}[A-Z]{2}$/;
        if (!codePattern.test(productCode)) {
            alert('상품 코드는 숫자 4자리+대문자 영문 2자리여야 합니다.');
			$("input#productCode").val("");
            return;
        }
        checkDuplicateProductCode();
    });
	//상품코드 중복검사 실행하기(ajax 이용)
    function checkDuplicateProductCode() { 
        $('#checkDuplicateCodeBtn').prop('disabled', true).html('<i class="fas fa-spinner fa-spin mr-2"></i>확인 중...');
        setTimeout(function() {
			$.ajax({
				url:"checkDuplicateProductCode.hp",
				data:{
					"productCode":$("input#productCode").val()
				},
				type: "post",
				dataType:"json",
				success:function(json){
					//console.log("확인용 json:" ,json);
					//alert(json.message);
					const isDuplicate = json.isProductCode;
					const productName = json.productName;
					const brandName = json.brandName;
					const price = json.price
					const productDESC = json.productDESC;
					const imagePath = json.imagePath;
					productCode = json.productCode; //만약 
					
					//상품코드가 중복됐다면 입력항목에 해당 값을을 넣어주고 비활성화
					showDuplicateResult(isDuplicate, productName, price, brandName, productDESC, imagePath);
				},
				error:function(request, status, error){
					alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				}
			});
            
            $('#checkDuplicateCodeBtn').prop('disabled', false).html('<i class="fas fa-check-circle mr-2"></i>중복 확인');
        }, 500);
    }
	// 상품코드 유효성검사 및 중복검사 이후 보여줄 메시지와 항목 자동 기입
    function showDuplicateResult(isDuplicate, productName, price, brandName, productDESC, imagePath) {
        const resultDiv = $('#duplicateCheckResult');
		isDuplicateCheckCode = true; //상품코드 중복체크 참값으로 바꾸기
		
        if (isDuplicate) {
			//중복된 상품코드일 경우
            resultDiv.html('<div class="duplicate-result unavailable"><i class="fas fa-times-circle mr-2"></i>사용 중인 상품명입니다. 옵션 등록으로 넘어가겠습니다.</div>');
			$('#brand').val(brandName).prop('disabled', true);; //상품코드에 해당하는 브랜드로 변경 후 비활성화
			$('#productName').val(productName).prop('readonly', true); //상품코드에 해당하는 상품명 기입 후 읽기전용
			$('#checkDuplicateNameBtn').prop('disabled', true); //상품명 중복체크 비활성화
			$('#basePrice').val(price).prop('readonly', true); //상품코드에 해당하는 기본가격 기입 후 읽기전용
			$("#description").val(productDESC).prop('readonly', true); //상품코드에 해당하는 상품설명 기입 후 읽기전용
			$('#imageFile').prop('disabled', true); //파일업로드 비활성화
		    $('#imagePath').val(imagePath).prop('disabled', true); //이미지경로 URL 입력 비활성화
		    $('#removeImageBtn').prop('disabled', true); //제거 버튼 비활성화
		    //드롭존 전체 클릭/드래그 비활성화
			$('#dropZone').css({
		        'pointer-events': 'none',
		        'opacity': '0.4'
		    });
			
			isDuplicateCheckName = true; //상품명 중복체크를 참값으로 바꾸기
			isImageFileANDPath = true; //중복됐다면 이미지등록과 경로를 참값으로 바꾸기
			isSendData = true; //중복됐을 때의 ajax 보내기를 구분
			
			// 2.2초 후 스크롤
		    setTimeout(function () {
		        $('html, body').animate({
		            scrollTop: $('#optionSection').offset().top - 100
		        }, 500);
		    }, 1900);
			
        } else {
			//중복되지 않은 상품코드일 경우
            resultDiv.html('<div class="duplicate-result available"><i class="fas fa-check-circle mr-2"></i>사용 가능한 상품 코드입니다.</div>');
			
			isDuplicateCheckName = false; //상품명 중복체크를 거짓값으로 바꾸기
			isImageFileANDPath = false; //중복됐다면 이미지등록과 경로를 거짓값으로 바꾸기
			isSendData = false;
			
			//새로운 상품코드이므로 비활성화 항목들 모두 활성화해주기
			enableImageUpload();
        }
        resultDiv.fadeIn();
    }

	
	//=========================상품명 중복체크 및 유효성 검사========================//
	
	// 상품명 입력 시 중복 체크 초기화
	$('#productName').on('input', function() {
	    isDuplicateCheckName = false;
	    $('#duplicateCheckResult2').hide();
	});

	// 형식 및 중복 체크
	$('#checkDuplicateNameBtn').click(function() {
	    const productName = $('#productName').val().trim();
	    if (!productName) {
	        alert('상품명을 입력해주세요.');
	        return;
	    }
		const codePattern = /^[A-Za-z0-9 ]+$/;
	    if (!codePattern.test(productName)) {
	        alert('상품명에 특수기호는 입력이 불가합니다.');
			$('#productName').val("");
	        return;
	    }
	    checkDuplicateProductName();
	});
	//상품명 중복 체크 함수
	function checkDuplicateProductName() {
	    $('#checkDuplicateNameBtn').prop('disabled', true).html('<i class="fas fa-spinner fa-spin mr-2"></i>확인 중...');
	    setTimeout(function() {
			$.ajax({
				url:"checkDuplicateProductName.hp",
				data:{
					"productName":$("input#productName").val().trim()
				},
				type:"post",
				dataType:"json",
				success:function(json){
					//console.log("확인용 json:" ,json);
					//alert(json.message);
					const isDuplicate = json.isProductName;
					showDuplicateResult2(isDuplicate);
				},
				error:function(request, status, error){
					alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				}
			});
	        
	        $('#checkDuplicateNameBtn').prop('disabled', false).html('<i class="fas fa-check-circle mr-2"></i>중복 확인');
	    }, 500);
	}
	//중복체크 버튼 클릭 후 나오는 이벤트
	function showDuplicateResult2(isDuplicate) {
	    const resultDiv = $('#duplicateCheckResult2');
		isDuplicateCheckName = true;
		
	    if (isDuplicate) {
			//상품명이 중복됐을 경우
	        resultDiv.html('<div class="duplicate-result unavailable"><i class="fas fa-times-circle mr-2"></i>이미 사용 중인 상품명입니다.</div>');
			$('#productName').val("");
	    } else {
			//상품명이 사용 가능한 경우
	        resultDiv.html('<div class="duplicate-result available"><i class="fas fa-check-circle mr-2"></i>사용 가능한 상품명입니다.</div>');
	    }
	    resultDiv.fadeIn();
	}
	//=================================================//
	
	
	// 기본금액 유효성검사
	$('#basePrice').on('input', function () {
       	let value = $(this).val();
       	value = value.replace(/[^0-9]/g, '');  //숫자(0~9)만 남기기
       	$(this).val(value);
   	});
	   
	
	// 중복 옵션 체크
	function isDuplicateOption(storage, color) {
	    return $(`.matrix-row[data-storage="${storage}"][data-color="${color}"]`).length > 0;
	}
	
	// 옵션 매트릭스 추가 버튼 클릭 시만 생성
	$('#addOptionMatrix').on('click', function () {
		const hasOption = updateOptionMatrix();

	    if (hasOption === false) {
	        alert('저장용량과 색상을 선택해주세요.');
	        return;
	    }

	    // ✅ 조합 생성 후 선택 해제
	    $('input[name="storage"]').prop('checked', false);
	    $('input[name="color"]').prop('checked', false);
	});
	
	//옵션 매트릭스 생성 함수
	function updateOptionMatrix() {
	    const selectedStorages = $('input[name="storage"]:checked');
	    const selectedColors   = $('input[name="color"]:checked');
	    const container        = $('#optionMatrixTable');
	    const basePrice        = parseInt($('#basePrice').val()) || 0;

	    // 선택 안 했을 경우
	    if (selectedStorages.length === 0 || selectedColors.length === 0) {
	        return false;
	    } 
		//container.empty();
		
	    selectedStorages.each(function () {
	        const storage         = $(this).val();
	        const additionalPrice = parseInt($(this).data('price')) || 0;
	        const is256GB         = storage === '256GB';

	        selectedColors.each(function () {
	            const color      = $(this).val();
	            const colorClass = colorClassMap[color] || 'black';

			   //중복 방지
	           if (isDuplicateOption(storage, color)) {
	               return;
	           }
				
	            // 256GB → 기본가 / 나머지 → 추가금
	            const priceValue   = is256GB ? basePrice : additionalPrice;
	            const priceLabel   = is256GB ? '기본가' : '추가금';
	            const priceReadonly = is256GB
	                ? 'readonly style="background:#e9ecef; cursor:not-allowed;"'
	                : '';

	            const row = $(`
	                <div class="matrix-row">
	                    <div class="matrix-cell storage">
	                        <i class="fas fa-hdd mr-2"></i>${storage}
	                    </div>
	                    <div class="matrix-cell color">
	                        <span class="color-indicator ${colorClass}"></span>${color}
	                    </div>

	                    <div class="matrix-input">
	                        <div class="input-group">
	                            <input type="number"
	                                   class="form-control option-stock"
	                                   data-storage="${storage}"
	                                   data-color="${color}"
	                                   placeholder="재고"
	                                   min="0" required>
	                            <div class="input-group-append">
	                                <span class="input-group-text">개</span>
	                            </div>
	                        </div>
	                    </div>

	                    <div class="matrix-input">
	                        <div class="input-group">
	                            <div class="input-group-prepend">
	                                <span class="input-group-text"
	                                      style="background:${is256GB ? '#667eea' : '#6c757d'};
	                                             color:white; border:none;">
	                                    ${priceLabel}
	                                </span>
	                            </div>
	                            <input type="number"
	                                   class="form-control option-additional-price"
	                                   data-storage="${storage}"
	                                   data-color="${color}"
	                                   data-is-base="${is256GB}"
	                                   value="${priceValue}"
	                                   min="0" required ${priceReadonly}>
	                            <div class="input-group-append">
	                                <span class="input-group-text">원</span>
	                            </div>
	                        </div>
	                    </div>
	                </div>
	            `);

	            container.append(row);
	        });
	    });
		return true;
	}
	
	// 기본 가격 변경 시 매트릭스 업데이트
	$('#basePrice').on('input', function() {
	    updateBasePriceInMatrix();
	});
	//기본금 업데이트 함수
	function updateBasePriceInMatrix() {
	    const basePrice = parseInt($('#basePrice').val()) || 0;

	    $('.option-additional-price[data-is-base="true"]').each(function () {
	        $(this).val(basePrice);
	    });
	}
	
	// ======================== 이미지 처리 ======================== //
    // 드래그 앤 드롭
    $('#dropZone').click(function() {
		 $('#imageFile').click(); 
	 });
    $('#dropZone').on('dragover', function(e) {
        e.preventDefault();
        e.stopPropagation();
        $(this).addClass('dragover');
    });
    $('#dropZone').on('dragleave', function(e) {
        e.preventDefault();
        e.stopPropagation();
        $(this).removeClass('dragover');
    });
    $('#dropZone').on('drop', function(e) {
        e.preventDefault();
        e.stopPropagation();
        $(this).removeClass('dragover');
        const files = e.originalEvent.dataTransfer.files;
        if (files.length > 0) handleFile(files[0]);
    });
    $('#imageFile').change(function() {
        if (this.files && this.files[0]) handleFile(this.files[0]);
    });

    function handleFile(file) {
        if (file.size > 5 * 1024 * 1024) {
            alert('파일 크기는 5MB 이하여야 합니다.');
            return;
        }
        if (!file.type.match('image.*')) {
            alert('이미지 파일만 업로드 가능합니다.');
            return;
        }
        uploadedFile = file;
		
		//이미지를 드롭했다면 경로는 수정할 수 없게 막아주기
		$('#imagePath').prop('disabled', true);
		
        const reader = new FileReader();
        reader.onload = function(e) {
            $('#previewImg').attr('src', e.target.result);
            $('#imagePreview').fadeIn();
            $('#imagePath').val('(파일 업로드: ' + file.name + ')');
        }
        reader.readAsDataURL(file);
    }
	//이미지를 삭제하는 버튼
    $('#removeImageBtn').click(function() {
        uploadedFile = null;
        $('#imageFile').val('');
        $('#imagePath').val('');
		$('#imagePath').val('').prop('disabled', false);
        $('#imagePreview').fadeOut();
		isImage = false;
    });
	//이미지경로 블러처리
    $('#imagePath').on('blur', function() {
        const url = $(this).val();
        if (url && url.startsWith('http')) {
            $('#previewImg').attr('src', url);
            $('#imagePreview').fadeIn();
        }
    });

	
	
    // ******** ========== 폼 제출 ========== ******** //
    $('#productForm').submit(function(e) {
        e.preventDefault(); //일단 폼 제출을 막기
		
		//------- 유효성 검사 ------//
		//상품코드 중복검사
        if (!isDuplicateCheckCode) {
            alert('상품 코드 중복 확인을 해주세요.');
            return;
        }
		//상품명 중복검사
		if (!isDuplicateCheckName) {
            alert('상품명 중복 확인을 해주세요.');
            return;
        }
		
		//이미지 업로드 검사
		const imagePath = $('#imagePath').val();
		if(!isImageFileANDPath) {
			//만약 상품코드가 중복되지 않았다면 아래 유효성 검사 해주기
			if (!imagePath && !uploadedFile) {
	            alert('이미지를 업로드하거나 URL을 입력해주세요.');
	            return;
			}
        }
		
		//상품옵션을 추가했는지의 유효성 검사
		if ($('.matrix-row').length === 0) {
	        alert('옵션을 최소 하나 이상 추가해주세요.');
	        return;
	    }

		
		const optionCombinations = [];
		let hasError = false;  // ✅ 추가: 에러 플래그

		$('.option-stock').each(function() {
		    const storage = $(this).data('storage');
		    const color = $(this).data('color');
		    const stock = parseInt($(this).val());
		    
		    // ✅ 변경: priceInput 찾는 방식 개선
		    const priceInput = $(this).closest('.matrix-row').find('.option-additional-price');
		    const additionalPrice = parseInt(priceInput.val());
		    const isBase = priceInput.data('is-base');  // ✅ 추가: 기본가 여부 확인

		    if (!stock || stock < 0) {
		        alert(`${storage}-${color} 조합의 재고를 입력해주세요.`);
		        hasError = true; 
		        return false;
		    }
		    
		    // ✅ 변경: 에러 메시지 개선
		    if (isNaN(additionalPrice) || additionalPrice < 0) {
		        alert(`${storage}-${color} 조합의 ${isBase ? '기본가' : '추가금'}를 확인해주세요.`);
		        hasError = true;
		        return false;
		    }

		    optionCombinations.push({
		        storage: storage,
		        color: color,
		        stock: stock,
		        additionalPrice: isBase ? 0 : additionalPrice  // ✅ 변경: 256GB는 0으로 저장
		    });
		});
		if (hasError) return;  // ✅ 추가: 에러 시 중단
        

        // 상품 테이블 데이터
        const productData = {
            productCode: $('#productCode').val(),
            productName: $('#productName').val(),
            brand: $('#brand').val(),
            description: $('#description').val(),
            basePrice: parseInt($('#basePrice').val()),
            imagePath: imagePath,
            salesStatus: '판매중'
        };

        // 상품옵션 테이블 데이터
        const optionData = optionCombinations;

        // 전송할 전체 데이터
        const registrationData = {
            product: productData,
            options: optionData
        };

		
		console.log('=== 상품 등록 데이터 ===');
        console.log('상품 기본 정보:', productData);
        console.log('상품 옵션 조합:', optionData);
        console.log('전체 데이터:', registrationData);

		// ======= AJAX로 서버에 전송 =======
		if(isSendData){
			//상품코드가 중복됐을 때 ajax로 보내는 값들(옵션만 보내주기)
			console.log(productCode);
			
			$.ajax({
			    url: 'productRegisterEnd.hp', // 서버 API 주소
			    method: 'POST',
			    contentType: 'application/json',
			    data: {
					"optionData": JSON.stringify(optionData),
					"productCode": productCode
				},
			    success: function(json) {
			        console.log('서버 응답:', json);
			        // 성공 모달 표시
			        $('#successModal').modal('show');
			        
			        $('#successModal').on('hidden.bs.modal', function() {
			            // 폼 초기화
			            $('#productForm')[0].reset();
			            $('input[type="checkbox"]').prop('checked', false);
			            $('#duplicateCheckResult').hide();
			            $('#optionMatrixTable').html('<div class="matrix-empty"><i class="fas fa-info-circle"></i><p>저장용량과 색상을 선택하면 조합이 표시됩니다</p></div>');
			            $('#imagePreview').hide();
						
			            /*isDuplicateChecked = false;
			            isCodeAvailable = false;
			            uploadedFile = null;*/
						
						console.log(json.message);
			        });
			    },
				error:function(request, status, error){
					alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				}
			});
			
			
		} else {
			//새로운 상품코드일 경우 ajax로 보내는 값들
			$.ajax({
			    url: 'productRegisterEnd.hp', // 서버 API 주소
			    method: 'POST',
			    contentType: 'application/json',
			    data: JSON.stringify(registrationData),
			    success: function(json) {
			        console.log('서버 응답:', json);
			        // 성공 모달 표시
			        $('#successModal').modal('show');
			        
			        $('#successModal').on('hidden.bs.modal', function() {
			            // 폼 초기화
			            $('#productForm')[0].reset();
			            $('input[type="checkbox"]').prop('checked', false);
			            $('#duplicateCheckResult').hide();
			            $('#optionMatrixTable').html('<div class="matrix-empty"><i class="fas fa-info-circle"></i><p>저장용량과 색상을 선택하면 조합이 표시됩니다</p></div>');
			            $('#imagePreview').hide();
						
			            /*isDuplicateChecked = false;
			            isCodeAvailable = false;
			            uploadedFile = null;*/
						
						console.log(json.message);
			        });
			    },
				error:function(request, status, error){
					alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				}
			});
			
		}//end of if~else()-----
		
		
        
		
    });
	// ******** ========== 폼 제출 끝 ========== ******** //
	
	
	
    //=============== 초기화 ===============//
    $('button[type="reset"]').click(function() {
        $('input[type="checkbox"]').prop('checked', false);
        $('#duplicateCheckResult').hide();
        $('#optionMatrixTable').html('<div class="matrix-empty"><i class="fas fa-info-circle"></i><p>저장용량과 색상을 선택하면 조합이 표시됩니다</p></div>');
        $('#imagePreview').hide();
        isDuplicateCheckCode = false;
        isDuplicateCheckName = false;
        isCodeAvailable = false;
        uploadedFile = null;
    });
});