package controller.Admin;

import Dal.OrderDAO;
import Dal.ProductDAO;
import Dal.Admin.AdminUserDAO;
import Model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

@WebServlet(urlPatterns = {"/Admin/statistics"})
public class AdminStatisticsServlet extends HttpServlet {

    private OrderDAO orderDAO;
    private ProductDAO productDAO;
    private AdminUserDAO userDAO;

    @Override
    public void init() throws ServletException {
        try {
            orderDAO = new OrderDAO();
            productDAO = new ProductDAO();
            userDAO = new AdminUserDAO();
        } catch (Exception e) {
            throw new ServletException("Failed to initialize DAOs", e);
        }
    }

    private boolean isAdmin(User user) {
        return user != null && "admin".equals(user.getRole());
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User user = (session == null) ? null : (User) session.getAttribute("user");

        if (!isAdmin(user)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            // Lấy tham số lọc thời gian
            String period = req.getParameter("period");
            if (period == null || period.isEmpty()) {
                period = "month";
            }

            // Tính toán khoảng thời gian
            LocalDate endDate = LocalDate.now();
            LocalDate startDate = calculateStartDate(period, endDate);

            // 1. Thống kê tổng quan
            Map<String, Object> overview = getOverviewStats(startDate, endDate);
            req.setAttribute("overview", overview);

            // 2. Doanh thu theo ngày (30 ngày gần nhất)
            List<Map<String, Object>> dailyRevenue = getDailyRevenue(30);
            req.setAttribute("dailyRevenue", dailyRevenue);

            // 3. Top 10 sản phẩm bán chạy
            List<Map<String, Object>> topProducts = getTopProducts(startDate, endDate, 10);
            req.setAttribute("topProducts", topProducts);

            // 4. Top 10 khách hàng
            List<Map<String, Object>> topCustomers = getTopCustomers(startDate, endDate, 10);
            req.setAttribute("topCustomers", topCustomers);

            // 5. Thống kê đơn hàng theo trạng thái
            Map<String, Integer> ordersByStatus = getOrdersByStatus(startDate, endDate);
            req.setAttribute("ordersByStatus", ordersByStatus);

            // 6. Thống kê theo tháng (12 tháng gần nhất)
            List<Map<String, Object>> monthlyStats = getMonthlyStats(12);
            req.setAttribute("monthlyStats", monthlyStats);

            // Gửi thông tin thời gian
            req.setAttribute("period", period);
            req.setAttribute("startDate", startDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));
            req.setAttribute("endDate", endDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));

            req.getRequestDispatcher("/Admin/statistics.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "❌ Lỗi khi tải thống kê: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/Admin/dashboard");
        }
    }

    /**
     * Tính ngày bắt đầu dựa trên period
     */
    private LocalDate calculateStartDate(String period, LocalDate endDate) {
        return switch (period) {
            case "today" -> endDate;
            case "week" -> endDate.minusDays(7);
            case "month" -> endDate.minusMonths(1);
            case "quarter" -> endDate.minusMonths(3);
            case "year" -> endDate.minusYears(1);
            default -> endDate.minusMonths(1);
        };
    }

    /**
     * Thống kê tổng quan
     */
    private Map<String, Object> getOverviewStats(LocalDate startDate, LocalDate endDate) throws Exception {
        Map<String, Object> stats = new HashMap<>();
        
        // Tổng doanh thu
        double totalRevenue = orderDAO.getTotalRevenue(startDate, endDate);
        stats.put("totalRevenue", totalRevenue);

        // Tổng đơn hàng
        int totalOrders = orderDAO.getTotalOrders(startDate, endDate);
        stats.put("totalOrders", totalOrders);

        // Tổng khách hàng mới
        int newCustomers = userDAO.getNewCustomersCount(startDate, endDate);
        stats.put("newCustomers", newCustomers);

        // Tổng sản phẩm đã bán
        int productsSold = orderDAO.getTotalProductsSold(startDate, endDate);
        stats.put("productsSold", productsSold);

        // Giá trị đơn hàng trung bình
        double avgOrderValue = totalOrders > 0 ? totalRevenue / totalOrders : 0;
        stats.put("avgOrderValue", avgOrderValue);

        return stats;
    }

    /**
     * Doanh thu theo ngày
     */
    private List<Map<String, Object>> getDailyRevenue(int days) throws Exception {
        List<Map<String, Object>> result = new ArrayList<>();
        LocalDate endDate = LocalDate.now();
        LocalDate startDate = endDate.minusDays(days - 1);

        // Lấy dữ liệu từ DAO
        List<Map<String, Object>> data = orderDAO.getDailyRevenue(startDate, endDate);
        
        // Đảm bảo có đủ 30 ngày (điền 0 nếu không có dữ liệu)
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM");
        for (int i = 0; i < days; i++) {
            LocalDate date = startDate.plusDays(i);
            String dateStr = date.format(formatter);
            
            Map<String, Object> dayData = new HashMap<>();
            dayData.put("date", dateStr);
            dayData.put("revenue", 0.0);
            
            // Tìm doanh thu thực tế
            for (Map<String, Object> d : data) {
                if (d.get("date").equals(dateStr)) {
                    dayData.put("revenue", d.get("revenue"));
                    break;
                }
            }
            
            result.add(dayData);
        }
        
        return result;
    }

    /**
     * Top sản phẩm bán chạy
     */
    private List<Map<String, Object>> getTopProducts(LocalDate startDate, LocalDate endDate, int limit) throws Exception {
        return orderDAO.getTopSellingProducts(startDate, endDate, limit);
    }

    /**
     * Top khách hàng
     */
    private List<Map<String, Object>> getTopCustomers(LocalDate startDate, LocalDate endDate, int limit) throws Exception {
        return orderDAO.getTopCustomers(startDate, endDate, limit);
    }

    /**
     * Đơn hàng theo trạng thái
     */
    private Map<String, Integer> getOrdersByStatus(LocalDate startDate, LocalDate endDate) throws Exception {
        return orderDAO.getOrderCountByStatus(startDate, endDate);
    }

    /**
     * Thống kê theo tháng
     */
    private List<Map<String, Object>> getMonthlyStats(int months) throws Exception {
        List<Map<String, Object>> result = new ArrayList<>();
        LocalDate now = LocalDate.now();

        for (int i = months - 1; i >= 0; i--) {
            LocalDate monthDate = now.minusMonths(i);
            LocalDate startOfMonth = monthDate.withDayOfMonth(1);
            LocalDate endOfMonth = monthDate.withDayOfMonth(monthDate.lengthOfMonth());

            Map<String, Object> monthData = new HashMap<>();
            monthData.put("month", monthDate.format(DateTimeFormatter.ofPattern("MM/yyyy")));
            monthData.put("revenue", orderDAO.getTotalRevenue(startOfMonth, endOfMonth));
            monthData.put("orders", orderDAO.getTotalOrders(startOfMonth, endOfMonth));
            
            result.add(monthData);
        }

        return result;
    }
}