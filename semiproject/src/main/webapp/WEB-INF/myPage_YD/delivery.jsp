<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- header.jsp (수정 금지) -->
<jsp:include page="/WEB-INF/header.jsp" />

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/member_YD/myPage.css" />

<style>
	.addr-card { border: 1px solid #e9ecef; border-radius: .5rem; }
	.addr-card.default { border-color: #007bff; }
	.addr-badge { font-size: 12px; }
	.addr-actions .btn { padding: .25rem .5rem; }
</style>

<!-- JS에서 ctxPath 쓸 수 있게 -->
<script>
  	const ctxPath = "${pageContext.request.contextPath}";
</script>

<div class="container my-5">
	<div class="row">

    	<!--사이드바 -->
    	<div class="col-md-3 mb-4">
      		<div class="card shadow-sm position-sticky" style="top: 100px;">
        		<div class="card-body text-center">
          			<h5 class="font-weight-bold mb-1">
            			<c:out value= "${memberInfo.name}" />
          			</h5>
          			<small class="text-muted">
            			<c:out value="${memberInfo.memberid}" />
          			</small>
        		</div>

        		<div class="list-group list-group-flush">
          			<a href="${pageContext.request.contextPath}/myPage/myPage.hp"
            			class="list-group-item list-group-item-action">
            			<i class="fa-regular fa-user mr-2"></i> 내 정보
          			</a>

          			<a href="${pageContext.request.contextPath}/myPage/orders.hp"
             			class="list-group-item list-group-item-action">
            			<i class="fa-solid fa-bag-shopping mr-2"></i> 주문내역
          			</a>

          			<a href="${pageContext.request.contextPath}/myPage/delivery.hp"
             			class="list-group-item list-group-item-action active">
            			<i class="fa-solid fa-truck mr-2"></i> 배송지 관리
          			</a>
        		</div>
      		</div>
    	</div>

    	<!-- 메인콘텐츠 -->
    	<div class="col-md-9">
      		<div class="card shadow-sm">
        		<div class="card-body">

          			<div class="d-flex justify-content-between align-items-center mb-4">
            			<h4 class="font-weight-bold mb-0">배송지 관리</h4>

            			<button type="button" class="btn btn-primary"
                    			data-toggle="modal" data-target="#addressModal"
                    			id="btnOpenAdd">
              					<i class="fa-solid fa-plus mr-1"></i> 배송지 추가
            			</button>
        			</div>

          			<div class="alert alert-light border mb-4">
            			<small class="text-muted">기본 배송지는 1개만 설정 가능하며, 주문 시 기본 배송지가 우선 선택됨.</small>
          			</div>

          			<c:if test="${empty deliveryList}">
            			<div class="text-center py-5">
              				<div class="mb-2 text-muted">등록된 배송지가 없습니다.</div>
              				<button type="button" class="btn btn-outline-primary"
                      			data-toggle="modal" data-target="#addressModal" id="btnOpenAddEmpty">
                				<i class="fa-solid fa-plus mr-1"></i> 첫 배송지 추가하기
              				</button>
            			</div>
          			</c:if>

          			<c:if test="${not empty deliveryList}">
            			<div class="d-flex justify-content-between align-items-center mb-3">
              				<div class="custom-control custom-checkbox">
                				<input type="checkbox" class="custom-control-input" id="checkAll" />
                				<label class="custom-control-label" for="checkAll">전체 선택</label>
              				</div>
              				<div>
	                			<button type="button" class="btn btn-outline-danger" id="btnDeleteSelected">
	                  				<i class="fa-solid fa-trash mr-1"></i> 선택 삭제
	                			</button>
	                			<button type="button" class="btn btn-success" id="btnSetDefault">
	                  				<i class="fa-solid fa-check mr-1"></i> 기본 배송지로 설정
	                			</button>
              				</div>
            			</div>

						<!-- 삭제 폼 -->
			            <form id="deleteForm" method="post" action="${pageContext.request.contextPath}/myPage/deliveryDelete.hp"></form>
			
			            <!-- 기본 설정 폼 -->
			            <form id="defaultForm" method="post" action="${pageContext.request.contextPath}/myPage/deliverySetDefault.hp">
			            	<input type="hidden" name="deliveryAddressId" id="defaultDeliveryId" />
			            </form>
			
			            <div class="list-group">
			              	<c:forEach var="addr" items="${deliveryList}">
			                	<div class="list-group-item addr-card mb-3 ${addr.isDefault == 1 ? 'default' : ''}">
			                  		<div class="d-flex align-items-start">
			                    		<div class="mr-3 pt-1">
			                      			<input type="checkbox" class="addr-check" name="deliveryAddressId" value="${addr.deliveryAddressId}" ${addr.isDefault == 1 ? "disabled" : ""} />
			                    		</div>
			                    		<div class="flex-grow-1">
			                      			<div class="d-flex justify-content-between align-items-start">
			                        			<div>
			                          				<div class="d-flex align-items-center">
			                            				<h5 class="mb-1 font-weight-bold">
			                              					<c:out value="${addr.memberId}" />
			                            				</h5>
			                            				<c:if test="${addr.isDefault == 1}">
			                              					<span class="badge badge-primary addr-badge ml-2">기본</span>
			                            				</c:if>
			                          				</div>
			                          				<div class="text-muted">
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
			                        			<div class="addr-actions text-right">
			                          				<button type="button"
			                                  			class="btn btn-outline-primary btn-sm btnOpenEdit"
			                                  			data-toggle="modal" data-target="#addressModal"
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
			                      			<div class="mt-2">
			                        			<small class="text-muted">기본 설정은 “기본 배송지로 설정” 버튼을 이용해 변경 가능함.</small>
			                      			</div>
			                    		</div>
			                  		</div>
			                	</div>
			              	</c:forEach>
						</div>
					</c:if>
				</div>
			</div>
   	 	</div>
  	</div>
</div>

<!-- 배송지 추가/수정 모달 -->
<div class="modal fade" id="addressModal" tabindex="-1" role="dialog" aria-labelledby="addressModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">

      <div class="modal-header">
        <h5 class="modal-title font-weight-bold" id="addressModalLabel">배송지 추가/수정</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>

      <form id="addressForm" method="post" action="${pageContext.request.contextPath}/myPage/deliverySave.hp">
        <div class="modal-body">

          <input type="hidden" name="mode" id="mode" value="add" />
          <input type="hidden" name="deliveryAddressId" id="deliveryAddressId" />

          <div class="form-row">
            <div class="form-group col-md-6">
              <label class="font-weight-bold">배송지명</label>
              <input type="text" class="form-control" name="addressName" id="addressName" required />
            </div>
            <div class="form-group col-md-6">
              <label class="font-weight-bold">수령인</label>
              <input type="text" class="form-control" name="recipientName" id="recipientName" required />
            </div>
          </div>

          <div class="form-row">
            <div class="form-group col-md-6">
              <label class="font-weight-bold">우편번호</label>
              <div class="input-group">
                <input type="text" class="form-control" name="postalCode" id="postalCode" required />
                <div class="input-group-append">
                  <button type="button" class="btn btn-outline-secondary" id="btnPostcodeSearch">
                    <i class="fa-solid fa-magnifying-glass"></i>
                  </button>
                </div>
              </div>
            </div>

            <div class="form-group col-md-6">
              <label class="font-weight-bold">연락처</label>
              <input type="text" class="form-control" name="recipientPhone" id="recipientPhone" required />
            </div>
          </div>

          <div class="form-group">
            <label class="font-weight-bold">주소</label>
            <input type="text" class="form-control" name="address" id="address" required />
          </div>

          <div class="form-group">
            <label class="font-weight-bold">상세주소</label>
            <input type="text" class="form-control" name="addressDetail" id="addressDetail" required />
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


<!-- 다음 우편번호 서비스 -->
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<!-- 배송지 관리 전용 JS -->
<script src="${pageContext.request.contextPath}/js/myPage_YD/delivery.js"></script>

<!-- footer.jsp (수정 금지) -->
<jsp:include page="/WEB-INF/footer.jsp" />
