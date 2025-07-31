package controller.user;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.UserService;

@WebServlet(name="ForgotPasswordServlet", urlPatterns={"/forget-password"})
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
            // Check if email exists
            if (userService.isEmailOrUsernameExists(email, null)) {
                // Redirect to reset password page with email
                request.setAttribute("email", email);
                request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
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