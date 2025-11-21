package Dal.Admin;

import Dal.DBContext;
import java.sql.*;
import java.util.HashMap;
import java.util.Map;

/**
 * Admin Settings DAO
 * @author Kien-Ptit
 * @date 2025-11-20
 */
public class AdminSettingsDAO extends DBContext {

    /**
     * Lấy tất cả settings
     */
    public Map<String, String> getAllSettings() throws Exception {
        String sql = "SELECT setting_key, setting_value FROM system_settings";
        Map<String, String> settings = new HashMap<>();

        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            
            while (rs.next()) {
                settings.put(rs.getString("setting_key"), rs.getString("setting_value"));
            }
        }

        // Set default values nếu không tồn tại
        settings.putIfAbsent("site_name", "Kien Store");
        settings.putIfAbsent("site_email", "contact@kienstore.com");
        settings.putIfAbsent("site_phone", "0123456789");
        settings.putIfAbsent("site_address", "Hà Nội, Việt Nam");
        settings.putIfAbsent("site_description", "Cửa hàng thời trang trực tuyến");
        settings.putIfAbsent("shipping_fee", "30000");
        settings.putIfAbsent("free_shipping_threshold", "500000");
        settings.putIfAbsent("estimated_delivery", "3-5 ngày");
        settings.putIfAbsent("enable_cod", "1");
        settings.putIfAbsent("enable_vnpay", "0");

        return settings;
    }

    /**
     * Cập nhật hoặc thêm mới setting
     */
    public boolean updateSetting(String key, String value) throws Exception {
        String sql = """
            INSERT INTO system_settings (setting_key, setting_value, updated_at)
            VALUES (?, ?, NOW())
            ON DUPLICATE KEY UPDATE setting_value = ?, updated_at = NOW()
        """;

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, key);
            st.setString(2, value);
            st.setString(3, value);
            
            int rows = st.executeUpdate();
            System.out.println("✅ Updated setting: " + key + " = " + value);
            
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("❌ Error updating setting: " + e.getMessage());
            throw e;
        }
    }

    /**
     * Lấy giá trị của 1 setting
     */
    public String getSetting(String key) throws Exception {
        String sql = "SELECT setting_value FROM system_settings WHERE setting_key = ?";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, key);

            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("setting_value");
                }
            }
        }

        return null;
    }

    /**
     * Đổi mật khẩu user
     */
    public boolean changePassword(int userId, String currentPassword, String newPassword) throws Exception {
        // Kiểm tra mật khẩu hiện tại
        String checkSql = "SELECT password FROM users WHERE id = ?";
        String currentHash = null;

        try (PreparedStatement st = connection.prepareStatement(checkSql)) {
            st.setInt(1, userId);

            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    currentHash = rs.getString("password");
                }
            }
        }

        // Verify current password (giả sử không hash - production nên dùng BCrypt)
        if (currentHash == null || !currentHash.equals(currentPassword)) {
            return false;
        }

        // Update new password
        String updateSql = "UPDATE users SET password = ?, updated_at = NOW() WHERE id = ?";

        try (PreparedStatement st = connection.prepareStatement(updateSql)) {
            st.setString(1, newPassword); // TODO: Hash password
            st.setInt(2, userId);

            int rows = st.executeUpdate();
            System.out.println("✅ Changed password for user ID: " + userId);

            return rows > 0;
        }
    }

    /**
     * Cập nhật thông tin user
     */
    public boolean updateUserProfile(int userId, String fullname, String email, String phone) throws Exception {
        String sql = """
            UPDATE users 
            SET full_name = ?, email = ?, phone = ?, updated_at = NOW()
            WHERE id = ?
        """;

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, fullname);
            st.setString(2, email);
            st.setString(3, phone);
            st.setInt(4, userId);

            int rows = st.executeUpdate();
            System.out.println("✅ Updated profile for user ID: " + userId);

            return rows > 0;
        }
    }

    /**
     * Xóa setting
     */
    public boolean deleteSetting(String key) throws Exception {
        String sql = "DELETE FROM system_settings WHERE setting_key = ?";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, key);
            return st.executeUpdate() > 0;
        }
    }
}