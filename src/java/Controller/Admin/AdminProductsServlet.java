package Controller.Admin;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;
import jakarta.servlet.*;
import java.io.IOException;
import java.io.File;
import java.math.BigDecimal;
import java.util.List;

import Dal.Admin.AdminProductDAO;
import Dal.Admin.AdminCategoryDAO;
import Model.Product;
import Model.Category;
import Model.User;

/**
 * Admin Products Management Servlet
 *
 * @author Kien-Ptit
 * @version 4.0 FINAL - Khớp 100% với AdminProductDAO
 * @since 2025-10-31
 */
@WebServlet("/Admin/products")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class AdminProductsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final String UPLOAD_DIR = "uploads";
    private static final String[] ALLOWED_EXTENSIONS = {".jpg", ".jpeg", ".png", ".gif", ".webp"};

    // ==================== GET METHODS ====================
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Check authentication
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !isAdmin(user)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");

        try {
            if ("edit".equals(action)) {
                showEditForm(req, resp, session);
            } else if ("add".equals(action)) {
                showAddForm(req, resp, session);
            } else if ("delete".equals(action)) {
                deleteProduct(req, resp, session);
            } else if ("toggleFeatured".equals(action)) {
                toggleFeatured(req, resp, session);
            } else if ("toggleStatus".equals(action)) {
                toggleStatus(req, resp, session);
            } else {
                listProducts(req, resp, session);
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "❌ Có lỗi xảy ra: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/Admin/products");
        }
    }

    /**
     * Danh sách sản phẩm với filters
     */
    private void listProducts(HttpServletRequest req, HttpServletResponse resp, HttpSession session)
            throws ServletException, IOException {

        try {
            AdminProductDAO productDAO = new AdminProductDAO();
            AdminCategoryDAO categoryDAO = new AdminCategoryDAO();

            // Get filter parameters
            String search = req.getParameter("search");
            String categoryId = req.getParameter("category");
            String status = req.getParameter("status");
            String filter = req.getParameter("filter");

            // Get products - DÙNG ĐÚNG METHOD CỦA DAO
            List<Product> products;
            if ("lowstock".equals(filter)) {
                products = productDAO.getLowStockProducts();  // GỌI METHOD KHÔNG THAM SỐ
                req.setAttribute("filterType", "lowstock");
            } else if (search != null && !search.trim().isEmpty()) {
                products = productDAO.searchProducts(search.trim());
            } else if (categoryId != null && !categoryId.trim().isEmpty()) {
                products = productDAO.getProductsByCategory(Integer.parseInt(categoryId));
            } else if (status != null && !status.trim().isEmpty()) {
                products = productDAO.getProductsByStatus(status);
            } else {
                products = productDAO.getAllProducts();
            }

            // Statistics - DÙNG ĐÚNG METHOD CỦA DAO
            int totalProducts = productDAO.getTotalProducts();              // Tất cả
            int activeProducts = productDAO.getActiveProducts();            // Chỉ active
            List<Product> lowStockProducts = productDAO.getLowStockProducts(); // Default threshold = 10

            // Set attributes
            req.setAttribute("products", products);
            req.setAttribute("categories", categoryDAO.getAllCategories());
            req.setAttribute("searchQuery", search);
            req.setAttribute("selectedCategory", categoryId);
            req.setAttribute("selectedStatus", status);
            req.setAttribute("totalProducts", totalProducts);
            req.setAttribute("activeProducts", activeProducts);
            req.setAttribute("lowStockCount", lowStockProducts.size());

            req.getRequestDispatcher("/Admin/products.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException("Error listing products", e);
        }
    }

    /**
     * Hiển thị form edit
     */
    private void showEditForm(HttpServletRequest req, HttpServletResponse resp, HttpSession session)
            throws ServletException, IOException {

        String idStr = req.getParameter("id");

        if (idStr == null || idStr.trim().isEmpty()) {
            session.setAttribute("error", "❌ Thiếu ID sản phẩm!");
            resp.sendRedirect(req.getContextPath() + "/Admin/products");
            return;
        }

        try {
            int productId = Integer.parseInt(idStr);

            AdminProductDAO productDAO = new AdminProductDAO();
            AdminCategoryDAO categoryDAO = new AdminCategoryDAO();

            // DÙNG ĐÚNG METHOD getProductById
            Product product = productDAO.getProductById(productId);

            if (product == null) {
                session.setAttribute("error", "❌ Không tìm thấy sản phẩm!");
                resp.sendRedirect(req.getContextPath() + "/Admin/products");
                return;
            }

            List<Category> categories = categoryDAO.getAllCategories();

            req.setAttribute("product", product);
            req.setAttribute("categories", categories);

            req.getRequestDispatcher("/Admin/product-form.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            session.setAttribute("error", "❌ ID sản phẩm không hợp lệ!");
            resp.sendRedirect(req.getContextPath() + "/Admin/products");
        } catch (Exception e) {
            throw new ServletException("Error showing edit form", e);
        }
    }

    /**
     * Hiển thị form thêm mới
     */
    private void showAddForm(HttpServletRequest req, HttpServletResponse resp, HttpSession session)
            throws ServletException, IOException {

        try {
            AdminCategoryDAO categoryDAO = new AdminCategoryDAO();
            List<Category> categories = categoryDAO.getAllCategories();

            if (categories == null || categories.isEmpty()) {
                session.setAttribute("error", "❌ Chưa có danh mục! Vui lòng tạo danh mục trước.");
                resp.sendRedirect(req.getContextPath() + "/Admin/categories");
                return;
            }

            req.setAttribute("categories", categories);
            req.getRequestDispatcher("/Admin/product-form.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException("Error showing add form", e);
        }
    }

    /**
     * Xóa sản phẩm (soft delete)
     */
    private void deleteProduct(HttpServletRequest req, HttpServletResponse resp, HttpSession session)
            throws ServletException, IOException {

        String idStr = req.getParameter("id");

        if (idStr == null || idStr.trim().isEmpty()) {
            session.setAttribute("error", "❌ Thiếu ID sản phẩm!");
            resp.sendRedirect(req.getContextPath() + "/Admin/products");
            return;
        }

        try {
            int productId = Integer.parseInt(idStr);

            AdminProductDAO productDAO = new AdminProductDAO();
            Product product = productDAO.getProductById(productId);

            if (product == null) {
                session.setAttribute("error", "❌ Không tìm thấy sản phẩm!");
                resp.sendRedirect(req.getContextPath() + "/Admin/products");
                return;
            }

            // DÙNG ĐÚNG METHOD deleteProduct (soft delete)
            boolean deleted = productDAO.deleteProduct(productId);

            if (deleted) {
                session.setAttribute("success", "✅ Đã xóa sản phẩm \"" + product.getName() + "\" thành công!");
            } else {
                session.setAttribute("error", "❌ Không thể xóa sản phẩm!");
            }

            resp.sendRedirect(req.getContextPath() + "/Admin/products");

        } catch (NumberFormatException e) {
            session.setAttribute("error", "❌ ID sản phẩm không hợp lệ!");
            resp.sendRedirect(req.getContextPath() + "/Admin/products");
        } catch (Exception e) {
            throw new ServletException("Error deleting product", e);
        }
    }

    /**
     * Toggle featured status (HOT)
     */
    private void toggleFeatured(HttpServletRequest req, HttpServletResponse resp, HttpSession session)
            throws ServletException, IOException {

        String idStr = req.getParameter("id");

        if (idStr == null || idStr.trim().isEmpty()) {
            session.setAttribute("error", "❌ Thiếu ID sản phẩm!");
            resp.sendRedirect(req.getContextPath() + "/Admin/products");
            return;
        }

        try {
            int productId = Integer.parseInt(idStr);

            AdminProductDAO productDAO = new AdminProductDAO();
            Product product = productDAO.getProductById(productId);

            if (product == null) {
                session.setAttribute("error", "❌ Không tìm thấy sản phẩm!");
                resp.sendRedirect(req.getContextPath() + "/Admin/products");
                return;
            }

            // DÙNG ĐÚNG METHOD toggleFeatured
            boolean toggled = productDAO.toggleFeatured(productId);

            if (toggled) {
                String statusText = product.isFeatured() ? "BỎ HOT" : "ĐẶT HOT";
                session.setAttribute("success", "✅ Đã " + statusText + " sản phẩm \"" + product.getName() + "\"!");
            } else {
                session.setAttribute("error", "❌ Không thể cập nhật!");
            }

            resp.sendRedirect(req.getContextPath() + "/Admin/products");

        } catch (NumberFormatException e) {
            session.setAttribute("error", "❌ ID sản phẩm không hợp lệ!");
            resp.sendRedirect(req.getContextPath() + "/Admin/products");
        } catch (Exception e) {
            throw new ServletException("Error toggling featured", e);
        }
    }

    /**
     * Toggle status (ĐANG BÁN / NGỪNG BÁN)
     */
    private void toggleStatus(HttpServletRequest req, HttpServletResponse resp, HttpSession session)
            throws ServletException, IOException {

        String idStr = req.getParameter("id");

        if (idStr == null || idStr.trim().isEmpty()) {
            session.setAttribute("error", "❌ Thiếu ID sản phẩm!");
            resp.sendRedirect(req.getContextPath() + "/Admin/products");
            return;
        }

        try {
            int productId = Integer.parseInt(idStr);

            AdminProductDAO productDAO = new AdminProductDAO();
            Product product = productDAO.getProductById(productId);

            if (product == null) {
                session.setAttribute("error", "❌ Không tìm thấy sản phẩm!");
                resp.sendRedirect(req.getContextPath() + "/Admin/products");
                return;
            }

            // DÙNG ĐÚNG METHOD toggleStatus
            boolean toggled = productDAO.toggleStatus(productId);

            if (toggled) {
                String oldStatus = product.getStatus();
                String newStatus = "active".equals(oldStatus) ? "inactive" : "active";
                String statusText = "active".equals(newStatus) ? "ĐANG BÁN" : "NGỪNG BÁN";

                session.setAttribute("success", "✅ Đã chuyển sản phẩm \"" + product.getName() + "\" sang trạng thái: " + statusText);
            } else {
                session.setAttribute("error", "❌ Không thể thay đổi trạng thái!");
            }

            resp.sendRedirect(req.getContextPath() + "/Admin/products");

        } catch (NumberFormatException e) {
            session.setAttribute("error", "❌ ID sản phẩm không hợp lệ!");
            resp.sendRedirect(req.getContextPath() + "/Admin/products");
        } catch (Exception e) {
            throw new ServletException("Error toggling status", e);
        }
    }

    // ==================== POST METHODS ====================
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !isAdmin(user)) {
            resp.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String action = req.getParameter("action");

        try {
            if ("save".equals(action)) {
                saveProduct(req, resp, session);
            } else {
                session.setAttribute("error", "❌ Action không hợp lệ!");
                resp.sendRedirect(req.getContextPath() + "/Admin/products");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "❌ Có lỗi: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/Admin/products");
        }
    }

    /**
     * Lưu sản phẩm (create hoặc update)
     */
    private void saveProduct(HttpServletRequest req, HttpServletResponse resp, HttpSession session)
            throws ServletException, IOException {

        try {
            AdminProductDAO productDAO = new AdminProductDAO();

            // Get parameters
            String idStr = req.getParameter("id");
            String name = req.getParameter("name");
            String description = req.getParameter("description");
            String priceStr = req.getParameter("price");
            String discountPriceStr = req.getParameter("discountPrice");
            String categoryIdStr = req.getParameter("categoryId");
            String stockStr = req.getParameter("stock");
            String size = req.getParameter("size");
            String color = req.getParameter("color");
            String material = req.getParameter("material");
            String brand = req.getParameter("brand");
            String imageUrl = req.getParameter("imageUrl");
            String status = req.getParameter("status");
            String featuredStr = req.getParameter("featured");

            // Validation
            if (name == null || name.trim().isEmpty()) {
                session.setAttribute("error", "❌ Tên sản phẩm không được để trống!");
                redirectBack(resp, req, idStr);
                return;
            }

            if (priceStr == null || priceStr.trim().isEmpty()) {
                session.setAttribute("error", "❌ Giá sản phẩm không được để trống!");
                redirectBack(resp, req, idStr);
                return;
            }

            if (categoryIdStr == null || categoryIdStr.trim().isEmpty()) {
                session.setAttribute("error", "❌ Vui lòng chọn danh mục!");
                redirectBack(resp, req, idStr);
                return;
            }

            // Parse values
            BigDecimal price = new BigDecimal(priceStr);
            BigDecimal discountPrice = (discountPriceStr != null && !discountPriceStr.trim().isEmpty())
                    ? new BigDecimal(discountPriceStr) : BigDecimal.ZERO;
            int categoryId = Integer.parseInt(categoryIdStr);
            int stock = (stockStr != null && !stockStr.trim().isEmpty()) ? Integer.parseInt(stockStr) : 0;

            // Validate discount
            if (discountPrice.compareTo(price) > 0) {
                session.setAttribute("error", "❌ Giá khuyến mãi không được lớn hơn giá gốc!");
                redirectBack(resp, req, idStr);
                return;
            }

            // Handle image upload
            Part filePart = req.getPart("imageFile");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = uploadImage(filePart, req);
                if (fileName != null) {
                    imageUrl = req.getContextPath() + "/" + UPLOAD_DIR + "/" + fileName;
                }
            }

            // Create Product object
            Product product = new Product();

            if (idStr != null && !idStr.trim().isEmpty()) {
                product.setId(Integer.parseInt(idStr));
            }

            product.setName(name.trim());
            product.setDescription(description != null ? description.trim() : "");
            product.setPrice(price);
            product.setDiscountPrice(discountPrice);
            product.setImageUrl(imageUrl);
            product.setCategoryId(categoryId);
            product.setStockQuantity(stock);
            product.setSize(size != null ? size.trim() : null);
            product.setColor(color != null ? color.trim() : null);
            product.setMaterial(material != null ? material.trim() : null);
            product.setBrand(brand != null ? brand.trim() : null);
            product.setStatus(status != null ? status : "active");
            product.setFeatured("on".equals(featuredStr) || "true".equals(featuredStr));

            // Save - DÙNG ĐÚNG METHOD CỦA DAO
            if (idStr != null && !idStr.trim().isEmpty()) {
                // Update - DÙNG updateProduct
                boolean updated = productDAO.updateProduct(product);
                if (updated) {
                    session.setAttribute("success", "✅ Cập nhật sản phẩm \"" + name + "\" thành công!");
                } else {
                    session.setAttribute("error", "❌ Không thể cập nhật sản phẩm!");
                }
            } else {
                // Create - DÙNG createProduct
                int newId = productDAO.createProduct(product);
                if (newId > 0) {
                    session.setAttribute("success", "✅ Thêm sản phẩm \"" + name + "\" thành công!");
                } else {
                    session.setAttribute("error", "❌ Không thể thêm sản phẩm!");
                }
            }

            resp.sendRedirect(req.getContextPath() + "/Admin/products");

        } catch (NumberFormatException e) {
            session.setAttribute("error", "❌ Dữ liệu số không hợp lệ!");
            resp.sendRedirect(req.getContextPath() + "/Admin/products");
        } catch (Exception e) {
            throw new ServletException("Error saving product", e);
        }
    }

    // ==================== HELPER METHODS ====================
    /**
     * Upload image file
     */
    private String uploadImage(Part filePart, HttpServletRequest req) {
        try {
            String fileName = getFileName(filePart);

            if (fileName == null || fileName.isEmpty()) {
                return null;
            }

            // Validate extension
            String ext = fileName.substring(fileName.lastIndexOf(".")).toLowerCase();
            boolean isValid = false;
            for (String allowedExt : ALLOWED_EXTENSIONS) {
                if (ext.equals(allowedExt)) {
                    isValid = true;
                    break;
                }
            }

            if (!isValid) {
                return null;
            }

            // Generate unique filename
            String uniqueFileName = System.currentTimeMillis() + "_"
                    + java.util.UUID.randomUUID().toString().substring(0, 8) + ext;

            // Create upload directory
            String uploadPath = req.getServletContext().getRealPath("") + UPLOAD_DIR;
            File uploadDir = new File(uploadPath);

            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // Write file
            String filePath = uploadPath + File.separator + uniqueFileName;
            filePart.write(filePath);

            return uniqueFileName;

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Get filename from Part
     */
    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");

        if (contentDisposition == null) {
            return null;
        }

        String[] items = contentDisposition.split(";");
        for (String item : items) {
            if (item.trim().startsWith("filename")) {
                String filename = item.substring(item.indexOf("=") + 2, item.length() - 1);
                return filename.substring(filename.lastIndexOf("\\") + 1);
            }
        }

        return null;
    }

    /**
     * Redirect back to form
     */
    private void redirectBack(HttpServletResponse resp, HttpServletRequest req, String idStr)
            throws IOException {
        String url = req.getContextPath() + "/Admin/products?action=";
        if (idStr != null && !idStr.trim().isEmpty()) {
            url += "edit&id=" + idStr;
        } else {
            url += "add";
        }
        resp.sendRedirect(url);
    }

    /**
     * Check if user is admin
     */
    private boolean isAdmin(User user) {
        return user != null && user.getRole() != null
                && user.getRole().equalsIgnoreCase("admin");
    }
}
