<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%String ctxPath=request.getContextPath();%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0 shrink-to-fit=no">
    <title>쿠폰 관리 - PhoneStore 관리자</title>
    
<script>
  const ctxPath = "<%= ctxPath %>";
</script>    
    
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" type="text/css" href="<%=ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css">
    
    <!-- Font Awesome 6 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.1/css/all.min.css">
   <!-- <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">-->
    
    <!-- 직접 만든 CSS -->
    <link href="<%=ctxPath%>/css/admin/admin.css" rel="stylesheet" />
    
    <!-- Optional JavaScript -->
	<script type="text/javascript" src="<%= ctxPath%>/js/jquery-3.7.1.min.js"></script>
	<script type="text/javascript" src="<%= ctxPath%>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js" ></script> 
    
    <%-- jQueryUI CSS 및 JS --%>
	<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/jquery-ui-1.13.1.custom/jquery-ui.min.css" />
	<script type="text/javascript" src="<%=ctxPath%>/jquery-ui-1.13.1.custom/jquery-ui.min.js"></script>
	
	<%-- 직접 만든 JS --%>
    <script src="<%=ctxPath%>/js/admin/coupons.js"></script>
    

</head>
<body>
    <div class="wrapper">
        <jsp:include page="/WEB-INF/admin/admin_sidebar.jsp" />
        
        <div class="main-content">
            <%-- <jsp:include page="/WEB-INF/admin/admin_header.jsp" /> --%>
            
             <div class="content-wrapper">
                <div class="container-fluid p-4">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div>
                            <h2 class="mb-2">쿠폰 관리</h2>
                            <p class="text-muted">쿠폰을 생성하고 관리할 수 있습니다</p>
                        </div>
                        <button class="btn btn-primary" data-toggle="modal" data-target="#createCouponModal" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                            <i class="fas fa-plus mr-2"></i>쿠폰 생성
                        </button>
                    </div>
                    
                    <c:if test="${not empty msg}">
					  <div class="alert alert-info alert-dismissible fade show" role="alert">
					    ${msg}
					    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
					      <span aria-hidden="true">&times;</span>
					    </button>
					  </div>
					</c:if>
                    
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">쿠폰 목록</h5>
                        </div>
                        <div class="card-body">
                        	<!-- filters -->
							<form id="couponFilterFrm" method="get" action="<%=ctxPath%>/admin/coupon.hp" class="form-inline mb-3">
							  <input type="hidden" name="sizePerPage" value="${requestScope.sizePerPage}" />
							  <input type="hidden" name="currentShowPageNo" value="1" />
							
							  <label class="mr-2">할인타입</label>
							  <select name="type" id="filterType" class="form-control mr-4">
							    <option value=""  ${empty param.type ? 'selected' : ''}>전체</option>
							    <option value="0" ${param.type == '0' ? 'selected' : ''}>정액</option>
							    <option value="1" ${param.type == '1' ? 'selected' : ''}>정률</option>
							  </select>
							
							  <label class="mr-2">정렬</label>
							  <select name="sort" id="filterSort" class="form-control">
							    <option value=""         ${empty param.sort ? 'selected' : ''}>전체</option>
							    <option value="valueDesc" ${param.sort == 'valueDesc' ? 'selected' : ''}>할인값 큰순</option>
							    <option value="valueAsc"  ${param.sort == 'valueAsc' ? 'selected' : ''}>할인값 작은순</option>
							  </select>
							  
							  <input type="hidden" name="onlyUsable" id="onlyUsableVal"
								     value="${empty param.onlyUsable ? '1' : param.onlyUsable}" />
								
								<div class="form-check ml-4">
								  <input class="form-check-input" type="checkbox" id="onlyUsableChk"
								         ${empty param.onlyUsable || param.onlyUsable == '1' ? 'checked' : ''} />
								  <label class="form-check-label" for="onlyUsableChk">사용중만 보기</label>
								</div>
							  
							</form>
							
                            <div class="table-responsive">
                                <table class="table table-hover" id="couponTable">
                                    <thead>
                                        <tr>
                                        	   <th>NO</th>
                                            <th>쿠폰번호</th>
                                            <th>쿠폰명</th>
                                            <th>할인타입</th>
                                            <th>할인값</th>
                                            <th>사용여부</th>
										   <th>관리</th>                                   
                                        </tr>
                                    </thead>
                                    <tbody id="couponTableBody">
                                    	<c:forEach var="coupon" items="${couponList}" varStatus="status">
										    <tr class="coupon-row" data-coupon-no="${coupon.couponCategoryNo}" data-coupon-name="${coupon.couponName}" data-usable="${coupon.usable}" style="cursor:pointer;">
										      <fmt:parseNumber var="currentShowPageNo" value="${requestScope.currentShowPageNo}"/>
										      <fmt:parseNumber var="sizePerPage" value="${requestScope.sizePerPage}"/>
										      <td>${(requestScope.totalCouponCount)-(currentShowPageNo-1)*sizePerPage-(status.index)}</td>
										      <td>${coupon.couponCategoryNo}</td>
										      <td>${coupon.couponName}</td>
										      <td>
										        <c:choose>
										          <c:when test="${coupon.discountType == 1}">정률(%)</c:when>
										          <c:otherwise>정액(원)</c:otherwise>
										        </c:choose>
										      </td>
										      <td>
										      	<c:choose>
											      <c:when test="${coupon.discountType == 0}">
											        <fmt:formatNumber value="${coupon.discountValue}" pattern="#,###" /> 원
											      </c:when>
											      <c:otherwise>
											        ${coupon.discountValue} %
											      </c:otherwise>
											    </c:choose>
										      </td>
										      
										      <!-- 사용여부 -->
											  <td class="coupon-usable-cell">
											    <c:choose>
											      <c:when test="${coupon.usable == 1}">
											        <span class="badge badge-success">사용중</span>
											      </c:when>
											      <c:otherwise>
											        <span class="badge badge-secondary">사용안함</span>
											      </c:otherwise>
											    </c:choose>
											  </td>
											
											  <!-- 사용안함 처리 버튼(POST) -->
											  <td class="coupon-action">
											    <c:choose>
											      <c:when test="${coupon.usable == 1}">
											        <form method="post" action="<%=ctxPath%>/admin/couponDisable.hp" class="d-inline"
												          onsubmit="return confirm('이 쿠폰을 사용안함 처리할까요?');">
												      <input type="hidden" name="couponCategoryNo" value="${coupon.couponCategoryNo}">
												      <button type="submit" class="btn btn-sm btn-outline-danger">사용안함</button>
												    </form>
											      </c:when>
											      <c:otherwise>
												    <form method="post" action="<%=ctxPath%>/admin/couponEnable.hp" class="d-inline"
												          onsubmit="return confirm('이 쿠폰을 다시 사용함으로 변경할까요?');">
												      <input type="hidden" name="couponCategoryNo" value="${coupon.couponCategoryNo}">
												      <button type="submit" class="btn btn-sm btn-outline-primary">사용함</button>
												    </form>
												  </c:otherwise>
											    </c:choose>
											  </td>
										      
										    </tr>
										</c:forEach>
										
									    <c:if test="${empty couponList}">
									        <tr>
									          <td colspan="4" class="text-center text-muted">등록된 쿠폰이 없습니다.</td>
									        </tr>
									    </c:if>
                                    </tbody>
                                </table>
                            </div>
                            <div id="pageBar">
							  <nav>
							    <ul class="pagination justify-content-center">${requestScope.pageBar}</ul>
							  </nav>
						   </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Create Coupon Modal -->
    <div class="modal fade" id="createCouponModal" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">쿠폰 생성</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <form id="createCouponForm">
                        <div class="form-group">
                            <label>쿠폰명</label>
                            <input type="text" class="form-control" id="couponName" required>
                        </div>
                        <div class="form-group">
                            <label>할인 타입</label>
                            <select class="form-control" id="discountType">
                                <option value="percentage">비율 할인 (%)</option>
                                <option value="fixed">금액 할인 (원)</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>할인값</label>
                            <input type="number" class="form-control" id="discountValue" required>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
                    <button type="button" class="btn btn-primary" id="submitCoupon">생성</button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Member Selection Modal -->
    <div class="modal fade" id="memberSelectModal" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-xl modal-dialog-scrollable" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">쿠폰 발급 대상 선택</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="alert alert-info" id="couponInfo"></div>
                    
                    <!-- Search and Filters -->
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <div class="form-inline">
                                <label class="mr-2">표시 개수:</label>
                                <select class="form-control mr-3" id="pageSize">
                                    <option value="5">5명</option>
                                    <option value="10">10명</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="input-group">
                                <select class="form-control" id="searchType" name="searchType" style="max-width: 120px;">
                                    <option value="member_id">아이디</option>
                                    <option value="name">이름</option>
                                    <option value="email">이메일</option>
                                </select>
                                <input type="text" class="form-control" id="searchWord" name="searchWord" placeholder="검색어 입력">
                                <div class="input-group-append">
                                    <button class="btn btn-outline-secondary" id="searchBtn">검색</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <p class="mb-3">선택된 회원: <span id="selectedCount">0</span>명</p>
                    <div class="table-responsive">
                        <table class="table table-hover" id="memberSelectTbl">
                        		<colgroup>
						      <col style="width: 48px;">   <%-- 체크박스 --%>
						      <col style="width: 160px;">  <%-- 아이디 --%>
						      <col style="width: 120px;">  <%-- 이름 --%>
						      <col style="width: 110px;">  <%-- 주문건수 --%>
						      <col style="width: 160px;">  <%-- 총 구매액 --%>
						      <col style="width: 120px;">  <%-- 가입일 --%>
						    </colgroup>
                            <thead>
                                <tr>
                                    <th>
                                        <input type="checkbox" id="selectAllMembers">
                                    </th>
                                    <th>아이디</th>
                                    <th>이름</th>
                                    <th class="member-sort-th">
									  <a href="#" class="member-sort" data-sort="order_cnt">주문건수</a>
									  <span class="member-sort-indicator"></span>
									</th>
									
									<th class="member-sort-th">
									  <a href="#" class="member-sort" data-sort="real_pay_sum">총 구매액</a>
									  <span class="member-sort-indicator"></span>
									</th>
                                    <th>가입일</th>
                                </tr>
                            </thead>
                            <tbody id="memberSelectTableBody"></tbody>
                        </table>
                    </div>
                    
                    <div class="row mb-3">
					  <div class="col-md-3 mt-4">
					    <label class="mb-1">만료일 입력</label>
					    <input type="date" class="form-control" id="expireDate" name="expireDate">
					    <small class="text-muted">선택일 23:59:59까지 사용 가능</small>
					  </div>
					</div>
                    
                    <!-- Pagination -->
                    <nav>
                        <ul class="pagination justify-content-center" id="pagination"></ul>
                    </nav>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
                    
                    <form id="issueCouponForm" method="post" action="<%=ctxPath%>/admin/couponSend.hp" class="m-0">
					   <input type="hidden" name="couponCategoryNo" id="hiddenCouponCategoryNo" />
					   <input type="hidden" name="memberIds" id="hiddenMemberIds" />
					   <input type="hidden" name="expireDate" id="hiddenExpireDate" />
					   
					   <input type="hidden" id="hiddenAllSelected"     name="allSelected">
					   <input type="hidden" id="hiddenDeselectedIds"   name="deselectedIds">
						
					   <button type="submit" class="btn btn-primary" id="sendCoupon">전송</button>
				    </form>
				    
                </div>
            </div>
        </div>
    </div>
    
    
    
    <!-- Issued Members Modal -->
    <div class="modal fade" id="issuedMembersModal" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">쿠폰 발급 회원 목록</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="alert alert-info" id="issuedCouponInfo"></div>
                    <div class="form-inline mb-2">
					  <label class="mr-2">필터</label>
					  <select class="form-control" id="issuedFilter">
					    <option value="all">전체</option>
					    <option value="unused">미사용만</option>
					    <!--
					    <option value="used">사용</option>
					    <option value="expired">기간만료</option>
					    -->
					  </select>
					</div>
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>발급번호</th>
                                    <th>아이디</th>
                                    <th>이름</th>
                                    <th>발급일</th>
                                    <th>만료일 (23시 59분 59초 까지)</th>
                                    <th>상태</th>
                                </tr>
                            </thead>
                            <tbody id="issuedMembersTableBody"></tbody>
                        </table>
                    </div>
                    
                    <nav class="mt-3">
					  <ul class="pagination justify-content-center" id="issuedPagination"></ul>
					</nav>
                </div>
                
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
                    <button type="button" class="btn btn-primary" id="sendMoreCoupons">회원에게 해당 쿠폰 전송</button>
                </div>
                
            </div>
        </div>
    </div>

</body>
</html>