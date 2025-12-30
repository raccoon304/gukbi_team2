<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
                                    <h3 class="mb-1">127건</h3>
                                    <small class="text-muted">전일 대비 +12%</small>
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
                                    <h3 class="mb-1">₩185,420,000</h3>
                                    <small class="text-muted">전일 대비 +8%</small>
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
                                    <h3 class="mb-1">3개</h3>
                                    <small class="text-muted">재고 10개 미만</small>
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
                                    <h3 class="mb-1">5명</h3>
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
                                <div class="card-body">
                                    <div id="recentOrders"></div>
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
                                <div class="card-body">
                                    <div id="lowStockProducts"></div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-lg-4 mb-3">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="mb-0 text-purple">
                                        <i class="fas fa-user-plus mr-2"></i>오늘 가입한 회원 (5명)
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <div id="todayNewMembers"></div>
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