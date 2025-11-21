package Controller.Order;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;
import java.io.IOException;
import java.util.List;

import Dal.OrderDAO;
import Model.Order;
import Model.User;

/**
 * Servlet xử lý hiển thị danh sách và chi tiết đơn hàng
 * 
 * @author Kien-Ptit
 * @version 3.1
 * @since 2025-11-20
 */
@WebServlet("/orders")
public class OrdersServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User user = (session == null) ? null : (User) session.getAttribute("user");
        
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String idStr = req.getParameter("id");
        String filterStatus = req.getParameter("status");
        
        OrderDAO dao = null;
        try {
            dao = new OrderDAO();

            // ==== CHI TIẾT ĐƠN HÀNG ====
            if (idStr != null && !idStr.isBlank()) {
                int orderId = Integer.parseInt(idStr);

                Order order = dao.findOrderHeader(orderId, user.getId());
                if (order == null) {
                    req.setAttribute("error", "Không tìm thấy đơn hàng hoặc bạn không có quyền xem.");
                    req.getRequestDispatcher("/order.jsp").forward(req, resp);
                    return;
                }

                List<Order.OrderItem> items = dao.findOrderItems(orderId);

                req.setAttribute("order", order);
                req.setAttribute("orderItems", items);
                req.setAttribute("orderStatus", order.getStatus());

                req.getRequestDispatcher("/order.jsp").forward(req, resp);
                return;
            }

            // ==== DANH SÁCH ĐƠN HÀNG ====
            List<Order> ordersList;
            
            if (filterStatus != null && !filterStatus.isBlank()) {
                ordersList = dao.findOrdersByStatus(user.getId(), filterStatus);
                req.setAttribute("currentStatus", filterStatus);
            } else {
                ordersList = dao.listOrdersByUser(user.getId());
            }
            
            req.setAttribute("orders", ordersList);
            req.getRequestDispatcher("/order.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            req.setAttribute("error", "Mã đơn hàng không hợp lệ");
            req.getRequestDispatcher("/order.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Có lỗi: " + e.getMessage());
            req.getRequestDispatcher("/order.jsp").forward(req, resp);
        } finally {
            // ✅ Đóng DAO
            if (dao != null) {
                try {
                    dao.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    }
}