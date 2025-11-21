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
    <title>Quản lý đơn hàng - Admin</title>
    
    <link rel="stylesheet" href="<c:url value='/css-admin/admin.css'/>">
    <link rel="stylesheet" href="<c:url value='/css-admin/admin-responsive.css'/>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
                    <i class="fas fa-shopping-cart"></i> Quản lý đơn hàng
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
                
                <div class="card" style="margin-bottom: 1.5rem;">
                    <div class="card-body">
                        <div style="display: flex; gap: 1rem; flex-wrap: wrap; align-items: center;">
                            
                            <form method="get" action="<c:url value='/Admin/orders'/>" style="flex: 1; min-width: 300px;">
                                <div style="display: flex; gap: 0.5rem;">
                                    <input type="text" 
                                           name="search" 
                                           class="form-control" 
                                           placeholder="Tìm theo mã đơn, tên khách..."
                                           value="${searchQuery}"
                                           style="flex: 1;">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-search"></i> Tìm
                                    </button>
                                </div>
                            </form>
                            
                            <div style="display: flex; gap: 0.5rem; flex-wrap: wrap;">
                                <a href="<c:url value='/Admin/orders'/>" 
                                   class="btn ${empty currentStatus ? 'btn-primary' : 'btn-secondary'}">
                                    Tất cả
                                </a>
                                <a href="<c:url value='/Admin/orders?status=Pending'/>" 
                                   class="btn ${currentStatus eq 'Pending' ? 'btn-primary' : 'btn-secondary'}">
                                    Chờ xử lý
                                </a>
                                <a href="<c:url value='/Admin/orders?status=Processing'/>" 
                                   class="btn ${currentStatus eq 'Processing' ? 'btn-primary' : 'btn-secondary'}">
                                    Đang xử lý
                                </a>
                                <a href="<c:url value='/Admin/orders?status=Completed'/>" 
                                   class="btn ${currentStatus eq 'Completed' ? 'btn-primary' : 'btn-secondary'}">
                                    Hoàn thành
                                </a>
                                <a href="<c:url value='/Admin/orders?status=Cancelled'/>" 
                                   class="btn ${currentStatus eq 'Cancelled' ? 'btn-primary' : 'btn-secondary'}">
                                    Đã hủy
                                </a>
                            </div>
                            
                        </div>
                    </div>
                </div>
                
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">Danh sách đơn hàng</h3>
                        <span class="badge badge-primary">${fn:length(orders)} đơn</span>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="admin-table">
                                <thead>
                                    <tr>
                                        <th>Mã đơn</th>
                                        <th>Khách hàng</th>
                                        <th>SĐT</th>
                                        <th>Ngày đặt</th>
                                        <th>Tổng tiền</th>
                                        <th>Thanh toán</th>
                                        <th>Trạng thái</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="order" items="${orders}">
                                        <tr>
                                            <td>
                                                <a href="<c:url value='/Admin/orders?action=view&id=${order.id}'/>"
                                                   style="color: #667eea; font-weight: 700;">
                                                    #OD-${order.id}
                                                </a>
                                            </td>
                                            <td style="font-weight: 600;">${order.fullname}</td>
                                            <td>${order.phone}</td>
                                            <td>
                                                <fmt:formatDate value="${order.createdAt}" 
                                                              pattern="dd/MM/yyyy HH:mm"/>
                                            </td>
                                            <td style="font-weight: 700; color: #27ae60;">
                                                <fmt:formatNumber value="${order.finalAmount}" 
                                                                type="currency" 
                                                                currencyCode="VND" 
                                                                minFractionDigits="0"/>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${order.paymentStatus eq 'PAID'}">
                                                        <span class="badge badge-success">Đã thanh toán</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-warning">Chưa TT</span>
                                                    </c:otherwise>
                                                </c:choose>
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
                                            <td>
                                                <a href="<c:url value='/Admin/orders?action=view&id=${order.id}'/>"
                                                   class="btn btn-sm btn-primary">
                                                    <i class="fas fa-eye"></i> Xem
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    
                                    <c:if test="${empty orders}">
                                        <tr>
                                            <td colspan="8" style="text-align: center; padding: 3rem; color: #6c757d;">
                                                <i class="fas fa-inbox" style="font-size: 3rem; display: block; margin-bottom: 1rem;"></i>
                                                Không tìm thấy đơn hàng nào
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                
            </div>
            
        </main>
        
    </div>
    
</body>
</html>