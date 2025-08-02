package controller.user;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.UserDTO;
import dao.UserDAO;
import utils.PasswordUtil;
import java.sql.SQLException;

@WebServlet(name="ChangePasswordController", urlPatterns={"/change-password"})
public class ChangePasswordController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession();
        Object accObj = session.getAttribute("acc");
        String accType = (String) session.getAttribute("accType");
        
        // Kiểm tra xem user đã đăng nhập chưa
        if (accObj == null || !"user".equals(accType)) {
            response.sendRedirect("Login.jsp");
            return;
        }
        
        // Chuyển hướng đến trang đổi password
        request.getRequestDispatcher("change-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession();
        Object accObj = session.getAttribute("acc");
        String accType = (String) session.getAttribute("accType");
        
        // Kiểm tra xem user đã đăng nhập chưa
        if (accObj == null || !"user".equals(accType)) {
            response.sendRedirect("Login.jsp");
            return;
        }
        
        UserDTO user = (UserDTO) accObj;
        
        // Lấy dữ liệu từ form
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validate input
        if (currentPassword == null || currentPassword.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập mật khẩu hiện tại!");
            request.getRequestDispatcher("change-password.jsp").forward(request, response);
            return;
        }
        
        if (newPassword == null || newPassword.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập mật khẩu mới!");
            request.getRequestDispatcher("change-password.jsp").forward(request, response);
            return;
        }
        
        if (confirmPassword == null || confirmPassword.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng xác nhận mật khẩu mới!");
            request.getRequestDispatcher("change-password.jsp").forward(request, response);
            return;
        }
        
        // Kiểm tra độ dài mật khẩu mới
        if (newPassword.length() < 6) {
            request.setAttribute("error", "Mật khẩu mới phải có ít nhất 6 ký tự!");
            request.getRequestDispatcher("change-password.jsp").forward(request, response);
            return;
        }
        
        // Kiểm tra mật khẩu mới và xác nhận có khớp không
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu mới và xác nhận mật khẩu không khớp!");
            request.getRequestDispatcher("change-password.jsp").forward(request, response);
            return;
        }
        
        // Kiểm tra mật khẩu hiện tại có đúng không
        if (!PasswordUtil.checkPassword(currentPassword, user.getPassword())) {
            request.setAttribute("error", "Mật khẩu hiện tại không đúng!");
            request.getRequestDispatcher("change-password.jsp").forward(request, response);
            return;
        }
        
        // Kiểm tra mật khẩu mới có giống mật khẩu cũ không
        if (PasswordUtil.checkPassword(newPassword, user.getPassword())) {
            request.setAttribute("error", "Mật khẩu mới phải khác mật khẩu hiện tại!");
            request.getRequestDispatcher("change-password.jsp").forward(request, response);
            return;
        }
        
        try {
            UserDAO userDAO = new UserDAO();
            
            // Hash mật khẩu mới trước khi cập nhật
            String hashedNewPassword = PasswordUtil.hashPassword(newPassword);
            boolean isUpdated = userDAO.updatePassword(user.getEmail(), hashedNewPassword);
            
            if (isUpdated) {
                // Cập nhật password trong session
                user.setPassword(hashedNewPassword);
                session.setAttribute("acc", user);
                
                request.setAttribute("success", "Đổi mật khẩu thành công!");
                request.getRequestDispatcher("change-password.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi cập nhật mật khẩu. Vui lòng thử lại!");
                request.getRequestDispatcher("change-password.jsp").forward(request, response);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("change-password.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Controller for changing user password";
    }
}
