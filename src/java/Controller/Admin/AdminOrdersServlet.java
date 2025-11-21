package Controller.Admin;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import Dal.Admin.AdminOrderDAO;
import Model.Order;
import Model.User;

/**
 * Admin Orders Management Servlet
 * 
 * @author Kien-Ptit
 * @version 2.0
 * @since 2025-10-25
 */
@WebServlet("/Admin/orders")
public class AdminOrdersServlet extends HttpServlet {
    
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
            AdminOrderDAO dao = new AdminOrderDAO();
            
            // VIEW DETAIL - Xem chi tiết đơn hàng
            if ("view".equals(action) && idStr != null) {
                int orderId = Integer.parseInt(idStr);
                Order order = dao.findOrderById(orderId);
                
                if (order != null) {
                    List<Order.OrderItem> items = dao.findOrderItems(orderId);
                    order.setItems(items);
                    
                    req.setAttribute("order", order);
                    req.getRequestDispatcher("/Admin/order-detail.jsp").forward(req, resp);
                    return;
                } else {
                    session.setAttribute("error", "Không tìm thấy đơn hàng!");
                    resp.sendRedirect(req.getContextPath() + "/Admin/orders");
                    return;
                }
            }
            
            // GET ORDER JSON - Lấy thông tin đơn hàng dạng JSON
            if ("get".equals(action) && idStr != null) {
                int orderId = Integer.parseInt(idStr);
                Order order = dao.findOrderById(orderId);
                
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                PrintWriter out = resp.getWriter();
                
                if (order != null) {
                    StringBuilder json = new StringBuilder();
                    json.append("{");
                    json.append("\"id\":").append(order.getId()).append(",");
                    json.append("\"status\":\"").append(escapeJson(order.getStatus())).append("\",");
                    json.append("\"trackingNumber\":\"").append(escapeJson(order.getTrackingNumber())).append("\",");
                    json.append("\"paymentStatus\":\"").append(escapeJson(order.getPaymentStatus())).append("\"");
                    json.append("}");
                    
                    out.print(json.toString());
                } else {
                    resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    out.print("{\"error\":\"Order not found\"}");
                }
                
                out.flush();
                return;
            }
            
            // LIST - Hiển thị danh sách đơn hàng
            String search = req.getParameter("search");
            String status = req.getParameter("status");
            
            List<Order> orders;
            
            if (search != null && !search.trim().isEmpty()) {
                orders = dao.searchOrders(search.trim());
            } else if (status != null && !status.trim().isEmpty()) {
                orders = dao.getOrdersByStatus(status);
            } else {
                orders = dao.getAllOrders();
            }
            
            // Thống kê
            int totalOrders = dao.getTotalOrders();
            int pendingOrders = dao.getPendingOrdersCount();
            
            req.setAttribute("orders", orders);
            req.setAttribute("searchQuery", search);
            req.setAttribute("selectedStatus", status);
            req.setAttribute("totalOrders", totalOrders);
            req.setAttribute("pendingOrders", pendingOrders);
            
            req.getRequestDispatcher("/Admin/orders.jsp").forward(req, resp);
            
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Có lỗi: " + e.getMessage());
            req.getRequestDispatcher("/Admin/orders.jsp").forward(req, resp);
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
            AdminOrderDAO dao = new AdminOrderDAO();
            
            // UPDATE STATUS - Cập nhật trạng thái đơn hàng
            if ("updateStatus".equals(action)) {
                String orderIdStr = req.getParameter("orderId");
                String status = req.getParameter("status");
                String trackingNumber = req.getParameter("trackingNumber");
                
                if (orderIdStr == null || status == null) {
                    session.setAttribute("error", "Thiếu thông tin đơn hàng!");
                    resp.sendRedirect(req.getContextPath() + "/Admin/orders");
                    return;
                }
                
                int orderId = Integer.parseInt(orderIdStr);
                boolean updated = dao.updateOrderStatus(orderId, status, trackingNumber);
                
                if (updated) {
                    session.setAttribute("success", "Cập nhật trạng thái đơn hàng thành công!");
                } else {
                    session.setAttribute("error", "Không thể cập nhật trạng thái đơn hàng!");
                }
                
                resp.sendRedirect(req.getContextPath() + "/Admin/orders?action=view&id=" + orderId);
                return;
            }
            
            // UPDATE PAYMENT STATUS - Cập nhật trạng thái thanh toán
            if ("updatePayment".equals(action)) {
                String orderIdStr = req.getParameter("orderId");
                String paymentStatus = req.getParameter("paymentStatus");
                
                if (orderIdStr == null || paymentStatus == null) {
                    session.setAttribute("error", "Thiếu thông tin thanh toán!");
                    resp.sendRedirect(req.getContextPath() + "/Admin/orders");
                    return;
                }
                
                int orderId = Integer.parseInt(orderIdStr);
                boolean updated = dao.updatePaymentStatus(orderId, paymentStatus);
                
                if (updated) {
                    session.setAttribute("success", "Cập nhật trạng thái thanh toán thành công!");
                } else {
                    session.setAttribute("error", "Không thể cập nhật trạng thái thanh toán!");
                }
                
                resp.sendRedirect(req.getContextPath() + "/Admin/orders?action=view&id=" + orderId);
                return;
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Có lỗi: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/Admin/orders");
        }
    }
    
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }
    
    private boolean isAdmin(User user) {
        return user != null && user.getRole() != null && 
               user.getRole().equalsIgnoreCase("admin");
    }
}