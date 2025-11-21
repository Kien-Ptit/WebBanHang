package Dal.Admin;

import Dal.DBContext;
import Model.Order;
import java.sql.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * DAO riêng cho Admin quản lý Orders
 * 
 * @author Kien-Ptit
 * @version 1.0
 * @since 2025-10-25
 */
public class AdminOrderDAO extends DBContext {

    /**
     * Lấy tất cả đơn hàng
     */
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

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                orders.add(mapResultSetToOrder(rs));
            }
        }

        return orders;
    }

    /**
     * Tìm đơn hàng theo ID
     */
    public Order findOrderById(int orderId) throws Exception {
        String sql = """
            SELECT 
                id, user_id, fullname, phone, address, tracking_number, note,
                total_amount, shipping_fee, discount_amount, final_amount,
                status, payment_method, ewallet_type, payment_status,
                created_at, updated_at, paid_at, cancelled_at, cancel_reason
            FROM orders
            WHERE id = ?
        """;

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, orderId);
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                return mapResultSetToOrder(rs);
            }
        }

        return null;
    }

    /**
     * Lấy items của đơn hàng
     */
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

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, orderId);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                items.add(mapResultSetToOrderItem(rs));
            }
        }

        return items;
    }

    /**
     * Tìm kiếm đơn hàng
     */
    public List<Order> searchOrders(String keyword) throws Exception {
        String sql = """
            SELECT 
                id, user_id, fullname, phone, address, tracking_number, note,
                total_amount, shipping_fee, discount_amount, final_amount,
                status, payment_method, ewallet_type, payment_status,
                created_at, updated_at, paid_at,  
                cancelled_at, cancel_reason
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

            while (rs.next()) {
                orders.add(mapResultSetToOrder(rs));
            }
        }

        return orders;
    }

    /**
     * Lấy đơn theo status
     */
    public List<Order> getOrdersByStatus(String status) throws Exception {
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

            while (rs.next()) {
                orders.add(mapResultSetToOrder(rs));
            }
        }

        return orders;
    }

    /**
     * Cập nhật trạng thái đơn hàng
     */
    public boolean updateOrderStatus(int orderId, String status, String trackingNumber) throws Exception {
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

    /**
     * Cập nhật trạng thái thanh toán
     */
    public boolean updatePaymentStatus(int orderId, String paymentStatus) throws Exception {
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
     * Đếm đơn pending
     */
    public int getPendingOrdersCount() throws Exception {
        String sql = "SELECT COUNT(*) FROM orders WHERE status = 'Pending'";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }
        }

        return 0;
    }

    /**
     * Đếm tổng đơn hàng
     */
    public int getTotalOrders() throws Exception {
        String sql = "SELECT COUNT(*) FROM orders";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }
        }

        return 0;
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
     * Đơn hàng gần đây
     */
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

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, limit);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                orders.add(mapResultSetToOrder(rs));
            }
        }

        return orders;
    }

    /**
     * Map ResultSet sang Order
     */
    private Order mapResultSetToOrder(ResultSet rs) throws SQLException {
        Order order = new Order();

        order.setId(rs.getInt("id"));

        int userId = rs.getInt("user_id");
        if (!rs.wasNull()) {
            order.setUserId(userId);
        }

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

    /**
     * Map ResultSet sang OrderItem
     */
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
}