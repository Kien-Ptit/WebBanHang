<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<fmt:setLocale value="vi_VN"/>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Thanh toán</title>
    
    <link rel="stylesheet" href="<c:url value='/css/checkout.css'/>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

    <!-- HEADER -->
    <jsp:include page="/header.jsp" />

    <div class="checkout-container">
        <div class="checkout-wrapper">
            
            <!-- LEFT SIDE - Form -->
            <div class="checkout-main">
                <h1 class="checkout-title">
                    <i class="fas fa-shopping-bag"></i> Thanh toán
                </h1>

                <form action="${ctx}/checkout" method="post" id="checkoutForm">
                    
                    <!-- THÔNG TIN GIAO HÀNG -->
                    <div class="checkout-section">
                        <h2 class="section-title">
                            <i class="fas fa-shipping-fast"></i>
                            Thông tin giao hàng
                        </h2>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="fullname">
                                    Họ và tên <span class="required">*</span>
                                </label>
                                <input type="text" 
                                       id="fullname" 
                                       name="fullname" 
                                       class="form-control"
                                       value="${u_fullname}" 
                                       placeholder="Nhập họ và tên"
                                       required>
                            </div>
                            
                            <div class="form-group">
                                <label for="phone">
                                    Số điện thoại <span class="required">*</span>
                                </label>
                                <input type="tel" 
                                       id="phone" 
                                       name="phone" 
                                       class="form-control"
                                       value="${u_phone}" 
                                       placeholder="Nhập số điện thoại"
                                       pattern="[0-9]{10,11}"
                                       required>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="address">
                                Địa chỉ <span class="required">*</span>
                            </label>
                            <input type="text" 
                                   id="address" 
                                   name="address" 
                                   class="form-control"
                                   value="${u_address}" 
                                   placeholder="Nhập địa chỉ giao hàng"
                                   required>
                        </div>
                        
                        <div class="form-group">
                            <label for="note">Ghi chú</label>
                            <textarea id="note" 
                                      name="note" 
                                      class="form-control" 
                                      rows="3"
                                      placeholder="Ghi chú thêm về đơn hàng (tùy chọn)"></textarea>
                        </div>
                    </div>

                    <!-- PHƯƠNG THỨC THANH TOÁN -->
                    <div class="checkout-section">
                        <h2 class="section-title">
                            <i class="fas fa-credit-card"></i>
                            Phương thức thanh toán
                        </h2>
                        
                        <div class="payment-methods">
                            
                            <!-- COD -->
                            <label class="payment-option">
                                <input type="radio" 
                                       name="paymentMethod" 
                                       value="COD" 
                                       checked 
                                       class="payment-radio">
                                <div class="payment-card">
                                    <div class="payment-icon cod">
                                        <i class="fas fa-money-bill-wave"></i>
                                    </div>
                                    <div class="payment-info">
                                        <div class="payment-name">Thanh toán khi nhận hàng</div>
                                        <div class="payment-desc">Thanh toán bằng tiền mặt khi nhận hàng (COD)</div>
                                    </div>
                                    <div class="payment-check">
                                        <i class="fas fa-check-circle"></i>
                                    </div>
                                </div>
                            </label>

                            <!-- VÍ ĐIỆN TỬ -->
                            <label class="payment-option">
                                <input type="radio" 
                                       name="paymentMethod" 
                                       value="EWALLET" 
                                       class="payment-radio">
                                <div class="payment-card">
                                    <div class="payment-icon ewallet">
                                        <i class="fas fa-wallet"></i>
                                    </div>
                                    <div class="payment-info">
                                        <div class="payment-name">Ví điện tử</div>
                                        <div class="payment-desc">MoMo, ZaloPay, VNPay</div>
                                    </div>
                                    <div class="payment-check">
                                        <i class="fas fa-check-circle"></i>
                                    </div>
                                </div>
                            </label>

                            <!-- CHUYỂN KHOẢN NGÂN HÀNG -->
                            <label class="payment-option">
                                <input type="radio" 
                                       name="paymentMethod" 
                                       value="BANK_TRANSFER" 
                                       class="payment-radio">
                                <div class="payment-card">
                                    <div class="payment-icon bank">
                                        <i class="fas fa-university"></i>
                                    </div>
                                    <div class="payment-info">
                                        <div class="payment-name">Chuyển khoản ngân hàng</div>
                                        <div class="payment-desc">Chuyển khoản qua tài khoản ngân hàng</div>
                                    </div>
                                    <div class="payment-check">
                                        <i class="fas fa-check-circle"></i>
                                    </div>
                                </div>
                            </label>

                        </div>

                        <!-- THÔNG TIN CHUYỂN KHOẢN (Ẩn mặc định) -->
                        <div id="bankInfo" class="bank-info" style="display: none;">
                            <div class="bank-details">
                                <div class="bank-header">
                                    <i class="fas fa-info-circle"></i>
                                    Thông tin chuyển khoản
                                </div>
                                <div class="bank-content">
                                    <div class="bank-item">
                                        <span class="bank-label">Ngân hàng:</span>
                                        <span class="bank-value">Vietcombank</span>
                                    </div>
                                    <div class="bank-item">
                                        <span class="bank-label">Số tài khoản:</span>
                                        <span class="bank-value">1234567890</span>
                                    </div>
                                    <div class="bank-item">
                                        <span class="bank-label">Chủ tài khoản:</span>
                                        <span class="bank-value">KIEN STORE</span>
                                    </div>
                                    <div class="bank-item">
                                        <span class="bank-label">Nội dung:</span>
                                        <span class="bank-value">THANHTOAN [Mã đơn hàng]</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- THÔNG TIN VÍ ĐIỆN TỬ (Ẩn mặc định) -->
                        <div id="ewalletInfo" class="ewallet-info" style="display: none;">
                            <div class="ewallet-options">
                                <div class="ewallet-header">
                                    <i class="fas fa-mobile-alt"></i>
                                    Chọn ví điện tử
                                </div>
                                <div class="ewallet-list">
                                    <label class="ewallet-item">
                                        <input type="radio" name="ewalletType" value="MOMO">
                                        <div class="ewallet-card">
                                            <div class="ewallet-logo momo">
                                                <i class="fas fa-mobile-alt"></i>
                                            </div>
                                            <span>MoMo</span>
                                        </div>
                                    </label>
                                    <label class="ewallet-item">
                                        <input type="radio" name="ewalletType" value="ZALOPAY">
                                        <div class="ewallet-card">
                                            <div class="ewallet-logo zalopay">
                                                <i class="fas fa-wallet"></i>
                                            </div>
                                            <span>ZaloPay</span>
                                        </div>
                                    </label>
                                    <label class="ewallet-item">
                                        <input type="radio" name="ewalletType" value="VNPAY">
                                        <div class="ewallet-card">
                                            <div class="ewallet-logo vnpay">
                                                <i class="fas fa-credit-card"></i>
                                            </div>
                                            <span>VNPay</span>
                                        </div>
                                    </label>
                                </div>
                            </div>
                        </div>

                    </div>

                    <!-- ERROR MESSAGE -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-error">
                            <i class="fas fa-exclamation-circle"></i>
                            ${error}
                        </div>
                    </c:if>

                    <!-- BUTTONS -->
                    <div class="checkout-actions">
                        <a href="${ctx}/cart.jsp" class="btn btn-back">
                            <i class="fas fa-arrow-left"></i>
                            Quay lại giỏ hàng
                        </a>
                        <button type="submit" class="btn btn-submit">
                            <i class="fas fa-check-circle"></i>
                            Đặt hàng
                        </button>
                    </div>

                </form>
            </div>

            <!-- RIGHT SIDE - Order Summary -->
            <div class="checkout-sidebar">
                <div class="order-summary">
                    <h2 class="summary-title">
                        <i class="fas fa-receipt"></i>
                        Đơn hàng
                    </h2>

                    <div class="summary-items">
                        <c:forEach var="line" items="${lines}">
                            <div class="summary-item">
                                <div class="item-info">
                                    <div class="item-name">${line.title}</div>
                                    
                                    <!-- ✅ HIỂN THỊ SIZE VÀ MÀU -->
                                    <div class="item-variants">
                                        <c:if test="${not empty line.size && line.size != '(NULL)'}">
                                            <span class="variant-badge size-badge">
                                                <i class="fas fa-ruler-combined"></i>
                                                Size: <strong>${line.size}</strong>
                                            </span>
                                        </c:if>
                                        
                                        <c:if test="${not empty line.color && line.color != '(NULL)'}">
                                            <span class="variant-badge color-badge">
                                                <span class="color-dot" style="background-color: ${line.color};"></span>
                                                <strong>${line.color}</strong>
                                            </span>
                                        </c:if>
                                    </div>
                                    
                                    <div class="item-qty">Số lượng: ${line.qty}</div>
                                </div>
                                <div class="item-price">
                                    <fmt:formatNumber value="${line.subtotal}" 
                                                    type="currency" 
                                                    currencyCode="VND" 
                                                    minFractionDigits="0"/>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <div class="summary-divider"></div>

                    <div class="summary-row">
                        <span>Tạm tính:</span>
                        <span class="summary-subtotal">
                            <fmt:formatNumber value="${sum}" 
                                            type="currency" 
                                            currencyCode="VND" 
                                            minFractionDigits="0"/>
                        </span>
                    </div>

                    <div class="summary-row">
                        <span>Phí vận chuyển:</span>
                        <span class="summary-shipping">Miễn phí</span>
                    </div>

                    <div class="summary-divider"></div>

                    <div class="summary-total">
                        <span>Tổng cộng:</span>
                        <span class="total-amount">
                            <fmt:formatNumber value="${sum}" 
                                            type="currency" 
                                            currencyCode="VND" 
                                            minFractionDigits="0"/>
                        </span>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <!-- JAVASCRIPT -->
    <script>
        // Xử lý hiển thị thông tin thanh toán
        document.querySelectorAll('input[name="paymentMethod"]').forEach(function(radio) {
            radio.addEventListener('change', function() {
                var bankInfo = document.getElementById('bankInfo');
                var ewalletInfo = document.getElementById('ewalletInfo');
                
                // Ẩn tất cả
                bankInfo.style.display = 'none';
                ewalletInfo.style.display = 'none';
                
                // Hiện theo lựa chọn
                if (this.value === 'BANK_TRANSFER') {
                    bankInfo.style.display = 'block';
                } else if (this.value === 'EWALLET') {
                    ewalletInfo.style.display = 'block';
                }
            });
        });

        // Validate form
        document.getElementById('checkoutForm').addEventListener('submit', function(e) {
            var paymentMethod = document.querySelector('input[name="paymentMethod"]:checked').value;
            
            if (paymentMethod === 'EWALLET') {
                var ewalletType = document.querySelector('input[name="ewalletType"]:checked');
                if (!ewalletType) {
                    e.preventDefault();
                    alert('Vui lòng chọn ví điện tử!');
                    return false;
                }
            }
        });

        // Format số điện thoại
        document.getElementById('phone').addEventListener('input', function(e) {
            this.value = this.value.replace(/[^0-9]/g, '');
        });
    </script>

</body>
</html>