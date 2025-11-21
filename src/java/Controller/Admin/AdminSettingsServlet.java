package Controller.Admin;

import Dal.Admin.AdminSettingsDAO;
import Model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;

/**
 * Admin Settings Servlet - Quản lý cài đặt hệ thống
 * @author Kien-Ptit
 * @date 2025-11-20
 */
@WebServlet(name = "AdminSettingsServlet", urlPatterns = {"/Admin/settings"})
public class AdminSettingsServlet extends HttpServlet {

    private AdminSettingsDAO settingsDAO;

    @Override
    public void init() throws ServletException {
        try {
            settingsDAO = new AdminSettingsDAO();
        } catch (Exception e) {
            throw new ServletException("Failed to initialize SettingsDAO", e);
        }
    }

    private boolean isAdmin(User user) {
        return user != null && "admin".equals(user.getRole());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session == null) ? null : (User) session.getAttribute("user");

        if (!isAdmin(user)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Lấy tất cả settings
            Map<String, String> settings = settingsDAO.getAllSettings();
            request.setAttribute("settings", settings);

            // Thông tin user hiện tại
            request.setAttribute("currentUser", user);

            request.getRequestDispatcher("/Admin/settings.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "❌ Lỗi khi tải cài đặt: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/Admin/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User user = (session == null) ? null : (User) session.getAttribute("user");

        if (!isAdmin(user)) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String action = request.getParameter("action");

        try {
            // ===== CẬP NHẬT CÀI ĐẶT CHUNG =====
            if ("updateGeneral".equals(action)) {
                String siteName = request.getParameter("siteName");
                String siteEmail = request.getParameter("siteEmail");
                String sitePhone = request.getParameter("sitePhone");
                String siteAddress = request.getParameter("siteAddress");
                String siteDescription = request.getParameter("siteDescription");

                settingsDAO.updateSetting("site_name", siteName);
                settingsDAO.updateSetting("site_email", siteEmail);
                settingsDAO.updateSetting("site_phone", sitePhone);
                settingsDAO.updateSetting("site_address", siteAddress);
                settingsDAO.updateSetting("site_description", siteDescription);

                session.setAttribute("success", "✅ Đã cập nhật cài đặt chung thành công!");
            }

            // ===== CẬP NHẬT CÀI ĐẶT EMAIL =====
            else if ("updateEmail".equals(action)) {
                String smtpHost = request.getParameter("smtpHost");
                String smtpPort = request.getParameter("smtpPort");
                String smtpUsername = request.getParameter("smtpUsername");
                String smtpPassword = request.getParameter("smtpPassword");
                String smtpEncryption = request.getParameter("smtpEncryption");

                settingsDAO.updateSetting("smtp_host", smtpHost);
                settingsDAO.updateSetting("smtp_port", smtpPort);
                settingsDAO.updateSetting("smtp_username", smtpUsername);
                if (smtpPassword != null && !smtpPassword.isEmpty()) {
                    settingsDAO.updateSetting("smtp_password", smtpPassword);
                }
                settingsDAO.updateSetting("smtp_encryption", smtpEncryption);

                session.setAttribute("success", "✅ Đã cập nhật cài đặt email thành công!");
            }

            // ===== CẬP NHẬT CÀI ĐẶT THANH TOÁN =====
            else if ("updatePayment".equals(action)) {
                String enableCod = request.getParameter("enableCod");
                String enableVnpay = request.getParameter("enableVnpay");
                String vnpayTmnCode = request.getParameter("vnpayTmnCode");
                String vnpayHashSecret = request.getParameter("vnpayHashSecret");
                String vnpayUrl = request.getParameter("vnpayUrl");

                settingsDAO.updateSetting("enable_cod", enableCod != null ? "1" : "0");
                settingsDAO.updateSetting("enable_vnpay", enableVnpay != null ? "1" : "0");
                settingsDAO.updateSetting("vnpay_tmn_code", vnpayTmnCode);
                settingsDAO.updateSetting("vnpay_hash_secret", vnpayHashSecret);
                settingsDAO.updateSetting("vnpay_url", vnpayUrl);

                session.setAttribute("success", "✅ Đã cập nhật cài đặt thanh toán thành công!");
            }

            // ===== CẬP NHẬT CÀI ĐẶT VẬN CHUYỂN =====
            else if ("updateShipping".equals(action)) {
                String shippingFee = request.getParameter("shippingFee");
                String freeShippingThreshold = request.getParameter("freeShippingThreshold");
                String estimatedDelivery = request.getParameter("estimatedDelivery");

                settingsDAO.updateSetting("shipping_fee", shippingFee);
                settingsDAO.updateSetting("free_shipping_threshold", freeShippingThreshold);
                settingsDAO.updateSetting("estimated_delivery", estimatedDelivery);

                session.setAttribute("success", "✅ Đã cập nhật cài đặt vận chuyển thành công!");
            }

            // ===== ĐỔI MẬT KHẨU =====
            else if ("changePassword".equals(action)) {
                String currentPassword = request.getParameter("currentPassword");
                String newPassword = request.getParameter("newPassword");
                String confirmPassword = request.getParameter("confirmPassword");

                if (newPassword == null || newPassword.length() < 6) {
                    session.setAttribute("error", "❌ Mật khẩu mới phải có ít nhất 6 ký tự!");
                } else if (!newPassword.equals(confirmPassword)) {
                    session.setAttribute("error", "❌ Mật khẩu xác nhận không khớp!");
                } else {
                    boolean changed = settingsDAO.changePassword(user.getId(), currentPassword, newPassword);
                    
                    if (changed) {
                        session.setAttribute("success", "✅ Đổi mật khẩu thành công!");
                    } else {
                        session.setAttribute("error", "❌ Mật khẩu hiện tại không đúng!");
                    }
                }
            }

            // ===== CẬP NHẬT THÔNG TIN CÁ NHÂN =====
            else if ("updateProfile".equals(action)) {
                String fullname = request.getParameter("fullname");
                String email = request.getParameter("email");
                String phone = request.getParameter("phone");

                boolean updated = settingsDAO.updateUserProfile(user.getId(), fullname, email, phone);
                
                if (updated) {
                    // Cập nhật lại session
                    user.setFullname(fullname);
                    user.setEmail(email);
                    user.setPhone(phone);
                    session.setAttribute("user", user);
                    
                    session.setAttribute("success", "✅ Cập nhật thông tin cá nhân thành công!");
                } else {
                    session.setAttribute("error", "❌ Không thể cập nhật thông tin!");
                }
            }

            // ===== XÓA CACHE =====
            else if ("clearCache".equals(action)) {
                // TODO: Implement cache clearing logic
                session.setAttribute("success", "✅ Đã xóa cache thành công!");
            }

            response.sendRedirect(request.getContextPath() + "/Admin/settings");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "❌ Lỗi: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/Admin/settings");
        }
    }

    @Override
    public String getServletInfo() {
        return "Admin Settings Servlet - System configuration management";
    }
}