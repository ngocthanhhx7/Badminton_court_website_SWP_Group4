//package controllerUser;
//
//import java.io.IOException;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import models.UserDTO;
//import service.UserService;
//
//@WebServlet(name = "ResetPasswordServlet", urlPatterns = {"/ResetPasswordServlet","/admin/Login"})
//public class ResetPasswordServlet extends HttpServlet {
//
//    private UserService userService;
//
//    @Override
//    public void init() throws ServletException {
//        userService = new UserService();
//    }
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        String email = request.getParameter("email");
//        String newPassword = request.getParameter("password");
//        String confirmPassword = request.getParameter("confirmPassword");
//
//        // Store email for form persistence
//        request.setAttribute("email", email);
//
//        // Validate input
//        if (newPassword == null || newPassword.trim().isEmpty() || confirmPassword == null || confirmPassword.trim().isEmpty()) {
//            request.setAttribute("error", "Vui lòng nhập đầy đủ mật khẩu và xác nhận mật khẩu.");
//            request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
//            return;
//        }
//
//        if (!newPassword.equals(confirmPassword)) {
//            request.setAttribute("error", "Mật khẩu và xác nhận mật khẩu không khớp.");
//            request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
//            return;
//        }
//
//        try {
//            // Fetch current user to get old password
//            UserDTO user = userService.authenticateUser(email, ""); // Temporary placeholder, adjust logic
//            if (user != null && user.getPassword() != null && userService.authenticateUser(email, newPassword) != null) {
//                request.setAttribute("error", "Mật khẩu bị trùng với mật khẩu cũ.");
//                request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
//                return;
//            }
//
//            // Update password if validation passes (handled in UserService/UserDAO)
//            if (userService.updatePassword(email, newPassword)) {
//    request.setAttribute("success", "Mật khẩu đã được thay đổi.");
//    // Thay vì forward, dùng sendRedirect để thay đổi URL
//    response.sendRedirect(request.getContextPath() + "/Login");
//            } else {
//                request.setAttribute("error", "Không thể thay đổi mật khẩu. Vui lòng thử lại.");
//                request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//            request.setAttribute("error", "Lỗi khi xử lý yêu cầu: " + e.getMessage());
//            request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
//        }
//    }
//}
package controllerUser;

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
        request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String newPassword = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        request.setAttribute("email", email);

        if (newPassword == null || newPassword.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ mật khẩu và xác nhận mật khẩu.");
            request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu và xác nhận mật khẩu không khớp.");
            request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
            return;
        }

        try {
            UserDTO user = userService.getUserByEmail(email); // ✅ Hàm mới trong UserService
            if (user != null && user.getPassword() != null &&
                BCrypt.checkpw(newPassword, user.getPassword())) {
                request.setAttribute("error", "Mật khẩu bị trùng với mật khẩu cũ.");
                request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
                return;
            }

             if (userService.updatePassword(email, newPassword)) {
    try {
        String subject = "Xác nhận thay đổi mật khẩu";

        
        EmailUtils.sendPasswordChangedEmail(email, newPassword);
    } catch (Exception mailEx) {
        mailEx.printStackTrace(); // Không dừng hệ thống nếu lỗi gửi email
    }

    response.sendRedirect(request.getContextPath() + "/Login");
}else {
                request.setAttribute("error", "Không thể thay đổi mật khẩu. Vui lòng thử lại.");
                request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi xử lý yêu cầu: " + e.getMessage());
            request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
        }
    }
}