package controller.user;

import dal.UserDAO;
import dal.EmailVerificationDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.UserDTO;

@WebServlet(name = "VerifyController", urlPatterns = {"/verify"})
public class VerifyController extends HttpServlet {

    private UserDAO userDAO = new UserDAO();
    private EmailVerificationDAO emailVerificationDAO = new EmailVerificationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        UserDTO pendingUser = (UserDTO) session.getAttribute("PENDING_USER");
        
        if (pendingUser == null) {
            // Không có user pending, redirect về register
            response.sendRedirect(request.getContextPath() + "/register.jsp");
            return;
        }
        
        // Forward đến verify.jsp
        request.getRequestDispatcher("verify.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String code = request.getParameter("code");
        String email = request.getParameter("email");
        
        HttpSession session = request.getSession();
        UserDTO pendingUser = (UserDTO) session.getAttribute("PENDING_USER");
        
        // Validation
        if (code == null || code.trim().isEmpty()) {
            request.setAttribute("message", "Vui lòng nhập mã xác minh.");
            request.getRequestDispatcher("verify.jsp").forward(request, response);
            return;
        }
        
        if (pendingUser == null) {
            request.setAttribute("message", "Phiên làm việc đã hết hạn. Vui lòng đăng ký lại.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        // Kiểm tra mã xác minh từ bảng EmailVerifications
        try {
            if (emailVerificationDAO.verifyCode(email, code.trim())) {
                // Xóa thông tin pending khỏi session
                session.removeAttribute("PENDING_USER");
                session.removeAttribute("VERIFY_EMAIL");
                
                // Thông báo thành công và redirect về login
                session.setAttribute("successMessage", "Xác minh tài khoản thành công! Bạn có thể đăng nhập ngay bây giờ.");
                response.sendRedirect(request.getContextPath() + "/Login");
            } else {
                // Mã xác minh sai hoặc hết hạn
                request.setAttribute("message", "Mã xác minh không đúng hoặc đã hết hạn. Vui lòng kiểm tra lại.");
                request.getRequestDispatcher("verify.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("verify.jsp").forward(request, response);
        }
    }
}
