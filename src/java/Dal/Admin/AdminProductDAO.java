package Dal.Admin;

import Dal.DBContext;
import Model.Product;
import Model.Category;
import java.sql.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * DAO riêng cho Admin quản lý Products Khớp 100% với database: webquanao
 *
 * @author Kien-Ptit
 * @version 2.0
 * @since 2025-10-25
 */
public class AdminProductDAO extends DBContext {

    public AdminProductDAO() {
        super();
    }

    /**
     * Lấy tất cả sản phẩm
     */
    public List<Product> getAllProducts() throws Exception {
        String sql = """
            SELECT 
                p.id,
                p.name,
                p.description,
                p.price,
                p.discount_price,
                p.image_url,
                p.category_id,
                p.stock_quantity,
                p.size,
                p.color,
                p.material,
                p.brand,
                p.status,
                p.featured,
                p.views,
                p.created_at,
                p.updated_at,
                c.name as category_name
            FROM products p
            LEFT JOIN categories c ON p.category_id = c.id
            ORDER BY p.created_at DESC
        """;

        List<Product> products = new ArrayList<>();

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                products.add(mapProduct(rs));
            }
        }

        return products;
    }

    /**
     * Tìm sản phẩm theo ID
     */
    public Product getProductById(int id) throws Exception {
        String sql = """
            SELECT 
                p.*,
                c.name as category_name
            FROM products p
            LEFT JOIN categories c ON p.category_id = c.id
            WHERE p.id = ?
        """;

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                return mapProduct(rs);
            }
        }

        return null;
    }

    /**
     * Tạo sản phẩm mới
     */
    public int createProduct(Product product) throws Exception {
        String sql = """
            INSERT INTO products (
                name, description, price, discount_price, image_url,
                category_id, stock_quantity, size, color, material,
                brand, status, featured, views, created_at, updated_at
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 0, NOW(), NOW())
        """;

        try (PreparedStatement st = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            st.setString(1, product.getName());
            st.setString(2, product.getDescription());
            st.setBigDecimal(3, product.getPrice());

            if (product.getDiscountPrice() != null) {
                st.setBigDecimal(4, product.getDiscountPrice());
            } else {
                st.setNull(4, Types.DECIMAL);
            }

            st.setString(5, product.getImageUrl());
            st.setInt(6, product.getCategoryId());
            st.setInt(7, product.getStockQuantity());
            st.setString(8, product.getSize());
            st.setString(9, product.getColor());
            st.setString(10, product.getMaterial());
            st.setString(11, product.getBrand());
            st.setString(12, product.getStatus() != null ? product.getStatus() : "active");
            st.setBoolean(13, product.isFeatured());

            int affectedRows = st.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet generatedKeys = st.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1);
                    }
                }
            }
        }

        return 0;
    }

    /**
     * Cập nhật sản phẩm
     */
    public boolean updateProduct(Product product) throws Exception {
        String sql = """
            UPDATE products SET
                name = ?,
                description = ?,
                price = ?,
                discount_price = ?,
                image_url = ?,
                category_id = ?,
                stock_quantity = ?,
                size = ?,
                color = ?,
                material = ?,
                brand = ?,
                status = ?,
                featured = ?,
                updated_at = NOW()
            WHERE id = ?
        """;

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, product.getName());
            st.setString(2, product.getDescription());
            st.setBigDecimal(3, product.getPrice());

            if (product.getDiscountPrice() != null) {
                st.setBigDecimal(4, product.getDiscountPrice());
            } else {
                st.setNull(4, Types.DECIMAL);
            }

            st.setString(5, product.getImageUrl());
            st.setInt(6, product.getCategoryId());
            st.setInt(7, product.getStockQuantity());
            st.setString(8, product.getSize());
            st.setString(9, product.getColor());
            st.setString(10, product.getMaterial());
            st.setString(11, product.getBrand());
            st.setString(12, product.getStatus());
            st.setBoolean(13, product.isFeatured());
            st.setInt(14, product.getId());

            return st.executeUpdate() > 0;
        }
    }

    /**
     * Xóa sản phẩm (soft delete)
     */
    public boolean deleteProduct(int id) throws Exception {
        String sql = "UPDATE products SET status = 'inactive', updated_at = NOW() WHERE id = ?";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, id);
            return st.executeUpdate() > 0;
        }
    }

    /**
     * Xóa vĩnh viễn
     */
    public boolean deleteProductPermanently(int id) throws Exception {
        String sql = "DELETE FROM products WHERE id = ?";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, id);
            return st.executeUpdate() > 0;
        }
    }

    /**
     * Tìm kiếm sản phẩm
     */
    public List<Product> searchProducts(String keyword) throws Exception {
        String sql = """
            SELECT p.*, c.name as category_name
            FROM products p
            LEFT JOIN categories c ON p.category_id = c.id
            WHERE p.name LIKE ? 
               OR p.description LIKE ?
               OR p.brand LIKE ?
            ORDER BY p.created_at DESC
        """;

        List<Product> products = new ArrayList<>();

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            String searchPattern = "%" + keyword + "%";
            st.setString(1, searchPattern);
            st.setString(2, searchPattern);
            st.setString(3, searchPattern);

            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                products.add(mapProduct(rs));
            }
        }

        return products;
    }

    /**
     * Lọc theo category
     */
    public List<Product> getProductsByCategory(int categoryId) throws Exception {
        String sql = """
            SELECT p.*, c.name as category_name
            FROM products p
            LEFT JOIN categories c ON p.category_id = c.id
            WHERE p.category_id = ?
            ORDER BY p.created_at DESC
        """;

        List<Product> products = new ArrayList<>();

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, categoryId);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                products.add(mapProduct(rs));
            }
        }

        return products;
    }

    /**
     * Lọc theo status
     */
    public List<Product> getProductsByStatus(String status) throws Exception {
        String sql = """
            SELECT p.*, c.name as category_name
            FROM products p
            LEFT JOIN categories c ON p.category_id = c.id
            WHERE p.status = ?
            ORDER BY p.created_at DESC
        """;

        List<Product> products = new ArrayList<>();

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, status);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                products.add(mapProduct(rs));
            }
        }

        return products;
    }

    /**
     * Lấy sản phẩm sắp hết hàng
     */
    public List<Product> getLowStockProducts() throws Exception {
        String sql = """
            SELECT p.*, c.name as category_name
            FROM products p
            LEFT JOIN categories c ON p.category_id = c.id
            WHERE p.stock_quantity <= 10
              AND p.status = 'active'
            ORDER BY p.stock_quantity ASC
        """;

        List<Product> products = new ArrayList<>();

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                products.add(mapProduct(rs));
            }
        }

        return products;
    }

    /**
     * Cập nhật tồn kho
     */
    public boolean updateStock(int productId, int quantity) throws Exception {
        String sql = "UPDATE products SET stock_quantity = ?, updated_at = NOW() WHERE id = ?";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, quantity);
            st.setInt(2, productId);
            return st.executeUpdate() > 0;
        }
    }

    /**
     * Toggle featured
     */
    public boolean toggleFeatured(int productId) throws Exception {
        String sql = "UPDATE products SET featured = NOT featured, updated_at = NOW() WHERE id = ?";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, productId);
            return st.executeUpdate() > 0;
        }
    }

    /**
     * Đếm tổng sản phẩm
     */
    public int getTotalProducts() throws Exception {
        String sql = "SELECT COUNT(*) FROM products";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }
        }

        return 0;
    }

    public int getActiveProducts() throws Exception {
        String sql = "SELECT COUNT(*) FROM products WHERE status = 'active'";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }
        }

        return 0;
    }

    /**
     * Sản phẩm bán chạy
     */
    public List<Map<String, Object>> getBestSellingProducts(int limit) throws Exception {
        String sql = """
            SELECT 
                p.id,
                p.name,
                p.image_url,
                p.price,
                p.discount_price,
                c.name as category_name,
                COALESCE(SUM(od.quantity), 0) as sold_count,
                COALESCE(SUM(od.quantity * od.price), 0) as revenue
            FROM products p
            LEFT JOIN order_detail od ON p.id = od.product_id
            LEFT JOIN orders o ON od.order_id = o.id
            LEFT JOIN categories c ON p.category_id = c.id
            WHERE p.status = 'active' 
              AND (o.status IS NULL OR o.status != 'Cancelled')
            GROUP BY p.id, p.name, p.image_url, p.price, p.discount_price, c.name
            ORDER BY sold_count DESC
            LIMIT ?
        """;

        List<Map<String, Object>> products = new ArrayList<>();

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, limit);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                Map<String, Object> product = new HashMap<>();
                product.put("id", rs.getInt("id"));
                product.put("name", rs.getString("name"));
                product.put("imageUrl", rs.getString("image_url"));
                product.put("price", rs.getBigDecimal("price"));
                product.put("salePrice", rs.getBigDecimal("discount_price"));
                product.put("categoryName", rs.getString("category_name"));
                product.put("soldCount", rs.getInt("sold_count"));
                product.put("revenue", rs.getBigDecimal("revenue"));

                products.add(product);
            }
        }

        return products;
    }

    /**
     * Map ResultSet sang Product
     */
    private Product mapProduct(ResultSet rs) throws SQLException {
        Product product = new Product();

        product.setId(rs.getInt("id"));
        product.setName(rs.getString("name"));
        product.setDescription(rs.getString("description"));
        product.setPrice(rs.getBigDecimal("price"));

        BigDecimal discountPrice = rs.getBigDecimal("discount_price");
        if (!rs.wasNull()) {
            product.setDiscountPrice(discountPrice);
        }

        product.setImageUrl(rs.getString("image_url"));
        product.setCategoryId(rs.getInt("category_id"));
        product.setStockQuantity(rs.getInt("stock_quantity"));
        product.setSize(rs.getString("size"));
        product.setColor(rs.getString("color"));
        product.setMaterial(rs.getString("material"));
        product.setBrand(rs.getString("brand"));
        product.setStatus(rs.getString("status"));
        product.setFeatured(rs.getBoolean("featured"));
        product.setViews(rs.getInt("views"));
        product.setCreatedAt(rs.getTimestamp("created_at"));
        product.setUpdatedAt(rs.getTimestamp("updated_at"));

        // Set category
        String categoryName = rs.getString("category_name");
        if (categoryName != null) {
            Category cat = new Category();
            cat.setId(rs.getInt("category_id"));
            cat.setName(categoryName);
            product.setCategory(cat);
            product.setCategoryName(categoryName);
        }

        return product;
    }

    public boolean toggleStatus(int productId) throws Exception {
        // Get current status
        String getCurrentStatusSql = "SELECT status FROM products WHERE id = ?";
        String currentStatus = null;

        try (PreparedStatement stmt = connection.prepareStatement(getCurrentStatusSql)) {
            stmt.setInt(1, productId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    currentStatus = rs.getString("status");
                }
            }
        }

        if (currentStatus == null) {
            return false;
        }

        // Toggle status
        String newStatus = "active".equals(currentStatus) ? "inactive" : "active";

        String updateSql = "UPDATE products SET status = ?, updated_at = NOW() WHERE id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(updateSql)) {
            stmt.setString(1, newStatus);
            stmt.setInt(2, productId);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }
}
