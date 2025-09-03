package Dal;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {
    protected Connection connection;

    public DBContext() {
        try {
            // Thông tin kết nối MySQL
            String url = "jdbc:mysql://localhost:3306/webquanaoD?useSSL=false&serverTimezone=UTC";
            String username = "root";       // thay bằng user MySQL của bạn
            String password = "";     // thay bằng mật khẩu MySQL của bạn

            // Load MySQL JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Tạo kết nối
            connection = DriverManager.getConnection(url, username, password);
            System.out.println("✅ Kết nối MySQL thành công!");
        } catch (ClassNotFoundException | SQLException ex) {
            System.out.println("❌ Lỗi kết nối MySQL: " + ex.getMessage());
        }
    }
}
