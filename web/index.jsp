<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fashion Store - Thời trang hiện đại</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .hero-section {
            background: linear-gradient(rgba(0,0,0,0.4), rgba(0,0,0,0.4)), url('https://images.unsplash.com/photo-1441986300917-64674bd600d8?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80');
            background-size: cover;
            background-position: center;
            height: 500px;
            display: flex;
            align-items: center;
            color: white;
        }
        .product-card {
            transition: transform 0.3s ease;
            border: none;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .product-card:hover {
            transform: translateY(-5px);
        }
        .navbar-brand {
            font-weight: bold;
            font-size: 1.5rem;
        }
        .category-card {
            position: relative;
            overflow: hidden;
            border-radius: 15px;
            height: 200px;
        }
        .category-overlay {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            background: linear-gradient(transparent, rgba(0,0,0,0.7));
            color: white;
            padding: 20px;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
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
                        <a class="nav-link active" href="index.jsp">Trang chủ</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="products.jsp">Sản phẩm</a>
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

    <!-- Hero Section -->
    <section class="hero-section">
        <div class="container text-center">
            <h1 class="display-4 mb-4">Thời Trang Hiện Đại</h1>
            <p class="lead mb-4">Khám phá bộ sưu tập mới nhất với phong cách độc đáo</p>
            <a href="products.jsp" class="btn btn-primary btn-lg">Mua sắm ngay</a>
        </div>
    </section>

    <!-- Categories Section -->
    <section class="py-5">
        <div class="container">
            <h2 class="text-center mb-5">Danh Mục Sản Phẩm</h2>
            <div class="row">
                <div class="col-md-4 mb-4">
                    <div class="category-card" style="background: url('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80') center/cover;">
                        <div class="category-overlay">
                            <h4>Thời trang Nam</h4>
                            <p>Phong cách lịch lãm</p>
                            <a href="products.jsp?category=nam" class="btn btn-outline-light">Xem thêm</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 mb-4">
                    <div class="category-card" style="background: url('https://images.unsplash.com/photo-1494790108755-2616c6eda8ec?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80') center/cover;">
                        <div class="category-overlay">
                            <h4>Thời trang Nữ</h4>
                            <p>Thanh lịch & quyến rũ</p>
                            <a href="products.jsp?category=nu" class="btn btn-outline-light">Xem thêm</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 mb-4">
                    <div class="category-card" style="background: url('https://images.unsplash.com/photo-1503919545889-aef636e10ad4?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80') center/cover;">
                        <div class="category-overlay">
                            <h4>Trẻ em</h4>
                            <p>Thoải mái & đáng yêu</p>
                            <a href="products.jsp?category=tre-em" class="btn btn-outline-light">Xem thêm</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Featured Products -->
    <section class="py-5 bg-light">
        <div class="container">
            <h2 class="text-center mb-5">Sản Phẩm Nổi Bật</h2>
            <div class="row">
                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="card product-card h-100">
                        <img src="https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80" class="card-img-top" alt="Áo sơ mi nam">
                        <div class="card-body">
                            <h5 class="card-title">Áo sơ mi nam cao cấp</h5>
                            <p class="card-text text-muted">Chất liệu cotton 100%</p>
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="h5 text-primary">899,000₫</span>
                                <button class="btn btn-outline-primary btn-sm" onclick="addToCart(1)">
                                    <i class="fas fa-cart-plus"></i> Thêm
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="card product-card h-100">
                        <img src="https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80" class="card-img-top" alt="Váy nữ">
                        <div class="card-body">
                            <h5 class="card-title">Váy maxi thời trang</h5>
                            <p class="card-text text-muted">Thiết kế thanh lịch</p>
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="h5 text-primary">1,299,000₫</span>
                                <button class="btn btn-outline-primary btn-sm" onclick="addToCart(2)">
                                    <i class="fas fa-cart-plus"></i> Thêm
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="card product-card h-100">
                        <img src="https://images.unsplash.com/photo-1542272604-787c3835535d?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80" class="card-img-top" alt="Áo khoác">
                        <div class="card-body">
                            <h5 class="card-title">Áo khoác denim</h5>
                            <p class="card-text text-muted">Phong cách trẻ trung</p>
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="h5 text-primary">799,000₫</span>
                                <button class="btn btn-outline-primary btn-sm" onclick="addToCart(3)">
                                    <i class="fas fa-cart-plus"></i> Thêm
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="card product-card h-100">
                        <img src="https://images.unsplash.com/photo-1489987707025-afc232f7ea0f?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80" class="card-img-top" alt="Quần jeans">
                        <div class="card-body">
                            <h5 class="card-title">Quần jeans slim fit</h5>
                            <p class="card-text text-muted">Form dáng chuẩn</p>
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="h5 text-primary">699,000₫</span>
                                <button class="btn btn-outline-primary btn-sm" onclick="addToCart(4)">
                                    <i class="fas fa-cart-plus"></i> Thêm
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Newsletter -->
    <section class="py-5 bg-primary text-white">
        <div class="container text-center">
            <h3>Đăng ký nhận tin khuyến mãi</h3>
            <p>Nhận thông báo về sản phẩm mới và ưu đãi đặc biệt</p>
            <div class="row justify-content-center">
                <div class="col-md-6">
                    <form class="d-flex">
                        <input type="email" class="form-control me-2" placeholder="Email của bạn">
                        <button type="submit" class="btn btn-light">Đăng ký</button>
                    </form>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="bg-dark text-white py-5">
        <div class="container">
            <div class="row">
                <div class="col-md-4 mb-4">
                    <h5>Fashion Store</h5>
                    <p>Chuyên cung cấp thời trang cao cấp với phong cách hiện đại và chất lượng tốt nhất.</p>
                </div>
                <div class="col-md-4 mb-4">
                    <h5>Liên hệ</h5>
                    <p><i class="fas fa-phone me-2"></i> 0123 456 789</p>
                    <p><i class="fas fa-envelope me-2"></i> info@fashionstore.com</p>
                    <p><i class="fas fa-map-marker-alt me-2"></i> 123 Đường ABC, Hà Nội</p>
                </div>
                <div class="col-md-4 mb-4">
                    <h5>Theo dõi chúng tôi</h5>
                    <div class="d-flex">
                        <a href="#" class="text-white me-3"><i class="fab fa-facebook fa-2x"></i></a>
                        <a href="#" class="text-white me-3"><i class="fab fa-instagram fa-2x"></i></a>
                        <a href="#" class="text-white me-3"><i class="fab fa-twitter fa-2x"></i></a>
                    </div>
                </div>
            </div>
            <hr>
            <div class="text-center">
                <p>&copy; 2024 Fashion Store. Tất cả quyền được bảo lưu.</p>
            </div>
        </div>
    </footer>

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
            
            // Show success message
            alert('Đã thêm sản phẩm vào giỏ hàng!');
        }
        
        function updateCartCount() {
            let cart = JSON.parse(localStorage.getItem('cart') || '[]');
            let totalItems = cart.reduce((sum, item) => sum + item.quantity, 0);
            document.getElementById('cartCount').textContent = totalItems;
        }
        
        // Update cart count on page load
        document.addEventListener('DOMContentLoaded', updateCartCount);
    </script>
</body>
</html>