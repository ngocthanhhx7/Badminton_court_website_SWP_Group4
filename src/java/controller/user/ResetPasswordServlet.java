package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import models.UserDTO;
import service.UserService;
import utils.EmailUtils;
import org.mindrot.jbcrypt.BCrypt;

import utils.EmailUtils;

import models.UserDTO;

import org.mindrot.jbcrypt.BCrypt;

import utils.EmailUtils;

@WebServlet(name = "ResetPasswordServlet", urlPatterns = {"/ResetPasswordServlet", "/admin/Login"})
public class ResetPasswordServlet extends HttpServlet {
    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user has been verified (coming from verification step)
        String verified = request.getParameter("verified");
        String email = request.getParameter("email");
        
        if (!"true".equals(verified) && request.getAttribute("verified") == null) {
            // Redirect to forgot password if not verified
            response.sendRedirect(request.getContextPath() + "/ForgotPasswordServlet");
            return;
        }
        
        request.setAttribute("email", email);
        request.getRequestDispatcher("reset-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String newPassword = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String verified = request.getParameter("verified");

        request.setAttribute("email", email);

        // Check if user has been verified
        if (!"true".equals(verified)) {
            response.sendRedirect(request.getContextPath() + "/ForgotPasswordServlet");
            return;
        }

        if (newPassword == null || newPassword.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ mật khẩu và xác nhận mật khẩu.");
            request.setAttribute("verified", true);
            request.getRequestDispatcher("reset-password.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu và xác nhận mật khẩu không khớp.");
            request.setAttribute("verified", true);
            request.getRequestDispatcher("reset-password.jsp").forward(request, response);
            return;
        }

        try {
            UserDTO user = userService.getUserByEmail(email); // ✅ Hàm mới trong UserService
            if (user != null && user.getPassword() != null &&
                BCrypt.checkpw(newPassword, user.getPassword())) {
                request.setAttribute("error", "Mật khẩu bị trùng với mật khẩu cũ.");
                request.setAttribute("verified", true);
                request.getRequestDispatcher("reset-password.jsp").forward(request, response);
                return;
            }

             if (userService.updatePassword(email, newPassword)) {
                try {
                    EmailUtils.sendPasswordChangedEmail(email, newPassword);
                } catch (Exception mailEx) {
                    mailEx.printStackTrace(); // Không dừng hệ thống nếu lỗi gửi email
                }

                // Add success message and redirect to login
                request.getSession().setAttribute("resetSuccess", "Mật khẩu đã được đặt lại thành công. Vui lòng đăng nhập với mật khẩu mới.");
                response.sendRedirect(request.getContextPath() + "/Login");
            } else {
                request.setAttribute("error", "Không thể thay đổi mật khẩu. Vui lòng thử lại.");
                request.setAttribute("verified", true);
                request.getRequestDispatcher("reset-password.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi xử lý yêu cầu: " + e.getMessage());
            request.setAttribute("verified", true);
            request.getRequestDispatcher("reset-password.jsp").forward(request, response);
        }
    }
}