<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>

/* 메인과 비슷하게 하기 위한 css */
/* 헤더 배경/경계선/그림자 톤*/
.top-header{
  background: #fff;                         /* 메인 navbar처럼 흰색 */
  border-bottom: 1px solid #e9ecef;         /* 은은한 라인 */
}

/* 헤더 제목을 메인 로고 톤으로 (텍스트만 변경) */
.top-header h5{
  font-weight: 700; /* 크기 안 바꾸고 두께만 */
  background: linear-gradient(180deg, #2c3e50 0%, #34495e 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

/* 우측 “관리자 로그인중” 영역: hover만 메인 느낌 */
.top-header .dropdown{
  color: #495057; /* 메인 nav-link 기본색 */
  font-weight: 600;
}

/* 아이콘 색도 메인 포인트 */
.top-header .dropdown i{
  color: #667eea;
  cursor: pointer;
}


	

</style>

<div class="top-header">
    <div class="d-flex justify-content-between align-items-center">
        <h5 class="mb-0">관리자 페이지</h5>
        <div class="dropdown">
        		<i class="fas fa-user-circle mr-2" data-toggle="dropdown"></i>관리자 로그인중
        <%--
            <button class="btn btn-link text-dark dropdown-toggle" type="button" data-toggle="dropdown">
                <i class="fas fa-user-circle mr-2"></i>관리자 로그인중
            </button>
            <ul class="dropdown-menu dropdown-menu-right">
                <li><a class="dropdown-item" href="#"><i class="fas fa-cog me-2"></i>설정</a></li>
                <li><hr class="dropdown-divider"></li>
                <li><a class="dropdown-item" href="#"><i class="fas fa-sign-out-alt me-2"></i>로그아웃</a></li>
            </ul>
       --%>     
        </div>
    </div>
</div>
