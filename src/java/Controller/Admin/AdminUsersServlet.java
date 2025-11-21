package Controller.Admin;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import Dal.Admin.AdminUserDAO;
import Model.User;

/**
 * Admin Users Management Servlet
 *
 * @author Kien-Ptit
 * @version 2.0
 * @since 2025-10-25
 */
@WebServlet("/Admin/users")
public class AdminUsersServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User user = (session == null) ? null : (User) session.getAttribute("user");

        if (user == null || !isAdmin(user)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        String idStr = req.getParameter("id");

        try {
            AdminUserDAO dao = new AdminUserDAO();

            // GET USER JSON
            if ("get".equals(action) && idStr != null) {
                int userId = Integer.parseInt(idStr);
                User targetUser = dao.findById(userId);

                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                PrintWriter out = resp.getWriter();

                if (targetUser != null) {
                    StringBuilder json = new StringBuilder();
                    json.append("{");
                    json.append("\"id\":").append(targetUser.getId()).append(",");
                    json.append("\"username\":\"").append(escapeJson(targetUser.getUsername())).append("\",");
                    json.append("\"fullname\":\"").append(escapeJson(targetUser.getFullname())).append("\",");
                    json.append("\"email\":\"").append(escapeJson(targetUser.getEmail())).append("\",");
                    json.append("\"phone\":\"").append(escapeJson(targetUser.getPhone())).append("\",");
                    json.append("\"role\":\"").append(escapeJson(targetUser.getRole())).append("\",");
                    json.append("\"status\":\"").append(escapeJson(targetUser.getStatus())).append("\"");
                    json.append("}");

                    out.print(json.toString());
                } else {
                    resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    out.print("{\"error\":\"User not found\"}");
                }

                out.flush();
                return;
            }

            // DELETE USER
            if ("delete".equals(action) && idStr != null) {
                int userId = Integer.parseInt(idStr);

                // Không cho phép xóa chính mình
                if (userId == user.getId()) {
                    session.setAttribute("error", "Bạn không thể xóa tài khoản của chính mình!");
                    resp.sendRedirect(req.getContextPath() + "/Admin/users");
                    return;
                }

                boolean deleted = dao.deleteUser(userId);

                if (deleted) {
                    session.setAttribute("success", "Xóa người dùng thành công!");
                } else {
                    session.setAttribute("error", "Không thể xóa người dùng!");
                }

                resp.sendRedirect(req.getContextPath() + "/Admin/users");
                return;
            }

            // TOGGLE STATUS
            if ("toggle".equals(action) && idStr != null) {
                int userId = Integer.parseInt(idStr);

                // Không cho phép thay đổi status của chính mình
                if (userId == user.getId()) {
                    session.setAttribute("error", "❌ Bạn không thể thay đổi trạng thái của chính mình!");
                    resp.sendRedirect(req.getContextPath() + "/Admin/users");
                    return;
                }

                try {
                    boolean toggled = dao.toggleUserStatus(userId);

                    if (toggled) {
                        session.setAttribute("success", "✅ Cập nhật trạng thái người dùng thành công!");
                    } else {
                        session.setAttribute("error", "❌ Không thể cập nhật trạng thái!");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    session.setAttribute("error", "❌ Lỗi: " + e.getMessage());
                }

                resp.sendRedirect(req.getContextPath() + "/Admin/users");
                return;
            }

            // LIST
            String search = req.getParameter("search");
            String role = req.getParameter("role");

            List<User> users;

            if (search != null && !search.trim().isEmpty()) {
                users = dao.searchUsers(search.trim());
            } else if (role != null && !role.trim().isEmpty()) {
                users = dao.getUsersByRole(role);
            } else {
                users = dao.getAllUsers();
            }

            // Thống kê
            int totalUsers = dao.getTotalUsers();
            int totalAdmins = dao.getTotalAdmins();
            int todayNewUsers = dao.getTodayNewUsers();

            req.setAttribute("users", users);
            req.setAttribute("searchQuery", search);
            req.setAttribute("selectedRole", role);
            req.setAttribute("totalUsers", totalUsers);
            req.setAttribute("totalAdmins", totalAdmins);
            req.setAttribute("todayNewUsers", todayNewUsers);

            req.getRequestDispatcher("/Admin/users.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Có lỗi: " + e.getMessage());
            req.getRequestDispatcher("/Admin/users.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        User user = (session == null) ? null : (User) session.getAttribute("user");

        if (user == null || !isAdmin(user)) {
            resp.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String action = req.getParameter("action");

        try {
            AdminUserDAO dao = new AdminUserDAO();

            if ("create".equals(action)) {
                String username = req.getParameter("username");
                String password = req.getParameter("password");
                String fullname = req.getParameter("fullname");
                String email = req.getParameter("email");
                String phone = req.getParameter("phone");
                String role = req.getParameter("role");

                // Validation
                if (username == null || username.trim().isEmpty()
                        || password == null || password.trim().isEmpty()
                        || fullname == null || fullname.trim().isEmpty()
                        || email == null || email.trim().isEmpty()) {

                    session.setAttribute("error", "Vui lòng điền đầy đủ thông tin bắt buộc!");
                    resp.sendRedirect(req.getContextPath() + "/Admin/users");
                    return;
                }

                // Kiểm tra username/email đã tồn tại
                if (dao.checkUserExists(username, email)) {
                    session.setAttribute("error", "Tên đăng nhập hoặc email đã tồn tại!");
                    resp.sendRedirect(req.getContextPath() + "/Admin/users");
                    return;
                }

                User newUser = new User();
                newUser.setUsername(username.trim());
                newUser.setPassword(password); // TODO: Nên hash password
                newUser.setFullname(fullname.trim());
                newUser.setEmail(email.trim());
                newUser.setPhone(phone != null ? phone.trim() : "");
                newUser.setRole(role != null ? role : "customer");
                newUser.setStatus("active");

                boolean created = dao.createUser(newUser);

                if (created) {
                    session.setAttribute("success", "✅ Thêm người dùng thành công!");
                } else {
                    session.setAttribute("error", "❌ Không thể thêm người dùng!");
                }

            } else if ("update".equals(action)) {
                String userIdStr = req.getParameter("userId");
                String fullname = req.getParameter("fullname");
                String email = req.getParameter("email");
                String phone = req.getParameter("phone");
                String role = req.getParameter("role");

                if (userIdStr == null || fullname == null || email == null) {
                    session.setAttribute("error", "❌ Thiếu thông tin cần thiết!");
                    resp.sendRedirect(req.getContextPath() + "/Admin/users");
                    return;
                }

                int userId = Integer.parseInt(userIdStr);

                // Không cho phép thay đổi role của chính mình
                if (userId == user.getId() && !role.equals(user.getRole())) {
                    session.setAttribute("error", "❌ Bạn không thể thay đổi vai trò của chính mình!");
                    resp.sendRedirect(req.getContextPath() + "/Admin/users");
                    return;
                }

                User updateUser = new User();
                updateUser.setId(userId);
                updateUser.setFullname(fullname.trim());
                updateUser.setEmail(email.trim());
                updateUser.setPhone(phone != null ? phone.trim() : "");
                updateUser.setRole(role);

                boolean updated = dao.updateUser(updateUser);

                if (updated) {
                    session.setAttribute("success", "✅ Cập nhật người dùng thành công!");
                } else {
                    session.setAttribute("error", "❌ Không thể cập nhật người dùng!");
                }
            }

            resp.sendRedirect(req.getContextPath() + "/Admin/users");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "❌ Có lỗi: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/Admin/users");
        }
    }

    private String escapeJson(String str) {
        if (str == null) {
            return "";
        }
        return str.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }

    private boolean isAdmin(User user) {
        return user != null && user.getRole() != null
                && user.getRole().equalsIgnoreCase("admin");
    }
}
