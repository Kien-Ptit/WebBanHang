<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<fmt:setLocale value="vi_VN"/>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Sản phẩm</title>
        <link rel="stylesheet" href="<c:url value='/css/products.css'/>?v=99">
    </head>
    <body class="products-page">

        <%@ include file="header.jsp" %>

        <div class="wrap">

            <!-- TOOLBAR GỌN: Search + Category + Price + Sort -->
            <form class="toolbar toolbar--compact" method="get" action="<c:url value='/products'/>">
                <div class="field searchbox">
                    <input type="text" name="q" placeholder="Tìm kiếm sản phẩm..." value="${q}"/>
                    <button type="submit" title="Tìm kiếm">🔍</button>
                </div>

                <!-- Thay thế phần select category này -->
                <div class="field">
                    <label>Danh mục</label>
                    <select name="category" onchange="this.form.submit()">
                        <option value="">Tất cả</option>
                        <c:forEach var="c" items="${categories}">
                            <option value="${c['id']}" 
                                    ${(c['id'] == category || (not empty categoryIds && categoryIds.contains(c['id']))) ? 'selected':''}>${c['name']}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="field">
                    <label>Giá</label>
                    <select name="price" onchange="this.form.submit()">
                        <option value="" ${empty price?'selected':''}>Tất cả</option>
                        <option value="under_500" ${price=='under_500'?'selected':''}>Dưới 500k</option>
                        <option value="500_1000" ${price=='500_1000'?'selected':''}>500k – 1 triệu</option>
                        <option value="1000_2000" ${price=='1000_2000'?'selected':''}>1 – 2 triệu</option>
                        <option value="over_2000" ${price=='over_2000'?'selected':''}>Trên 2 triệu</option>
                    </select>
                </div>

                <div class="field">
                    <label>Sắp xếp</label>
                    <select name="sort" onchange="this.form.submit()">
                        <option value="newest"     ${sort=='newest'?'selected':''}>Mới nhất</option>
                        <option value="price_asc"  ${sort=='price_asc'?'selected':''}>Giá ↑</option>
                        <option value="price_desc" ${sort=='price_desc'?'selected':''}>Giá ↓</option>
                        <option value="popular"    ${sort=='popular'?'selected':''}>Phổ biến</option>
                    </select>
                </div>

                <a class="btn btn-ghost" href="<c:url value='/products'/>">Xóa</a>
            </form>

            <!-- LƯỚI SẢN PHẨM (full chiều ngang) -->
            <div class="products-grid">
                <c:forEach var="p" items="${products}">
                    <article class="product-card">
                        <a class="product-image" href="<c:url value='/detail'><c:param name='id' value='${p.id}'/></c:url>">
                            <c:choose>
                                <c:when test="${fn:startsWith(p.image_url,'http')}">
                                    <img src="${p.image_url}" alt="${p.name}">
                                </c:when>
                                <c:otherwise>
                                    <img src="<c:url value='/img/${p.image_url}'/>" alt="${p.name}">
                                </c:otherwise>
                            </c:choose>
                        </a>

                        <div class="product-body">
                            <h3 class="product-title"><c:out value="${p.name}"/></h3>
                            <p class="product-desc"><c:out value="${p.description}"/></p>

                            <div class="product-price">
                                <c:choose>
                                    <c:when test="${p.discount_price != null && p.price != null && p.price > 0}">
                                        <span class="price-new">
                                            <fmt:formatNumber value="${p.discount_price}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ
                                        </span>
                                        <span class="price-old">
                                            <fmt:formatNumber value="${p.price}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ
                                        </span>
                                        <span class="price-off">
                                            -<fmt:formatNumber value="${(1 - (p.discount_price / p.price)) * 100}" maxFractionDigits="0"/>%
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="price-new">
                                            <fmt:formatNumber value="${p.price}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </div>


                            <!-- Footer dính đáy -->
                            <div class="product-footer">
                                <form action="${pageContext.request.contextPath}/add" method="post" class="mt-3">
                                    <input type="hidden" name="productId" value="${product.id}">
                                    <input type="hidden" name="qty" value="1" />

                                    <c:if test="${not empty product.availableSizes}">
                                        <div class="mb-2">
                                            <label class="form-label">Size</label>
                                            <select name="size" class="form-select" required>
                                                <option value="" disabled selected>-- Chọn size --</option>
                                                <c:forEach var="s" items="${product.availableSizes}">
                                                    <option value="${s}">${s}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </c:if>

                                    <c:if test="${not empty product.availableColors}">
                                        <div class="mb-3">
                                            <label class="form-label">Màu</label>
                                            <select name="color" class="form-select" required>
                                                <option value="" disabled selected>-- Chọn màu --</option>
                                                <c:forEach var="c" items="${product.availableColors}">
                                                    <option value="${c}">${c}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </c:if>
                                    <c:choose>
                                        <c:when test="${product.stockQuantity > 0}">
                                            <button type="submit" class="btn btn-primary btn-lg">
                                                <i class="fas fa-cart-plus"></i> Thêm vào giỏ hàng
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <button type="button" class="btn btn-secondary btn-lg" disabled>
                                                <i class="fas fa-times"></i> Hết hàng
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                </form>
                            </div>
                        </div>
                    </article>
                </c:forEach>
            </div>

            <!-- PHÂN TRANG RÚT GỌN: « ‹ [page][page+1] › » -->
            <!-- Sửa phần phân trang để hỗ trợ categories -->
            <c:if test="${totalPages > 1}">
                <c:set var="prev" value="${page > 1 ? page - 1 : 1}" />
                <c:set var="next" value="${page < totalPages ? page + 1 : totalPages}" />
                <nav class="pagination pagination--compact">
                    <!-- first -->
                    <a class="nav ${page==1?'disabled':''}"
                       href="<c:url value='/products'>
                           <c:param name='page' value='1'/>
                           <c:param name='q' value='${q}'/>
                           <c:param name='sort' value='${sort}'/>
                           <c:param name='price' value='${price}'/>
                           <c:param name='category' value='${category}'/>
                           <c:param name='categories' value='${categoriesParam}'/>
                       </c:url>">«</a>

                    <!-- prev -->
                    <a class="nav ${page==1?'disabled':''}"
                       href="<c:url value='/products'>
                           <c:param name='page' value='${prev}'/>
                           <c:param name='q' value='${q}'/>
                           <c:param name='sort' value='${sort}'/>
                           <c:param name='price' value='${price}'/>
                           <c:param name='category' value='${category}'/>
                           <c:param name='categories' value='${categoriesParam}'/>
                       </c:url>">‹</a>

                    <!-- Current and next page numbers -->
                    <c:choose>
                        <c:when test="${page == totalPages && totalPages > 1}">
                            <a href="<c:url value='/products'>
                                   <c:param name='page' value='${page-1}'/>
                                   <c:param name='q' value='${q}'/><c:param name='sort' value='${sort}'/>
                                   <c:param name='price' value='${price}'/><c:param name='category' value='${category}'/>
                                   <c:param name='categories' value='${categoriesParam}'/>
                               </c:url>">${page-1}</a>
                            <a class="is-active">${page}</a>
                        </c:when>
                        <c:otherwise>
                            <a class="is-active">${page}</a>
                            <c:if test="${page < totalPages}">
                                <a href="<c:url value='/products'>
                                       <c:param name='page' value='${page+1}'/>
                                       <c:param name='q' value='${q}'/><c:param name='sort' value='${sort}'/>
                                       <c:param name='price' value='${price}'/><c:param name='category' value='${category}'/>
                                       <c:param name='categories' value='${categoriesParam}'/>
                                   </c:url>">${page+1}</a>
                            </c:if>
                        </c:otherwise>
                    </c:choose>

                    <!-- next -->
                    <a class="nav ${page==totalPages?'disabled':''}"
                       href="<c:url value='/products'>
                           <c:param name='page' value='${next}'/>
                           <c:param name='q' value='${q}'/><c:param name='sort' value='${sort}'/>
                           <c:param name='price' value='${price}'/><c:param name='category' value='${category}'/>
                           <c:param name='categories' value='${categoriesParam}'/>
                       </c:url>">›</a>

                    <!-- last -->
                    <a class="nav ${page==totalPages?'disabled':''}"
                       href="<c:url value='/products'>
                           <c:param name='page' value='${totalPages}'/>
                           <c:param name='q' value='${q}'/><c:param name='sort' value='${sort}'/>
                           <c:param name='price' value='${price}'/><c:param name='category' value='${category}'/>
                           <c:param name='categories' value='${categoriesParam}'/>
                       </c:url>">»</a>
                </nav>
            </c:if>

            <c:if test="${empty products}">
                <p class="empty-note">Không tìm thấy sản phẩm phù hợp.</p>
            </c:if>

        </div>

        <%@ include file="footer.jsp" %>
    </body>
    <script>
        // Thay thế đoạn JavaScript cuối detail.jsp
        function addToCart() {
            var qtyInput = document.getElementById('qtyInput');
            if (!qtyInput) {
                notify('Lỗi: Không tìm thấy input số lượng');
                return;
            }

            var qty = parseInt(qtyInput.value || '1', 10);
            if (qty <= 0) {
                notify('Số lượng phải lớn hơn 0');
                return;
            }

            var sz = selectedSize();
            var col = selectedColor();

            // Validate size nếu có options
            var sizeInputs = document.querySelectorAll('input[name="size"]');
            if (sizeInputs.length > 0 && !sz) {
                notify('Vui lòng chọn kích thước');
                return;
            }

            // Tạo FormData để gửi AJAX
            var formData = new FormData();
            formData.append('productId', '${product.id}');
            formData.append('quantity', qty);
            if (sz)
                formData.append('size', sz);
            if (col)
                formData.append('color', col);

            // Disable button và show loading
            var addBtn = document.querySelector('.actions .btn-primary');
            var originalText = addBtn.innerHTML;
            addBtn.disabled = true;
            addBtn.innerHTML = '<i class="fa fa-spinner fa-spin me"></i> Đang thêm...';

            // Gửi AJAX request
            fetch('add-to-cart', {
                method: 'POST',
                body: formData
            })
                    .then(function (response) {
                        return response.json();
                    })
                    .then(function (data) {
                        if (data.success) {
                            notify('Đã thêm vào giỏ hàng thành công!');
                            // Cập nhật số lượng giỏ hàng trong header
                            updateCartCount(data.cartCount);
                        } else {
                            notify(data.message);
                        }
                    })
                    .catch(function (error) {
                        console.error('Error:', error);
                        notify('Có lỗi xảy ra. Vui lòng thử lại.');
                    })
                    .finally(function () {
                        // Restore button
                        addBtn.disabled = false;
                        addBtn.innerHTML = originalText;
                    });
        }

        function buyNow() {
            var qtyInput = document.getElementById('qtyInput');
            var qty = parseInt(qtyInput.value || '1', 10);
            var sz = selectedSize();
            var col = selectedColor();

            var formData = new FormData();
            formData.append('productId', '${product.id}');
            formData.append('quantity', qty);
            if (sz)
                formData.append('size', sz);
            if (col)
                formData.append('color', col);

            fetch('add-to-cart', {
                method: 'POST',
                body: formData
            })
                    .then(function (response) {
                        return response.json();
                    })
                    .then(function (data) {
                        if (data.success) {
                            window.location.href = 'cart';
                        } else {
                            notify(data.message);
                        }
                    })
                    .catch(function (error) {
                        console.error('Error:', error);
                        notify('Có lỗi xảy ra. Vui lòng thử lại.');
                    });
        }

        function updateCartCount(count) {
            var cartCountElements = document.querySelectorAll('#cartCount, .cart-count');
            for (var i = 0; i < cartCountElements.length; i++) {
                cartCountElements[i].textContent = count || 0;
            }
        }
    </script>
</html>
