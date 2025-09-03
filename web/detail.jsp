<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết sản phẩm - Fashion Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body { padding-top: 76px; }
        .product-image { 
            border-radius: 10px; 
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }
        .product-image:hover { transform: scale(1.05); }
        .thumbnail-img { 
            cursor: pointer; 
            opacity: 0.7;
            transition: opacity 0.3s ease;
        }
        .thumbnail-img:hover { opacity: 1; }
        .thumbnail-img.active { 
            opacity: 1; 
            border: 3px solid #007bff;
        }
        .color-option {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            border: 3px solid #e9ecef;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
        }
        .color-option:hover { transform: scale(1.1); }
        .color-option.selected { 
            border-color: #007bff; 
            box-shadow: 0 0 10px rgba(0,123,255,0.3);
        }
        .color-option::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 20px;
            height: 20px;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="%23007bff"><path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/></svg>') no-repeat center;
            opacity: 0;
        }
        .color-option.selected::after { opacity: 1; }
        .size-btn {
            min-width: 50px;
            margin: 3px;
        }
        .review-star { color: #ffc107; }
        .quantity-controls {
            border: 1px solid #dee2e6;
            border-radius: 5px;
            overflow: hidden;
        }
        .quantity-btn {
            border: none;
            background: #f8f9fa;
            padding: 8px 12px;
            cursor: pointer;
        }
        .quantity-btn:hover { background: #e9ecef; }
        .quantity-input {
            border: none;
            text-align: center;
            width: 60px;
            padding: 8px;
        }
        .feature-item {
            padding: 10px;
            background: #f8f9fa;
            border-radius: 8px;
            margin-bottom: 10px;
        }
        .review-item {
            border-bottom: 1px solid #eee;
            padding: 20px 0;
        }
        .review-item:last-child { border-bottom: none; }
        .rating-bar {
            background: #e9ecef;
            height: 8px;
            border-radius: 4px;
            overflow: hidden;
        }
        .rating-fill {
            background: #ffc107;
            height: 100%;
            transition: width 0.3s ease;
        }
        .related-product {
            border: none;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }
        .related-product:hover { transform: translateY(-5px); }
        .sticky-purchase {
            position: sticky;
            top: 100px;
            background: white;
            border: 1px solid #dee2e6;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
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
                        <a class="nav-link" href="index.jsp">Trang chủ</a>
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

    <div class="container mt-4">
        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="index.jsp">Trang chủ</a></li>
                <li class="breadcrumb-item"><a href="products.jsp">Sản phẩm</a></li>
                <li class="breadcrumb-item"><a href="products.jsp?category=nam">Thời trang Nam</a></li>
                <li class="breadcrumb-item active">Áo sơ mi nam cao cấp</li>
            </ol>
        </nav>

        <div class="row">
            <!-- Product Images -->
            <div class="col-lg-6 mb-4">
                <!-- Main Image -->
                <div class="main-image mb-3 text-center">
                    <img src="https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80" 
                         class="img-fluid product-image" id="mainImage" alt="Áo sơ mi nam cao cấp" style="max-height: 500px;">
                </div>
                
                <!-- Thumbnail Images -->
                <div class="row g-2">
                    <div class="col-3">
                        <img src="https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80" 
                             class="img-fluid product-image thumbnail-img active" 
                             onclick="changeMainImage(this)" alt="Hình 1">
                    </div>
                    <div class="col-3">
                        <img src="https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80" 
                             class="img-fluid product-image thumbnail-img" 
                             onclick="changeMainImage(this)" alt="Hình 2">
                    </div>
                    <div class="col-3">
                        <img src="https://images.unsplash.com/photo-1593030761757-71fae45fa0e7?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80" 
                             class="img-fluid product-image thumbnail-img" 
                             onclick="changeMainImage(this)" alt="Hình 3">
                    </div>
                    <div class="col-3">
                        <img src="https://images.unsplash.com/photo-1553062407-98eeb64c6a62?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80" 
                             class="img-fluid product-image thumbnail-img" 
                             onclick="changeMainImage(this)" alt="Hình 4">
                    </div>
                </div>
            </div>

            <!-- Product Info -->
            <div class="col-lg-6">
                <div class="sticky-purchase">
                    <!-- Product Title -->
                    <h1 class="h2 mb-3">Áo sơ mi nam cao cấp</h1>
                    <p class="text-muted mb-3">SKU: ASM001 | Thương hiệu: Fashion Store</p>
                    
                    <!-- Rating -->
                    <div class="d-flex align-items-center mb-3">
                        <div class="me-2">
                            <i class="fas fa-star review-star"></i>
                            <i class="fas fa-star review-star"></i>
                            <i class="fas fa-star review-star"></i>
                            <i class="fas fa-star review-star"></i>
                            <i class="fas fa-star-half-alt review-star"></i>
                        </div>
                        <span class="me-3"><strong>4.5</strong> (128 đánh giá)</span>
                        <span class="text-success">✓ Còn hàng</span>
                    </div>

                    <!-- Price -->
                    <div class="mb-4">
                        <span class="h3 text-primary fw-bold">899,000₫</span>
                        <span class="h5 text-decoration-line-through text-muted ms-2">1,200,000₫</span>
                        <span class="badge bg-danger ms-2 fs-6">Giảm 25%</span>
                    </div>

                    <!-- Quick Description -->
                    <div class="mb-4">
                        <p class="lead">Áo sơ mi nam cao cấp chất liệu cotton 100%, thiết kế lịch lãm phù hợp cho môi trường công sở và các dịp quan trọng.</p>
                    </div>

                    <!-- Colors -->
                    <div class="mb-4">
                        <h6 class="fw-bold">Màu sắc:</h6>
                        <div class="d-flex align-items-center">
                            <div class="color-option selected me-3" 
                                 style="background-color: #ffffff; border-color: #ddd;" 
                                 onclick="selectColor(this, 'Trắng')" 
                                 title="Trắng"></div>
                            <div class="color-option me-3" 
                                 style="background-color: #87ceeb;" 
                                 onclick="selectColor(this, 'Xanh nhạt')" 
                                 title="Xanh nhạt"></div>
                            <div class="color-option me-3" 
                                 style="background-color: #ffb6c1;" 
                                 onclick="selectColor(this, 'Hồng nhạt')" 
                                 title="Hồng nhạt"></div>
                            <div class="color-option me-3" 
                                 style="background-color: #e6e6fa;" 
                                 onclick="selectColor(this, 'Tím nhạt')" 
                                 title="Tím nhạt"></div>
                        </div>
                        <small class="text-muted mt-2 d-block">Đã chọn: <span id="selectedColor" class="fw-bold">Trắng</span></small>
                    </div>

                    <!-- Sizes -->
                    <div class="mb-4">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <h6 class="fw-bold mb-0">Kích thước:</h6>
                            <a href="#" class="text-decoration-none small" data-bs-toggle="modal" data-bs-target="#sizeGuideModal">
                                <i class="fas fa-ruler me-1"></i>Hướng dẫn chọn size
                            </a>
                        </div>
                        <div class="btn-group" role="group">
                            <input type="radio" class="btn-check" name="size" id="sizeS" value="S">
                            <label class="btn btn-outline-primary size-btn" for="sizeS">S</label>
                            
                            <input type="radio" class="btn-check" name="size" id="sizeM" value="M" checked>
                            <label class="btn btn-outline-primary size-btn" for="sizeM">M</label>
                            
                            <input type="radio" class="btn-check" name="size" id="sizeL" value="L">
                            <label class="btn btn-outline-primary size-btn" for="sizeL">L</label>
                            
                            <input type="radio" class="btn-check" name="size" id="sizeXL" value="XL">
                            <label class="btn btn-outline-primary size-btn" for="sizeXL">XL</label>
                        </div>
                    </div>

                    <!-- Quantity -->
                    <div class="mb-4">
                        <h6 class="fw-bold">Số lượng:</h6>
                        <div class="d-flex align-items-center">
                            <div class="quantity-controls d-flex">
                                <button class="quantity-btn" type="button" onclick="decreaseQuantity()">
                                    <i class="fas fa-minus"></i>
                                </button>
                                <input type="number" class="quantity-input form-control-plaintext" value="1" min="1" max="50" id="quantity">
                                <button class="quantity-btn" type="button" onclick="increaseQuantity()">
                                    <i class="fas fa-plus"></i>
                                </button>
                            </div>
                            <small class="text-muted ms-3">Còn lại: <span class="text-success fw-bold">50</span> sản phẩm</small>
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="d-grid gap-2 mb-4">
                        <button class="btn btn-primary btn-lg" onclick="addToCart()">
                            <i class="fas fa-cart-plus me-2"></i>Thêm vào giỏ hàng
                        </button>
                        <button class="btn btn-success btn-lg" onclick="buyNow()">
                            <i class="fas fa-bolt me-2"></i>Mua ngay
                        </button>
                        <button class="btn btn-outline-secondary" onclick="addToWishlist()">
                            <i class="far fa-heart me-2"></i>Thêm vào yêu thích
                        </button>
                    </div>

                    <!-- Features -->
                    <div class="row g-2">
                        <div class="col-6">
                            <div class="feature-item text-center">
                                <i class="fas fa-shipping-fast text-primary mb-2 d-block"></i>
                                <small class="fw-bold">Miễn phí vận chuyển</small>
                                <div><small class="text-muted">Đơn hàng từ 500K</small></div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="feature-item text-center">
                                <i class="fas fa-undo text-primary mb-2 d-block"></i>
                                <small class="fw-bold">Đổi trả miễn phí</small>
                                <div><small class="text-muted">Trong vòng 30 ngày</small></div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="feature-item text-center">
                                <i class="fas fa-shield-alt text-primary mb-2 d-block"></i>
                                <small class="fw-bold">Bảo hành chính hãng</small>
                                <div><small class="text-muted">Cam kết chất lượng</small></div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="feature-item text-center">
                                <i class="fas fa-headset text-primary mb-2 d-block"></i>
                                <small class="fw-bold">Hỗ trợ 24/7</small>
                                <div><small class="text-muted">Tư vấn miễn phí</small></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Product Details Tabs -->
        <div class="mt-5">
            <ul class="nav nav-tabs" id="productTabs" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active" id="description-tab" data-bs-toggle="tab" data-bs-target="#description" type="button">
                        <i class="fas fa-info-circle me-2"></i>Mô tả chi tiết
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="specifications-tab" data-bs-toggle="tab" data-bs-target="#specifications" type="button">
                        <i class="fas fa-list-ul me-2"></i>Thông số kỹ thuật
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="reviews-tab" data-bs-toggle="tab" data-bs-target="#reviews" type="button">
                        <i class="fas fa-star me-2"></i>Đánh giá (128)
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="care-tab" data-bs-toggle="tab" data-bs-target="#care" type="button">
                        <i class="fas fa-heart me-2"></i>Hướng dẫn bảo quản
                    </button>
                </li>
            </ul>
            
            <div class="tab-content bg-white border border-top-0 p-4" id="productTabsContent">
                <!-- Description Tab -->
                <div class="tab-pane fade show active" id="description" role="tabpanel">
                    <h5 class="mb-4">Mô tả chi tiết sản phẩm</h5>
                    
                    <div class="row">
                        <div class="col-md-8">
                            <p class="lead">Áo sơ mi nam cao cấp được thiết kế dành riêng cho những quý ông hiện đại, yêu thích sự lịch lãm và đẳng cấp trong từng chi tiết.</p>
                            
                            <h6 class="mt-4 mb-3">Đặc điểm nổi bật:</h6>
                            <ul class="list-unstyled">
                                <li class="mb-2"><i class="fas fa-check text-success me-2"></i><strong>Chất liệu cao cấp:</strong> Cotton 100% tự nhiên, thấm hút mồ hôi tốt, thoáng mát</li>
                                <li class="mb-2"><i class="fas fa-check text-success me-2"></i><strong>Thiết kế tinh tế:</strong> Đường may tỉ mỉ, chắc chắn, form áo slim fit tôn dáng</li>
                                <li class="mb-2"><i class="fas fa-check text-success me-2"></i><strong>Phong cách đa dạng:</strong> Phù hợp đi làm, dự tiệc, gặp gỡ đối tác</li>
                                <li class="mb-2"><i class="fas fa-check text-success me-2"></i><strong>Dễ phối đồ:</strong> Kết hợp hoàn hảo với quần âu, jeans, kaki</li>
                                <li class="mb-2"><i class="fas fa-check text-success me-2"></i><strong>Bền đẹp:</strong> Giữ form sau nhiều lần giặt, không co rút, phai màu</li>
                            </ul>

                            <h6 class="mt-4 mb-3">Phù hợp cho:</h6>
                            <div class="row">
                                <div class="col-6">
                                    <ul class="list-unstyled">
                                        <li>• Môi trường công sở</li>
                                        <li>• Cuộc họp quan trọng</li>
                                        <li>• Dự tiệc, sự kiện</li>
                                    </ul>
                                </div>
                                <div class="col-6">
                                    <ul class="list-unstyled">
                                        <li>• Hẹn hò, gặp gỡ</li>
                                        <li>• Du lịch công tác</li>
                                        <li>• Các dịp lễ tết</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="bg-light p-3 rounded">
                                <h6>Thông tin nhanh</h6>
                                <ul class="list-unstyled small">
                                    <li><strong>Mã sản phẩm:</strong> ASM001</li>
                                    <li><strong>Chất liệu:</strong> Cotton 100%</li>
                                    <li><strong>Xuất xứ:</strong> Việt Nam</li>
                                    <li><strong>Bảo hành:</strong> 6 tháng</li>
                                    <li><strong>Đổi trả:</strong> 30 ngày</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Specifications Tab -->
                <div class="tab-pane fade" id="specifications" role="tabpanel">
                    <h5 class="mb-4">Thông số kỹ thuật</h5>
                    <div class="row">
                        <div class="col-md-6">
                            <table class="table table-striped">
                                <tbody>
                                    <tr>
                                        <td><strong>Chất liệu chính:</strong></td>
                                        <td>Cotton 100%</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Chất liệu phụ:</strong></td>
                                        <td>Polyester (nút, chỉ may)</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Xuất xứ:</strong></td>
                                        <td>Việt Nam</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Thương hiệu:</strong></td>
                                        <td>Fashion Store</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Màu sắc:</strong></td>
                                        <td>Trắng, Xanh nhạt, Hồng nhạt, Tím nhạt</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="col-md-6">
                            <table class="table table-striped">
                                <tbody>
                                    <tr>
                                        <td><strong>Kích thước:</strong></td>
                                        <td>S, M, L, XL</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Kiểu dáng:</strong></td>
                                        <td>Slim fit</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Cổ áo:</strong></td>
                                        <td>Cổ vest cổ điển</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Tay áo:</strong></td>
                                        <td>Dài tay có cuff</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Trọng lượng:</strong></td>
                                        <td>~300g</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Size Chart -->
                    <h6 class="mt-4 mb-3">Bảng size chi tiết (cm):</h6>
                    <div class="table-responsive">
                        <table class="table table-bordered text-center">
                            <thead class="table-dark">
                                <tr>
                                    <th>Size</th>
                                    <th>Vai (cm)</th>
                                    <th>Ngực (cm)</th>
                                    <th>Eo (cm)</th>
                                    <th>Dài áo (cm)</th>
                                    <th>Dài tay (cm)</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td><strong>S</strong></td>
                                    <td>42</td>
                                    <td>96</td>
                                    <td>88</td>
                                    <td>71</td>
                                    <td>59</td>
                                </tr>
                                <tr>
                                    <td><strong>M</strong></td>
                                    <td>44</td>
                                    <td>100</td>
                                    <td>92</td>
                                    <td>73</td>
                                    <td>61</td>
                                </tr>
                                <tr>
                                    <td><strong>L</strong></td>
                                    <td>46</td>
                                    <td>104</td>
                                    <td>96</td>
                                    <td>75</td>
                                    <td>63</td>
                                </tr>
                                <tr>
                                    <td><strong>XL</strong></td>
                                    <td>48</td>
                                    <td>108</td>
                                    <td>100</td>
                                    <td>77</td>
                                    <td>65</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Reviews Tab -->
                <div class="tab-pane fade" id="reviews" role="tabpanel">
                    <h5 class="mb-4">Đánh giá từ khách hàng</h5>
                    
                    <!-- Review Summary -->
                    <div class="row mb-4">
                        <div class="col-md-3 text-center">
                            <div class="border rounded p-3">
                                <h2 class="display-4 text-primary mb-2">4.5</h2>
                                <div class="mb-2">
                                    <i class="fas fa-star review-star"></i>
                                    <i class="fas fa-star review-star"></i>
                                    <i class="fas fa-star review-star"></i>
                                    <i class="fas fa-star review-star"></i>
                                    <i class="fas fa-star-half-alt review-star"></i>
                                </div>
                                <small class="text-muted">128 đánh giá</small>
                            </div>
                        </div>
                        <div class="col-md-9">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="d-flex align-items-center mb-2">
                                        <span class="me-2">5 sao</span>
                                        <div class="rating-bar flex-grow-1 me-2">
                                            <div class="rating-fill" style="width: 75%"></div>
                                        </div>
                                        <span class="small text-muted">96</span>
                                    </div>
                                    <div class="d-flex align-items-center mb-2">
                                        <span class="me-2">4 sao</span>
                                        <div class="rating-bar flex-grow-1 me-2">
                                            <div class="rating-fill" style="width: 15%"></div>
                                        </div>
                                        <span class="small text-muted">19</span>
                                    </div>
                                    <div class="d-flex align-items-center mb-2">
                                        <span class="me-2">3 sao</span>
                                        <div class="rating-bar flex-grow-1 me-2">
                                            <div class="rating-fill" style="width: 6%"></div>
                                        </div>
                                        <span class="small text-muted">8</span>
                                    </div>
                                    <div class="d-flex align-items-center mb-2">
                                        <span class="me-2">2 sao</span>
                                        <div class="rating-bar flex-grow-1 me-2">
                                            <div class="rating-fill" style="width: 3%"></div>
                                        </div>
                                        <span class="small text-muted">4</span>
                                    </div>
                                    <div class="d-flex align-items-center mb-2">
                                        <span class="me-2">1 sao</span>
                                        <div class="rating-bar flex-grow-1 me-2">
                                            <div class="rating-fill" style="width: 1%"></div>
                                        </div>
                                        <span class="small text-muted">1</span>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <button class="btn btn-outline-primary mb-2 w-100">Viết đánh giá</button>
                                    <div class="small text-muted">
                                        <div>✓ 96% khách hàng hài lòng</div>
                                        <div>✓ 89% sẽ mua lại sản phẩm</div>
                                        <div>✓ 92% giới thiệu cho bạn bè</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Individual Reviews -->
                    <div class="review-item">
                        <div class="d-flex align-items-start">
                            <img src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-4.0.3&auto=format&fit=crop&w=50&q=80" 
                                 class="rounded-circle me-3" width="50" height="50" alt="User">
                            <div class="flex-grow-1">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <div>
                                        <h6 class="mb-1">Nguyễn Văn An</h6>
                                        <div class="small text-muted">Đã mua hàng • Size: M • Màu: Trắng</div>
                                    </div>
                                    <small class="text-muted">2 ngày trước</small>
                                </div>
                                <div class="mb-2">
                                    <i class="fas fa-star review-star"></i>
                                    <i class="fas fa-star review-star"></i>
                                    <i class="fas fa-star review-star"></i>
                                    <i class="fas fa-star review-star"></i>
                                    <i class="fas fa-star review-star"></i>
                                </div>
                                <p class="mb-2">Áo đẹp lắm, chất liệu cotton mềm mại, mặc rất thoải mái. Form áo vừa vặn, không bị chật hay rộng. Đóng gói cẩn thận, giao hàng nhanh. Sẽ ủng hộ shop tiếp!</p>
                                <div class="d-flex align-items-center">
                                    <button class="btn btn-sm btn-outline-secondary me-2">
                                        <i class="far fa-thumbs-up me-1"></i>Hữu ích (12)
                                    </button>
                                    <button class="btn btn-sm btn-outline-secondary">Trả lời</button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="review-item">
                        <div class="d-flex align-items-start">
                            <img src="https://images.unsplash.com/photo-1494790108755-2616c6eda8ec?ixlib=rb-4.0.3&auto=format&fit=crop&w=50&q=80" 
                                 class="rounded-circle me-3" width="50" height="50" alt="User">
                            <div class="flex-grow-1">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <div>
                                        <h6 class="mb-1">Trần Thị Bình</h6>
                                        <div class="small text-muted">Đã mua hàng • Size: L • Màu: Xanh nhạt</div>
                                    </div>
                                    <small class="text-muted">1 tuần trước</small>
                                </div>
                                <div class="mb-2">
                                    <i class="fas fa-star review-star"></i>
                                    <i class="fas fa-star review-star"></i>
                                    <i class="fas fa-star review-star"></i>
                                    <i class="fas fa-star review-star"></i>
                                    <i class="far fa-star text-muted"></i>
                                </div>
                                <p class="mb-2">Mua tặng chồng, anh ấy rất thích. Chất liệu tốt, màu sắc đẹp, không phai sau khi giặt. Giá cả hợp lý so với chất lượng.</p>
                                <div class="row g-2 mb-2">
                                    <div class="col-3">
                                        <img src="https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?ixlib=rb-4.0.3&auto=format&fit=crop&w=100&q=80" 
                                             class="img-fluid rounded" alt="Review image">
                                    </div>
                                </div>
                                <div class="d-flex align-items-center">
                                    <button class="btn btn-sm btn-outline-secondary me-2">
                                        <i class="far fa-thumbs-up me-1"></i>Hữu ích (8)
                                    </button>
                                    <button class="btn btn-sm btn-outline-secondary">Trả lời</button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="review-item">
                        <div class="d-flex align-items-start">
                            <img src="https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=50&q=80" 
                                 class="rounded-circle me-3" width="50" height="50" alt="User">
                            <div class="flex-grow-1">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <div>
                                        <h6 class="mb-1">Lê Hoàng Minh</h6>
                                        <div class="small text-muted">Đã mua hàng • Size: XL • Màu: Trắng</div>
                                    </div>
                                    <small class="text-muted">2 tuần trước</small>
                                </div>
                                <div class="mb-2">
                                    <i class="fas fa-star review-star"></i>
                                    <i class="fas fa-star review-star"></i>
                                    <i class="fas fa-star review-star"></i>
                                    <i class="fas fa-star review-star"></i>
                                    <i class="fas fa-star review-star"></i>
                                </div>
                                <p class="mb-2">Áo rất đẹp, đi làm hay đi chơi đều phù hợp. Chất cotton cao cấp, mặc mát và không nhăn. Size chuẩn theo bảng size. Recommend!</p>
                                <div class="d-flex align-items-center">
                                    <button class="btn btn-sm btn-outline-secondary me-2">
                                        <i class="far fa-thumbs-up me-1"></i>Hữu ích (15)
                                    </button>
                                    <button class="btn btn-sm btn-outline-secondary">Trả lời</button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="text-center mt-4">
                        <button class="btn btn-outline-primary">Xem thêm đánh giá</button>
                    </div>
                </div>

                <!-- Care Instructions Tab -->
                <div class="tab-pane fade" id="care" role="tabpanel">
                    <h5 class="mb-4">Hướng dẫn bảo quản</h5>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <h6 class="mb-3"><i class="fas fa-tint text-primary me-2"></i>Hướng dẫn giặt ủi</h6>
                            <ul class="list-unstyled">
                                <li class="mb-2"><i class="fas fa-check text-success me-2"></i>Giặt ở nhiệt độ không quá 40°C</li>
                                <li class="mb-2"><i class="fas fa-check text-success me-2"></i>Sử dụng nước giặt dịu nhẹ</li>
                                <li class="mb-2"><i class="fas fa-times text-danger me-2"></i>Không sử dụng chất tẩy mạnh</li>
                                <li class="mb-2"><i class="fas fa-check text-success me-2"></i>Ủi ở nhiệt độ trung bình (150°C)</li>
                                <li class="mb-2"><i class="fas fa-check text-success me-2"></i>Phơi trong bóng râm</li>
                                <li class="mb-2"><i class="fas fa-times text-danger me-2"></i>Không vắt mạnh</li>
                            </ul>
                        </div>
                        <div class="col-md-6">
                            <h6 class="mb-3"><i class="fas fa-archive text-primary me-2"></i>Hướng dẫn bảo quản</h6>
                            <ul class="list-unstyled">
                                <li class="mb-2"><i class="fas fa-check text-success me-2"></i>Treo móc áo để giữ form</li>
                                <li class="mb-2"><i class="fas fa-check text-success me-2"></i>Bảo quản nơi khô ráo, thoáng mát</li>
                                <li class="mb-2"><i class="fas fa-times text-danger me-2"></i>Tránh ánh nắng trực tiếp</li>
                                <li class="mb-2"><i class="fas fa-check text-success me-2"></i>Sử dụng túi chống ẩm</li>
                                <li class="mb-2"><i class="fas fa-check text-success me-2"></i>Kiểm tra định kỳ</li>
                                <li class="mb-2"><i class="fas fa-times text-danger me-2"></i>Không để lâu trong túi kín</li>
                            </ul>
                        </div>
                    </div>

                    <div class="alert alert-info mt-4">
                        <h6 class="alert-heading"><i class="fas fa-lightbulb me-2"></i>Mẹo hay</h6>
                        <ul class="list-unstyled mb-0">
                            <li>• Giặt áo lần đầu riêng để tránh pha màu</li>
                            <li>• Lộn ngược áo khi giặt để bảo vệ bề mặt</li>
                            <li>• Sử dụng nước xả mềm để áo mềm mại hơn</li>
                            <li>• Ủi khi áo còn hơi ẩm sẽ dễ dàng hơn</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <!-- Related Products -->
        <div class="mt-5">
            <h4 class="mb-4">Sản phẩm liên quan</h4>
            <div class="row">
                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="card related-product h-100">
                        <img src="https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?ixlib=rb-4.0.3&auto=format&fit=crop&w=300&q=80" 
                             class="card-img-top" alt="Áo blouse nữ">
                        <div class="card-body">
                            <h6 class="card-title">Áo blouse nữ</h6>
                            <p class="text-primary fw-bold">599,000₫</p>
                            <div class="d-flex justify-content-between">
                                <small class="text-muted">⭐ 4.3 (89)</small>
                                <button class="btn btn-sm btn-outline-primary">Xem</button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="card related-product h-100">
                        <img src="https://images.unsplash.com/photo-1542272604-787c3835535d?ixlib=rb-4.0.3&auto=format&fit=crop&w=300&q=80" 
                             class="card-img-top" alt="Áo khoác denim">
                        <div class="card-body">
                            <h6 class="card-title">Áo khoác denim</h6>
                            <p class="text-primary fw-bold">799,000₫</p>
                            <div class="d-flex justify-content-between">
                                <small class="text-muted">⭐ 4.6 (156)</small>
                                <button class="btn btn-sm btn-outline-primary">Xem</button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="card related-product h-100">
                        <img src="https://images.unsplash.com/photo-1489987707025-afc232f7ea0f?ixlib=rb-4.0.3&auto=format&fit=crop&w=300&q=80" 
                             class="card-img-top" alt="Quần jeans">
                        <div class="card-body">
                            <h6 class="card-title">Quần jeans slim fit</h6>
                            <p class="text-primary fw-bold">699,000₫</p>
                            <div class="d-flex justify-content-between">
                                <small class="text-muted">⭐ 4.4 (203)</small>
                                <button class="btn btn-sm btn-outline-primary">Xem</button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="card related-product h-100">
                        <img src="https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?ixlib=rb-4.0.3&auto=format&fit=crop&w=300&q=80" 
                             class="card-img-top" alt="Áo polo">
                        <div class="card-body">
                            <h6 class="card-title">Áo polo nam</h6>
                            <p class="text-primary fw-bold">549,000₫</p>
                            <div class="d-flex justify-content-between">
                                <small class="text-muted">⭐ 4.2 (98)</small>
                                <button class="btn btn-sm btn-outline-primary">Xem</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Size Guide Modal -->
    <div class="modal fade" id="sizeGuideModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Hướng dẫn chọn size</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6">
                            <h6>Cách đo size áo sơ mi:</h6>
                            <ol>
                                <li><strong>Vai:</strong> Đo từ vai này sang vai kia</li>
                                <li><strong>Ngực:</strong> Đo quanh ngực tại vị trí rộng nhất</li>
                                <li><strong>Eo:</strong> Đo quanh eo tại vị trí nhỏ nhất</li>
                                <li><strong>Dài áo:</strong> Đo từ vai đến gấu áo</li>
                                <li><strong>Dài tay:</strong> Đo từ vai đến cổ tay</li>
                            </ol>
                        </div>
                        <div class="col-md-6">
                            <img src="https://images.unsplash.com/photo-1581497195919-f75d2d6628b6?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80" 
                                 class="img-fluid rounded" alt="Size guide">
                        </div>
                    </div>
                    <div class="mt-3">
                        <small class="text-muted">
                            <strong>Lưu ý:</strong> Nếu số đo của bạn nằm giữa 2 size, hãy chọn size lớn hơn để thoải mái hơn.
                        </small>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Global variables
        let selectedColor = 'Trắng';
        let selectedSize = 'M';
        let currentQuantity = 1;

        // Change main image
        function changeMainImage(clickedImg) {
            document.getElementById('mainImage').src = clickedImg.src.replace('w=200', 'w=600');
            
            // Update thumbnail active state
            document.querySelectorAll('.thumbnail-img').forEach(img => img.classList.remove('active'));
            clickedImg.classList.add('active');
        }

        // Select color
        function selectColor(element, colorName) {
            document.querySelectorAll('.color-option').forEach(option => option.classList.remove('selected'));
            element.classList.add('selected');
            selectedColor = colorName;
            document.getElementById('selectedColor').textContent = colorName;
        }

        // Quantity controls
        function increaseQuantity() {
            const quantityInput = document.getElementById('quantity');
            const currentVal = parseInt(quantityInput.value);
            const maxVal = parseInt(quantityInput.max);
            
            if (currentVal < maxVal) {
                quantityInput.value = currentVal + 1;
                currentQuantity = currentVal + 1;
            }
        }

        function decreaseQuantity() {
            const quantityInput = document.getElementById('quantity');
            const currentVal = parseInt(quantityInput.value);
            const minVal = parseInt(quantityInput.min);
            
            if (currentVal > minVal) {
                quantityInput.value = currentVal - 1;
                currentQuantity = currentVal - 1;
            }
        }

        // Add to cart
        function addToCart() {
            // Get selected size
            const sizeRadios = document.querySelectorAll('input[name="size"]');
            let selectedSize = '';
            sizeRadios.forEach(radio => {
                if (radio.checked) selectedSize = radio.value;
            });

            const product = {
                id: 1,
                name: 'Áo sơ mi nam cao cấp',
                price: 899000,
                color: selectedColor,
                size: selectedSize,
                quantity: currentQuantity,
                image: document.getElementById('mainImage').src
            };

            // Get existing cart or create new one
            let cart = JSON.parse(localStorage.getItem('cart') || '[]');
            
            // Check if product with same attributes already exists
            const existingItemIndex = cart.findIndex(item => 
                item.id === product.id && 
                item.color === product.color && 
                item.size === product.size
            );

            if (existingItemIndex > -1) {
                cart[existingItemIndex].quantity += product.quantity;
            } else {
                cart.push(product);
            }

            localStorage.setItem('cart', JSON.stringify(cart));
            updateCartCount();
            
            // Show success message
            showNotification('Đã thêm sản phẩm vào giỏ hàng!', 'success');
        }

        // Buy now
        function buyNow() {
            addToCart();
            window.location.href = 'cart.jsp';
        }

        // Add to wishlist
        function addToWishlist() {
            showNotification('Đã thêm vào danh sách yêu thích!', 'info');
        }

        // Update cart count
        function updateCartCount() {
            let cart = JSON.parse(localStorage.getItem('cart') || '[]');
            let totalItems = cart.reduce((sum, item) => sum + item.quantity, 0);
            document.getElementById('cartCount').textContent = totalItems;
        }

        // Show notification
        function showNotification(message, type = 'success') {
            // Create notification element
            const notification = document.createElement('div');
            notification.className = `alert alert-${type} alert-dismissible fade show position-fixed`;
            notification.style.cssText = 'top: 100px; right: 20px; z-index: 9999; min-width: 300px;';
            notification.innerHTML = `
                ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            `;
            
            document.body.appendChild(notification);
            
            // Auto remove after 3 seconds
            setTimeout(() => {
                if (notification.parentNode) {
                    notification.remove();
                }
            }, 3000);
        }

        // Initialize on page load
        document.addEventListener('DOMContentLoaded', function() {
            updateCartCount();
            
            // Handle quantity input changes
            const quantityInput = document.getElementById('quantity');
            quantityInput.addEventListener('change', function() {
                const value = parseInt(this.value);
                const min = parseInt(this.min);
                const max = parseInt(this.max);
                
                if (value < min) this.value = min;
                if (value > max) this.value = max;
                
                currentQuantity = parseInt(this.value);
            });

            // Handle size selection
            document.querySelectorAll('input[name="size"]').forEach(radio => {
                radio.addEventListener('change', function() {
                    if (this.checked) selectedSize = this.value;
                });
            });
        });
    </script>
</body>
</html>