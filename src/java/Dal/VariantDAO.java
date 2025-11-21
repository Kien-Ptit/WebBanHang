package Dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VariantDAO extends DBContext {

    public static class VariantRow {
        public final int id, productId;
        public final String size, color;
        public final Integer stock;
        public final java.math.BigDecimal price; // hiệu lực: override or product price

        public VariantRow(int id, int productId, String size, String color, Integer stock, java.math.BigDecimal price) {
            this.id = id; this.productId = productId; this.size = size; this.color = color; this.stock = stock; this.price = price;
        }
    }

    /** Danh sách biến thể (có giá hiệu lực: price_override hoặc products.price/discount_price) */
    public List<VariantRow> listByProductId(int productId) {
        List<VariantRow> list = new ArrayList<>();
        String sql =
            "SELECT v.id, v.product_id, v.size, v.color, v.stock_quantity, " +
            "       COALESCE(v.price_override, p.discount_price, p.price) AS eff_price " +
            "FROM product_variants v JOIN products p ON p.id = v.product_id " +
            "WHERE v.product_id = ? ORDER BY v.size, v.color";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, productId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(new VariantRow(
                        rs.getInt("id"),
                        rs.getInt("product_id"),
                        rs.getString("size"),
                        rs.getString("color"),
                        (Integer) rs.getObject("stock_quantity"),
                        rs.getBigDecimal("eff_price")
                    ));
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public VariantRow findById(int variantId) {
        String sql =
            "SELECT v.id, v.product_id, v.size, v.color, v.stock_quantity, " +
            "       COALESCE(v.price_override, p.discount_price, p.price) AS eff_price " +
            "FROM product_variants v JOIN products p ON p.id = v.product_id " +
            "WHERE v.id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, variantId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return new VariantRow(
                        rs.getInt("id"),
                        rs.getInt("product_id"),
                        rs.getString("size"),
                        rs.getString("color"),
                        (Integer) rs.getObject("stock_quantity"),
                        rs.getBigDecimal("eff_price")
                    );
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }
}
