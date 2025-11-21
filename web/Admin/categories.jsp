<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Danh mục - Kien Store Admin</title>
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <!-- CSS Files -->
    <link rel="stylesheet" href="<c:url value='/css-admin/admin.css'/>">
    <link rel="stylesheet" href="<c:url value='/css-admin/admin-responsive.css'/>">
    <link rel="stylesheet" href="<c:url value='/css-admin/categories.css'/>">
</head>
<body>
    <div class="admin-container">
        <!-- Sidebar -->
        <jsp:include page="sidebar.jsp" />
        
        <div class="main-content">
            <div class="content-wrapper">
                <!-- Page Header -->
                <div class="page-header">
                    <h1>
                        <i class="fas fa-tags"></i>
                        Quản lý Danh mục
                    </h1>
                    <a href="${pageContext.request.contextPath}/Admin/categories?action=add" class="btn-add">
                        <i class="fas fa-plus"></i>
                        Thêm danh mục
                    </a>
                </div>

                <!-- Stats Cards -->
                <div class="stats-cards">
                    <div class="stat-card purple">
                        <div class="stat-value">
                            <c:choose>
                                <c:when test="${not empty totalCategories}">
                                    ${totalCategories}
                                </c:when>
                                <c:otherwise>
                                    ${fn:length(categories)}
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="stat-label">
                            <i class="fas fa-tags"></i>
                            Tổng danh mục
                        </div>
                    </div>
                    
                    <div class="stat-card green">
                        <div class="stat-value">
                            <c:choose>
                                <c:when test="${not empty activeCategories}">
                                    ${activeCategories}
                                </c:when>
                                <c:otherwise>
                                    ${fn:length(categories)}
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="stat-label">
                            <i class="fas fa-eye"></i>
                            Đang hiển thị
                        </div>
                    </div>
                    
                    <div class="stat-card orange">
                        <div class="stat-value">0</div>
                        <div class="stat-label">
                            <i class="fas fa-folder"></i>
                            Danh mục cha
                        </div>
                    </div>
                </div>

                <!-- Categories Container -->
                <div class="categories-container">
                    <div class="section-header">
                        <h2>Danh sách danh mục</h2>
                    </div>

                    <!-- Alerts -->
                    <c:if test="${not empty success}">
                        <div class="alert alert-success">
                            <i class="fas fa-check-circle"></i>
                            ${success}
                        </div>
                    </c:if>

                    <c:if test="${not empty error}">
                        <div class="alert alert-error">
                            <i class="fas fa-exclamation-circle"></i>
                            ${error}
                        </div>
                    </c:if>

                    <!-- Table -->
                    <c:choose>
                        <c:when test="${empty categories}">
                            <div class="empty-state">
                                <i class="fas fa-tags"></i>
                                <h3>Chưa có danh mục nào</h3>
                                <p>Hãy tạo danh mục đầu tiên để phân loại sản phẩm!</p>
                                <a href="${pageContext.request.contextPath}/Admin/categories?action=add" 
                                   class="btn-primary">
                                    <i class="fas fa-plus"></i>
                                    Thêm danh mục đầu tiên
                                </a>
                            </div>
                        </c:when>
                        
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="categories-table">
                                    <thead>
                                        <tr>
                                            <th style="width: 100px;">ID</th>
                                            <th style="width: 280px;">TÊN DANH MỤC</th>
                                            <th>MÔ TÃ</th>
                                            <th style="width: 180px;">SỐ SẢN PHẨM</th>
                                            <th style="width: 180px;">THAO TÁC</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${categories}" var="category">
                                            <tr>
                                                <td class="category-id">#${category.id}</td>
                                                
                                                <td>
                                                    <div class="category-name">${category.name}</div>
                                                </td>
                                                
                                                <td class="category-description">
                                                    <c:choose>
                                                        <c:when test="${not empty category.description}">
                                                            <c:choose>
                                                                <c:when test="${fn:length(category.description) > 120}">
                                                                    ${fn:substring(category.description, 0, 120)}...
                                                                </c:when>
                                                                <c:otherwise>
                                                                    ${category.description}
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="color: #adb5bd; font-style: italic;">
                                                                Chưa có mô tả
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${category.productCount > 0}">
                                                            <span class="badge badge-info">
                                                                <i class="fas fa-box"></i>
                                                                ${category.productCount} sản phẩm
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge badge-secondary">
                                                                0 sản phẩm
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                
                                                <td class="category-actions">
                                                    <a href="${pageContext.request.contextPath}/Admin/categories?action=edit&id=${category.id}" 
                                                       class="btn-icon btn-edit" 
                                                       title="Sửa danh mục">
                                                        <i class="fas fa-edit"></i>
                                                    </a>
                                                    
                                                    <a href="${pageContext.request.contextPath}/Admin/categories?action=delete&id=${category.id}" 
                                                       class="btn-icon btn-delete" 
                                                       onclick="return confirmDelete('${category.name}', ${category.productCount})"
                                                       title="Xóa danh mục">
                                                        <i class="fas fa-trash"></i>
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <script>
        /**
         * Auto hide alerts after 5 seconds
         */
        setTimeout(() => {
            document.querySelectorAll('.alert').forEach(alert => {
                alert.style.transition = 'opacity 0.5s';
                alert.style.opacity = '0';
                setTimeout(() => alert.remove(), 500);
            });
        }, 5000);

        /**
         * Confirm delete with product count check
         */
        function confirmDelete(categoryName, productCount) {
            if (productCount > 0) {
                alert(
                    '⚠️ KHÔNG THỂ XÓA\n\n' +
                    'Danh mục "' + categoryName + '" đang có ' + productCount + ' sản phẩm.\n\n' +
                    '👉 Vui lòng chuyển các sản phẩm sang danh mục khác trước khi xóa!'
                );
                return false;
            }
            
            return confirm(
                '⚠️ XÁC NHẬN XÓA\n\n' +
                'Bạn có chắc muốn xóa danh mục:\n' +
                '"' + categoryName + '"\n\n' +
                '❌ Thao tác này KHÔNG THỂ hoàn tác!'
            );
        }
    </script>
</body>
</html>