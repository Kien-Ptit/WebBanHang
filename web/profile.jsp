    <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Hồ sơ cá nhân - Fashion Store</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/profile.css" rel="stylesheet">
    </head>
    <body>
        <%@ include file="header.jsp" %>
        <div class="container">
            <div class="row">
                <!-- Sidebar Profile -->
                <div class="col-lg-3 mb-3">
                    <div class="profile-sidebar">
                        <div class="profile-header">
                            <h5 class="user-name">
                                <c:out value="${empty sessionScope.user.fullname ? sessionScope.user.username : sessionScope.user.fullname}"/>
                            </h5>
                        </div>
                        <div class="profile-menu">
                            <a class="menu-item" href="${ctx}/orders">
                                <i class="fa fa-receipt"></i>Đơn hàng
                            </a>
                            <a class="menu-item" href="${ctx}/reviews?userId=${sessionScope.user.id}">
                                <i class="fa fa-star"></i>Đánh giá của tôi
                            </a>
                            <c:if test="${sessionScope.userRole == 'ADMIN'}">
                                <a class="menu-item" href="${ctx}/admin">
                                    <i class="fa fa-toolbox"></i>Quản trị
                                </a>
                            </c:if>
                        </div>
                    </div>
                </div>

                <!-- Main Content -->
                <div class="col-lg-9">
                    <!-- Flash Message -->
                    <c:if test="${not empty requestScope.flash}">
                        <div class="flash-message flash-${flash.type eq 'success' ? 'success' : 'error'}">
                            <i class="fa ${flash.type eq 'success' ? 'fa-check-circle' : 'fa-triangle-exclamation'}"></i>
                            <span><c:out value="${flash.message}"/></span>
                            <button type="button" class="flash-close" onclick="this.parentElement.style.display='none'">
                                <i class="fa fa-times"></i>
                            </button>
                        </div>
                    </c:if>

                    <!-- Tab Navigation -->
                    <ul class="profile-tabs" id="pills-tab" role="tablist">
                        <li class="tab-item" role="presentation">
                            <button class="tab-link active" id="pills-info-tab" data-bs-toggle="pill"
                                    data-bs-target="#pills-info" type="button" role="tab">
                                <i class="fa fa-user-pen"></i> Thông tin hồ sơ
                            </button>
                        </li>
                        <li class="tab-item" role="presentation">
                            <button class="tab-link" id="pills-password-tab" data-bs-toggle="pill"
                                    data-bs-target="#pills-password" type="button" role="tab">
                                <i class="fa fa-lock"></i> Đổi mật khẩu
                            </button>
                        </li>
                    </ul>

                    <!-- Tab Content -->
                    <div class="profile-content">
                        <div class="tab-content" id="pills-tabContent">
                            <!-- Profile Info Tab -->
                            <div class="tab-pane fade show active" id="pills-info" role="tabpanel">
                                <form method="post" action="${ctx}/profile" class="profile-form">
                                    <input type="hidden" name="action" value="updateProfile">
                                    <div class="form-section">
                                        <h6 class="section-title">Thông tin cá nhân</h6>
                                        <div class="row g-3">
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label class="form-label">Họ và tên</label>
                                                    <input class="form-input" name="fullname"
                                                           value="<c:out value='${sessionScope.user.fullname}'/>" 
                                                           placeholder="Nguyễn Văn A">
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label class="form-label">Tên đăng nhập</label>
                                                    <input class="form-input disabled" 
                                                           value="<c:out value='${sessionScope.user.username}'/>" disabled>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label class="form-label">Email</label>
                                                    <input class="form-input" name="email"
                                                           value="<c:out value='${sessionScope.user.email}'/>" 
                                                           type="email" placeholder="email@domain.com">
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label class="form-label">Số điện thoại</label>
                                                    <input class="form-input" name="phone"
                                                           value="<c:out value='${sessionScope.user.phone}'/>" 
                                                           placeholder="09xxxxxxxx">
                                                </div>
                                            </div>
                                            <div class="col-12">
                                                <div class="form-group">
                                                    <label class="form-label">Địa chỉ</label>
                                                    <input class="form-input" name="address"
                                                           value="<c:out value='${sessionScope.user.address}'/>" 
                                                           placeholder="Số nhà, đường, phường/xã, quận/huyện, tỉnh/thành...">
                                                </div>
                                            </div>
                                            <div class="col-12">
                                                <div class="form-group">
                                                    <label class="form-label">Ảnh đại diện</label>
                                                    <input class="form-input" name="avatarUrl"
                                                           value="<c:out value='${sessionScope.user.avatar}'/>" 
                                                           placeholder="https://...jpg">
                                                    <div class="form-help">Bạn có thể dán link ảnh. (Nếu muốn upload file sau mình bổ sung Multipart)</div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-actions">
                                        <button class="btn-primary">
                                            <i class="fa fa-floppy-disk"></i> Lưu thay đổi
                                        </button>
                                    </div>
                                </form>
                            </div>

                            <!-- Change Password Tab -->
                            <div class="tab-pane fade" id="pills-password" role="tabpanel">
                                <form method="post" action="${ctx}/profile" class="profile-form">
                                    <input type="hidden" name="action" value="changePassword">
                                    <div class="form-section">
                                        <h6 class="section-title">Đổi mật khẩu</h6>
                                        <div class="row g-3">
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label class="form-label">Mật khẩu hiện tại</label>
                                                    <input class="form-input" name="currentPassword" type="password" required>
                                                </div>
                                            </div>
                                            <div class="col-md-6"></div>
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label class="form-label">Mật khẩu mới</label>
                                                    <input class="form-input" name="newPassword" type="password" minlength="6" required>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label class="form-label">Nhập lại mật khẩu mới</label>
                                                    <input class="form-input" name="confirmPassword" type="password" minlength="6" required>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-actions">
                                        <button class="btn-warning">
                                            <i class="fa fa-key"></i> Đổi mật khẩu
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        <c:if test="${param.tab eq 'password'}">
            <script>
                var tabTrigger = new bootstrap.Tab(document.querySelector('#pills-password-tab'));
                tabTrigger.show();
            </script>
        </c:if>
    </body>
</html>