<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<fmt:setLocale value="vi_VN"/>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Giỏ hàng</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- Bootstrap -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- CSS tách riêng -->
        <link rel="stylesheet" href="<c:url value='/css/cart.css'/>">
    </head>
    <body class="container py-4">

        <h1 class="mb-4 fw-bold">🛒 Giỏ hàng của bạn</h1>

        <!-- Lấy danh sách item từ request trước, nếu không có thì lấy từ session -->
        <c:set var="items"
               value="${not empty requestScope.cartItems
                        ? requestScope.cartItems
                        : (sessionScope.cart != null ? sessionScope.cart.items : null)}" />

        <c:choose>
            <c:when test="${empty items}">
                <div class="alert alert-info">Giỏ hàng trống.</div>
                <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-primary mt-2">Tiếp tục mua sắm</a>
            </c:when>

            <c:otherwise>
                <div class="cart-card">
                    <table class="table align-middle mb-0">
                        <thead>
                            <tr>
                                <th>Sản phẩm</th>
                                <th class="text-center">Màu sắc</th>
                                <th class="text-center">Size</th>
                                <th class="text-end">Giá</th>
                                <th style="width:220px;">Số lượng</th>
                                <th class="text-end">Thành tiền</th>
                                <th></th>
                            </tr>
                        </thead>

                        <tbody>
                            <c:forEach var="it" items="${items}">
                                <c:set var="rowTotal" value="${it.lineTotal != null ? it.lineTotal : it.price * it.qty}" />

                                <tr>
                                    <!-- ✅ SẢN PHẨM (không hiển thị màu ở đây nữa) -->
                                    <td>
                                        <div class="d-flex align-items-center gap-2">
                                            <img class="cart-thumb" src="${it.imageUrl}" alt="${it.name}" width="60" height="60">
                                            <div class="fw-bold">${it.name}</div>
                                        </div>
                                    </td>

                                    <!-- ✅ CỘT MÀU SẮC -->
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${not empty it.color && it.color != '(NULL)'}">
                                                <div class="color-display">
                                                    <span class="color-dot" style="background-color: ${it.color};"></span>
                                                    <strong>${it.color}</strong>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">-</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <!-- ✅ CỘT SIZE -->
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${not empty it.size && it.size != '(NULL)'}">
                                                <span class="badge badge-size fs-6"><strong>${it.size}</strong></span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">-</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <!-- Giá -->
                                    <td class="text-end">
                                        <fmt:formatNumber value="${it.price}" type="currency" currencySymbol="₫" minFractionDigits="0"/>
                                    </td>

                                    <!-- Số lượng -->
                                    <td>
                                        <form action="${pageContext.request.contextPath}/update-cart" method="post"
                                              class="d-flex align-items-center gap-2" onsubmit="return cartSubmitOnce(this)">

                                            <!-- GỬI PRODUCT_ID + SIZE + COLOR -->
                                            <input type="hidden" name="productId" value="${it.productId}">
                                            <input type="hidden" name="size" value="${it.size}">
                                            <input type="hidden" name="color" value="${it.color}">

                                            <div class="input-group" style="max-width:220px;">
                                                <button class="btn btn-outline-secondary" type="button" onclick="cartStep(this, -1)">−</button>
                                                <input class="form-control text-center qty-input"
                                                       type="number" name="qty" min="0" value="${it.qty}"
                                                       oninput="cartAutoSubmit(this)"
                                                       onblur="cartAutoSubmit(this, true)">
                                                <button class="btn btn-outline-secondary" type="button" onclick="cartStep(this, 1)">+</button>
                                            </div>

                                            <!-- Fallback nếu JS tắt -->
                                            <button class="btn btn-outline-primary btn-sm d-none">Cập nhật</button>
                                        </form>
                                    </td>

                                    <!-- Thành tiền -->
                                    <td class="text-end">
                                        <fmt:formatNumber value="${rowTotal}" type="currency" currencySymbol="₫" minFractionDigits="0"/>
                                    </td>

                                    <!-- Xóa -->
                                    <td class="text-end">
                                        <c:url var="rmUrl" value="/remove-from-cart">
                                            <c:param name="productId" value="${it.productId}" />
                                            <c:param name="size" value="${it.size}" />
                                            <c:param name="color" value="${it.color}" />
                                        </c:url>
                                        <a href="${rmUrl}" class="btn btn-outline-danger btn-sm">Xóa</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>

                        <!-- Tổng cộng -->
                        <tfoot>
                            <tr>
                                <th colspan="5" class="text-end">Tổng cộng:</th>
                                <th class="text-end">
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.cart && not empty sessionScope.cart.totalAmount}">
                                            <fmt:formatNumber value="${sessionScope.cart.totalAmount}" type="currency" currencySymbol="₫" minFractionDigits="0"/>
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="sum" value="0" scope="page"/>
                                            <c:forEach var="it" items="${items}">
                                                <c:set var="sum" value="${sum + (it.lineTotal != null ? it.lineTotal : it.price * it.qty)}" scope="page"/>
                                            </c:forEach>
                                            <fmt:formatNumber value="${sum}" type="currency" currencySymbol="₫" minFractionDigits="0"/>
                                        </c:otherwise>
                                    </c:choose>
                                </th>
                                <th></th>
                            </tr>
                        </tfoot>
                    </table>

                    <div class="sticky d-flex gap-2 justify-content-end mt-3">
                        <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-secondary">← Tiếp tục mua</a>
                        <a href="${pageContext.request.contextPath}/checkout" class="btn btn-success">Thanh toán</a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>

        <!-- JS nhỏ gọn cho +/- và auto submit -->
        <script>
            function cartSubmitOnce(form) {
                if (form.__submitting)
                    return false;
                form.__submitting = true;
                return true;
            }
            function cartStep(btn, delta) {
                const input = btn.parentElement.querySelector('.qty-input');
                let val = parseInt(input.value || '0', 10);
                if (isNaN(val))
                    val = 0;
                val = Math.max(parseInt(input.min || '0', 10), val + delta);
                input.value = val;
                cartAutoSubmit(input);
            }
            let cartTimer = null;
            function cartAutoSubmit(el, immediate) {
                const form = el.form;
                let v = parseInt(el.value || '0', 10);
                if (isNaN(v) || v < 0)
                    v = 0;
                el.value = v;
                if (immediate) {
                    form.requestSubmit();
                    return;
                }
                clearTimeout(cartTimer);
                cartTimer = setTimeout(() => {
                    if (!form.__submitting)
                        form.requestSubmit();
                }, 350);
            }
        </script>
    </body>
</html>