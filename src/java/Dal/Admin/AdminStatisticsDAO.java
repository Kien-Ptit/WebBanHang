package Dal.Admin;

import Dal.DBContext;
import java.sql.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * DAO riêng cho Admin Statistics
 * 
 * @author Kien-Ptit
 * @version 1.0
 * @since 2025-10-25
 */
public class AdminStatisticsDAO extends DBContext {

    /**
     * Đếm đơn hàng hôm nay
     */
    public int getTodayOrders() throws Exception {
        String sql = "SELECT COUNT(*) FROM orders WHERE DATE(created_at) = CURDATE()";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }
        }

        return 0;
    }

    /**
     * Doanh thu hôm nay
     */
    public BigDecimal getTodayRevenue() throws Exception {
        String sql = """
            SELECT COALESCE(SUM(final_amount), 0) 
            FROM orders 
            WHERE DATE(created_at) = CURDATE()
              AND status != 'Cancelled'
        """;

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                return rs.getBigDecimal(1);
            }
        }

        return BigDecimal.ZERO;
    }

    /**
     * Tổng doanh thu
     */
    public BigDecimal getTotalRevenue() throws Exception {
        String sql = """
            SELECT COALESCE(SUM(final_amount), 0) 
            FROM orders 
            WHERE status != 'Cancelled'
        """;

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                return rs.getBigDecimal(1);
            }
        }

        return BigDecimal.ZERO;
    }

    /**
     * Doanh thu theo khoảng thời gian
     */
    public BigDecimal getRevenueByPeriod(LocalDate start, LocalDate end) throws Exception {
        String sql = """
            SELECT COALESCE(SUM(final_amount), 0) 
            FROM orders 
            WHERE DATE(created_at) BETWEEN ? AND ?
              AND status != 'Cancelled'
        """;

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, start.toString());
            st.setString(2, end.toString());
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                return rs.getBigDecimal(1);
            }
        }

        return BigDecimal.ZERO;
    }

    /**
     * Đơn hàng theo khoảng thời gian
     */
    public int getOrdersByPeriod(LocalDate start, LocalDate end) throws Exception {
        String sql = """
            SELECT COUNT(*) 
            FROM orders 
            WHERE DATE(created_at) BETWEEN ? AND ?
        """;

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, start.toString());
            st.setString(2, end.toString());
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }
        }

        return 0;
    }

    /**
     * Doanh thu kỳ trước (để so sánh)
     */
    public BigDecimal getPreviousPeriodRevenue(LocalDate start, LocalDate end) throws Exception {
        long days = java.time.temporal.ChronoUnit.DAYS.between(start, end);
        LocalDate prevStart = start.minusDays(days);
        LocalDate prevEnd = end.minusDays(days);

        return getRevenueByPeriod(prevStart, prevEnd);
    }

    /**
     * Đơn hàng kỳ trước
     */
    public int getPreviousPeriodOrders(LocalDate start, LocalDate end) throws Exception {
        long days = java.time.temporal.ChronoUnit.DAYS.between(start, end);
        LocalDate prevStart = start.minusDays(days);
        LocalDate prevEnd = end.minusDays(days);

        return getOrdersByPeriod(prevStart, prevEnd);
    }

    /**
     * Dữ liệu biểu đồ doanh thu
     */
    public String getRevenueChartData(LocalDate start, LocalDate end) throws Exception {
        String sql = """
            SELECT 
                DATE(created_at) as order_date,
                COALESCE(SUM(final_amount), 0) as daily_revenue
            FROM orders
            WHERE DATE(created_at) BETWEEN ? AND ?
              AND status != 'Cancelled'
            GROUP BY DATE(created_at)
            ORDER BY order_date ASC
        """;

        List<String> labels = new ArrayList<>();
        List<BigDecimal> data = new ArrayList<>();

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, start.toString());
            st.setString(2, end.toString());
            ResultSet rs = st.executeQuery();

            java.text.SimpleDateFormat outputFormat = new java.text.SimpleDateFormat("dd/MM");

            while (rs.next()) {
                String dateStr = rs.getString("order_date");
                BigDecimal revenue = rs.getBigDecimal("daily_revenue");

                try {
                    java.util.Date date = java.sql.Date.valueOf(dateStr);
                    labels.add(outputFormat.format(date));
                } catch (Exception e) {
                    labels.add(dateStr);
                }

                data.add(revenue);
            }
        }

        return buildChartJson(labels, data);
    }

    /**
     * Dữ liệu biểu đồ đơn hàng
     */
    public String getOrdersChartData(LocalDate start, LocalDate end) throws Exception {
        String sql = """
            SELECT 
                DATE(created_at) as order_date,
                COUNT(*) as order_count
            FROM orders
            WHERE DATE(created_at) BETWEEN ? AND ?
            GROUP BY DATE(created_at)
            ORDER BY order_date ASC
        """;

        List<String> labels = new ArrayList<>();
        List<Integer> data = new ArrayList<>();

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, start.toString());
            st.setString(2, end.toString());
            ResultSet rs = st.executeQuery();

            java.text.SimpleDateFormat outputFormat = new java.text.SimpleDateFormat("dd/MM");

            while (rs.next()) {
                String dateStr = rs.getString("order_date");
                int count = rs.getInt("order_count");

                try {
                    java.util.Date date = java.sql.Date.valueOf(dateStr);
                    labels.add(outputFormat.format(date));
                } catch (Exception e) {
                    labels.add(dateStr);
                }

                data.add(count);
            }
        }

        return buildChartJsonInt(labels, data);
    }

    /**
     * Doanh thu 7 ngày gần đây
     */
    public String getRevenue7Days() throws Exception {
        LocalDate end = LocalDate.now();
        LocalDate start = end.minusDays(7);
        return getRevenueChartData(start, end);
    }

    /**
     * Thống kê theo trạng thái đơn hàng
     */
    public Map<String, Integer> getOrderStatsByStatus() throws Exception {
        String sql = """
            SELECT status, COUNT(*) as count
            FROM orders
            GROUP BY status
        """;

        Map<String, Integer> stats = new HashMap<>();

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                stats.put(rs.getString("status"), rs.getInt("count"));
            }
        }

        return stats;
    }

    /**
     * Thống kê sản phẩm bán chạy
     */
    public List<Map<String, Object>> getBestSellingProducts(int limit) throws Exception {
        String sql = """
            SELECT 
                p.id,
                p.name,
                p.image_url,
                p.price,
                c.name as category_name,
                COALESCE(SUM(od.quantity), 0) as sold_count,
                COALESCE(SUM(od.quantity * od.price), 0) as revenue
            FROM products p
            LEFT JOIN order_detail od ON p.id = od.product_id
            LEFT JOIN orders o ON od.order_id = o.id
            LEFT JOIN categories c ON p.category_id = c.id
            WHERE p.status = 'active' 
              AND (o.status IS NULL OR o.status != 'Cancelled')
            GROUP BY p.id, p.name, p.image_url, p.price, c.name
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
                product.put("categoryName", rs.getString("category_name"));
                product.put("soldCount", rs.getInt("sold_count"));
                product.put("revenue", rs.getBigDecimal("revenue"));

                products.add(product);
            }
        }

        return products;
    }

    /**
     * Thống kê theo danh mục
     */
    public List<Map<String, Object>> getRevenueByCategoryByCategory() throws Exception {
        String sql = """
            SELECT 
                c.id,
                c.name,
                COUNT(DISTINCT o.id) as order_count,
                COALESCE(SUM(od.quantity), 0) as total_sold,
                COALESCE(SUM(od.quantity * od.price), 0) as revenue
            FROM categories c
            LEFT JOIN products p ON c.id = p.category_id
            LEFT JOIN order_detail od ON p.id = od.product_id
            LEFT JOIN orders o ON od.order_id = o.id AND o.status != 'Cancelled'
            GROUP BY c.id, c.name
            ORDER BY revenue DESC
        """;

        List<Map<String, Object>> categories = new ArrayList<>();

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                Map<String, Object> category = new HashMap<>();
                category.put("id", rs.getInt("id"));
                category.put("name", rs.getString("name"));
                category.put("orderCount", rs.getInt("order_count"));
                category.put("totalSold", rs.getInt("total_sold"));
                category.put("revenue", rs.getBigDecimal("revenue"));

                categories.add(category);
            }
        }

        return categories;
    }

    /**
     * Build JSON cho biểu đồ (BigDecimal)
     */
    private String buildChartJson(List<String> labels, List<BigDecimal> data) {
        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"labels\":[");
        for (int i = 0; i < labels.size(); i++) {
            json.append("\"").append(labels.get(i)).append("\"");
            if (i < labels.size() - 1) json.append(",");
        }
        json.append("],");
        json.append("\"data\":[");
        for (int i = 0; i < data.size(); i++) {
            json.append(data.get(i));
            if (i < data.size() - 1) json.append(",");
        }
        json.append("]}");

        return json.toString();
    }

    /**
     * Build JSON cho biểu đồ (Integer)
     */
    private String buildChartJsonInt(List<String> labels, List<Integer> data) {
        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"labels\":[");
        for (int i = 0; i < labels.size(); i++) {
            json.append("\"").append(labels.get(i)).append("\"");
            if (i < labels.size() - 1) json.append(",");
        }
        json.append("],");
        json.append("\"data\":[");
        for (int i = 0; i < data.size(); i++) {
            json.append(data.get(i));
            if (i < data.size() - 1) json.append(",");
        }
        json.append("]}");

        return json.toString();
    }
}