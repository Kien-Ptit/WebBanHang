package Controller.Order;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;
import java.io.IOException;

import Dal.OrderDAO;
import Model.User;

/**
 * Servlet xử lý hủy đơn hàng
 * 
 * @author Kien-Ptit
 * @version 1.1
 * @since 2025-11-20
 */
@WebServlet("/cancel-order")
public class CancelOrderServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json; charset=UTF-8");
        
        HttpSession session = req.getSession(false);
        
        // ✅ Kiểm tra session
        if (session == null) {
            sendJsonError(resp, HttpServletResponse.SC_UNAUTHORIZED, "Vui lòng đăng nhập");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (user == null) {
            sendJsonError(resp, HttpServletResponse.SC_UNAUTHORIZED, "Vui lòng đăng nhập");
            return;
        }
        
        String orderIdStr = req.getParameter("orderId");
        String reason = req.getParameter("reason");
        
        // ✅ Validate orderId
        if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
            sendJsonError(resp, HttpServletResponse.SC_BAD_REQUEST, "Thiếu thông tin đơn hàng");
            return;
        }
        
        // ✅ Set default reason
        if (reason == null || reason.trim().isEmpty()) {
            reason = "Khách hàng hủy đơn";
        }
        
        OrderDAO dao = null;
        try {
            int orderId = Integer.parseInt(orderIdStr);
            dao = new OrderDAO();
            
            // ✅ Kiểm tra quyền hủy
            if (!dao.canCancelOrder(orderId, user.getId())) {
                sendJsonError(resp, HttpServletResponse.SC_FORBIDDEN, "Không thể hủy đơn hàng này");
                return;
            }
            
            // ✅ Hủy đơn
            boolean success = dao.cancelOrder(orderId, user.getId(), reason);
            
            if (success) {
                sendJsonSuccess(resp, "Hủy đơn hàng thành công");
            } else {
                sendJsonError(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Không thể hủy đơn hàng");
            }
            
        } catch (NumberFormatException e) {
            sendJsonError(resp, HttpServletResponse.SC_BAD_REQUEST, "Mã đơn hàng không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            sendJsonError(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Có lỗi: " + e.getMessage());
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
    
    // ✅ Helper methods để gửi JSON response
    private void sendJsonError(HttpServletResponse resp, int status, String message) throws IOException {
        resp.setStatus(status);
        resp.getWriter().write("{\"success\": false, \"message\": \"" + escapeJson(message) + "\"}");
    }
    
    private void sendJsonSuccess(HttpServletResponse resp, String message) throws IOException {
        resp.getWriter().write("{\"success\": true, \"message\": \"" + escapeJson(message) + "\"}");
    }
    
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r");
    }
}