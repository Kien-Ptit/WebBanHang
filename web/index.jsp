<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<fmt:setLocale value="vi_VN"/>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Kien Store - Trang chủ</title>
        <link rel="stylesheet" href="<c:url value='/css/home.css'/>?v=99">
    </head>
    <body class="home-page">

        <%@ include file="header.jsp" %>

        <div class="wrap">

            <!-- ===== HERO SLIDER ===== -->
            <section class="hero" id="home">
                <div class="hero-slider" id="heroSlider">
                    <!-- Slide 1 -->
                    <div class="hero-slide active">
                        <div class="hero-content">
                            <div class="container">
                                <div class="hero-text">
                                    <h1>Bộ Sưu Tập Thu Đông 2025</h1>
                                    <p>Khám phá những xu hướng thời trang mới nhất với thiết kế hiện đại và chất lượng vượt trội</p>
                                    <div class="hero-buttons">
                                        <button class="btn btn-primary" onclick="scrollToProducts()">
                                            <i class="fas fa-shopping-bag"></i> Mua Sắm Ngay
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="hero-background" style="background-image:url('https://images.unsplash.com/photo-1441984904996-e0b6ba687e04?auto=format&fit=crop&w=1920&q=80')"></div>
                    </div>

                    <!-- Slide 2 - Nam -->
                    <div class="hero-slide">
                        <div class="hero-content">
                            <div class="container">
                                <div class="hero-text">
                                    <h1>Thời Trang Nam Hiện Đại</h1>
                                    <p>Phong cách lịch lãm và sang trọng cho các quý ông thành đạt</p>
                                    <div class="hero-buttons">
                                        <button class="btn btn-primary" onclick="filterByCategory(1)">
                                            <i class="fas fa-male"></i> Xem Thời Trang Nam
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="hero-background" style="background-image:url('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=1920&q=80')"></div>
                    </div>

                    <!-- Slide 3 - Nữ -->
                    <div class="hero-slide">
                        <div class="hero-content">
                            <div class="container">
                                <div class="hero-text">
                                    <h1>Thời Trang Nữ Quyến Rũ</h1>
                                    <p>Tôn vinh vẻ đẹp và sự tự tin của phái đẹp với những thiết kế tinh tế</p>
                                    <div class="hero-buttons">
                                        <button class="btn btn-primary" onclick="filterByCategory(2)">
                                            <i class="fas fa-female"></i> Xem Thời Trang Nữ
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="hero-background" style="background-image:url('https://images.unsplash.com/photo-1469334031218-e382a71b716b?auto=format&fit=crop&w=1920&q=80')"></div>
                    </div>
                </div>

                <!-- Controls -->
                <button class="hero-nav prev" aria-label="Previous slide">❮</button>
                <button class="hero-nav next" aria-label="Next slide">❯</button>
                <div class="hero-dots" id="heroDots" aria-label="Slide indicators"></div>
            </section>
            <!-- ===== SẢN PHẨM NỔI BẬT (giữ nguyên) ===== -->
            <c:if test="${not empty featuredProducts}">
                <section class="section" id="products-section">
                    <div class="section__head">
                        <h2>Sản phẩm nổi bật</h2>
                        <a class="link" href="<c:url value='/products?sort=popular'/>">Xem thêm</a>
                    </div>
                    <div class="products-grid">
                        <c:forEach var="p" items="${featuredProducts}">
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
                                    <span class="btn-float">Xem nhanh</span>
                                </a>
                                <div class="product-body">
                                    <h3 class="product-title"><c:out value="${p.name}"/></h3>
                                    <p class="product-desc"><c:out value="${p.description}"/></p>
                                    <div class="product-price">
                                        <c:choose>
                                            <c:when test="${p.discount_price != null && p.price != null && p.price > 0}">
                                                <span class="price-new"><fmt:formatNumber value="${p.discount_price}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ</span>
                                                <span class="price-old"><fmt:formatNumber value="${p.price}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ</span>
                                                <span class="price-off">-<fmt:formatNumber value="${(1 - (p.discount_price / p.price)) * 100}" maxFractionDigits="0"/>%</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="price-new"><fmt:formatNumber value="${p.price}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </article>
                        </c:forEach>
                    </div>
                </section>
            </c:if>

            <!-- ===== HÀNG MỚI VỀ (giữ nguyên) ===== -->
            <c:if test="${not empty latestProducts}">
                <section class="section">
                    <div class="section__head">
                        <h2>Hàng mới về</h2>
                        <a class="link" href="<c:url value='/products?sort=newest'/>">Xem thêm</a>
                    </div>
                    <div class="products-grid">
                        <c:forEach var="p" items="${latestProducts}">
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
                                    <span class="btn-float">Xem nhanh</span>
                                </a>
                                <div class="product-body">
                                    <h3 class="product-title"><c:out value="${p.name}"/></h3>
                                    <p class="product-desc"><c:out value="${p.description}"/></p>
                                    <div class="product-price">
                                        <c:choose>
                                            <c:when test="${p.discount_price != null && p.price != null && p.price > 0}">
                                                <span class="price-new"><fmt:formatNumber value="${p.discount_price}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ</span>
                                                <span class="price-old"><fmt:formatNumber value="${p.price}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ</span>
                                                <span class="price-off">-<fmt:formatNumber value="${(1 - (p.discount_price / p.price)) * 100}" maxFractionDigits="0"/>%</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="price-new"><fmt:formatNumber value="${p.price}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </article>
                        </c:forEach>
                    </div>
                </section>
            </c:if>

            <!-- ===== ĐỒ NAM (categories=1,3) ===== -->
            <c:if test="${not empty menProducts}">
                <section class="section">
                    <div class="section__head">
                        <h2>Đồ Nam</h2>
                        <a class="link"
                           href="<c:url value='/products'><c:param name='categories' value='1,3'/></c:url>">Xem thêm</a>
                        </div>
                        <div class="products-grid">
                        <c:forEach var="p" items="${menProducts}">
                            <!-- card giống trên -->
                            <article class="product-card">
                                <a class="product-image" href="<c:url value='/detail'><c:param name='id' value='${p.id}'/></c:url>">
                                    <c:choose>
                                        <c:when test="${fn:startsWith(p.image_url,'http')}"><img src="${p.image_url}" alt="${p.name}"></c:when>
                                        <c:otherwise><img src="<c:url value='/img/${p.image_url}'/>" alt="${p.name}"></c:otherwise>
                                    </c:choose>
                                    <span class="btn-float">Xem nhanh</span>
                                </a>
                                <div class="product-body">
                                    <h3 class="product-title"><c:out value="${p.name}"/></h3>
                                    <p class="product-desc"><c:out value="${p.description}"/></p>
                                    <div class="product-price">
                                        <c:choose>
                                            <c:when test="${p.discount_price != null && p.price != null && p.price > 0}">
                                                <span class="price-new"><fmt:formatNumber value="${p.discount_price}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ</span>
                                                <span class="price-old"><fmt:formatNumber value="${p.price}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ</span>
                                                <span class="price-off">-<fmt:formatNumber value="${(1 - (p.discount_price / p.price)) * 100}" maxFractionDigits="0"/>%</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="price-new"><fmt:formatNumber value="${p.price}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="product-footer">
                                        <a class="btn btn--mini" href="<c:url value='/detail'><c:param name='id' value='${p.id}'/></c:url>">Xem chi tiết</a>
                                        <form action="${pageContext.request.contextPath}/add" method="post">
                                            <input type="hidden" name="productId" value="${p.id}">
                                            <!-- [SIZE-ONLY] thêm chọn size (không đổi CSS) -->
                                            <label class="visually-hidden">Size</label>
                                            <select name="size" class="form-select" required>
                                                <option value="S">S</option>
                                                <option value="M" selected>M</option>
                                                <option value="L">L</option>
                                                <option value="XL">XL</option>
                                            </select>

                                            <!-- nếu có qty, giữ nguyên -->
                                            <input type="number" name="qty" value="1" min="1" class="form-control">

                                            <button type="submit" class="btn">Thêm vào giỏ</button>
                                        </form>
                                    </div>
                                </div>
                            </article>
                        </c:forEach>
                    </div>
                </section>
            </c:if>

            <!-- ===== ĐỒ NỮ (categories=2,4) ===== -->
            <c:if test="${not empty womenProducts}">
                <section class="section">
                    <div class="section__head">
                        <h2>Đồ Nữ</h2>
                        <a class="link"
                           href="<c:url value='/products'><c:param name='categories' value='2,4'/></c:url>">Xem thêm</a>
                        </div>
                        <div class="products-grid">
                        <c:forEach var="p" items="${womenProducts}">
                            <!-- card giống trên -->
                            <article class="product-card">
                                <a class="product-image" href="<c:url value='/detail'><c:param name='id' value='${p.id}'/></c:url>">
                                    <c:choose>
                                        <c:when test="${fn:startsWith(p.image_url,'http')}"><img src="${p.image_url}" alt="${p.name}"></c:when>
                                        <c:otherwise><img src="<c:url value='/img/${p.image_url}'/>" alt="${p.name}"></c:otherwise>
                                    </c:choose>
                                    <span class="btn-float">Xem nhanh</span>
                                </a>
                                <div class="product-body">
                                    <h3 class="product-title"><c:out value="${p.name}"/></h3>
                                    <p class="product-desc"><c:out value="${p.description}"/></p>
                                    <div class="product-price">
                                        <c:choose>
                                            <c:when test="${p.discount_price != null && p.price != null && p.price > 0}">
                                                <span class="price-new"><fmt:formatNumber value="${p.discount_price}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ</span>
                                                <span class="price-old"><fmt:formatNumber value="${p.price}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ</span>
                                                <span class="price-off">-<fmt:formatNumber value="${(1 - (p.discount_price / p.price)) * 100}" maxFractionDigits="0"/>%</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="price-new"><fmt:formatNumber value="${p.price}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="product-footer">
                                        <a class="btn btn--mini" href="<c:url value='/detail'><c:param name='id' value='${p.id}'/></c:url>">Xem chi tiết</a>
                                        <form action="${pageContext.request.contextPath}/add" method="post">
                                            <input type="hidden" name="productId" value="${p.id}">
                                            <!-- [SIZE-ONLY] thêm chọn size (không đổi CSS) -->
                                            <label class="visually-hidden">Size</label>
                                            <select name="size" class="form-select" required>
                                                <option value="S">S</option>
                                                <option value="M" selected>M</option>
                                                <option value="L">L</option>
                                                <option value="XL">XL</option>
                                            </select>

                                            <!-- nếu có qty, giữ nguyên -->
                                            <input type="number" name="qty" value="1" min="1" class="form-control">

                                            <button type="submit" class="btn">Thêm vào giỏ</button>
                                        </form>
                                    </div>
                                </div>
                            </article>
                        </c:forEach>
                    </div>
                </section>
            </c:if>

            <!-- ===== PHỤ KIỆN ===== -->
            <c:if test="${not empty accProducts}">
                <section class="section">
                    <div class="section__head">
                        <h2>Phụ kiện</h2>
                        <c:choose>
                            <c:when test="${not empty accCatsParam}">
                                <a class="link" href="<c:url value='/products'><c:param name='category' value='${accCatsParam}'/></c:url>">Xem thêm</a>
                            </c:when>
                            <c:otherwise>
                                <a class="link" href="<c:url value='/products'><c:param name='q' value='phụ kiện'/></c:url>">Xem thêm</a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="products-grid">
                        <c:forEach var="p" items="${accProducts}">
                            <!-- card giống trên -->
                            <article class="product-card">
                                <a class="product-image" href="<c:url value='/detail'><c:param name='id' value='${p.id}'/></c:url>">
                                    <c:choose>
                                        <c:when test="${fn:startsWith(p.image_url,'http')}"><img src="${p.image_url}" alt="${p.name}"></c:when>
                                        <c:otherwise><img src="<c:url value='/img/${p.image_url}'/>" alt="${p.name}"></c:otherwise>
                                    </c:choose>
                                    <span class="btn-float">Xem nhanh</span>
                                </a>
                                <div class="product-body">
                                    <h3 class="product-title"><c:out value="${p.name}"/></h3>
                                    <p class="product-desc"><c:out value="${p.description}"/></p>
                                    <div class="product-price">
                                        <c:choose>
                                            <c:when test="${p.discount_price != null && p.price != null && p.price > 0}">
                                                <span class="price-new"><fmt:formatNumber value="${p.discount_price}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ</span>
                                                <span class="price-old"><fmt:formatNumber value="${p.price}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ</span>
                                                <span class="price-off">-<fmt:formatNumber value="${(1 - (p.discount_price / p.price)) * 100}" maxFractionDigits="0"/>%</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="price-new"><fmt:formatNumber value="${p.price}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="product-footer">
                                        <a class="btn btn--mini" href="<c:url value='/detail'><c:param name='id' value='${p.id}'/></c:url>">Xem chi tiết</a>
                                        <form action="${pageContext.request.contextPath}/add" method="post">
                                            <input type="hidden" name="productId" value="${p.id}">
                                            <!-- [SIZE-ONLY] thêm chọn size (không đổi CSS) -->
                                            <label class="visually-hidden">Size</label>
                                            <select name="size" class="form-select" required>
                                                <option value="S">S</option>
                                                <option value="M" selected>M</option>
                                                <option value="L">L</option>
                                                <option value="XL">XL</option>
                                            </select>

                                            <!-- nếu có qty, giữ nguyên -->
                                            <input type="number" name="qty" value="1" min="1" class="form-control">

                                            <button type="submit" class="btn">Thêm vào giỏ</button>
                                        </form>
                                    </div>
                                </div>
                            </article>
                        </c:forEach>
                    </div>
                </section>
            </c:if>
            <!-- ===== ĐỒ TRẺ EM ===== -->
            <c:if test="${not empty kidsProducts}">
                <section class="section">
                    <div class="section__head">
                        <h2>Đồ Trẻ Em</h2>
                        <c:choose>
                            <c:when test="${not empty kidsCatsParam}">
                                <a class="link"
                                   href="<c:url value='/products'><c:param name='category' value='${kidsCatsParam}'/></c:url>">
                                       Xem thêm
                                   </a>
                            </c:when>
                            <c:otherwise>
                                <!-- fallback khi chưa tìm ra id danh mục -->
                                <a class="link"
                                   href="<c:url value='/products'><c:param name='q' value='trẻ em'/></c:url>">
                                       Xem thêm
                                   </a>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="products-grid">
                        <c:forEach var="p" items="${kidsProducts}">
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
                                    <span class="btn-float">Xem nhanh</span>
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

                                    <div class="product-footer">
                                        <a class="btn btn--mini" href="<c:url value='/detail'><c:param name='id' value='${p.id}'/></c:url>">Xem chi tiết</a>
                                        <form action="<c:url value='/cart/add'/>" method="post">
                                            <input type="hidden" name="id" value="${p.id}">
                                            <button type="submit" class="btn btn--ghost btn--mini" title="Thêm vào giỏ">🛒</button>
                                        </form>
                                    </div>
                                </div>
                            </article>
                        </c:forEach>
                    </div>
                </section>
            </c:if>
        </div>

        <%@ include file="footer.jsp" %>

        <!-- ===== HERO JS ===== -->
        <script>
            (function () {
                const slider = document.getElementById('heroSlider');
                if (!slider)
                    return;

                const slides = Array.from(slider.querySelectorAll('.hero-slide'));
                const dotsRoot = document.getElementById('heroDots');
                const prevBtn = document.querySelector('.hero-nav.prev');
                const nextBtn = document.querySelector('.hero-nav.next');

                // build dots
                slides.forEach((_, i) => {
                    const b = document.createElement('button');
                    b.setAttribute('aria-label', 'Go to slide ' + (i + 1));
                    b.addEventListener('click', () => goTo(i, true));
                    dotsRoot.appendChild(b);
                });

                let index = 0, timer = null, hovering = false, touchStartX = null;
                const AUTOPLAY = 5500;

                function goTo(i, manual = false) {
                    index = (i + slides.length) % slides.length;
                    slides.forEach((s, idx) => s.classList.toggle('active', idx === index));
                    dotsRoot.querySelectorAll('button').forEach((d, idx) => d.classList.toggle('active', idx === index));
                    if (manual)
                        restart();
                }
                function next() {
                    goTo(index + 1);
                }
                function prev() {
                    goTo(index - 1);
                }
                function start() {
                    if (timer)
                        clearInterval(timer);
                    timer = setInterval(() => !hovering && next(), AUTOPLAY);
                }
                function restart() {
                    clearInterval(timer);
                    start();
                }

                // init
                goTo(0);
                start();

                // events
                prevBtn.addEventListener('click', () => goTo(index - 1, true));
                nextBtn.addEventListener('click', () => goTo(index + 1, true));
                slider.addEventListener('mouseenter', () => {
                    hovering = true;
                });
                slider.addEventListener('mouseleave', () => {
                    hovering = false;
                });
                document.addEventListener('keydown', (e) => {
                    if (e.key === 'ArrowLeft')
                        goTo(index - 1, true);
                    if (e.key === 'ArrowRight')
                        goTo(index + 1, true);
                });
                slider.addEventListener('touchstart', e => {
                    touchStartX = e.touches[0].clientX;
                }, {passive: true});
                slider.addEventListener('touchend', e => {
                    if (touchStartX == null)
                        return;
                    const dx = e.changedTouches[0].clientX - touchStartX;
                    if (Math.abs(dx) > 40)
                        (dx < 0 ? next() : prev());
                    touchStartX = null;
                });

                // helpers
                window.scrollToProducts = function () {
                    // cuộn tới "Sản phẩm nổi bật"
                    const el = document.getElementById('products-section');
                    if (el)
                        el.scrollIntoView({behavior: 'smooth'});
                    else
                        window.location.href = '<c:url value="/products"/>';
                };
                window.scrollToAbout = function () {
                    const el = document.getElementById('about');
                    if (el)
                        el.scrollIntoView({behavior: 'smooth'});
                };
                // id=1 -> nam (1,3), id=2 -> nữ (2,4)
                window.filterByCategory = function (id) {
                    const base = '<c:url value="/products"/>';
                    if (id === 1)
                        window.location.href = base + '?categories=1,3';
                    else
                        window.location.href = base + '?categories=2,4';
                };
            })();
        </script>
    </body>
</html>
