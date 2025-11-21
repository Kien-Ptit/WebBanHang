<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <c:choose>
            <c:when test="${not empty product}">Sửa sản phẩm</c:when>
            <c:otherwise>Thêm sản phẩm mới</c:otherwise>
        </c:choose>
        - Kien Store Admin
    </title>

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <!-- CSS Files -->
    <link rel="stylesheet" href="<c:url value='/css-admin/admin.css'/>">
    <link rel="stylesheet" href="<c:url value='/css-admin/admin-responsive.css'/>">
    <link rel="stylesheet" href="<c:url value='/css-admin/product-form.css'/>">
</head>
<body>
    <div class="admin-container">
        <jsp:include page="sidebar.jsp" />

        <div class="main-content">
            <div class="content-wrapper">
                <!-- Page Header -->
                <div class="page-header">
                    <h1>
                        <i class="fas fa-edit"></i>
                        <c:choose>
                            <c:when test="${not empty product}">
                                Sửa sản phẩm: ${product.name}
                            </c:when>
                            <c:otherwise>
                                Thêm sản phẩm mới
                            </c:otherwise>
                        </c:choose>
                    </h1>
                    <a href="${pageContext.request.contextPath}/Admin/products" class="btn-secondary">
                        <i class="fas fa-arrow-left"></i>
                        Quay lại
                    </a>
                </div>

                <!-- Form Container -->
                <div class="form-container">
                    <form method="post" action="${pageContext.request.contextPath}/Admin/products" enctype="multipart/form-data" id="productForm">
                        <input type="hidden" name="action" value="save">
                        <c:if test="${not empty product}">
                            <input type="hidden" name="id" value="${product.id}">
                        </c:if>

                        <!-- Section 1: Thông tin cơ bản -->
                        <div class="form-section">
                            <h3 class="form-section-title">
                                <i class="fas fa-info-circle"></i>
                                Thông tin cơ bản
                            </h3>

                            <div class="form-group">
                                <label for="name">
                                    <i class="fas fa-tag"></i>
                                    Tên sản phẩm 
                                    <span class="required">*</span>
                                </label>
                                <input type="text" id="name" name="name" value="${product.name}" required placeholder="Nhập tên sản phẩm" autofocus>
                                <small class="form-text">
                                    <i class="fas fa-lightbulb"></i>
                                    Tên sản phẩm sẽ hiển thị trên website
                                </small>
                            </div>

                            <div class="form-group">
                                <label for="description">
                                    <i class="fas fa-align-left"></i>
                                    Mô tả sản phẩm
                                </label>
                                <textarea id="description" name="description" placeholder="Nhập mô tả chi tiết về sản phẩm" rows="4">${product.description}</textarea>
                                <small class="form-text">
                                    <i class="fas fa-lightbulb"></i>
                                    Mô tả chi tiết giúp khách hàng hiểu rõ hơn về sản phẩm
                                </small>
                            </div>
                        </div>

                        <!-- Section 2: Giá & Kho -->
                        <div class="form-section">
                            <h3 class="form-section-title">
                                <i class="fas fa-dollar-sign"></i>
                                Giá & Kho hàng
                            </h3>

                            <div class="form-row">
                                <div class="form-group">
                                    <label for="price">
                                        <i class="fas fa-money-bill-wave"></i>
                                        Giá gốc 
                                        <span class="required">*</span>
                                    </label>
                                    <div class="input-with-suffix">
                                        <input type="text" 
                                               id="price" 
                                               name="price" 
                                               value="${product.price}" 
                                               required 
                                               placeholder="0"
                                               class="price-input">
                                        <span class="input-suffix">đ</span>
                                    </div>
                                    <small class="form-text">
                                        <i class="fas fa-info-circle"></i>
                                        Đơn vị: VNĐ (ví dụ: 150.000)
                                    </small>
                                </div>

                                <div class="form-group">
                                    <label for="discountPrice">
                                        <i class="fas fa-percentage"></i>
                                        Giá khuyến mãi
                                    </label>
                                    <div class="input-with-suffix">
                                        <input type="text" 
                                               id="discountPrice" 
                                               name="discountPrice" 
                                               value="${product.discountPrice}" 
                                               placeholder="0"
                                               class="price-input">
                                        <span class="input-suffix">đ</span>
                                    </div>
                                    <small class="form-text">
                                        <i class="fas fa-info-circle"></i>
                                        Để trống nếu không giảm giá
                                    </small>
                                </div>
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label for="categoryId">
                                        <i class="fas fa-list"></i>
                                        Danh mục 
                                        <span class="required">*</span>
                                    </label>
                                    <select id="categoryId" name="categoryId" required>
                                        <option value="">-- Chọn danh mục --</option>
                                        <c:forEach items="${categories}" var="cat">
                                            <option value="${cat.id}" <c:if test="${product.categoryId eq cat.id}">selected</c:if>>
                                                ${cat.name}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label for="stock">
                                        <i class="fas fa-warehouse"></i>
                                        Tồn kho 
                                        <span class="required">*</span>
                                    </label>
                                    <input type="number" 
                                           id="stock" 
                                           name="stock" 
                                           value="${product.stockQuantity}" 
                                           required 
                                           min="0" 
                                           placeholder="0">
                                    <small class="form-text">
                                        <i class="fas fa-info-circle"></i>
                                        Số lượng sản phẩm trong kho
                                    </small>
                                </div>
                            </div>
                        </div>

                        <!-- Section 3: Chi tiết -->
                        <div class="form-section">
                            <h3 class="form-section-title">
                                <i class="fas fa-tags"></i>
                                Chi tiết sản phẩm
                            </h3>

                            <div class="form-row-3">
                                <div class="form-group">
                                    <label for="size">
                                        <i class="fas fa-ruler"></i>
                                        Kích thước
                                    </label>
                                    <input type="text" id="size" name="size" value="${product.size}" placeholder="S, M, L, XL...">
                                </div>

                                <div class="form-group">
                                    <label for="color">
                                        <i class="fas fa-palette"></i>
                                        Màu sắc
                                    </label>
                                    <input type="text" id="color" name="color" value="${product.color}" placeholder="Đỏ, Xanh, Vàng...">
                                </div>

                                <div class="form-group">
                                    <label for="material">
                                        <i class="fas fa-tshirt"></i>
                                        Chất liệu
                                    </label>
                                    <input type="text" id="material" name="material" value="${product.material}" placeholder="Cotton, Polyester...">
                                </div>
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label for="brand">
                                        <i class="fas fa-copyright"></i>
                                        Thương hiệu
                                    </label>
                                    <input type="text" id="brand" name="brand" value="${product.brand}" placeholder="Nike, Adidas...">
                                </div>

                                <div class="form-group">
                                    <label for="status">
                                        <i class="fas fa-toggle-on"></i>
                                        Trạng thái
                                    </label>
                                    <select id="status" name="status">
                                        <option value="active" <c:if test="${product.status eq 'active'}">selected</c:if>>Đang bán</option>
                                        <option value="inactive" <c:if test="${product.status eq 'inactive'}">selected</c:if>>Ngừng bán</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <!-- Section 4: Hình ảnh -->
                        <div class="form-section">
                            <h3 class="form-section-title">
                                <i class="fas fa-image"></i>
                                Hình ảnh sản phẩm
                            </h3>

                            <div class="form-group">
                                <label for="imageUrl">
                                    <i class="fas fa-link"></i>
                                    URL Hình ảnh
                                </label>
                                <input type="text" id="imageUrl" name="imageUrl" value="${product.imageUrl}" placeholder="https://example.com/image.jpg">
                                <small class="form-text">
                                    <i class="fas fa-lightbulb"></i>
                                    Nhập đường dẫn URL của hình ảnh sản phẩm
                                </small>
                            </div>

                            <div class="form-group">
                                <label for="imageFile">
                                    <i class="fas fa-upload"></i>
                                    Hoặc tải ảnh lên
                                </label>
                                <input type="file" id="imageFile" name="imageFile" accept="img/products/*">
                                <small class="form-text">
                                    <i class="fas fa-info-circle"></i>
                                    Chấp nhận: JPG, PNG, GIF (Tối đa 10MB)
                                </small>
                            </div>

                            <c:if test="${not empty product.imageUrl}">
                                <div class="image-preview">
                                    <span class="image-preview-label">
                                        <i class="fas fa-image"></i>
                                        Hình ảnh hiện tại:
                                    </span>
                                    <img src="${product.imageUrl}" alt="${product.name}">
                                </div>
                            </c:if>
                        </div>

                        <!-- Featured Checkbox -->
                        <div class="form-group">
                            <div class="checkbox-group">
                                <input type="checkbox" id="featured" name="featured" value="true" <c:if test="${product.featured}">checked</c:if>>
                                <label for="featured">
                                    <i class="fas fa-fire"></i>
                                    Đánh dấu là sản phẩm HOT
                                </label>
                            </div>
                            <small class="form-text" style="margin-left: 36px;">
                                <i class="fas fa-info-circle"></i>
                                Sản phẩm HOT sẽ hiển thị ở vị trí nổi bật trên trang chủ
                            </small>
                        </div>

                        <!-- Form Actions -->
                        <div class="form-actions">
                            <a href="${pageContext.request.contextPath}/Admin/products" class="btn-secondary">
                                <i class="fas fa-times"></i>
                                Hủy bỏ
                            </a>
                            <button type="submit" class="btn-primary">
                                <i class="fas fa-save"></i>
                                <c:choose>
                                    <c:when test="${not empty product}">Cập nhật</c:when>
                                    <c:otherwise>Thêm mới</c:otherwise>
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
         * Format VND - Add thousand separators
         */
        function formatVND(value) {
            let number = value.replace(/\D/g, '');
            if (!number) return '';
            return number.replace(/\B(?=(\d{3})+(?!\d))/g, '.');
        }

        /**
         * Get raw number value
         */
        function getRawValue(value) {
            return value.replace(/\./g, '');
        }

        /**
         * Setup price input with auto-format
         */
        function setupPriceInput(inputId) {
            const input = document.getElementById(inputId);
            if (!input) return;

            input.addEventListener('input', function(e) {
                const cursorPos = this.selectionStart;
                const oldLength = this.value.length;
                
                const rawValue = getRawValue(this.value);
                const formatted = formatVND(rawValue);
                
                this.value = formatted;
                
                const newLength = formatted.length;
                const diff = newLength - oldLength;
                this.setSelectionRange(cursorPos + diff, cursorPos + diff);
            });

            input.addEventListener('blur', function() {
                if (this.value) {
                    this.value = formatVND(getRawValue(this.value));
                }
            });

            // Initial format
            if (input.value) {
                input.value = formatVND(getRawValue(input.value.toString()));
            }
        }

        /**
         * Form submit handler
         */
        document.getElementById('productForm').addEventListener('submit', function(e) {
            const name = document.getElementById('name').value.trim();
            const priceInput = document.getElementById('price');
            const discountInput = document.getElementById('discountPrice');
            const categoryId = document.getElementById('categoryId').value;
            const stock = parseInt(document.getElementById('stock').value) || 0;

            // Get raw values
            const priceValue = getRawValue(priceInput.value);
            const discountValue = getRawValue(discountInput.value);

            // Validations
            if (name.length < 3) {
                e.preventDefault();
                alert('⚠️ Tên sản phẩm phải có ít nhất 3 ký tự!');
                document.getElementById('name').focus();
                return false;
            }

            if (!priceValue || parseInt(priceValue) <= 0) {
                e.preventDefault();
                alert('⚠️ Giá sản phẩm phải lớn hơn 0!');
                priceInput.focus();
                return false;
            }

            if (!categoryId) {
                e.preventDefault();
                alert('⚠️ Vui lòng chọn danh mục!');
                document.getElementById('categoryId').focus();
                return false;
            }

            if (discountValue && parseInt(discountValue) > parseInt(priceValue)) {
                e.preventDefault();
                alert('⚠️ Giá khuyến mãi không được lớn hơn giá gốc!');
                discountInput.focus();
                return false;
            }

            if (stock < 0) {
                e.preventDefault();
                alert('⚠️ Số lượng tồn kho không hợp lệ!');
                document.getElementById('stock').focus();
                return false;
            }

            // Create hidden inputs with raw values
            priceInput.name = 'price_display';
            discountInput.name = 'discountPrice_display';

            const hiddenPrice = document.createElement('input');
            hiddenPrice.type = 'hidden';
            hiddenPrice.name = 'price';
            hiddenPrice.value = priceValue;

            const hiddenDiscount = document.createElement('input');
            hiddenDiscount.type = 'hidden';
            hiddenDiscount.name = 'discountPrice';
            hiddenDiscount.value = discountValue || '0';

            this.appendChild(hiddenPrice);
            this.appendChild(hiddenDiscount);

            return true;
        });

        /**
         * Image validation
         */
        document.getElementById('imageFile').addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (file && file.size > 10 * 1024 * 1024) {
                alert('⚠️ File quá lớn! Vui lòng chọn file dưới 10MB');
                this.value = '';
            }
        });

        /**
         * Initialize on load
         */
        document.addEventListener('DOMContentLoaded', function() {
            setupPriceInput('price');
            setupPriceInput('discountPrice');
        });
    </script>
</body>
</html>