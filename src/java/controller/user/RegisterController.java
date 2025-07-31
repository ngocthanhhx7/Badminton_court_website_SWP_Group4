package controller.user;

import dal.UserDAO;
import dal.EmailVerificationDAO;
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
    private EmailVerificationDAO emailVerificationDAO = new EmailVerificationDAO();


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String rawPwd = request.getParameter("password");
            String phone = request.getParameter("phone");
            String role = request.getParameter("role");

            // Trim và xử lý null
            username = (username != null) ? username.trim() : "";
            email = (email != null) ? email.trim() : "";
            rawPwd = (rawPwd != null) ? rawPwd.trim() : "";
            phone = (phone != null && !phone.trim().isEmpty()) ? phone.trim() : null;
            role = (role != null) ? role.trim() : "Customer";

            // Debug
            System.out.println("RegisterController - Phone: '" + phone + "'");

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

            String hashedPwd = PasswordUtil.hashPassword(rawPwd);

            UserDTO user = new UserDTO();
            user.setUsername(username);
            user.setEmail(email);
            user.setPassword(hashedPwd);
            user.setFullName(null);
            user.setDob(null);
            user.setGender(null);
            user.setPhone(phone); 
            user.setAddress(null);
            user.setSportLevel("Beginner");
            user.setRole(role);
            user.setStatus("Active");
            user.setCreatedBy(1); 
            // Không set VerifyCode vào UserDTO nữa

            boolean success = userDAO.registerUser(user);

            if (success) {
                try {
                    // Lấy user vừa tạo để có UserID
                    UserDTO newUser = userDAO.getUserByEmail(email);
                    
                    if (newUser != null) {
                        // Tạo verification record trong bảng EmailVerifications
                        String verifyCode = emailVerificationDAO.createVerification(newUser.getUserID(), email);
                        
                        if (verifyCode != null) {
                            EmailUtils.sendVerificationEmail(email, verifyCode);

                            // Lưu vào session để verify.jsp dùng lại
                            HttpSession session = request.getSession();
                            // Tạo UserDTO với verify code để session sử dụng
                            UserDTO pendingUser = new UserDTO();
                            pendingUser.setUserID(newUser.getUserID());
                            pendingUser.setUsername(username);
                            pendingUser.setEmail(email);
                            pendingUser.setVerifyCode(verifyCode);
                            
                            session.setAttribute("PENDING_USER", pendingUser);
                            session.setAttribute("VERIFY_EMAIL", email);

                            request.setAttribute("message", "Đăng ký thành công! Vui lòng kiểm tra email để xác minh tài khoản.");
                            request.setAttribute("email", email);
                            request.getRequestDispatcher("verify.jsp").forward(request, response);
                        } else {
                            request.setAttribute("message", "Đăng ký thành công nhưng không thể tạo mã xác minh.");
                            request.getRequestDispatcher("register.jsp").forward(request, response);
                        }
                    } else {
                        request.setAttribute("message", "Đăng ký thành công nhưng có lỗi hệ thống.");
                        request.getRequestDispatcher("register.jsp").forward(request, response);
                    }
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