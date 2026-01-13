$(document).ready(function() {
    let uploadedFile = null;
    let isDuplicateCheckCode = false; //상품코드 중복체크
	let isDuplicateCheckName = false; //상품명 중복체크

    // 색상 클래스 매핑
    const colorClassMap = {
        '블랙': 'black',
        '화이트': 'white',
        '블루': 'blue',
        '레드': 'red',
        '그린': 'green',
        '골드': 'gold'
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
					
					//상품코드가 중복됐다면 입력항목에 해당 값을을 넣어주고 비활성화
					showDuplicateResult(isDuplicate, productName, price, brandName, productDESC);
				},
				error:function(request, status, error){
					alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				}
			});
            
            $('#checkDuplicateCodeBtn').prop('disabled', false).html('<i class="fas fa-check-circle mr-2"></i>중복 확인');
        }, 500);
    }
	// 상품코드 유효성검사 및 중복검사 이후 보여줄 메시지와 항목 자동 기입
    function showDuplicateResult(isDuplicate, productName, price, brandName, productDESC) {
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
		    $('#imagePath').prop('disabled', true); //이미지경로 URL 입력 비활성화
		    $('#removeImageBtn').prop('disabled', true); //제거 버튼 비활성화
		    //드롭존 전체 클릭/드래그 비활성화
			$('#dropZone').css({
		        'pointer-events': 'none',
		        'opacity': '0.4'
		    });
			
			isDuplicateCheckName = true; //상품명 중복체크를 참값으로 바꾸기
			
			
			//console.log("isDuplicateCheckName:", isDuplicateCheckName);
			
			// 2.2초 후 스크롤
		    setTimeout(function () {
		        $('html, body').animate({
		            scrollTop: $('#optionSection').offset().top - 100
		        }, 500);
		    }, 1900);
			
        } else {
			//중복되지 않은 상품코드일 경우
            resultDiv.html('<div class="duplicate-result available"><i class="fas fa-check-circle mr-2"></i>사용 가능한 상품 코드입니다.</div>');
			//새로운 상품코드이므로 비활성화 항목들 모두 활성화해주기
			enableImageUpload(); 
        }
        resultDiv.fadeIn();
    }

	
	//=================================================//
	
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
	    const codePattern = /^[A-Za-z0-9]+$/;
	    if (!codePattern.test(productName)) {
	        alert('상품명은 영문과 숫자만 입력이 가능합니다.');
			$('#productName').val("");
	        return;
	    }
	    checkDuplicateProductName();
	});

	function checkDuplicateProductName() {
	    $('#checkDuplicateNameBtn').prop('disabled', true).html('<i class="fas fa-spinner fa-spin mr-2"></i>확인 중...');
	    setTimeout(function() {
			$.ajax({
				url:"checkDuplicateProductName.hp",
				data:{
					"productName":$("input#productName").val().trim()
				},
				type: "post",
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
	   
	
	
    // 옵션 선택 시 매트릭스 업데이트
    $('input[name="storage"], input[name="color"]').change(function() {
        updateOptionMatrix();
    });

    function updateOptionMatrix() {
        const selectedStorages = $('input[name="storage"]:checked');
        const selectedColors = $('input[name="color"]:checked');
        const container = $('#optionMatrixTable');
        
        if (selectedStorages.length === 0 || selectedColors.length === 0) {
            container.html('<div class="matrix-empty"><i class="fas fa-info-circle"></i><p>저장용량과 색상을 선택하면 조합이 표시됩니다</p></div>');
            return;
        }

        container.empty();
        
        selectedStorages.each(function() {
            const storage = $(this).val();
            const additionalPrice = parseInt($(this).data('price'));
            
            selectedColors.each(function() {
                const color = $(this).val();
                const colorClass = colorClassMap[color] || 'black';
                
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
                                <input type="number" class="form-control option-stock" 
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
                                <input type="number" class="form-control option-additional-price" 
                                    data-storage="${storage}" 
                                    data-color="${color}" 
                                    placeholder="추가금" 
                                    value="${additionalPrice}"
                                    min="0" required>
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
    }

	
	
	
	// ======================== 이미지 처리 ======================== //
    // 드래그 앤 드롭
    $('#dropZone').click(function() { $('#imageFile').click(); });
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
        const reader = new FileReader();
        reader.onload = function(e) {
            $('#previewImg').attr('src', e.target.result);
            $('#imagePreview').fadeIn();
            $('#imagePath').val('(파일 업로드: ' + file.name + ')');
        }
        reader.readAsDataURL(file);
    }

    $('#removeImageBtn').click(function() {
        uploadedFile = null;
        $('#imageFile').val('');
        $('#imagePath').val('');
        $('#imagePreview').fadeOut();
    });

    $('#imagePath').on('blur', function() {
        const url = $(this).val();
        if (url && url.startsWith('http')) {
            $('#previewImg').attr('src', url);
            $('#imagePreview').fadeIn();
        }
    });

	
	
    // ========== 폼 제출 ========== //
    $('#productForm').submit(function(e) {
        e.preventDefault(); //일단 폼 제출을 막기
		
		
		//------- 유효성 검사 ------//
		//상품코드 중복검사
        if (!isDuplicateCheckCode) {
            alert('상품 코드 중복 확인을 해주세요.');
            return;
        }
		if (!isDuplicateCheckName) {
            alert('상품명 중복 확인을 해주세요.');
            return;
        }
		
		//이미지 업로드 검사
		const imagePath = $('#imagePath').val();
        if (!imagePath && !uploadedFile) {
            alert('이미지를 업로드하거나 URL을 입력해주세요.');
            return;
        }
		
		
        const selectedStorages = $('input[name="storage"]:checked');
        const selectedColors = $('input[name="color"]:checked');
        
        if (selectedStorages.length === 0) {
            alert('저장용량을 최소 하나 이상 선택해주세요.');
            return;
        }
        if (selectedColors.length === 0) {
            alert('색상을 최소 하나 이상 선택해주세요.');
            return;
        }

        // 옵션 조합 데이터 수집
        const optionCombinations = [];
        $('.option-stock').each(function() {
            const storage = $(this).data('storage');
            const color = $(this).data('color');
            const stock = parseInt($(this).val());
            const additionalPrice = parseInt($(this).siblings('.input-group').find('.option-additional-price').val());

            if (!stock || stock < 0) {
                alert(`${storage}-${color} 조합의 재고를 입력해주세요.`);
                return false;
            }
            if (additionalPrice < 0) {
                alert(`${storage}-${color} 조합의 추가금을 입력해주세요.`);
                return false;
            }

            optionCombinations.push({
                storage: storage,
                color: color,
                stock: stock,
                additionalPrice: additionalPrice
            });
        });

        

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
		
		

        // 성공 모달 표시
        $('#successModal').modal('show');

        $('#successModal').on('hidden.bs.modal', function() {
            $('#productForm')[0].reset();
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
	//=============== 폼 제출 끝 ===============//
	
	
	
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