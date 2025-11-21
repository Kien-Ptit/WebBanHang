package Controller.Cart;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

import Dal.CartDAO;
import Model.Cart;

@WebServlet("/remove-from-cart")
public class RemoveCartServlet extends HttpServlet {
    
    private Integer parseInt(String s) {
        try { 
            return (s == null || s.isEmpty()) ? null : Integer.parseInt(s.trim()); 
        } catch (Exception e) { 
            return null; 
        }
    }

    private void handleRemove(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        Integer userId = (session != null) ? (Integer) session.getAttribute("userId") : null;
        
        if (session == null || userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        Integer productId = parseInt(req.getParameter("productId"));
        String size = req.getParameter("size");
        String color = req.getParameter("color");
        
        if (size != null) size = size.trim().toUpperCase(); // ← Chuẩn hóa
        if (color != null) color = color.trim();

        CartDAO dao = new CartDAO();
        try {
            if (productId != null) {
                dao.removeBySize(userId, productId, size);
            }
            
            // Reload cart từ DB
            Cart cart = dao.loadCartForUser(userId);
            session.setAttribute("cart", cart);
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { dao.close(); } catch (Exception ignore) {}
        }

        resp.sendRedirect(req.getContextPath() + "/cart");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        handleRemove(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        handleRemove(req, resp);
    }
}