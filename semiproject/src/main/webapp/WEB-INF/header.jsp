<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%String ctxPath=request.getContextPath();%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <title>쇼핑몰 메인임시</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Bootstrap CSS -->
	<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css">

    <!-- Font Awesome 6 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.1/css/all.min.css">

	<!-- 사용자 CSS -->
    <link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/product_TH/index.css">
    
    <script>const ctxPath = "<%= ctxPath %>";</script>
    <!-- JS -->
	<script type="text/javascript" src="<%=ctxPath%>/js/jquery-3.7.1.min.js"></script>
	<script type="text/javascript" src="<%=ctxPath%>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js" ></script>
	
	<!-- 사용자 JS -->
	<script type="text/javascript" src="<%=ctxPath%>/js/product_TH/index.js"></script>
    
    
	<%-- jQueryUI CSS 및 JS --%>
	<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/jquery-ui-1.13.1.custom/jquery-ui.min.css" />
	<script type="text/javascript" src="<%=ctxPath%>/jquery-ui-1.13.1.custom/jquery-ui.min.js"></script>
	
	<style>
	.navbar {
  	height: 70px;
 	padding: 0 24px;
	}
	
	.navbar .container {
  	height: 100%;
  	display: flex;
  	align-items: center;
	}
</style>
</head>



<body>
<!-- 네비게이션 -->
<nav class="navbar navbar-expand-lg navbar-custom sticky-top">
    <div class="container">
    	<!-- 로고부분 -->
        <a class="navbar-brand" href="<%=ctxPath%>/index.hp">
            <i class="fa-solid fa-store mr-2"></i>ShopMall
        </a>

        <button class="navbar-toggler" type="button" data-toggle="collapse">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
            <!-- 왼쪽정렬 해주기 -->
            <ul class="navbar-nav mr-auto">
                <li class="nav-item">
                    <a class="nav-link" href="<%=ctxPath%>/product/productList.hp">
                        <i class="fa-solid fa-list"></i> 상품목록
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%=ctxPath%>/cart/zangCart.hp">
                        <i class="fa-solid fa-cart-shopping"></i> 장바구니
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%=ctxPath%>/index.hp">
                        <i class="fa-solid fa-headset"></i> 고객센터
                    </a>
                </li>
                
                <%-- <li class="nav-item">
                    <a class="nav-link" href="<%=ctxPath%>/index.hp">
                        <i class="fa-solid fa-user"></i> 마이페이지
                    </a>
                </li> --%>
                
                <li class="nav-item">
                    <a class="nav-link" href="<%=ctxPath%>/index.hp">
                        <i class="fa-solid fa-gear"></i> 관리자페이지
                    </a>
                </li>
            </ul>


			<!-- 오른쪽정렬 해주기 -->
            <div class="ml-3">
                <button class="btn btn-login" id="loginBtn">
                    <i class="fa-solid fa-right-to-bracket"></i> 로그인
                </button>
                <button class="btn btn-signup" id="signupBtn">
                    <i class="fa-solid fa-user-plus"></i> 회원가입
                </button>
            </div>
        </div>
    </div>
</nav>


<!-- 로그인 모달 -->
<div class="modal fade" id="loginModal" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog modal-dialog" role="document" style="margin-top: 10%">
        <div class="modal-content">

            <!-- 모달 헤더 -->
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fa-solid fa-right-to-bracket mr-2"></i>로그인
                </h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>

            <!-- 모달 바디 -->
            <div class="modal-body">
                <form id="loginForm">

                    <!-- 아이디 -->
                    <div class="form-group">
                        <label for="loginId">아이디</label>
                        <input type="text" class="form-control" id="loginId" placeholder="아이디를 입력하세요">
                    </div>

                    <!-- 비밀번호 -->
                    <div class="form-group">
                        <label for="loginPw">비밀번호</label>
                        <input type="password" class="form-control" id="loginPw" placeholder="비밀번호를 입력하세요">
                    </div>

                    <!-- 아이디 / 비밀번호 찾기 -->
               <div class="text-center mb-3">
                   <a href="#" class="text-secondary small mr-2">
                       <i class="fa-solid fa-user-magnifying-glass mr-1"></i>아이디 찾기
                   </a>
                   <span class="text-muted mx-1">|</span>
                   <a href="#" class="text-secondary small ml-2">
                       <i class="fa-solid fa-key mr-1"></i>비밀번호 찾기
                   </a>
               </div>

                </form>
            </div>

            <!-- 모달 푸터 -->
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">
                    취소
                </button>
                <button type="button" class="btn btn-primary" onclick="login()">
                    <i class="fa-solid fa-right-to-bracket mr-1"></i>로그인
                </button>
            </div>

        </div>
    </div>
</div>

