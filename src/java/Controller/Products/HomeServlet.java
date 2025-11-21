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
import java.util.Arrays;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Admin
 */
@WebServlet(name = "HomeServlet", urlPatterns = {"/home",""})
public class HomeServlet extends HttpServlet {

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
            out.println("<title>Servlet HomeServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet HomeServlet at " + request.getContextPath() + "</h1>");
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
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            ProductDAO dao = new ProductDAO();

            List<Map<String, Object>> categories = dao.getCategories();
            List<Map<String, Object>> featuredProducts = dao.getFeaturedProducts(6); // sp nổi bật
            List<Map<String, Object>> latestProducts = dao.getLatestProducts(6);   // sp mới

            req.setAttribute("categories", categories);
            req.setAttribute("featuredProducts", featuredProducts);
            req.setAttribute("latestProducts", latestProducts);
            final int limit = 6;

            // ===== ĐỒ NAM = category 1 & 3 =====
            List<Integer> menIds = Arrays.asList(1, 3);
            req.setAttribute("menProducts", dao.listProductsByCategoryIds(menIds, limit));
            // dùng cho link "Xem thêm" => /products?categories=1,3
            req.setAttribute("menCatsParam", "1,3");

            // ===== ĐỒ NỮ = category 2 & 4 =====
            List<Integer> womenIds = Arrays.asList(2, 4);
            req.setAttribute("womenProducts", dao.listProductsByCategoryIds(womenIds, limit));
            // dùng cho link "Xem thêm" => /products?categories=2,4
            req.setAttribute("womenCatsParam", "2,4");
            // == == = PHỤ KIỆN = category 5 =====
            List<Integer> accId = Arrays.asList(5);
            req.setAttribute("accProducts", dao.listProductsByCategoryIds(accId, limit));
            // dùng cho link "Xem thêm" => /products?categories=2,4
            req.setAttribute("accCatsParam", "5");
            // == == = TRẺ EM = category 6 =====
            List<Integer> kidsId = Arrays.asList(6);
            req.setAttribute("kidsProducts", dao.listProductsByCategoryIds(accId, limit));
            // dùng cho link "Xem thêm" => /products?categories=2,4
            req.setAttribute("kidsCatsParam", "6");
            // forward sang view
            req.getRequestDispatcher("/index.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", "Không tải được dữ liệu: " + e.getMessage());
            req.getRequestDispatcher("/index.jsp").forward(req, resp);
        }
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
