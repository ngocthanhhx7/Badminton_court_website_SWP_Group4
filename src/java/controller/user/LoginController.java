package controller.user;

import dao.AdminDAO;
import dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.AdminDTO;
import models.UserDTO;

public class LoginController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String mess = (String) session.getAttribute("mess");
        if (mess != null) {
            request.setAttribute("mess", mess);
            session.removeAttribute("mess");
        }

        Cookie[] cookies = request.getCookies();
        String savedIdentifier = "";
        String savedPassword = "";

        if (cookies != null) {
            for (Cookie c : cookies) {
                if (c.getName().equals("loginIdentifier")) {
                    savedIdentifier = c.getValue();
                }
                if (c.getName().equals("loginPassword")) {
                    savedPassword = c.getValue();
                }
            }
        }

        request.setAttribute("savedIdentifier", savedIdentifier);
        request.setAttribute("savedPassword", savedPassword);
        request.setAttribute("rememberChecked", !savedIdentifier.isEmpty());
        request.getRequestDispatcher("Login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String emailOrUsername = request.getParameter("emailOrUsername");
        String password = request.getParameter("password");

        if (emailOrUsername == null || emailOrUsername.trim().isEmpty()
                || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Email/Username và mật khẩu là bắt buộc.");
            request.getRequestDispatcher("Login.jsp").forward(request, response);
            return;
        }

        AdminDAO adminDao = new AdminDAO();
        UserDAO userDao = new UserDAO();

        AdminDTO admin = adminDao.loginWithEmailOrUsername(emailOrUsername, password);
        UserDTO user = userDao.loginWithEmailOrUsername(emailOrUsername, password);

        HttpSession session = request.getSession();

        if (admin != null) {
            if (!"Active".equalsIgnoreCase(admin.getStatus())) {
                request.setAttribute("error", "Tài khoản của bạn đã bị khóa.");
                request.getRequestDispatcher("Login.jsp").forward(request, response);
                return;
            }

            session.setAttribute("acc", admin);
            session.setAttribute("accType", "admin");
            session.setAttribute("username", admin.getUsername());
            session.setAttribute("userID", admin.getAdminID());
            session.setAttribute("role", "admin");

            handleRememberMe(request, response, emailOrUsername, password);
            response.sendRedirect("./home");
            return;
        }

        if (user != null) {
            if (!"Active".equalsIgnoreCase(user.getStatus())) {
                request.setAttribute("error", "Tài khoản của bạn đã bị khóa.");
                request.getRequestDispatcher("Login.jsp").forward(request, response);
                return;
            }

            session.setAttribute("acc", user);
            session.setAttribute("accType", "user");
            session.setAttribute("username", user.getUsername());
            session.setAttribute("userID", user.getUserID());
            session.setAttribute("role", user.getRole());

            handleRememberMe(request, response, emailOrUsername, password);

            // Nếu profile chưa đầy đủ thì chuyển hướng đến trang bổ sung
            if (user.getFullName() == null || user.getDob() == null || user.getGender() == null ||
                user.getPhone() == null || user.getAddress() == null || user.getSportLevel() == null) {
                session.setAttribute("currentUser", user);
                response.sendRedirect("completeProfile.jsp");
                return;
            }

            String role = user.getRole();
            if (role != null) {
                switch (role.toLowerCase()) {
                    case "customer":
                        response.sendRedirect("./home");
                        return;
                    case "staff":
                        response.sendRedirect("./page-manager");
                        return;
                }
            }

            response.sendRedirect("./home");
            return;
        }

        // Đăng nhập sai
        request.setAttribute("error", "Sai email/username hoặc mật khẩu.");
        request.getRequestDispatcher("Login.jsp").forward(request, response);
    }

    private void handleRememberMe(HttpServletRequest request, HttpServletResponse response, String identifier, String password) {
        String remember = request.getParameter("remember_me");
        if ("on".equals(remember)) {
            Cookie idCookie = new Cookie("loginIdentifier", identifier);
            Cookie pwCookie = new Cookie("loginPassword", password); // Khuyến khích mã hóa
            idCookie.setMaxAge(60 * 60 * 24 * 7);
            pwCookie.setMaxAge(60 * 60 * 24 * 7);
            response.addCookie(idCookie);
            response.addCookie(pwCookie);
        } else {
            Cookie idCookie = new Cookie("loginIdentifier", "");
            Cookie pwCookie = new Cookie("loginPassword", "");
            idCookie.setMaxAge(0);
            pwCookie.setMaxAge(0);
            response.addCookie(idCookie);
            response.addCookie(pwCookie);
        }
    }

    @Override
    public String getServletInfo() {
        return "Handles user/admin login and session management.";
    }
}
