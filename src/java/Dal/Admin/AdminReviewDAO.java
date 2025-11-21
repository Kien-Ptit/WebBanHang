package Dal.Admin;

import Dal.DBContext;
import Model.Review;
import Model.User;
import Model.Product;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Admin Review DAO - Quản lý reviews từ admin
 * Database: product_reviews, review_replies, review_images
 * @author Kien-Ptit
 */
public class AdminReviewDAO extends DBContext {

    /**
     * Lấy tất cả reviews cho admin với filter
     */
    public List<Review> getAllReviewsForAdmin(String status, String rating, String search) throws Exception {
        StringBuilder sql = new StringBuilder("""
            SELECT 
                pr.id,
                pr.product_id,
                pr.user_id,
                pr.rating,
                pr.title,
                pr.comment,
                pr.is_verified_purchase,
                pr.status,
                pr.created_at,
                pr.updated_at,
                u.full_name AS user_name,
                u.email AS user_email,
                p.name AS product_name,
                p.thumbnail AS product_image,
                (SELECT COUNT(*) FROM review_images WHERE review_id = pr.id) AS image_count,
                (SELECT COUNT(*) FROM review_replies WHERE review_id = pr.id) AS reply_count
            FROM product_reviews pr
            JOIN users u ON pr.user_id = u.id
            JOIN products p ON pr.product_id = p.id
            WHERE 1=1
        """);

        // Filter theo status
        if (status != null && !status.isEmpty()) {
            sql.append(" AND pr.status = ?");
        }

        // Filter theo rating
        if (rating != null && !rating.isEmpty()) {
            sql.append(" AND pr.rating = ?");
        }

        // Search theo user name, product name, comment
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (u.full_name LIKE ? OR p.name LIKE ? OR pr.comment LIKE ? OR pr.title LIKE ?)");
        }

        sql.append(" ORDER BY pr.created_at DESC");

        List<Review> reviews = new ArrayList<>();

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            int paramIndex = 1;

            if (status != null && !status.isEmpty()) {
                st.setString(paramIndex++, status);
            }

            if (rating != null && !rating.isEmpty()) {
                st.setInt(paramIndex++, Integer.parseInt(rating));
            }

            if (search != null && !search.trim().isEmpty()) {
                String searchPattern = "%" + search.trim() + "%";
                st.setString(paramIndex++, searchPattern);
                st.setString(paramIndex++, searchPattern);
                st.setString(paramIndex++, searchPattern);
                st.setString(paramIndex++, searchPattern);
            }

            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Review review = new Review();
                    review.setId(rs.getInt("id"));
                    review.setProductId(rs.getInt("product_id"));
                    review.setUserId(rs.getInt("user_id"));
                    review.setRating(rs.getInt("rating"));
                    review.setTitle(rs.getString("title"));
                    review.setComment(rs.getString("comment"));
                    review.setIsVerifiedPurchase(rs.getBoolean("is_verified_purchase"));
                    review.setStatus(rs.getString("status"));
                    review.setCreatedAt(rs.getTimestamp("created_at"));
                    review.setUpdatedAt(rs.getTimestamp("updated_at"));
                    review.setImageCount(rs.getInt("image_count"));
                    review.setReplyCount(rs.getInt("reply_count"));

                    // Set user info
                    User user = new User();
                    user.setFullname(rs.getString("user_name"));
                    user.setEmail(rs.getString("user_email"));
                    review.setUser(user);

                    // Set product info
                    Product product = new Product();
                    product.setName(rs.getString("product_name"));
                    product.setImage(rs.getString("product_image"));
                    review.setProduct(product);

                    reviews.add(review);
                }
            }
        }

        return reviews;
    }

    /**
     * Duyệt review (approve) - Chuyển từ pending sang approved
     */
    public boolean approveReview(int reviewId) throws Exception {
        String sql = "UPDATE product_reviews SET status = 'approved', updated_at = NOW() WHERE id = ?";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, reviewId);
            int rows = st.executeUpdate();
            
            System.out.println("✅ Approved review ID: " + reviewId + ", Rows: " + rows);
            
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("❌ Error approving review: " + e.getMessage());
            throw e;
        }
    }

    /**
     * Từ chối review (reject)
     */
    public boolean rejectReview(int reviewId) throws Exception {
        String sql = "UPDATE product_reviews SET status = 'rejected', updated_at = NOW() WHERE id = ?";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, reviewId);
            int rows = st.executeUpdate();
            
            System.out.println("❌ Rejected review ID: " + reviewId + ", Rows: " + rows);
            
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("❌ Error rejecting review: " + e.getMessage());
            throw e;
        }
    }

    /**
     * Xóa review (cascade delete images và replies)
     */
    public boolean deleteReview(int reviewId) throws Exception {
        // Xóa images trước
        String deleteImages = "DELETE FROM review_images WHERE review_id = ?";
        // Xóa replies
        String deleteReplies = "DELETE FROM review_replies WHERE review_id = ?";
        // Xóa review
        String deleteReview = "DELETE FROM product_reviews WHERE id = ?";

        try {
            connection.setAutoCommit(false);

            try (PreparedStatement st1 = connection.prepareStatement(deleteImages);
                 PreparedStatement st2 = connection.prepareStatement(deleteReplies);
                 PreparedStatement st3 = connection.prepareStatement(deleteReview)) {

                st1.setInt(1, reviewId);
                st1.executeUpdate();

                st2.setInt(1, reviewId);
                st2.executeUpdate();

                st3.setInt(1, reviewId);
                int rows = st3.executeUpdate();

                connection.commit();
                
                System.out.println("🗑️ Deleted review ID: " + reviewId + " (with images and replies)");
                
                return rows > 0;
            }
        } catch (SQLException e) {
            connection.rollback();
            System.err.println("❌ Error deleting review: " + e.getMessage());
            throw e;
        } finally {
            connection.setAutoCommit(true);
        }
    }

    /**
     * Thêm phản hồi từ admin
     */
    public boolean addAdminReply(int reviewId, String reply, int adminId) throws Exception {
        String sql = """
            INSERT INTO review_replies (review_id, user_id, reply_text, is_admin_reply, created_at, updated_at)
            VALUES (?, ?, ?, 1, NOW(), NOW())
        """;

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, reviewId);
            st.setInt(2, adminId);
            st.setString(3, reply);
            int rows = st.executeUpdate();
            
            System.out.println("💬 Added admin reply to review ID: " + reviewId + ", Admin ID: " + adminId);
            
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("❌ Error adding admin reply: " + e.getMessage());
            throw e;
        }
    }

    /**
     * Lấy tất cả replies của 1 review
     */
    public List<String> getReviewReplies(int reviewId) throws Exception {
        String sql = """
            SELECT 
                rr.reply_text,
                rr.is_admin_reply,
                rr.created_at,
                u.full_name AS user_name
            FROM review_replies rr
            JOIN users u ON rr.user_id = u.id
            WHERE rr.review_id = ?
            ORDER BY rr.created_at ASC
        """;

        List<String> replies = new ArrayList<>();

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, reviewId);

            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    String replyText = rs.getString("reply_text");
                    boolean isAdmin = rs.getBoolean("is_admin_reply");
                    String userName = rs.getString("user_name");
                    Timestamp createdAt = rs.getTimestamp("created_at");

                    String reply = String.format("[%s] %s: %s",
                            isAdmin ? "ADMIN" : "USER",
                            userName,
                            replyText);

                    replies.add(reply);
                }
            }
        }

        return replies;
    }

    /**
     * Lấy tất cả images của 1 review
     */
    public List<String> getReviewImages(int reviewId) throws Exception {
        String sql = "SELECT image_url FROM review_images WHERE review_id = ? ORDER BY id";

        List<String> images = new ArrayList<>();

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, reviewId);

            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    images.add(rs.getString("image_url"));
                }
            }
        }

        return images;
    }

    /**
     * Tổng số reviews
     */
    public int getTotalReviews() throws Exception {
        String sql = "SELECT COUNT(*) AS total FROM product_reviews";

        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        }
        return 0;
    }

    /**
     * Số reviews đang chờ duyệt
     */
    public int getPendingReviews() throws Exception {
        String sql = "SELECT COUNT(*) AS total FROM product_reviews WHERE status = 'pending'";

        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        }
        return 0;
    }

    /**
     * Số reviews đã duyệt
     */
    public int getApprovedReviews() throws Exception {
        String sql = "SELECT COUNT(*) AS total FROM product_reviews WHERE status = 'approved'";

        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        }
        return 0;
    }

    /**
     * Đánh giá trung bình (chỉ approved)
     */
    public double getAverageRating() throws Exception {
        String sql = "SELECT COALESCE(AVG(rating), 0) AS avg_rating FROM product_reviews WHERE status = 'approved'";

        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                return Math.round(rs.getDouble("avg_rating") * 10.0) / 10.0;
            }
        }
        return 0.0;
    }

    /**
     * Lấy review theo ID (với đầy đủ thông tin)
     */
    public Review getReviewById(int id) throws Exception {
        String sql = """
            SELECT 
                pr.*,
                u.full_name AS user_name,
                u.email AS user_email,
                p.name AS product_name,
                p.thumbnail AS product_image
            FROM product_reviews pr
            JOIN users u ON pr.user_id = u.id
            JOIN products p ON pr.product_id = p.id
            WHERE pr.id = ?
        """;

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, id);

            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    Review review = new Review();
                    review.setId(rs.getInt("id"));
                    review.setProductId(rs.getInt("product_id"));
                    review.setUserId(rs.getInt("user_id"));
                    review.setRating(rs.getInt("rating"));
                    review.setTitle(rs.getString("title"));
                    review.setComment(rs.getString("comment"));
                    review.setIsVerifiedPurchase(rs.getBoolean("is_verified_purchase"));
                    review.setStatus(rs.getString("status"));
                    review.setCreatedAt(rs.getTimestamp("created_at"));
                    review.setUpdatedAt(rs.getTimestamp("updated_at"));

                    // Set user info
                    User user = new User();
                    user.setFullname(rs.getString("user_name"));
                    user.setEmail(rs.getString("user_email"));
                    review.setUser(user);

                    // Set product info
                    Product product = new Product();
                    product.setName(rs.getString("product_name"));
                    product.setImage(rs.getString("product_image"));
                    review.setProduct(product);

                    // Load images
                    review.setImages(getReviewImages(id));

                    // Load replies
                    review.setReplies(getReviewReplies(id));

                    return review;
                }
            }
        }

        return null;
    }
}