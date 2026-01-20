<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%String ctxPath=request.getContextPath();%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0 shrink-to-fit=no">
    <title>대시보드 - PhoneStore 관리자</title>


    <!-- Bootstrap CSS -->
	<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css">

    <!-- Font Awesome 6 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.1/css/all.min.css">


	<!-- JS -->
	<script type="text/javascript" src="<%=ctxPath%>/js/jquery-3.7.1.min.js"></script>
	<script type="text/javascript" src="<%=ctxPath%>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js" ></script>

    <%-- jQueryUI CSS 및 JS --%>
	<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/jquery-ui-1.13.1.custom/jquery-ui.min.css" />
	<script type="text/javascript" src="<%=ctxPath%>/jquery-ui-1.13.1.custom/jquery-ui.min.js"></script>


	<!-- 사용자 CSS -->
	<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/product_TH/productRegister.css">
	<link href="<%=ctxPath%>/css/admin/admin.css" rel="stylesheet" />
	
	
	<!-- 사용자 JS -->
	<script type="text/javascript" src="<%=ctxPath%>/js/product_TH/productRegister.js"></script>
	<script src="<%=ctxPath%>/js/admin/admin_common.js"></script>

</head>
<body>
    <div class="wrapper">
        <jsp:include page="/WEB-INF/admin/admin_sidebar.jsp" />
        <div class="sidebar-overlay" id="sidebarOverlay"></div>
        
        <div class="main-content">
        
	        <div class="mobile-topbar d-lg-none">
	            <button type="button" class="btn btn-light btn-sm" id="btnSidebarToggle">
	              <i class="fas fa-bars"></i>
	            </button>
	            <span class="ml-2 font-weight-bold">관리자</span>
			</div>
          
            <%-- <jsp:include page="/WEB-INF/admin/admin_header.jsp" /> --%>

			<div class="registration-container">
			    <div class="page-header">
			        <h2><i class="fas fa-box-open mr-2"></i>상품 등록</h2>
			        <p>새로운 상품 정보를 입력해주세요</p>
			    </div>
			
			    <div class="form-container">
			        <form id="productForm" name="productForm" enctype="multipart/form-data">
			            <!-- 상품 기본 정보 -->
			            <h5 class="text-primary mb-4"><i class="fas fa-info-circle mr-2"></i>상품 기본 정보</h5>
			            
			            
			            <!-- 상품 코드 -->
			            <div class="form-section">
			                <div class="section-title">
			                    <i class="fas fa-barcode mr-2"></i>상품 코드 <span class="required-mark">*</span>
			                </div>
			                <div class="input-group input-group-lg">
			                    <input type="text" class="form-control" id="productCode" name="productCode" placeholder="상품 코드를 입력하세요 (예: 1000AP, 2000GX)" maxlength="10" required>
			                    <div class="input-group-append">
			                        <button class="btn btn-outline-primary" type="button" id="checkDuplicateCodeBtn">
			                            <i class="fas fa-check-circle mr-2"></i>중복 확인
			                        </button>
			                    </div>
			                </div>
			                <small class="form-text text-muted">숫자 4자리 + 대문자 영문 2자리로 입력하세요</small>
			                <div id="duplicateCheckResult" class="mt-2" style="display: none;"></div>
			            </div>
			
			
			            <!-- 브랜드 -->
			            <div class="form-section">
			                <div class="section-title">
			                    <i class="fas fa-tag mr-2"></i>브랜드 <span class="required-mark">*</span>
			                </div>
			                <select class="custom-select custom-select-lg" id="brand" name="brand" required>
			                    <option value="">브랜드를 선택하세요</option>
			                    <option value="Apple">애플 (Apple)</option>
			                    <option value="Samsung">삼성 (Samsung)</option>
			                </select>
			            </div>
			
			
			            <!-- 상품명 -->
			            <div class="form-section">
			                <div class="section-title">
			                    <i class="fas fa-mobile-alt mr-2"></i>상품명 <span class="required-mark">*</span>
			                </div>
			                <div class="input-group input-group-lg">
				                <input type="text" class="form-control form-control-lg" id="productName" name="productName" 
				                		   placeholder="상품명을 입력하세요 (예: iPhone 17 Pro Max)" required>
				                <div class="input-group-append">
				                    <button class="btn btn-outline-primary" type="button" id="checkDuplicateNameBtn">
				                        <i class="fas fa-check-circle mr-2"></i>중복 확인
				                    </button>
				                </div>
			                </div>
			                <small class="form-text text-muted">영문과 숫자로 정확하게 작성하세요</small>
			                <div id="duplicateCheckResult2" class="mt-2" style="display: none;"></div>
			            </div>
			
			
			            <!-- 기본 가격 -->
			            <div class="form-section">
			                <div class="section-title">
			                    <i class="fas fa-won-sign mr-2"></i>기본 가격 <span class="required-mark">*</span>
			                </div>
			                <div class="input-group input-group-lg">
			                    <input type="number" class="form-control" id="basePrice" name="basePrice" 
			                    		   placeholder="기본 가격을 입력하세요 (256GB 기준)" required min="0" step="100">
			                    <div class="input-group-append">
			                        <span class="input-group-text">원</span>
			                    </div>
			                </div>
			                <small class="form-text text-muted">숫자만 입력이 가능합니다. 256GB의 기본 판매 가격입니다</small>
			            </div>
			
			
			            <!-- 제품 설명 -->
			            <div class="form-section">
			                <div class="section-title">
			                    <i class="fas fa-file-alt mr-2"></i>제품 설명 <span class="required-mark">*</span>
			                </div>
			                <textarea class="form-control" id="description" name="description" rows="6" 
			                		  placeholder="제품의 상세 설명을 입력하세요" required></textarea>
			            </div>
			
			
			            
			            
			            
			            <div class="form-section image-upload-section" id="imageUploadSection">
				            <!-- 이미지 업로드 -->
							<div class="form-section">
							  <div class="section-title">
							    <i class="fas fa-image mr-2"></i>이미지 업로드 <span class="required-mark">*</span>
							  </div>
							
							  <!-- 대표 이미지 -->
							  <div class="mb-4">
							    <h6 class="mb-2 font-weight-bold">대표 이미지 (필수)</h6>
							
							    <div class="drop-zone" id="dropZoneMain">
							      <i class="fas fa-cloud-upload-alt"></i>
							      <p>대표 이미지를 드래그하여 놓거나 클릭하여 선택하세요</p>
							      <small>JPG, PNG, GIF 파일 지원 (최대 5MB)</small>
							    </div>
							
							    <input type="file" id="imageFileMain" name="mainImageFile" accept="image/*" style="display:none;">
							
							    <div class="form-group mt-2">
							      <label>또는 이미지 URL 입력</label>
							      <input type="text" class="form-control form-control-lg" id="imagePathMain" name="mainImagePath" placeholder="https://example.com/main.jpg">
							    </div>
							
							    <div class="image-preview" id="imagePreviewMain" style="display:none;">
							      <p class="mb-2"><strong>미리보기:</strong></p>
							      <img id="previewImgMain" src="" alt="대표 이미지 미리보기">
							      <div class="image-preview-actions">
							        <button type="button" class="btn-remove-image" id="removeImageBtnMain">
							          <i class="fas fa-trash mr-2"></i>이미지 제거
							        </button>
							      </div>
							    </div>
							  </div>
							
							  <!-- 추가 이미지 가로 배치 영역 -->
							  <div class="image-slot-sub-wrapper">
								  <!-- 추가 이미지 1 -->
								  <div class="image-slot image-slot-sub">
								    <h6 class="mb-2 font-weight-bold">추가 이미지 1 (필수)</h6>
								
								    <div class="drop-zone" id="dropZoneSub1">
								      <i class="fas fa-cloud-upload-alt"></i>
								      <p>추가 이미지를 드래그하여 놓거나 클릭하여 선택하세요</p>
								      <small>JPG, PNG, GIF 파일 지원 (최대 5MB)</small>
								    </div>
								
								    <input type="file" id="imageFileSub1" name="subImageFile1" accept="image/*" style="display:none;">
								
								    <div class="form-group mt-2">
								      <label>또는 이미지 URL 입력</label>
								      <input type="text" class="form-control form-control-lg" id="imagePathSub1" name="subImagePath1" placeholder="https://example.com/sub1.jpg">
								    </div>
								  </div>
								
								  <!-- 추가 이미지 2 -->
								  <div class="image-slot image-slot-sub">
								    <h6 class="mb-2 font-weight-bold">추가 이미지 2 (필수)</h6>
								
								    <div class="drop-zone" id="dropZoneSub2">
								      <i class="fas fa-cloud-upload-alt"></i>
								      <p>추가 이미지를 드래그하여 놓거나 클릭하여 선택하세요</p>
								      <small>JPG, PNG, GIF 파일 지원 (최대 5MB)</small>
								    </div>
								
								    <input type="file" id="imageFileSub2" name="subImageFile2" accept="image/*" style="display:none;">
								
								    <div class="form-group mt-2">
								      <label>또는 이미지 URL 입력</label>
								      <input type="text" class="form-control form-control-lg" id="imagePathSub2" name="subImagePath2" placeholder="https://example.com/sub2.jpg">
								    </div>
								  </div>
								
							  </div>
							
							  <!-- 공통 미리보기 (추가 이미지용) -->
							  <div class="image-preview mt-3"
								     id="imagePreviewSub"
								     style="display:none;">
								  <p class="mb-2"><strong>미리보기:</strong></p>
								  <img id="previewImgSub" src="" alt="추가 이미지 미리보기">
								
								  <div class="image-preview-actions">
								    <button type="button" class="btn-remove-image" id="removeImageBtnSub">
								      <i class="fas fa-trash mr-2"></i>이미지 제거
								    </button>
								  </div>
							  </div>
							  
							</div>
			            </div>
			            
			
			
			            <!-- 옵션 선택 -->
			            <h5 class="text-primary mb-4 mt-5" id="optionSection">
			            	<i class="fas fa-sliders-h mr-2"></i>옵션 설정
			            </h5>
			
			
			            <!-- 저장용량 선택 -->
			            <div class="form-section">
			                <div class="section-title">
			                    <i class="fas fa-hdd mr-2"></i>저장용량 선택 <span class="required-mark">*</span>
			                </div>
			                <div class="toggle-group">
			                    <div class="toggle-item">
			                        <input type="checkbox" id="storage256" name="storage" value="256GB" data-price="0">
			                        <label class="toggle-label" for="storage256">256GB<br><small>(기본가)</small></label>
			                    </div>
			                    <div class="toggle-item">
			                        <input type="checkbox" id="storage512" name="storage" value="512GB" data-price="300000">
			                        <label class="toggle-label" for="storage512">512GB<br><small>(추가금 기입)</small></label>
			                    </div>
			                    <div class="toggle-item">
			                        <input type="checkbox" id="storage1TB" name="storage" value="1TB" data-price="600000">
			                        <label class="toggle-label" for="storage1TB">1TB<br><small>(추가금 기입)</small></label>
			                    </div>
			                </div>
			                <small class="form-text text-muted">판매할 저장용량을 선택하세요</small>
			            </div>
			
			
			            <!-- 색상 선택 -->
			            <div class="form-section">
			                <div class="section-title">
			                    <i class="fas fa-palette mr-2"></i>색상 선택 <span class="required-mark">*</span>
			                </div>
			                <div class="toggle-group">
			                    <div class="toggle-item">
			                        <input type="checkbox" id="colorBlack" name="color" value="Black">
			                        <label class="toggle-label" for="colorBlack">
			                            <span class="color-indicator Black"></span>블랙
			                        </label>
			                    </div>
			                    <div class="toggle-item">
			                        <input type="checkbox" id="colorWhite" name="color" value="White">
			                        <label class="toggle-label" for="colorWhite">
			                            <span class="color-indicator White"></span>화이트
			                        </label>
			                    </div>
			                    <div class="toggle-item">
			                        <input type="checkbox" id="colorBlue" name="color" value="Blue">
			                        <label class="toggle-label" for="colorBlue">
			                            <span class="color-indicator Blue"></span>블루
			                        </label>
			                    </div>
			                    <div class="toggle-item">
			                        <input type="checkbox" id="colorRed" name="color" value="Red">
			                        <label class="toggle-label" for="colorRed">
			                            <span class="color-indicator Red"></span>레드
			                        </label>
			                    </div>
			                </div>
			                <small class="form-text text-muted">판매할 색상을 선택하세요</small>
			            </div>
			
			
			            <!-- 옵션 조합 매트릭스 -->
			            <div class="form-section">
			                <div class="section-title">
			                    <i class="fas fa-table mr-2"></i>옵션별 재고 및 추가금 설정 <span class="required-mark">*</span>
			                    <small class="form-text text-muted">이미 존재하는 옵션일 경우 재고량만 증가합니다.</small>
			                </div>
			                
			                <div class="d-flex justify-content-center mt-3">
							    <button type="button" id="addOptionMatrix" class="option-add-btn">
							        <i class="fas fa-plus"></i>
							        옵션 추가
							    </button>
							</div>
						    <small class="form-text text-muted text-center" style="margin-top: 10px;">새로운 상품일 경우 기본금을 입력해야 옵션 추가가 가능합니다.</small>
					        
							
			                <div class="option-matrix">
			                    <div class="matrix-header">
			                        <h6 class="mb-0"><i class="fas fa-th mr-2"></i>저장용량 × 색상 조합</h6>
			                    </div>
			                    <div id="optionMatrixTable">
			                        <div class="matrix-empty">
			                            <i class="fas fa-info-circle"></i>
			                            <p>저장용량과 색상을 선택하면 조합이 표시됩니다</p>
			                        </div>
			                    </div>
			                </div>
			            </div>
			
			
			            <!-- 버튼 -->
			            <div class="text-center mt-5">
			                <button type="reset" class="btn btn-secondary btn-reset mr-3">
			                    <i class="fas fa-redo mr-2"></i>초기화
			                </button>
			                <button type="submit" class="btn btn-primary btn-submit">
			                    <i class="fas fa-check mr-2"></i>상품 등록
			                </button>
			            </div>
			        </form>
			    </div>
			</div>
			
			
			<!-- 등록 완료 모달 -->
			<div class="modal fade" id="successModal" tabindex="-1">
			    <div class="modal-dialog modal-dialog-centered">
			        <div class="modal-content">
			            <div class="modal-body text-center py-5">
			                <i class="fas fa-check-circle fa-4x text-success mb-3"></i>
			                <h4>상품 등록 완료!</h4>
			                <p class="text-muted mb-0">상품이 성공적으로 등록되었습니다.</p>
			            </div>
			            <div class="modal-footer justify-content-center">
			                <button type="button" class="btn btn-primary" data-dismiss="modal">확인</button>
			            </div>
			        </div>
			    </div>
			</div>
		</div>
	</div>


</body>
</html>