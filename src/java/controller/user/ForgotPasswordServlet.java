package controller.user;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.UserService;
import utils.EmailUtils;
import utils.VerificationCodeUtils;

@WebServlet(name = "ForgotPasswordServlet", urlPatterns = {"/ForgotPasswordServlet"})
public class ForgotPasswordServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");

        // Store email for form persistence
        request.setAttribute("email", email);

        // Validate input
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập email.");
            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
            return;
        }

        if (email == null || !email.matches("^[\\w.%+-]+@[\\w.-]+\\.com$")) {
            request.setAttribute("error", "Vui lòng nhập địa chỉ email hợp lệ có đuôi .com.");
            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
            return;
        }

        try {
            // Check if email exists in the system
            if (userService.isEmailOrUsernameExists(email, null)) {
                // Generate verification code
                String verificationCode = VerificationCodeUtils.generateVerificationCode();
                
                // Store verification code
                VerificationCodeUtils.storeVerificationCode(email, verificationCode);
                
                // Send verification email
                try {
                    EmailUtils.sendPasswordResetVerificationEmail(email, verificationCode);
                    
                    // Redirect to verification page with email
                    request.setAttribute("email", email);
                    request.setAttribute("success", "Mã xác minh đã được gửi đến email của bạn. Vui lòng kiểm tra hộp thư.");
                    request.getRequestDispatcher("verify-reset-code.jsp").forward(request, response);
                    
                } catch (Exception emailEx) {
                    emailEx.printStackTrace();
                    request.setAttribute("error", "Không thể gửi email xác minh. Vui lòng thử lại sau.");
                    request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
                }
                
            } else {
                request.setAttribute("error", "Email không tồn tại trong hệ thống.");
                request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi xử lý yêu cầu: " + e.getMessage());
            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
        }
    }
}