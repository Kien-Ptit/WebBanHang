package Dal;

import java.sql.*;
import java.util.*;

public class ReviewDAO extends DBContext {

    public Map<String, Object> getSummary(int productId) {
        String sql = """
            SELECT 
                COUNT(*)               AS total,
                ROUND(AVG(rating), 2)  AS avg_rating,
                SUM(CASE WHEN rating=5 THEN 1 ELSE 0 END) AS star5,
                SUM(CASE WHEN rating=4 THEN 1 ELSE 0 END) AS star4,
                SUM(CASE WHEN rating=3 THEN 1 ELSE 0 END) AS star3,
                SUM(CASE WHEN rating=2 THEN 1 ELSE 0 END) AS star2,
                SUM(CASE WHEN rating=1 THEN 1 ELSE 0 END) AS star1
            FROM product_reviews
            WHERE product_id=? AND status='approved'
        """;
        Map<String, Object> m = new HashMap<>();
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, productId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    m.put("total", rs.getInt("total"));
                    m.put("avg", rs.getDouble("avg_rating"));
                    m.put("star5", rs.getInt("star5"));
                    m.put("star4", rs.getInt("star4"));
                    m.put("star3", rs.getInt("star3"));
                    m.put("star2", rs.getInt("star2"));
                    m.put("star1", rs.getInt("star1"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return m;
    }

    /**
     * ✅ List reviews - CÓ FILTER THEO RATING
     */
    public List<Map<String, Object>> listByProduct(int productId, Integer filterRating, int limit, int offset) {
        StringBuilder sql = new StringBuilder("""
            SELECT r.id, r.rating, r.title, r.comment, r.created_at, r.is_verified_purchase,
                   u.username, u.avatar
            FROM product_reviews r
            JOIN users u ON u.id = r.user_id
            WHERE r.product_id=? AND r.status='approved'
        """);

        // ✅ FILTER THEO RATING NẾU CÓ
        if (filterRating != null && filterRating >= 1 && filterRating <= 5) {
            sql.append(" AND r.rating=?");
        }

        sql.append(" ORDER BY r.created_at DESC LIMIT ? OFFSET ?");

        List<Map<String, Object>> list = new ArrayList<>();
        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            st.setInt(paramIndex++, productId);

            if (filterRating != null && filterRating >= 1 && filterRating <= 5) {
                st.setInt(paramIndex++, filterRating);
            }

            st.setInt(paramIndex++, limit);
            st.setInt(paramIndex, offset);

            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> r = new HashMap<>();
                    int reviewId = rs.getInt("id");

                    r.put("id", reviewId);
                    r.put("rating", rs.getInt("rating"));
                    r.put("title", rs.getString("title"));
                    r.put("comment", rs.getString("comment"));
                    r.put("created_at", rs.getTimestamp("created_at"));
                    r.put("is_verified_purchase", rs.getInt("is_verified_purchase") == 1);
                    r.put("username", rs.getString("username"));
                    r.put("avatar", rs.getString("avatar"));

                    // ✅ LẤY HÌNH ẢNH CỦA REVIEW
                    r.put("images", getReviewImages(reviewId));

                    // ✅ LẤY REPLIES
                    r.put("replies", getReviewReplies(reviewId));

                    list.add(r);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * ✅ LẤY DANH SÁCH HÌNH ẢNH CỦA 1 REVIEW
     */
    public List<String> getReviewImages(int reviewId) {
        String sql = "SELECT image_url FROM review_images WHERE review_id=? ORDER BY display_order";
        List<String> images = new ArrayList<>();
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, reviewId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    images.add(rs.getString("image_url"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return images;
    }

    /**
     * ✅ LẤY REPLIES CỦA 1 REVIEW
     */
    public List<Map<String, Object>> getReviewReplies(int reviewId) {
        String sql = """
            SELECT rr.id, rr.reply_text, rr.is_admin_reply, rr.created_at,
                   u.username, u.avatar
            FROM review_replies rr
            JOIN users u ON u.id = rr.user_id
            WHERE rr.review_id=?
            ORDER BY rr.created_at ASC
        """;
        List<Map<String, Object>> replies = new ArrayList<>();
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, reviewId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> reply = new HashMap<>();
                    reply.put("id", rs.getInt("id"));
                    reply.put("reply_text", rs.getString("reply_text"));
                    reply.put("is_admin_reply", rs.getInt("is_admin_reply") == 1);
                    reply.put("created_at", rs.getTimestamp("created_at"));
                    reply.put("username", rs.getString("username"));
                    reply.put("avatar", rs.getString("avatar"));
                    replies.add(reply);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return replies;
    }

    /**
     * ✅ THÊM REPLY VÀO REVIEW
     */
    public void addReply(int reviewId, int userId, String replyText, boolean isAdminReply) throws SQLException {
        String sql = "INSERT INTO review_replies (review_id, user_id, reply_text, is_admin_reply) VALUES (?,?,?,?)";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, reviewId);
            st.setInt(2, userId);
            st.setString(3, replyText);
            st.setInt(4, isAdminReply ? 1 : 0);
            st.executeUpdate();
        }
    }
    /**
     * ✅ THÊM HÌNH ẢNH VÀO REVIEW (CÓ DESCRIPTION)
     */
    public void addReviewImage(int reviewId, String imageUrl, int displayOrder) throws SQLException {
        String sql = "INSERT INTO review_images (review_id, image_url, display_order, image_description) VALUES (?,?,?,?)";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, reviewId);
            st.setString(2, imageUrl);
            st.setInt(3, displayOrder);
            st.setString(4, "Review image " + (displayOrder + 1)); // ✅ THÊM DESCRIPTION

            int rows = st.executeUpdate();
            System.out.println("Image inserted into DB: " + imageUrl + " (rows affected: " + rows + ")");
        }
    }

    public boolean isVerifiedPurchase(int userId, int productId) {
        String sql = """
            SELECT 1
            FROM order_detail od 
            JOIN orders o ON o.id = od.order_id
            WHERE o.user_id=? AND od.product_id=?
            LIMIT 1
        """;
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            st.setInt(2, productId);
            try (ResultSet rs = st.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * ✅ UPSERT REVIEW (TRẢ VỀ REVIEW_ID)
     */
    public int upsertReview(int productId, int userId, int rating, String title, String comment, boolean verified)
            throws SQLException {
        String sql = """
            INSERT INTO product_reviews (product_id, user_id, rating, title, comment, is_verified_purchase, status)
            VALUES (?,?,?,?,?,?, 'approved')
            ON DUPLICATE KEY UPDATE
                rating=VALUES(rating),
                title=VALUES(title),
                comment=VALUES(comment),
                is_verified_purchase=VALUES(is_verified_purchase),
                status='approved',
                updated_at=NOW()
        """;
        try (PreparedStatement st = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            st.setInt(1, productId);
            st.setInt(2, userId);
            st.setInt(3, rating);
            st.setString(4, title);
            st.setString(5, comment);
            st.setInt(6, verified ? 1 : 0);
            st.executeUpdate();

            // Lấy review_id
            try (ResultSet rs = st.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

            // Nếu là update thì lấy ID hiện tại
            String getIdSql = "SELECT id FROM product_reviews WHERE user_id=? AND product_id=?";
            try (PreparedStatement ps = connection.prepareStatement(getIdSql)) {
                ps.setInt(1, userId);
                ps.setInt(2, productId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt("id");
                    }
                }
            }
        }
        return -1;
    }
}
