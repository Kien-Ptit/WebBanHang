<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Kien Store</title>
    
    <link rel="stylesheet" href="<c:url value='/css-admin/admin.css'/>">
    <link rel="stylesheet" href="<c:url value='/css-admin/admin-responsive.css'/>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    
    <div class="admin-wrapper">
        
        <jsp:include page="sidebar.jsp" />
        
        <main class="admin-main">
            
            <header class="admin-header">
                <button class="mobile-menu-toggle" onclick="toggleMobileSidebar()">
                    <i class="fas fa-bars"></i>
                </button>
                
                <h1 class="header-title">
                    <i class="fas fa-chart-line"></i> Dashboard
                </h1>
                
                <div class="header-actions">
                    <div class="header-user">
                        <div class="user-avatar">
                            ${sessionScope.user.fullname.substring(0,1).toUpperCase()}
                        </div>
                        <div>
                            <div style="font-weight: 600;">${sessionScope.user.fullname}</div>
                            <div style="font-size: 0.875rem; color: #6c757d;">Admin</div>
                        </div>
                    </div>
                </div>
            </header>
            
            <div class="admin-content">
                
                <c:if test="${not empty sessionScope.success}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i>
                        ${sessionScope.success}
                    </div>
                    <c:remove var="success" scope="session"/>
                </c:if>
                
                <c:if test="${not empty sessionScope.error}">
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-circle"></i>
                        ${sessionScope.error}
                    </div>
                    <c:remove var="error" scope="session"/>
                </c:if>
                
                <div class="stats-grid">
                    
                    <div class="stat-card info">
                        <div class="stat-header">
                            <div class="stat-title">Đơn hàng hôm nay</div>
                            <div class="stat-icon info">
                                <i class="fas fa-shopping-cart"></i>
                            </div>
                        </div>
                        <div class="stat-value">${todayOrders != null ? todayOrders : 0}</div>
                        <div class="stat-change up">
                            <i class="fas fa-arrow-up"></i>
                            <span>Đơn mới</span>
                        </div>
                    </div>
                    
                    <div class="stat-card success">
                        <div class="stat-header">
                            <div class="stat-title">Doanh thu hôm nay</div>
                            <div class="stat-icon success">
                                <i class="fas fa-dollar-sign"></i>
                            </div>
                        </div>
                        <div class="stat-value">
                            <fmt:formatNumber value="${todayRevenue != null ? todayRevenue : 0}" 
                                            type="currency" 
                                            currencyCode="VND" 
                                            minFractionDigits="0"/>
                        </div>
                        <div class="stat-change up">
                            <i class="fas fa-arrow-up"></i>
                            <span>Tăng trưởng tốt</span>
                        </div>
                    </div>
                    
                    <div class="stat-card primary">
                        <div class="stat-header">
                            <div class="stat-title">Tổng sản phẩm</div>
                            <div class="stat-icon primary">
                                <i class="fas fa-box"></i>
                            </div>
                        </div>
                        <div class="stat-value">${totalProducts != null ? totalProducts : 0}</div>
                        <div class="stat-change">
                            <i class="fas fa-info-circle"></i>
                            <span>Sản phẩm đang bán</span>
                        </div>
                    </div>
                    
                    <div class="stat-card warning">
                        <div class="stat-header">
                            <div class="stat-title">Đơn chờ xử lý</div>
                            <div class="stat-icon warning">
                                <i class="fas fa-clock"></i>
                            </div>
                        </div>
                        <div class="stat-value">${pendingOrders != null ? pendingOrders : 0}</div>
                        <div class="stat-change">
                            <i class="fas fa-exclamation-triangle"></i>
                            <span>Cần xử lý</span>
                        </div>
                    </div>
                    
                </div>
                
                <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 1.5rem; margin-bottom: 2rem;">
                    
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">
                                <i class="fas fa-chart-area"></i>
                                Doanh thu 7 ngày gần đây
                            </h3>
                        </div>
                        <div class="card-body">
                            <canvas id="revenueChart" height="100"></canvas>
                        </div>
                    </div>
                    
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">
                                <i class="fas fa-info-circle"></i>
                                Thống kê tổng quan
                            </h3>
                        </div>
                        <div class="card-body">
                            <div style="display: flex; flex-direction: column; gap: 1rem;">
                                
                                <div style="display: flex; justify-content: space-between; padding: 0.75rem; background: #f8f9fa; border-radius: 8px;">
                                    <span style="font-weight: 600; color: #6c757d;">Tổng đơn hàng:</span>
                                    <span style="font-weight: 700; color: #2c3e50;">${totalOrders != null ? totalOrders : 0}</span>
                                </div>
                                
                                <div style="display: flex; justify-content: space-between; padding: 0.75rem; background: #f8f9fa; border-radius: 8px;">
                                    <span style="font-weight: 600; color: #6c757d;">Tổng người dùng:</span>
                                    <span style="font-weight: 700; color: #2c3e50;">${totalUsers != null ? totalUsers : 0}</span>
                                </div>
                                
                                <div style="display: flex; justify-content: space-between; padding: 0.75rem; background: #f8f9fa; border-radius: 8px;">
                                    <span style="font-weight: 600; color: #6c757d;">User mới hôm nay:</span>
                                    <span style="font-weight: 700; color: #27ae60;">${todayNewUsers != null ? todayNewUsers : 0}</span>
                                </div>
                                
                                <div style="display: flex; justify-content: space-between; padding: 0.75rem; background: #e7f3ff; border-radius: 8px; border: 2px solid #3498db;">
                                    <span style="font-weight: 600; color: #3498db;">Tổng doanh thu:</span>
                                    <span style="font-weight: 700; color: #3498db;">
                                        <fmt:formatNumber value="${totalRevenue != null ? totalRevenue : 0}" 
                                                        type="currency" 
                                                        currencyCode="VND" 
                                                        minFractionDigits="0"/>
                                    </span>
                                </div>
                                
                            </div>
                        </div>
                    </div>
                    
                </div>
                
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem;">
                    
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">
                                <i class="fas fa-receipt"></i>
                                Đơn hàng gần đây
                            </h3>
                            <a href="<c:url value='/Admin/orders'/>" class="btn btn-sm btn-primary">
                                Xem tất cả
                            </a>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="admin-table">
                                    <thead>
                                        <tr>
                                            <th>Mã đơn</th>
                                            <th>Khách hàng</th>
                                            <th>Tổng tiền</th>
                                            <th>Trạng thái</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="order" items="${recentOrders}" varStatus="status">
                                            <c:if test="${status.index < 5}">
                                                <tr>
                                                    <td>
                                                        <a href="<c:url value='/Admin/orders?action=view&id=${order.id}'/>" 
                                                           style="color: #667eea; font-weight: 600;">
                                                            #OD-${order.id}
                                                        </a>
                                                    </td>
                                                    <td>${order.fullname}</td>
                                                    <td>
                                                        <fmt:formatNumber value="${order.finalAmount}" 
                                                                        type="currency" 
                                                                        currencyCode="VND" 
                                                                        minFractionDigits="0"/>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${order.status eq 'Pending'}">
                                                                <span class="badge badge-warning">Chờ xác nhận</span>
                                                            </c:when>
                                                            <c:when test="${order.status eq 'Processing'}">
                                                                <span class="badge badge-primary">Đang xử lý</span>
                                                            </c:when>
                                                            <c:when test="${order.status eq 'Completed'}">
                                                                <span class="badge badge-success">Hoàn thành</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge badge-danger">Đã hủy</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </c:forEach>
                                        
                                        <c:if test="${empty recentOrders}">
                                            <tr>
                                                <td colspan="4" style="text-align: center; padding: 2rem; color: #6c757d;">
                                                    <i class="fas fa-inbox" style="font-size: 2rem; margin-bottom: 0.5rem; display: block;"></i>
                                                    Chưa có đơn hàng nào
                                                </td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">
                                <i class="fas fa-fire"></i>
                                Sản phẩm bán chạy
                            </h3>
                            <a href="<c:url value='/Admin/products'/>" class="btn btn-sm btn-primary">
                                Xem tất cả
                            </a>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="admin-table">
                                    <thead>
                                        <tr>
                                            <th>Sản phẩm</th>
                                            <th>Đã bán</th>
                                            <th>Doanh thu</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="product" items="${bestSellers}">
                                            <tr>
                                                <td>
                                                    <div style="display: flex; align-items: center; gap: 0.75rem;">
                                                        <img src="${product.imageUrl}" 
                                                             alt="${product.name}"
                                                             style="width: 40px; height: 40px; border-radius: 6px; object-fit: cover;">
                                                        <span style="font-weight: 600;">${product.name}</span>
                                                    </div>
                                                </td>
                                                <td>
                                                    <span style="font-weight: 600; color: #667eea;">
                                                        ${product.soldCount}
                                                    </span>
                                                </td>
                                                <td>
                                                    <fmt:formatNumber value="${product.revenue}" 
                                                                    type="currency" 
                                                                    currencyCode="VND" 
                                                                    minFractionDigits="0"/>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        
                                        <c:if test="${empty bestSellers}">
                                            <tr>
                                                <td colspan="3" style="text-align: center; padding: 2rem; color: #6c757d;">
                                                    <i class="fas fa-box-open" style="font-size: 2rem; margin-bottom: 0.5rem; display: block;"></i>
                                                    Chưa có dữ liệu
                                                </td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    
                </div>
                
            </div>
            
        </main>
        
    </div>
    
    <script>
        const revenueData = ${not empty revenueChartData ? revenueChartData : '{"labels":[],"data":[]}'};
        
        const ctx = document.getElementById('revenueChart').getContext('2d');
        new Chart(ctx, {
            type: 'line',
            data: {
                labels: revenueData.labels || [],
                datasets: [{
                    label: 'Doanh thu (VNĐ)',
                    data: revenueData.data || [],
                    backgroundColor: 'rgba(102, 126, 234, 0.1)',
                    borderColor: 'rgba(102, 126, 234, 1)',
                    borderWidth: 2,
                    fill: true,
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: true,
                plugins: {
                    legend: {
                        display: true,
                        position: 'top',
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return new Intl.NumberFormat('vi-VN', {
                                    style: 'currency',
                                    currency: 'VND',
                                    minimumFractionDigits: 0
                                }).format(value);
                            }
                        }
                    }
                }
            }
        });
    </script>
    
</body>
</html>