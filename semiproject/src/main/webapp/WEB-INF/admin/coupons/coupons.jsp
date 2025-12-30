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
            <jsp:include page="/WEB-INF/admin/admin_header.jsp" />
            
             <div class="content-wrapper">
                <div class="container-fluid p-4">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div>
                            <h2 class="mb-2">쿠폰 관리</h2>
                            <p class="text-muted">쿠폰을 생성하고 관리할 수 있습니다</p>
                        </div>
                        <button class="btn btn-primary" data-toggle="modal" data-target="#createCouponModal">
                            <i class="fas fa-plus mr-2"></i>쿠폰 생성
                        </button>
                    </div>
                    
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">쿠폰 목록</h5>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover" id="couponTable">
                                    <thead>
                                        <tr>
                                            <th>쿠폰번호</th>
                                            <th>쿠폰명</th>
                                            <th>할인타입</th>
                                            <th>할인값</th>                                   
                                        </tr>
                                    </thead>
                                    <tbody id="couponTableBody">
                                    	<c:forEach var="coupon" items="${couponList}">
										    <tr class="coupon-row" data-coupon-no="${coupon.couponCategoryNo}" data-coupon-name="${coupon.couponName}" style="cursor:pointer;">
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
        <div class="modal-dialog modal-xl" role="document">
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
                                <select class="form-control" id="searchType" style="max-width: 120px;">
                                    <option value="userId">아이디</option>
                                    <option value="name">이름</option>
                                    <option value="email">이메일</option>
                                </select>
                                <input type="text" class="form-control" id="memberSearch" placeholder="검색어 입력">
                                <div class="input-group-append">
                                    <button class="btn btn-outline-secondary" id="searchBtn">검색</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <p class="mb-3">선택된 회원: <span id="selectedCount">0</span>명</p>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>
                                        <input type="checkbox" id="selectAllMembers">
                                    </th>
                                    <th>아이디</th>
                                    <th>이름</th>
                                    <th>주문건수</th>
                                    <th>총 구매액</th>
                                    <th>가입일</th>
                                </tr>
                            </thead>
                            <tbody id="memberSelectTableBody"></tbody>
                        </table>
                    </div>
                    
                    <!-- Pagination -->
                    <nav>
                        <ul class="pagination justify-content-center" id="pagination"></ul>
                    </nav>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
                    <button type="button" class="btn btn-primary" id="sendCoupon">전송</button>
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
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>아이디</th>
                                    <th>이름</th>
                                    <th>발급일</th>
                                    <th>상태</th>
                                </tr>
                            </thead>
                            <tbody id="issuedMembersTableBody"></tbody>
                        </table>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
                    <button type="button" class="btn btn-primary" id="sendMoreCoupons">쿠폰 전송</button>
                </div>
            </div>
        </div>
    </div>

</body>
</html>