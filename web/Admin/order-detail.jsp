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
    <title>Chi tiết đơn #OD-${order.id} - Admin</title>
    
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
                    <i class="fas fa-receipt"></i> Chi tiết đơn hàng #OD-${order.id}
                </h1>
                
                <div class="header-actions">
                    <a href="<c:url value='/Admin/orders'/>" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Quay lại
                    </a>
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
                    <div class="card-header">
                        <h3 class="card-title">Cập nhật đơn hàng</h3>
                    </div>
                    <div class="card-body">
                        <form method="post" action="<c:url value='/Admin/orders'/>">
                            <input type="hidden" name="action" value="updateStatus">
                            <input type="hidden" name="id" value="${order.id}">
                            
                            <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 1rem;">
                                
                                <div class="form-group">
                                    <label class="form-label">Trạng thái đơn hàng</label>
                                    <select name="status" class="form-control">
                                        <option value="Pending" ${order.status eq 'Pending' ? 'selected' : ''}>Chờ xác nhận</option>
                                        <option value="Processing" ${order.status eq 'Processing' ? 'selected' : ''}>Đang xử lý</option>
                                        <option value="Completed" ${order.status eq 'Completed' ? 'selected' : ''}>Hoàn thành</option>
                                        <option value="Cancelled" ${order.status eq 'Cancelled' ? 'selected' : ''}>Đã hủy</option>
                                    </select>
                                </div>
                                
                                <div class="form-group">
                                    <label class="form-label">Mã vận đơn</label>
                                    <input type="text" 
                                           name="trackingNumber" 
                                           class="form-control" 
                                           value="${order.trackingNumber}"
                                           placeholder="Nhập mã vận đơn">
                                </div>
                                
                                <div class="form-group" style="display: flex; align-items: flex-end;">
                                    <button type="submit" class="btn btn-primary" style="width: 100%;">
                                        <i class="fas fa-save"></i> Cập nhật
                                    </button>
                                </div>
                                
                            </div>
                        </form>
                    </div>
                </div>
                
                <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 1.5rem; margin-bottom: 1.5rem;">
                    
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">
                                <i class="fas fa-user"></i> Thông tin khách hàng
                            </h3>
                        </div>
                        <div class="card-body">
                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem;">
                                
                                <div>
                                    <div style="color: #6c757d; font-size: 0.875rem; margin-bottom: 0.25rem;">Họ và tên</div>
                                    <div style="font-weight: 700; font-size: 1.1rem;">${order.fullname}</div>
                                </div>
                                
                                <div>
                                    <div style="color: #6c757d; font-size: 0.875rem; margin-bottom: 0.25rem;">Số điện thoại</div>
                                    <div style="font-weight: 700; font-size: 1.1rem;">
                                        <a href="tel:${order.phone}" style="color: #3498db;">
                                            ${order.phone}
                                        </a>
                                    </div>
                                </div>
                                
                                <div style="grid-column: 1 / -1;">
                                    <div style="color: #6c757d; font-size: 0.875rem; margin-bottom: 0.25rem;">Địa chỉ giao hàng</div>
                                    <div style="font-weight: 600;">${order.address}</div>
                                </div>
                                
                                <c:if test="${not empty order.note}">
                                    <div style="grid-column: 1 / -1;">
                                        <div style="color: #6c757d; font-size: 0.875rem; margin-bottom: 0.25rem;">Ghi chú</div>
                                        <div style="padding: 0.75rem; background: #fff3cd; border-radius: 6px;">
                                            ${order.note}
                                        </div>
                                    </div>
                                </c:if>
                                
                            </div>
                        </div>
                    </div>
                    
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">
                                <i class="fas fa-info-circle"></i> Tóm tắt đơn hàng
                            </h3>
                        </div>
                        <div class="card-body">
                            <div style="display: flex; flex-direction: column; gap: 0.75rem;">
                                
                                <div style="display: flex; justify-content: space-between;">
                                    <span style="color: #6c757d;">Ngày đặt:</span>
                                    <span style="font-weight: 600;">
                                        <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                    </span>
                                </div>
                                
                                <div style="display: flex; justify-content: space-between;">
                                    <span style="color: #6c757d;">Trạng thái:</span>
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
                                </div>
                                
                                <div style="display: flex; justify-content: space-between;">
                                    <span style="color: #6c757d;">Thanh toán:</span>
                                    <c:choose>
                                        <c:when test="${order.paymentStatus eq 'PAID'}">
                                            <span class="badge badge-success">Đã thanh toán</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-warning">Chưa thanh toán</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                
                                <div style="display: flex; justify-content: space-between;">
                                    <span style="color: #6c757d;">Phương thức TT:</span>
                                    <span style="font-weight: 600;">
                                        <c:choose>
                                            <c:when test="${order.paymentMethod eq 'COD'}">
                                                <i class="fas fa-money-bill-wave"></i> COD
                                            </c:when>
                                            <c:when test="${order.paymentMethod eq 'EWALLET'}">
                                                <i class="fas fa-wallet"></i> ${order.ewalletType}
                                            </c:when>
                                            <c:otherwise>
                                                <i class="fas fa-university"></i> Chuyển khoản
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                
                                <c:if test="${not empty order.trackingNumber}">
                                    <div style="display: flex; justify-content: space-between; padding: 0.75rem; background: #e7f3ff; border-radius: 6px; margin-top: 0.5rem;">
                                        <span style="color: #3498db; font-weight: 600;">Mã vận đơn:</span>
                                        <span style="font-weight: 700; color: #3498db; font-family: monospace;">
                                            ${order.trackingNumber}
                                        </span>
                                    </div>
                                </c:if>
                                
                            </div>
                        </div>
                    </div>
                    
                </div>
                
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-box"></i> Sản phẩm trong đơn
                        </h3>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="admin-table">
                                <thead>
                                    <tr>
                                        <th>Sản phẩm</th>
                                        <th>Đơn giá</th>
                                        <th>Số lượng</th>
                                        <th>Thành tiền</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${orderItems}">
                                        <tr>
                                            <td>
                                                <div style="display: flex; align-items: center; gap: 1rem;">
                                                    <img src="${item.productImage}" 
                                                         alt="${item.productName}"
                                                         style="width: 60px; height: 60px; border-radius: 8px; object-fit: cover; border: 2px solid #e9ecef;"
                                                         onerror="this.src='${ctx}/images/no-image.png'">
                                                    <div>
                                                        <div style="font-weight: 600; margin-bottom: 0.25rem;">
                                                            ${item.productName}
                                                        </div>
                                                        <div style="font-size: 0.875rem; color: #6c757d;">
                                                            <c:if test="${not empty item.size}">
                                                                <span>Size: ${item.size}</span>
                                                            </c:if>
                                                            <c:if test="${not empty item.color}">
                                                                <span style="margin-left: 0.5rem;">Màu: ${item.color}</span>
                                                            </c:if>
                                                        </div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td style="font-weight: 600;">
                                                <fmt:formatNumber value="${item.price}" 
                                                                  type="currency" 
                                                                  currencyCode="VND" 
                                                                  minFractionDigits="0"/>
                                            </td>
                                            <td style="font-weight: 600; text-align: center;">
                                                ${item.quantity}
                                            </td>
                                            <td style="font-weight: 700; color: #27ae60;">
                                                <fmt:formatNumber value="${item.subtotal}" 
                                                                  type="currency" 
                                                                  currencyCode="VND" 
                                                                  minFractionDigits="0"/>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                                <tfoot>
                                    <tr style="background: #f8f9fa;">
                                        <th colspan="2">Tạm tính:</th>
                                        <th></th>
                                        <th style="text-align: left;">
                                            <fmt:formatNumber value="${order.totalAmount}" 
                                                              type="currency" 
                                                              currencyCode="VND" 
                                                              minFractionDigits="0"/>
                                        </th>
                                    </tr>
                                    
                                    <c:if test="${order.shippingFee > 0}">
                                        <tr style="background: #f8f9fa;">
                                            <th colspan="2">Phí vận chuyển:</th>
                                            <th></th>
                                            <th style="text-align: left; color: #3498db;">
                                                +<fmt:formatNumber value="${order.shippingFee}" 
                                                                   type="currency" 
                                                                   currencyCode="VND" 
                                                                   minFractionDigits="0"/>
                                            </th>
                                        </tr>
                                    </c:if>
                                    
                                    <c:if test="${order.discountAmount > 0}">
                                        <tr style="background: #f8f9fa;">
                                            <th colspan="2">Giảm giá:</th>
                                            <th></th>
                                            <th style="text-align: left; color: #27ae60;">
                                                -<fmt:formatNumber value="${order.discountAmount}" 
                                                                   type="currency" 
                                                                   currencyCode="VND" 
                                                                   minFractionDigits="0"/>
                                            </th>
                                        </tr>
                                    </c:if>
                                    
                                    <tr style="background: #e7f3ff; border-top: 3px solid #3498db;">
                                        <th colspan="2" style="font-size: 1.1rem;">TỔNG CỘNG:</th>
                                        <th></th>
                                        <th style="text-align: left; font-size: 1.25rem; color: #e74c3c;">
                                            <fmt:formatNumber value="${order.finalAmount}" 
                                                              type="currency" 
                                                              currencyCode="VND" 
                                                              minFractionDigits="0"/>
                                        </th>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                    </div>
                </div>
                
                <div class="card" style="margin-top: 1.5rem;">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-credit-card"></i> Cập nhật thanh toán
                        </h3>
                    </div>
                    <div class="card-body">
                        <form method="post" action="<c:url value='/Admin/orders'/>" style="display: flex; gap: 1rem; align-items: flex-end;">
                            <input type="hidden" name="action" value="updatePayment">
                            <input type="hidden" name="id" value="${order.id}">
                            
                            <div class="form-group" style="flex: 1;">
                                <label class="form-label">Trạng thái thanh toán</label>
                                <select name="paymentStatus" class="form-control">
                                    <option value="UNPAID" ${order.paymentStatus eq 'UNPAID' ? 'selected' : ''}>Chưa thanh toán</option>
                                    <option value="PAID" ${order.paymentStatus eq 'PAID' ? 'selected' : ''}>Đã thanh toán</option>
                                    <option value="REFUNDED" ${order.paymentStatus eq 'REFUNDED' ? 'selected' : ''}>Đã hoàn tiền</option>
                                </select>
                            </div>
                            
                            <button type="submit" class="btn btn-success">
                                <i class="fas fa-save"></i> Cập nhật thanh toán
                            </button>
                        </form>
                    </div>
                </div>
                
            </div>
            
        </main>
        
    </div>
    
    <script>
        function toggleMobileSidebar() {
            const sidebar = document.getElementById('adminSidebar');
            const overlay = document.getElementById('mobileOverlay');
            sidebar.classList.toggle('show');
            overlay.classList.toggle('show');
        }
    </script>
    
</body>
</html>