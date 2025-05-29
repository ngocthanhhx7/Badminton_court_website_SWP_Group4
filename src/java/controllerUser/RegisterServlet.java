/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controllerUser;

import dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import models.UserDTO;

/**
 *
 * @author Admin
 */
@WebServlet(name = "RegisterServlet", urlPatterns = {"/RegisterServlet"})
public class RegisterServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Lấy dữ liệu từ form
            String username = request.getParameter("username").trim();
            String email = request.getParameter("email").trim();
            String password = request.getParameter("password").trim();
            String fullname = request.getParameter("fullname");
            String dobStr = request.getParameter("dob");
            String gender = request.getParameter("gender");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String sportlevel = request.getParameter("sportlevel");

            // Validate bắt buộc
            if (username.isEmpty() || email.isEmpty() || password.isEmpty()) {
                request.setAttribute("message", "Username, Email và Password là bắt buộc!");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            // Kiểm tra username hoặc email đã tồn tại
            if (userDAO.isEmailOrUsernameExists(email, username)) {
                request.setAttribute("message", "Username hoặc Email đã tồn tại!");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            // Kiểm tra số điện thoại nếu nhập
            if (phone != null && !phone.trim().isEmpty()) {
                if (userDAO.isPhoneExists(phone)) {
                    request.setAttribute("message", "Số điện thoại đã được sử dụng!");
                    request.getRequestDispatcher("register.jsp").forward(request, response);
                    return;
                }
            }

            // Tạo UserDTO
            UserDTO user = new UserDTO();
            user.setUsername(username);
            user.setEmail(email);
            user.setPassword(hashPassword(password)); // Hash mật khẩu
            user.setFullName(fullname != null && !fullname.isEmpty() ? fullname : null);

            if (dobStr != null && !dobStr.isEmpty()) {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                user.setDob(sdf.parse(dobStr));
            }

            user.setGender(gender != null && !gender.isEmpty() ? gender : null);
            user.setPhone(phone != null && !phone.isEmpty() ? phone : null);
            user.setAddress(address != null && !address.isEmpty() ? address : null);
            user.setSportLevel(sportlevel != null && !sportlevel.isEmpty() ? sportlevel : null);
            user.setRole("Customer"); // Mặc định role Customer
            user.setStatus("Active"); // Mặc định active
            user.setCreatedBy(null);  // Người dùng tự đăng ký

            boolean success = userDAO.registerUserBasic(user);

            if (success) {
                // Đăng ký thành công -> redirect trang home
                response.sendRedirect("./login");
                return;
            } else {
                request.setAttribute("message", "Đăng ký thất bại, vui lòng thử lại.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }

    private String hashPassword(String password) throws Exception {
        java.security.MessageDigest md = java.security.MessageDigest.getInstance("MD5");
        md.update(password.getBytes());
        byte[] digest = md.digest();
        StringBuilder sb = new StringBuilder();
        for (byte b : digest) {
            sb.append(String.format("%02x", b & 0xff));
        }
        return sb.toString();
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
