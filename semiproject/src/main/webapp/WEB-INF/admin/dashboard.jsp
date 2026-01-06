<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%String ctxPath=request.getContextPath();%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
    <script src="<%=ctxPath%>/js/admin/dashboard.js"></script>
	
</head>
<body>
    <div class="wrapper">
        <jsp:include page="/WEB-INF/admin/admin_sidebar.jsp" />

        
        <div class="main-content">
            <jsp:include page="/WEB-INF/admin/admin_header.jsp" />
            
            <div class="content-wrapper">
                <div class="container-fluid p-4">
                    <div class="mb-4">
                        <h2 class="mb-2">대시보드</h2>
                        <p class="text-muted">관리자 대시보드에 오신 것을 환영합니다</p>
                    </div>
                    
                    <!-- Stats Cards -->
                    <div class="row mb-4">
                        <div class="col-md-6 col-lg-3 mb-3">
                            <div class="card stat-card">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <h6 class="text-muted mb-0">오늘 주문수</h6>
                                        <i class="fas fa-shopping-cart text-primary"></i>
                                    </div>
                                    <h3 class="mb-1">${todayOrderCount} 건</h3>
                                    <small class="text-white">오늘 주문수</small>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-6 col-lg-3 mb-3">
                            <div class="card stat-card">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <h6 class="text-muted mb-0">오늘 매출</h6>
                                        <i class="fas fa-dollar-sign text-success"></i>
                                    </div>
                                    <h3 class="mb-1">₩ <fmt:formatNumber value="${todaySales}" pattern="#,###"/></h3>
                                    <small class="text-muted">쿠폰 차감 후 실 결제액 기준</small>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-6 col-lg-3 mb-3">
                            <div class="card stat-card">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <h6 class="text-muted mb-0">품절 임박 상품</h6>
                                        <i class="fas fa-box-open text-danger"></i>
                                    </div>
                                    <h3 class="mb-1">${fn:length(lowStockProducts)} 개</h3>
                                    <small class="text-muted">판매중인 상품 중 재고 10개 미만</small>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-6 col-lg-3 mb-3">
                            <div class="card stat-card">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <h6 class="text-muted mb-0">오늘 가입 회원</h6>
                                        <i class="fas fa-user-plus text-purple"></i>
                                    </div>
                                    <h3 class="mb-1">${fn:length(todayNewMembers)} 명</h3>
                                    <small class="text-muted">신규 가입 회원</small>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Detail Cards -->
                    <div class="row">
                        <div class="col-lg-4 mb-3">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="mb-0">
                                        <i class="fas fa-clock mr-2"></i>최근 주문 5건
                                    </h5>
                                </div>
                                <div class="card-body scroll-card-body">
                                    <div id="recentOrders">
                                    		<c:if test="${empty currentOrders}">
									      <div class="text-muted">최근 주문이 없습니다.</div>
									    </c:if>
									
									    <c:if test="${not empty currentOrders}">
									      <ul class="list-group list-group-flush">
									        <c:forEach var="r" items="${currentOrders}">
									          <li class="list-group-item px-0">
									            <div class="d-flex justify-content-between align-items-start">
									              <div>
									                <%-- <div class="small text-muted">
									                  ${r.name} <span class="ml-1">(${r.memberId})</span>
									                </div> --%>
													<div class="small text-muted">
									                  <small class="text-muted">${r.brandName}</small>
									                </div>
									                <strong>${r.productName}</strong>
									                <%-- <small class="text-muted ml-2">${r.brandName}</small> --%>
														<c:if test="${r.detailCnt > 1}">
									                    · <span class="text-danger">외 ${r.detailCnt - 1}건</span>
									                  	</c:if>
									
									                <div class="small text-muted">
									              <%--  ${r.quantity}개 --%>
									                  <%-- <c:if test="${r.detailCnt > 1}">
									                    · <span class="text-danger">외 ${r.detailCnt - 1}건</span>
									                  </c:if> --%>
									                </div>
													<div class="small text-muted">
									                  ${r.name} <span class="ml-1">(${r.memberId})</span>
									                </div>
									                <%-- <small class="text-muted">${r.brandName}</small> --%>
									              </div>
									
									              <div class="text-right">
									              	<div class="small text-muted">
									              		${r.quantity}개
									              	</div>
									                <div class="font-weight-bold">
									                  <fmt:formatNumber value="${r.payAmount}" pattern="#,###"/>원
									                </div>
									                	<div class="small text-muted">${r.orderDate}</div>	
									                <%-- <div class="small text-muted">#${r.orderId}</div> --%>
									              </div>
									            </div>
									          </li>
									        </c:forEach>
									      </ul>
									    </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-lg-4 mb-3">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="mb-0 text-danger">
                                        <i class="fas fa-box-open mr-2"></i>품절 임박 상품
                                    </h5>
                                </div>
                                <div class="card-body scroll-card-body" >
                                    <div id="lowStockProducts">
                                    		<c:if test="${empty lowStockProducts}">
										  <div class="text-muted">재고 10개 미만 상품이 없습니다.</div>
										</c:if>
										
										<c:if test="${not empty lowStockProducts}">
										  <ul class="list-group list-group-flush">
										    <c:forEach var="p" items="${lowStockProducts}">
										      <li class="list-group-item px-0">
										        <div class="d-flex justify-content-between align-items-start">
										          <div>
										            <strong>${p.productName}</strong>
										            <small class="text-muted ml-2">${p.brandName}</small>
										            <div class="small text-muted">
										              ${p.color} / ${p.storageSize}
										            </div>
										          </div>
										
										          <span class="badge badge-danger badge-pill">
										            재고 : ${p.stockQty}개
										          </span>
										        </div>
										      </li>
										    </c:forEach>
										  </ul>
										</c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-lg-4 mb-3">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="mb-0 text-purple">
                                        <i class="fas fa-user-plus mr-2"></i>오늘 가입한 회원 (${fn:length(todayNewMembers)}명)
                                    </h5>
                                </div>
                                <div class="card-body scroll-card-body">
                                    <div id="todayNewMembers">
                                    		<c:if test="${empty todayNewMembers}">
									      <div class="text-muted">오늘 가입한 회원이 없습니다.</div>
									    </c:if>
									
									    <c:if test="${not empty todayNewMembers}">
									      <ul class="list-group list-group-flush">
									        <c:forEach var="m" items="${todayNewMembers}">
									          <li class="list-group-item px-0">
									            <div class="d-flex justify-content-between">
									              <div>
									                <strong>${m.name}</strong>
									                <small class="text-muted ml-2">(${m.memberid})</small>
									                <div class="small text-muted">${m.email}</div>
									              </div>
									              <div class="small text-muted">
									              ${m.registerday}
									              </div>
									            </div>
									          </li>
									        </c:forEach>
									      </ul>
									    </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    
</body>
</html>