package Dal;

import Model.Order;
import java.sql.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * DAO cho quản lý Orders
 *
 * @author Kien-Ptit
 * @version 3.0
 * @since 2025-10-21
 */
public class OrderDAO extends DBContext {

    // ==================== CREATE ====================
    /**
     * Tạo order mới với đầy đủ thông tin thanh toán
     */
    public int createOrderWithItems(
            Integer userId,
            String fullname,
            String phone,
            String address,
            String note,
            BigDecimal totalAmount,
            List<Order.OrderItem> items,
            String paymentMethod,
            String ewalletType) throws Exception {

        String sqlOrder = """
            INSERT INTO orders (
                user_id, fullname, phone, address, note,
                total_amount, shipping_fee, discount_amount,
                status, payment_method, ewallet_type, payment_status,
                created_at, updated_at
            ) VALUES (?, ?, ?, ?, ?, ?, 0, 0, 'Pending', ?, ?, 'UNPAID', NOW(), NOW())
        """;

        String sqlItem = """
            INSERT INTO order_detail (
                order_id, product_id, quantity, price, size, color
            ) VALUES (?, ?, ?, ?, ?, ?)
        """;

        Connection con = null;
        PreparedStatement psOrder = null;
        PreparedStatement psItem = null;
        ResultSet generatedKeys = null;

        try {
            con = getConnection();
            boolean oldAutoCommit = con.getAutoCommit();

            try {
                con.setAutoCommit(false);

                // Insert order
                int orderId = -1;
                psOrder = con.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);

                if (userId == null) {
                    psOrder.setNull(1, Types.INTEGER);
                } else {
                    psOrder.setInt(1, userId);
                }
                psOrder.setString(2, fullname);
                psOrder.setString(3, phone);
                psOrder.setString(4, address);
                psOrder.setString(5, note);
                psOrder.setBigDecimal(6, totalAmount);
                psOrder.setString(7, paymentMethod != null ? paymentMethod : "COD");
                psOrder.setString(8, ewalletType);

                psOrder.executeUpdate();
                generatedKeys = psOrder.getGeneratedKeys();
                if (generatedKeys.next()) {
                    orderId = generatedKeys.getInt(1);
                } else {
                    throw new SQLException("Không lấy được order ID");
                }

                // Insert items
                if (items != null && !items.isEmpty()) {
                    psItem = con.prepareStatement(sqlItem);

                    for (Order.OrderItem item : items) {
                        psItem.setInt(1, orderId);
                        psItem.setInt(2, item.getProductId());
                        psItem.setInt(3, item.getQuantity());
                        psItem.setBigDecimal(4, item.getPrice());

                        if (item.getSize() != null && !item.getSize().trim().isEmpty()) {
                            psItem.setString(5, item.getSize());
                        } else {
                            psItem.setNull(5, Types.VARCHAR);
                        }

                        if (item.getColor() != null && !item.getColor().trim().isEmpty()) {
                            psItem.setString(6, item.getColor());
                        } else {
                            psItem.setNull(6, Types.VARCHAR);
                        }

                        psItem.addBatch();
                    }

                    psItem.executeBatch();
                }

                con.commit();
                return orderId;

            } catch (Exception ex) {
                if (con != null) con.rollback();
                throw ex;
            } finally {
                if (con != null) con.setAutoCommit(oldAutoCommit);
            }
        } finally {
            if (generatedKeys != null) try { generatedKeys.close(); } catch (SQLException e) {}
            if (psItem != null) try { psItem.close(); } catch (SQLException e) {}
            if (psOrder != null) try { psOrder.close(); } catch (SQLException e) {}
            if (con != null) try { con.close(); } catch (SQLException e) {}
        }
    }

    // ==================== READ ====================
    public List<Order> listOrdersByUser(int userId) throws Exception {
        String sql = """
            SELECT 
                id, user_id, fullname, phone, address, tracking_number, note,
                total_amount, shipping_fee, discount_amount, final_amount,
                status, payment_method, ewallet_type, payment_status,
                created_at, updated_at, paid_at, cancelled_at, cancel_reason
            FROM orders
            WHERE user_id = ?
            ORDER BY created_at DESC
        """;

        List<Order> orders = new ArrayList<>();

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order order = mapResultSetToOrder(rs);
                    orders.add(order);
                }
            }
        }

        return orders;
    }

    public Order findOrderHeader(int orderId, int userId) throws Exception {
        String sql = """
            SELECT 
                id, user_id, fullname, phone, address, tracking_number, note,
                total_amount, shipping_fee, discount_amount, final_amount,
                status, payment_method, ewallet_type, payment_status,
                created_at, updated_at, paid_at, cancelled_at, cancel_reason
            FROM orders
            WHERE id = ? AND user_id = ?
        """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.setInt(2, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapResultSetToOrder(rs);
            }
        }

        return null;
    }

    public List<Order.OrderItem> findOrderItems(int orderId) throws Exception {
        String sql = """
            SELECT 
                od.id, od.order_id, od.product_id, od.quantity, od.price,
                od.size, od.color,
                p.name AS product_name,
                p.image_url AS product_image
            FROM order_detail od
            INNER JOIN products p ON p.id = od.product_id
            WHERE od.order_id = ?
            ORDER BY od.id ASC
        """;

        List<Order.OrderItem> items = new ArrayList<>();

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    items.add(mapResultSetToOrderItem(rs));
                }
            }
        }

        return items;
    }

    // ==================== UPDATE ====================
    public boolean updateOrderStatus(int orderId, String status) throws Exception {
        String sql = """
            UPDATE orders 
            SET status = ?, updated_at = NOW()
            WHERE id = ?
        """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean cancelOrder(int orderId, int userId, String reason) throws Exception {
        String sql = """
            UPDATE orders 
            SET status = 'Cancelled', 
                cancelled_at = NOW(),
                cancel_reason = ?,
                updated_at = NOW()
            WHERE id = ? AND user_id = ? AND status = 'Pending'
        """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, reason);
            ps.setInt(2, orderId);
            ps.setInt(3, userId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean updatePaymentStatus(int orderId, String paymentStatus) throws Exception {
        String sql = """
            UPDATE orders 
            SET payment_status = ?,
                paid_at = CASE WHEN ? = 'PAID' THEN NOW() ELSE NULL END,
                updated_at = NOW()
            WHERE id = ?
        """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, paymentStatus);
            ps.setString(2, paymentStatus);
            ps.setInt(3, orderId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean updateTrackingNumber(int orderId, String trackingNumber) throws Exception {
        String sql = """
            UPDATE orders 
            SET tracking_number = ?,
                status = 'Processing',
                updated_at = NOW()
            WHERE id = ?
        """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, trackingNumber);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        }
    }

    // ==================== HELPER: MAPPING ====================
    private Order mapResultSetToOrder(ResultSet rs) throws SQLException {
        Order order = new Order();

        order.setId(rs.getInt("id"));

        int userId = rs.getInt("user_id");
        if (!rs.wasNull()) order.setUserId(userId);

        order.setFullname(rs.getString("fullname"));
        order.setPhone(rs.getString("phone"));
        order.setAddress(rs.getString("address"));
        order.setTrackingNumber(rs.getString("tracking_number"));
        order.setNote(rs.getString("note"));

        order.setTotalAmount(rs.getBigDecimal("total_amount"));
        order.setShippingFee(rs.getBigDecimal("shipping_fee"));
        order.setDiscountAmount(rs.getBigDecimal("discount_amount"));
        order.setFinalAmount(rs.getBigDecimal("final_amount"));

        order.setStatus(rs.getString("status"));
        order.setPaymentMethod(rs.getString("payment_method"));
        order.setEwalletType(rs.getString("ewallet_type"));
        order.setPaymentStatus(rs.getString("payment_status"));

        order.setCreatedAt(rs.getTimestamp("created_at"));
        order.setUpdatedAt(rs.getTimestamp("updated_at"));
        order.setPaidAt(rs.getTimestamp("paid_at"));
        order.setCancelledAt(rs.getTimestamp("cancelled_at"));
        order.setCancelReason(rs.getString("cancel_reason"));

        return order;
    }

    private Order.OrderItem mapResultSetToOrderItem(ResultSet rs) throws SQLException {
        Order.OrderItem item = new Order.OrderItem();

        item.setId(rs.getInt("id"));
        item.setOrderId(rs.getInt("order_id"));
        item.setProductId(rs.getInt("product_id"));
        item.setQuantity(rs.getInt("quantity"));
        item.setPrice(rs.getBigDecimal("price"));
        item.setSize(rs.getString("size"));
        item.setColor(rs.getString("color"));
        item.setProductName(rs.getString("product_name"));
        item.setProductImage(rs.getString("product_image"));

        return item;
    }

    public boolean canCancelOrder(int orderId, int userId) throws Exception {
        String sql = """
            SELECT COUNT(*) 
            FROM orders 
            WHERE id = ? AND user_id = ? AND status = 'Pending'
        """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.setInt(2, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        }

        return false;
    }

    public List<Order> findOrdersByStatus(int userId, String status) throws Exception {
        String sql = """
        SELECT 
            id, user_id, fullname, phone, address, tracking_number, note,
            total_amount, shipping_fee, discount_amount, final_amount,
            status, payment_method, ewallet_type, payment_status,
            created_at, updated_at, paid_at, cancelled_at, cancel_reason
        FROM orders
        WHERE user_id = ? AND status = ?
        ORDER BY created_at DESC
        """;

        List<Order> orders = new ArrayList<>();

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, status);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) orders.add(mapResultSetToOrder(rs));
            }
        }

        return orders;
    }

    // ==================== ADMIN ====================
    public List<Order> getAllOrders() throws Exception {
        String sql = """
        SELECT 
            id, user_id, fullname, phone, address, tracking_number, note,
            total_amount, shipping_fee, discount_amount, final_amount,
            status, payment_method, ewallet_type, payment_status,
            created_at, updated_at, paid_at, cancelled_at, cancel_reason
        FROM orders
        ORDER BY created_at DESC
        """;

        List<Order> orders = new ArrayList<>();

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) orders.add(mapResultSetToOrder(rs));
        }

        return orders;
    }

    public Order findOrderByIdAdmin(int orderId) throws Exception {
        String sql = """
        SELECT 
            id, user_id, fullname, phone, address, tracking_number, note,
            total_amount, shipping_fee, discount_amount, final_amount,
            status, payment_method, ewallet_type, payment_status,
            created_at, updated_at, paid_at, cancelled_at, cancel_reason
        FROM orders
        WHERE id = ?
        """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapResultSetToOrder(rs);
            }
        }

        return null;
    }

    public List<Order> findAllOrdersByStatus(String status) throws Exception {
        String sql = """
        SELECT 
            id, user_id, fullname, phone, address, tracking_number, note,
            total_amount, shipping_fee, discount_amount, final_amount,
            status, payment_method, ewallet_type, payment_status,
            created_at, updated_at, paid_at, cancelled_at, cancel_reason
        FROM orders
        WHERE status = ?
        ORDER BY created_at DESC
        """;

        List<Order> orders = new ArrayList<>();

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) orders.add(mapResultSetToOrder(rs));
            }
        }

        return orders;
    }

    public List<Order> searchOrders(String keyword) throws Exception {
        String sql = """
        SELECT 
            id, user_id, fullname, phone, address, tracking_number, note,
            total_amount, shipping_fee, discount_amount, final_amount,
            status, payment_method, ewallet_type, payment_status,
            created_at, updated_at, paid_at, cancelled_at, cancel_reason
        FROM orders
        WHERE fullname LIKE ? 
           OR phone LIKE ? 
           OR CONCAT('OD-', id) LIKE ?
           OR tracking_number LIKE ?
        ORDER BY created_at DESC
        """;

        List<Order> orders = new ArrayList<>();
        String searchPattern = "%" + keyword + "%";

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ps.setString(4, searchPattern);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) orders.add(mapResultSetToOrder(rs));
            }
        }

        return orders;
    }

    public int getPendingOrdersCount() throws Exception {
        String sql = "SELECT COUNT(*) FROM orders WHERE status = 'Pending'";

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        }

        return 0;
    }

    public List<Order> getRecentOrders(int limit) throws Exception {
        String sql = """
        SELECT 
            id, user_id, fullname, phone, address, tracking_number, note,
            total_amount, shipping_fee, discount_amount, final_amount,
            status, payment_method, ewallet_type, payment_status,
            created_at, updated_at, paid_at, cancelled_at, cancel_reason
        FROM orders
        ORDER BY created_at DESC
        LIMIT ?
        """;

        List<Order> orders = new ArrayList<>();

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) orders.add(mapResultSetToOrder(rs));
            }
        }

        return orders;
    }

    public Map<String, Object> getTodayStatistics() throws Exception {
        String sql = """
        SELECT 
            COUNT(*) as total_orders,
            COALESCE(SUM(final_amount), 0) as total_revenue
        FROM orders
        WHERE DATE(created_at) = CURDATE()
        """;

        Map<String, Object> stats = new HashMap<>();

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                stats.put("totalOrders", rs.getInt("total_orders"));
                stats.put("totalRevenue", rs.getBigDecimal("total_revenue"));
            }
        }

        return stats;
    }

    public int getTotalOrders() throws Exception {
        String sql = "SELECT COUNT(*) FROM orders";

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        }

        return 0;
    }

    public BigDecimal getTotalRevenue() throws Exception {
        String sql = """
        SELECT COALESCE(SUM(final_amount), 0) 
        FROM orders 
        WHERE status != 'Cancelled'
        """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getBigDecimal(1);
        }

        return BigDecimal.ZERO;
    }


    // ==================== FIXED ADMIN STATISTICS ====================
    public String getRevenueChartDataForAdmin(int days) throws Exception {
        String sql = """
        SELECT 
            DATE(created_at) as order_date,
            COALESCE(SUM(final_amount), 0) as daily_revenue
        FROM orders
        WHERE created_at >= DATE_SUB(NOW(), INTERVAL ? DAY)
          AND status != 'Cancelled'
        GROUP BY DATE(created_at)
        ORDER BY order_date ASC
        """;

        List<String> labels = new ArrayList<>();
        List<BigDecimal> data = new ArrayList<>();

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, days);
            ResultSet rs = st.executeQuery();

            java.text.SimpleDateFormat inFmt = new java.text.SimpleDateFormat("yyyy-MM-dd");
            java.text.SimpleDateFormat outFmt = new java.text.SimpleDateFormat("dd/MM");

            while (rs.next()) {
                String dateStr = rs.getString("order_date");
                BigDecimal revenue = rs.getBigDecimal("daily_revenue");

                try {
                    java.util.Date d = inFmt.parse(dateStr);
                    labels.add(outFmt.format(d));
                } catch (Exception e) {
                    labels.add(dateStr);
                }

                data.add(revenue);
            }
        }

        StringBuilder json = new StringBuilder();
        json.append("{\"labels\":[");
        for (int i = 0; i < labels.size(); i++) {
            json.append("\"").append(labels.get(i)).append("\"");
            if (i < labels.size() - 1) json.append(",");
        }
        json.append("],\"data\":[");
        for (int i = 0; i < data.size(); i++) {
            json.append(data.get(i));
            if (i < data.size() - 1) json.append(",");
        }
        json.append("]}");

        return json.toString();
    }

    public int getTodayOrdersCount() throws Exception {
        String sql = "SELECT COUNT(*) FROM orders WHERE DATE(created_at) = CURDATE()";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            ResultSet rs = st.executeQuery();
            if (rs.next()) return rs.getInt(1);
        }

        return 0;
    }

    public BigDecimal getTodayRevenueAmount() throws Exception {
        String sql = """
        SELECT COALESCE(SUM(final_amount), 0) 
        FROM orders 
        WHERE DATE(created_at) = CURDATE()
          AND status != 'Cancelled'
        """;

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            ResultSet rs = st.executeQuery();
            if (rs.next()) return rs.getBigDecimal(1);
        }

        return BigDecimal.ZERO;
    }

    public BigDecimal getTotalRevenueAmount() throws Exception {
        String sql = "SELECT COALESCE(SUM(final_amount), 0) FROM orders WHERE status != 'Cancelled'";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            ResultSet rs = st.executeQuery();
            if (rs.next()) return rs.getBigDecimal(1);
        }

        return BigDecimal.ZERO;
    }

    public int getTotalOrdersCount() throws Exception {
        String sql = "SELECT COUNT(*) FROM orders";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            ResultSet rs = st.executeQuery();
            if (rs.next()) return rs.getInt(1);
        }

        return 0;
    }

    public List<Order> getRecentOrdersForAdmin(int limit) throws Exception {
        String sql = """
        SELECT 
            id, user_id, fullname, phone, address, tracking_number, note,
            total_amount, shipping_fee, discount_amount, final_amount,
            status, payment_method, ewallet_type, payment_status,
            created_at, updated_at, paid_at, cancelled_at, cancel_reason
        FROM orders 
        ORDER BY created_at DESC 
        LIMIT ?
        """;

        List<Order> orders = new ArrayList<>();

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, limit);
            ResultSet rs = st.executeQuery();

            while (rs.next()) orders.add(mapResultSetToOrder(rs));
        }

        return orders;
    }

    public List<Order> searchOrdersForAdmin(String keyword) throws Exception {
        String sql = """
        SELECT 
            id, user_id, fullname, phone, address, tracking_number, note,
            total_amount, shipping_fee, discount_amount, final_amount,
            status, payment_method, ewallet_type, payment_status,
            created_at, updated_at, paid_at, cancelled_at, cancel_reason
        FROM orders 
        WHERE fullname LIKE ? 
           OR phone LIKE ? 
           OR CONCAT('OD-', id) LIKE ?
           OR tracking_number LIKE ?
        ORDER BY created_at DESC
        """;

        List<Order> orders = new ArrayList<>();
        String searchPattern = "%" + keyword + "%";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, searchPattern);
            st.setString(2, searchPattern);
            st.setString(3, searchPattern);
            st.setString(4, searchPattern);

            ResultSet rs = st.executeQuery();
            while (rs.next()) orders.add(mapResultSetToOrder(rs));
        }

        return orders;
    }

    public List<Order> getOrdersByStatusForAdmin(String status) throws Exception {
        String sql = """
        SELECT 
            id, user_id, fullname, phone, address, tracking_number, note,
            total_amount, shipping_fee, discount_amount, final_amount,
            status, payment_method, ewallet_type, payment_status,
            created_at, updated_at, paid_at, cancelled_at, cancel_reason
        FROM orders 
        WHERE status = ? 
        ORDER BY created_at DESC
        """;

        List<Order> orders = new ArrayList<>();

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, status);
            ResultSet rs = st.executeQuery();

            while (rs.next()) orders.add(mapResultSetToOrder(rs));
        }

        return orders;
    }

    public List<Order> getAllOrdersForAdmin() throws Exception {
        String sql = """
        SELECT 
            id, user_id, fullname, phone, address, tracking_number, note,
            total_amount, shipping_fee, discount_amount, final_amount,
            status, payment_method, ewallet_type, payment_status,
            created_at, updated_at, paid_at, cancelled_at, cancel_reason
        FROM orders
        ORDER BY created_at DESC
        """;

        List<Order> orders = new ArrayList<>();

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            ResultSet rs = st.executeQuery();

            while (rs.next()) orders.add(mapResultSetToOrder(rs));
        }

        return orders;
    }

    public boolean updateOrderStatusByAdmin(int orderId, String status, String trackingNumber) throws Exception {
        String sql = """
        UPDATE orders 
        SET status = ?, 
            tracking_number = ?, 
            updated_at = NOW() 
        WHERE id = ?
        """;

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, status);
            st.setString(2, trackingNumber);
            st.setInt(3, orderId);

            return st.executeUpdate() > 0;
        }
    }

    public boolean updatePaymentStatusByAdmin(int orderId, String paymentStatus) throws Exception {
        String sql = """
        UPDATE orders 
        SET payment_status = ?, 
            paid_at = CASE WHEN ? = 'PAID' THEN NOW() ELSE paid_at END,
            updated_at = NOW() 
        WHERE id = ?
        """;

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, paymentStatus);
            st.setString(2, paymentStatus);
            st.setInt(3, orderId);

            return st.executeUpdate() > 0;
        }
    }
    /**
     * Tổng doanh thu trong khoảng thời gian
     */
    public double getTotalRevenue(LocalDate startDate, LocalDate endDate) throws Exception {
        String sql = """
            SELECT COALESCE(SUM(total_amount), 0) AS total
            FROM orders
            WHERE status = 'delivered'
            AND DATE(created_at) BETWEEN ? AND ?
        """;

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setDate(1, Date.valueOf(startDate));
            st.setDate(2, Date.valueOf(endDate));

            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("total");
                }
            }
        }
        return 0.0;
    }

    /**
     * Tổng đơn hàng trong khoảng thời gian
     */
    public int getTotalOrders(LocalDate startDate, LocalDate endDate) throws Exception {
        String sql = """
            SELECT COUNT(*) AS total
            FROM orders
            WHERE status = 'delivered'
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

    /**
     * Tổng sản phẩm đã bán
     */
    public int getTotalProductsSold(LocalDate startDate, LocalDate endDate) throws Exception {
        String sql = """
            SELECT COALESCE(SUM(oi.quantity), 0) AS total
            FROM order_items oi
            JOIN orders o ON oi.order_id = o.id
            WHERE o.status = 'delivered'
            AND DATE(o.created_at) BETWEEN ? AND ?
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

    /**
     * Doanh thu theo ngày
     */
    public List<Map<String, Object>> getDailyRevenue(LocalDate startDate, LocalDate endDate) throws Exception {
        String sql = """
            SELECT 
                DATE_FORMAT(created_at, '%d/%m') AS date,
                COALESCE(SUM(total_amount), 0) AS revenue
            FROM orders
            WHERE status = 'delivered'
            AND DATE(created_at) BETWEEN ? AND ?
            GROUP BY DATE(created_at)
            ORDER BY DATE(created_at)
        """;

        List<Map<String, Object>> result = new ArrayList<>();

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setDate(1, Date.valueOf(startDate));
            st.setDate(2, Date.valueOf(endDate));

            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("date", rs.getString("date"));
                    row.put("revenue", rs.getDouble("revenue"));
                    result.add(row);
                }
            }
        }

        return result;
    }

    /**
     * Top sản phẩm bán chạy
     */
    public List<Map<String, Object>> getTopSellingProducts(LocalDate startDate, LocalDate endDate, int limit) throws Exception {
        String sql = """
            SELECT 
                p.id,
                p.name,
                SUM(oi.quantity) AS quantity,
                SUM(oi.quantity * oi.price) AS revenue
            FROM order_items oi
            JOIN products p ON oi.product_id = p.id
            JOIN orders o ON oi.order_id = o.id
            WHERE o.status = 'delivered'
            AND DATE(o.created_at) BETWEEN ? AND ?
            GROUP BY p.id, p.name
            ORDER BY quantity DESC
            LIMIT ?
        """;

        List<Map<String, Object>> result = new ArrayList<>();

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setDate(1, Date.valueOf(startDate));
            st.setDate(2, Date.valueOf(endDate));
            st.setInt(3, limit);

            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("id", rs.getInt("id"));
                    row.put("name", rs.getString("name"));
                    row.put("quantity", rs.getInt("quantity"));
                    row.put("revenue", rs.getDouble("revenue"));
                    result.add(row);
                }
            }
        }

        return result;
    }

    /**
     * Top khách hàng
     */
    public List<Map<String, Object>> getTopCustomers(LocalDate startDate, LocalDate endDate, int limit) throws Exception {
        String sql = """
            SELECT 
                u.id,
                u.full_name AS name,
                COUNT(o.id) AS orders,
                COALESCE(SUM(o.total_amount), 0) AS total
            FROM orders o
            JOIN users u ON o.user_id = u.id
            WHERE o.status = 'delivered'
            AND DATE(o.created_at) BETWEEN ? AND ?
            GROUP BY u.id, u.full_name
            ORDER BY total DESC
            LIMIT ?
        """;

        List<Map<String, Object>> result = new ArrayList<>();

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setDate(1, Date.valueOf(startDate));
            st.setDate(2, Date.valueOf(endDate));
            st.setInt(3, limit);

            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("id", rs.getInt("id"));
                    row.put("name", rs.getString("name"));
                    row.put("orders", rs.getInt("orders"));
                    row.put("total", rs.getDouble("total"));
                    result.add(row);
                }
            }
        }

        return result;
    }

    /**
     * Số lượng đơn hàng theo trạng thái
     */
    public Map<String, Integer> getOrderCountByStatus(LocalDate startDate, LocalDate endDate) throws Exception {
        String sql = """
            SELECT 
                status,
                COUNT(*) AS count
            FROM orders
            WHERE DATE(created_at) BETWEEN ? AND ?
            GROUP BY status
        """;

        Map<String, Integer> result = new HashMap<>();

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setDate(1, Date.valueOf(startDate));
            st.setDate(2, Date.valueOf(endDate));

            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    result.put(rs.getString("status"), rs.getInt("count"));
                }
            }
        }

        return result;
    }
}
