<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    String ctxPath = request.getContextPath();
%>

<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<!-- Bootstrap CSS -->
<link rel="stylesheet"
      href="<%= ctxPath %>/bootstrap-4.6.2-dist/css/bootstrap.min.css">

<!-- Font Awesome -->
<link rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.1/css/all.min.css">

<!-- jQuery (Bootstrap 필수) -->
<script src="<%= ctxPath %>/js/jquery-3.7.1.min.js"></script>

<!-- Bootstrap JS -->
<script src="<%= ctxPath %>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js"></script>

</head>

<style>
/* === 상단 Login / Sign Up */
.top-header {
    background-color: #1a1a1a;
    padding: 8px 0;
}

.top-header .container {
    display: flex;
    justify-content: flex-end;
    align-items: center;
}

.top-header .auth-links {
    display: flex;
    gap: 16px;
}

.top-header .auth-links a {
    color: #ffffff;
    font-size: 14px;
    text-decoration: none;
    font-weight: 500;
}

.top-header .auth-links a:hover {
    color: #0d6efd;
}
</style>

<body>

    <!-- 상단 헤더 (검은색 배경) -->
    <div class="top-header">
        <div class="container">
            <div class="auth-links">
                <a href="<%= ctxPath %>/member/login.hp">Login</a>
                <a href="<%= ctxPath %>/member/signup.hp">Sign Up</a>
            </div>
        </div>
    </div>

    <!-- 메인 네비게이션 -->
    <nav class="navbar navbar-expand-lg navbar-light main-navbar">
        <div class="container">

            <!-- 로고 -->
            <a class="navbar-brand" href="<%= ctxPath %>/index.hp">
                <i class="fas fa-shopping-bag"></i> 로고
            </a>

            <!-- 모바일 토글 버튼 -->
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#mainNavbar">
                <span class="navbar-toggler-icon"></span>
            </button>

            <!-- 네비게이션 메뉴 -->
            <div class="collapse navbar-collapse" id="mainNavbar">
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" href="<%= ctxPath %>/shop/mallHome.hp">
                            <i class="fas fa-store"></i> 상품목록
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= ctxPath %>/shop/cart.hp">
                            <i class="fas fa-shopping-cart"></i> 장바구니
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= ctxPath %>/customer/notice.hp">
                            <i class="fas fa-headset"></i> 고객센터
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= ctxPath %>/member/mypage.hp">
                            <i class="fas fa-user-circle"></i> 마이페이지
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= ctxPath %>/inquiry/list.hp">
                            <i class="fas fa-question-circle"></i> 관리자페이지
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- 메인 컨텐츠 영역 시작 -->
    <div class="main-content-wrapper">