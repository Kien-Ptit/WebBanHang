package Controller.Cart;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.ServletException;
import java.io.IOException;

import Dal.CartDAO;
import Model.Cart;

@WebServlet("/update-cart")
public class UpdateCartServlet extends HttpServlet {

    private Integer parseInt(String s) {
        try {
            return (s == null || s.isEmpty()) ? null : Integer.parseInt(s.trim());
        } catch (Exception e) {
            return null;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        Integer userId = (session != null) ? (Integer) session.getAttribute("userId") : null;
        if (session == null || userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        Integer productId = parseInt(req.getParameter("productId"));
        String size = req.getParameter("size");
        String color = req.getParameter("color"); // ✅ ĐỌC COLOR

        if (size != null) {
            size = size.trim();
        }
        if (color != null) {
            color = color.trim();
        }

        Integer qtyI = parseInt(req.getParameter("qty"));
        int qty = (qtyI == null ? 0 : Math.max(0, qtyI));

        CartDAO dao = new CartDAO();
        try {
            if (productId != null && size != null && !size.isEmpty()) {
                if (qty <= 0) {
                    dao.removeBySize(userId, productId, size);
                } else {
                    dao.setQtyBySize(userId, productId, size, qty);
                }
            }

            Cart fresh = dao.loadCartForUser(userId);
            session.setAttribute("cart", fresh);

        } finally {
            try {
                dao.close();
            } catch (Exception ignore) {
            }
        }

        resp.sendRedirect(req.getContextPath() + "/cart");
    }
}
