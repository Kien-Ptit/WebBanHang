package Dal;

import Model.Cart;
import Model.CartItem;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

public class CartDAO extends DBContext {

    public boolean clearCartByUserId(int userId) throws Exception {
        String sql = "DELETE FROM cart WHERE user_id = ?";

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected >= 0;
        }
    }

    /**
     * ✅ LẤY GIỎ HÀNG - HIỂN THỊ ĐẦY ĐỦ SIZE VÀ COLOR
     */
    public List<CartItem> getCartByUserId(int userId) {
        List<CartItem> list = new ArrayList<>();
        String sql = "SELECT c.id, c.product_id, c.quantity, "
                + "       c.size, c.color, "
                + "       p.name, p.image_url, "
                + "       COALESCE(p.discount_price, p.price) AS eff_price "
                + "FROM cart c "
                + "JOIN products p ON p.id = c.product_id "
                + "WHERE c.user_id = ? "
                + "ORDER BY c.id";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    int productId = rs.getInt("product_id");
                    BigDecimal price = rs.getBigDecimal("eff_price");

                    CartItem it = new CartItem(
                            productId,
                            rs.getString("name"),
                            rs.getString("image_url"),
                            price,
                            rs.getInt("quantity")
                    );
                    it.setSize(rs.getString("size"));
                    it.setColor(rs.getString("color")); // ✅ ĐỌC COLOR TỪ DB

                    list.add(it);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Cart loadCartForUser(int userId) {
        Cart cart = new Cart();
        List<CartItem> items = getCartByUserId(userId);
        for (CartItem item : items) {
            cart.add(item);
        }
        return cart;
    }

    /**
     * ✅ THÊM/CẬP NHẬT GIỎ HÀNG - BẮT BUỘC CÓ SIZE VÀ COLOR
     */
    public void addOrUpdateBySize(int userId, int productId, String size, String color, int qty) {
        if (size != null) size = size.trim().toUpperCase();
        if (color != null) color = color.trim();

        // ✅ KIỂM TRA DỰA TRÊN CẢ SIZE VÀ COLOR
        String check = "SELECT id, quantity FROM cart "
                + "WHERE user_id=? AND product_id=? AND size=? AND color=?";

        try (PreparedStatement st = connection.prepareStatement(check)) {
            st.setInt(1, userId);
            st.setInt(2, productId);
            st.setString(3, size);
            st.setString(4, color);

            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    // ✅ ĐÃ TỒN TẠI -> CỘNG DỒN
                    int id = rs.getInt("id");
                    int newQty = rs.getInt("quantity") + qty;

                    String update = "UPDATE cart SET quantity=? WHERE id=?";
                    try (PreparedStatement up = connection.prepareStatement(update)) {
                        up.setInt(1, newQty);
                        up.setInt(2, id);
                        up.executeUpdate();
                    }
                } else {
                    // ✅ CHƯA TỒN TẠI -> INSERT MỚI (CÓ COLOR)
                    String insert = "INSERT INTO cart(user_id, product_id, quantity, size, color) VALUES(?,?,?,?,?)";
                    try (PreparedStatement ins = connection.prepareStatement(insert)) {
                        ins.setInt(1, userId);
                        ins.setInt(2, productId);
                        ins.setInt(3, qty);
                        ins.setString(4, size);
                        ins.setString(5, color);
                        ins.executeUpdate();
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * ✅ CẬP NHẬT SỐ LƯỢNG - DỰA TRÊN SIZE VÀ COLOR
     */
    public void setQtyBySize(int userId, int productId, String size, int qty) {
        if (size != null) size = size.trim().toUpperCase();

        if (qty <= 0) {
            removeBySize(userId, productId, size);
            return;
        }

        String sql = "UPDATE cart SET quantity=? "
                + "WHERE user_id=? AND product_id=? AND size=?";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, qty);
            st.setInt(2, userId);
            st.setInt(3, productId);
            st.setString(4, size);
            st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * ✅ XÓA ITEM - DỰA TRÊN SIZE VÀ COLOR
     */
    public void removeBySize(int userId, int productId, String size) {
        if (size != null) size = size.trim().toUpperCase();

        String sql = "DELETE FROM cart WHERE user_id=? AND product_id=? AND size=?";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            st.setInt(2, productId);
            st.setString(3, size);
            st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public BigDecimal getTotalAmount(int userId) {
        String sql = "SELECT SUM(c.quantity * COALESCE(p.discount_price, p.price)) "
                + "FROM cart c "
                + "JOIN products p ON p.id = c.product_id "
                + "WHERE c.user_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    BigDecimal v = rs.getBigDecimal(1);
                    return v == null ? BigDecimal.ZERO : v;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }

    // Giữ nguyên các method khác...
    public void removeByVariant(int userId, int variantId) {
        String sql = "DELETE FROM cart WHERE user_id=? AND variant_id=?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            st.setInt(2, variantId);
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void setQtyByVariant(int userId, int variantId, int qty) {
        if (qty <= 0) {
            removeByVariant(userId, variantId);
            return;
        }
        String sql = "UPDATE cart SET quantity=? WHERE user_id=? AND variant_id=?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, qty);
            st.setInt(2, userId);
            st.setInt(3, variantId);
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}