<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<link rel="stylesheet" href="${ctx}/css/header.css?v=9"/>

<nav class="hs-header">
    <div class="wrap">
        <div class="hs-menu">

            <!-- LEFT: logo + nav -->
            <ul class="hs-left">
                <li class="brand">
                    <a class="brand__link" href="${ctx}/home" aria-label="Kien Store">
                        <span class="brand__icon" aria-hidden="true">
                            <!-- áo thun -->
                            <svg viewBox="0 0 24 24" width="20" height="20" fill="currentColor">
                            <path d="M9 3h6l4 3v14a1 1 0 0 1-1 1h-3V9H9v12H6a1 1 0 0 1-1-1V6l4-3z"/>
                            </svg>
                        </span>
                        <span class="brand__text"><b>Kien Store</b></span>
                    </a>
                </li>

                <li class="hs-nav-item"><a class="hs-nav-link" href="${ctx}/home">Trang chủ</a></li>

                <!-- Đồ Nam -->
                <li class="hs-nav-item hs-has-mega">
                    <a class="hs-nav-link" href="<c:url value='/products'><c:param name='segment' value='men'/><c:param name='category' value='1,3'/></c:url>">Đồ Nam</a>

                        <div class="hs-mega">
                            <div class="hs-mega-inner">
                                <!-- Áo -->
                                <div class="hs-mega-col">
                                    <div class="hs-mega-title">Áo</div>
                                    <a class="hs-mega-link" href="<c:url value='/products'><c:param name='segment' value='men'/><c:param name='category' value='1,3'/><c:param name='q' value='áo thun'/></c:url>">Áo Thun</a>
                                <a class="hs-mega-link" href="<c:url value='/products'><c:param name='segment' value='men'/><c:param name='category' value='1,3'/><c:param name='q' value='áo polo'/></c:url>">Áo Polo</a>
                                <a class="hs-mega-link" href="<c:url value='/products'><c:param name='segment' value='men'/><c:param name='category' value='1,3'/><c:param name='q' value='áo sơ mi|áo somi'/></c:url>">Áo Sơ mi</a>
                                <a class="hs-mega-link" href="<c:url value='/products'><c:param name='segment' value='men'/><c:param name='category' value='1,3'/><c:param name='q' value='áo khoác|hoodie'/></c:url>">Áo Khoác / Hoodie</a>
                                <a class="hs-mega-link" href="<c:url value='/products'><c:param name='segment' value='men'/><c:param name='category' value='1,3'/><c:param name='q' value='nỉ|len'/></c:url>">Áo Nỉ &amp; Len</a>
                                <a class="hs-mega-link" href="<c:url value='/products'><c:param name='segment' value='men'/><c:param name='category' value='1,3'/><c:param name='q' value='tank top|ba lỗ'/></c:url>">Tank Top / Ba Lỗ</a>
                                <a class="hs-mega-link" href="<c:url value='/products'><c:param name='segment' value='men'/><c:param name='category' value='1,3'/><c:param name='q' value='set đồ'/></c:url>">Set đồ</a>
                                </div>

                                <!-- Quần -->
                                <div class="hs-mega-col">
                                    <div class="hs-mega-title">Quần</div>
                                    <a class="hs-mega-link" href="<c:url value='/products'><c:param name='segment' value='men'/><c:param name='category' value='1,3'/><c:param name='q' value='jean'/></c:url>">Quần Jean</a>
                                <a class="hs-mega-link" href="<c:url value='/products'><c:param name='segment' value='men'/><c:param name='category' value='1,3'/><c:param name='q' value='short'/></c:url>">Quần Short</a>
                                <a class="hs-mega-link" href="<c:url value='/products'><c:param name='segment' value='men'/><c:param name='category' value='1,3'/><c:param name='q' value='kaki|chino'/></c:url>">Kaki &amp; Chino</a>
                                <a class="hs-mega-link" href="<c:url value='/products'><c:param name='segment' value='men'/><c:param name='category' value='1,3'/><c:param name='q' value='jogger|quần dài'/></c:url>">Jogger / Quần Dài</a>
                                <a class="hs-mega-link" href="<c:url value='/products'><c:param name='segment' value='men'/><c:param name='category' value='1,3'/><c:param name='q' value='quần tây'/></c:url>">Quần Tây</a>
                                <a class="hs-mega-link" href="<c:url value='/products'><c:param name='segment' value='men'/><c:param name='category' value='1,3'/><c:param name='q' value='boxer'/></c:url>">Quần Boxer</a>
                                </div>

                                <!-- Giày & Phụ kiện -->
                                <div class="hs-mega-col">
                                    <div class="hs-mega-title">Giày &amp; Phụ kiện</div>
                                    <a class="hs-mega-link" href="<c:url value='/products'><c:param name='category' value='5'/><c:param name='segment' value='men'/></c:url>">Tất cả Phụ kiện</a>
                                <a class="hs-mega-link" href="<c:url value='/products'><c:param name='category' value='5'/><c:param name='segment' value='men'/><c:param name='q' value='giày|dép'/></c:url>">Giày &amp; Dép</a>
                                <a class="hs-mega-link" href="<c:url value='/products'><c:param name='category' value='5'/><c:param name='segment' value='men'/><c:param name='q' value='balo|túi|ví'/></c:url>">Balo, Túi &amp; Ví</a>
                                <a class="hs-mega-link" href="<c:url value='/products'><c:param name='category' value='5'/><c:param name='segment' value='men'/><c:param name='q' value='nón|mũ'/></c:url>">Nón</a>
                                <a class="hs-mega-link" href="<c:url value='/products'><c:param name='category' value='5'/><c:param name='segment' value='men'/><c:param name='q' value='thắt lưng|belt|lung'/></c:url>">Thắt Lưng</a>
                                <a class="hs-mega-link" href="<c:url value='/products'><c:param name='category' value='5'/><c:param name='segment' value='men'/><c:param name='q' value='vớ|tất|socks'/></c:url>">Vớ / Tất</a>
                                <a class="hs-mega-link" href="<c:url value='/products'><c:param name='category' value='5'/><c:param name='segment' value='men'/><c:param name='q' value='mắt kính|kính mát|sunglasses'/></c:url>">Mắt Kính</a>
                                </div>
                            </div>
                        </div>
                    </li>

                    <!-- Đồ Nữ -->
                    <li class="hs-nav-item hs-has-mega">
                        <a class="hs-nav-link" href="<c:url value='/products'><c:param name='segment' value='women'/><c:param name='category' value='2,4'/></c:url>">Đồ Nữ</a>

                        <div class="hs-mega">
                            <div class="hs-mega-inner">
                                <!-- Áo -->
                                <div class="hs-mega-col">
                                    <div class="hs-mega-title">Áo</div>
                                    <a class="hs-mega-link" href="<c:url value='/products'><c:param name='segment' value='women'/><c:param name='category' value='2,4'/><c:param name='q' value='áo thun'/></c:url>">Áo Thun</a>
                                <a class="hs-mega-link" href="<c:url value='/products'><c:param name='segment' value='women'/><c:param name='category' value='2,4'/><c:param name='q' value='áo polo'/></c:url>">Áo Polo</a>
                                <a class="hs-mega-link" href="<c:url value='/products'><c:param name='segment' value='women'/><c:param name='category' value='2,4'/><c:param name='q' value='áo sơ mi|áo somi'/></c:url>">Áo Sơ mi</a>
                                <a class="hs-mega-link" href="<c:url value='/products'><c:param name='segment' value='women'/><c:param name='category' value='2,4'/><c:param name='q' value='áo khoác|hoodie'/></c:url>">Áo Khoác / Hoodie</a>
                                <a class="hs-mega-link" href="<c:url value='/products'><c:param name='segment' value='women'/><c:param name='category' value='2,4'/><c:param name='q' value='nỉ|len'/></c:url>">Áo Nỉ &amp; Len</a>
                                <a class="hs-mega-link" href="<c:url value='/products'><c:param name='segment' value='women'/><c:param name='category' value='2,4'/><c:param name='q' value='tank top|ba lỗ'/></c:url>">Tank Top / Ba Lỗ</a>
                                <a class="hs-mega-link" href="<c:url value='/products'><c:param name='segment' value='women'/><c:param name='category' value='2,4'/><c:param name='q' value='set đồ'/></c:url>">Set đồ</a>
                                </div>

                                <!-- Quần -->
                                <div class="hs-mega-col">
                                    <div class="hs-mega-title">Quần</div>
                                    <a class="hs-mega-link" href="<c:url value='/products'><c:param name='segment' value='women'/><c:param name='category' value='2,4'/><c:param name='q' value='jean'/></c:url>">Quần Jean</a>
                                <a class="hs-mega-link" href="<c:url value='/products'><c:param name='segment' value='women'/><c:param name='category' value='2,4'/><c:param name='q' value='short'/></c:url>">Quần Short</a>
                                <a class="hs-mega-link" href="<c:url value='/products'><c:param name='segment' value='women'/><c:param name='category' value='2,4'/><c:param name='q' value='kaki|chino'/></c:url>">Kaki &amp; Chino</a>
                                <a class="hs-mega-link" href="<c:url value='/products'><c:param name='segment' value='women'/><c:param name='category' value='2,4'/><c:param name='q' value='jogger|quần dài'/></c:url>">Jogger / Quần Dài</a>
                                <a class="hs-mega-link" href="<c:url value='/products'><c:param name='segment' value='women'/><c:param name='category' value='2,4'/><c:param name='q' value='quần tây'/></c:url>">Quần Tây</a>
                                <a class="hs-mega-link" href="<c:url value='/products'><c:param name='segment' value='women'/><c:param name='category' value='2,4'/><c:param name='q' value='boxer'/></c:url>">Quần Boxer</a>
                                </div>

                                <!-- Giày & Phụ kiện -->
                                <div class="hs-mega-col">
                                    <div class="hs-mega-title">Giày &amp; Phụ kiện</div>
                                    <a class="hs-mega-link" href="<c:url value='/products'><c:param name='category' value='5'/><c:param name='segment' value='women'/></c:url>">Tất cả Phụ kiện</a>
                                <a class="hs-mega-link" href="<c:url value='/products'><c:param name='category' value='5'/><c:param name='segment' value='women'/><c:param name='q' value='giày|dép|heels|sandal'/></c:url>">Giày &amp; Dép</a>
                                <a class="hs-mega-link" href="<c:url value='/products'><c:param name='category' value='5'/><c:param name='segment' value='women'/><c:param name='q' value='balo|túi|ví|handbag'/></c:url>">Balo, Túi &amp; Ví</a>
                                <a class="hs-mega-link" href="<c:url value='/products'><c:param name='category' value='5'/><c:param name='segment' value='women'/><c:param name='q' value='nón|mũ'/></c:url>">Nón</a>
                                <a class="hs-mega-link" href="<c:url value='/products'><c:param name='category' value='5'/><c:param name='segment' value='women'/><c:param name='q' value='thắt lưng|belt|lung'/></c:url>">Thắt Lưng</a>
                                <a class="hs-mega-link" href="<c:url value='/products'><c:param name='category' value='5'/><c:param name='segment' value='women'/><c:param name='q' value='vớ|tất|socks'/></c:url>">Vớ / Tất</a>
                                <a class="hs-mega-link" href="<c:url value='/products'><c:param name='category' value='5'/><c:param name='segment' value='women'/><c:param name='q' value='mắt kính|kính mát|sunglasses'/></c:url>">Mắt Kính</a>
                                </div>
                            </div>
                        </div>
                    </li>

                    <!-- Trẻ Em -->
                    <li class="hs-nav-item hs-has-mega">
                        <a class="hs-nav-link" href="<c:url value='/products'><c:param name='category' value='6'/></c:url>">Trẻ Em</a>

                        <div class="hs-mega">
                            <div class="hs-mega-inner">
                                <!-- Áo -->
                                <div class="hs-mega-col">
                                    <div class="hs-mega-title">Áo</div>
                                    <a class="hs-mega-link" href="<c:url value='/products'><c:param name='category' value='6'/><c:param name='q' value='áo thun'/></c:url>">Áo Thun</a>
                                <a class="hs-mega-link" href="<c:url value='/products'><c:param name='category' value='6'/><c:param name='q' value='áo polo'/></c:url>">Áo Polo</a>
                                <a class="hs-mega-link" href="<c:url value='/products'><c:param name='category' value='6'/><c:param name='q' value='áo khoác|hoodie'/></c:url>">Áo Khoác / Hoodie</a>
                                </div>

                                <!-- Quần -->
                                <div class="hs-mega-col">
                                    <div class="hs-mega-title">Quần</div>
                                    <a class="hs-mega-link" href="<c:url value='/products'><c:param name='category' value='6'/><c:param name='q' value='jean|short'/></c:url>">Jean / Short</a>
                                <a class="hs-mega-link" href="<c:url value='/products'><c:param name='category' value='6'/><c:param name='q' value='jogger|quần dài'/></c:url>">Jogger / Quần Dài</a>
                                </div>

                                <!-- Phụ kiện Trẻ Em -->
                                <div class="hs-mega-col">
                                    <div class="hs-mega-title">Giày &amp; Phụ kiện</div>
                                    <a class="hs-mega-link" href="<c:url value='/products'><c:param name='category' value='5'/><c:param name='q' value='kid|kids|bé|tre'/></c:url>">Tất cả Phụ kiện Trẻ Em</a>
                                <a class="hs-mega-link" href="<c:url value='/products'><c:param name='category' value='5'/><c:param name='q' value='giày|dép kid|kids|bé|tre'/></c:url>">Giày &amp; Dép</a>
                                <a class="hs-mega-link" href="<c:url value='/products'><c:param name='category' value='5'/><c:param name='q' value='balo|túi|ví kid|kids|bé|tre'/></c:url>">Balo, Túi &amp; Ví</a>
                                <a class="hs-mega-link" href="<c:url value='/products'><c:param name='category' value='5'/><c:param name='q' value='nón|mũ kid|kids|bé|tre'/></c:url>">Nón</a>
                                <a class="hs-mega-link" href="<c:url value='/products'><c:param name='category' value='5'/><c:param name='q' value='vớ|tất|socks kid|kids|bé|tre'/></c:url>">Vớ / Tất</a>
                                </div>
                            </div>
                        </div>
                    </li>
                </ul>

                <!-- CENTER: Search -->
                <form class="hs-search" role="search" method="get" action="${ctx}/products">
                <input type="text" name="q" class="hs-search__input"
                       placeholder="Tìm kiếm sản phẩm..."
                       value="${fn:escapeXml(param.q)}" autocomplete="off"/>
                <!-- giữ ngữ cảnh nếu có -->
                <c:set var="seg" value="${empty segment ? param.segment : segment}"/>
                <c:if test="${not empty seg}">
                    <input type="hidden" name="segment" value="${fn:escapeXml(seg)}"/>
                </c:if>
                <c:if test="${not empty param.category}">
                    <input type="hidden" name="category" value="${fn:escapeXml(param.category)}"/>
                </c:if>
                <button class="hs-search__btn" type="submit" aria-label="Tìm kiếm">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none">
                    <circle cx="11" cy="11" r="7" stroke="currentColor" stroke-width="2"/>
                    <line x1="20" y1="20" x2="16.65" y2="16.65" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                    </svg>
                </button>
            </form>

            <!-- RIGHT: cart + auth -->
            <ul class="hs-right">
                <li class="cart">
                    <a href="${ctx}/cart" class="hs-cart-link" aria-label="Giỏ hàng">
                        <!-- SVG icon giỏ hàng -->
                        <svg class="hs-cart-icon" width="22" height="22" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
                        <path d="M7 8V7a5 5 0 1 1 10 0v1h3v13H4V8h3zm2 0h6V7a3 3 0 0 0-6 0v1z"/>
                        </svg>
                        <%-- Tính tổng số lượng --%>
                        <c:set var="totalQty" value="0"/>
                        <c:if test="${not empty sessionScope.cart and not empty sessionScope.cart.items}">
                            <c:forEach var="it" items="${sessionScope.cart.items}">
                                <c:set var="totalQty" value="${totalQty + it.qty}"/>
                            </c:forEach>
                        </c:if>

                        <span id="cart-count" class="hs-cart-badge">
                            <c:out value="${totalQty}"/>
                        </span>
                    </a>
                </li>


                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <li class="hs-user hs-has-dropdown">
                            <a class="hs-nav-link" href="javascript:void(0)">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor" style="margin-right:6px">
                                <path d="M12 12a5 5 0 1 0-5-5 5 5 0 0 0 5 5Zm0 2c-5 0-9 2.5-9 5.5V22h18v-2.5C21 16.5 17 14 12 14Z"/>
                                </svg>
                                ${sessionScope.user.fullname}
                            </a>
                            <ul class="hs-dropdown">
                                <li><a href="${ctx}/profile">Thông tin cá nhân</a></li>
                                <li><a href="${ctx}/orders">Đơn hàng</a></li>
                                    <c:if test="${sessionScope.userRole eq 'admin' || sessionScope.userRole eq 'manager'}">
                                    <li><a href="${ctx}/Admin/dashboard">Quản trị</a></li>
                                    </c:if>
                                <li class="sep"></li>
                                <li><a href="${ctx}/logout">Đăng xuất</a></li>
                            </ul>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li><a class="hs-nav-link" href="${ctx}/login">Đăng nhập</a></li>
                        <li><a class="hs-nav-link" href="${ctx}/register">Đăng ký</a></li>
                        </c:otherwise>
                    </c:choose>
            </ul>

        </div>
    </div>
</nav>

<script>
    const CTX = '<c:out value="${pageContext.request.contextPath}"/>';
    window.updateCartBadge ||= function (n) {
        const el = document.getElementById('cart-count');
        if (el && Number.isFinite(+n))
            el.textContent = n;
    };

    function toast(msg) {
        let t = document.getElementById('cartToast');
        if (!t) {
            t = document.createElement('div');
            t.id = 'cartToast';
            t.style = "position:fixed;right:16px;bottom:16px;background:#0b1324;color:#fff;padding:10px 14px;border-radius:12px;box-shadow:0 10px 30px rgba(0,0,0,.15);z-index:9999;opacity:0;transform:translateY(8px);transition:all .25s";
            document.body.appendChild(t);
        }
        t.textContent = msg;
        requestAnimationFrame(() => {
            t.style.opacity = '1';
            t.style.transform = 'translateY(0)';
        });
        setTimeout(() => {
            t.style.opacity = '0';
            t.style.transform = 'translateY(8px)';
        }, 1200);
    }

    document.addEventListener('click', function (e) {
        const btn = e.target.closest('.js-add-to-cart');
        if (!btn)
            return;
        e.preventDefault();

        const fd = new URLSearchParams();
        fd.append('productId', btn.dataset.pid);
        fd.append('qty', btn.dataset.qty || '1');
        fd.append('size', btn.dataset.size || '');
        fd.append('color', btn.dataset.color || '');

        fetch(CTX + '/api/cart/add', {method: 'POST', body: fd})
                .then(r => {
                    if (r.status === 401) {
                        location.href = CTX + '/login';
                        return null;
                    }
                    return r.json();
                })
                .then(j => {
                    if (!j)
                        return;
                    if (j.ok) {
                        updateCartBadge(j.count);
                        toast('Đã thêm vào giỏ');
                    }
                })
                .catch(() => {
                    const href = btn.getAttribute('href');
                    if (href)
                        location.href = href;
                });
    });
    window.updateCartBadge = function (n) {
        var el = document.getElementById('cart-count');
        if (el && Number.isFinite(+n))
            el.textContent = n;
    };
    const CTX = '<c:out value="${pageContext.request.contextPath}"/>';

    // ===== CẬP NHẬT BADGE GIỎ HÀNG =====
    window.updateCartBadge = function (n) {
        const el = document.getElementById('cart-count');
        if (el && Number.isFinite(+n)) {
            el.textContent = n;
            // Ẩn badge nếu = 0
            el.style.display = n > 0 ? 'inline-block' : 'none';
        }
    };

    // ===== TOAST THÔNG BÁO =====
    function toast(msg) {
        let t = document.getElementById('cartToast');
        if (!t) {
            t = document.createElement('div');
            t.id = 'cartToast';
            t.style = "position:fixed;right:16px;bottom:16px;background:#0b1324;color:#fff;padding:10px 14px;border-radius:12px;box-shadow:0 10px 30px rgba(0,0,0,.15);z-index:9999;opacity:0;transform:translateY(8px);transition:all .25s";
            document.body.appendChild(t);
        }
        t.textContent = msg;
        requestAnimationFrame(() => {
            t.style.opacity = '1';
            t.style.transform = 'translateY(0)';
        });
        setTimeout(() => {
            t.style.opacity = '0';
            t.style.transform = 'translateY(8px)';
        }, 1200);
    }

    // ===== THÊM VÀO GIỎ =====
    document.addEventListener('click', function (e) {
        const btn = e.target.closest('.js-add-to-cart');
        if (!btn)
            return;
        e.preventDefault();

        const fd = new URLSearchParams();
        fd.append('productId', btn.dataset.pid);
        fd.append('qty', btn.dataset.qty || '1');
        fd.append('size', btn.dataset.size || '');
        fd.append('color', btn.dataset.color || '');

        fetch(CTX + '/api/cart/add', {method: 'POST', body: fd})
                .then(r => {
                    if (r.status === 401) {
                        location.href = CTX + '/login';
                        return null;
                    }
                    return r.json();
                })
                .then(j => {
                    if (!j)
                        return;
                    if (j.ok) {
                        updateCartBadge(j.count);
                        toast('✓ Đã thêm vào giỏ hàng');
                    }
                })
                .catch(() => {
                    const href = btn.getAttribute('href');
                    if (href)
                        location.href = href;
                });
    });

    // ===== LOAD SỐ LƯỢNG KHI MỚI VÀO TRANG =====
    document.addEventListener('DOMContentLoaded', function () {
        const badge = document.getElementById('cart-count');
        if (badge) {
            const count = parseInt(badge.textContent) || 0;
            if (count === 0) {
                badge.style.display = 'none';
            }
        }
    });
</script>
