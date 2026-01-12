
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%String ctxPath=request.getContextPath();%>


<style>
    .sidebar {
        position: fixed;
        top: 0;
        left: 0;
        width: 250px;
        height: 100vh;
        background: white;
        border-right: 1px solid #e0e0e0;
        z-index: 1000;
        overflow-y: auto;
    }
    .sidebar-header {
        padding: 24px 20px;
        border-bottom: 1px solid #e0e0e0;
    }
    .sidebar-logo {
        display: flex;
        align-items: center;
        gap: 12px;
        text-decoration: none;
    }
    .sidebar-logo-icon {
        width: 40px;
        height: 40px;
        background: linear-gradient(135deg, #2196f3 0%, #3f51b5 100%);
        border-radius: 8px;
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 20px;
    }
    .sidebar-logo-text h4 {
        margin: 0;
        font-size: 18px;
        font-weight: 700;
        color: #212529;
    }
    .sidebar-logo-text p {
        margin: 0;
        font-size: 12px;
        color: #757575;
    }
    .sidebar-menu {
        padding: 16px;
    }
    .sidebar-menu-item {
        list-style: none;
        margin-bottom: 4px;
    }
    .sidebar-menu-link {
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 12px 16px;
        border-radius: 8px;
        text-decoration: none;
        color: #424242;
        font-size: 14px;
        font-weight: 500;
        transition: all 0.2s;
    }
    .sidebar-menu-link:hover {
        background: #f5f5f5;
        text-decoration: none;
        color: #212529;
    }
    .sidebar-menu-link.active {
        background: #e3f2fd;
        color: #2196f3;
    }
    .sidebar-menu-link i {
        width: 20px;
        text-align: center;
    }
    
    
    
/* 이 아래부터 메인페이지랑 비슷한 느낌으로 css 덮어씌움 */
.sidebar{
  background: #fff;
  border-right: 1px solid #e9ecef;
}

/* 로고(메인 톤) */
.sidebar .navbar-brand{
  font-size: 1.8rem;
  font-weight: 700;
  text-decoration: none;
  display: inline-flex;
  align-items: center;

  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

/* 메뉴 기본 */
.sidebar-menu-link{
  color: #495057;                 /* 메인 nav-link 기본색 */
  border-radius: 10px;
  transition: all .25s;
}

/* hover: 연한 퍼플 배경 + 텍스트 컬러 */
.sidebar-menu-link:hover{
  background: #f0f4ff;            /* 메인 nav hover 배경 */
  color: #667eea;                 /* 메인 포인트 */
}

/* active: hover보다 살짝 진하게 + 왼쪽 포인트 바 */
.sidebar-menu-link.active{
  background: rgba(102, 126, 234, 0.14);  /* #667eea 계열 연하게 */
  color: #667eea;
  position: relative;
}

/* active 왼쪽 포인트*/
.sidebar-menu-link.active::before{
  content: "";
  position: absolute;
  left: 0;
  top: 10px;
  bottom: 10px;
  width: 4px;
  border-radius: 4px;
  background: #667eea;
}

/* 아이콘*/
.sidebar-menu-link i{
  color: inherit;
  opacity: 0.95;
}

/* 메뉴 간격 */
.sidebar-menu{
  padding: 14px;
}
.sidebar-menu-item{
  margin-bottom: 6px;
}
    
</style>

<div class="sidebar">
    <div class="sidebar-header">
        
	   <a class="navbar-brand" href="<%=ctxPath%>/index.hp">
	   <i class="fa-solid fa-store mr-2"></i>ShopMall
	   </a>
       
    </div>
    <ul class="sidebar-menu">
        <li class="sidebar-menu-item">
            <a class="sidebar-menu-link <%= request.getRequestURI().contains("dashboard") ? "active" : "" %>" 
               href="<%= ctxPath %>/admin/adminpage.hp">
                <i class="fas fa-th-large"></i>
                <span>대시보드</span>
            </a>
        </li>
        <li class="sidebar-menu-item">
            <a class="sidebar-menu-link <%= request.getRequestURI().contains("members") ? "active" : "" %>" 
               href="<%=ctxPath%>/product/productRegister.hp">
                <i class="fa-solid fa-cart-plus"></i>
                <span>상품등록</span>
            </a>
        </li>
        <li class="sidebar-menu-item">
            <a class="sidebar-menu-link <%= request.getRequestURI().contains("members") ? "active" : "" %>" 
               href="<%= ctxPath %>/admin/members.hp">
                <i class="fas fa-users"></i>
                <span>가입회원조회</span>
            </a>
        </li>
        <li class="sidebar-menu-item">
            <a class="sidebar-menu-link <%= request.getRequestURI().contains("coupons") ? "active" : "" %>" 
               href="<%= ctxPath %>/admin/coupon.hp">
                <i class="fas fa-ticket-alt"></i>
                <span>쿠폰 관리</span>
            </a>
        </li>
        <li class="sidebar-menu-item">
            <a class="sidebar-menu-link <%= request.getRequestURI().contains("accounting") ? "active" : "" %>" 
               href="<%= ctxPath %>/admin/accounting.hp">
                <i class="fas fa-calculator"></i>
                <span>회계</span>
            </a>
        </li>
    </ul>
</div>
