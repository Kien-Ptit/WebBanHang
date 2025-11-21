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
        <title>Quản lý người dùng - Admin</title>

        <link rel="stylesheet" href="<c:url value='/css-admin/admin.css'/>">
        <link rel="stylesheet" href="<c:url value='/css-admin/admin-responsive.css'/>">
        <link rel="stylesheet" href="<c:url value='/css-admin/users.css'/>">
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
                        <i class="fas fa-users"></i> Quản lý người dùng
                    </h1>

                    <div class="header-actions">
                        <button onclick="showAddUserModal()" class="btn btn-primary">
                            <i class="fas fa-user-plus"></i> Thêm người dùng
                        </button>
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

                    <div class="stats-grid" style="margin-bottom: 2rem;">

                        <div class="stat-card primary">
                            <div class="stat-header">
                                <div class="stat-title">Tổng người dùng</div>
                                <div class="stat-icon primary">
                                    <i class="fas fa-users"></i>
                                </div>
                            </div>
                            <div class="stat-value">${totalUsers != null ? totalUsers : 0}</div>
                        </div>

                        <div class="stat-card success">
                            <div class="stat-header">
                                <div class="stat-title">User mới hôm nay</div>
                                <div class="stat-icon success">
                                    <i class="fas fa-user-check"></i>
                                </div>
                            </div>
                            <div class="stat-value">${todayNewUsers != null ? todayNewUsers : 0}</div>
                        </div>

                        <div class="stat-card warning">
                            <div class="stat-header">
                                <div class="stat-title">Admin</div>
                                <div class="stat-icon warning">
                                    <i class="fas fa-user-shield"></i>
                                </div>
                            </div>
                            <div class="stat-value">${totalAdmins != null ? totalAdmins : 0}</div>
                        </div>

                    </div>

                    <div class="card" style="margin-bottom: 1.5rem;">
                        <div class="card-body">
                            <form method="get" action="<c:url value='/Admin/users'/>" style="display: flex; gap: 1rem; align-items: center;">
                                <input type="text" 
                                       name="search" 
                                       class="form-control" 
                                       placeholder="Tìm theo tên, email, số điện thoại..."
                                       value="${searchQuery}"
                                       style="flex: 1;">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-search"></i> Tìm kiếm
                                </button>

                                <select class="form-control" 
                                        onchange="window.location.href = '<c:url value='/Admin/users'/>?role=' + this.value"
                                        style="max-width: 200px;">
                                    <option value="">Tất cả vai trò</option>
                                    <option value="admin" ${param.role eq 'admin' ? 'selected' : ''}>Admin</option>
                                    <option value="customer" ${param.role eq 'customer' ? 'selected' : ''}>Customer</option>
                                </select>
                            </form>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">Danh sách người dùng</h3>
                            <span class="badge badge-primary">${fn:length(users)} người dùng</span>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="admin-table">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Họ và tên</th>
                                            <th>Email</th>
                                            <th>Số điện thoại</th>
                                            <th>Vai trò</th>
                                            <th>Ngày tạo</th>
                                            <th>Trạng thái</th>
                                            <th>Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="user" items="${users}">
                                            <tr>
                                                <td style="font-weight: 700; color: #667eea;">
                                                    #${user.id}
                                                </td>
                                                <td>
                                                    <div style="display: flex; align-items: center; gap: 0.75rem;">
                                                        <div class="user-avatar" style="width: 40px; height: 40px; font-size: 1rem;">
                                                            ${user.fullname.substring(0,1).toUpperCase()}
                                                        </div>
                                                        <div>
                                                            <div style="font-weight: 600;">${user.fullname}</div>
                                                            <div style="font-size: 0.875rem; color: #6c757d;">
                                                                ${user.username}
                                                            </div>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>${user.email}</td>
                                                <td>${user.phone}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${user.role eq 'admin'}">
                                                            <span class="badge badge-danger">
                                                                <i class="fas fa-user-shield"></i> Admin
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge badge-primary">
                                                                <i class="fas fa-user"></i> Customer
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy"/>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${user.status eq 'active'}">
                                                            <span class="badge badge-success">Hoạt động</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge badge-danger">Bị khóa</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <div style="display: flex; gap: 0.5rem;">
                                                        <button onclick="editUser(${user.id})" 
                                                                class="btn btn-sm btn-primary"
                                                                title="Sửa">
                                                            <i class="fas fa-edit"></i>
                                                        </button>

                                                        <c:if test="${user.id != sessionScope.user.id}">
                                                            <button onclick="toggleUserStatus(${user.id}, '${user.status}')" 
                                                                    class="btn btn-sm ${user.status eq 'active' ? 'btn-danger' : 'btn-success'}"
                                                                    title="${user.status eq 'active' ? 'Khóa' : 'Mở khóa'}">
                                                                <i class="fas fa-${user.status eq 'active' ? 'lock' : 'unlock'}"></i>
                                                            </button>

                                                            <button onclick="deleteUser(${user.id}, '${user.fullname}')" 
                                                                    class="btn btn-sm btn-danger"
                                                                    title="Xóa">
                                                                <i class="fas fa-trash"></i>
                                                            </button>
                                                        </c:if>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>

                                        <c:if test="${empty users}">
                                            <tr>
                                                <td colspan="8" style="text-align: center; padding: 3rem; color: #6c757d;">
                                                    <i class="fas fa-user-slash" style="font-size: 3rem; display: block; margin-bottom: 1rem;"></i>
                                                    Không tìm thấy người dùng nào
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

        <div id="userModal" class="modal">
            <div class="modal-content" style="max-width: 600px;">
                <div class="modal-header">
                    <h3 class="modal-title" id="userModalTitle">
                        <i class="fas fa-user-plus"></i> Thêm người dùng mới
                    </h3>
                </div>
                <form method="post" action="<c:url value='/Admin/users'/>" id="userForm">
                    <input type="hidden" name="action" id="userAction" value="create">
                    <input type="hidden" name="userId" id="userId">

                    <div class="modal-body">

                        <div class="form-group">
                            <label class="form-label">Họ và tên <span style="color: #e74c3c;">*</span></label>
                            <input type="text" name="fullname" id="fullname" class="form-control" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Email <span style="color: #e74c3c;">*</span></label>
                            <input type="email" name="email" id="email" class="form-control" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Số điện thoại</label>
                            <input type="tel" name="phone" id="phone" class="form-control">
                        </div>

                        <div class="form-group">
                            <label class="form-label">Tên đăng nhập <span style="color: #e74c3c;">*</span></label>
                            <input type="text" name="username" id="username" class="form-control" required>
                        </div>

                        <div class="form-group" id="passwordGroup">
                            <label class="form-label">Mật khẩu <span style="color: #e74c3c;">*</span></label>
                            <input type="password" name="password" id="password" class="form-control" minlength="6">
                        </div>

                        <div class="form-group">
                            <label class="form-label">Vai trò</label>
                            <select name="role" id="role" class="form-control">
                                <option value="customer">Customer</option>
                                <option value="admin">Admin</option>
                            </select>
                        </div>

                    </div>

                    <div class="modal-footer">
                        <button type="button" onclick="closeUserModal()" class="btn btn-secondary">
                            Hủy
                        </button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i> Lưu
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            // ========== SHOW ADD MODAL ==========
            function showAddUserModal() {
                document.getElementById('userModalTitle').innerHTML = '<i class="fas fa-user-plus"></i> Thêm người dùng mới';
                document.getElementById('userAction').value = 'create';
                document.getElementById('userForm').reset();
                document.getElementById('userId').value = '';

                // ✅ ENABLE USERNAME KHI THÊM MỚI
                const usernameField = document.getElementById('username');
                usernameField.disabled = false;
                usernameField.style.background = 'white';
                usernameField.style.cursor = 'text';

                // Hiện password field
                document.getElementById('password').required = true;
                document.getElementById('passwordGroup').style.display = 'block';

                document.getElementById('userModal').classList.add('show');
            }

            // ========== EDIT USER ==========
            function editUser(id) {
                fetch('<c:url value="/Admin/users"/>?action=get&id=' + id)
                        .then(response => response.json())
                        .then(user => {
                            console.log('User data:', user);

                            document.getElementById('userModalTitle').innerHTML = '<i class="fas fa-edit"></i> Sửa thông tin người dùng';
                            document.getElementById('userAction').value = 'update';
                            document.getElementById('userId').value = user.id;
                            document.getElementById('fullname').value = user.fullname;
                            document.getElementById('email').value = user.email;
                            document.getElementById('phone').value = user.phone || '';
                            document.getElementById('username').value = user.username;
                            document.getElementById('role').value = user.role;

                            // ✅ DISABLE USERNAME KHI EDIT
                            const usernameField = document.getElementById('username');
                            usernameField.disabled = true;
                            usernameField.style.background = '#e9ecef';
                            usernameField.style.cursor = 'not-allowed';

                            // Ẩn password khi edit
                            document.getElementById('password').required = false;
                            document.getElementById('passwordGroup').style.display = 'none';

                            document.getElementById('userModal').classList.add('show');
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            alert('❌ Có lỗi khi lấy thông tin người dùng!');
                        });
            }

            // ========== CLOSE MODAL ==========
            function closeUserModal() {
                document.getElementById('userModal').classList.remove('show');
            }

            // ========== TOGGLE STATUS ==========
            function toggleUserStatus(id, currentStatus) {
                const action = currentStatus === 'active' ? 'khóa' : 'mở khóa';
                const icon = currentStatus === 'active' ? '🔒' : '🔓';

                if (confirm(icon + ' Bạn có chắc muốn ' + action + ' người dùng này?\n\nThao tác này sẽ ' +
                        (currentStatus === 'active' ? 'vô hiệu hóa tài khoản' : 'kích hoạt lại tài khoản') + '.')) {

                    console.log('Toggling user status:', id);
                    window.location.href = '<c:url value="/Admin/users"/>?action=toggle&id=' + id;
                }
            }

            // ========== DELETE USER ==========
            function deleteUser(id, name) {
                if (confirm('⚠️ Bạn có chắc muốn xóa người dùng "' + name + '"?\n\n❌ Hành động này KHÔNG THỂ hoàn tác!')) {
                    window.location.href = '<c:url value="/Admin/users"/>?action=delete&id=' + id;
                }
            }

            // ========== CLOSE MODAL WHEN CLICK OUTSIDE ==========
            document.getElementById('userModal').addEventListener('click', function (e) {
                if (e.target === this) {
                    closeUserModal();
                }
            });

            // ========== MOBILE SIDEBAR TOGGLE ==========
            function toggleMobileSidebar() {
                const sidebar = document.getElementById('adminSidebar');
                const overlay = document.getElementById('mobileOverlay');

                if (sidebar)
                    sidebar.classList.toggle('show');
                if (overlay)
                    overlay.classList.toggle('show');
            }

            // ========== AUTO HIDE ALERTS ==========
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