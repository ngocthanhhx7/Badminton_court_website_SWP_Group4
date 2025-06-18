/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controllerUser;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import service.UserService;

public class RegistrationController extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Lấy các tham số từ form với xử lý null an toàn
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        // Xử lý null values
        username = (username != null) ? username.trim() : "";
        email = (email != null) ? email.trim() : "";
        password = (password != null) ? password.trim() : "";
        role = (role != null) ? role.trim() : "Customer"; // Default role

        // Retain form values in case of error
        request.setAttribute("username", username);
        request.setAttribute("email", email);
        request.setAttribute("role", role);

        // Basic validation
        if (username.isEmpty() || email.isEmpty() || password.isEmpty()) {
            request.setAttribute("error", "Vui lòng điền đầy đủ Username, Email và Password.");
            request.setAttribute("form", "register");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        try {
            if (userService.registerUser(username, email, password, role, "")) {
                HttpSession session = request.getSession();
                session.setAttribute("successMessage", "Đã đăng ký thành công, vui lòng đăng nhập!");
                response.sendRedirect(request.getContextPath() + "/UserLoginController");
            } else {
                request.setAttribute("error", "Username hoặc Email đã tồn tại.");
                request.setAttribute("form", "register");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi đăng ký: " + e.getMessage());
            request.setAttribute("form", "register");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("form", "register");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }
}
