package controllerUser;

import dao.AdminDAO;
import dao.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.AdminDTO;
import models.UserDTO;

/**
 *
 * @author PC - ACER
 */
@WebServlet(name = "loginController", urlPatterns = {"/Login"})
public class loginController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
//        response.setContentType("text/html;charset=UTF-8");
//        String Username = request.getParameter("Username");
//        String Password = request.getParameter("Password");
//        DAO dao = new DAO();
//        Admins a = dao.login(Username, Password);
//        if (a == null) {
//            request.setAttribute("mess", "Wrong user or password");
//            request.getRequestDispatcher("Login.jsp").forward(request, response);
//        } else {
//            HttpSession session = request.getSession();
//            session.setAttribute("acc", a);
//            //session.setMaxInactiveInterval(1000);
//            response.sendRedirect("Success.jsp");
//        }

    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
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

            handleRememberMe(request, response, emailOrUsername, password);

            response.sendRedirect("./home");
            return;
        }

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("acc", user);
            session.setAttribute("accType", "user");

            handleRememberMe(request, response, emailOrUsername, password);

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
            idCookie.setMaxAge(0);
            pwCookie.setMaxAge(0);
            response.addCookie(idCookie);
            response.addCookie(pwCookie);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
