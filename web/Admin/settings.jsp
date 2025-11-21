<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Cài đặt hệ thống - Admin</title>

        <link rel="stylesheet" href="<c:url value='/css-admin/admin.css'/>">
        <link rel="stylesheet" href="<c:url value='/css-admin/admin-responsive.css'/>">
        <link rel="stylesheet" href="<c:url value='/css-admin/settings.css'/>">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    </head>
    <body>

        <div class="admin-wrapper">

            <jsp:include page="sidebar.jsp" />

            <main class="admin-main">

                <header class="admin-header">
                    <h1 class="header-title">
                        <i class="fas fa-cog"></i> Cài đặt hệ thống
                    </h1>
                </header>

                <div class="admin-content">

                    <!-- Alerts -->
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

                    <!-- Settings Tabs -->
                    <div class="settings-container">

                        <!-- Tabs Navigation -->
                        <div class="settings-tabs">
                            <button class="tab-btn active" onclick="showTab('general')">
                                <i class="fas fa-globe"></i>
                                <span>Cài đặt chung</span>
                            </button>
                            <button class="tab-btn" onclick="showTab('email')">
                                <i class="fas fa-envelope"></i>
                                <span>Email</span>
                            </button>
                            <button class="tab-btn" onclick="showTab('payment')">
                                <i class="fas fa-credit-card"></i>
                                <span>Thanh toán</span>
                            </button>
                            <button class="tab-btn" onclick="showTab('shipping')">
                                <i class="fas fa-shipping-fast"></i>
                                <span>Vận chuyển</span>
                            </button>
                            <button class="tab-btn" onclick="showTab('profile')">
                                <i class="fas fa-user-circle"></i>
                                <span>Tài khoản</span>
                            </button>
                            <button class="tab-btn" onclick="showTab('system')">
                                <i class="fas fa-tools"></i>
                                <span>Hệ thống</span>
                            </button>
                        </div>

                        <!-- Tabs Content -->
                        <div class="settings-content">

                            <!-- ===== TAB 1: CÀI ĐẶT CHUNG ===== -->
                            <div id="general-tab" class="tab-content active">
                                <div class="card">
                                    <div class="card-header">
                                        <h3 class="card-title">
                                            <i class="fas fa-globe"></i> Thông tin website
                                        </h3>
                                    </div>
                                    <div class="card-body">
                                        <form method="post" action="<c:url value='/Admin/settings'/>">
                                            <input type="hidden" name="action" value="updateGeneral">

                                            <div class="form-row">
                                                <div class="form-group">
                                                    <label class="form-label">
                                                        <i class="fas fa-store"></i> Tên website
                                                    </label>
                                                    <input type="text" name="siteName" class="form-control" 
                                                           value="${settings['site_name']}" required>
                                                </div>

                                                <div class="form-group">
                                                    <label class="form-label">
                                                        <i class="fas fa-envelope"></i> Email liên hệ
                                                    </label>
                                                    <input type="email" name="siteEmail" class="form-control" 
                                                           value="${settings['site_email']}" required>
                                                </div>
                                            </div>

                                            <div class="form-row">
                                                <div class="form-group">
                                                    <label class="form-label">
                                                        <i class="fas fa-phone"></i> Số điện thoại
                                                    </label>
                                                    <input type="text" name="sitePhone" class="form-control" 
                                                           value="${settings['site_phone']}">
                                                </div>

                                                <div class="form-group">
                                                    <label class="form-label">
                                                        <i class="fas fa-map-marker-alt"></i> Địa chỉ
                                                    </label>
                                                    <input type="text" name="siteAddress" class="form-control" 
                                                           value="${settings['site_address']}">
                                                </div>
                                            </div>

                                            <div class="form-group">
                                                <label class="form-label">
                                                    <i class="fas fa-info-circle"></i> Mô tả website
                                                </label>
                                                <textarea name="siteDescription" class="form-control" rows="3">${settings['site_description']}</textarea>
                                            </div>

                                            <div class="form-actions">
                                                <button type="submit" class="btn btn-primary">
                                                    <i class="fas fa-save"></i> Lưu thay đổi
                                                </button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>

                            <!-- ===== TAB 2: CÀI ĐẶT EMAIL ===== -->
                            <div id="email-tab" class="tab-content">
                                <div class="card">
                                    <div class="card-header">
                                        <h3 class="card-title">
                                            <i class="fas fa-envelope"></i> Cấu hình SMTP
                                        </h3>
                                    </div>
                                    <div class="card-body">
                                        <form method="post" action="<c:url value='/Admin/settings'/>">
                                            <input type="hidden" name="action" value="updateEmail">

                                            <div class="form-row">
                                                <div class="form-group">
                                                    <label class="form-label">
                                                        <i class="fas fa-server"></i> SMTP Host
                                                    </label>
                                                    <input type="text" name="smtpHost" class="form-control" 
                                                           value="${settings['smtp_host']}" placeholder="smtp.gmail.com">
                                                </div>

                                                <div class="form-group">
                                                    <label class="form-label">
                                                        <i class="fas fa-plug"></i> SMTP Port
                                                    </label>
                                                    <input type="number" name="smtpPort" class="form-control" 
                                                           value="${settings['smtp_port']}" placeholder="587">
                                                </div>
                                            </div>

                                            <div class="form-row">
                                                <div class="form-group">
                                                    <label class="form-label">
                                                        <i class="fas fa-user"></i> Username
                                                    </label>
                                                    <input type="text" name="smtpUsername" class="form-control" 
                                                           value="${settings['smtp_username']}">
                                                </div>

                                                <div class="form-group">
                                                    <label class="form-label">
                                                        <i class="fas fa-lock"></i> Password
                                                    </label>
                                                    <input type="password" name="smtpPassword" class="form-control" 
                                                           placeholder="••••••••">
                                                </div>
                                            </div>

                                            <div class="form-group">
                                                <label class="form-label">
                                                    <i class="fas fa-shield-alt"></i> Mã hóa
                                                </label>
                                                <select name="smtpEncryption" class="form-control">
                                                    <option value="tls" ${settings['smtp_encryption'] eq 'tls' ? 'selected' : ''}>TLS</option>
                                                    <option value="ssl" ${settings['smtp_encryption'] eq 'ssl' ? 'selected' : ''}>SSL</option>
                                                    <option value="none" ${settings['smtp_encryption'] eq 'none' ? 'selected' : ''}>None</option>
                                                </select>
                                            </div>

                                            <div class="form-actions">
                                                <button type="submit" class="btn btn-primary">
                                                    <i class="fas fa-save"></i> Lưu cấu hình
                                                </button>
                                                <button type="button" class="btn btn-secondary" onclick="testEmail()">
                                                    <i class="fas fa-paper-plane"></i> Gửi email test
                                                </button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>

                            <!-- ===== TAB 3: THANH TOÁN ===== -->
                            <div id="payment-tab" class="tab-content">
                                <div class="card">
                                    <div class="card-header">
                                        <h3 class="card-title">
                                            <i class="fas fa-credit-card"></i> Phương thức thanh toán
                                        </h3>
                                    </div>
                                    <div class="card-body">
                                        <form method="post" action="<c:url value='/Admin/settings'/>">
                                            <input type="hidden" name="action" value="updatePayment">

                                            <!-- COD -->
                                            <div class="payment-method">
                                                <div class="method-header">
                                                    <label class="switch">
                                                        <input type="checkbox" name="enableCod" 
                                                               ${settings['enable_cod'] eq '1' ? 'checked' : ''}>
                                                        <span class="slider"></span>
                                                    </label>
                                                    <div>
                                                        <h4>
                                                            <i class="fas fa-money-bill-wave"></i> 
                                                            Thanh toán khi nhận hàng (COD)
                                                        </h4>
                                                        <p>Khách hàng thanh toán tiền mặt khi nhận hàng</p>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- VNPay -->
                                            <div class="payment-method">
                                                <div class="method-header">
                                                    <label class="switch">
                                                        <input type="checkbox" name="enableVnpay" 
                                                               ${settings['enable_vnpay'] eq '1' ? 'checked' : ''}>
                                                        <span class="slider"></span>
                                                    </label>
                                                    <div>
                                                        <h4>
                                                            <i class="fas fa-credit-card"></i> 
                                                            VNPay
                                                        </h4>
                                                        <p>Thanh toán trực tuyến qua VNPay</p>
                                                    </div>
                                                </div>

                                                <div class="method-config">
                                                    <div class="form-group">
                                                        <label class="form-label">TMN Code</label>
                                                        <input type="text" name="vnpayTmnCode" class="form-control" 
                                                               value="${settings['vnpay_tmn_code']}">
                                                    </div>

                                                    <div class="form-group">
                                                        <label class="form-label">Hash Secret</label>
                                                        <input type="text" name="vnpayHashSecret" class="form-control" 
                                                               value="${settings['vnpay_hash_secret']}">
                                                    </div>

                                                    <div class="form-group">
                                                        <label class="form-label">Payment URL</label>
                                                        <input type="text" name="vnpayUrl" class="form-control" 
                                                               value="${settings['vnpay_url']}">
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="form-actions">
                                                <button type="submit" class="btn btn-primary">
                                                    <i class="fas fa-save"></i> Lưu cấu hình
                                                </button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>

                            <!-- ===== TAB 4: VẬN CHUYỂN ===== -->
                            <div id="shipping-tab" class="tab-content">
                                <div class="card">
                                    <div class="card-header">
                                        <h3 class="card-title">
                                            <i class="fas fa-shipping-fast"></i> Cài đặt vận chuyển
                                        </h3>
                                    </div>
                                    <div class="card-body">
                                        <form method="post" action="<c:url value='/Admin/settings'/>">
                                            <input type="hidden" name="action" value="updateShipping">

                                            <div class="form-row">
                                                <div class="form-group">
                                                    <label class="form-label">
                                                        <i class="fas fa-dollar-sign"></i> Phí vận chuyển (VNĐ)
                                                    </label>
                                                    <input type="number" name="shippingFee" class="form-control" 
                                                           value="${settings['shipping_fee']}" min="0" step="1000">
                                                </div>

                                                <div class="form-group">
                                                    <label class="form-label">
                                                        <i class="fas fa-gift"></i> Miễn phí ship từ (VNĐ)
                                                    </label>
                                                    <input type="number" name="freeShippingThreshold" class="form-control" 
                                                           value="${settings['free_shipping_threshold']}" min="0" step="10000">
                                                </div>
                                            </div>

                                            <div class="form-group">
                                                <label class="form-label">
                                                    <i class="fas fa-clock"></i> Thời gian giao hàng dự kiến
                                                </label>
                                                <input type="text" name="estimatedDelivery" class="form-control" 
                                                       value="${settings['estimated_delivery']}" placeholder="3-5 ngày">
                                            </div>

                                            <div class="info-box">
                                                <i class="fas fa-info-circle"></i>
                                                <div>
                                                    <strong>Lưu ý:</strong>
                                                    <p>Khách hàng sẽ được miễn phí vận chuyển khi giá trị đơn hàng đạt ngưỡng quy định.</p>
                                                </div>
                                            </div>

                                            <div class="form-actions">
                                                <button type="submit" class="btn btn-primary">
                                                    <i class="fas fa-save"></i> Lưu cấu hình
                                                </button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>

                            <!-- ===== TAB 5: TÀI KHOẢN ===== -->
                            <div id="profile-tab" class="tab-content">

                                <!-- Thông tin cá nhân -->
                                <div class="card">
                                    <div class="card-header">
                                        <h3 class="card-title">
                                            <i class="fas fa-user"></i> Thông tin cá nhân
                                        </h3>
                                    </div>
                                    <div class="card-body">
                                        <form method="post" action="<c:url value='/Admin/settings'/>">
                                            <input type="hidden" name="action" value="updateProfile">

                                            <div class="form-group">
                                                <label class="form-label">
                                                    <i class="fas fa-user"></i> Họ và tên
                                                </label>
                                                <input type="text" name="fullname" class="form-control" 
                                                       value="${currentUser.fullname}" required>
                                            </div>

                                            <div class="form-row">
                                                <div class="form-group">
                                                    <label class="form-label">
                                                        <i class="fas fa-envelope"></i> Email
                                                    </label>
                                                    <input type="email" name="email" class="form-control" 
                                                           value="${currentUser.email}" required>
                                                </div>

                                                <div class="form-group">
                                                    <label class="form-label">
                                                        <i class="fas fa-phone"></i> Số điện thoại
                                                    </label>
                                                    <input type="text" name="phone" class="form-control" 
                                                           value="${currentUser.phone}">
                                                </div>
                                            </div>

                                            <div class="form-actions">
                                                <button type="submit" class="btn btn-primary">
                                                    <i class="fas fa-save"></i> Cập nhật
                                                </button>
                                            </div>
                                        </form>
                                    </div>
                                </div>

                                <!-- Đổi mật khẩu -->
                                <div class="card" style="margin-top: 20px;">
                                    <div class="card-header">
                                        <h3 class="card-title">
                                            <i class="fas fa-key"></i> Đổi mật khẩu
                                        </h3>
                                    </div>
                                    <div class="card-body">
                                        <form method="post" action="<c:url value='/Admin/settings'/>" onsubmit="return validatePassword()">
                                            <input type="hidden" name="action" value="changePassword">

                                            <div class="form-group">
                                                <label class="form-label">
                                                    <i class="fas fa-lock"></i> Mật khẩu hiện tại
                                                </label>
                                                <input type="password" name="currentPassword" id="currentPassword" 
                                                       class="form-control" required>
                                            </div>

                                            <div class="form-group">
                                                <label class="form-label">
                                                    <i class="fas fa-lock"></i> Mật khẩu mới
                                                </label>
                                                <input type="password" name="newPassword" id="newPassword" 
                                                       class="form-control" minlength="6" required>
                                                <small class="form-text">Mật khẩu phải có ít nhất 6 ký tự</small>
                                            </div>

                                            <div class="form-group">
                                                <label class="form-label">
                                                    <i class="fas fa-lock"></i> Xác nhận mật khẩu mới
                                                </label>
                                                <input type="password" name="confirmPassword" id="confirmPassword" 
                                                       class="form-control" minlength="6" required>
                                            </div>

                                            <div class="form-actions">
                                                <button type="submit" class="btn btn-primary">
                                                    <i class="fas fa-key"></i> Đổi mật khẩu
                                                </button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>

                            <!-- ===== TAB 6: HỆ THỐNG ===== -->
                            <div id="system-tab" class="tab-content">
                                <div class="card">
                                    <div class="card-header">
                                        <h3 class="card-title">
                                            <i class="fas fa-tools"></i> Công cụ hệ thống
                                        </h3>
                                    </div>
                                    <div class="card-body">

                                        <!-- Thông tin hệ thống -->
                                        <div class="system-info">
                                            <div class="info-item">
                                                <div class="info-icon">
                                                    <i class="fas fa-database"></i>
                                                </div>
                                                <div class="info-details">
                                                    <h4>Database</h4>
                                                    <p>MySQL 8.0 - webquanao</p>
                                                </div>
                                            </div>

                                            <div class="info-item">
                                                <div class="info-icon">
                                                    <i class="fas fa-server"></i>
                                                </div>
                                                <div class="info-details">
                                                    <h4>Server</h4>
                                                    <p>Apache Tomcat 10.1</p>
                                                </div>
                                            </div>

                                            <div class="info-item">
                                                <div class="info-icon">
                                                    <i class="fas fa-code"></i>
                                                </div>
                                                <div class="info-details">
                                                    <h4>Version</h4>
                                                    <p>Kien Store v1.0.0</p>
                                                </div>
                                            </div>

                                            <div class="info-item">
                                                <div class="info-icon">
                                                    <i class="fas fa-calendar"></i>
                                                </div>
                                                <div class="info-details">
                                                    <h4>Last Update</h4>
                                                    <p>20/11/2025</p>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Actions -->
                                        <div class="system-actions">
                                            <form method="post" action="<c:url value='/Admin/settings'/>" style="display: inline;">
                                                <input type="hidden" name="action" value="clearCache">
                                                <button type="submit" class="btn btn-warning" onclick="return confirm('Xóa cache hệ thống?')">
                                                    <i class="fas fa-broom"></i> Xóa Cache
                                                </button>
                                            </form>

                                            <button type="button" class="btn btn-info" onclick="window.print()">
                                                <i class="fas fa-file-export"></i> Xuất cấu hình
                                            </button>

                                            <button type="button" class="btn btn-secondary" onclick="location.reload()">
                                                <i class="fas fa-sync"></i> Tải lại trang
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>

                </div>

            </main>

        </div>

        <script>
            // Tab switching
            function showTab(tabName) {
                // Hide all tabs
                document.querySelectorAll('.tab-content').forEach(tab => {
                    tab.classList.remove('active');
                });

                document.querySelectorAll('.tab-btn').forEach(btn => {
                    btn.classList.remove('active');
                });

                // Show selected tab
                document.getElementById(tabName + '-tab').classList.add('active');
                event.target.closest('.tab-btn').classList.add('active');
            }

            // Validate password
            function validatePassword() {
                const newPass = document.getElementById('newPassword').value;
                const confirmPass = document.getElementById('confirmPassword').value;

                if (newPass.length < 6) {
                    alert('❌ Mật khẩu mới phải có ít nhất 6 ký tự!');
                    return false;
                }

                if (newPass !== confirmPass) {
                    alert('❌ Mật khẩu xác nhận không khớp!');
                    return false;
                }

                return confirm('🔒 Bạn có chắc muốn đổi mật khẩu?');
            }

            // Test email
            function testEmail() {
                alert('📧 Đang gửi email test...\n\nTính năng này sẽ được triển khai sau.');
            }

            // Auto hide alerts
            setTimeout(() => {
                document.querySelectorAll('.alert').forEach(alert => {
                    alert.style.transition = 'opacity 0.5s';
                    alert.style.opacity = '0';
                    setTimeout(() => alert.remove(), 500);
                });
            }, 5000);
        </script>

    </body>
</html>