package Controller.Admin;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;
import jakarta.servlet.*;
import java.io.IOException;
import java.io.File;
import java.util.List;

import Dal.Admin.AdminCategoryDAO;
import Model.Category;
import Model.User;

/**
 * Admin Categories Management Servlet
 * 
 * @author Kien-Ptit
 * @version 3.0
 * @since 2025-10-25
 */
@WebServlet("/Admin/categories")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 50
)
public class AdminCategoriesServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        HttpSession session = req.getSession(false);
        User user = (session == null) ? null : (User) session.getAttribute("user");
        
        if (user == null || !isAdmin(user)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        
        String action = req.getParameter("action");
        String idStr = req.getParameter("id");
        
        try {
            AdminCategoryDAO dao = new AdminCategoryDAO();
            
            // EDIT - Hiển thị form sửa
            if ("edit".equals(action) && idStr != null) {
                int categoryId = Integer.parseInt(idStr);
                Category category = dao.getCategoryById(categoryId);
                
                if (category != null) {
                    req.setAttribute("category", category);
                    req.setAttribute("allCategories", dao.getAllCategories());
                    req.getRequestDispatcher("/Admin/category-form.jsp").forward(req, resp);
                    return;
                } else {
                    session.setAttribute("error", "Không tìm thấy danh mục!");
                    resp.sendRedirect(req.getContextPath() + "/Admin/categories");
                    return;
                }
            }
            
            // ADD - Hiển thị form thêm mới
            if ("add".equals(action)) {
                req.setAttribute("allCategories", dao.getAllCategories());
                req.getRequestDispatcher("/Admin/category-form.jsp").forward(req, resp);
                return;
            }
            
            // DELETE - Xóa danh mục
            if ("delete".equals(action) && idStr != null) {
                int categoryId = Integer.parseInt(idStr);
                boolean deleted = dao.deleteCategory(categoryId);
                
                if (deleted) {
                    session.setAttribute("success", "Xóa danh mục thành công!");
                } else {
                    session.setAttribute("error", "Không thể xóa danh mục! Có thể đang có sản phẩm trong danh mục này.");
                }
                resp.sendRedirect(req.getContextPath() + "/Admin/categories");
                return;
            }
            
            // TOGGLE ACTIVE - Database không có field này
            if ("toggleActive".equals(action) && idStr != null) {
                int categoryId = Integer.parseInt(idStr);
                boolean toggled = dao.toggleCategoryActive(categoryId);
                
                if (toggled) {
                    session.setAttribute("success", "Cập nhật trạng thái danh mục thành công!");
                } else {
                    session.setAttribute("error", "Không thể cập nhật trạng thái!");
                }
                resp.sendRedirect(req.getContextPath() + "/Admin/categories");
                return;
            }
            
            // LIST - Hiển thị danh sách
            List<Category> categories = dao.getAllCategoriesWithCount();
            int totalCategories = categories.size();
            
            // Đếm active categories (tất cả đều active vì không có field is_active)
            int activeCategories = totalCategories;
            
            req.setAttribute("categories", categories);
            req.setAttribute("totalCategories", totalCategories);
            req.setAttribute("activeCategories", activeCategories);
            req.getRequestDispatcher("/Admin/categories.jsp").forward(req, resp);
            
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Có lỗi: " + e.getMessage());
            req.getRequestDispatcher("/Admin/categories.jsp").forward(req, resp);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        req.setCharacterEncoding("UTF-8");
        
        HttpSession session = req.getSession(false);
        User user = (session == null) ? null : (User) session.getAttribute("user");
        
        if (user == null || !isAdmin(user)) {
            resp.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        
        String action = req.getParameter("action");
        
        try {
            AdminCategoryDAO dao = new AdminCategoryDAO();
            
            if ("save".equals(action)) {
                String idStr = req.getParameter("id");
                String name = req.getParameter("name");
                String description = req.getParameter("description");
                
                // Validation
                if (name == null || name.trim().isEmpty()) {
                    session.setAttribute("error", "Tên danh mục không được để trống!");
                    resp.sendRedirect(req.getContextPath() + "/Admin/categories?action=add");
                    return;
                }
                
                // Tạo category object
                Category category = new Category();
                
                if (idStr != null && !idStr.trim().isEmpty()) {
                    category.setId(Integer.parseInt(idStr));
                }
                
                category.setName(name.trim());
                category.setDescription(description != null ? description.trim() : "");
                category.setActive(true); // Mặc định active
                
                // Lưu vào database
                if (idStr != null && !idStr.trim().isEmpty()) {
                    // Update
                    boolean updated = dao.updateCategory(category);
                    if (updated) {
                        session.setAttribute("success", "Cập nhật danh mục thành công!");
                    } else {
                        session.setAttribute("error", "Không thể cập nhật danh mục!");
                    }
                } else {
                    // Create
                    boolean created = dao.createCategory(category);
                    if (created) {
                        session.setAttribute("success", "Thêm danh mục thành công!");
                    } else {
                        session.setAttribute("error", "Không thể thêm danh mục!");
                    }
                }
                
                resp.sendRedirect(req.getContextPath() + "/Admin/categories");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Có lỗi: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/Admin/categories");
        }
    }
    
    /**
     * Kiểm tra quyền admin
     */
    private boolean isAdmin(User user) {
        return user != null && user.getRole() != null && 
               user.getRole().equalsIgnoreCase("admin");
    }
}