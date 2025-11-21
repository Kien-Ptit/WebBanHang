<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<!-- ===== ADMIN SIDEBAR ===== -->
<aside class="admin-sidebar" id="adminSidebar">
    <div class="sidebar-header">
        <a href="<c:url value='/Admin/dashboard'/>" class="sidebar-logo">
            <i class="fas fa-store"></i>
            <span>Kien Store Admin</span>
        </a>
    </div>
    
    <nav class="sidebar-nav">
        <div class="nav-item">
            <a href="<c:url value='/Admin/dashboard'/>" class="nav-link ${pageContext.request.requestURI.contains('admin') ? 'active' : ''}">
                <i class="fas fa-chart-line"></i>
                <span>Dashboard</span>
            </a>
        </div>
        
        <div class="nav-item">
            <a href="<c:url value='/Admin/products'/>" class="nav-link ${pageContext.request.requestURI.contains('product') ? 'active' : ''}">
                <i class="fas fa-box"></i>
                <span>Sản phẩm</span>
            </a>
        </div>
        
        <div class="nav-item">
            <a href="<c:url value='/Admin/orders'/>" class="nav-link ${pageContext.request.requestURI.contains('order') ? 'active' : ''}">
                <i class="fas fa-shopping-cart"></i>
                <span>Đơn hàng</span>
                <c:if test="${not empty pendingOrders && pendingOrders > 0}">
                    <span class="badge badge-danger" style="margin-left: auto;">
                        ${pendingOrders}
                    </span>
                </c:if>
            </a>
        </div>
        
        <div class="nav-item">
            <a href="<c:url value='/Admin/users'/>" class="nav-link ${pageContext.request.requestURI.contains('user') ? 'active' : ''}">
                <i class="fas fa-users"></i>
                <span>Người dùng</span>
            </a>
        </div>
        
        <div class="nav-item">
            <a href="<c:url value='/Admin/categories'/>" class="nav-link ${pageContext.request.requestURI.contains('categor') ? 'active' : ''}">
                <i class="fas fa-tags"></i>
                <span>Danh mục</span>
            </a>
        </div>
        
        <div class="nav-item">
            <a href="<c:url value='/Admin/statistics'/>" class="nav-link ${pageContext.request.requestURI.contains('statistic') ? 'active' : ''}">
                <i class="fas fa-chart-bar"></i>
                <span>Thống kê</span>
            </a>
        </div>
        
        <div class="nav-item">
            <a href="<c:url value='/Admin/settings'/>" class="nav-link ${pageContext.request.requestURI.contains('setting') ? 'active' : ''}">
                <i class="fas fa-cog"></i>
                <span>Cài đặt</span>
            </a>
        </div>
        
        <hr style="border-color: rgba(255,255,255,0.1); margin: 1rem 0;">
        
        <div class="nav-item">
            <a href="<c:url value='/'/>" class="nav-link">
                <i class="fas fa-home"></i>
                <span>Về trang chủ</span>
            </a>
        </div>
        
        <div class="nav-item">
            <a href="<c:url value='/logout'/>" class="nav-link">
                <i class="fas fa-sign-out-alt"></i>
                <span>Đăng xuất</span>
            </a>
        </div>
    </nav>
</aside>

<!-- Mobile Overlay -->
<div class="mobile-overlay" id="mobileOverlay" onclick="toggleMobileSidebar()"></div>

<script>
function toggleMobileSidebar() {
    const sidebar = document.getElementById('adminSidebar');
    const overlay = document.getElementById('mobileOverlay');
    sidebar.classList.toggle('show');
    overlay.classList.toggle('show');
}
</script>