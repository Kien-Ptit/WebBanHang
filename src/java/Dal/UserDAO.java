// Đổi package cho đúng với dự án của bạn
package Dal;

import Model.User;
import java.sql.*;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

public class UserDAO extends DBContext {

    // Map 1 row -> User
    private User map(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getInt("id"));
        u.setUsername(rs.getString("username"));
        u.setPassword(rs.getString("password"));
        u.setEmail(rs.getString("email"));
        u.setFullname(rs.getString("full_name"));
        u.setPhone(rs.getString("phone"));
        u.setAddress(rs.getString("address"));
        u.setRole(rs.getString("role"));
        u.setStatus(rs.getString("status"));
        u.setAvatar(rs.getString("avatar"));
        Timestamp ll = rs.getTimestamp("last_login");
        u.setLastLogin(ll);
        return u;
    }

    // Kiểm tra trùng username/email
    public boolean checkUserExists(String username, String email) throws Exception {
        String sql = "SELECT id FROM users WHERE username = ? OR email = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, username);
            st.setString(2, email);
            try (ResultSet rs = st.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Đăng ký
    public int insert(User u) throws Exception {
        String sql = "INSERT INTO users (username, password, email, full_name, phone, address, role, status, avatar) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, u.getUsername());
            st.setString(2, u.getPassword()); // TODO: nếu muốn, mã hoá tại đây (BCrypt)
            st.setString(3, u.getEmail());
            st.setString(4, u.getFullname());
            st.setString(5, u.getPhone());
            st.setString(6, u.getAddress());
            st.setString(7, u.getRole() == null ? "customer" : u.getRole());
            st.setString(8, u.getStatus() == null ? "active" : u.getStatus());
            st.setString(9, u.getAvatar());
            st.executeUpdate();
            try (ResultSet rs = st.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
                return 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Đăng nhập (username hoặc email) + trạng thái active
    public User login(String usernameOrEmail, String password) throws Exception {
        String sql = "SELECT * FROM users WHERE (username = ? OR email = ?) AND password = ? AND status = 'active'";

        // THÊM LOG DEBUG
        System.out.println("DEBUG SQL: " + sql);
        System.out.println("DEBUG Params: [" + usernameOrEmail + "], [" + password + "]");

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, usernameOrEmail);
            st.setString(2, usernameOrEmail);
            st.setString(3, password);

            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    System.out.println("DEBUG - User found in DB");
                    return map(rs);
                }
                System.out.println("DEBUG - No user found in DB");
                return null;
            }
        } catch (Exception e) {
            System.out.println("DEBUG - Exception in login: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    // Cập nhật last_login
    public void updateLastLogin(int userId) throws Exception {
        String sql = "UPDATE users SET last_login = ? WHERE id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setTimestamp(1, Timestamp.from(Instant.now()));
            st.setInt(2, userId);
            st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Tìm user theo id (tuỳ chọn)
    public User findById(int id) throws Exception {
        String sql = "SELECT * FROM users WHERE id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            try (ResultSet rs = st.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateProfile(Model.User u) throws SQLException {
        String sql = "UPDATE users SET full_name=?, email=?, phone=?, address=?, avatar=? WHERE id=?";

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, u.getFullname());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getPhone());
            ps.setString(4, u.getAddress());
            ps.setString(5, u.getAvatar());
            ps.setInt(6, u.getId());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean changePassword(int userId, String currentPlain, String nextPlain) throws SQLException {
        String check = "SELECT password FROM users WHERE id=?";
        String update = "UPDATE users SET password=? WHERE id=?";
        try (Connection con = getConnection(); PreparedStatement ps1 = con.prepareStatement(check)) {
            ps1.setInt(1, userId);
            try (ResultSet rs = ps1.executeQuery()) {
                if (!rs.next()) {
                    return false;
                }
                String curInDb = rs.getString(1);
                if (curInDb == null || !curInDb.equals(currentPlain)) {
                    return false; // sai mật khẩu hiện tại
                }
            }
            try (PreparedStatement ps2 = con.prepareStatement(update)) {
                ps2.setString(1, nextPlain);
                ps2.setInt(2, userId);
                return ps2.executeUpdate() > 0;
            }
        }
    }
    // ==================== ADMIN METHODS - FIXED ====================

    /**
     * Đếm tổng số người dùng (role = customer)
     */
    public int getTotalUsersCount() throws Exception {
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
    public int getTodayNewUsersCount() throws Exception {
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
    public int getTotalAdminsCount() throws Exception {
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
     * Lấy tất cả người dùng - FIXED
     */
    public List<User> getAllUsersForAdmin() throws Exception {
        String sql = "SELECT * FROM users ORDER BY created_at DESC";

        List<User> users = new ArrayList<>();

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setFullname(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setAddress(rs.getString("address"));
                user.setRole(rs.getString("role"));
                user.setStatus(rs.getString("status"));
                user.setAvatar(rs.getString("avatar"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                user.setUpdatedAt(rs.getTimestamp("updated_at"));

                users.add(user);
            }
        }

        return users;
    }

    /**
     * Tìm kiếm người dùng - FIXED
     */
    public List<User> searchUsersForAdmin(String keyword) throws Exception {
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
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setFullname(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setRole(rs.getString("role"));
                user.setStatus(rs.getString("status"));
                user.setCreatedAt(rs.getTimestamp("created_at"));

                users.add(user);
            }
        }

        return users;
    }

    /**
     * Lấy người dùng theo vai trò - FIXED
     */
    public List<User> getUsersByRoleForAdmin(String role) throws Exception {
        String sql = "SELECT * FROM users WHERE role = ? ORDER BY created_at DESC";

        List<User> users = new ArrayList<>();

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, role);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setFullname(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setRole(rs.getString("role"));
                user.setStatus(rs.getString("status"));
                user.setCreatedAt(rs.getTimestamp("created_at"));

                users.add(user);
            }
        }

        return users;
    }

    /**
     * Tạo người dùng mới - FIXED
     */
    public boolean createUserByAdmin(User user) throws Exception {
        String sql = """
        INSERT INTO users (username, password, full_name, email, phone, role, status, created_at) 
        VALUES (?, ?, ?, ?, ?, ?, ?, NOW())
    """;

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, user.getUsername());
            st.setString(2, user.getPassword()); // Hash password trước khi gọi
            st.setString(3, user.getFullname());
            st.setString(4, user.getEmail());
            st.setString(5, user.getPhone());
            st.setString(6, user.getRole());
            st.setString(7, user.getStatus() != null ? user.getStatus() : "active");

            return st.executeUpdate() > 0;
        }
    }

    /**
     * Cập nhật thông tin người dùng - FIXED
     */
    public boolean updateUserByAdmin(User user) throws Exception {
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
     * Xóa người dùng - FIXED
     */
    public boolean deleteUserByAdmin(int id) throws Exception {
        String sql = "DELETE FROM users WHERE id = ?";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, id);
            return st.executeUpdate() > 0;
        }
    }

    /**
     * Bật/Tắt trạng thái người dùng - FIXED
     */
    public boolean toggleUserStatusByAdmin(int id) throws Exception {
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
}
