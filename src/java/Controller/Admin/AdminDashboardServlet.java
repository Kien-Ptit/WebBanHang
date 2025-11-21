package Controller.Admin;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.*;

import Dal.Admin.AdminOrderDAO;
import Dal.Admin.AdminProductDAO;
import Dal.Admin.AdminUserDAO;
import Dal.Admin.AdminStatisticsDAO;
import Model.Order;
import Model.User;

/**
 * Admin Dashboard Servlet
 * 
 * @author Kien-Ptit
 * @version 3.0
 * @since 2025-10-25
 */
@WebServlet("/Admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        HttpSession session = req.getSession(false);
        User user = (session == null) ? null : (User) session.getAttribute("user");
        
        if (user == null || !isAdmin(user)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        
        try {
            AdminOrderDAO orderDAO = new AdminOrderDAO();
            AdminProductDAO productDAO = new AdminProductDAO();
            AdminUserDAO userDAO = new AdminUserDAO();
            AdminStatisticsDAO statsDAO = new AdminStatisticsDAO();
            
            // Thống kê hôm nay
            int todayOrders = statsDAO.getTodayOrders();
            BigDecimal todayRevenue = statsDAO.getTodayRevenue();
            int todayNewUsers = userDAO.getTodayNewUsers();
            
            // Tổng quan
            int totalProducts = productDAO.getTotalProducts();
            int totalOrders = orderDAO.getTotalOrders();
            int totalUsers = userDAO.getTotalUsers();
            BigDecimal totalRevenue = statsDAO.getTotalRevenue();
            int pendingOrders = orderDAO.getPendingOrdersCount();
            
            // Đơn hàng gần đây
            List<Order> recentOrders = orderDAO.getRecentOrders(10);
            
            // Sản phẩm bán chạy
            List<Map<String, Object>> bestSellers = statsDAO.getBestSellingProducts(5);
            
            // Dữ liệu biểu đồ doanh thu 7 ngày
            String revenueChartData = statsDAO.getRevenue7Days();
            
            // Set attributes
            req.setAttribute("todayOrders", todayOrders);
            req.setAttribute("todayRevenue", todayRevenue);
            req.setAttribute("todayNewUsers", todayNewUsers);
            req.setAttribute("totalProducts", totalProducts);
            req.setAttribute("totalOrders", totalOrders);
            req.setAttribute("totalUsers", totalUsers);
            req.setAttribute("totalRevenue", totalRevenue);
            req.setAttribute("pendingOrders", pendingOrders);
            req.setAttribute("recentOrders", recentOrders);
            req.setAttribute("bestSellers", bestSellers);
            req.setAttribute("revenueChartData", revenueChartData);
            
            req.getRequestDispatcher("/Admin/admin.jsp").forward(req, resp);
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            req.getRequestDispatcher("/Admin/admin.jsp").forward(req, resp);
        }
    }
    
    private boolean isAdmin(User user) {
        return user != null && user.getRole() != null && 
               user.getRole().equalsIgnoreCase("admin");
    }
}