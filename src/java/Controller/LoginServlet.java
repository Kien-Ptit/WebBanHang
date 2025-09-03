/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller;

import Dal.UserDAO;
import Model.User;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author Admin
 */
@WebServlet(name="LoginServlet", urlPatterns={"/login"})
public class LoginServlet extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
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
            out.println("<title>Servlet LoginServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LoginServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // If user is already logged in, redirect to dashboard
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            redirectBasedOnRole(user, response);
            return;
        }
        response.sendRedirect("login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Set UTF-8 encoding
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String usernameOrEmail = request.getParameter("username");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe");

        // Validate input
        if (usernameOrEmail == null || usernameOrEmail.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            response.sendRedirect("login.jsp?error=required");
            return;
        }
        try {
            UserDAO userDAO = new UserDAO();
            // Authenticate user
            User user = userDAO.authenticate(usernameOrEmail.trim(), password);

            if (user != null) {
                // Check if user account is active
                if (user.getStatus() != null && !"active".equals(user.getStatus())) {
                    response.sendRedirect("login.jsp?error=inactive");
                    return;
                }

                // Create session
                HttpSession session = request.getSession(true);
                session.setAttribute("user", user);
                session.setAttribute("userId", user.getId());
                session.setAttribute("username", user.getUsername());
                session.setAttribute("userRole", user.getRole());
                
                // Create full name
                String fullName = user.getFirstName() + " " + user.getLastName();
                session.setAttribute("userFullName", fullName);

                // Set session timeout (30 minutes)
                session.setMaxInactiveInterval(30 * 60);

                // Handle "Remember Me" functionality
                if ("on".equals(rememberMe)) {
                    // Set session timeout to 7 days for remember me
                    session.setMaxInactiveInterval(7 * 24 * 60 * 60);
                }

                // Log successful login
                System.out.println("✅ User logged in: " + user.getUsername() + " (" + user.getRole() + ")");

                // Redirect based on user role
                redirectBasedOnRole(user, response);

            } else {
                // Authentication failed
                System.out.println("❌ Login failed for: " + usernameOrEmail);
                response.sendRedirect("login.jsp?error=invalid");
            }

        } catch (Exception e) {
            System.err.println("❌ Login error: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=system");
        }
    }

    private void redirectBasedOnRole(User user, HttpServletResponse response) throws IOException {
        String redirectURL;
        
        String role = user.getRole() != null ? user.getRole().toLowerCase() : "customer";
        
        switch (role) {
            case "admin":
                redirectURL = "admin/dashboard.jsp";
                break;
            case "manager":
                redirectURL = "manager/dashboard.jsp";
                break;
            case "customer":
            default:
                redirectURL = "index.jsp";
                break;
        }
        
        System.out.println("🔄 Redirecting " + user.getRole() + " to: " + redirectURL);
        response.sendRedirect(redirectURL);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
