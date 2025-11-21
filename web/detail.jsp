<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:setLocale value="vi_VN"/>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title><c:out value="${product.name}"/> - Chi tiết sản phẩm</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <!-- FontAwesome cho icon (nếu không cần có thể bỏ) -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
        <!-- CSS tách riêng -->
        <link rel="stylesheet" href="<c:url value='/css/detail.css'/>?v=3">
    </head>
    <body class="detail-page">

        <%@ include file="header.jsp" %>

        <div class="wrap detail">
            <div class="detail__main">
                <!-- LEFT: Gallery -->
                <section class="gallery">
                    <div class="gallery__main">
                        <img id="mainImage"
                             src="<c:out value='${product.image_url}'/>"
                             alt="<c:out value='${product.name}'/>">
                    </div>

                    <div class="gallery__thumbs">
                        <!-- Nếu chỉ có 1 ảnh, lặp lại để có đủ thumbnail -->
                        <c:forEach var="i" begin="1" end="4">
                            <img class="thumb is-active"
                                 src="<c:out value='${product.image_url}'/>"
                                 alt="thumb"
                                 onclick="changeMainImage(this)">
                        </c:forEach>
                    </div>
                </section>

                <!-- RIGHT: Purchase box -->
                <section class="buybox">
                    <h1 class="buybox__title"><c:out value="${product.name}"/></h1>

                    <div class="buybox__meta">
                        <span>SKU: #<c:out value="${product.id}"/></span>
                        <span class="sep">•</span>
                        <span>Thương hiệu: <c:out value="${product.brand}"/></span>
                        <span class="sep">•</span>
                        <span class="stock ${product.stock_quantity > 0 ? 'in' : 'out'}">
                            <c:choose>
                                <c:when test="${product.stock_quantity > 0}">Còn hàng</c:when>
                                <c:otherwise>Hết hàng</c:otherwise>
                            </c:choose>
                        </span>
                    </div>

                    <!-- Giá -->
                    <c:set var="hasDiscount" value="${product.discount_price != null and product.discount_price > 0 and product.discount_price < product.price}"/>
                    <div class="buybox__price">
                        <span class="price-new">
                            <fmt:formatNumber value="${hasDiscount ? product.discount_price : product.price}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ
                        </span>
                        <c:if test="${hasDiscount}">
                            <span class="price-old">
                                <fmt:formatNumber value="${product.price}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ
                            </span>
                            <span class="price-off">
                                -<fmt:formatNumber value="${(1 - (product.discount_price / product.price)) * 100}" maxFractionDigits="0"/>%
                            </span>
                        </c:if>
                    </div>

                    <!-- Mô tả ngắn -->
                    <c:if test="${not empty product.description}">
                        <p class="buybox__lead">
                            <c:out value="${product.description}"/>
                        </p>
                    </c:if>

                    <!-- Màu sắc -->
                    <c:if test="${not empty colors}">
                        <div class="form-group">
                            <div class="label">Màu sắc</div>
                            <div class="colors" id="colorList">
                                <c:forEach var="col" items="${colors}" varStatus="st">
                                    <button type="button" class="color ${st.first ? 'is-selected':''}" 
                                            data-color="${fn:trim(col)}"
                                            title="${fn:trim(col)}">
                                        <span class="dot" style="background:${fn:trim(col)};"></span>
                                        <span class="name"><c:out value="${fn:trim(col)}"/></span>
                                    </button>
                                </c:forEach>
                            </div>
                            <small class="muted">Đã chọn: <strong id="selectedColorTxt"><c:out value="${fn:trim(colors[0])}"/></strong></small>
                        </div>
                    </c:if>
                    <c:choose>
                        <c:when test="${product.category_id == 5}">
                        </c:when>
                        <c:otherwise>
                            <!-- Category khác → Hiển thị nút chọn S/M/L/XL -->
                            <div class="form-group">
                                <div class="label">Kích thước <span class="text-danger">*</span></div>
                                <div id="sizeGroup" class="d-flex gap-2">
                                    <button type="button" class="btn btn-outline-secondary size-option" data-size="S">S</button>
                                    <button type="button" class="btn btn-outline-secondary size-option" data-size="M">M</button>
                                    <button type="button" class="btn btn-outline-secondary size-option" data-size="L">L</button>
                                    <button type="button" class="btn btn-outline-secondary size-option" data-size="XL">XL</button>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <!-- Số lượng -->
                    <div class="form-group">
                        <div class="label">Số lượng</div>
                        <div class="qty">
                            <button type="button" class="qty__btn" onclick="decQty()">−</button>
                            <input id="qtyInput" type="number" min="1" max="${product.stock_quantity > 0 ? product.stock_quantity : 1}" value="1">
                            <button type="button" class="qty__btn" onclick="incQty()">+</button>
                        </div>
                        <small class="muted">Còn lại: <strong><c:out value="${product.stock_quantity}"/></strong> sản phẩm</small>
                    </div>

                    <form id="addCartForm" action="<c:url value='/add'/>" method="post">
                        <input type="hidden" name="productId" value="${product.id}">
                        <input type="hidden" name="size" id="sizeInput" value="">
                        <input type="hidden" name="color" id="colorInput" value="">
                        <input type="hidden" name="go" id="goInput" value="">

                        <button type="submit" class="btn btn-primary">
                            <i class="fa fa-cart-plus me-1"></i> Thêm vào giỏ
                        </button>

                        <button type="button" class="btn btn-success" onclick="buyNow()">
                            <i class="fa fa-bolt me-1"></i> Mua ngay
                        </button>
                    </form>
                </section>
            </div>

            <!-- TABS: Mô tả / Thông số / Đánh giá -->
            <section class="tabs" id="tabs">
                <div class="tabs__nav">
                    <button class="tab is-active" data-tab="desc"><i class="fa fa-circle-info me"></i>Mô tả chi tiết</button>
                    <button class="tab" data-tab="spec"><i class="fa fa-list-ul me"></i>Thông số kỹ thuật</button>
                    <button class="tab" data-tab="rv"><i class="fa fa-star me"></i>Đánh giá (<c:out value="${reviewSummary.total != null ? reviewSummary.total : 0}"/>)</button>
                </div>

                <div class="tabs__content">
                    <!-- DESC -->
                    <div id="tab-desc" class="tabpane is-active">
                        <h3>Mô tả chi tiết</h3>
                        <c:choose>
                            <c:when test="${not empty product.description}">
                                <p class="lead"><c:out value="${product.description}"/></p>
                            </c:when>
                            <c:otherwise>
                                <p class="muted">Sản phẩm đang cập nhật mô tả.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- SPEC -->
                    <div id="tab-spec" class="tabpane">
                        <h3>Thông số kỹ thuật</h3>
                        <div class="spec-grid">
                            <div class="spec-col">
                                <ul class="spec-list">
                                    <li><span>Thương hiệu</span><strong><c:out value="${product.brand}"/></strong></li>
                                    <li><span>Chất liệu</span><strong><c:out value="${product.material}"/></strong></li>
                                    <li><span>Màu sắc</span>
                                        <strong>
                                            <c:forEach var="c0" items="${colors}" varStatus="st">
                                                <c:out value="${c0}"/><c:if test="${!st.last}">, </c:if>
                                            </c:forEach>
                                        </strong>
                                    </li>
                                    <li><span>Kích thước</span>
                                        <strong>
                                            <c:forEach var="s0" items="${sizes}" varStatus="st">
                                                <c:out value="${s0}"/><c:if test="${!st.last}">, </c:if>
                                            </c:forEach>
                                        </strong>
                                    </li>
                                    <li><span>Tồn kho</span><strong><c:out value="${product.stock_quantity}"/></strong></li>
                                </ul>
                            </div>
                            <div class="spec-col">
                                <ul class="spec-list">
                                    <c:set var="effPrice" value="${hasDiscount ? product.discount_price : product.price}"/>
                                    <li><span>Giá</span>
                                        <strong>
                                            <fmt:formatNumber value="${effPrice}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ
                                        </strong>
                                        <c:if test="${hasDiscount}">
                                            <span class="old ml-8">
                                                <fmt:formatNumber value="${product.price}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ
                                            </span>
                                        </c:if>
                                    </li>
                                    <li><span>Mã SP</span><strong>#<c:out value="${product.id}"/></strong></li>
                                    <li><span>Danh mục</span>
                                        <strong>
                                            <a class="link" href="<c:url value='/products'><c:param name='category' value='${product.category_id}'/></c:url>">
                                                <c:out value="${product.category_id}"/>
                                            </a>
                                        </strong>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>

                    <!-- REVIEWS -->
                    <div id="tab-rv" class="tabpane">
                        <c:if test="${not empty flash}">
                            <div class="notice success"><i class="fa fa-check me"></i><c:out value="${flash}"/></div>
                            </c:if>

                        <!-- ✅ FILTER BUTTONS - AJAX KHÔNG RELOAD -->
                        <div class="rv-filter">
                            <button class="filter-btn ${empty filterRating ? 'active' : ''}" 
                                    onclick="filterReviews(null)"
                                    data-rating="">
                                <i class="fa fa-list"></i> Tất cả
                            </button>
                            <button class="filter-btn ${filterRating == 5 ? 'active' : ''}" 
                                    onclick="filterReviews(5)"
                                    data-rating="5">
                                5 <i class="fa-star fa-solid"></i>
                            </button>
                            <button class="filter-btn ${filterRating == 4 ? 'active' : ''}" 
                                    onclick="filterReviews(4)"
                                    data-rating="4">
                                4 <i class="fa-star fa-solid"></i>
                            </button>
                            <button class="filter-btn ${filterRating == 3 ? 'active' : ''}" 
                                    onclick="filterReviews(3)"
                                    data-rating="3">
                                3 <i class="fa-star fa-solid"></i>
                            </button>
                            <button class="filter-btn ${filterRating == 2 ? 'active' : ''}" 
                                    onclick="filterReviews(2)"
                                    data-rating="2">
                                2 <i class="fa-star fa-solid"></i>
                            </button>
                            <button class="filter-btn ${filterRating == 1 ? 'active' : ''}" 
                                    onclick="filterReviews(1)"
                                    data-rating="1">
                                1 <i class="fa-star fa-solid"></i>
                            </button>
                        </div>

                        <!-- Loading indicator -->
                        <div id="reviewsLoading" class="reviews-loading" style="display:none">
                            <i class="fa fa-spinner fa-spin"></i> Đang tải...
                        </div>

                        <!-- Summary -->
                        <div class="rv-summary">
                            <div class="rv-score">
                                <div class="num">
                                    <fmt:formatNumber value="${reviewSummary.avg != null ? reviewSummary.avg : 0}" 
                                                      maxFractionDigits="1" minFractionDigits="1"/>
                                </div>
                                <div class="stars">
                                    <c:set var="avg" value="${reviewSummary.avg != null ? reviewSummary.avg : 0}"/>
                                    <c:forEach begin="1" end="5" var="i">
                                        <i class="fa-star ${avg >= i ? 'fa-solid' : 'fa-regular'}"></i>
                                    </c:forEach>
                                </div>
                                <div class="muted"><c:out value="${reviewSummary.total != null ? reviewSummary.total : 0}"/> đánh giá</div>
                            </div>
                            <div class="rv-bars">
                                <c:set var="total" value="${reviewSummary.total != null ? reviewSummary.total : 0}"/>
                                <div class="barrow"><span>5 sao</span><div class="bar"><div style="width:${total>0 ? (reviewSummary.star5*100/total) : 0}%"></div></div><em>${reviewSummary.star5 != null ? reviewSummary.star5 : 0}</em></div>
                                <div class="barrow"><span>4 sao</span><div class="bar"><div style="width:${total>0 ? (reviewSummary.star4*100/total) : 0}%"></div></div><em>${reviewSummary.star4 != null ? reviewSummary.star4 : 0}</em></div>
                                <div class="barrow"><span>3 sao</span><div class="bar"><div style="width:${total>0 ? (reviewSummary.star3*100/total) : 0}%"></div></div><em>${reviewSummary.star3 != null ? reviewSummary.star3 : 0}</em></div>
                                <div class="barrow"><span>2 sao</span><div class="bar"><div style="width:${total>0 ? (reviewSummary.star2*100/total) : 0}%"></div></div><em>${reviewSummary.star2 != null ? reviewSummary.star2 : 0}</em></div>
                                <div class="barrow"><span>1 sao</span><div class="bar"><div style="width:${total>0 ? (reviewSummary.star1*100/total) : 0}%"></div></div><em>${reviewSummary.star1 != null ? reviewSummary.star1 : 0}</em></div>
                            </div>
                        </div>

                        <!-- ✅ Form đánh giá VỚI UPLOAD ẢNH -->
                        <div class="rv-write">
                            <c:choose>
                                <c:when test="${empty sessionScope.userId}">
                                    <a class="btn btn-ghost" href="<c:url value='/login'/>">
                                        <i class="fa fa-right-to-bracket me"></i> Đăng nhập để viết đánh giá
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <form method="post" action="<c:url value='/detail'/>" class="rv-form" enctype="multipart/form-data">
                                        <input type="hidden" name="action" value="addReview"/>
                                        <input type="hidden" name="id" value="${product.id}"/>
                                        <input type="hidden" name="rating" id="ratingInput" value="5"/>

                                        <div class="rv-stars" id="ratingStars">
                                            <i data-v="1" class="fa-star fa-solid"></i>
                                            <i data-v="2" class="fa-star fa-solid"></i>
                                            <i data-v="3" class="fa-star fa-solid"></i>
                                            <i data-v="4" class="fa-star fa-solid"></i>
                                            <i data-v="5" class="fa-star fa-solid"></i>
                                        </div>

                                        <input class="input" name="title" placeholder="Tiêu đề (tùy chọn)" maxlength="255"/>
                                        <textarea class="textarea" name="comment" placeholder="Chia sẻ cảm nhận của bạn..." required maxlength="1000"></textarea>

                                        <!-- ✅ UPLOAD HÌNH ẢNH -->
                                        <div class="upload-wrapper">
                                            <label for="reviewImages" class="upload-label">
                                                <i class="fa fa-camera"></i> Thêm hình ảnh
                                            </label>
                                            <input type="file" id="reviewImages" name="reviewImages" multiple accept="image/*" 
                                                   onchange="previewImages(this)" style="display:none"/>
                                            <div id="imagePreview" class="image-preview"></div>
                                        </div>

                                        <button class="btn btn-primary"><i class="fa fa-paper-plane me"></i> Gửi đánh giá</button>
                                    </form>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- ✅ Danh sách đánh giá VỚI HÌNH ẢNH VÀ REPLY -->
                        <div class="rv-list">
                            <c:forEach var="r" items="${reviews}">
                                <article class="rv-item">
                                    <div class="rv-avatar">
                                        <c:choose>
                                            <c:when test="${not empty r.avatar}">
                                                <img src="<c:out value='${r.avatar}'/>" alt="avatar"/>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="fa fa-user-circle"></i>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="rv-body">
                                        <div class="rv-head">
                                            <strong><c:out value="${r.username}"/></strong>
                                            <span class="rv-meta">
                                                <fmt:formatDate value="${r.created_at}" pattern="dd/MM/yyyy HH:mm"/>
                                                <c:if test="${r.is_verified_purchase}"> • <span class="tag tag-green"><i class="fa fa-check-circle"></i> Đã mua</span></c:if>
                                                </span>
                                            </div>
                                            <div class="rv-stars-line">
                                            <c:forEach begin="1" end="5" var="i">
                                                <i class="fa-star ${r.rating >= i ? 'fa-solid':'fa-regular'}"></i>
                                            </c:forEach>
                                            <c:if test="${not empty r.title}">
                                                <span class="rv-title"><c:out value="${r.title}"/></span>
                                            </c:if>
                                        </div>
                                        <p class="rv-text"><c:out value="${r.comment}"/></p>

                                        <!-- ✅ HÌNH ẢNH REVIEW -->
                                        <c:if test="${not empty r.images}">
                                            <div class="rv-images">
                                                <c:forEach var="img" items="${r.images}">
                                                    <img src="<c:out value='${img}'/>" alt="review" onclick="openImageModal('<c:out value="${img}"/>')"/>
                                                </c:forEach>
                                            </div>
                                        </c:if>

                                        <!-- ✅ REPLIES -->
                                        <c:if test="${not empty r.replies}">
                                            <div class="rv-replies">
                                                <c:forEach var="reply" items="${r.replies}">
                                                    <div class="reply-item ${reply.is_admin_reply ? 'admin-reply' : ''}">
                                                        <div class="reply-avatar">
                                                            <c:choose>
                                                                <c:when test="${not empty reply.avatar}">
                                                                    <img src="<c:out value='${reply.avatar}'/>" alt="avatar"/>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <i class="fa fa-user-circle"></i>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                        <div class="reply-content">
                                                            <strong><c:out value="${reply.username}"/></strong>
                                                            <c:if test="${reply.is_admin_reply}">
                                                                <span class="admin-badge"><i class="fa fa-shield"></i> Admin</span>
                                                            </c:if>
                                                            <small class="reply-time">
                                                                <fmt:formatDate value="${reply.created_at}" pattern="dd/MM/yyyy HH:mm"/>
                                                            </small>
                                                            <p><c:out value="${reply.reply_text}"/></p>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </c:if>

                                        <!-- ✅ FORM REPLY - CHỈ HIỆN CHO ADMIN -->
                                        <c:if test="${not empty sessionScope.userId && sessionScope.role == 'admin'}">
                                            <button class="toggle-reply-btn" onclick="toggleReplyForm(${r.id})">
                                                <i class="fa fa-reply"></i> Trả lời
                                            </button>
                                            <div class="reply-form" id="replyForm${r.id}" style="display:none">
                                                <form method="post" action="<c:url value='/detail'/>">
                                                    <input type="hidden" name="action" value="addReply"/>
                                                    <input type="hidden" name="id" value="${product.id}"/>
                                                    <input type="hidden" name="reviewId" value="${r.id}"/>
                                                    <textarea name="replyText" placeholder="Viết phản hồi..." required maxlength="500"></textarea>
                                                    <div class="reply-actions">
                                                        <button type="button" class="btn btn-ghost btn-sm" onclick="toggleReplyForm(${r.id})">
                                                            <i class="fa fa-times"></i> Hủy
                                                        </button>
                                                        <button type="submit" class="btn btn-primary btn-sm">
                                                            <i class="fa fa-paper-plane"></i> Gửi
                                                        </button>
                                                    </div>
                                                </form>
                                            </div>
                                        </c:if>
                                    </div>
                                </article>
                            </c:forEach>

                            <c:if test="${empty reviews}">
                                <div class="empty-state">
                                    <i class="fa fa-comment-slash"></i>
                                    <p>
                                        <c:choose>
                                            <c:when test="${not empty filterRating}">Chưa có đánh giá ${filterRating} sao</c:when>
                                            <c:otherwise>Chưa có đánh giá nào</c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </section>
            <!-- ✅ MODAL XEM ẢNH - ĐẶT NGOÀI SECTION -->
            <div id="imageModal" class="image-modal">
                <span class="modal-close" onclick="closeImageModal()">&times;</span>
                <img class="modal-content" id="modalImage" alt="Review"/>
            </div>
            <!-- SẢN PHẨM LIÊN QUAN -->
            <c:if test="${not empty relatedProducts}">
                <section class="related">
                    <div class="related__head">
                        <h3>Sản phẩm liên quan</h3>
                        <a class="link" href="<c:url value='/products'><c:param name='category' value='${product.category_id}'/></c:url>">Xem tất cả</a>
                        </div>
                        <div class="products-grid">
                        <c:forEach var="p" items="${relatedProducts}">
                            <article class="product-card">
                                <a class="product-image" href="<c:url value='/detail'><c:param name='id' value='${p.id}'/></c:url>">
                                    <img src="<c:out value='${p.image_url}'/>" alt="<c:out value='${p.name}'/>">
                                    <c:if test="${p.discount_price != null && p.discount_price > 0 && p.discount_price < p.price}">
                                        <span class="badge">-<fmt:formatNumber value="${(1 - (p.discount_price / p.price)) * 100}" maxFractionDigits="0"/>%</span>
                                    </c:if>
                                </a>
                                <div class="product-body">
                                    <h4 class="product-title"><c:out value="${p.name}"/></h4>
                                    <div class="product-price">
                                        <span class="new">
                                            <fmt:formatNumber value="${(p.discount_price != null && p.discount_price > 0 && p.discount_price < p.price) ? p.discount_price : p.price}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ
                                        </span>
                                        <c:if test="${p.discount_price != null && p.discount_price > 0 && p.discount_price < p.price}">
                                            <span class="old">
                                                <fmt:formatNumber value="${p.price}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ
                                            </span>
                                        </c:if>
                                    </div>
                                    <div class="product-footer">
                                        <a class="btn btn-primary btn--mini" href="<c:url value='/detail'><c:param name='id' value='${p.id}'/></c:url>">Xem chi tiết</a>
                                        <a class="btn btn-ghost btn--mini" href="<c:url value='/detail'><c:param name='id' value='${p.id}'/></c:url>" title="Thêm vào giỏ">🛒</a>
                                        </div>
                                    </div>
                                </article>
                        </c:forEach>
                    </div>
                </section>
            </c:if>

        </div>

        <%@ include file="footer.jsp" %>

        <script>
            // ========== TABS ==========
            document.querySelectorAll('.tabs .tab').forEach(btn => {
                btn.addEventListener('click', () => {
                    document.querySelectorAll('.tabs .tab').forEach(b => b.classList.remove('is-active'));
                    btn.classList.add('is-active');
                    const id = btn.dataset.tab;
                    document.querySelectorAll('.tabpane').forEach(p => p.classList.remove('is-active'));
                    document.getElementById('tab-' + id).classList.add('is-active');
                });
            });

            // ========== GALLERY ==========
            function changeMainImage(el) {
                document.getElementById('mainImage').src = el.src;
                document.querySelectorAll('.gallery__thumbs .thumb').forEach(i => i.classList.remove('is-active'));
                el.classList.add('is-active');
            }

            // ========== COLOR SELECT ==========
            const colorList = document.getElementById('colorList');
            const colorInput = document.getElementById('colorInput');

            if (colorList) {
                colorList.querySelectorAll('.color').forEach(btn => {
                    btn.addEventListener('click', () => {
                        colorList.querySelectorAll('.color').forEach(b => b.classList.remove('is-selected'));
                        btn.classList.add('is-selected');

                        const selectedColor = btn.dataset.color;
                        if (colorInput)
                            colorInput.value = selectedColor;
                        document.getElementById('selectedColorTxt').textContent = selectedColor;
                    });
                });

                // Set màu mặc định
                const firstColor = colorList.querySelector('.color.is-selected');
                if (firstColor && colorInput) {
                    colorInput.value = firstColor.dataset.color;
                }
            }

            // ========== QUANTITY ==========
            function incQty() {
                const ip = document.getElementById('qtyInput');
                const max = parseInt(ip.max || "99", 10);
                let v = parseInt(ip.value || "1", 10);
                if (v < max)
                    ip.value = v + 1;
            }

            function decQty() {
                const ip = document.getElementById('qtyInput');
                let v = parseInt(ip.value || "1", 10);
                if (v > 1)
                    ip.value = v - 1;
            }

            // ========== RATING STARS ==========
            (function () {
                const stars = document.querySelectorAll('#ratingStars i');
                const input = document.getElementById('ratingInput');
                if (!stars.length)
                    return;

                function paint(n) {
                    stars.forEach((s, idx) => s.className = 'fa-star ' + (idx < n ? 'fa-solid' : 'fa-regular'));
                    input.value = n;
                }

                stars.forEach(s => {
                    s.addEventListener('mouseenter', () => paint(parseInt(s.dataset.v)));
                    s.addEventListener('click', () => paint(parseInt(s.dataset.v)));
                });
            })();

            // ========== SIZE & FORM VALIDATION ==========
            (function () {
                const sizeBtns = document.querySelectorAll('#sizeGroup .size-option');
                const sizeInput = document.getElementById('sizeInput');
                const colorInput = document.getElementById('colorInput');
                const form = document.getElementById('addCartForm');

                if (sizeBtns.length) {
                    sizeBtns.forEach(btn => {
                        btn.addEventListener('click', () => {
                            sizeInput.value = btn.dataset.size;
                            sizeBtns.forEach(b => b.classList.remove('active'));
                            btn.classList.add('active');
                        });
                    });
                }

                // Submit validation
                form.addEventListener('submit', e => {
                    if (!sizeInput.value) {
                        e.preventDefault();
                        alert('Vui lòng chọn kích thước trước khi thêm vào giỏ!');
                        return;
                    }

                    const colorList = document.getElementById('colorList');
                    if (colorList && !colorInput.value) {
                        e.preventDefault();
                        alert('Vui lòng chọn màu sắc trước khi thêm vào giỏ!');
                        return;
                    }
                });

                // Buy now
                window.buyNow = function () {
                    if (!sizeInput.value) {
                        alert('Vui lòng chọn kích thước trước khi mua!');
                        return;
                    }

                    const colorList = document.getElementById('colorList');
                    if (colorList && !colorInput.value) {
                        alert('Vui lòng chọn màu sắc trước khi mua!');
                        return;
                    }

                    document.getElementById('goInput').value = 'cart';
                    form.submit();
                };
            })();

            // ========== NOTIFICATION ==========
            function notify(msg) {
                const el = document.createElement('div');
                el.className = 'toast';
                el.textContent = msg;
                document.body.appendChild(el);
                setTimeout(() => el.classList.add('show'), 10);
                setTimeout(() => {
                    el.classList.remove('show');
                    setTimeout(() => el.remove(), 250);
                }, 2200);
            }

            // ========== PREVIEW MULTIPLE IMAGES ==========
            function previewImages(input) {
                const preview = document.getElementById('imagePreview');
                if (!preview) {
                    console.error('❌ Không tìm thấy element imagePreview');
                    return;
                }

                // ✅ XÓA CÁC PREVIEW CŨ
                preview.innerHTML = '';

                if (!input.files || input.files.length === 0) {
                    console.log('⚠️ Không có file nào được chọn');
                    return;
                }

                console.log('📁 Số file được chọn:', input.files.length);

                const maxFiles = 5;
                const maxSize = 5 * 1024 * 1024; // 5MB

                // ✅ LẤY TẤT CẢ FILES (tối đa 5)
                const files = Array.from(input.files).slice(0, maxFiles);

                console.log('📸 Sẽ xử lý', files.length, 'file(s)');

                let validFileCount = 0;

                files.forEach((file, index) => {
                    console.log(`\n--- File ${index + 1}/${files.length} ---`);
                    console.log('Name:', file.name);
                    console.log('Type:', file.type);
                    console.log('Size:', (file.size / 1024).toFixed(2), 'KB');

                    // ✅ Validate file type
                    if (!file.type.match('image.*')) {
                        console.warn('⚠️ Bỏ qua file không phải ảnh:', file.name);
                        alert('File "' + file.name + '" không phải là ảnh!');
                        return;
                    }

                    // ✅ Validate file size
                    if (file.size > maxSize) {
                        console.warn('⚠️ File quá lớn:', file.name, '-', (file.size / 1024 / 1024).toFixed(2), 'MB');
                        alert('File "' + file.name + '" quá lớn! Tối đa 5MB.');
                        return;
                    }

                    validFileCount++;

                    // ✅ ĐỌC VÀ PREVIEW ẢNH
                    const reader = new FileReader();

                    reader.onload = function (e) {
                        console.log('✅ File loaded:', file.name);

                        const wrapper = document.createElement('div');
                        wrapper.className = 'preview-item';
                        wrapper.setAttribute('data-filename', file.name);

                        const img = document.createElement('img');
                        img.src = e.target.result;
                        img.alt = 'Preview ' + (index + 1);
                        img.title = file.name;

                        const removeBtn = document.createElement('button');
                        removeBtn.type = 'button';
                        removeBtn.className = 'remove-preview';
                        removeBtn.innerHTML = '&times;';
                        removeBtn.title = 'Xóa ảnh';

                        // ✅ XÓA ẢNH PREVIEW (nhưng không xóa file khỏi input)
                        removeBtn.onclick = function () {
                            console.log('🗑️ Removing preview:', file.name);
                            wrapper.remove();

                            // Nếu không còn preview nào, reset input
                            if (preview.children.length === 0) {
                                input.value = '';
                                console.log('🔄 Input reset (no more previews)');
                            }
                        };

                        wrapper.appendChild(img);
                        wrapper.appendChild(removeBtn);
                        preview.appendChild(wrapper);

                        console.log('✅ Preview added to DOM for:', file.name);
                    };

                    reader.onerror = function () {
                        console.error('❌ Lỗi đọc file:', file.name);
                        alert('Không thể đọc file: ' + file.name);
                    };

                    reader.readAsDataURL(file);
                });

                console.log('\n📊 SUMMARY:');
                console.log('Total selected:', input.files.length);
                console.log('Valid images:', validFileCount);
                console.log('Will upload:', Math.min(validFileCount, maxFiles));
            }
            // ========== IMAGE MODAL (SỬA LẠI) ==========
            function openImageModal(src) {
                const modal = document.getElementById('imageModal');
                const modalImg = document.getElementById('modalImage');

                if (!modal || !modalImg) {
                    console.error('Modal elements not found');
                    return;
                }

                console.log('Opening modal with image:', src);

                modal.style.display = 'flex';
                modalImg.src = src;
                document.body.style.overflow = 'hidden';
            }

            function closeImageModal() {
                const modal = document.getElementById('imageModal');
                if (!modal)
                    return;

                modal.style.display = 'none';
                document.body.style.overflow = 'auto';
            }

// Close modal khi click vào background
            document.addEventListener('DOMContentLoaded', function () {
                const modal = document.getElementById('imageModal');
                if (modal) {
                    modal.addEventListener('click', function (e) {
                        if (e.target === modal) {
                            closeImageModal();
                        }
                    });
                }

                // Close modal với ESC key
                document.addEventListener('keydown', function (e) {
                    if (e.key === 'Escape') {
                        closeImageModal();
                    }
                });

                // Prevent modal image click from closing
                const modalImg = document.getElementById('modalImage');
                if (modalImg) {
                    modalImg.addEventListener('click', function (e) {
                        e.stopPropagation();
                    });
                }
            });
            // ========== TOGGLE REPLY FORM ==========
            function toggleReplyForm(reviewId) {
                const form = document.getElementById('replyForm' + reviewId);
                if (!form)
                    return;

                const isVisible = form.style.display !== 'none';
                document.querySelectorAll('.reply-form').forEach(f => f.style.display = 'none');

                if (!isVisible) {
                    form.style.display = 'block';
                    form.querySelector('textarea')?.focus();
                }
            }

// ========== AJAX FILTER REVIEWS - KHÔNG RELOAD (SỬA LẠI) ==========
            function filterReviews(rating) {
                const productId = ${product.id};
                const reviewsList = document.querySelector('.rv-list');
                const loading = document.getElementById('reviewsLoading');
                const filterBtns = document.querySelectorAll('.filter-btn');

                console.log('Filter reviews by rating:', rating);

                // Update active button
                filterBtns.forEach(btn => {
                    const btnRating = btn.getAttribute('data-rating');
                    if ((rating === null && btnRating === '') || (btnRating == rating)) {
                        btn.classList.add('active');
                    } else {
                        btn.classList.remove('active');
                    }
                });

                // Show loading
                if (loading)
                    loading.style.display = 'block';
                if (reviewsList)
                    reviewsList.style.opacity = '0.5';

                // Build URL
                let url = 'detail?id=' + productId;
                if (rating !== null) {
                    url += '&filterRating=' + rating;
                }

                console.log('Fetching URL:', url);

                // ✅ AJAX REQUEST - KHÔNG RELOAD
                fetch(url, {
                    method: 'GET',
                    headers: {
                        'X-Requested-With': 'XMLHttpRequest' // Đánh dấu đây là AJAX request
                    }
                })
                        .then(response => {
                            if (!response.ok) {
                                throw new Error('Network response was not ok');
                            }
                            return response.text(); // Lấy HTML response
                        })
                        .then(html => {
                            console.log('Response received, length:', html.length);

                            // ✅ Parse HTML và lấy phần reviews list
                            const parser = new DOMParser();
                            const doc = parser.parseFromString(html, 'text/html');
                            const newReviewsList = doc.querySelector('.rv-list');

                            if (newReviewsList && reviewsList) {
                                // Thay thế nội dung reviews list
                                reviewsList.innerHTML = newReviewsList.innerHTML;
                                console.log('Reviews list updated');
                            } else {
                                console.error('Could not find .rv-list in response');
                            }

                            // Hide loading
                            if (loading)
                                loading.style.display = 'none';
                            if (reviewsList)
                                reviewsList.style.opacity = '1';

                            // ✅ Update URL without reload
                            const newUrl = rating ? 'detail?id=' + productId + '&filterRating=' + rating : 'detail?id=' + productId;
                            window.history.pushState({}, '', newUrl + '#tab-rv');

                            // Scroll to reviews
                            document.getElementById('tab-rv').scrollIntoView({behavior: 'smooth'});
                        })
                        .catch(error => {
                            console.error('Error loading reviews:', error);
                            if (loading)
                                loading.style.display = 'none';
                            if (reviewsList)
                                reviewsList.style.opacity = '1';
                            alert('Không thể tải đánh giá. Vui lòng thử lại!');
                        });
            }
        </script>
    </body>
</html>