<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sản phẩm - Fashion Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body { padding-top: 76px; }
        .product-card {
            transition: transform 0.3s ease;
            border: none;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .product-card:hover { transform: translateY(-5px); }
        .filter-sidebar {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
        }
        .price-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            background: rgba(0,0,0,0.7);
            color: white;
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 0.9rem;
        }
        .product-image {
            position: relative;
            overflow: hidden;
        }
    </style>
</head>
<body>
    <!-- Navigation (same as index.jsp) -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
        <div class="container">
            <a class="navbar-brand" href="index.jsp">
                <i class="fas fa-tshirt me-2"></i>Fashion Store
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="index.jsp">Trang chủ</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="products.jsp">Sản phẩm</a>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
                            Danh mục
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="products.jsp?category=nam">Thời trang Nam</a></li>
                            <li><a class="dropdown-item" href="products.jsp?category=nu">Thời trang Nữ</a></li>
                            <li><a class="dropdown-item" href="products.jsp?category=tre-em">Trẻ em</a></li>
                        </ul>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" href="cart.jsp">
                            <i class="fas fa-shopping-cart"></i>
                            <span class="badge bg-danger" id="cartCount">0</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="login.jsp">Đăng nhập</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="row">
            <!-- Filter Sidebar -->
            <div class="col-lg-3 mb-4">
                <div class="filter-sidebar">
                    <h5 class="mb-3">Bộ lọc</h5>
                    
                    <!-- Category Filter -->
                    <div class="mb-4">
                        <h6>Danh mục</h6>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" value="nam" id="categoryMen">
                            <label class="form-check-label" for="categoryMen">Thời trang Nam</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" value="nu" id="categoryWomen">
                            <label class="form-check-label" for="categoryWomen">Thời trang Nữ</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" value="tre-em" id="categoryKids">
                            <label class="form-check-label" for="categoryKids">Trẻ em</label>
                        </div>
                    </div>

                    <!-- Price Filter -->
                    <div class="mb-4">
                        <h6>Khoảng giá</h6>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" value="0-500000" id="price1">
                            <label class="form-check-label" for="price1">Dưới 500,000₫</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" value="500000-1000000" id="price2">
                            <label class="form-check-label" for="price2">500,000₫ - 1,000,000₫</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" value="1000000-2000000" id="price3">
                            <label class="form-check-label" for="price3">1,000,000₫ - 2,000,000₫</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" value="2000000+" id="price4">
                            <label class="form-check-label" for="price4">Trên 2,000,000₫</label>
                        </div>
                    </div>

                    <!-- Size Filter -->
                    <div class="mb-4">
                        <h6>Kích thước</h6>
                        <div class="d-flex flex-wrap gap-2">
                            <input type="checkbox" class="btn-check" id="sizeS" value="S">
                            <label class="btn btn-outline-secondary btn-sm" for="sizeS">S</label>
                            
                            <input type="checkbox" class="btn-check" id="sizeM" value="M">
                            <label class="btn btn-outline-secondary btn-sm" for="sizeM">M</label>
                            
                            <input type="checkbox" class="btn-check" id="sizeL" value="L">
                            <label class="btn btn-outline-secondary btn-sm" for="sizeL">L</label>
                            
                            <input type="checkbox" class="btn-check" id="sizeXL" value="XL">
                            <label class="btn btn-outline-secondary btn-sm" for="sizeXL">XL</label>
                        </div>
                    </div>

                    <button class="btn btn-primary w-100" onclick="applyFilters()">Áp dụng bộ lọc</button>
                    <button class="btn btn-outline-secondary w-100 mt-2" onclick="clearFilters()">Xóa bộ lọc</button>
                </div>
            </div>

            <!-- Products Grid -->
            <div class="col-lg-9">
                <!-- Search and Sort -->
                <div class="row mb-4">
                    <div class="col-md-6">
                        <div class="input-group">
                            <input type="text" class="form-control" placeholder="Tìm kiếm sản phẩm..." id="searchInput">
                            <button class="btn btn-outline-secondary" type="button" onclick="searchProducts()">
                                <i class="fas fa-search"></i>
                            </button>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <select class="form-select" id="sortSelect" onchange="sortProducts()">
                            <option value="">Sắp xếp theo</option>
                            <option value="name-asc">Tên A-Z</option>
                            <option value="name-desc">Tên Z-A</option>
                            <option value="price-asc">Giá thấp đến cao</option>
                            <option value="price-desc">Giá cao đến thấp</option>
                        </select>
                    </div>
                </div>

                <!-- Products -->
                <div class="row" id="productsContainer">
                    <!-- Product 1 -->
                    <div class="col-lg-4 col-md-6 mb-4 product-item" data-category="nam" data-price="899000" data-name="Áo sơ mi nam cao cấp">
                        <div class="card product-card h-100">
                            <div class="product-image">
                                <img src="https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80" class="card-img-top" alt="Áo sơ mi nam">
                                <div class="price-badge">899,000₫</div>
                            </div>
                            <div class="card-body">
                                <h5 class="card-title">Áo sơ mi nam cao cấp</h5>
                                <p class="card-text text-muted">Chất liệu cotton 100%, thiết kế lịch lãm</p>
                                <div class="mb-2">
                                    <span class="badge bg-secondary me-1">S</span>
                                    <span class="badge bg-secondary me-1">M</span>
                                    <span class="badge bg-secondary me-1">L</span>
                                    <span class="badge bg-secondary">XL</span>
                                </div>
                                <div class="d-flex justify-content-between align-items-center">
                                    <a href="product-detail.jsp?id=1" class="btn btn-primary btn-sm">Xem chi tiết</a>
                                    <button class="btn btn-outline-primary btn-sm" onclick="addToCart(1)">
                                        <i class="fas fa-cart-plus"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Product 2 -->
                    <div class="col-lg-4 col-md-6 mb-4 product-item" data-category="nu" data-price="1299000" data-name="Váy maxi thời trang">
                        <div class="card product-card h-100">
                            <div class="product-image">
                                <img src="https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80" class="card-img-top" alt="Váy nữ">
                                <div class="price-badge">1,299,000₫</div>
                            </div>
                            <div class="card-body">
                                <h5 class="card-title">Váy maxi thời trang</h5>
                                <p class="card-text text-muted">Thiết kế thanh lịch, phù hợp dự tiệc</p>
                                <div class="mb-2">
                                    <span class="badge bg-secondary me-1">S</span>
                                    <span class="badge bg-secondary me-1">M</span>
                                    <span class="badge bg-secondary">L</span>
                                </div>
                                <div class="d-flex justify-content-between align-items-center">
                                    <a href="product-detail.jsp?id=2" class="btn btn-primary btn-sm">Xem chi tiết</a>
                                    <button class="btn btn-outline-primary btn-sm" onclick="addToCart(2)">
                                        <i class="fas fa-cart-plus"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Product 3 -->
                    <div class="col-lg-4 col-md-6 mb-4 product-item" data-category="nam" data-price="799000" data-name="Áo khoác denim">
                        <div class="card product-card h-100">
                            <div class="product-image">
                                <img src="https://images.unsplash.com/photo-1542272604-787c3835535d?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80" class="card-img-top" alt="Áo khoác">
                                <div class="price-badge">799,000₫</div>
                            </div>
                            <div class="card-body">
                                <h5 class="card-title">Áo khoác denim</h5>
                                <p class="card-text text-muted">Phong cách trẻ trung, năng động</p>
                                <div class="mb-2">
                                    <span class="badge bg-secondary me-1">M</span>
                                    <span class="badge bg-secondary me-1">L</span>
                                    <span class="badge bg-secondary">XL</span>
                                </div>
                                <div class="d-flex justify-content-between align-items-center">
                                    <a href="product-detail.jsp?id=3" class="btn btn-primary btn-sm">Xem chi tiết</a>
                                    <button class="btn btn-outline-primary btn-sm" onclick="addToCart(3)">
                                        <i class="fas fa-cart-plus"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Product 4 -->
                    <div class="col-lg-4 col-md-6 mb-4 product-item" data-category="nam" data-price="699000" data-name="Quần jeans slim fit">
                        <div class="card product-card h-100">
                            <div class="product-image">
                                <img src="https://images.unsplash.com/photo-1489987707025-afc232f7ea0f?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80" class="card-img-top" alt="Quần jeans">
                                <div class="price-badge">699,000₫</div>
                            </div>
                            <div class="card-body">
                                <h5 class="card-title">Quần jeans slim fit</h5>
                                <p class="card-text text-muted">Form dáng chuẩn, co giãn tốt</p>
                                <div class="mb-2">
                                    <span class="badge bg-secondary me-1">S</span>
                                    <span class="badge bg-secondary me-1">M</span>
                                    <span class="badge bg-secondary me-1">L</span>
                                    <span class="badge bg-secondary">XL</span>
                                </div>
                                <div class="d-flex justify-content-between align-items-center">
                                    <a href="product-detail.jsp?id=4" class="btn btn-primary btn-sm">Xem chi tiết</a>
                                    <button class="btn btn-outline-primary btn-sm" onclick="addToCart(4)">
                                        <i class="fas fa-cart-plus"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Product 5 -->
                    <div class="col-lg-4 col-md-6 mb-4 product-item" data-category="nu" data-price="599000" data-name="Áo blouse nữ">
                        <div class="card product-card h-100">
                            <div class="product-image">
                                <img src="https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80" class="card-img-top" alt="Áo blouse">
                                <div class="price-badge">599,000₫</div>
                            </div>
                            <div class="card-body">
                                <h5 class="card-title">Áo blouse nữ</h5>
                                <p class="card-text text-muted">Kiểu dáng công sở, thanh lịch</p>
                                <div class="mb-2">
                                    <span class="badge bg-secondary me-1">S</span>
                                    <span class="badge bg-secondary me-1">M</span>
                                    <span class="badge bg-secondary">L</span>
                                </div>
                                <div class="d-flex justify-content-between align-items-center">
                                    <a href="product-detail.jsp?id=5" class="btn btn-primary btn-sm">Xem chi tiết</a>
                                    <button class="btn btn-outline-primary btn-sm" onclick="addToCart(5)">
                                        <i class="fas fa-cart-plus"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Product 6 -->
                    <div class="col-lg-4 col-md-6 mb-4 product-item" data-category="tre-em" data-price="399000" data-name="Bộ đồ trẻ em">
                        <div class="card product-card h-100">
                            <div class="product-image">
                                <img src="https://images.unsplash.com/photo-1503919545889-aef636e10ad4?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80" class="card-img-top" alt="Đồ trẻ em">
                                <div class="price-badge">399,000₫</div>
                            </div>
                            <div class="card-body">
                                <h5 class="card-title">Bộ đồ trẻ em</h5>
                                <p class="card-text text-muted">Chất liệu an toàn, thoải mái</p>
                                <div class="mb-2">
                                    <span class="badge bg-secondary me-1">100cm</span>
                                    <span class="badge bg-secondary me-1">110cm</span>
                                    <span class="badge bg-secondary">120cm</span>
                                </div>
                                <div class="d-flex justify-content-between align-items-center">
                                    <a href="product-detail.jsp?id=6" class="btn btn-primary btn-sm">Xem chi tiết</a>
                                    <button class="btn btn-outline-primary btn-sm" onclick="addToCart(6)">
                                        <i class="fas fa-cart-plus"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Pagination -->
                <nav aria-label="Page navigation">
                    <ul class="pagination justify-content-center">
                        <li class="page-item disabled">
                            <a class="page-link" href="#">Trước</a>
                        </li>
                        <li class="page-item active">
                            <a class="page-link" href="#">1</a>
                        </li>
                        <li class="page-item">
                            <a class="page-link" href="#">2</a>
                        </li>
                        <li class="page-item">
                            <a class="page-link" href="#">3</a>
                        </li>
                        <li class="page-item">
                            <a class="page-link" href="#">Sau</a>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function addToCart(productId) {
            let cart = JSON.parse(localStorage.getItem('cart') || '[]');
            let existingItem = cart.find(item => item.id === productId);
            
            if (existingItem) {
                existingItem.quantity += 1;
            } else {
                cart.push({ id: productId, quantity: 1 });
            }
            
            localStorage.setItem('cart', JSON.stringify(cart));
            updateCartCount();
            alert('Đã thêm sản phẩm vào giỏ hàng!');
        }
        
        function updateCartCount() {
            let cart = JSON.parse(localStorage.getItem('cart') || '[]');
            let totalItems = cart.reduce((sum, item) => sum + item.quantity, 0);
            document.getElementById('cartCount').textContent = totalItems;
        }
        
        function searchProducts() {
            const searchTerm = document.getElementById('searchInput').value.toLowerCase();
            const products = document.querySelectorAll('.product-item');
            
            products.forEach(product => {
                const productName = product.dataset.name.toLowerCase();
                if (productName.includes(searchTerm)) {
                    product.style.display = 'block';
                } else {
                    product.style.display = 'none';
                }
            });
        }
        
        function sortProducts() {
            const sortValue = document.getElementById('sortSelect').value;
            const container = document.getElementById('productsContainer');
            const products = Array.from(container.querySelectorAll('.product-item'));
            
            products.sort((a, b) => {
                switch(sortValue) {
                    case 'name-asc':
                        return a.dataset.name.localeCompare(b.dataset.name);
                    case 'name-desc':
                        return b.dataset.name.localeCompare(a.dataset.name);
                    case 'price-asc':
                        return parseInt(a.dataset.price) - parseInt(b.dataset.price);
                    case 'price-desc':
                        return parseInt(b.dataset.price) - parseInt(a.dataset.price);
                    default:
                        return 0;
                }
            });
            
            products.forEach(product => container.appendChild(product));
        }
        
        function applyFilters() {
            const categoryFilters = Array.from(document.querySelectorAll('input[type="checkbox"]:checked'))
                .filter(cb => cb.value === 'nam' || cb.value === 'nu' || cb.value === 'tre-em')
                .map(cb => cb.value);
            
            const products = document.querySelectorAll('.product-item');
            
            products.forEach(product => {
                const productCategory = product.dataset.category;
                
                if (categoryFilters.length === 0 || categoryFilters.includes(productCategory)) {
                    product.style.display = 'block';
                } else {
                    product.style.display = 'none';
                }
            });
        }
        
        function clearFilters() {
            document.querySelectorAll('input[type="checkbox"]').forEach(cb => cb.checked = false);
            document.querySelectorAll('.product-item').forEach(product => product.style.display = 'block');
        }
        
        document.addEventListener('DOMContentLoaded', updateCartCount);
    </script>
</body>
</html>