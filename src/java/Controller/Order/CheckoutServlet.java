package Controller.Order;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;
import java.io.IOException;
import java.lang.reflect.Method;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.*;

import Dal.OrderDAO;
import Dal.CartDAO;
import Model.User;
import Model.Cart;
import Model.CartItem;
import Model.Order;

/**
 * Servlet xử lý checkout (thanh toán)
 * Hỗ trợ nhiều phương thức thanh toán: COD, E-Wallet, Bank Transfer
 * 
 * @author Kien-Ptit
 * @version 2.1
 * @since 2025-11-20
 */
@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    // ==================== HELPER METHODS ====================
    
    /**
     * Đọc giá trị Integer từ object bằng reflection
     */
    private Integer callIntGetter(Object obj, String... names) {
        for (String methodName : names) {
            try {
                Method method = obj.getClass().getMethod(methodName);
                Object value = method.invoke(obj);
                if (value instanceof Number) {
                    return ((Number) value).intValue();
                }
            } catch (Exception ignore) {
            }
        }
        return null;
    }
    
    /**
     * Đọc giá trị BigDecimal từ object bằng reflection
     */
    private BigDecimal callBDGetter(Object obj, String... names) {
        for (String methodName : names) {
            try {
                Method method = obj.getClass().getMethod(methodName);
                Object value = method.invoke(obj);
                
                if (value instanceof BigDecimal) {
                    return (BigDecimal) value;
                } else if (value instanceof Number) {
                    return new BigDecimal(value.toString());
                } else if (value instanceof String) {
                    return new BigDecimal((String) value);
                }
            } catch (Exception ignore) {
            }
        }
        return null;
    }
    
    /**
     * Đọc giá trị String từ object bằng reflection
     */
    private String callStrGetter(Object obj, String... names) {
        for (String methodName : names) {
            try {
                Method method = obj.getClass().getMethod(methodName);
                Object value = method.invoke(obj);
                if (value != null) {
                    return value.toString();
                }
            } catch (Exception ignore) {
            }
        }
        return null;
    }

    /**
     * ✅ SỬA: Thêm size và color vào lineItem
     */
    private Map<String, Object> normalizeCart(Cart cart) {
        List<Map<String, Object>> lines = new ArrayList<>();
        BigDecimal sum = BigDecimal.ZERO;

        if (cart != null && cart.getItems() != null) {
            for (CartItem cartItem : cart.getItems()) {
                // Lấy quantity
                Integer qty = callIntGetter(cartItem, "getQty", "getQuantity", "getAmount");
                if (qty == null || qty <= 0) {
                    qty = 0;
                }
                
                // Lấy price
                BigDecimal price = callBDGetter(cartItem, "getPrice", "getUnitPrice");
                if (price == null) {
                    price = BigDecimal.ZERO;
                }
                
                // Lấy subtotal
                BigDecimal subtotal = callBDGetter(cartItem, "getSubtotal", "getTotal", "getTotalPrice", "getLineTotal");
                if (subtotal == null && qty > 0 && price.compareTo(BigDecimal.ZERO) > 0) {
                    subtotal = price.multiply(new BigDecimal(qty));
                }
                if (subtotal == null) {
                    subtotal = BigDecimal.ZERO;
                }
                
                // Lấy title
                String title = callStrGetter(cartItem, "getProductName", "getName", "getTitle");
                if (title == null || title.isBlank()) {
                    title = "Sản phẩm";
                }
                
                // ✅ LẤY SIZE VÀ COLOR
                String size = callStrGetter(cartItem, "getSize");
                String color = callStrGetter(cartItem, "getColor");

                // Build line item
                Map<String, Object> lineItem = new HashMap<>();
                lineItem.put("title", title);
                lineItem.put("qty", qty);
                lineItem.put("price", price);
                lineItem.put("subtotal", subtotal);
                lineItem.put("size", size);      // ✅ THÊM SIZE
                lineItem.put("color", color);    // ✅ THÊM COLOR
                lines.add(lineItem);

                // Cộng vào tổng
                sum = sum.add(subtotal);
            }
        }
        
        Map<String, Object> result = new HashMap<>();
        result.put("lines", lines);
        result.put("sum", sum);
        return result;
    }

    /**
     * Fill thông tin user vào form (prefill)
     */
    private void fillUserPrefill(HttpSession session, HttpServletRequest req) {
        User user = (User) session.getAttribute("user");
        if (user != null) {
            req.setAttribute("u_fullname", user.getFullname());
            req.setAttribute("u_phone", user.getPhone());
            req.setAttribute("u_address", user.getAddress());
        }
    }

    // ==================== HTTP METHODS ====================

    /**
     * GET: Hiển thị trang checkout
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        HttpSession session = req.getSession(false);
        
        // Kiểm tra cart có tồn tại không
        Cart cart = (session == null) ? null : (Cart) session.getAttribute("cart");
        if (cart == null || cart.getItems() == null || cart.getItems().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart.jsp");
            return;
        }

        // Chuẩn bị data cho JSP
        Map<String, Object> normalized = normalizeCart(cart);
        req.setAttribute("lines", normalized.get("lines"));
        req.setAttribute("sum", normalized.get("sum"));
        fillUserPrefill(session, req);

        // Forward to checkout page
        req.getRequestDispatcher("/checkout.jsp").forward(req, resp);
    }

    /**
     * POST: Xử lý đặt hàng
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        req.setCharacterEncoding("UTF-8");

        // ===== KIỂM TRA SESSION & USER =====
        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        Cart cart = (Cart) session.getAttribute("cart");
        
        if (cart == null || cart.getItems() == null || cart.getItems().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart.jsp");
            return;
        }

        // ===== LẤY THÔNG TIN TỪ FORM =====
        String fullname = req.getParameter("fullname");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");
        String note = req.getParameter("note");
        
        String paymentMethod = req.getParameter("paymentMethod");
        String ewalletType = req.getParameter("ewalletType");
        
        // Default payment method
        if (paymentMethod == null || paymentMethod.isBlank()) {
            paymentMethod = "COD";
        }
        
        // Nếu chọn e-wallet mà không chọn loại ví
        if ("EWALLET".equals(paymentMethod) && (ewalletType == null || ewalletType.isBlank())) {
            req.setAttribute("error", "Vui lòng chọn loại ví điện tử.");
            Map<String, Object> normalized = normalizeCart(cart);
            req.setAttribute("lines", normalized.get("lines"));
            req.setAttribute("sum", normalized.get("sum"));
            fillUserPrefill(session, req);
            req.getRequestDispatcher("/checkout.jsp").forward(req, resp);
            return;
        }

        // ===== AUTO-FILL TỪ USER NẾU TRỐNG =====
        if (user != null) {
            if (fullname == null || fullname.isBlank()) {
                fullname = user.getFullname();
            }
            if (phone == null || phone.isBlank()) {
                phone = user.getPhone();
            }
            if (address == null || address.isBlank()) {
                address = user.getAddress();
            }
        }

        // ===== VALIDATE REQUIRED FIELDS =====
        if (fullname == null || fullname.isBlank()
                || phone == null || phone.isBlank()
                || address == null || address.isBlank()) {
            
            req.setAttribute("error", "Vui lòng nhập đủ Họ tên, Số điện thoại và Địa chỉ.");
            Map<String, Object> normalized = normalizeCart(cart);
            req.setAttribute("lines", normalized.get("lines"));
            req.setAttribute("sum", normalized.get("sum"));
            fillUserPrefill(session, req);
            req.getRequestDispatcher("/checkout.jsp").forward(req, resp);
            return;
        }

        // ===== TÍNH TỔNG TIỀN =====
        BigDecimal totalAmount = (BigDecimal) normalizeCart(cart).get("sum");

        try {
            OrderDAO orderDAO = new OrderDAO();
            CartDAO cartDAO = new CartDAO();
            Integer userId = (user != null ? user.getId() : null);

            // ===== BUILD ORDER ITEMS TỪ CART =====
            List<Order.OrderItem> orderItems = new ArrayList<>();
            
            for (CartItem cartItem : cart.getItems()) {
                Integer productId = callIntGetter(cartItem, "getProductId", "getPid", "getId");
                Integer quantity = callIntGetter(cartItem, "getQty", "getQuantity", "getAmount");
                BigDecimal price = callBDGetter(cartItem, "getPrice", "getUnitPrice");
                
                // Nếu không có price, tính từ subtotal
                if (price == null) {
                    BigDecimal subtotal = callBDGetter(cartItem, "getSubtotal", "getTotal", "getTotalPrice");
                    if (subtotal != null && quantity != null && quantity > 0) {
                        price = subtotal.divide(new BigDecimal(quantity), 2, RoundingMode.HALF_UP);
                    }
                }
                
                // Skip invalid items
                if (productId == null || productId <= 0 
                        || quantity == null || quantity <= 0 
                        || price == null || price.compareTo(BigDecimal.ZERO) <= 0) {
                    continue;
                }

                // Create OrderItem
                Order.OrderItem orderItem = new Order.OrderItem();
                orderItem.setProductId(productId);
                orderItem.setQuantity(quantity);
                orderItem.setPrice(price);

                // Lấy size và color
                String size = callStrGetter(cartItem, "getSize");
                String color = callStrGetter(cartItem, "getColor");
                
                if (size != null && !size.equals("(NULL)") && !size.trim().isEmpty()) {
                    orderItem.setSize(size);
                }
                if (color != null && !color.equals("(NULL)") && !color.trim().isEmpty()) {
                    orderItem.setColor(color);
                }

                orderItems.add(orderItem);
            }

            // Kiểm tra có items không
            if (orderItems.isEmpty()) {
                req.setAttribute("error", "Giỏ hàng không hợp lệ.");
                Map<String, Object> normalized = normalizeCart(cart);
                req.setAttribute("lines", normalized.get("lines"));
                req.setAttribute("sum", normalized.get("sum"));
                fillUserPrefill(session, req);
                req.getRequestDispatcher("/checkout.jsp").forward(req, resp);
                return;
            }

            // ===== TẠO ORDER VỚI TRANSACTION =====
            int orderId = orderDAO.createOrderWithItems(
                userId, 
                fullname, 
                phone, 
                address, 
                note, 
                totalAmount, 
                orderItems,
                paymentMethod,
                ewalletType
            );

            if (orderId <= 0) {
                req.setAttribute("error", "Không thể tạo đơn hàng. Vui lòng thử lại sau.");
                Map<String, Object> normalized = normalizeCart(cart);
                req.setAttribute("lines", normalized.get("lines"));
                req.setAttribute("sum", normalized.get("sum"));
                fillUserPrefill(session, req);
                req.getRequestDispatcher("/checkout.jsp").forward(req, resp);
                return;
            }

            // ===== XÓA CART SAU KHI ĐẶT HÀNG THÀNH CÔNG =====
            session.removeAttribute("cart");

            if (userId != null) {
                try {
                    cartDAO.clearCartByUserId(userId);
                } catch (Exception e) {
                    System.err.println("[WARN] Không thể xóa cart trong DB cho userId=" + userId + ": " + e.getMessage());
                }
            }

            // ===== REDIRECT TO ORDER DETAIL =====
            resp.sendRedirect(req.getContextPath() + "/orders?id=" + orderId);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Có lỗi khi đặt hàng: " + e.getMessage());
            Map<String, Object> normalized = normalizeCart(cart);
            req.setAttribute("lines", normalized.get("lines"));
            req.setAttribute("sum", normalized.get("sum"));
            fillUserPrefill(session, req);
            req.getRequestDispatcher("/checkout.jsp").forward(req, resp);
        }
    }
}