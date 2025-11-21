<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Đăng ký</title>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/register.css?v=7">
    </head>
    <body class="register-page">
        <div class="container">
            <h2>Đăng ký</h2>

            <!-- Form gửi/hiển thị đều qua /register -->
            <form class="register-form" action="<%= request.getContextPath() %>/register" method="post">
                <div class="grid-2">
                    <div class="form-group">
                        <label for="username">Tên đăng nhập</label>
                        <input id="username" name="username" type="text" required
                               value="<%= request.getParameter("username")!=null?request.getParameter("username"):"" %>">
                    </div>

                    <div class="form-group">
                        <label for="email">Email</label>
                        <input id="email" name="email" type="email" required
                               value="<%= request.getParameter("email")!=null?request.getParameter("email"):"" %>">
                    </div>

                    <div class="form-group">
                        <label for="password">Mật khẩu</label>
                        <input id="password" name="password" type="password" required autocomplete="new-password">
                        <!-- Thanh đo độ mạnh realtime -->
                        <div class="strength">
                            <div class="strength-bar"><div id="strengthFill" class="fill lv0" style="width:0%"></div></div>
                            <div class="strength-legend">Độ mạnh: <span id="strengthText" class="badge">Chưa đánh giá</span></div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="full_name">Họ và tên</label>
                        <input id="full_name" name="full_name" type="text"
                               value="<%= request.getParameter("full_name")!=null?request.getParameter("full_name"):"" %>">
                    </div>

                    <div class="form-group">
                        <label for="phone">Số điện thoại</label>
                        <input id="phone" name="phone" type="text"
                               value="<%= request.getParameter("phone")!=null?request.getParameter("phone"):"" %>">
                    </div>

                    <div class="form-group">
                        <label for="address">Địa chỉ</label>
                        <input id="address" name="address" type="text"
                               value="<%= request.getParameter("address")!=null?request.getParameter("address"):"" %>">
                    </div>

                    <!-- Captcha (full hàng) -->
                    <div class="form-group full">
                        <label>Mã Captcha</label>
                        <div class="captcha-row">
                            <div class="captcha-box"><%= (String) session.getAttribute("captcha") %></div>
                            <!-- GET /register để load lại trang và sinh captcha mới -->
                            <a class="captcha-refresh" href="<%= request.getContextPath() %>/register">Mã mới</a>
                        </div>
                    </div>

                    <div class="form-group full">
                        <label for="captcha_input">Nhập captcha</label>
                        <input id="captcha_input" name="captcha_input" type="text" required>
                    </div>
                </div>

                <button type="submit" class="btn">Đăng ký</button>
                <p class="auth-switch">
                    Đã có tài khoản?
                    <a href="<%= request.getContextPath() %>/login">Đăng nhập ngay</a>
                </p>
                <p class="msg error"><%= request.getAttribute("error")!=null?request.getAttribute("error"):"" %></p>
                <p class="msg success"><%= request.getAttribute("message")!=null?request.getAttribute("message"):"" %></p>
            </form>
        </div>

        <!-- JS ngắn hiển thị độ mạnh mật khẩu theo thời gian thực -->
        <script>
            (function () {
                const pwd = document.getElementById('password');
                const fill = document.getElementById('strengthFill');
                const text = document.getElementById('strengthText');

                function score(p) {
                    if (!p)
                        return 0;
                    let s = 0;
                    if (p.length >= 8)
                        s++;
                    if (/[A-Z]/.test(p))
                        s++;
                    if (/[a-z]/.test(p))
                        s++;
                    if (/\d/.test(p))
                        s++;
                    if (/[^A-Za-z0-9]/.test(p))
                        s++;
                    return s;
                }
                function label(s) {
                    if (s <= 2)
                        return 'Yếu';
                    if (s === 3)
                        return 'Trung bình';
                    if (s === 4)
                        return 'Khá';
                    return 'Mạnh';
                }
                function update() {
                    const s = score(pwd.value);
                    fill.style.width = (s * 20) + '%';
                    fill.className = 'fill lv' + s;
                    text.textContent = label(s);
                }
                pwd.addEventListener('input', update);
                update();
            })();
        </script>
    </body>
</html>
