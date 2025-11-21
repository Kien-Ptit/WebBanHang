<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt hàng thành công</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container py-5 text-center">
    <h2 class="text-success mb-3">Cảm ơn bạn! Đơn hàng đã được tạo.</h2>
    <p>Mã đơn hàng của bạn: <strong><%= request.getParameter("orderId") %></strong></p>
    <a href="products" class="btn btn-primary mt-3">Tiếp tục mua sắm</a>
</div>
</body>
</html>
