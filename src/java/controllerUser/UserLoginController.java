/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controllerUser;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import models.UserDTO;
import service.UserService;

/**
 *
 * @author nguye
 */
@WebServlet(name = "UserLoginController", urlPatterns = {"/user-login"})
public class UserLoginController extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String emailOrUsername = request.getParameter("emailOrUsername");
        String password = request.getParameter("password");

        // Kiểm tra đầu vào
        if (emailOrUsername == null || emailOrUsername.trim().isEmpty()
                || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Email/Username và mật khẩu là bắt buộc.");
            request.getRequestDispatcher("./Login").forward(request, response);
            return;
        }

        try {
            System.out.println("UserLoginController: Thử xác thực user: " + emailOrUsername);
            UserDTO user = userService.authenticateUser(emailOrUsername, password);
            if (user != null) {
                // Đăng nhập thành công, lưu user vào session
                request.getSession().setAttribute("user", user);

                // Kiểm tra xem user đã hoàn thiện hồ sơ chưa
                if (!userService.isProfileComplete(user)) {
                    // Chưa hoàn thiện, chuyển hướng đến trang hoàn thiện hồ sơ
                    String completeProfileUrl = getCompleteProfileUrl(user.getRole());
                    response.sendRedirect(request.getContextPath() + completeProfileUrl);
                } else {
                    // Đã hoàn thiện, chuyển hướng đến dashboard
                    String redirectUrl = getDashboardUrl(user.getRole());
                    response.sendRedirect(request.getContextPath() + redirectUrl);
                }
            } else {
                // Nếu không phải user, thử đăng nhập với AdminLoginController
                System.out.println("UserLoginController: Không phải user, chuyển sang AdminLoginController");
                request.setAttribute("emailOrUsername", emailOrUsername);
                request.setAttribute("password", password);
                request.getRequestDispatcher("/AdminLoginController").forward(request, response);
            }
        } catch (SQLException e) {
            System.err.println("UserLoginController: Lỗi SQL: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Lỗi kết nối: " + e.getMessage());
            request.getRequestDispatcher("./Login").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("./Login").forward(request, response);
    }

    private String getDashboardUrl(String role) {
        if (role == null) {
            return "/default/dashboard";
        }
        switch (role.toLowerCase()) {
            case "customer":
                return "/home";
            case "staff":
                return "/manage-page.jsp";
            default:
                return "/default/dashboard";
        }
    }

    private String getCompleteProfileUrl(String role) {
        if (role == null) {
            return "/default/completeProfile";
        }
        switch (role.toLowerCase()) {
            case "customer":
                return "/completeProfile.jsp";
            case "staff":
                return "/completeProfile.jsp";
            default:
                return "/default/completeProfile";
        }
    }

    @Override
    public String getServletInfo() {
        return "Xử lý đăng nhập cho user";
    }
}
