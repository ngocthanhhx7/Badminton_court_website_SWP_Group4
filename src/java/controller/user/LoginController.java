/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.user;

import dal.AdminDAO;
import dal.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.AdminDTO;
import models.UserDTO;

/**
 *
 * @author nguye
 */
public class LoginController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet LoginController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LoginController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

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

        // Kiểm tra đầu vào
if (emailOrUsername == null || emailOrUsername.trim().isEmpty()
                || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Email/Username và mật khẩu là bắt buộc.");
            request.getRequestDispatcher("Login.jsp").forward(request, response);
            return;
        }

        // Khởi tạo DAO
        AdminDAO adminDao = new AdminDAO();
        UserDAO userDao = new UserDAO();

        // Thử đăng nhập với email hoặc username
        AdminDTO admin = adminDao.loginWithEmailOrUsername(emailOrUsername, password);
        UserDTO user = userDao.loginWithEmailOrUsername(emailOrUsername, password);

        if (admin != null) {
            HttpSession session = request.getSession();
            session.setAttribute("acc", admin);
            session.setAttribute("accType", "admin");
             session.setAttribute("username", admin.getUsername()); // ✅ thêm dòng này

            handleRememberMe(request, response, emailOrUsername, password);

            response.sendRedirect("./home");
            return;
        }

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("acc", user);
            session.setAttribute("accType", "user");
            session.setAttribute("username", user.getUsername()); // ✅ thêm dòng này

            // Kiểm tra profile đầy đủ chưa sử dụng method từ ProfileSetupController
            if (!controller.user.ProfileSetupController.isProfileComplete(user)) {
                handleRememberMe(request, response, emailOrUsername, password);
                session.setAttribute("currentUser", user); // Lưu user để dùng trong profile-setup.jsp
                response.sendRedirect("profile-setup.jsp");
                return;
            }

            handleRememberMe(request, response, emailOrUsername, password);
            
            // Chuyển hướng dựa trên Role
            String role = user.getRole();
            if (role != null) {
                switch (role.toLowerCase()) {
                    case "customer":
                        response.sendRedirect("./home");
                        return;
                    case "staff":
                        response.sendRedirect("./page-manager");
                        return;
                    default:
                        response.sendRedirect("./home");
                        return;
                }
            }
            
            response.sendRedirect("./home");
            return;
        }

        // Sai thông tin đăng nhập
        request.setAttribute("error", "Sai email/username hoặc mật khẩu.");
        request.getRequestDispatcher("Login.jsp").forward(request, response);
    }

    private void handleRememberMe(HttpServletRequest request, HttpServletResponse response, String identifier, String password) {
        String remember = request.getParameter("remember_me");
        if ("on".equals(remember)) {
            Cookie idCookie = new Cookie("loginIdentifier", identifier);
            Cookie pwCookie = new Cookie("loginPassword", password); // Thực tế nên mã hóa!

            idCookie.setMaxAge(60 * 60 * 24 * 7); // 7 ngày
            pwCookie.setMaxAge(60 * 60 * 24 * 7);

            response.addCookie(idCookie);
            response.addCookie(pwCookie);
        } else {
            // Xóa cookie nếu user không chọn Remember
            Cookie idCookie = new Cookie("loginIdentifier", "");
            Cookie pwCookie = new Cookie("loginPassword", "");

        }}}

