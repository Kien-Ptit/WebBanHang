package Controller.Profile;

import Dal.CartDAO;
import Dal.ProductDAO;
import Dal.UserDAO;
import Model.Cart;
import Model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private void noCache(HttpServletResponse resp) {
        resp.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
        resp.setHeader("Pragma", "no-cache");
        resp.setDateHeader("Expires", 0);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        noCache(resp);
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        noCache(resp);
        req.setCharacterEncoding("UTF-8");

        String usernameOrEmail = req.getParameter("username");
        String password = req.getParameter("password");

        if (usernameOrEmail == null || usernameOrEmail.trim().isEmpty()
                || password == null || password.trim().isEmpty()) {
            req.setAttribute("error", "Vui lòng nhập đầy đủ tài khoản và mật khẩu.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        try {
            UserDAO dao = new UserDAO();
            CartDAO dao1 = new CartDAO();
            User user = dao.login(usernameOrEmail.trim(), password.trim());

            // THÊM LOG DEBUG
            System.out.println("DEBUG - User found: " + (user != null ? user.getUsername() : "null"));

            if (user == null) {
                req.setAttribute("error", "Sai tài khoản/mật khẩu hoặc tài khoản không hoạt động.");
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
                return;
            }
            // Sau khi đã xác thực thành công, biến `user` != null
            HttpSession session = req.getSession(true);
            session.setAttribute("user", user);                 // Để header.jsp nhận ra đã đăng nhập
            session.setAttribute("userId", user.getId());
            session.setAttribute("userRole", user.getRole());   // Header đang dùng userRole cho menu Admin
            session.setMaxInactiveInterval(60 * 60 * 2);        // 2 giờ, tùy bạn
            try {
                Cart cart = dao1.loadCartForUser(user.getId());  // <-- dùng đúng hàm bạn đang có
                session.setAttribute("cart", cart);
            } finally {
                try {
                    dao.close();
                } catch (Exception ignore) {
                }
            }
            // Nếu bạn có lưu URL trước login thì dùng, không thì về home
            String backUrl = (String) session.getAttribute("afterLoginRedirect");
            if (backUrl != null) {
                session.removeAttribute("afterLoginRedirect");
                resp.sendRedirect(resp.encodeRedirectURL(backUrl));
            } else {
                resp.sendRedirect(resp.encodeRedirectURL(req.getContextPath() + "/home"));
            }
        } catch (Exception e) {
            e.printStackTrace(); // Để xem lỗi chi tiết
            req.setAttribute("error", "Có lỗi khi đăng nhập: " + e.getMessage());
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }

}
