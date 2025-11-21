package Controller.Products;

import Dal.ProductDAO;
import Dal.ReviewDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.nio.file.*;
import java.util.*;

@WebServlet(name = "DetailServlet", urlPatterns = {"/detail"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class DetailServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads/reviews";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idParam = req.getParameter("id");
        String filterRatingParam = req.getParameter("filterRating"); // ✅ FILTER RATING

        if (idParam == null || idParam.trim().isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing product ID");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid product ID");
            return;
        }

        Integer filterRating = null;
        if (filterRatingParam != null && !filterRatingParam.isEmpty()) {
            try {
                filterRating = Integer.parseInt(filterRatingParam);
            } catch (NumberFormatException ignored) {
            }
        }

        try {
            ProductDAO pdao = new ProductDAO();
            ReviewDAO rdao = new ReviewDAO();

            Map<String, Object> product = pdao.findById(id);
            if (product == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Product not found");
                return;
            }

            pdao.increaseViews(id);

            List<String> sizes = splitCsv((String) product.get("size"));
            List<String> colors = splitCsv((String) product.get("color"));

            List<Map<String, Object>> related = pdao.getProductsByCategory(
                    (int) product.get("category_id"), 8);

            Map<String, Object> summary = rdao.getSummary(id);
            List<Map<String, Object>> reviews = rdao.listByProduct(id, filterRating, 10, 0); // ✅ FILTER

            req.setAttribute("product", product);
            req.setAttribute("sizes", sizes);
            req.setAttribute("colors", colors);
            req.setAttribute("relatedProducts", related);
            req.setAttribute("reviewSummary", summary);
            req.setAttribute("reviews", reviews);
            req.setAttribute("filterRating", filterRating); // ✅ GỬI LẠI FILTER

            HttpSession ss = req.getSession(false);
            if (ss != null && ss.getAttribute("flash") != null) {
                req.setAttribute("flash", ss.getAttribute("flash"));
                ss.removeAttribute("flash");
            }

            req.getRequestDispatcher("/detail.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error loading product details", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        String idParam = req.getParameter("id");

        if (idParam == null || idParam.trim().isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing product ID");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid product ID");
            return;
        }

        // ✅ XỬ LÝ THÊM REVIEW
        if ("addReview".equals(action)) {
            handleAddReview(req, resp, id);
            return;
        }

        // ✅ XỬ LÝ THÊM REPLY
        if ("addReply".equals(action)) {
            handleAddReply(req, resp, id);
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/detail?id=" + id);
    }

    /**
     * ✅ XỬ LÝ THÊM REVIEW VỚI UPLOAD HÌNH ẢNH
     */
    private void handleAddReview(HttpServletRequest req, HttpServletResponse resp, int productId)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        String ratingParam = req.getParameter("rating");
        String title = req.getParameter("title");
        String comment = req.getParameter("comment");

        if (ratingParam == null || comment == null || comment.trim().isEmpty()) {
            session.setAttribute("flash", "Vui lòng nhập đầy đủ thông tin đánh giá!");
            resp.sendRedirect(req.getContextPath() + "/detail?id=" + productId + "#tabs");
            return;
        }

        int rating;
        try {
            rating = Integer.parseInt(ratingParam);
            if (rating < 1 || rating > 5) {
                throw new NumberFormatException();
            }
        } catch (NumberFormatException e) {
            session.setAttribute("flash", "Đánh giá không hợp lệ!");
            resp.sendRedirect(req.getContextPath() + "/detail?id=" + productId + "#tabs");
            return;
        }

        try {
            ReviewDAO rdao = new ReviewDAO();
            boolean verified = rdao.isVerifiedPurchase(userId, productId);

            // ✅ THÊM REVIEW VÀ LẤY REVIEW_ID
            int reviewId = rdao.upsertReview(productId, userId, rating,
                    title != null ? title.trim() : "",
                    comment.trim(), verified);

            // ✅ XỬ LÝ UPLOAD NHIỀU HÌNH ẢNH
            if (reviewId > 0) {
                Collection<Part> fileParts = req.getParts();
                int displayOrder = 0;
                int uploadedCount = 0;
                final int MAX_IMAGES = 5;

                System.out.println("=== PROCESSING FILE PARTS ===");
                System.out.println("Total parts: " + fileParts.size());

                for (Part part : fileParts) {
                    System.out.println("Part name: " + part.getName() + ", Size: " + part.getSize() + ", Content-Type: " + part.getContentType());

                    // ✅ KIỂM TRA ĐÂY LÀ FILE UPLOAD VÀ CÓ DỮ LIỆU
                    if ("reviewImages".equals(part.getName()) && part.getSize() > 0) {

                        // Kiểm tra đã upload đủ 5 ảnh chưa
                        if (uploadedCount >= MAX_IMAGES) {
                            System.out.println("Reached max images limit: " + MAX_IMAGES);
                            break;
                        }

                        String fileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                        System.out.println("Processing file: " + fileName);

                        // Validate file type
                        String contentType = part.getContentType();
                        if (contentType == null || !contentType.startsWith("image/")) {
                            System.out.println("Skipping non-image file: " + fileName);
                            continue;
                        }

                        // Tạo thư mục uploads nếu chưa có
                        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
                        File uploadDir = new File(uploadPath);
                        if (!uploadDir.exists()) {
                            uploadDir.mkdirs();
                            System.out.println("Created upload directory: " + uploadPath);
                        }

                        // Tạo tên file unique
                        String fileExtension = fileName.substring(fileName.lastIndexOf("."));
                        String uniqueFileName = System.currentTimeMillis() + "_" + uploadedCount + fileExtension;
                        String filePath = uploadPath + File.separator + uniqueFileName;

                        // Lưu file
                        part.write(filePath);
                        System.out.println("File saved to: " + filePath);

                        // Lưu vào DB với image_url
                        String imageUrl = req.getContextPath() + "/" + UPLOAD_DIR + "/" + uniqueFileName;
                        rdao.addReviewImage(reviewId, imageUrl, displayOrder++);

                        uploadedCount++;
                        System.out.println("Image " + uploadedCount + " saved: " + imageUrl);
                    }
                }

                System.out.println("Total images uploaded: " + uploadedCount);
            }

            session.setAttribute("flash", "Đã gửi đánh giá thành công. Cảm ơn bạn!");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("flash", "Không thể gửi đánh giá. Vui lòng thử lại sau!");
        }

        resp.sendRedirect(req.getContextPath() + "/detail?id=" + productId + "#tabs");
    }

    /**
     * ✅ XỬ LÝ THÊM REPLY
     */
    private void handleAddReply(HttpServletRequest req, HttpServletResponse resp, int productId)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");

        String reviewIdParam = req.getParameter("reviewId");
        String replyText = req.getParameter("replyText");

        if (reviewIdParam == null || replyText == null || replyText.trim().isEmpty()) {
            session.setAttribute("flash", "Vui lòng nhập nội dung trả lời!");
            resp.sendRedirect(req.getContextPath() + "/detail?id=" + productId + "#reviews");
            return;
        }

        try {
            int reviewId = Integer.parseInt(reviewIdParam);
            ReviewDAO rdao = new ReviewDAO();

            boolean isAdmin = "admin".equalsIgnoreCase(role);
            rdao.addReply(reviewId, userId, replyText.trim(), isAdmin);

            session.setAttribute("flash", "Đã gửi phản hồi thành công!");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("flash", "Không thể gửi phản hồi. Vui lòng thử lại!");
        }

        resp.sendRedirect(req.getContextPath() + "/detail?id=" + productId + "#reviews");
    }

    private List<String> splitCsv(String s) {
        if (s == null || s.isBlank()) {
            return Collections.emptyList();
        }
        return Arrays.stream(s.split("[,;/]"))
                .map(String::trim)
                .filter(x -> !x.isEmpty())
                .toList();
    }
}
