<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Đăng nhập</title>
  <!-- dùng contextPath + version để tránh cache -->
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/login.css?v=3">
</head>
<body class="login-page">
<div class="container">
  <h2>Đăng nhập</h2>

  <!-- Đổi action nếu servlet bạn map khác (ví dụ /LoginServlet) -->
  <form class="login-form" action="<%= request.getContextPath() %>/login" method="post">
    <div class="form-group">
      <label for="username">Tên đăng nhập hoặc Email</label>
      <input id="username" name="username" type="text" required
             value="<%= request.getParameter("username")!=null?request.getParameter("username"):"" %>">
    </div>

    <div class="form-group">
      <label for="password">Mật khẩu</label>
      <input id="password" name="password" type="password" required>
    </div>

    <button type="submit" class="btn">Đăng nhập</button>

    <p class="msg error"><%= request.getAttribute("error")!=null?request.getAttribute("error"):"" %></p>
    <p class="msg success"><%= request.getAttribute("message")!=null?request.getAttribute("message"):"" %></p>

    <p class="auth-switch">
      Chưa có tài khoản?
      <a href="<%= request.getContextPath() %>/register">Đăng ký ngay</a>
    </p>
  </form>
</div>
</body>
</html>
