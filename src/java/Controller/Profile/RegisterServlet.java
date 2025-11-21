/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.Profile;

import Dal.UserDAO;
import Model.User;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.Random;

/**
 *
 * @author Admin
 */
@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet RegisterServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet RegisterServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    private static final long serialVersionUID = 1L;

    // Sinh captcha 5 ký tự dễ đọc
    private String generateCaptcha() {
        String chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
        StringBuilder sb = new StringBuilder();
        Random rnd = new Random();
        for (int i = 0; i < 5; i++) {
            sb.append(chars.charAt(rnd.nextInt(chars.length())));
        }
        return sb.toString();
    }

    // Chặn cache để luôn thấy captcha mới khi F5/back
    private void noCache(HttpServletResponse resp) {
        resp.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
        resp.setHeader("Pragma", "no-cache");
        resp.setDateHeader("Expires", 0);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        noCache(resp);
        // Mỗi lần vào trang => set captcha mới
        req.getSession().setAttribute("captcha", generateCaptcha());
        // Hiển thị form
        req.getRequestDispatcher("register.jsp").forward(req, resp);
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        noCache(resp);
        req.setCharacterEncoding("UTF-8");

        // Lấy dữ liệu form
        String username = trim(req.getParameter("username"));
        String email = trim(req.getParameter("email"));
        String password = trim(req.getParameter("password"));
        String fullName = trim(req.getParameter("full_name"));
        String phone = trim(req.getParameter("phone"));
        String address = trim(req.getParameter("address"));
        String captchaInput = trim(req.getParameter("captcha_input"));

        HttpSession session = req.getSession();
        String captchaSession = (String) session.getAttribute("captcha");

        // Luôn đổi captcha mới cho lần hiển thị tiếp theo
        session.setAttribute("captcha", generateCaptcha());

        // Validate cơ bản phía server
        if (isEmpty(username) || isEmpty(email) || isEmpty(password)) {
            req.setAttribute("error", "Vui lòng nhập đầy đủ Tên đăng nhập, Email và Mật khẩu.");
            req.getRequestDispatcher("/register").forward(req, resp);
            return;
        }

        // Validate captcha
        if (captchaSession == null || !captchaSession.equalsIgnoreCase(captchaInput)) {
            req.setAttribute("error", "Captcha không đúng! Vui lòng thử lại.");
            req.getRequestDispatcher("/register").forward(req, resp);
            return;
        }

        // Kiểm tra trùng & Insert
        UserDAO userDAO = new UserDAO();
        try {
            if (userDAO.checkUserExists(username, email)) {
                req.setAttribute("error", "Tên đăng nhập hoặc email đã tồn tại!");
                req.getRequestDispatcher("/register").forward(req, resp);
                return;
            }

            User u = new User();
            u.setUsername(username);
            u.setPassword(password);   // Nếu muốn mã hoá, thêm BCrypt/SHA ở đây
            u.setEmail(email);
            u.setFullname(fullName);
            u.setPhone(phone);
            u.setAddress(address);
            u.setRole("customer");
            u.setStatus("active");

            userDAO.insert(u);

            // Thành công: bỏ captcha cũ & chuyển sang trang đăng nhập
            session.removeAttribute("captcha");
            resp.sendRedirect(req.getContextPath() + "/login");
        } catch (Exception e) {
            req.setAttribute("error", "Có lỗi khi đăng ký: " + e.getMessage());
            // Đã set captcha mới ở trên, forward lại form
            req.getRequestDispatcher("/register").forward(req, resp);
        }
    }

    // Helpers
    private static String trim(String s) {
        return s == null ? null : s.trim();
    }

    private static boolean isEmpty(String s) {
        return s == null || s.trim().isEmpty();
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
