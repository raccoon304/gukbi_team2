<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%String ctxPath=request.getContextPath();%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0 shrink-to-fit=no">
    <title>회원 관리 - PhoneStore 관리자</title>
    
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
    <script src="<%=ctxPath%>/js/admin/members.js"></script>
    
</head>
<body>
    <div class="wrapper">
        <jsp:include page="/WEB-INF/admin/admin_sidebar.jsp" />
        
        <div class="main-content">
            <jsp:include page="/WEB-INF/admin/admin_header.jsp" />
            
            <div class="content-wrapper">
                <div class="container-fluid p-4">
                    <div class="mb-4">
                        <h2 class="mb-2">가입회원 조회/관리</h2>
                        <p class="text-muted">회원 정보를 조회하고 관리할 수 있습니다</p>
                    </div>
                    
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">회원 목록</h5>
                        </div>
                        <div class="card-body">
                            <div class="row mb-3">
                                <div class="col-md-3">
                                <form name="member_search_frm">
	                                    <select class="form-control" id="searchType" name="searchType">
	                                    	<option value="">검색대상</option>
	                                        <option value="userid">아이디</option>
	                                        <option value="name">이름</option>
	                                        <option value="email">이메일</option>
	                                    </select>
	                                </div>
	                                <div class="col-md-6">
	                                    <div class="input-group">
	                                        <input type="text" class="form-control" id="searchWord" name="searchWord" placeholder="검색"></input>
	                                        <div class="input-group-append">
	                                            <button class="btn btn-outline-secondary" id="searchBtn">
	                                                <i class="fas fa-search"></i> 검색
	                                            </button>
	                                        </div>
	                                    </div>
	                                </div>
	                                <div class="col-md-3">
	                                    <select class="form-control" id="sizePerPage" name="sizePerPage">
	                                    	<option value="10">10명씩 보기</option>
	                                    	<option value="5">5명씩 보기</option>
	                                    	<option value="3">3명씩 보기</option>	                             
	                                    </select>
	                                </div>
                                </form>
                            </div>
                            
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>아이디</th>
                                            <th>이름</th>
                                            <th>이메일</th>
                                            <th>전화번호</th>
                                            <th>가입일</th>
                                            <th>주문건수</th>
                                            <th>총 구매액</th>
                                        </tr>
                                    </thead>
                                    <tbody id="memberTableBody"></tbody>
                                </table>
                            </div>
                            
                            <nav>
                                <ul class="pagination justify-content-center" id="pagination"></ul>
                            </nav>
                            
                            <div id="pageBar">
							   <nav>
							  	  <ul class="pagination">${requestScope.pageBar}</ul>
							   </nav>
						    </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
   
</body>
</html>