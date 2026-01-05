
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
