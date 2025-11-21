<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thống kê - Admin</title>
    
    <link rel="stylesheet" href="<c:url value='/css-admin/admin.css'/>">
    <link rel="stylesheet" href="<c:url value='/css-admin/admin-responsive.css'/>">
    <link rel="stylesheet" href="<c:url value='/css-admin/statistics.css'/>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>

<div class="admin-wrapper">
    
    <jsp:include page="sidebar.jsp" />
    
    <main class="admin-main">
        
        <header class="admin-header">
            <h1 class="header-title">
                <i class="fas fa-chart-bar"></i> Thống kê & Báo cáo
            </h1>
            
            <div class="header-actions">
                <select class="form-control" onchange="window.location.href='<c:url value="/Admin/statistics"/>?period=' + this.value" style="max-width: 200px;">
                    <option value="today" ${period eq 'today' ? 'selected' : ''}>Hôm nay</option>
                    <option value="week" ${period eq 'week' ? 'selected' : ''}>7 ngày qua</option>
                    <option value="month" ${period eq 'month' ? 'selected' : ''}>30 ngày qua</option>
                    <option value="quarter" ${period eq 'quarter' ? 'selected' : ''}>3 tháng qua</option>
                    <option value="year" ${period eq 'year' ? 'selected' : ''}>Năm nay</option>
                </select>
                
                <button class="btn btn-primary" onclick="window.print()">
                    <i class="fas fa-print"></i> In báo cáo
                </button>
            </div>
        </header>
        
        <div class="admin-content">
            
            <!-- Overview Stats -->
            <div class="stats-grid">
                <div class="stat-card primary">
                    <div class="stat-header">
                        <div class="stat-title">Tổng doanh thu</div>
                        <div class="stat-icon primary">
                            <i class="fas fa-dollar-sign"></i>
                        </div>
                    </div>
                    <div class="stat-value">
                        <fmt:formatNumber value="${overview.totalRevenue}" pattern="#,###"/>₫
                    </div>
                    <div class="stat-footer">
                        <i class="fas fa-calendar-alt"></i> 
                        <fmt:formatDate value="${startDate}" pattern="dd/MM"/> - <fmt:formatDate value="${endDate}" pattern="dd/MM/yyyy"/>
                    </div>
                </div>
                
                <div class="stat-card success">
                    <div class="stat-header">
                        <div class="stat-title">Tổng đơn hàng</div>
                        <div class="stat-icon success">
                            <i class="fas fa-shopping-cart"></i>
                        </div>
                    </div>
                    <div class="stat-value">${overview.totalOrders}</div>
                    <div class="stat-footer">
                        <i class="fas fa-chart-line"></i> 
                        Đơn hàng hoàn thành
                    </div>
                </div>
                
                <div class="stat-card warning">
                    <div class="stat-header">
                        <div class="stat-title">Khách hàng mới</div>
                        <div class="stat-icon warning">
                            <i class="fas fa-users"></i>
                        </div>
                    </div>
                    <div class="stat-value">${overview.newCustomers}</div>
                    <div class="stat-footer">
                        <i class="fas fa-user-plus"></i> 
                        Đăng ký mới
                    </div>
                </div>
                
                <div class="stat-card info">
                    <div class="stat-header">
                        <div class="stat-title">Đơn trung bình</div>
                        <div class="stat-icon info">
                            <i class="fas fa-receipt"></i>
                        </div>
                    </div>
                    <div class="stat-value">
                        <fmt:formatNumber value="${overview.avgOrderValue}" pattern="#,###"/>₫
                    </div>
                    <div class="stat-footer">
                        <i class="fas fa-calculator"></i> 
                        Giá trị TB
                    </div>
                </div>
            </div>
            
            <!-- Charts Row -->
            <div class="charts-grid">
                <!-- Revenue Chart -->
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-chart-line"></i> Doanh thu 30 ngày qua
                        </h3>
                    </div>
                    <div class="card-body">
                        <canvas id="revenueChart"></canvas>
                    </div>
                </div>
                
                <!-- Orders by Status -->
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-chart-pie"></i> Đơn hàng theo trạng thái
                        </h3>
                    </div>
                    <div class="card-body">
                        <canvas id="statusChart"></canvas>
                    </div>
                </div>
            </div>
            
            <!-- Monthly Stats Chart -->
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">
                        <i class="fas fa-chart-area"></i> Thống kê 12 tháng gần nhất
                    </h3>
                </div>
                <div class="card-body">
                    <canvas id="monthlyChart"></canvas>
                </div>
            </div>
            
            <!-- Top Products & Customers -->
            <div class="tables-grid">
                <!-- Top Products -->
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-fire"></i> Top 10 sản phẩm bán chạy
                        </h3>
                    </div>
                    <div class="card-body">
                        <table class="admin-table">
                            <thead>
                                <tr>
                                    <th>STT</th>
                                    <th>Sản phẩm</th>
                                    <th>Số lượng</th>
                                    <th>Doanh thu</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="product" items="${topProducts}" varStatus="status">
                                    <tr>
                                        <td>${status.count}</td>
                                        <td>${product.name}</td>
                                        <td><strong>${product.quantity}</strong></td>
                                        <td>
                                            <fmt:formatNumber value="${product.revenue}" pattern="#,###"/>₫
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
                
                <!-- Top Customers -->
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-crown"></i> Top 10 khách hàng
                        </h3>
                    </div>
                    <div class="card-body">
                        <table class="admin-table">
                            <thead>
                                <tr>
                                    <th>STT</th>
                                    <th>Khách hàng</th>
                                    <th>Đơn hàng</th>
                                    <th>Tổng tiền</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="customer" items="${topCustomers}" varStatus="status">
                                    <tr>
                                        <td>${status.count}</td>
                                        <td>${customer.name}</td>
                                        <td><strong>${customer.orders}</strong></td>
                                        <td>
                                            <fmt:formatNumber value="${customer.total}" pattern="#,###"/>₫
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            
        </div>
        
    </main>
    
</div>

<script>
// Revenue Chart (Line)
const revenueCtx = document.getElementById('revenueChart').getContext('2d');
new Chart(revenueCtx, {
    type: 'line',
    data: {
        labels: [<c:forEach var="day" items="${dailyRevenue}">'${day.date}',</c:forEach>],
        datasets: [{
            label: 'Doanh thu (₫)',
            data: [<c:forEach var="day" items="${dailyRevenue}">${day.revenue},</c:forEach>],
            borderColor: '#667eea',
            backgroundColor: 'rgba(102, 126, 234, 0.1)',
            tension: 0.4,
            fill: true
        }]
    },
    options: {
        responsive: true,
        plugins: {
            legend: { display: true }
        },
        scales: {
            y: { beginAtZero: true }
        }
    }
});

// Status Chart (Pie)
const statusCtx = document.getElementById('statusChart').getContext('2d');
new Chart(statusCtx, {
    type: 'doughnut',
    data: {
        labels: ['Chờ xử lý', 'Đang xử lý', 'Đang giao', 'Hoàn thành', 'Đã hủy'],
        datasets: [{
            data: [
                ${ordersByStatus['pending'] != null ? ordersByStatus['pending'] : 0},
                ${ordersByStatus['processing'] != null ? ordersByStatus['processing'] : 0},
                ${ordersByStatus['shipping'] != null ? ordersByStatus['shipping'] : 0},
                ${ordersByStatus['delivered'] != null ? ordersByStatus['delivered'] : 0},
                ${ordersByStatus['cancelled'] != null ? ordersByStatus['cancelled'] : 0}
            ],
            backgroundColor: ['#f39c12', '#3498db', '#9b59b6', '#27ae60', '#e74c3c']
        }]
    }
});

// Monthly Chart (Bar)
const monthlyCtx = document.getElementById('monthlyChart').getContext('2d');
new Chart(monthlyCtx, {
    type: 'bar',
    data: {
        labels: [<c:forEach var="month" items="${monthlyStats}">'Tháng ${month.month}',</c:forEach>],
        datasets: [{
            label: 'Doanh thu (₫)',
            data: [<c:forEach var="month" items="${monthlyStats}">${month.revenue},</c:forEach>],
            backgroundColor: '#667eea'
        }, {
            label: 'Đơn hàng',
            data: [<c:forEach var="month" items="${monthlyStats}">${month.orders},</c:forEach>],
            backgroundColor: '#26de81'
        }]
    },
    options: {
        responsive: true,
        scales: {
            y: { beginAtZero: true }
        }
    }
});
</script>

</body>
</html>