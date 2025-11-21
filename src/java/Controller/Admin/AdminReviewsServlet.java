package Controller.Admin;

import Dal.Admin.AdminReviewDAO;
import Dal.ProductDAO;
import Model.User;
import Model.Review;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Admin Reviews Servlet - Quản lý đánh giá sản phẩm
 * @author Kien-Ptit
 */
@WebServlet(name = "AdminReviewsServlet", urlPatterns = {"/Admin/reviews"})
public class AdminReviewsServlet extends HttpServlet {

    private AdminReviewDAO reviewDAO;
    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        try {
            reviewDAO = new AdminReviewDAO();
            productDAO = new ProductDAO();
        } catch (Exception e) {
            throw new ServletException("Failed to initialize DAOs", e);
        }
    }

    /**
     * Kiểm tra user có phải admin không
     */
    private boolean isAdmin(User user) {
        return user != null && "admin".equals(user.getRole());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session == null) ? null : (User) session.getAttribute("user");

        if (!isAdmin(user)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        String idStr = request.getParameter("id");

        try {
            // ===== APPROVE REVIEW =====
            if ("approve".equals(action) && idStr != null) {
                int reviewId = Integer.parseInt(idStr);
                boolean approved = reviewDAO.approveReview(reviewId);

                if (approved) {
                    session.setAttribute("success", "✅ Đã duyệt đánh giá thành công!");
                } else {
                    session.setAttribute("error", "❌ Không thể duyệt đánh giá!");
                }

                response.sendRedirect(request.getContextPath() + "/Admin/reviews");
                return;
            }

            // ===== REJECT REVIEW =====
            if ("reject".equals(action) && idStr != null) {
                int reviewId = Integer.parseInt(idStr);
                boolean rejected = reviewDAO.rejectReview(reviewId);

                if (rejected) {
                    session.setAttribute("success", "✅ Đã từ chối đánh giá thành công!");
                } else {
                    session.setAttribute("error", "❌ Không thể từ chối đánh giá!");
                }

                response.sendRedirect(request.getContextPath() + "/Admin/reviews");
                return;
            }

            // ===== DELETE REVIEW =====
            if ("delete".equals(action) && idStr != null) {
                int reviewId = Integer.parseInt(idStr);
                boolean deleted = reviewDAO.deleteReview(reviewId);

                if (deleted) {
                    session.setAttribute("success", "✅ Đã xóa đánh giá thành công!");
                } else {
                    session.setAttribute("error", "❌ Không thể xóa đánh giá!");
                }

                response.sendRedirect(request.getContextPath() + "/Admin/reviews");
                return;
            }

            // ===== GET ALL REVIEWS WITH FILTERS =====
            String statusFilter = request.getParameter("status");
            String ratingFilter = request.getParameter("rating");
            String searchQuery = request.getParameter("search");

            // Lấy danh sách reviews
            List<Review> reviews = reviewDAO.getAllReviewsForAdmin(statusFilter, ratingFilter, searchQuery);
            request.setAttribute("reviews", reviews);

            // Thống kê
            int totalReviews = reviewDAO.getTotalReviews();
            int pendingReviews = reviewDAO.getPendingReviews();
            int approvedReviews = reviewDAO.getApprovedReviews();
            double avgRating = reviewDAO.getAverageRating();

            request.setAttribute("totalReviews", totalReviews);
            request.setAttribute("pendingReviews", pendingReviews);
            request.setAttribute("approvedReviews", approvedReviews);
            request.setAttribute("avgRating", avgRating);

            // Gửi lại filter params
            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("ratingFilter", ratingFilter);
            request.setAttribute("searchQuery", searchQuery);

            request.getRequestDispatcher("/Admin/reviews.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "❌ Lỗi: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/Admin/reviews");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User user = (session == null) ? null : (User) session.getAttribute("user");

        if (!isAdmin(user)) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String action = request.getParameter("action");

        try {
            // ===== REPLY TO REVIEW =====
            if ("reply".equals(action)) {
                String reviewIdStr = request.getParameter("reviewId");
                String reply = request.getParameter("reply");

                if (reviewIdStr == null || reply == null || reply.trim().isEmpty()) {
                    session.setAttribute("error", "❌ Vui lòng nhập nội dung phản hồi!");
                } else {
                    int reviewId = Integer.parseInt(reviewIdStr);
                    boolean replied = reviewDAO.addAdminReply(reviewId, reply.trim(), user.getId());

                    if (replied) {
                        session.setAttribute("success", "✅ Đã gửi phản hồi thành công!");
                    } else {
                        session.setAttribute("error", "❌ Không thể gửi phản hồi!");
                    }
                }
            }

            response.sendRedirect(request.getContextPath() + "/Admin/reviews");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "❌ Lỗi: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/Admin/reviews");
        }
    }

    @Override
    public String getServletInfo() {
        return "Admin Reviews Servlet - Manage product reviews";
    }
}