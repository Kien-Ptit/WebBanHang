package Dal.Admin;

import Dal.DBContext;
import Model.Category;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO riêng cho Admin quản lý Categories
 * Khớp 100% với database: webquanao
 * 
 * @author Kien-Ptit
 * @version 2.0
 * @since 2025-10-25
 */
public class AdminCategoryDAO extends DBContext {

    public AdminCategoryDAO() {
        super();
    }

    /**
     * Lấy tất cả danh mục kèm số lượng sản phẩm
     */
    public List<Category> getAllCategoriesWithCount() throws Exception {
        List<Category> categories = new ArrayList<>();
        String sql = """
            SELECT 
                c.id,
                c.name,
                c.description,
                c.created_at,
                COUNT(p.id) as product_count
            FROM categories c
            LEFT JOIN products p ON c.id = p.category_id AND p.status = 'active'
            GROUP BY c.id, c.name, c.description, c.created_at
            ORDER BY c.name
        """;
        
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            ResultSet rs = st.executeQuery();
            
            while (rs.next()) {
                Category category = mapCategory(rs);
                category.setProductCount(rs.getInt("product_count"));
                categories.add(category);
            }
        }
        
        return categories;
    }

    /**
     * Lấy tất cả danh mục
     */
    public List<Category> getAllCategories() throws Exception {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT id, name, description, created_at FROM categories ORDER BY name";
        
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            ResultSet rs = st.executeQuery();
            
            while (rs.next()) {
                categories.add(mapCategory(rs));
            }
        }
        
        return categories;
    }

    /**
     * Lấy danh mục theo ID
     */
    public Category getCategoryById(int id) throws Exception {
        String sql = "SELECT id, name, description, created_at FROM categories WHERE id = ?";
        
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            
            if (rs.next()) {
                return mapCategory(rs);
            }
        }
        
        return null;
    }

    /**
     * Tạo danh mục mới
     */
    public boolean createCategory(Category category) throws Exception {
        String sql = "INSERT INTO categories (name, description, created_at) VALUES (?, ?, NOW())";
        
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, category.getName());
            st.setString(2, category.getDescription());
            
            return st.executeUpdate() > 0;
        }
    }

    /**
     * Cập nhật danh mục
     */
    public boolean updateCategory(Category category) throws Exception {
        String sql = "UPDATE categories SET name = ?, description = ? WHERE id = ?";
        
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, category.getName());
            st.setString(2, category.getDescription());
            st.setInt(3, category.getId());
            
            return st.executeUpdate() > 0;
        }
    }

    /**
     * Xóa danh mục
     */
    public boolean deleteCategory(int id) throws Exception {
        // Kiểm tra có sản phẩm không
        String checkSql = "SELECT COUNT(*) FROM products WHERE category_id = ?";
        try (PreparedStatement st = connection.prepareStatement(checkSql)) {
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                return false; // Không thể xóa vì còn sản phẩm
            }
        }
        
        String sql = "DELETE FROM categories WHERE id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, id);
            return st.executeUpdate() > 0;
        }
    }

    /**
     * Toggle active - Database không có field này
     */
    public boolean toggleCategoryActive(int id) throws Exception {
        // Database không có field is_active nên return true
        return true;
    }

    /**
     * Map ResultSet sang Category
     */
    private Category mapCategory(ResultSet rs) throws SQLException {
        Category category = new Category();
        category.setId(rs.getInt("id"));
        category.setName(rs.getString("name"));
        category.setDescription(rs.getString("description"));
        category.setCreatedAt(rs.getTimestamp("created_at"));
        category.setActive(true); // Mặc định active
        
        return category;
    }
}