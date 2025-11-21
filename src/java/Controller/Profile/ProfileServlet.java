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

/**
 *
 * @author Admin
 */
@WebServlet(name="ProfileServlet", urlPatterns={"/profile"})
public class ProfileServlet extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
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
            out.println("<title>Servlet ProfileServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ProfileServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private void setNoCache(HttpServletResponse resp) {
        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        resp.setHeader("Pragma", "no-cache");
        resp.setDateHeader("Expires", 0);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        setNoCache(resp);
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // chuyển flash từ session -> request (nếu có)
        Object flash = session.getAttribute("flash");
        if (flash != null) {
            req.setAttribute("flash", flash);
            session.removeAttribute("flash");
        }

        req.getRequestDispatcher("/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        setNoCache(resp);
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        User user = (User) session.getAttribute("user");
        String action = req.getParameter("action");

        UserDAO dao = new UserDAO();

        try {
            if ("updateProfile".equals(action)) {
                String fullname = req.getParameter("fullname");
                String email    = req.getParameter("email");
                String phone    = req.getParameter("phone");
                String address  = req.getParameter("address");
                String avatarUrl = req.getParameter("avatarUrl");

                // cập nhật bản ghi
                user.setFullname(fullname);
                user.setEmail(email);
                user.setPhone(phone);
                user.setAddress(address);
                user.setAvatar(avatarUrl);

                boolean ok = dao.updateProfile(user);
                if (ok) {
                    // refresh session user (nếu muốn, có thể load lại từ DB)
                    session.setAttribute("user", user);
                    session.setAttribute("flash", new Flash("success","Cập nhật hồ sơ thành công."));
                } else {
                    session.setAttribute("flash", new Flash("error","Cập nhật hồ sơ thất bại."));
                }
                resp.sendRedirect(req.getContextPath() + "/profile");
                return;

            } else if ("changePassword".equals(action)) {
                String current = req.getParameter("currentPassword");
                String npw     = req.getParameter("newPassword");
                String cfm     = req.getParameter("confirmPassword");

                if (npw == null || !npw.equals(cfm)) {
                    session.setAttribute("flash", new Flash("error", "Mật khẩu mới và xác nhận không khớp."));
                    resp.sendRedirect(req.getContextPath() + "/profile?tab=password");
                    return;
                }

                boolean ok = dao.changePassword(user.getId(), current, npw);
                if (ok) {
                    session.setAttribute("flash", new Flash("success", "Đổi mật khẩu thành công."));
                } else {
                    session.setAttribute("flash", new Flash("error", "Mật khẩu hiện tại không đúng."));
                }
                resp.sendRedirect(req.getContextPath() + "/profile?tab=password");
                return;

            } else {
                session.setAttribute("flash", new Flash("error", "Yêu cầu không hợp lệ."));
                resp.sendRedirect(req.getContextPath() + "/profile");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("flash", new Flash("error", "Lỗi: " + e.getMessage()));
            resp.sendRedirect(req.getContextPath() + "/profile");
        }
    }

    // Flash message helper (class lồng đơn giản)
    public static class Flash implements java.io.Serializable {
        public String type;
        public String message;
        public Flash(String type, String message) {
            this.type = type;
            this.message = message;
        }
        public String getType() { return type; }
        public String getMessage() { return message; }
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
