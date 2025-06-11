package controllerUser;

import dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.UserDTO;
import utils.EmailUtils;
import utils.PasswordUtil;

public class RegisterController extends HttpServlet {

    private UserDAO userDAO = new UserDAO();


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String username = request.getParameter("username").trim();
            String email = request.getParameter("email").trim();
            String rawPwd = request.getParameter("password").trim();

            if (username.isEmpty() || email.isEmpty() || rawPwd.isEmpty()) {
                request.setAttribute("message", "Username, Email và Password là bắt buộc!");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            if (userDAO.isEmailOrUsernameExists(email, username)) {
                request.setAttribute("message", "Username hoặc Email đã tồn tại!");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            String hashedPwd = PasswordUtil.hashMD5(rawPwd);
            String verify_code = generateVerifyCode();

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
            user.setVerifyCode(verify_code);

            boolean success = userDAO.registerUser(user);

            if (success) {
                try {
                    EmailUtils.sendEmail(email, verify_code);

                    // Lưu vào session để verify.jsp dùng lại
                    HttpSession session = request.getSession();
                    session.setAttribute("PENDING_USER", user);
                    session.setAttribute("VERIFY_EMAIL", email);

                    request.setAttribute("message", "Đăng ký thành công! Vui lòng kiểm tra email để xác minh tài khoản.");
                    request.setAttribute("email", email);
                    request.getRequestDispatcher("verify.jsp").forward(request, response);
                } catch (Exception e) {
                    e.printStackTrace();
                    request.setAttribute("message", "Đăng ký thành công nhưng gửi email xác minh thất bại.");
                    request.getRequestDispatcher("register.jsp").forward(request, response);
                }
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

    private String generateVerifyCode() {
        int code = (int)(Math.random() * 900000) + 100000;
        return String.valueOf(code);
    }

    @Override
    public String getServletInfo() {
        return "Đăng ký người dùng với xác minh email";
    }
} 