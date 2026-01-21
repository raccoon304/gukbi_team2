<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% String ctxPath = request.getContextPath(); %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<link rel="stylesheet" href="<%= ctxPath %>/bootstrap-4.6.2-dist/css/bootstrap.min.css">
<link rel="stylesheet" href="<%= ctxPath %>/css/pay_MS/payMent.css">

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>배송방법 선택</title>

<style>
  /* 총 상품금액 헤더 스타일 */
  .info-row.header-fixed {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 12px 0;
    border-bottom: 1px solid #e0e0e0;
    margin-bottom: 20px;
  }

  .info-row.header-fixed .info-label {
    margin: 0;
  }

  .info-row.header-fixed .info-text {
    margin-left: auto;
    font-size: 12px;
    color: #999;
  }

  /* 변경 버튼 작게 + 오른쪽 정렬 */
  .btn-change-phone {
    padding: 4px 12px;
    font-size: 12px;
    margin-left: 8px;
  }

  /* 정보 변경 및 배송지 추가 버튼 너비 조정 */
  .btn-address-change {
    width: 100% !important;
  }

  /* two-col 레이아웃 개선 */
  .info-row.two-col {
    display: flex;
    gap: 16px;
  }

  .info-row.two-col .half {
    flex: 1;
    display: flex;
    align-items: center;
    gap: 8px;
  }

  .info-row.two-col .half .info-label {
    white-space: nowrap;
  }

  .info-row.two-col .half .info-value {
    flex: 1;
  }

  /* 우편번호와 버튼을 감싸는 레이아웃 */
  .zipcode-and-button-row {
    display: flex;
    gap: 16px;
    margin-top: 12px;
  }

/* 쿠폰 사용 버튼 */
#applyCouponBtn {
  background: #f2eaff;          /* 연한 보라 배경 */
  color: #6f3cff;               /* 포인트 보라 */
  border: 1px solid #d6c6ff;
  border-radius: 8px;
  padding: 10px 14px;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s ease;
}

/* hover 효과 */
#applyCouponBtn:hover {
  background: #6f3cff;
  color: #fff;
}

/* 쿠폰 금액 강조 */
#discountAmount {
  color: #ff4d4f;           
  font-weight: 700;
}

  .addr-card { border: 4px solid #e9ecef; border-radius: .5rem; }
  .addr-card.default { border-color: #007bff; }
  .addr-badge { font-size: 12px; }
  .addr-actions .btn { padding: .25rem .5rem; }
  
  
</style>

</head>

<body>
<jsp:include page="/WEB-INF/header.jsp" />

<form action="<%= ctxPath %>/payment/paymentSuccess.hp"
      method="post"
      id="payForm">

<div class="container payment-container">

  <!-- ================= 상단 : 받는분 정보 ================= -->
  <div class="payment-top-flex">

    <div class="recipient-info">

      <!-- 헤더: 총 상품금액과 결제 페이지 텍스트를 flex로 배치 -->
      <div class="info-row header-fixed">
        <span class="info-label">총 상품금액</span>
        <span class="info-text">결제 페이지 입니다.</span>
      </div>

      <div class="info-row two-col">
        <span class="info-label">받는분 이름</span>
        <input type="text" class="form-control info-input" id="recipientName" value="${loginUser.name}">
        <span class="info-label phone-label">전화번호</span>
        <input type="text" class="form-control info-input" id="recipientPhone" value="${loginUser.mobile}">
      </div>

      <div class="info-row address-row">
        <span class="info-label">주소</span>
        <input type="text"
               id="address"
               class="form-control"
               value="${address}"
               placeholder="주소 검색을 눌러주세요"
               readonly>
        <button type="button"
                class="btn btn-outline-secondary"
                id="addressSearchBtn">
          검색
        </button>
      </div>

      <div class="info-row detail-address-row">
        <span class="info-label"></span>
        <input type="text"
               id="detailAddress"
               class="form-control"
               placeholder="상세주소를 입력하세요">
      </div>

      <div class="info-row zipcode-button-row">
        <span class="info-label">우편번호</span>
        <input type="text" id="zipcode" class="form-control" readonly>
        <button type="button"
                id="selectAddressBtn"
                class="btn btn-outline-secondary btn-address-change"
                data-toggle="modal"
                data-target="#deliveryModal">
          배송지 설정
        </button>
      </div>

    </div>

  </div>
  <!-- ================= 상단 끝 ================= -->


  <!-- ================= 본문 : 좌 / 우 (7:3 비율) ================= -->
  <div class="payment-body">

    <!-- ===== 왼쪽 70% : 상품 목록 ===== -->
    <div class="payment-left">

      <div class="product-section">
			<c:if test="${stockAdjusted}">
			  <div class="alert alert-warning py-2 mb-3" style="font-size:13px;">
			    남은 재고 수량 초과시 재고 수량에 맞게 자동 조정됩니다.
			  </div>
			</c:if>
        <div class="product-header-row">
          <div class="col-image">상품정보</div>
          <div class="col-name"></div>
          <div class="col-qty">수량</div>
          <div class="col-price">주문금액</div>
        </div>

        <c:forEach var="item" items="${orderList}">
          <div class="product-row">

            <div class="col-image">
              <img src="<%= ctxPath %>/image/product_TH/${item.image_path}"
                   alt="상품 이미지"
                   class="product-image">
            </div>

            <div class="col-name">${item.product_name}</div>
            <div class="col-qty">${item.quantity}</div>

            <div class="col-price">
              <fmt:formatNumber value="${item.total_price}" pattern="#,###"/> 원
            </div>

          </div>
        </c:forEach>

        <div class="product-total-row">
          <span>주문금액</span>
          <span>
            <fmt:formatNumber value="${totalPrice}" pattern="#,###"/> 원
          </span>
        </div>

      </div>
    </div>
    <!-- ===== 왼쪽 끝 ===== -->


    <!-- ===== 오른쪽 30% : 금액 요약 + 결제 (스크롤 따라다님) ===== -->
    <div class="payment-right">

      <div class="price-summary">
        <div class="price-row">
          <span>총 상품금액</span>
          <span><fmt:formatNumber value="${totalPrice}" pattern="#,###"/> 원</span>
        </div>
        
        <div class="price-row">
          <select id="couponSelect" name="couponSelect" class="form-control">
            <option value="">쿠폰 선택</option>
			<option value="cancel" data-discount="0" style="display: none;
			">쿠폰 X (0원)</option>
			
            <c:forEach var="row" items="${couponList}">
              <c:set var="coupon" value="${row.coupon}" />
              <c:set var="issue" value="${row.issue}" />

              <%-- 정액 할인 --%>
              <c:if test="${coupon.discountType == 0}">
                <option value="${issue.couponId}"
                        data-discount="${coupon.discountValue}">
                  ${coupon.couponName}
                  ( <fmt:formatNumber value="${coupon.discountValue}" pattern="#,###"/>원 할인 )
                </option>
              </c:if>

              <%-- 정률 할인 --%>
              <c:if test="${coupon.discountType == 1}">
                <option value="${issue.couponId}"
                        data-discount="${totalPrice * coupon.discountValue / 100}">
                  ${coupon.couponName}
                  ( ${coupon.discountValue}% 할인 )
                </option>
              </c:if>

            </c:forEach>
          </select>
        </div>

        <div class="price-row">
          <button type="button" id="applyCouponBtn">쿠폰 사용하기</button>
          <span id="discountAmount">- 0 원</span>
        </div>

        <input type="hidden" name="couponDiscount" id="couponDiscount" value="0">
        <input type="hidden" id="totalPrice" value="${totalPrice}" />	
        <input type="hidden" id="finalPrice" value="${totalPrice}" />
        <input type="hidden" id="couponId" name="couponId" />
        
        <div class="price-row total">
          <span>총 주문금액</span>
          <span class="amount" id="finalAmount">
            <fmt:formatNumber value="${finalPrice}" pattern="#,###"/> 원
          </span>
        </div>
      </div>
		
      <button class="confirm-btn" id="coinPayBtn">
        결제하기
      </button>

    </div>
    <!-- ===== 오른쪽 끝 ===== -->

  </div>
  <!-- ================= 본문 끝 ================= -->

</div>

<input type="hidden" name="totalAmount" id="totalAmount" value="${totalPrice}">
<input type="hidden" name="discountAmount" id="discountAmountHidden" value="0">
<input type="hidden" name="deliveryAddress" id="deliveryAddress" value="">

<!-- 상품명 정보 추가 -->
<c:choose>
  <c:when test="${orderList.size() == 1}">
    <input type="hidden" id="productName" value="${orderList[0].product_name}" />
  </c:when>
  <c:otherwise>
    <input type="hidden" id="productName" value="${orderList[0].product_name} 외 ${orderList.size() - 1}건" />
  </c:otherwise>
</c:choose>

</form>

<!-- 회원정보 모달 -->
<div class="modal fade" id="memberInfoModal" tabindex="-1" role="dialog" aria-labelledby="memberInfoModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="memberInfoModalLabel">내 정보</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <div class="row">
          <!-- 개인정보 표시 -->
          <div class="col-md-6 mb-4">
            <h6 class="font-weight-bold mb-3">개인정보</h6>

            <div class="mb-3">
              <small class="text-muted d-block">성 명</small>
              <div class="font-weight-bold">
                ${loginUser.name}
              </div>
            </div>

            <div class="mb-3">
              <small class="text-muted d-block">이메일</small>
              <div class="font-weight-bold">
                ${loginUser.email}
              </div>
            </div>

            <div class="mb-3">
              <small class="text-muted d-block">전화번호</small>
              <div class="font-weight-bold">
                ${loginUser.mobile}
              </div>
            </div>

            <button type="button" class="btn btn-outline-primary btn-sm" onclick="goToMemberEdit();">
              <i class="fa-regular fa-pen-to-square mr-1"></i> 정보 수정하기
            </button>
          </div>

          <!-- 계정정보 표시 -->
          <div class="col-md-6 mb-4">
            <h6 class="font-weight-bold mb-3">계정 정보</h6>

            <div class="mb-3">
              <small class="text-muted d-block">아이디</small>
              <div class="font-weight-bold">
                ${loginUser.memberid}
              </div>
            </div>

            <div class="mb-3">
              <small class="text-muted d-block">회원가입일자</small>
              <div class="font-weight-bold">
                ${loginUser.registerday}
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
      </div>
    </div>
  </div>
</div>

<!-- 배송지 관리 모달 -->
<div class="modal fade" id="deliveryModal" tabindex="-1" role="dialog" aria-labelledby="deliveryModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-xl" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title font-weight-bold" id="deliveryModalLabel">배송지 관리</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        
        <div class="d-flex justify-content-between align-items-center mb-3">
          <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#addressModalPayment" id="btnOpenAddInPayment">
            <i class="fa-solid fa-plus mr-1"></i> 배송지 추가
          </button>
        </div>

        <div class="alert alert-light border mb-4">
          <small class="text-muted">기본 배송지는 1개만 설정 가능하며, 주문 시 기본 배송지가 우선 선택됩니다.</small>
        </div>

        <c:if test="${empty deliveryList}">
          <div class="text-center py-5">
            <div class="mb-2 text-muted">등록된 배송지가 없습니다.</div>
            <button type="button" class="btn btn-outline-primary" data-toggle="modal" data-target="#addressModalPayment" id="btnOpenAddEmptyInPayment">
              <i class="fa-solid fa-plus mr-1"></i> 첫 배송지 추가하기
            </button>
          </div>
        </c:if>

        <c:if test="${not empty deliveryList}">
          <div class="d-flex justify-content-between align-items-center mb-3">
            <div class="custom-control custom-checkbox">
              <input type="checkbox" class="custom-control-input" id="checkAllInPayment" />
              <label class="custom-control-label" for="checkAllInPayment">전체 선택</label>
            </div>
            <div>
              <button type="button" class="btn btn-outline-danger btn-sm" id="btnDeleteSelectedInPayment">
                <i class="fa-solid fa-trash mr-1"></i> 선택 삭제
              </button>
              <button type="button" class="btn btn-success btn-sm" id="btnSetDefaultInPayment">
                <i class="fa-solid fa-check mr-1"></i> 기본 배송지로 설정
              </button>
            </div>
          </div>

          <div class="list-group" style="max-height: 500px; overflow-y: auto;">
            <c:forEach var="addr" items="${deliveryList}">
              <div class="list-group-item mb-2 ${addr.isDefault == 1 ? 'border-primary' : ''}">
                <div class="d-flex align-items-start">
                  <div class="mr-3 pt-1">
                    <input type="checkbox" class="addr-check-payment" name="deliveryAddressIdPayment" value="${addr.deliveryAddressId}" ${addr.isDefault == 1 ? "disabled" : ""} />
                  </div>
                  <div class="flex-grow-1">
                    <div class="d-flex justify-content-between align-items-start">
                      <div>
                        <div class="d-flex align-items-center">
                          <h6 class="mb-1 font-weight-bold">
                            <c:out value="${addr.addressName}" />
                          </h6>
                          <c:if test="${addr.isDefault == 1}">
                            <span class="badge badge-primary ml-2">기본</span>
                          </c:if>
                        </div>
                        <div class="text-muted small">
                          <div><c:out value="${addr.recipientName}" /></div>
                          <div>
                            (<c:out value="${addr.postalCode}" />)
                            <c:out value="${addr.address}" />
                            <c:if test="${not empty addr.addressDetail}">
                              , <c:out value="${addr.addressDetail}" />
                            </c:if>
                          </div>
                          <div><c:out value="${addr.recipientPhone}" /></div>
                        </div>
                      </div>
                      <div class="text-right">
                        <button type="button" class="btn btn-outline-primary btn-sm btnSelectAddress"
                                data-name="${addr.recipientName}"
                                data-phone="${addr.recipientPhone}"
                                data-zipcode="${addr.postalCode}"
                                data-address="${addr.address}"
                                data-detail="${addr.addressDetail}">
                          <i class="fa-solid fa-check mr-1"></i> 선택
                        </button>
                        <button type="button" class="btn btn-outline-secondary btn-sm btnOpenEditInPayment"
                                data-toggle="modal" data-target="#addressModalPayment"
                                data-id="${addr.deliveryAddressId}"
                                data-addressname="${addr.addressName}"
                                data-recipientname="${addr.recipientName}"
                                data-postalcode="${addr.postalCode}"
                                data-phone="${addr.recipientPhone}"
                                data-address="${addr.address}"
                                data-addressdetail="${addr.addressDetail}">
                          <i class="fa-regular fa-pen-to-square mr-1"></i> 수정
                        </button>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </c:forEach>
          </div>
        </c:if>

      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
      </div>
    </div>
  </div>
</div>

<!-- 배송지 추가/수정 모달 -->
<div class="modal fade" id="addressModalPayment" tabindex="-1" role="dialog" aria-labelledby="addressModalPaymentLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title font-weight-bold" id="addressModalPaymentLabel">배송지 추가/수정</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>

      <form id="addressFormPayment" method="post" action="<%= ctxPath %>/myPage/deliverySave.hp">
        <div class="modal-body">
          <input type="hidden" name="mode" id="modePayment" value="add" />
          <input type="hidden" name="deliveryAddressId" id="deliveryAddressIdPayment" />

          <div class="form-row">
            <div class="form-group col-md-6">
              <label class="font-weight-bold">배송지명</label>
              <input type="text" class="form-control" name="addressName" id="addressNamePayment" required />
            </div>
            <div class="form-group col-md-6">
              <label class="font-weight-bold">수령인</label>
              <input type="text" class="form-control" name="recipientName" id="recipientNamePayment" required />
            </div>
          </div>

          <div class="form-row">
            <div class="form-group col-md-6">
              <label class="font-weight-bold">우편번호</label>
              <div class="input-group">
                <input type="text" class="form-control" name="postalCode" id="postalCodePayment" required />
                <div class="input-group-append">
                  <button type="button" class="btn btn-outline-secondary" id="btnPostcodeSearchPayment">
                    <i class="fa-solid fa-magnifying-glass"></i>
                  </button>
                </div>
              </div>
            </div>

            <div class="form-group col-md-6">
              <label class="font-weight-bold">연락처</label>
              <input type="text" class="form-control" name="recipientPhone" id="recipientPhonePayment" required />
            </div>
          </div>

          <div class="form-group">
            <label class="font-weight-bold">주소</label>
            <input type="text" class="form-control" name="address" id="addressPayment" required />
          </div>

          <div class="form-group">
            <label class="font-weight-bold">상세주소</label>
            <input type="text" class="form-control" name="addressDetail" id="addressDetailPayment" required />
          </div>
        </div>

        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
          <button type="submit" class="btn btn-primary">
            <i class="fa-solid fa-floppy-disk mr-1"></i> 저장
          </button>
        </div>
      </form>
    </div>
  </div>
</div>

<style>
  .addr-card { border: 4px solid #e9ecef; border-radius: .5rem; }
  .addr-card.default { border-color: #007bff; }
  .addr-badge { font-size: 12px; }
  .addr-actions .btn { padding: .25rem .5rem; }
</style>

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="<%= ctxPath %>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js"></script>

<script>
const ctxpath = '<%= ctxPath %>';
const loginUserName = '${loginUser.name}';
const loginUserMobile = '${loginUser.mobile}';
const loginUserEmail = '${loginUser.email}';

// 마이페이지 정보 수정 페이지로 이동
function goToMemberEdit() {
  window.location.href = ctxpath + '/myPage/memberEdit.hp';
}

$(document).ready(function() {
  
  // ===== 주기적 backdrop 정리 (화면 멈춤 방지) =====
  setInterval(function() {
    // 다음 주소검색 팝업이 열려있으면 스킵
    if ($('body').find('iframe[src*="postcode"]').length > 0) {
      return;
    }
    
    const openModals = $('.modal.show').length;
    const backdrops = $('.modal-backdrop').length;
    
    // 모달 없는데 backdrop 있으면 제거
    if (openModals === 0 && backdrops > 0) {
      $('.modal-backdrop').remove();
      $('body').removeClass('modal-open').css({
        'overflow': '',
        'padding-right': ''
      });
    }
    // backdrop이 모달보다 많으면 초과분 제거
    else if (backdrops > openModals && openModals > 0) {
      const excess = backdrops - openModals;
      $('.modal-backdrop').slice(0, excess).remove();
    }
  }, 500); // setInterval 끝
  
  // ===== 배송지 선택 =====
  $(document).on('click', '.btnSelectAddress', function() {
    const name = $(this).data('name');
    const phone = $(this).data('phone');
    const zipcode = $(this).data('zipcode');
    const address = $(this).data('address');
    const detail = $(this).data('detail');
    
    // 값 설정
    $('#recipientName').val(name);
    $('#recipientPhone').val(phone);
    $('#zipcode').val(zipcode);
    $('#address').val(address);
    $('#detailAddress').val(detail);
    
    // 모든 모달 닫기
    $('.modal').modal('hide');
    
    // 모달 배경 강제 제거 + 알림
    setTimeout(function() {
      $('.modal-backdrop').remove();
      $('body').removeClass('modal-open').css({
        'overflow': '',
        'padding-right': ''
      });
      alert('배송지가 선택되었습니다.');
    }, 300);
  });
  
  // ===== 배송지 추가 =====
  $(document).on('click', '#btnOpenAddInPayment, #btnOpenAddEmptyInPayment', function() {
    $('#modePayment').val('add');
    $('#deliveryAddressIdPayment').val('');
    $('#addressFormPayment')[0].reset();
    $('#addressModalPaymentLabel').text('배송지 추가');
  });
  
  // ===== 배송지 수정 =====
  $(document).on('click', '.btnOpenEditInPayment', function() {
    $('#modePayment').val('edit');
    $('#deliveryAddressIdPayment').val($(this).data('id'));
    $('#addressNamePayment').val($(this).data('addressname'));
    $('#recipientNamePayment').val($(this).data('recipientname'));
    $('#postalCodePayment').val($(this).data('postalcode'));
    $('#recipientPhonePayment').val($(this).data('phone'));
    $('#addressPayment').val($(this).data('address'));
    $('#addressDetailPayment').val($(this).data('addressdetail'));
    $('#addressModalPaymentLabel').text('배송지 수정');
  });
  
  // ===== 우편번호 검색 =====
  $('#btnPostcodeSearchPayment').click(function() {
    new daum.Postcode({
      oncomplete: function(data) {
        $('#postalCodePayment').val(data.zonecode);
        $('#addressPayment').val(data.address);
        $('#addressDetailPayment').focus();
      }
    }).open();
  });
  
  // ===== 전체 선택 =====
  $('#checkAllInPayment').change(function() {
    $('.addr-check-payment:not(:disabled)').prop('checked', $(this).prop('checked'));
  });
  
  // ===== 개별 체크 =====
  $(document).on('change', '.addr-check-payment', function() {
    const total = $('.addr-check-payment:not(:disabled)').length;
    const checked = $('.addr-check-payment:not(:disabled):checked').length;
    if (total === 0) {
      $('#checkAllInPayment').prop('checked', false);
      return;
    }
    $('#checkAllInPayment').prop('checked', (total === checked));
  });
  
  // ===== 선택 삭제 =====
  $('#btnDeleteSelectedInPayment').click(function() {
    const checked = $('.addr-check-payment:checked');
    if (checked.length === 0) {
      alert('삭제할 배송지를 선택해주세요.');
      return;
    }
    
    if (!confirm('선택한 배송지를 삭제하시겠습니까?')) {
      return;
    }
    
    const form = $('<form>', {
      method: 'post',
      action: ctxpath + '/myPage/deliveryDelete.hp'
    });
    
    checked.each(function() {
      form.append($('<input>', {
        type: 'hidden',
        name: 'deliveryAddressId',
        value: $(this).val()
      }));
    });
    
    $('body').append(form);
    form.submit();
  });
  
  // ===== 기본 배송지 설정 =====
  $('#btnSetDefaultInPayment').click(function() {
    const checked = $('.addr-check-payment:checked');
    if (checked.length === 0) {
      alert('기본 배송지로 설정할 배송지를 선택해주세요.');
      return;
    }
    if (checked.length > 1) {
      alert('기본 배송지는 1개만 선택할 수 있습니다.');
      return;
    }
    
    $.ajax({
      url: ctxpath + '/myPage/deliverySetDefault.hp',
      method: 'POST',
      data: {
        deliveryAddressId: checked.val()
      },
      success: function(response) {
        $('.addr-check-payment').prop('disabled', false).prop('checked', false);
        checked.prop('disabled', true);
        
        $('.list-group-item').removeClass('border-primary');
        $('.badge-primary').remove();
        
        checked.closest('.list-group-item').addClass('border-primary');
        checked.closest('.list-group-item').find('h6').append(' <span class="badge badge-primary ml-2">기본</span>');
        
        $('#checkAllInPayment').prop('checked', false);
      },
      error: function() {
        alert('기본 배송지 설정에 실패했습니다.');
      }
    });
  });
  
  // ===== 배송지 저장 =====
  $('#addressFormPayment').submit(function(e) {
    e.preventDefault();
    
    const phone = $('#recipientPhonePayment').val().trim();
    if (!/^\d{10,11}$/.test(phone)) {
      alert('연락처는 10~11자리 숫자만 입력 가능합니다.');
      $('#recipientPhonePayment').focus();
      return;
    }
    
    $.ajax({
      url: $(this).attr('action'),
      method: 'POST',
      data: $(this).serialize(),
      success: function() {
        alert('배송지가 저장되었습니다.');
        location.reload();
      },
      error: function() {
        alert('배송지 저장에 실패했습니다.');
      }
    });
  });
  
  // ===== 연락처 숫자만 =====
  $('#recipientPhonePayment').attr({
    inputmode: 'numeric',
    pattern: '[0-9]*',
    autocomplete: 'tel',
    maxlength: 11
  }).on('keydown', function(e) {
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
  }).on('input', function() {
    const onlyDigits = this.value.replace(/\D/g, '');
    if (this.value !== onlyDigits) this.value = onlyDigits;
  });
  
});

$(document).on('shown.bs.modal', '#deliveryModal', function () {

	  // 전체선택 체크박스 줄 제거
	  $('#checkAllInPayment')
	    .closest('.d-flex.justify-content-between.align-items-center.mb-3')
	    .remove();

	  // 선택 삭제 버튼 제거
	  $('#btnDeleteSelectedInPayment').remove();

	  // 기본 배송지 설정 버튼 제거
	  $('#btnSetDefaultInPayment').remove();

	  // 개별 배송지 체크박스 제거
	  $('.addr-check-payment').remove();

	  // 체크박스가 있던 왼쪽 여백 제거
	  $('.list-group-item .mr-3').remove();

	});
</script>

<script src="<%= ctxPath %>/js/pay_MS/payMent.js"></script>

</body>
</html>
