package Dal;

import Model.Product;
import Model.Category;
import Model.Brand;
import com.mysql.cj.jdbc.result.ResultSetMetaData;
import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ProductDAO extends DBContext {

    private static final String VI_COLLATE = "utf8mb4_0900_ai_ci";

    private void setParams(PreparedStatement st, Object... params) throws SQLException {
        if (params == null) {
            return;
        }
        for (int i = 0; i < params.length; i++) {
            Object p = params[i];
            int idx = i + 1;
            if (p == null) {
                st.setObject(idx, null);
            } else if (p instanceof Integer) {
                st.setInt(idx, (Integer) p);
            } else if (p instanceof Long) {
                st.setLong(idx, (Long) p);
            } else if (p instanceof Double) {
                st.setDouble(idx, (Double) p);
            } else {
                st.setString(idx, p.toString());
            }
        }
    }

    private List<Map<String, Object>> queryList(String sql, Object... params) throws Exception {
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            setParams(st, params);
            try (ResultSet rs = st.executeQuery()) {
                List<Map<String, Object>> list = new ArrayList<>();
                ResultSetMetaData md = (ResultSetMetaData) rs.getMetaData();
                int n = md.getColumnCount();
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    for (int i = 1; i <= n; i++) {
                        String key = md.getColumnLabel(i);
                        row.put(key, rs.getObject(i));
                    }
                    list.add(row);
                }
                return list;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /* ------ Nghiệp vụ ------ */
    // Danh mục
    public List<Map<String, Object>> getCategories() throws Exception {
        String sql = "SELECT id, name, description FROM categories ORDER BY name";
        return queryList(sql);
    }

    // Sản phẩm nổi bật
    public List<Map<String, Object>> getFeaturedProducts(int limit) throws Exception {
        String sql = "SELECT id, name, price, discount_price, image_url, category_id "
                + "FROM products WHERE status='active' AND featured=1 "
                + "ORDER BY updated_at DESC LIMIT ?";
        return queryList(sql, limit);
    }

    // Sản phẩm mới
    public List<Map<String, Object>> getLatestProducts(int limit) throws Exception {
        String sql = "SELECT id, name, price, discount_price, image_url, category_id "
                + "FROM products WHERE status='active' "
                + "ORDER BY created_at DESC LIMIT ?";
        return queryList(sql, limit);
    }

    // (tuỳ chọn) sản phẩm xem nhiều
    public List<Map<String, Object>> getTopViews(int limit) throws Exception {
        String sql = "SELECT id, name, price, discount_price, image_url, views "
                + "FROM products WHERE status='active' ORDER BY views DESC LIMIT ?";
        return queryList(sql, limit);
    }

    public List<Map<String, Object>> findProducts(String q, Integer categoryId, String priceRange,
            List<String> sizes, String sort, int offset, int pageSize) throws Exception {
        List<Object> params = new ArrayList<>();
        StringBuilder where = new StringBuilder(" WHERE status='active' ");

        // Tìm kiếm theo từ khóa
        if (q != null && !q.isBlank()) {
            where.append(" AND (LOWER(name) LIKE ? OR LOWER(description) LIKE ?) ");
            String k = "%" + q.toLowerCase() + "%";
            params.add(k);
            params.add(k);
        }

        // Lọc theo danh mục
        if (categoryId != null) {
            where.append(" AND category_id = ? ");
            params.add(categoryId);
        }

        // Lọc theo giá
        String priceExpr = "COALESCE(discount_price, price)";
        if (priceRange != null && !priceRange.isBlank()) {
            switch (priceRange) {
                case "under_500":
                    where.append(" AND ").append(priceExpr).append(" < 500000 ");
                    break;
                case "500_1000":
                    where.append(" AND ").append(priceExpr).append(" BETWEEN 500000 AND 1000000 ");
                    break;
                case "1000_2000":
                    where.append(" AND ").append(priceExpr).append(" BETWEEN 1000000 AND 2000000 ");
                    break;
                case "over_2000":
                    where.append(" AND ").append(priceExpr).append(" > 2000000 ");
                    break;
            }
        }

        // Sắp xếp
        String orderBy = " created_at DESC ";
        if ("price_asc".equals(sort)) {
            orderBy = priceExpr + " ASC";
        } else if ("price_desc".equals(sort)) {
            orderBy = priceExpr + " DESC";
        } else if ("popular".equals(sort)) {
            orderBy = " views DESC, created_at DESC ";
        }

        String sql = "SELECT id, name, description, price, discount_price, image_url, category_id, created_at "
                + "FROM products " + where + " ORDER BY " + orderBy + " LIMIT ? OFFSET ?";

        params.add(pageSize);
        params.add(offset);

        return queryList(sql, params.toArray());
    }
// Sửa lại method buildWhereMySQL để không duplicate WHERE
// Thay thế method buildWhereMySQL hiện tại bằng version này:

    private String buildWhereMySQL(String q, List<Integer> categoryIds,
            String priceRange, String segment, List<Object> params) {
        StringBuilder where = new StringBuilder(" WHERE status = 'active' ");

        if (q != null && !q.isBlank()) {
            // Tách từ khóa để tìm kiếm linh hoạt hơn
            String searchTerm = q.trim().toLowerCase();
            String[] keywords = q.toLowerCase().trim().split("\\s+");

            if (keywords.length == 1) {
                // Tìm kiếm đơn giản với 1 từ khóa
                where.append(" AND (LOWER(name) LIKE ? ) ");
                String k = "%" + keywords[0] + "%";
                params.add(k);
            } else {
                // Tìm kiếm với nhiều từ khóa - phải chứa tất cả các từ
                where.append(" AND (");
                for (int i = 0; i < keywords.length; i++) {
                    if (i > 0) {
                        where.append(" AND ");
                    }
                    where.append("(LOWER(name) LIKE ? OR LOWER(description) LIKE ?)");
                    String k = "%" + keywords[i] + "%";
                    params.add(k);
                    params.add(k);
                }
                where.append(") ");
            }
        }

        // Phần còn lại giữ nguyên...
        if (categoryIds != null && !categoryIds.isEmpty()) {
            where.append(" AND category_id IN (")
                    .append(String.join(",", java.util.Collections.nCopies(categoryIds.size(), "?")))
                    .append(") ");
            params.addAll(categoryIds);
        }

        // Price range logic...
        String priceExpr = "COALESCE(discount_price, price)";
        if (priceRange != null && !priceRange.isBlank()) {
            switch (priceRange) {
                case "under_500":
                    where.append(" AND ").append(priceExpr).append(" < 500000 ");
                    break;
                case "500_1000":
                    where.append(" AND ").append(priceExpr).append(" BETWEEN 500000 AND 1000000 ");
                    break;
                case "1000_2000":
                    where.append(" AND ").append(priceExpr).append(" BETWEEN 1000000 AND 2000000 ");
                    break;
                case "over_2000":
                    where.append(" AND ").append(priceExpr).append(" > 2000000 ");
                    break;
            }
        }
        if (segment != null) {
            String s = segment.toLowerCase();
            if ("women".equals(s)) {
                where.append(" AND (LOWER(name) REGEXP '(^|[[:space:]])(nữ|nu|women|lady|ladies|girl)([[:space:]]|$)' ")
                        .append(" OR LOWER(description) REGEXP '(^|[[:space:]])(nữ|nu|women|lady|ladies|girl)([[:space:]]|$)') ");
            } else if ("men".equals(s)) {
                where.append(" AND (LOWER(name) REGEXP '(^|[[:space:]])(nam|men|male|boy)([[:space:]]|$)' ")
                        .append(" OR LOWER(description) REGEXP '(^|[[:space:]])(nam|men|male|boy)([[:space:]]|$)') ");
            }
        }
        return where.toString();
    }

// Thay thế method findProductsByCategories:
    public List<Map<String, Object>> findProductsByCategories(String q, List<Integer> categoryIds,
            String priceRange, String sort, int offset, int pageSize, String segment) throws Exception {
        List<Object> params = new ArrayList<>();
        String where = buildWhereMySQL(q, categoryIds, priceRange, segment, params);

        String priceExpr = "COALESCE(discount_price, price)";
        String orderBy = " created_at DESC ";
        if ("price_asc".equals(sort)) {
            orderBy = priceExpr + " ASC";
        } else if ("price_desc".equals(sort)) {
            orderBy = priceExpr + " DESC";
        } else if ("popular".equals(sort)) {
            orderBy = " views DESC, created_at DESC ";
        }

        // Bỏ "AND status = 'active'" vì đã có trong buildWhereMySQL
        String sql = "SELECT id, name, description, price, discount_price, image_url, category_id, created_at "
                + "FROM products " + where + " ORDER BY " + orderBy + " LIMIT ? OFFSET ?";

        params.add(pageSize);
        params.add(offset);

        return queryList(sql, params.toArray());
    }

// Thay thế method countProductsByCategories:
    public int countProductsByCategories(String q, List<Integer> categoryIds, String priceRange, String segment) {
        List<Object> params = new ArrayList<>();
        String where = buildWhereMySQL(q, categoryIds, priceRange, segment, params);
        String sql = "SELECT COUNT(*) FROM products " + where;

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            for (int i = 0; i < params.size(); i++) {
                st.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = st.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Thay thế method countProducts hiện tại:
    // Thay thế method countProducts hiện tại:
    public int countProducts(String q, Integer categoryId, String priceRange, List<String> sizes) {
        List<Object> params = new ArrayList<>();
        StringBuilder where = new StringBuilder(" WHERE status='active' ");

        // Tìm kiếm theo từ khóa
        if (q != null && !q.isBlank()) {
            where.append(" AND (LOWER(name) LIKE ? OR LOWER(description) LIKE ?) ");
            String k = "%" + q.toLowerCase() + "%";
            params.add(k);
            params.add(k);
        }

        // Lọc theo danh mục
        if (categoryId != null) {
            where.append(" AND category_id = ? ");
            params.add(categoryId);
        }

        // Lọc theo giá
        String priceExpr = "COALESCE(discount_price, price)";
        if (priceRange != null && !priceRange.isBlank()) {
            switch (priceRange) {
                case "under_500":
                    where.append(" AND ").append(priceExpr).append(" < 500000 ");
                    break;
                case "500_1000":
                    where.append(" AND ").append(priceExpr).append(" BETWEEN 500000 AND 1000000 ");
                    break;
                case "1000_2000":
                    where.append(" AND ").append(priceExpr).append(" BETWEEN 1000000 AND 2000000 ");
                    break;
                case "over_2000":
                    where.append(" AND ").append(priceExpr).append(" > 2000000 ");
                    break;
            }
        }

        String sql = "SELECT COUNT(*) FROM products " + where;

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            for (int i = 0; i < params.size(); i++) {
                st.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = st.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    // MySQL 8+: dùng collate này; nếu là MySQL 5.7 hãy đổi thành "utf8mb4_unicode_ci"

    /**
     * Lấy N sản phẩm theo category id
     */
    public List<Map<String, Object>> getProductsByCategory(int categoryId, int limit) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT id, name, description, price, discount_price, image_url, category_id "
                + "FROM products WHERE status='active' AND category_id=? "
                + "ORDER BY created_at DESC LIMIT ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, categoryId);
            st.setInt(2, limit);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Map<String, Object> p = new HashMap<>();
                p.put("id", rs.getInt("id"));
                p.put("name", rs.getString("name"));
                p.put("description", rs.getString("description"));
                p.put("price", rs.getDouble("price"));
                p.put("discount_price", rs.getObject("discount_price"));
                p.put("image_url", rs.getString("image_url"));
                p.put("category_id", rs.getInt("category_id"));
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Map<String, Object>> listProductsByCategoryIds(List<Integer> categoryIds, int limit) {
        List<Map<String, Object>> list = new ArrayList<>();
        if (categoryIds == null || categoryIds.isEmpty()) {
            return list;
        }

        String placeholders = String.join(",", java.util.Collections.nCopies(categoryIds.size(), "?"));
        String sql = "SELECT id, name, description, price, discount_price, image_url, "
                + "category_id, created_at "
                + "FROM products "
                + "WHERE status='active' AND category_id IN (" + placeholders + ") "
                + "ORDER BY created_at DESC LIMIT ?";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            int idx = 1;
            for (Integer cid : categoryIds) {
                st.setInt(idx++, cid);
            }
            st.setInt(idx, limit);

            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> m = new HashMap<>();
                    m.put("id", rs.getInt("id"));
                    m.put("name", rs.getString("name"));
                    m.put("description", rs.getString("description"));
                    m.put("price", rs.getDouble("price"));
                    m.put("discount_price", rs.getObject("discount_price"));
                    m.put("image_url", rs.getString("image_url"));
                    m.put("category_id", rs.getInt("category_id"));
                    m.put("created_at", rs.getTimestamp("created_at"));
                    list.add(m);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Map<String, Object> findProductById(int id) throws Exception {
        String sql = """
        SELECT id, name, description, price, discount_price, image_url,
               category_id, stock_quantity, brand, material, color, size,
               views, status, created_at, updated_at
        FROM products
        WHERE id = ? AND (status IS NULL OR status = 'active')
        LIMIT 1
        """;
        // Nếu bạn đã có helper queryOne(...) thì dùng:
        return queryOne(sql, id);
    }

    public void increaseViews(int id) {
        String sql = "UPDATE products SET views = COALESCE(views,0) + 1 WHERE id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, id);
            st.executeUpdate();
        } catch (Exception ignored) {
        }
    }

    public List<Map<String, Object>> findRelatedProducts(int categoryId, int excludeId, int limit) throws Exception {
        String sql = """
        SELECT id, name, description, price, discount_price, image_url, category_id
        FROM products
        WHERE category_id = ? AND id <> ?
              AND (status IS NULL OR status = 'active')
        ORDER BY created_at DESC
        LIMIT ?
        """;
        return queryList(sql, categoryId, excludeId, limit);
    }

    private Map<String, Object> queryOne(String sql, Object... params) throws Exception {
        List<Map<String, Object>> list = queryList(sql, params);
        return list.isEmpty() ? null : list.get(0);
    }

    public Map<String, Object> findById(int id) {
        String sql = """
        SELECT id, name, description, price, discount_price, image_url, 
               category_id, stock_quantity, size, color, material, brand, views, status
        FROM products 
        WHERE id=? AND (status IS NULL OR status='active')
        """;
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, id);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> p = new HashMap<>();
                    p.put("id", rs.getInt("id"));
                    p.put("name", rs.getString("name"));
                    p.put("description", rs.getString("description"));
                    p.put("price", rs.getDouble("price"));
                    p.put("discount_price", rs.getObject("discount_price"));
                    p.put("image_url", rs.getString("image_url"));
                    p.put("category_id", rs.getInt("category_id"));
                    p.put("stock_quantity", rs.getInt("stock_quantity"));
                    p.put("size", rs.getString("size"));
                    p.put("color", rs.getString("color"));
                    p.put("material", rs.getString("material"));
                    p.put("brand", rs.getString("brand"));
                    p.put("views", rs.getInt("views"));
                    p.put("status", rs.getString("status"));
                    return p;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public static class ProductRow {

        public final int id;
        public final String name;
        public final String imageUrl;
        public final BigDecimal price;

        public ProductRow(int id, String name, String imageUrl, BigDecimal price) {
            this.id = id;
            this.name = name;
            this.imageUrl = imageUrl;
            this.price = price;
        }
    }
    // ==================== ADMIN METHODS - FIXED ====================

    /**
     * Lấy tất cả sản phẩm (Admin) - FIXED
     */
    /**
     * Lấy tất cả sản phẩm (Admin) - FIXED COMPLETELY
     */
    public List<Product> getAllProductsForAdmin() throws Exception {
        String sql = """
        SELECT 
            p.id,
            p.name,
            p.description,
            p.price,
            p.sale_price,
            p.image_url,
            p.category_id,
            p.stock_quantity,
            p.status,
            p.created_at,
            c.name as category_name
        FROM products p
        LEFT JOIN categories c ON p.category_id = c.id
        ORDER BY p.created_at DESC
    """;

        List<Product> products = new ArrayList<>();

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                Product product = new Product();
                product.setId(rs.getInt("id"));
                product.setName(rs.getString("name"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getBigDecimal("price"));

                // Handle sale_price (có thể null)
                BigDecimal salePrice = rs.getBigDecimal("sale_price");
                if (salePrice != null) {
                    product.setSalePrice(salePrice);
                }

                // Handle image_url
                product.setImage(rs.getString("image_url"));

                product.setCategoryId(rs.getInt("category_id"));
                product.setStockQuantity(rs.getInt("stock_quantity"));
                product.setStatus(rs.getString("status"));
                product.setCreatedAt(rs.getTimestamp("created_at"));

                // Set category object
                String categoryName = rs.getString("category_name");
                if (categoryName != null) {
                    Category cat = new Category();
                    cat.setId(rs.getInt("category_id"));
                    cat.setName(categoryName);
                    product.setCategory(cat);
                }

                products.add(product);
            }

            // Debug log
            System.out.println("DEBUG ProductDAO: Loaded " + products.size() + " products");
        } catch (SQLException e) {
            System.err.println("ERROR in getAllProductsForAdmin: " + e.getMessage());
            e.printStackTrace();
            throw new Exception("Cannot load products: " + e.getMessage());
        }

        return products;
    }

    /**
     * Đếm tổng số sản phẩm - FIXED
     */
    public int getTotalProductsCount() throws Exception {
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
     * Lấy sản phẩm bán chạy nhất - FIXED (trả về Map)
     */
    public List<Map<String, Object>> getBestSellingProductsMap(int limit) throws Exception {
        String sql = """
        SELECT 
            p.id,
            p.name,
            p.image_url,
            p.price,
            COALESCE(SUM(od.quantity), 0) as sold_count,
            COALESCE(SUM(od.quantity * od.price), 0) as revenue
        FROM products p
        LEFT JOIN order_detail od ON p.id = od.product_id
        LEFT JOIN orders o ON od.order_id = o.id
        WHERE p.status = 'active' 
          AND (o.status IS NULL OR o.status != 'Cancelled')
        GROUP BY p.id, p.name, p.image_url, p.price
        ORDER BY sold_count DESC
        LIMIT ?
    """;

        List<Map<String, Object>> bestSellers = new ArrayList<>();

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, limit);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                Map<String, Object> product = new HashMap<>();
                product.put("id", rs.getInt("id"));
                product.put("name", rs.getString("name"));
                product.put("imageUrl", rs.getString("image_url"));
                product.put("price", rs.getBigDecimal("price"));
                product.put("soldCount", rs.getInt("sold_count"));
                product.put("revenue", rs.getBigDecimal("revenue"));

                bestSellers.add(product);
            }
        }

        return bestSellers;
    }

    /**
     * Tìm kiếm sản phẩm (Admin) - FIXED
     */
    public List<Product> searchProductsForAdmin(String keyword) throws Exception {
        String sql = """
        SELECT p.*, c.name as category_name
        FROM products p
        LEFT JOIN categories c ON p.category_id = c.id
        WHERE p.status = 'active'
          AND (p.name LIKE ? OR p.description LIKE ?)
        ORDER BY p.created_at DESC
    """;

        List<Product> products = new ArrayList<>();

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            String searchPattern = "%" + keyword + "%";
            st.setString(1, searchPattern);
            st.setString(2, searchPattern);

            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                Product product = new Product();
                product.setId(rs.getInt("id"));
                product.setName(rs.getString("name"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getBigDecimal("price"));
                product.setSalePrice(rs.getBigDecimal("sale_price"));
                product.setImage(rs.getString("image_url"));
                product.setCategoryId(rs.getInt("category_id"));
                product.setStockQuantity(rs.getInt("stock_quantity"));
                product.setStatus(rs.getString("status"));

                // Set category name
                if (rs.getString("category_name") != null) {
                    Category cat = new Category();
                    cat.setId(rs.getInt("category_id"));
                    cat.setName(rs.getString("category_name"));
                    product.setCategory(cat);
                }

                products.add(product);
            }
        }

        return products;
    }

    /**
     * Lấy sản phẩm theo category (Admin) - FIXED
     */
    public List<Product> getProductsByCategoryForAdmin(int categoryId) throws Exception {
        String sql = """
        SELECT p.*, c.name as category_name
        FROM products p
        LEFT JOIN categories c ON p.category_id = c.id
        WHERE p.status = 'active' AND p.category_id = ?
        ORDER BY p.created_at DESC
    """;

        List<Product> products = new ArrayList<>();

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, categoryId);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                Product product = new Product();
                product.setId(rs.getInt("id"));
                product.setName(rs.getString("name"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getBigDecimal("price"));
                product.setSalePrice(rs.getBigDecimal("sale_price"));
                product.setImage(rs.getString("image_url"));
                product.setCategoryId(rs.getInt("category_id"));
                product.setStockQuantity(rs.getInt("stock_quantity"));
                product.setStatus(rs.getString("status"));

                if (rs.getString("category_name") != null) {
                    Category cat = new Category();
                    cat.setId(rs.getInt("category_id"));
                    cat.setName(rs.getString("category_name"));
                    product.setCategory(cat);
                }

                products.add(product);
            }
        }

        return products;
    }
}
