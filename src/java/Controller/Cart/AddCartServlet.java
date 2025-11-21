package Controller.Cart;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.Map;

import Dal.CartDAO;
import Dal.ProductDAO;
import Model.Cart;
import Model.CartItem;

@WebServlet(name = "AddCartServlet", urlPatterns = {"/add"})
public class AddCartServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Integer userId = (session != null) ? (Integer) session.getAttribute("userId") : null;
        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String pidRaw = req.getParameter("productId");
        String size = req.getParameter("size");
        String color = req.getParameter("color"); // ✅ ĐỌC COLOR TỪ REQUEST
        
        if (size != null) size = size.trim().toUpperCase();
        if (color != null) color = color.trim(); // ✅ CHUẨN HÓA COLOR

        int productId;
        try {
            productId = Integer.parseInt(pidRaw);
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/products");
            return;
        }

        if (size == null || size.isEmpty()) {
            String back = req.getHeader("Referer");
            resp.sendRedirect(back != null ? back : (req.getContextPath() + "/product?id=" + productId));
            return;
        }

        final int qty = 1;

        ProductDAO pdao = null;
        CartDAO cdao = null;

        try {
            pdao = new ProductDAO();
            cdao = new CartDAO();
            Map<String, Object> p = pdao.findById(productId);
            if (p == null) {
                resp.sendRedirect(req.getContextPath() + "/products");
                return;
            }

            // ✅ TRUYỀN COLOR VÀO DAO
            cdao.addOrUpdateBySize(userId, productId, size, color, qty);

            // Reload cart từ DB
            Cart cart = cdao.loadCartForUser(userId);
            session.setAttribute("cart", cart);

            String go = req.getParameter("go");
            boolean directToCart = (go != null && "cart".equalsIgnoreCase(go));
            String back = req.getHeader("Referer");
            if (directToCart) {
                resp.sendRedirect(req.getContextPath() + "/cart");
            } else {
                resp.sendRedirect(back != null ? back : (req.getContextPath() + "/cart"));
            }

        } catch (Exception ex) {
            ex.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/products");
        } finally {
            try { if (pdao != null) pdao.close(); } catch (Exception ignore) {}
            try { if (cdao != null) cdao.close(); } catch (Exception ignore) {}
        }
    }

    private static BigDecimal toBigDecimal(Object val) {
        if (val == null) return BigDecimal.ZERO;
        if (val instanceof BigDecimal) return (BigDecimal) val;
        if (val instanceof Number) return new BigDecimal(((Number) val).toString());
        return new BigDecimal(String.valueOf(val));
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }
}