/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.Products;

import Dal.ProductDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Admin
 */
@WebServlet(name = "ProductsServlet", urlPatterns = {"/products"})
public class ProductsServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ProductsServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ProductsServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private java.util.List<Integer> parseIds(String csv) {
        if (csv == null || csv.isBlank()) {
            return java.util.Collections.emptyList();
        }
        return java.util.Arrays.stream(csv.split(","))
                .map(String::trim)
                .filter(s -> s.matches("\\d+"))
                .map(Integer::valueOf)
                .collect(java.util.stream.Collectors.toList());
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");
        // ---- Đọc tham số lọc/sắp xếp/phân trang
        String segment = req.getParameter("segment"); // "men" | "women" | null
        String q = n(req.getParameter("q"));
        String sort = n(req.getParameter("sort"));
        String priceRange = n(req.getParameter("price"));

        // Xử lý category parameters
        String categoryStr = n(req.getParameter("category"));
        String categoriesStr = n(req.getParameter("categories"));

        List<Integer> categoryIds = new ArrayList<>();

        // Xử lý single category
        if (!categoryStr.isEmpty()) {
            try {
                categoryIds.add(Integer.parseInt(categoryStr));
            } catch (Exception ignore) {
            }
        }

        // Xử lý multiple categories (chỉ khi không có single category)
        if (categoryIds.isEmpty() && !categoriesStr.isEmpty()) {
            categoryIds.addAll(parseIds(categoriesStr));
        }

        int page = 1, pageSize = 9;
        try {
            page = Math.max(1, Integer.parseInt(n(req.getParameter("page")).isEmpty() ? "1" : req.getParameter("page")));
        } catch (Exception ignore) {
        }
        int offset = (page - 1) * pageSize;

        // ---- Lấy dữ liệu
        ProductDAO dao = new ProductDAO();
        try {
            List<Map<String, Object>> categories = dao.getCategories();

            // Truyền null nếu categoryIds rỗng
            List<Integer> categoryIdsToPass = categoryIds.isEmpty() ? null : categoryIds;

            List<Map<String, Object>> products = dao.findProductsByCategories(
                    q, categoryIdsToPass, priceRange, sort, offset, pageSize, segment);

            int total = dao.countProductsByCategories(q, categoryIdsToPass, priceRange, segment);
            int totalPages = (int) Math.ceil(total / (double) pageSize);

            // ---- Gửi sang view
            req.setAttribute("categories", categories);
            req.setAttribute("products", products);
            req.setAttribute("total", total);
            req.setAttribute("page", page);
            req.setAttribute("pageSize", pageSize);
            req.setAttribute("segment", segment);
            req.setAttribute("totalPages", totalPages);

            // giữ lại lựa chọn hiện tại cho form
            req.setAttribute("q", q);
            req.setAttribute("sort", sort);
            req.setAttribute("price", priceRange);
            req.setAttribute("category", !categoryIds.isEmpty() ? categoryIds.get(0) : null);
            req.setAttribute("categoryIds", categoryIds);
            req.setAttribute("categoriesParam", categoriesStr);

            req.getRequestDispatcher("/products.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Không tải được sản phẩm: " + e.getMessage());
            req.getRequestDispatcher("/products.jsp").forward(req, resp);
        }
    }

    private static String n(String s) {
        return s == null ? "" : s.trim();
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
