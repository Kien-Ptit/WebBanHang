package Dal;

import Model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO extends DBContext {

    // Authenticate user by username/email and password
    public User authenticate(String usernameOrEmail, String password) {
        String sql = "SELECT * FROM users WHERE (username = ? OR email = ?) AND password = ? AND status = 'active'";
        
        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setString(1, usernameOrEmail);
            stmt.setString(2, usernameOrEmail);
            stmt.setString(3, password);
            
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                User user = mapResultSetToUser(rs);
                updateLastLogin(user.getId());
                return user;
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Error in authenticate: " + e.getMessage());
            System.err.println("📅 Time: " + java.time.LocalDateTime.now());
            System.err.println("👤 User: Kien-Ptit");
            e.printStackTrace();
        }
        
        return null;
    }

    // Get user by ID
    public User getUserById(int userId) {
        String sql = "SELECT * FROM users WHERE id = ?";
        
        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Error in getUserById: " + e.getMessage());
            System.err.println("📅 Time: " + java.time.LocalDateTime.now());
            e.printStackTrace();
        }
        
        return null;
    }

    // Get user by username
    public User getUserByUsername(String username) {
        String sql = "SELECT * FROM users WHERE username = ?";
        
        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Error in getUserByUsername: " + e.getMessage());
            System.err.println("📅 Time: " + java.time.LocalDateTime.now());
            e.printStackTrace();
        }
        
        return null;
    }

    // Get user by email
    public User getUserByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        
        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Error in getUserByEmail: " + e.getMessage());
            System.err.println("📅 Time: " + java.time.LocalDateTime.now());
            e.printStackTrace();
        }
        
        return null;
    }

    // Create new user
    public boolean createUser(User user) {
        String sql = "INSERT INTO users (username, email, password, first_name, last_name, phone, role, status, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())";
        
        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPassword());
            stmt.setString(4, user.getFirstName());
            stmt.setString(5, user.getLastName());
            stmt.setString(6, user.getPhone());
            stmt.setString(7, user.getRole());
            stmt.setString(8, user.getStatus());
            
            int result = stmt.executeUpdate();
            if (result > 0) {
                System.out.println("✅ User created successfully: " + user.getUsername());
                System.out.println("📅 Time: " + java.time.LocalDateTime.now());
                System.out.println("👤 Created by: Kien-Ptit");
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Error in createUser: " + e.getMessage());
            System.err.println("📅 Time: " + java.time.LocalDateTime.now());
            System.err.println("👤 User: Kien-Ptit");
            e.printStackTrace();
        }
        
        return false;
    }

    // Update user
    public boolean updateUser(User user) {
        String sql = "UPDATE users SET email = ?, first_name = ?, last_name = ?, phone = ?, role = ?, status = ?, updated_at = NOW() WHERE id = ?";
        
        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setString(1, user.getEmail());
            stmt.setString(2, user.getFirstName());
            stmt.setString(3, user.getLastName());
            stmt.setString(4, user.getPhone());
            stmt.setString(5, user.getRole());
            stmt.setString(6, user.getStatus());
            stmt.setInt(7, user.getId());
            
            int result = stmt.executeUpdate();
            if (result > 0) {
                System.out.println("✅ User updated successfully: " + user.getUsername());
                System.out.println("📅 Time: " + java.time.LocalDateTime.now());
                System.out.println("👤 Updated by: Kien-Ptit");
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Error in updateUser: " + e.getMessage());
            System.err.println("📅 Time: " + java.time.LocalDateTime.now());
            e.printStackTrace();
        }
        
        return false;
    }

    // Update password
    public boolean updatePassword(int userId, String newPassword) {
        String sql = "UPDATE users SET password = ?, updated_at = NOW() WHERE id = ?";
        
        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setString(1, newPassword);
            stmt.setInt(2, userId);
            
            int result = stmt.executeUpdate();
            if (result > 0) {
                System.out.println("✅ Password updated successfully for user ID: " + userId);
                System.out.println("📅 Time: " + java.time.LocalDateTime.now());
                System.out.println("👤 Updated by: Kien-Ptit");
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Error in updatePassword: " + e.getMessage());
            System.err.println("📅 Time: " + java.time.LocalDateTime.now());
            e.printStackTrace();
        }
        
        return false;
    }

    // Update last login
    public boolean updateLastLogin(int userId) {
        String sql = "UPDATE users SET last_login = NOW(), updated_at = NOW() WHERE id = ?";
        
        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setInt(1, userId);
            
            int result = stmt.executeUpdate();
            if (result > 0) {
                System.out.println("✅ Last login updated for user ID: " + userId);
                System.out.println("📅 Time: " + java.time.LocalDateTime.now());
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Error in updateLastLogin: " + e.getMessage());
            System.err.println("📅 Time: " + java.time.LocalDateTime.now());
            e.printStackTrace();
        }
        
        return false;
    }

    // Get all users
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY created_at DESC";
        
        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
            
            System.out.println("✅ Retrieved " + users.size() + " users from database");
            System.out.println("📅 Time: " + java.time.LocalDateTime.now());
            System.out.println("👤 Requested by: Kien-Ptit");
            
        } catch (SQLException e) {
            System.err.println("❌ Error in getAllUsers: " + e.getMessage());
            System.err.println("📅 Time: " + java.time.LocalDateTime.now());
            e.printStackTrace();
        }
        
        return users;
    }

    // Get users by role
    public List<User> getUsersByRole(String role) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role = ? AND status = 'active' ORDER BY created_at DESC";
        
        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setString(1, role);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
            
            System.out.println("✅ Retrieved " + users.size() + " users with role: " + role);
            System.out.println("📅 Time: " + java.time.LocalDateTime.now());
            
        } catch (SQLException e) {
            System.err.println("❌ Error in getUsersByRole: " + e.getMessage());
            System.err.println("📅 Time: " + java.time.LocalDateTime.now());
            e.printStackTrace();
        }
        
        return users;
    }

    // Check if username exists
    public boolean isUsernameExists(String username) {
        String sql = "SELECT COUNT(*) FROM users WHERE username = ?";
        
        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Error in isUsernameExists: " + e.getMessage());
            System.err.println("📅 Time: " + java.time.LocalDateTime.now());
            e.printStackTrace();
        }
        
        return false;
    }

    // Check if email exists
    public boolean isEmailExists(String email) {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";
        
        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Error in isEmailExists: " + e.getMessage());
            System.err.println("📅 Time: " + java.time.LocalDateTime.now());
            e.printStackTrace();
        }
        
        return false;
    }

    // Delete user (soft delete - change status to inactive)
    public boolean deleteUser(int userId) {
        String sql = "UPDATE users SET status = 'inactive', updated_at = NOW() WHERE id = ?";
        
        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setInt(1, userId);
            
            int result = stmt.executeUpdate();
            if (result > 0) {
                System.out.println("✅ User soft deleted (status = inactive) for ID: " + userId);
                System.out.println("📅 Time: " + java.time.LocalDateTime.now());
                System.out.println("👤 Deleted by: Kien-Ptit");
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Error in deleteUser: " + e.getMessage());
            System.err.println("📅 Time: " + java.time.LocalDateTime.now());
            e.printStackTrace();
        }
        
        return false;
    }

    // Hard delete user (permanent deletion)
    public boolean hardDeleteUser(int userId) {
        String sql = "DELETE FROM users WHERE id = ?";
        
        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setInt(1, userId);
            
            int result = stmt.executeUpdate();
            if (result > 0) {
                System.out.println("⚠️ User permanently deleted from database for ID: " + userId);
                System.out.println("📅 Time: " + java.time.LocalDateTime.now());
                System.out.println("👤 Deleted by: Kien-Ptit");
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Error in hardDeleteUser: " + e.getMessage());
            System.err.println("📅 Time: " + java.time.LocalDateTime.now());
            e.printStackTrace();
        }
        
        return false;
    }

    // Search users by keyword
    public List<User> searchUsers(String keyword) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE (username LIKE ? OR email LIKE ? OR first_name LIKE ? OR last_name LIKE ?) AND status = 'active' ORDER BY created_at DESC";
        
        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            String searchTerm = "%" + keyword + "%";
            stmt.setString(1, searchTerm);
            stmt.setString(2, searchTerm);
            stmt.setString(3, searchTerm);
            stmt.setString(4, searchTerm);
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
            
            System.out.println("🔍 Search completed for keyword: '" + keyword + "' - Found " + users.size() + " users");
            System.out.println("📅 Time: " + java.time.LocalDateTime.now());
            System.out.println("👤 Searched by: Kien-Ptit");
            
        } catch (SQLException e) {
            System.err.println("❌ Error in searchUsers: " + e.getMessage());
            System.err.println("📅 Time: " + java.time.LocalDateTime.now());
            e.printStackTrace();
        }
        
        return users;
    }

    // Test connection
    public boolean testConnection() {
        try {
            if (connection != null && !connection.isClosed()) {
                // Test with a simple query
                PreparedStatement stmt = connection.prepareStatement("SELECT 1");
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    System.out.println("✅ Database connection test successful");
                    System.out.println("📅 Time: " + java.time.LocalDateTime.now());
                    System.out.println("👤 Tested by: Kien-Ptit");
                    return true;
                }
            }
        } catch (SQLException e) {
            System.err.println("❌ Connection test failed: " + e.getMessage());
            System.err.println("📅 Time: " + java.time.LocalDateTime.now());
            e.printStackTrace();
        }
        
        return false;
    }

    // Get user count by status
    public int getUserCountByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM users WHERE status = ?";
        
        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setString(1, status);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                int count = rs.getInt(1);
                System.out.println("📊 User count for status '" + status + "': " + count);
                System.out.println("📅 Time: " + java.time.LocalDateTime.now());
                return count;
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Error in getUserCountByStatus: " + e.getMessage());
            System.err.println("📅 Time: " + java.time.LocalDateTime.now());
            e.printStackTrace();
        }
        
        return 0;
    }

    // Helper method to map ResultSet to User object
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        
        try {
            user.setId(rs.getInt("id"));
            user.setUsername(rs.getString("username"));
            user.setEmail(rs.getString("email"));
            user.setPassword(rs.getString("password"));
            user.setFirstName(rs.getString("first_name"));
            user.setLastName(rs.getString("last_name"));
            user.setPhone(rs.getString("phone"));
            user.setRole(rs.getString("role"));
            user.setStatus(rs.getString("status"));
            
            // Set optional fields if they exist
            if (hasColumn(rs, "last_login")) {
                user.setLastLogin(rs.getTimestamp("last_login"));
            }
            if (hasColumn(rs, "created_at")) {
                user.setCreatedAt(rs.getTimestamp("created_at"));
            }
            if (hasColumn(rs, "updated_at")) {
                user.setUpdatedAt(rs.getTimestamp("updated_at"));
            }
            
        } catch (Exception e) {
            System.err.println("❌ Error mapping ResultSet to User: " + e.getMessage());
            System.err.println("📅 Time: " + java.time.LocalDateTime.now());
            e.printStackTrace();
        }
        
        return user;
    }

    // Helper method to check if column exists in ResultSet
    private boolean hasColumn(ResultSet rs, String columnName) {
        try {
            rs.getObject(columnName);
            return true;
        } catch (SQLException e) {
            return false;
        }
    }
}