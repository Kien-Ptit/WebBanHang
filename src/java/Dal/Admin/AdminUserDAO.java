package Dal.Admin;

import Dal.DBContext;
import Model.User;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * DAO riêng cho Admin quản lý Users
 *
 * @author Kien-Ptit
 * @version 1.0
 * @since 2025-10-25
 */
public class AdminUserDAO extends DBContext {

    /**
     * Lấy tất cả người dùng
     */
    public List<User> getAllUsers() throws Exception {
        String sql = "SELECT * FROM users ORDER BY created_at DESC";
        List<User> users = new ArrayList<>();

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                users.add(mapUser(rs));
            }
        }

        return users;
    }

    /**
     * Tìm user theo ID
     */
    public User findById(int id) throws Exception {
        String sql = "SELECT * FROM users WHERE id = ?";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                return mapUser(rs);
            }
        }

        return null;
    }

    /**
     * Tìm kiếm người dùng
     */
    public List<User> searchUsers(String keyword) throws Exception {
        String sql = """
            SELECT * FROM users 
            WHERE full_name LIKE ? 
               OR email LIKE ? 
               OR phone LIKE ?
               OR username LIKE ?
            ORDER BY created_at DESC
        """;

        List<User> users = new ArrayList<>();

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            String searchPattern = "%" + keyword + "%";
            st.setString(1, searchPattern);
            st.setString(2, searchPattern);
            st.setString(3, searchPattern);
            st.setString(4, searchPattern);

            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                users.add(mapUser(rs));
            }
        }

        return users;
    }

    /**
     * Lấy người dùng theo vai trò
     */
    public List<User> getUsersByRole(String role) throws Exception {
        String sql = "SELECT * FROM users WHERE role = ? ORDER BY created_at DESC";
        List<User> users = new ArrayList<>();

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, role);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                users.add(mapUser(rs));
            }
        }

        return users;
    }

    /**
     * Tạo người dùng mới
     */
    public boolean createUser(User user) throws Exception {
        String sql = """
            INSERT INTO users (
                username, password, full_name, email, phone, 
                role, status, created_at
            ) VALUES (?, ?, ?, ?, ?, ?, ?, NOW())
        """;

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, user.getUsername());
            st.setString(2, user.getPassword());
            st.setString(3, user.getFullname());
            st.setString(4, user.getEmail());
            st.setString(5, user.getPhone());
            st.setString(6, user.getRole());
            st.setString(7, user.getStatus() != null ? user.getStatus() : "active");

            return st.executeUpdate() > 0;
        }
    }

    /**
     * Cập nhật người dùng
     */
    public boolean updateUser(User user) throws Exception {
        String sql = """
            UPDATE users 
            SET full_name = ?, 
                email = ?, 
                phone = ?, 
                role = ?, 
                updated_at = NOW() 
            WHERE id = ?
        """;

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, user.getFullname());
            st.setString(2, user.getEmail());
            st.setString(3, user.getPhone());
            st.setString(4, user.getRole());
            st.setInt(5, user.getId());

            return st.executeUpdate() > 0;
        }
    }

    /**
     * Xóa người dùng
     */
    public boolean deleteUser(int id) throws Exception {
        String sql = "DELETE FROM users WHERE id = ?";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, id);
            return st.executeUpdate() > 0;
        }
    }

    /**
     * Toggle trạng thái user
     */
    public boolean toggleUserStatus(int id) throws Exception {
        String sql = """
            UPDATE users 
            SET status = CASE WHEN status = 'active' THEN 'inactive' ELSE 'active' END,
                updated_at = NOW() 
            WHERE id = ?
        """;

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, id);
            return st.executeUpdate() > 0;
        }
    }

    /**
     * Kiểm tra username/email đã tồn tại
     */
    public boolean checkUserExists(String username, String email) throws Exception {
        String sql = "SELECT id FROM users WHERE username = ? OR email = ?";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, username);
            st.setString(2, email);
            ResultSet rs = st.executeQuery();

            return rs.next();
        }
    }

    /**
     * Đếm tổng số user
     */
    public int getTotalUsers() throws Exception {
        String sql = "SELECT COUNT(*) FROM users WHERE role = 'customer'";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }
        }

        return 0;
    }

    /**
     * Đếm user mới hôm nay
     */
    public int getTodayNewUsers() throws Exception {
        String sql = "SELECT COUNT(*) FROM users WHERE DATE(created_at) = CURDATE()";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }
        }

        return 0;
    }

    /**
     * Đếm tổng số admin
     */
    public int getTotalAdmins() throws Exception {
        String sql = "SELECT COUNT(*) FROM users WHERE role = 'admin'";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }
        }

        return 0;
    }

    /**
     * Lấy top khách hàng
     */
    public List<Map<String, Object>> getTopCustomers(int limit) throws Exception {
        String sql = """
            SELECT 
                u.id,
                u.full_name,
                u.email,
                u.phone,
                COUNT(o.id) as total_orders,
                COALESCE(SUM(o.final_amount), 0) as total_spent
            FROM users u
            INNER JOIN orders o ON u.id = o.user_id
            WHERE u.role = 'customer' AND o.status != 'Cancelled'
            GROUP BY u.id, u.full_name, u.email, u.phone
            ORDER BY total_spent DESC
            LIMIT ?
        """;

        List<Map<String, Object>> customers = new ArrayList<>();

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, limit);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                Map<String, Object> customer = new HashMap<>();
                customer.put("id", rs.getInt("id"));
                customer.put("fullName", rs.getString("full_name"));
                customer.put("email", rs.getString("email"));
                customer.put("phone", rs.getString("phone"));
                customer.put("totalOrders", rs.getInt("total_orders"));
                customer.put("totalSpent", rs.getBigDecimal("total_spent"));

                customers.add(customer);
            }
        }

        return customers;
    }

    /**
     * Map ResultSet sang User
     */
    private User mapUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setEmail(rs.getString("email"));
        user.setFullname(rs.getString("full_name"));
        user.setPhone(rs.getString("phone"));
        user.setAddress(rs.getString("address"));
        user.setRole(rs.getString("role"));
        user.setStatus(rs.getString("status"));
        user.setAvatar(rs.getString("avatar"));
        user.setLastLogin(rs.getTimestamp("last_login"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        user.setUpdatedAt(rs.getTimestamp("updated_at"));
        return user;
    }

    /**
     * Số lượng khách hàng mới
     */
    public int getNewCustomersCount(LocalDate startDate, LocalDate endDate) throws Exception {
        String sql = """
        SELECT COUNT(*) AS total
        FROM users
        WHERE role = 'customer'
        AND DATE(created_at) BETWEEN ? AND ?
    """;

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setDate(1, Date.valueOf(startDate));
            st.setDate(2, Date.valueOf(endDate));

            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        }
        return 0;
    }
}
