$(document).ready(function() {
    let isDuplicateCheckCode = false; //상품코드 중복체크
    let isDuplicateCheckName = false; //상품명 중복체크
    let uploadedFile = null;		  //이미지 경로
    let isImageFileANDPath = false;	  //이미지파일, 이미지경로 올렸는지 검사
    let isSendData = false;			  //중복된 상품코드와 새로운 상품코드를 구분하는 값
    let productCode = ""; //상품코드
	
	let isDefaultOptionCreated = false; //기본금 입력에 따른 기본옵션
	
    const colorClassMap = { '블랙': 'Black', '화이트': 'White', '블루': 'Blue', '레드': 'Red' };

    // 초기 비활성화
    disableTag();

	// 초기 상태 => 옵션 추가에 대한 버튼을 비활성화 해두기
	$('#addOptionMatrix').prop('disabled', true);

	// 기본금 입력 완료 시 1회만
	$('#basePrice').on('blur', function () {
	    const basePrice = Number($(this).val());

	    if (basePrice > 0) {
	        $('#addOptionMatrix').prop('disabled', false);
	        addDefault256OptionIfNeeded();
	    }
	});
	
	// 기본금 입력 감지
	$('#basePrice').on('input', function () {
		const basePrice = Number($(this).val());
	    $('#addOptionMatrix').prop('disabled', basePrice <= 0);
	});
	
	
	//비활성화 함수
    function disableTag() {
        $('#brand').val("").prop('disabled', true);
        $('#productName').val("").prop('readonly', true);
        $('#checkDuplicateNameBtn').prop('disabled', true);
        $('#basePrice').val("").prop('readonly', true);
        $("#description").val("").prop('readonly', true);
        $('#imageFile').prop('disabled', true);
        $('#imagePath').prop('disabled', true);
        $('#removeImageBtn').prop('disabled', true);
        $('#dropZone').css({ 'pointer-events': 'none', 'opacity': '0.4' });
    }
	
	//활성화 함수
    function enableTag() {
        $('#brand').val("").prop('disabled', false);
        $('#productName').val("").prop('readonly', false);
        $('#checkDuplicateNameBtn').prop('disabled', false);
        $('#basePrice').val("").prop('readonly', false);
        $("#description").val("").prop('readonly', false);
        $('#imageFile').prop('disabled', false);
        $('#imagePath').prop('disabled', false);
        $('#removeImageBtn').prop('disabled', false);
        $('#dropZone').css({ 'pointer-events': 'auto', 'opacity': '1' });
    }

	//상품코드 입력 시 비활성화 항목들 활성화해주기
    $('#productCode').on('input', function() {
        isDuplicateCheckCode = false; //상품코드 중복체크 거짓
        isDuplicateCheckName = false; //상품명 중복체크 거짓
		isDefaultOptionCreated = false;
    });

	//===상품코드 중복확인 버튼 클릭 이벤트===//
    $('#checkDuplicateCodeBtn').click(function() {
        //중복코드 누르면 활성화 실행
		enableTag();
		
        const code = $('#productCode').val().trim();
        if (!code) {
			alert('상품 코드를 입력해주세요.'); 
			return;
		}
        const codePattern = /^\d{4}[A-Z]{2}$/;
        if (!codePattern.test(code)) {
            alert('상품 코드는 숫자 4자리+대문자 영문 2자리여야 합니다.');
            $("#productCode").val("");
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
				type: "post",
				data:{
					"productCode":$("input#productCode").val()
				},
				dataType:"json",
				success:function(json){
					const isDuplicate = json.isProductCode;
					const productName = json.productName;
					const brandName = json.brandName;
					const price = json.price
					const productDESC = json.productDESC;
					const imagePath = json.imagePath;
					productCode = json.productCode; 
					
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

	//상품코드 유효성검사 및 중복검사 이후 보여줄 메시지와 항목 자동 기입
    function showDuplicateResult(isDuplicate, productName, price, brandName, productDESC, imagePath) {
        const resultDiv = $('#duplicateCheckResult');
        isDuplicateCheckCode = true;
        
        if (isDuplicate) {
			//중복된 상품코드일 경우
            resultDiv.html('<div class="duplicate-result unavailable"><i class="fas fa-times-circle mr-2"></i>사용 중인 상품명입니다. 옵션 등록으로 넘어가겠습니다.</div>');
            $('#brand').val(brandName).prop('disabled', true);
            $('#productName').val(productName).prop('readonly', true);
            $('#checkDuplicateNameBtn').prop('disabled', true);
            $('#basePrice').val(price).prop('readonly', true);
            $("#description").val(productDESC).prop('readonly', true);
            $('#imageFile').prop('disabled', true);
            $('#imagePath').val(imagePath).prop('disabled', true);
            $('#removeImageBtn').prop('disabled', true);
            $('#dropZone').css({ 'pointer-events': 'none', 'opacity': '0.4' });
            
			isDuplicateCheckName = true; //상품명 중복체크 참값
            isImageFileANDPath = true;	 //이미지등록,경로 참값
            isSendData = true; //중복됐을 때의 ajax 보내기 구분
			
			$('#addOptionMatrix').prop('disabled', false);
		    addDefault256OptionIfNeeded();
            
            setTimeout(function() {
                $('html, body').animate({ scrollTop: $('#optionSection').offset().top - 100 }, 500);
            }, 1900);
			
        } else {
			//중복되지 않은 상품코드일 경우
            resultDiv.html('<div class="duplicate-result available"><i class="fas fa-check-circle mr-2"></i>사용 가능한 상품 코드입니다.</div>');
            isDuplicateCheckName = false;
            isImageFileANDPath = false;
            isSendData = false;
			
			//새로운 상품코드이므로 비활성화 항목들 모두 활성화해주기
            enableTag();
        }
        resultDiv.fadeIn();
    }

	
//=========================상품명 중복체크 및 유효성 검사========================//
	//상품명 입력 시 중복체크 초기화
    $('#productName').on('input', function() {
        isDuplicateCheckName = false;
        $('#duplicateCheckResult2').hide();
    });
	
	//상품명 중복체크 버튼 클릭 이벤트
    $('#checkDuplicateNameBtn').click(function() {
        const name = $('#productName').val().trim();
        if (!name) {
			alert('상품명을 입력해주세요.');
			return; 
		}
        const codePattern = /^[A-Za-z0-9 ]+$/;
        if (!codePattern.test(name)) {
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
	
	//상품명 유효성검사 및 중복검사 이후 보여줄 메시지와 항목 자동 기입
    function showDuplicateResult2(isDuplicate) {
        const resultDiv = $('#duplicateCheckResult2');
        isDuplicateCheckName = true;
        if (isDuplicate) {
			//상품명이 중복됐을 경우
            resultDiv.html('<div class="duplicate-result unavailable"><i class="fas fa-times-circle mr-2"></i>이미 사용 중인 상품명입니다.</div>');
            $('#productName').val("");
			
        } else {
			//상품명이 새로운 이름일 경우
            resultDiv.html('<div class="duplicate-result available"><i class="fas fa-check-circle mr-2"></i>사용 가능한 상품명입니다.</div>');
        }
        resultDiv.fadeIn();
    }

	
	//기본금액 유효성 검사
    $('#basePrice').on('input', function() {
        let value = $(this).val();
        value = value.replace(/[^0-9]/g, '');
        $(this).val(value);
    });

	
	
//========================== 옵션 매트릭스 ==========================//
	function addDefault256OptionIfNeeded() {
		if (isDefaultOptionCreated) return;
		
	    // 중복 상품이면 자동 생성 ❌
	    if (isSendData === true) return;
	
	    const basePrice = parseInt($('#basePrice').val());
	    if (!basePrice || basePrice <= 0) return;
	
	    // 이미 256GB 옵션이 있으면 종료
	    /*const exists = $('.matrix-row[data-storage="256GB"]').length > 0;
	    if (exists) return;*/
	
	    // 256GB + 기본 색상(임시)
	    const defaultColor = $('input[name="color"]:first').val() || '기본';
	
	    const row = $(`
	        <div class="matrix-row" data-storage="256GB" data-color="${defaultColor}" data-default="true">
	            <div class="matrix-cell storage">
	                <i class="fas fa-hdd mr-2"></i>256GB
	            </div>
	            <div class="matrix-cell color">
	                <i class="fas fa-palette mr-2"></i>${defaultColor}
	            </div>
	            <div class="matrix-input">
	                <input type="number" class="form-control option-stock"
	                    data-storage="256GB" data-color="${defaultColor}"
	                    placeholder="재고" min="0" required>
	            </div>
	            <div class="matrix-input">
	                <input type="number" class="form-control option-additional-price"
	                    data-is-base="true" value="${basePrice}"
	                    readonly style="background:#e9ecef;">
	            </div>
	            <div class="matrix-delete">
	                <button type="button" class="btn btn-secondary btn-sm" disabled>
	                    기본옵션
	                </button>
	            </div>
	        </div>
	    `);
	
	    $('#optionMatrixTable .matrix-empty').remove();
	    $('#optionMatrixTable').append(row);
		
		isDefaultOptionCreated = true; 
	}



	//중복 옵션 확인 함수
    function isDuplicateOption(storage, color) {
        let isDuplicate = false;
        $('.matrix-row').each(function() {
            const rowStorage = $(this).find('.option-stock').data('storage');
            const rowColor = $(this).find('.option-stock').data('color');
            if (rowStorage === storage && rowColor === color) {
                isDuplicate = true;
                return false;
            }
        });
        return isDuplicate;
    }

	//옵션추가 버튼을 클릭시 나오는 이벤트
    $('#addOptionMatrix').on('click', function() {
        const hasOption = updateOptionMatrix();
        if (hasOption === false) {
            alert('저장용량과 색상을 선택해주세요.');
            return;
        }
        $('input[name="storage"]').prop('checked', false);
        $('input[name="color"]').prop('checked', false);
    });
	
	//옵션 매트릭스 업데이트 함수
    function updateOptionMatrix() {
        const selectedStorages = $('input[name="storage"]:checked');
        const selectedColors = $('input[name="color"]:checked');
        const container = $('#optionMatrixTable');
        const basePrice = parseInt($('#basePrice').val()) || 0;

		// 256GB는 수동 추가 못 하게
		/*if ($('input[name="storage"][value="256GB"]').is(':checked')) {
		    alert('256GB는 기본 옵션으로 자동 추가됩니다.');
		    return false;
		}*/
		
		//선택하지 않았을 경우
        if (selectedStorages.length === 0 || selectedColors.length === 0) {
            return false;
        }

        let duplicateCount = 0;
        let addedCount = 0;

        selectedStorages.each(function() {
            const storage = $(this).val();
            const additionalPrice = parseInt($(this).data('price')) || 0;
            const is256GB = storage === '256GB';

            selectedColors.each(function() {
                const color = $(this).val();
                const colorClass = colorClassMap[color] || 'white';

				//중복방지
                if (isDuplicateOption(storage, color)) {
                    duplicateCount++;
                    return;
                }
				
				// 256GB → 기본가 / 나머지 → 추가금
                const priceValue = is256GB ? basePrice : additionalPrice;
                const priceLabel = is256GB ? '기본가' : '추가금';
                const priceReadonly = is256GB ? 'readonly style="background:#e9ecef; cursor:not-allowed;"' : '';

                const row = $(`
                    <div class="matrix-row" data-storage="${storage}" data-color="${color}">
                        <div class="matrix-cell storage">
                            <i class="fas fa-hdd mr-2"></i>${storage}
                        </div>
                        <div class="matrix-cell color">
                            <i class="fas fa-palette mr-2"></i>${color}
                        </div>
                        <div class="matrix-input">
                            <div class="input-group">
                                <input type="number" class="form-control option-stock" 
                                    data-storage="${storage}" data-color="${color}" 
                                    placeholder="재고" min="0" required>
                                <div class="input-group-append">
                                    <span class="input-group-text">개</span>
                                </div>
                            </div>
                        </div>
                        <div class="matrix-input">
                            <div class="input-group">
                                <div class="input-group-prepend">
                                    <span class="input-group-text" 
                                        style="background:${is256GB ? '#667eea' : '#6c757d'}; color:white; border:none;">
                                        ${priceLabel}
                                    </span>
                                </div>
                                <input type="number" class="form-control option-additional-price" 
                                    data-storage="${storage}" data-color="${color}" 
                                    data-is-base="${is256GB}" value="${priceValue}" 
                                    min="0" step="1000" required ${priceReadonly}>
                                <div class="input-group-append">
                                    <span class="input-group-text">원</span>
                                </div>
                            </div>
                        </div>
                        <div class="matrix-delete">
                            <button type="button" class="btn btn-danger btn-sm delete-option-btn" 
                                data-storage="${storage}" data-color="${color}">
                                <i class="fas fa-trash-alt"></i>
                            </button>
                        </div>
                    </div>
                `);
                container.append(row);
                addedCount++;
            });
        });

		//이미 있는 매트릭스일 경우 건너뛰기
        if (duplicateCount > 0) {
            alert(`이미 추가한 옵션입니다.`);
        }
		//추가 완료 메시지
        if (addedCount > 0) {
			//빈 상태 메시지 제거
            container.find('.matrix-empty').remove();
        }
        return true;
    }

	//옵션 삭제 기능
    $(document).on('click', '.delete-option-btn', function() {
		const row = $(this).closest('.matrix-row');
		
		if (row.data('default') === true) {
		        alert('기본 옵션(256GB)은 삭제할 수 없습니다.');
		        return;
	    }
        
        if (confirm('해당 옵션을 삭제하시겠습니까?')) {
			row.fadeOut(300, function() {
	            $(this).remove();
				if ($('.matrix-row').length === 0) {
                    $('#optionMatrixTable').html('<div class="matrix-empty"><i class="fas fa-info-circle"></i><p>저장용량과 색상을 선택 후 \'옵션 조합 추가\' 버튼을 클릭하세요</p></div>');
                }
	        });
        }
    });

	//기본 가격 변경 시 매트릭스 업데이트
    $('#basePrice').on('input', function() {
        updateBasePriceInMatrix();
    });

	//기본금 업데이트 함수
    function updateBasePriceInMatrix() {
        const basePrice = parseInt($('#basePrice').val()) || 0;
        $('.option-additional-price[data-is-base="true"]').each(function() {
            $(this).val(basePrice);
        });
    }

//================== 이미지 처리 ==================//	
	//드래그 앤 드롭
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
            $('#imagePath').val(file.name);
        }
        reader.readAsDataURL(file);
    }

	//이미지를 삭제하는 버튼
    $('#removeImageBtn').click(function() {
        uploadedFile = null;
        $('#imageFile').val('');
        $('#imagePath').val('').prop('disabled', false);
        $('#imagePreview').fadeOut();
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
        e.preventDefault();
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
        if (!isImageFileANDPath) {
            if (!imagePath && !uploadedFile) {
                alert('이미지를 업로드하거나 URL을 입력해주세요.');
                return;
            }
        }
		//상품옵션을 추가했는지 검사
        if ($('.matrix-row').length === 0) {
            alert('옵션을 최소 하나 이상 추가해주세요.');
            return;
        }

        const optionCombinations = [];
        let hasError = false;

        $('.option-stock').each(function() {
            const storage = $(this).data('storage');
            const color = $(this).data('color');
            const stock = parseInt($(this).val());
            const priceInput = $(this).closest('.matrix-row').find('.option-additional-price');
            const additionalPrice = parseInt(priceInput.val());
            const isBase = priceInput.data('is-base');

            if (!stock || stock < 0) {
                alert(`${storage}-${color} 조합의 재고를 입력해주세요.`);
                hasError = true;
                return false;
            }
            if (isNaN(additionalPrice) || additionalPrice < 0) {
                alert(`${storage}-${color} 조합의 ${isBase ? '기본가' : '추가금'}를 확인해주세요.`);
                hasError = true;
                return false;
            }

            optionCombinations.push({
                storage: storage,
                color: color,
                stock: stock,
                additionalPrice: isBase ? 0 : additionalPrice //256GB는 0으로 저장
            });
        });

        if (hasError) return;

		//상품 테이블 데이터
        const productData = {
            productCode: $('#productCode').val(),
            productName: $('#productName').val(),
            brand: $('#brand').val(),
            description: $('#description').val(),
            basePrice: parseInt($('#basePrice').val()),
            imagePath: imagePath,
            salesStatus: '판매중'
        };
		
		//상품옵션 테이블 데이터
        const optionData = optionCombinations;
		
		//전송할 전체 데이터
        const registrationData = {
            product: productData,
            options: optionCombinations
        };

		
		const formData = new FormData();
		
		//이미지 파일
		const imageFile = $('#imageFile')[0].files[0];
		if (imageFile) {
		    formData.append('image', imageFile);
		}
		//JSON 데이터 (문자열로)
		formData.append(
		    'registrationData',
		    new Blob(
		        [JSON.stringify(registrationData)],
		        { type: 'application/json' }
		    )
		);
		
		
        console.log('=== 상품 등록 데이터 ===');
        console.log('전체 데이터:', registrationData);

	// ================== AJAX로 서버에 전송 ================== //
		if(isSendData){
			//상품코드가 중복됐을 때 ajax로 보내는 값들(옵션만 보내주기)
			console.log('=== 상품 등록 데이터 ===');
		    console.log('전체 데이터:', registrationData);
			
			$.ajax({
			    url: 'productRegisterEnd.hp', // 서버 API 주소
			    method: 'POST',
			    //contentType: 'application/json',
				dataType:"json",
				traditional: true,
				processData:false,  // 파일 전송시 설정 
				contentType:false,  // 파일 전송시 설정
			    data: JSON.stringify({
					"optionData": optionData,
					"productCode": productCode
				}),
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
						console.log(json.message);
			        });
			    },
				error:function(request, status, error){
					alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				}
			});
			
		} else {
			//새로운 상품코드일 경우 ajax로 보내는 값들
			console.log('=== 상품 등록 데이터 ===');
		    console.log('전체 데이터:', registrationData);
			
			$.ajax({
			    url: 'productRegisterNewPCodeEnd.hp', // 서버 API 주소
			    method: 'POST',
			    //contentType: 'application/json', //기존코드
			    //data: JSON.stringify(registrationData), //기존코드
			    data: formData,
				processData:false,  // 파일 전송시 설정 
				contentType:false,  // 파일 전송시 설정
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
						
						console.log(json.message);
			        });
			    },
				error:function(request, status, error){
					alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				}
			});
		}//end of if~else()-----

    });
// ******** ========== 폼 제출 ========== ******** //
	
	
//===========리셋 버튼===========//
    $('button[type="reset"]').click(function() {
        $('input[type="checkbox"]').prop('checked', false);
        $('#duplicateCheckResult').hide();
        $('#duplicateCheckResult2').hide();
        $('#optionMatrixTable').html('<div class="matrix-empty"><i class="fas fa-info-circle"></i><p>저장용량과 색상을 선택 후 \'옵션 조합 추가\' 버튼을 클릭하세요</p></div>');
        $('#imagePreview').hide();
        isDuplicateCheckCode = false;
        isDuplicateCheckName = false;
        uploadedFile = null;
		isDefaultOptionCreated = false;
        disableTag();
    });
});