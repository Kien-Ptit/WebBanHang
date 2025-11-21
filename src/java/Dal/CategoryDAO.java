package Dal;

import Model.Category;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO cho Categories - User Side
 * Khớp 100% với database: webquanao
 * 
 * @author Kien-Ptit
 * @version 2.0
 * @since 2025-10-25
 */
public class CategoryDAO extends DBContext {

    /**
     * Lấy tất cả danh mục
     */
    public List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT id, name, description, created_at FROM categories ORDER BY name";
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            
            while (rs.next()) {
                Category category = new Category();
                category.setId(rs.getInt("id"));
                category.setName(rs.getString("name"));
                category.setDescription(rs.getString("description"));
                category.setCreatedAt(rs.getTimestamp("created_at"));
                category.setActive(true); // Mặc định active vì không có field
                categories.add(category);
            }
        } catch (SQLException e) {
            System.out.println("Error in getAllCategories: " + e.getMessage());
            e.printStackTrace();
        }
        
        return categories;
    }

    /**
     * Lấy danh mục chính (tất cả đều là danh mục chính vì không có parent_id)
     */
    public List<Category> getMainCategories() {
        // Database không có parent_id nên tất cả đều là main categories
        return getAllCategories();
    }

    /**
     * Lấy danh mục theo ID
     */
    public Category getCategoryById(int id) {
        String sql = "SELECT id, name, description, created_at FROM categories WHERE id = ?";
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            
            if (rs.next()) {
                Category category = new Category();
                category.setId(rs.getInt("id"));
                category.setName(rs.getString("name"));
                category.setDescription(rs.getString("description"));
                category.setCreatedAt(rs.getTimestamp("created_at"));
                category.setActive(true);
                return category;
            }
        } catch (SQLException e) {
            System.out.println("Error in getCategoryById: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }

    /**
     * Lấy danh mục theo slug (không có slug nên tìm theo name)
     */
    public Category getCategoryBySlug(String slug) {
        // Database không có slug, có thể tìm theo name hoặc bỏ qua
        String sql = "SELECT id, name, description, created_at FROM categories WHERE name LIKE ?";
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, "%" + slug + "%");
            ResultSet rs = st.executeQuery();
            
            if (rs.next()) {
                Category category = new Category();
                category.setId(rs.getInt("id"));
                category.setName(rs.getString("name"));
                category.setDescription(rs.getString("description"));
                category.setCreatedAt(rs.getTimestamp("created_at"));
                category.setActive(true);
                return category;
            }
        } catch (SQLException e) {
            System.out.println("Error in getCategoryBySlug: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }

    /**
     * Lấy danh mục theo tên
     */
    public Category getCategoryByName(String name) {
        String sql = "SELECT id, name, description, created_at FROM categories WHERE name = ?";
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, name);
            ResultSet rs = st.executeQuery();
            
            if (rs.next()) {
                Category category = new Category();
                category.setId(rs.getInt("id"));
                category.setName(rs.getString("name"));
                category.setDescription(rs.getString("description"));
                category.setCreatedAt(rs.getTimestamp("created_at"));
                category.setActive(true);
                return category;
            }
        } catch (SQLException e) {
            System.out.println("Error in getCategoryByName: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }

    /**
     * Đếm số lượng sản phẩm trong category
     */
    public int getProductCount(int categoryId) {
        String sql = "SELECT COUNT(*) FROM products WHERE category_id = ? AND status = 'active'";
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, categoryId);
            ResultSet rs = st.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error in getProductCount: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }

    /**
     * Lấy tất cả categories với số lượng sản phẩm
     */
    public List<Category> getCategoriesWithProductCount() {
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
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            
            while (rs.next()) {
                Category category = new Category();
                category.setId(rs.getInt("id"));
                category.setName(rs.getString("name"));
                category.setDescription(rs.getString("description"));
                category.setCreatedAt(rs.getTimestamp("created_at"));
                category.setActive(true);
                category.setProductCount(rs.getInt("product_count"));
                categories.add(category);
            }
        } catch (SQLException e) {
            System.out.println("Error in getCategoriesWithProductCount: " + e.getMessage());
            e.printStackTrace();
        }
        
        return categories;
    }
}