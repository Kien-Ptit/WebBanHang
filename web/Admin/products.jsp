<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý sản phẩm - Kien Store Admin</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" 
              integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" 
              crossorigin="anonymous" referrerpolicy="no-referrer" />
        <link rel="stylesheet" href="<c:url value='/css-admin/admin.css'/>">
        <link rel="stylesheet" href="<c:url value='/css-admin/admin-responsive.css'/>">
        <link rel="stylesheet" href="<c:url value='/css-admin/products.css'/>">
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
                            <i class="fas fa-box"></i>
                            Quản lý sản phẩm
                        </h1>
                        <a href="${pageContext.request.contextPath}/Admin/products?action=add" class="btn-add">
                            <i class="fas fa-plus"></i>
                            Thêm sản phẩm
                        </a>
                    </div>

                    <!-- Stats Cards -->
                    <div class="stats-cards">
                        <div class="stat-card blue">
                            <div class="stat-value">
                                <c:choose>
                                    <c:when test="${not empty totalProducts}">
                                        ${totalProducts}
                                    </c:when>
                                    <c:otherwise>
                                        ${fn:length(products)}
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="stat-label">
                                <i class="fas fa-box"></i>
                                Tất cả sản phẩm
                            </div>
                        </div>

                        <div class="stat-card green">
                            <div class="stat-value">
                                <c:choose>
                                    <c:when test="${not empty activeProducts}">
                                        ${activeProducts}
                                    </c:when>
                                    <c:otherwise>
                                        ${fn:length(products)}
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="stat-label">
                                <i class="fas fa-check-circle"></i>
                                Đang kinh doanh
                            </div>
                        </div>

                        <div class="stat-card orange" 
                             onclick="window.location.href = '${pageContext.request.contextPath}/Admin/products?filter=lowstock'" 
                             style="cursor: pointer;"
                             title="Click để xem chi tiết sản phẩm cần nhập hàng">
                            <div class="stat-icon">
                                <i class="fas fa-exclamation-triangle"></i>
                            </div>
                            <div class="stat-details">
                                <div class="stat-value">${lowStockCount}</div>
                                <div class="stat-label">
                                    <i class="fas fa-warehouse"></i>
                                    CẦN NHẬP HÀNG
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Filters -->
                    <div class="filters-section">
                        <form method="get" action="${pageContext.request.contextPath}/Admin/products">
                            <div class="search-box">
                                <input type="text" 
                                       name="search" 
                                       placeholder="Tìm theo tên sản phẩm, mô tả..." 
                                       value="${searchQuery}">
                            </div>

                            <div class="filter-group">
                                <label>Danh mục:</label>
                                <select name="category" onchange="this.form.submit()">
                                    <option value="">Tất cả danh mục</option>
                                    <c:forEach items="${categories}" var="cat">
                                        <option value="${cat.id}" 
                                                <c:if test="${selectedCategory eq cat.id}">selected</c:if>>
                                            ${cat.name}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="filter-group">
                                <label>Trạng thái:</label>
                                <select name="status" onchange="this.form.submit()">
                                    <option value="">Tất cả</option>
                                    <option value="active" 
                                            <c:if test="${selectedStatus eq 'active'}">selected</c:if>>
                                                Đang bán
                                            </option>
                                            <option value="inactive" 
                                            <c:if test="${selectedStatus eq 'inactive'}">selected</c:if>>
                                                Ngừng bán
                                            </option>
                                    </select>
                                </div>

                                <button type="submit" class="btn-search">
                                    <i class="fas fa-search"></i>
                                    Tìm kiếm
                                </button>
                            </form>
                        </div>

                        <!-- Products Container -->
                        <div class="products-container">
                            <div class="section-header">
                                <h2>Danh sách sản phẩm</h2>
                                <span class="product-count">
                                ${fn:length(products)} sản phẩm
                            </span>
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
                            <c:when test="${empty products}">
                                <div class="empty-state">
                                    <i class="fas fa-box-open"></i>
                                    <h3>Không tìm thấy sản phẩm nào</h3>
                                    <p>Hãy thêm sản phẩm đầu tiên của bạn!</p>
                                    <a href="${pageContext.request.contextPath}/Admin/products?action=add" 
                                       class="btn-primary">
                                        <i class="fas fa-plus"></i>
                                        Thêm sản phẩm mới
                                    </a>
                                </div>
                            </c:when>

                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="products-table">
                                        <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>Ảnh</th>
                                                <th>Thông tin sản phẩm</th>
                                                <th>Danh mục</th>
                                                <th>Giá</th>
                                                <th>Tồn kho</th>
                                                <th>Hot</th>
                                                <th>Trạng thái</th>
                                                <th>Thao tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${products}" var="product">
                                                <tr>
                                                    <td class="product-id">#${product.id}</td>

                                                    <td class="product-image">
                                                        <c:choose>
                                                            <c:when test="${not empty product.imageUrl}">
                                                                <img src="${product.imageUrl}" 
                                                                     alt="${product.name}"
                                                                     onerror="this.parentElement.innerHTML='<div class=\'no-image\'><i class=\'fas fa-image\'></i></div>'">
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div class="no-image">
                                                                    <i class="fas fa-image"></i>
                                                                </div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>

                                                    <td class="product-info">
                                                        <div class="product-name">${product.name}</div>
                                                        <div class="product-sku">SKU: ${product.id}</div>
                                                    </td>

                                                    <td class="product-category">
                                                        <c:choose>
                                                            <c:when test="${not empty product.categoryName}">
                                                                ${product.categoryName}
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted">Chưa phân loại</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>

                                                    <td class="product-price">
                                                        <c:choose>
                                                            <c:when test="${not empty product.discountPrice and product.discountPrice > 0}">
                                                                <div class="price-sale">
                                                                    <fmt:formatNumber value="${product.discountPrice}" pattern="#,###"/> đ
                                                                </div>
                                                                <div class="price-original">
                                                                    <fmt:formatNumber value="${product.price}" pattern="#,###"/> đ
                                                                </div>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div class="price-regular">
                                                                    <fmt:formatNumber value="${product.price}" pattern="#,###"/> đ
                                                                </div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>

                                                    <td class="product-stock">
                                                        <c:choose>
                                                            <c:when test="${product.stockQuantity <= 0}">
                                                                <span class="badge badge-danger">Hết hàng</span>
                                                            </c:when>
                                                            <c:when test="${product.stockQuantity <= 10}">
                                                                <span class="badge badge-warning">
                                                                    ${product.stockQuantity} (Sắp hết)
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge badge-success">
                                                                    ${product.stockQuantity}
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>

                                                    <td class="product-featured">
                                                        <c:choose>
                                                            <c:when test="${product.featured}">
                                                                <span class="badge badge-hot">
                                                                    <i class="fas fa-fire"></i> Hot
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted">-</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>

                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${product.status eq 'active'}">
                                                                <span class="badge badge-success status-toggle" 
                                                                      onclick="toggleStatus(${product.id}, '${product.name}')"
                                                                      title="Click để chuyển sang NGỪNG BÁN">
                                                                    <i class="fas fa-check-circle"></i>
                                                                    ĐANG BÁN
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge badge-secondary status-toggle" 
                                                                      onclick="toggleStatus(${product.id}, '${product.name}')"
                                                                      title="Click để chuyển sang ĐANG BÁN">
                                                                    <i class="fas fa-times-circle"></i>
                                                                    NGỪNG BÁN
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>

                                                    <td class="product-actions">
                                                        <a href="${pageContext.request.contextPath}/Admin/products?action=edit&id=${product.id}" 
                                                           class="btn-icon btn-edit" 
                                                           title="Sửa sản phẩm">
                                                            <i class="fas fa-edit"></i>
                                                        </a>

                                                        <a href="${pageContext.request.contextPath}/Admin/products?action=toggleFeatured&id=${product.id}" 
                                                           class="btn-icon btn-star" 
                                                           title="Đánh dấu Hot">
                                                            <i class="fas fa-star"></i>
                                                        </a>

                                                        <a href="${pageContext.request.contextPath}/Admin/products?action=delete&id=${product.id}" 
                                                           class="btn-icon btn-delete" 
                                                           onclick="return confirm('Bạn có chắc muốn xóa \"${product.name}\"?')"
                                                           title="Xóa">
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
            // Auto hide alerts
            setTimeout(() => {
                document.querySelectorAll('.alert').forEach(alert => {
                    alert.style.transition = 'opacity 0.5s';
                    alert.style.opacity = '0';
                    setTimeout(() => alert.remove(), 500);
                });
            }, 5000);

            // Toggle HOT without reload
            document.addEventListener('DOMContentLoaded', function () {
                const starButtons = document.querySelectorAll('.btn-star');

                starButtons.forEach(button => {
                    button.addEventListener('click', function (e) {
                        e.preventDefault();

                        const url = this.getAttribute('href');
                        const row = this.closest('tr');
                        const hotCell = row.querySelector('.product-featured');
                        const currentHtml = hotCell.innerHTML.trim();

                        // Toggle UI ngay lập tức
                        if (currentHtml.includes('badge-hot')) {
                            // Đang HOT → Bỏ HOT
                            hotCell.innerHTML = '<span class="text-muted">-</span>';
                            showToast('Đã bỏ đánh dấu HOT', 'info');
                        } else {
                            // Không HOT → Đánh dấu HOT
                            hotCell.innerHTML = `
                                <span class="badge badge-hot">
                                    <i class="fas fa-fire"></i> Hot
                                </span>
                            `;
                            showToast('Đã đánh dấu HOT', 'success');
                        }

                        // Highlight row
                        row.style.background = '#fff3cd';
                        setTimeout(() => row.style.background = '', 1000);

                        // Gửi request ở background (không chờ response)
                        fetch(url).catch(err => console.error('Error:', err));
                    });
                });
            });

            // Toast notification đơn giản
            function showToast(message, type) {
                const colors = {
                    success: {bg: '#d4edda', text: '#155724', icon: 'check-circle'},
                    info: {bg: '#d1ecf1', text: '#0c5460', icon: 'info-circle'},
                    error: {bg: '#f8d7da', text: '#721c24', icon: 'exclamation-circle'}
                };

                const color = colors[type] || colors.info;

                const toast = document.createElement('div');
                toast.style.cssText = `
                    position: fixed;
                    top: 20px;
                    right: 20px;
                    padding: 15px 25px;
                    background: ${color.bg};
                    color: ${color.text};
                    border-radius: 10px;
                    box-shadow: 0 5px 20px rgba(0,0,0,0.2);
                    z-index: 10000;
                    font-weight: 600;
                    display: flex;
                    align-items: center;
                    gap: 10px;
                    animation: slideIn 0.3s ease;
                `;

                toast.innerHTML = `
                    <i class="fas fa-${color.icon}" style="font-size: 18px;"></i>
            ${message}
                `;

                document.body.appendChild(toast);

                setTimeout(() => {
                    toast.style.animation = 'slideOut 0.3s ease';
                    setTimeout(() => toast.remove(), 300);
                }, 2500);
            }

            // CSS Animation
            const css = document.createElement('style');
            css.textContent = `
                @keyframes slideIn {
                    from { transform: translateX(100%); opacity: 0; }
                    to { transform: translateX(0); opacity: 1; }
                }
                @keyframes slideOut {
                    from { transform: translateX(0); opacity: 1; }
                    to { transform: translateX(100%); opacity: 0; }
                }
            `;
            document.head.appendChild(css);
            function toggleStatus(productId, productName) {
                const confirmed = confirm(
                        '🔄 Bạn có chắc muốn thay đổi trạng thái sản phẩm?\n\n' +
                        'Sản phẩm: ' + productName + '\n\n' +
                        '✅ ĐANG BÁN → ❌ NGỪNG BÁN\n' +
                        '❌ NGỪNG BÁN → ✅ ĐANG BÁN'
                        );

                if (confirmed) {
                    window.location.href = '${pageContext.request.contextPath}/Admin/products?action=toggleStatus&id=' + productId;
                }
            }

            /**
             * Toggle featured status (giữ nguyên)
             */
            function toggleFeatured(productId, productName) {
                const confirmed = confirm(
                        '🔥 Bạn có chắc muốn thay đổi trạng thái HOT?\n\n' +
                        'Sản phẩm: ' + productName
                        );

                if (confirmed) {
                    window.location.href = '${pageContext.request.contextPath}/Admin/products?action=toggleFeatured&id=' + productId;
                }
            }

            /**
             * Delete product confirmation
             */
            function confirmDelete(productId, productName) {
                const confirmed = confirm(
                        '⚠️ BẠN CÓ CHẮC MUỐN XÓA SẢN PHẨM NÀY?\n\n' +
                        'Sản phẩm: ' + productName + '\n\n' +
                        '❌ Hành động này KHÔNG THỂ HOÀN TÁC!'
                        );

                if (confirmed) {
                    window.location.href = '${pageContext.request.contextPath}/Admin/products?action=delete&id=' + productId;
                }
            }
        </script>
    </body>
</html>