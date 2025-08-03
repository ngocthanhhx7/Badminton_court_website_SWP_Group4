package controller.user;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.VerificationCodeUtils;

@WebServlet(name = "VerifyResetCodeServlet", urlPatterns = {"/VerifyResetCodeServlet"})
public class VerifyResetCodeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect to forgot password if accessed directly
        response.sendRedirect(request.getContextPath() + "/ForgotPasswordServlet");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String verificationCode = request.getParameter("verificationCode");
        String action = request.getParameter("action");

        // Store email for form persistence
        request.setAttribute("email", email);

        // Handle resend code action
        if ("resend".equals(action)) {
            // Redirect to ForgotPasswordServlet to resend code
            request.setAttribute("email", email);
            request.getRequestDispatcher("/ForgotPasswordServlet").forward(request, response);
            return;
        }

        // Validate input
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Email không hợp lệ.");
            request.getRequestDispatcher("verify-reset-code.jsp").forward(request, response);
            return;
        }

        if (verificationCode == null || verificationCode.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập mã xác minh.");
            request.getRequestDispatcher("verify-reset-code.jsp").forward(request, response);
            return;
        }

        // Validate verification code format (6 digits)
        if (!verificationCode.matches("\\d{6}")) {
            request.setAttribute("error", "Mã xác minh phải là 6 chữ số.");
            request.getRequestDispatcher("verify-reset-code.jsp").forward(request, response);
            return;
        }

        try {
            // Verify the code
            if (VerificationCodeUtils.verifyCode(email, verificationCode)) {
                // Code is valid, remove it and redirect to reset password
                VerificationCodeUtils.removeVerificationCode(email);
                
                // Forward to reset password page with verified email
                request.setAttribute("email", email);
                request.setAttribute("verified", true);
                request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
                
            } else {
                // Check if code has expired or invalid
                if (VerificationCodeUtils.hasValidCode(email)) {
                    request.setAttribute("error", "Mã xác minh không đúng. Vui lòng kiểm tra lại.");
                } else {
                    request.setAttribute("error", "Mã xác minh đã hết hạn hoặc không tồn tại. Vui lòng yêu cầu mã mới.");
                }
                request.getRequestDispatcher("verify-reset-code.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi xác minh mã: " + e.getMessage());
            request.getRequestDispatcher("verify-reset-code.jsp").forward(request, response);
        }
    }
}
