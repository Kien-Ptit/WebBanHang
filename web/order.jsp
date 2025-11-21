<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<fmt:setLocale value="vi_VN"/>
<fmt:setTimeZone value="Asia/Ho_Chi_Minh"/>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title>
        <c:choose>
            <c:when test="${empty order}">Đơn hàng của tôi</c:when>
            <c:otherwise>Đơn #OD-${order.id}</c:otherwise>
        </c:choose>
    </title>
    <link rel="stylesheet" href="<c:url value='/css/orders.css'/>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    
    <jsp:include page="/header.jsp" />
    
    <div class="container">
        
        <!-- ===== CHI TIẾT ĐƠN HÀNG ===== -->
        <c:if test="${not empty order}">
            <a href="<c:url value='/orders'/>" class="back-link">
                <i class="fas fa-arrow-left"></i> Quay lại danh sách
            </a>
            
            <div class="order-header">
                <h1 class="order-title">
                    Đơn <span class="order-id">#OD-${order.id}</span>
                </h1>
                <c:if test="${not empty order.status}">
                    <span class="status-badge status-${fn:toLowerCase(order.status)}">
                        ${order.statusDisplay}
                    </span>
                </c:if>
            </div>

            <!-- Info Card -->
            <div class="info-card">
                <div class="info-grid">
                    <div class="info-item">
                        <span class="info-label">📅 Ngày tạo</span>
                        <span class="info-value">
                            <fmt:formatDate value="${order.createdAt}" 
                                          pattern="dd/MM/yyyy HH:mm" 
                                          timeZone="Asia/Ho_Chi_Minh"/>
                        </span>
                    </div>
                    
                    <div class="info-item">
                        <span class="info-label">👤 Người nhận</span>
                        <span class="info-value highlight">${order.fullname}</span>
                    </div>
                    
                    <div class="info-item">
                        <span class="info-label">📞 Số điện thoại</span>
                        <span class="info-value">${order.phone}</span>
                    </div>
                    
                    <div class="info-item">
                        <span class="info-label">📍 Địa chỉ</span>
                        <span class="info-value">${order.address}</span>
                    </div>
                    
                    <c:if test="${not empty order.note}">
                        <div class="info-item" style="grid-column: 1 / -1;">
                            <span class="info-label">📝 Ghi chú</span>
                            <span class="info-value">${order.note}</span>
                        </div>
                    </c:if>
                </div>
                
                <!-- ✅ THÔNG TIN THANH TOÁN -->
                <div class="payment-info-section">
                    <div class="payment-info-row">
                        <span class="payment-label">💳 Phương thức thanh toán:</span>
                        <span class="payment-value">
                            <c:choose>
                                <c:when test="${order.paymentMethod eq 'COD'}">
                                    <span class="payment-method-badge cod">
                                        <i class="fas fa-money-bill-wave"></i>
                                        COD - Thanh toán khi nhận hàng
                                    </span>
                                </c:when>
                                <c:when test="${order.paymentMethod eq 'EWALLET'}">
                                    <span class="payment-method-badge ewallet">
                                        <i class="fas fa-wallet"></i>
                                        Ví điện tử (${order.ewalletType})
                                    </span>
                                </c:when>
                                <c:when test="${order.paymentMethod eq 'BANK_TRANSFER'}">
                                    <span class="payment-method-badge bank">
                                        <i class="fas fa-university"></i>
                                        Chuyển khoản ngân hàng
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="payment-method-badge cod">COD</span>
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    
                    <div class="payment-info-row">
                        <span class="payment-label">💰 Trạng thái thanh toán:</span>
                        <span class="payment-value">
                            <c:choose>
                                <c:when test="${order.paymentStatus eq 'PAID'}">
                                    <span class="payment-status-badge paid">
                                        <i class="fas fa-check-circle"></i> Đã thanh toán
                                    </span>
                                </c:when>
                                <c:when test="${order.paymentStatus eq 'REFUNDED'}">
                                    <span class="payment-status-badge refunded">
                                        <i class="fas fa-undo"></i> Đã hoàn tiền
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="payment-status-badge unpaid">
                                        <i class="fas fa-clock"></i> Chưa thanh toán
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    
                    <c:if test="${not empty order.paidAt}">
                        <div class="payment-info-row">
                            <span class="payment-label">⏰ Thời gian thanh toán:</span>
                            <span class="payment-value">
                                <fmt:formatDate value="${order.paidAt}" 
                                              pattern="dd/MM/yyyy HH:mm" 
                                              timeZone="Asia/Ho_Chi_Minh"/>
                            </span>
                        </div>
                    </c:if>
                </div>
                
                <!-- ✅ MÃ VẬN ĐƠN (nếu có) -->
                <c:if test="${not empty order.trackingNumber}">
                    <div class="tracking-info">
                        <div class="tracking-label">📦 Mã vận đơn:</div>
                        <div class="tracking-number">${order.trackingNumber}</div>
                        <c:if test="${not empty order.shippedAt}">
                            <div class="tracking-label" style="margin-top: 0.5rem;">
                                Giao hàng lúc: 
                                <fmt:formatDate value="${order.shippedAt}" 
                                              pattern="dd/MM/yyyy HH:mm" 
                                              timeZone="Asia/Ho_Chi_Minh"/>
                            </div>
                        </c:if>
                    </div>
                </c:if>
                
                <!-- ✅ LÝ DO HỦY (nếu đã hủy) -->
                <c:if test="${order.status eq 'Cancelled' && not empty order.cancelReason}">
                    <div class="cancel-reason-section">
                        <div class="cancel-reason-label">
                            <i class="fas fa-exclamation-triangle"></i>
                            Lý do hủy đơn:
                        </div>
                        <div class="cancel-reason-text">${order.cancelReason}</div>
                        <c:if test="${not empty order.cancelledAt}">
                            <div class="tracking-label" style="margin-top: 0.5rem; color: #856404;">
                                Hủy lúc: 
                                <fmt:formatDate value="${order.cancelledAt}" 
                                              pattern="dd/MM/yyyy HH:mm" 
                                              timeZone="Asia/Ho_Chi_Minh"/>
                            </div>
                        </c:if>
                    </div>
                </c:if>
                
                <!-- ✅ NÚT HỦY ĐƠN -->
                <c:if test="${order.status eq 'Pending'}">
                    <div class="order-actions">
                        <button type="button" class="btn-cancel-order" onclick="showCancelModal(${order.id})">
                            <i class="fas fa-times-circle"></i> Hủy đơn hàng
                        </button>
                    </div>
                </c:if>
            </div>

            <!-- Items Table -->
            <div class="items-card">
                <table class="items-table">
                    <thead>
                        <tr>
                            <th>Sản phẩm</th>
                            <th class="text-end">Giá</th>
                            <th class="text-end">SL</th>
                            <th class="text-end">Thành tiền</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="it" items="${orderItems}">
                            <tr>
                                <td>
                                    <div class="product-info">
                                        <c:if test="${not empty it.productImage}">
                                            <img src="${it.productImage}" 
                                                 alt="${it.productName}" 
                                                 class="product-image"/>
                                        </c:if>
                                        <div class="product-details">
                                            <div class="product-name">${it.productName}</div>
                                            <div class="product-meta">
                                                <c:if test="${not empty it.size}">
                                                    <span class="meta-badge">
                                                        📏 Size: <strong>${it.size}</strong>
                                                    </span>
                                                </c:if>
                                                <c:if test="${not empty it.color}">
                                                    <span class="meta-badge">
                                                        🎨 Màu: <strong>${it.color}</strong>
                                                    </span>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                </td>
                                <td class="text-end">
                                    <span class="price">
                                        <fmt:formatNumber value="${it.price}" 
                                                        type="currency" 
                                                        currencyCode="VND" 
                                                        minFractionDigits="0"/>
                                    </span>
                                </td>
                                <td class="text-end">
                                    <span class="quantity">${it.quantity}</span>
                                </td>
                                <td class="text-end">
                                    <span class="subtotal">
                                        <fmt:formatNumber value="${it.subtotal}" 
                                                        type="currency" 
                                                        currencyCode="VND" 
                                                        minFractionDigits="0"/>
                                    </span>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty orderItems}">
                            <tr>
                                <td colspan="4" class="empty-items">
                                    <span class="empty-items-icon">📦</span>
                                    <p>Đơn hàng chưa có sản phẩm.</p>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                    <tfoot>
                        <!-- ✅ PRICE BREAKDOWN -->
                        <tr>
                            <th colspan="3" class="text-end">Tạm tính:</th>
                            <th class="text-end">
                                <fmt:formatNumber value="${order.totalAmount}" 
                                                type="currency" 
                                                currencyCode="VND" 
                                                minFractionDigits="0"/>
                            </th>
                        </tr>
                        
                        <c:if test="${order.shippingFee > 0}">
                            <tr>
                                <th colspan="3" class="text-end">Phí vận chuyển:</th>
                                <th class="text-end" style="color: #3498db;">
                                    +<fmt:formatNumber value="${order.shippingFee}" 
                                                    type="currency" 
                                                    currencyCode="VND" 
                                                    minFractionDigits="0"/>
                                </th>
                            </tr>
                        </c:if>
                        
                        <c:if test="${order.discountAmount > 0}">
                            <tr>
                                <th colspan="3" class="text-end">Giảm giá:</th>
                                <th class="text-end" style="color: #27ae60;">
                                    -<fmt:formatNumber value="${order.discountAmount}" 
                                                    type="currency" 
                                                    currencyCode="VND" 
                                                    minFractionDigits="0"/>
                                </th>
                            </tr>
                        </c:if>
                        
                        <tr style="background: #f8f9fa; border-top: 2px solid #dee2e6;">
                            <th colspan="3" class="text-end" style="font-size: 1.1rem;">Tổng cộng:</th>
                            <th class="text-end">
                                <span class="total-amount">
                                    <fmt:formatNumber value="${order.finalAmount}" 
                                                    type="currency" 
                                                    currencyCode="VND" 
                                                    minFractionDigits="0"/>
                                </span>
                            </th>
                        </tr>
                    </tfoot>
                </table>
            </div>
        </c:if>

        <!-- ===== DANH SÁCH ĐƠN HÀNG ===== -->
        <c:if test="${empty order}">
            <div class="page-header">
                <h1 class="page-title">🛍️ Đơn hàng của tôi</h1>
            </div>

            <!-- ✅ FILTER TABS -->
            <div class="order-filters">
                <a href="<c:url value='/orders'/>" 
                   class="filter-tab ${empty currentStatus ? 'active' : ''}">
                    Tất cả
                </a>
                <a href="<c:url value='/orders?status=Pending'/>" 
                   class="filter-tab ${currentStatus eq 'Pending' ? 'active' : ''}">
                    Chờ xác nhận
                </a>
                <a href="<c:url value='/orders?status=Processing'/>" 
                   class="filter-tab ${currentStatus eq 'Processing' ? 'active' : ''}">
                    Đang xử lý
                </a>
                <a href="<c:url value='/orders?status=Completed'/>" 
                   class="filter-tab ${currentStatus eq 'Completed' ? 'active' : ''}">
                    Hoàn thành
                </a>
                <a href="<c:url value='/orders?status=Cancelled'/>" 
                   class="filter-tab ${currentStatus eq 'Cancelled' ? 'active' : ''}">
                    Đã hủy
                </a>
            </div>

            <c:choose>
                <c:when test="${empty orders}">
                    <div class="empty-state">
                        <span class="empty-state-icon">📦</span>
                        <h3>Chưa có đơn hàng nào</h3>
                        <p>Bạn chưa có đơn hàng nào. Hãy bắt đầu mua sắm ngay!</p>
                        <a href="<c:url value='/products'/>" class="btn-shop">🛒 Mua sắm ngay</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="orders-table-container">
                        <table class="orders-table">
                            <thead>
                                <tr>
                                    <th>Mã đơn</th>
                                    <th>Người nhận</th>
                                    <th class="text-center">Ngày tạo</th>
                                    <th class="text-center">Trạng thái</th>
                                    <th class="text-center">Thanh toán</th>
                                    <th class="text-end">Tổng tiền</th>
                                    <th class="text-center">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="o" items="${orders}">
                                    <tr>
                                        <td>
                                            <span class="order-code">OD-${o.id}</span>
                                        </td>
                                        <td>${o.fullname}</td>
                                        <td class="text-center">
                                            <span class="order-date">
                                                <fmt:formatDate value="${o.createdAt}" 
                                                              pattern="dd/MM/yyyy HH:mm" 
                                                              timeZone="Asia/Ho_Chi_Minh"/>
                                            </span>
                                        </td>
                                        <td class="text-center">
                                            <span class="status-badge status-${fn:toLowerCase(o.status)}">
                                                ${o.statusDisplay}
                                            </span>
                                        </td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${o.paymentStatus eq 'PAID'}">
                                                    <span class="payment-status-badge paid">
                                                        <i class="fas fa-check-circle"></i> Đã TT
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="payment-status-badge unpaid">
                                                        <i class="fas fa-clock"></i> Chưa TT
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-end">
                                            <span class="order-total">
                                                <fmt:formatNumber value="${o.finalAmount}" 
                                                                type="currency" 
                                                                currencyCode="VND" 
                                                                minFractionDigits="0"/>
                                            </span>
                                        </td>
                                        <td class="text-center">
                                            <a href="<c:url value='/orders?id=${o.id}'/>" 
                                               class="btn-view">
                                                Xem chi tiết
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </c:if>

        <c:if test="${not empty error}">
            <div class="alert-error">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>

    </div>
    
    <!-- ✅ MODAL HỦY ĐƠN -->
    <div id="cancelModal" class="cancel-modal">
        <div class="cancel-modal-content">
            <div class="cancel-modal-header">
                <h2 class="cancel-modal-title">
                    <i class="fas fa-exclamation-triangle" style="color: #e74c3c;"></i>
                    Xác nhận hủy đơn
                </h2>
            </div>
            <div class="cancel-modal-body">
                <p>Bạn có chắc chắn muốn hủy đơn hàng này không?</p>
                
                <!-- ✅ LÝ DO HỦY -->
                <div class="form-group" style="margin-top: 1rem;">
                    <label for="cancelReason">Lý do hủy (tùy chọn):</label>
                    <textarea id="cancelReason" 
                              class="form-control" 
                              rows="3" 
                              placeholder="Nhập lý do hủy đơn..."></textarea>
                </div>
                
                <p style="color: #e74c3c; font-weight: 600; margin-top: 1rem;">
                    ⚠️ Hành động này không thể hoàn tác!
                </p>
            </div>
            <div class="cancel-modal-footer">
                <button type="button" class="btn-modal-cancel" onclick="closeCancelModal()">
                    Không, giữ đơn
                </button>
                <button type="button" class="btn-modal-confirm" onclick="confirmCancelOrder()">
                    Có, hủy đơn
                </button>
            </div>
        </div>
    </div>
    
    <!-- ✅ JAVASCRIPT -->
    <script>
        var currentOrderId = null;
        
        function showCancelModal(orderId) {
            currentOrderId = orderId;
            document.getElementById('cancelModal').classList.add('show');
            document.getElementById('cancelReason').value = '';
        }
        
        function closeCancelModal() {
            currentOrderId = null;
            document.getElementById('cancelModal').classList.remove('show');
        }
        
        function confirmCancelOrder() {
            if (!currentOrderId) return;
            
            var btn = document.querySelector('.btn-modal-confirm');
            var reason = document.getElementById('cancelReason').value || 'Khách hàng hủy đơn';
            
            btn.disabled = true;
            btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang hủy...';
            
            fetch('<c:url value="/cancel-order"/>', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'orderId=' + currentOrderId + '&reason=' + encodeURIComponent(reason)
            })
            .then(function(response) {
                return response.json();
            })
            .then(function(data) {
                if (data.success) {
                    showToast('success', 'Thành công', data.message);
                    setTimeout(function() {
                        window.location.reload();
                    }, 1500);
                } else {
                    showToast('error', 'Lỗi', data.message);
                    btn.disabled = false;
                    btn.innerHTML = 'Có, hủy đơn';
                }
                closeCancelModal();
            })
            .catch(function(error) {
                console.error('Error:', error);
                showToast('error', 'Lỗi', 'Có lỗi xảy ra. Vui lòng thử lại.');
                btn.disabled = false;
                btn.innerHTML = 'Có, hủy đơn';
                closeCancelModal();
            });
        }
        
        function showToast(type, title, message) {
            var toast = document.createElement('div');
            toast.className = 'toast-notification toast-' + type;
            
            var iconHTML = type === 'success' 
                ? '<i class="fas fa-check-circle"></i>' 
                : '<i class="fas fa-times-circle"></i>';
            
            toast.innerHTML = 
                '<div class="toast-icon">' +
                    iconHTML +
                '</div>' +
                '<div class="toast-content">' +
                    '<div class="toast-title">' + title + '</div>' +
                    '<div class="toast-message">' + message + '</div>' +
                '</div>' +
                '<button class="toast-close" onclick="this.parentElement.remove()">' +
                    '<i class="fas fa-times"></i>' +
                '</button>';
            
            document.body.appendChild(toast);
            
            setTimeout(function() {
                if (toast && toast.parentElement) {
                    toast.remove();
                }
            }, 5000);
        }
        
        document.getElementById('cancelModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeCancelModal();
            }
        });
    </script>

    <style>
        .form-group {
            margin-bottom: 1rem;
        }
        
        .form-group label {
            display: block;
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: #2c3e50;
        }
        
        .form-control {
            width: 100%;
            padding: 0.75rem;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 1rem;
            font-family: inherit;
            transition: all 0.3s;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
    </style>
    
</body>
</html>