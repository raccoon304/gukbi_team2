$(document).ready(function() {
    let uploadedFile = null;
    let isDuplicateCheckCode = false; //상품코드 중복체크
	let isDuplicateCheckName = false; //상품명 중복체크
    let isCodeAvailable = false; //상품코드 유효성검사
    let isNameAvailable = false; //상품명 유효성검사
    //const existingProductCodes = ['Ap001', 'Ap002', 'Ga001', 'Ga002', 'Ap003'];

    // 색상 클래스 매핑
    const colorClassMap = {
        '블랙': 'black',
        '화이트': 'white',
        '블루': 'blue',
        '레드': 'red',
        '그린': 'green',
        '골드': 'gold'
    };

	
	
    // 상품 코드 입력 시 중복 체크 초기화
    $('#productCode').on('input', function(e) {
        isDuplicateCheckCode = false;
        isCodeAvailable = false;
        $('#duplicateCheckResult').hide();
    });

    // 형식 및 중복 체크
    $('#checkDuplicateCodeBtn').click(function() {
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
					showDuplicateResult(isDuplicate);
				},
				error:function(request, status, error){
					alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				}
			});
            
            $('#checkDuplicateCodeBtn').prop('disabled', false).html('<i class="fas fa-check-circle mr-2"></i>중복 확인');
        }, 500);
    }

    function showDuplicateResult(isDuplicate) {
        const resultDiv = $('#duplicateCheckResult');
		
        if (isDuplicate) {
            isCodeAvailable = false;
            resultDiv.html('<div class="duplicate-result unavailable"><i class="fas fa-times-circle mr-2"></i>이미 사용 중인 상품 코드입니다.</div>');
			$("input#productCode").val("");
        } else {
            isCodeAvailable = true;
            resultDiv.html('<div class="duplicate-result available"><i class="fas fa-check-circle mr-2"></i>사용 가능한 상품 코드입니다.</div>');
        }
        resultDiv.fadeIn();
    }

	
	//=================================================//
	
	// 상품명 입력 시 중복 체크 초기화
	$('#productName').on('input', function(e) {
	    isDuplicateCheckName = false;
	    isNameAvailable = false;
		//$(e.target).parent().find("span.error").hide();
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
		
	    if (isDuplicate) {
	        isCodeAvailable = false;
	        resultDiv.html('<div class="duplicate-result unavailable"><i class="fas fa-times-circle mr-2"></i>이미 사용 중인 상품명입니다.</div>');
			$('#productName').val("");
	    } else {
	        isCodeAvailable = true;
	        resultDiv.html('<div class="duplicate-result available"><i class="fas fa-check-circle mr-2"></i>사용 가능한 상품명입니다.</div>');
	    }
	    resultDiv.fadeIn();
	}
	//=================================================//
	
	
	
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
        e.preventDefault();

        if (!isDuplicateCheckCode) {
            alert('상품 코드 중복 확인을 해주세요.');
            return;
        }
        if (!isCodeAvailable) {
            alert('사용 가능한 상품 코드를 입력해주세요.');
            return;
        }

		if (!isDuplicateCheckName) {
            alert('상품명 중복 확인을 해주세요.');
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

        const imagePath = $('#imagePath').val();
        if (!imagePath && !uploadedFile) {
            alert('이미지를 업로드하거나 URL을 입력해주세요.');
            return;
        }

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