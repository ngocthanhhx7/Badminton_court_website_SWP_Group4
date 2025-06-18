package controllerUser;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/verify")
public class VerifyController extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    String code = request.getParameter("code");

    HttpSession session = request.getSession();
    String email = null;

    // Ưu tiên lấy email từ session
    Object userObj = session.getAttribute("PENDING_USER");
    if (userObj != null && userObj instanceof models.UserDTO) {
        email = ((models.UserDTO) userObj).getEmail();
    }

    if (email == null) {
        request.setAttribute("message", "Không tìm thấy thông tin email để xác minh.");
        request.getRequestDispatcher("verify.jsp").forward(request, response);
        return;
    }

    boolean success = userDAO.verifyCode(email, code);
    if (success) {
        // Xác minh thành công, có thể xoá session
        session.removeAttribute("PENDING_USER");
        session.removeAttribute("VERIFY_EMAIL");

        request.setAttribute("message", "Xác minh thành công! Bạn có thể đăng nhập.");
        request.getRequestDispatcher("Login.jsp").forward(request, response);
    } else {
        request.setAttribute("message", "Mã xác minh không hợp lệ hoặc đã hết hạn.");
        request.getRequestDispatcher("verify.jsp").forward(request, response);
    }
}

}
