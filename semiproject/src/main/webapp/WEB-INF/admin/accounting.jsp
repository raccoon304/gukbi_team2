<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%String ctxPath=request.getContextPath();%>


<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회계 - PhoneStore 관리자</title>
    
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
    <script src="<%=ctxPath%>/js/admin/accounting.js"></script>
 
<script>
  const ctxPath = "<%= request.getContextPath() %>";
</script> 
    
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .wrapper {
            display: flex;
            min-height: 100vh;
        }
        .main-content {
            flex: 1;
            margin-left: 250px;
            padding: 20px;
        }
        .stat-card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            transition: transform 0.2s;
        }
        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .stat-card .icon {
            width: 48px;
            height: 48px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            margin-bottom: 12px;
        }
        .stat-card .icon.blue { background: #e3f2fd; color: #2196f3; }
        .stat-card .icon.purple { background: #f3e5f5; color: #9c27b0; }
        .stat-card .icon.green { background: #e8f5e9; color: #4caf50; }
        .stat-card .icon.orange { background: #fff3e0; color: #ff9800; }
        .stat-card .icon.indigo { background: #e8eaf6; color: #3f51b5; }
        .stat-card .label {
            font-size: 13px;
            color: #757575;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .stat-card .value {
            font-size: 24px;
            font-weight: 600;
            color: #212529;
        }
        .section-card {
            background: white;
            border-radius: 12px;
            padding: 24px;
            margin-bottom: 24px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        .section-title {
            font-size: 18px;
            font-weight: 600;
            color: #212529;
            margin-bottom: 20px;
        }
        .table-wrapper {
            overflow-x: auto;
            overflow-y: auto;     /* 세로 스크롤 */
    			max-height: 420px;    /* 원하는 높이로 조절 */
        }
        .table {
            margin-bottom: 0;
        }
        .table thead th {
            border-top: none;
            border-bottom: 2px solid #e0e0e0;
            color: #757575;
            font-weight: 600;
            font-size: 13px;
            padding: 12px 16px;
            
            position: sticky;
		    top: 0;
		    background: white;   /* 헤더가 겹칠 때 배경 필요 */
		    z-index: 2;
            
        }
        .table tbody td {
            padding: 16px;
            vertical-align: middle;
            border-bottom: 1px solid #f5f5f5;
            color: #424242;
        }
        .table tbody tr:hover {
            background-color: #f8f9fa;
        }
        .period-select {
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            padding: 8px 12px;
            font-size: 14px;
            color: #424242;
            background: white;
            cursor: pointer;
        }
        .sort-select {
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            padding: 6px 12px;
            font-size: 13px;
            color: #424242;
            background: white;
        }
        .page-header {
            margin-bottom: 24px;
        }
        .page-title {
            font-size: 24px;
            font-weight: 700;
            color: #212529;
            margin-bottom: 8px;
        }
        .page-subtitle {
            font-size: 14px;
            color: #757575;
        }
        /* Custom 5-column grid for Bootstrap 4 */
        @media (min-width: 768px) {
            .col-md-2-4 {
                flex: 0 0 20%;
                max-width: 20%;
                position: relative;
                width: 100%;
                padding-right: 15px;
                padding-left: 15px;
            }
        }
        @media (max-width: 767px) {
            .col-md-2-4 {
                flex: 0 0 100%;
                max-width: 100%;
            }
        }
    </style>
</head>
<body>
    <div class="wrapper">
        <jsp:include page="/WEB-INF/admin/admin_sidebar.jsp" />
        
        <div class="main-content">
        		
            <!-- Page Header -->
            <div class="page-header">
                <div class="d-flex justify-content-between align-items-start">
                    <div>
                        <h1 class="page-title">회계</h1>
                        <p class="page-subtitle">기간별, 상품별 판매수량 및 매출을 확인할 수 있습니다</p>
                    </div>
                    
                    <div class="accounting-controls">
	                    <select class="period-select" id="periodSelect">
						  <optgroup label="일">
						    <option value="TODAY">오늘</option>
						    <option value="YESTERDAY">어제</option>
						    <option value="LAST_7" selected>최근 7일</option>
						    <option value="LAST_30">최근 30일</option>
						  </optgroup>
						
						  <optgroup label="월/분기/연">
						    <option value="MTD">이번 달(MTD)</option>
						    <option value="LAST_MONTH">지난 달</option>
						    <option value="QTD">이번 분기(QTD)</option>
						    <option value="LAST_QUARTER">지난 분기</option>
						    <option value="YTD">올해(YTD)</option>
						    <option value="LAST_YEAR">작년</option>
						  </optgroup>
						
						  <optgroup label="직접 선택">
						    <option value="CUSTOM">사용자 지정</option>
						  </optgroup>
						</select>
						
						<!-- 사용자 지정 날짜 영역 -->
						<div id="customRange" class="mt-2" style="display:none;">
						  <input type="text" id="startDate" class="period-select" style="width:140px;" placeholder="시작일">
						  <span class="mx-1">~</span>
						  <input type="text" id="endDate" class="period-select" style="width:140px;" placeholder="종료일">
						  <button type="button" id="applyCustom" class="btn btn-sm btn-primary ml-2">적용</button>
						
						  <div class="text-muted mt-1" style="font-size:12px;">
						    * 종료일 포함(예: 01-01~01-05는 5일까지)
						  </div>
						</div>
						
						<!-- 선택된 실제 기간 표시 -->
						<div id="rangeLabel" class="text-muted mt-2" style="font-size:13px;"></div>
					</div>
                </div>
            </div>
            
            <!-- Statistics Cards -->
            <div class="row">
                <div class="col-md-2-4 col-sm-6">
                    <div class="stat-card">
                        <div class="icon blue">
                            <i class="fas fa-shopping-cart"></i>
                        </div>
                        <div class="label">
                            <!-- <i class="fas fa-box"></i> -->
                            주문건수
                        </div>
                        <div class="value" id="totalOrders"></div>
                    </div>
                </div>
                <div class="col-md-2-4 col-sm-6">
                    <div class="stat-card">
                        <div class="icon purple">
                            <i class="fas fa-cube"></i>
                        </div>
                        <div class="label">
                            <!-- <i class="fas fa-box-open"></i> -->
                            판매수량
                        </div>
                        <div class="value" id="totalSales"></div>
                    </div>
                </div>
                <div class="col-md-2-4 col-sm-6">
                    <div class="stat-card">
                        <div class="icon green">
                            <i class="fas fa-dollar-sign"></i>
                        </div>
                        <div class="label">
                            <!-- <i class="fas fa-won-sign"></i> -->
                            할인 적용 전 매출액
                        </div>
                        <div class="value" id="totalRevenue"></div>
                    </div>
                </div>
                <div class="col-md-2-4 col-sm-6">
                    <div class="stat-card">
                        <div class="icon orange">
                            <i class="fas fa-tag"></i>
                        </div>
                        <div class="label">
                            <!-- <i class="fas fa-percent"></i> -->
                            할인액
                        </div>
                        <div class="value" id="totalDiscount"></div>
                    </div>
                </div>
                <div class="col-md-2-4 col-sm-6">
                    <div class="stat-card">
                        <div class="icon indigo">
                            <i class="fas fa-credit-card"></i>
                        </div>
                        <div class="label">
                            <!-- <i class="fas fa-receipt"></i> -->
                            최종결제액
                        </div>
                        <div class="value" id="finalPayment"></div>
                    </div>
                </div>
            </div>
            
            <!-- Daily Statistics -->
            <div class="section-card">
                <h2 class="section-title">기간별 집계</h2>
                <div class="table-wrapper">
                    <table class="table">
                        <thead>
                            <tr>
                                <th style="width: 25%;">기준일</th>
                                <th style="width: 25%;" class="text-right">주문건수</th>
                                <th style="width: 25%;" class="text-right">판매수량</th>
                                <th style="width: 25%;" class="text-right">할인 전 판매금액</th>
                            </tr>
                        </thead>
                        <tbody id="dailyStatsBody">
                            <!-- Populated by JavaScript -->
                        </tbody>
                    </table>
                </div>
            </div>
            
            <!-- Product Statistics -->
            <div class="section-card">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h2 class="section-title mb-0">상품별 집계</h2>
                    <select class="sort-select" id="productSort">
                        <option value="revenue">판매금액순</option>
                        <option value="quantity">판매수량순</option>
                        <option value="name">상품명순</option>
                    </select>
                </div>
                <div class="table-wrapper">
                    <table class="table">
                        <thead>
                            <tr>
                                <th style="width: 15%;">상품번호</th>
                                <th style="width: 30%;">상품명</th>
                                <th style="width: 20%;">브랜드</th>
                                <th style="width: 17.5%;" class="text-right">판매수량</th>
                                <th style="width: 17.5%;" class="text-right">할인 전 판매금액</th>
                            </tr>
                        </thead>
                        <tbody id="productStatsBody">
                            <!-- Populated by JavaScript -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

</body>
</html>