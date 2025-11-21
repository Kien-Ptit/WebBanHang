<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <c:choose>
            <c:when test="${not empty category}">Sửa danh mục</c:when>
            <c:otherwise>Thêm danh mục mới</c:otherwise>
        </c:choose>
        - Kien Store Admin
    </title>
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <!-- CSS Files -->
    <link rel="stylesheet" href="<c:url value='/css-admin/admin.css'/>">
    <link rel="stylesheet" href="<c:url value='/css-admin/admin-responsive.css'/>">
    <link rel="stylesheet" href="<c:url value='/css-admin/category-form.css'/>">
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
                        <c:choose>
                            <c:when test="${not empty category}">
                                Sửa danh mục: ${category.name}
                            </c:when>
                            <c:otherwise>
                                Thêm danh mục mới
                            </c:otherwise>
                        </c:choose>
                    </h1>
                    <a href="${pageContext.request.contextPath}/Admin/categories" class="btn-secondary">
                        <i class="fas fa-arrow-left"></i>
                        Quay lại
                    </a>
                </div>

                <!-- Form Container -->
                <div class="form-container">
                    <form method="post" action="${pageContext.request.contextPath}/Admin/categories" id="categoryForm">
                        <input type="hidden" name="action" value="save">
                        <c:if test="${not empty category}">
                            <input type="hidden" name="id" value="${category.id}">
                        </c:if>

                        <!-- Category Name -->
                        <div class="form-group">
                            <label for="name">
                                <i class="fas fa-tag"></i>
                                Tên danh mục 
                                <span>*</span>
                            </label>
                            <input type="text" 
                                   id="name" 
                                   name="name" 
                                   value="${category.name}" 
                                   required 
                                   placeholder="Nhập tên danh mục"
                                   autofocus>
                            <small class="form-text">
                                <i class="fas fa-lightbulb"></i>
                                Ví dụ: Áo Nam, Quần Nữ, Phụ Kiện...
                            </small>
                        </div>

                        <!-- Description -->
                        <div class="form-group">
                            <label for="description">
                                <i class="fas fa-align-left"></i>
                                Mô tả danh mục
                            </label>
                            <textarea id="description" 
                                      name="description" 
                                      placeholder="Nhập mô tả chi tiết về danh mục này">${category.description}</textarea>
                            <small class="form-text">
                                <i class="fas fa-lightbulb"></i>
                                Mô tả chi tiết giúp khách hàng hiểu rõ hơn về danh mục sản phẩm
                            </small>
                        </div>

                        <!-- Form Actions -->
                        <div class="form-actions">
                            <a href="${pageContext.request.contextPath}/Admin/categories" class="btn-secondary">
                                <i class="fas fa-times"></i>
                                Hủy bỏ
                            </a>
                            <button type="submit" class="btn-primary">
                                <i class="fas fa-save"></i>
                                <c:choose>
                                    <c:when test="${not empty category}">
                                        Cập nhật
                                    </c:when>
                                    <c:otherwise>
                                        Thêm mới
                                    </c:otherwise>
                                </c:choose>
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script>
        /**
         * Auto-focus on name field
         */
        document.addEventListener('DOMContentLoaded', function() {
            document.getElementById('name').focus();
        });

        /**
         * Validate form before submit
         */
        document.getElementById('categoryForm').addEventListener('submit', function(e) {
            const name = document.getElementById('name').value.trim();
            
            if (name.length < 2) {
                e.preventDefault();
                alert('⚠️ Tên danh mục phải có ít nhất 2 ký tự!');
                document.getElementById('name').focus();
                return false;
            }
            
            if (name.length > 100) {
                e.preventDefault();
                alert('⚠️ Tên danh mục không được vượt quá 100 ký tự!');
                document.getElementById('name').focus();
                return false;
            }
            
            return true;
        });
    </script>
</body>
</html>