/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controllerUser;

import dao.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import models.UserDTO;
import utils.PasswordUtil;

/**
 *
 * @author nguye
 */
public class RegisterController extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //processRequest(request, response);
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Lấy các tham số từ form với xử lý null an toàn
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String rawPwd = request.getParameter("password");

            // Xử lý null values
            username = (username != null) ? username.trim() : "";
            email = (email != null) ? email.trim() : "";
            rawPwd = (rawPwd != null) ? rawPwd.trim() : "";

            // Validate bắt buộc
            if (username.isEmpty() || email.isEmpty() || rawPwd.isEmpty()) {
                request.setAttribute("message", "Username, Email và Password là bắt buộc!");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            // Kiểm tra tồn tại
            if (userDAO.isEmailOrUsernameExists(email, username)) {
                request.setAttribute("message", "Username hoặc Email đã tồn tại!");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            // Mã hoá mật khẩu
            String hashedPwd = PasswordUtil.hashMD5(rawPwd);

            // Tạo DTO với chỉ 3 trường, các trường khác để null
            UserDTO user = new UserDTO();
            user.setUsername(username);
            user.setEmail(email);
            user.setPassword(hashedPwd);
            user.setFullName(null);
            user.setDob(null);
            user.setGender(null);
            user.setPhone(null);
            user.setAddress(null);
            user.setSportLevel(null);
            user.setRole("Customer");
            user.setStatus("Active");
            user.setCreatedBy(null);

            boolean success = userDAO.registerUser(user);
            if (success) {
                request.setAttribute("message", "Đăng ký thành công! Vui lòng đăng nhập.");
                response.sendRedirect("Login.jsp");
            } else {
                request.setAttribute("message", "Đăng ký thất bại! Vui lòng thử lại.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
