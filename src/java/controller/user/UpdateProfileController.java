/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.user;

import dal.UserDAO;
import dal.AdminDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import models.UserDTO;
import models.AdminDTO;

public class UpdateProfileController extends HttpServlet {

    private UserDAO userDAO = new UserDAO();
    private AdminDAO adminDAO = new AdminDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet UpdateProfileServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UpdateProfileServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
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
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Object sessionUser = session.getAttribute("acc");
        String accType = (String) session.getAttribute("accType");
        
        // Xử lý cho User
        if ("user".equals(accType) && sessionUser instanceof UserDTO) {
            handleUserUpdate(request, response, (UserDTO) sessionUser);
        }
        // Xử lý cho Admin
        else if ("admin".equals(accType) && sessionUser instanceof AdminDTO) {
            handleAdminUpdate(request, response, (AdminDTO) sessionUser);
        }
        else {
            response.sendRedirect("Login.jsp");
        }
    }

    private void handleUserUpdate(HttpServletRequest request, HttpServletResponse response, UserDTO user)
            throws ServletException, IOException {
        
        String password = request.getParameter("password");

        String specialCharRegex = ".*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>/?].*";
        String upperCaseRegex = ".*[A-Z].*";

        if (password != null && password.length() > 0) {
            if (password.length() <= 6
                    || !password.matches(upperCaseRegex)
                    || !password.matches(specialCharRegex)) {

                request.setAttribute("error", "Mật khẩu phải nhiều hơn 6 ký tự, chứa ít nhất 1 chữ in hoa và 1 ký tự đặc biệt.");
                request.getRequestDispatcher("edit-profile.jsp").forward(request, response);
                return;
            }
        } else {
            password = user.getPassword(); 
        }

        user.setPassword(password);

        String fullName = request.getParameter("fullName");
        String dobStr = request.getParameter("dob");
        String gender = request.getParameter("gender");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String sportLevel = request.getParameter("sportlevel");

        if (sportLevel == null || sportLevel.trim().isEmpty()) {
            sportLevel = user.getSportLevel() != null ? user.getSportLevel() : "Beginner";
        }

        String phoneRegex = "^(01|03|04|06|07|08|09)\\d{8}$";
        if (phone != null && !phone.matches(phoneRegex)) {
            request.setAttribute("error", "Số điện thoại không hợp lệ! Phải bắt đầu bằng 09 hoặc 03 và có đúng 10 chữ số.");
            request.getRequestDispatcher("edit-profile.jsp").forward(request, response);
            return;
        }

        java.util.Date dob = null;

        if (dobStr != null && !dobStr.isEmpty()) {
            try {
                dob = new SimpleDateFormat("yyyy-MM-dd").parse(dobStr);

                Date currentDate = new Date();
                if (dob.after(currentDate)) {
                    request.setAttribute("error", "Ngày sinh không được vượt quá ngày hiện tại.");
                    request.getRequestDispatcher("edit-profile.jsp").forward(request, response);
                    return;
                }

            } catch (ParseException e) {
                request.setAttribute("error", "Ngày sinh không hợp lệ! Định dạng phải là yyyy-MM-dd.");
                request.getRequestDispatcher("edit-profile.jsp").forward(request, response);
                return;
            }
        }

        user.setFullName(fullName);
        user.setDob(dob);
        user.setGender(gender);
        user.setPhone(phone);
        user.setAddress(address);
        user.setSportLevel(sportLevel);

        new UserDAO().updateUser(user);
        request.getSession().setAttribute("currentUser", user);

        response.sendRedirect("view-profile.jsp?success=true");
    }

    private void handleAdminUpdate(HttpServletRequest request, HttpServletResponse response, AdminDTO admin)
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String status = request.getParameter("status");

        // Validation
        if (username == null || username.trim().isEmpty()) {
            request.setAttribute("error", "Username không được để trống.");
            request.getRequestDispatcher("edit-profile-admin.jsp").forward(request, response);
            return;
        }

        if (password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Password không được để trống.");
            request.getRequestDispatcher("edit-profile-admin.jsp").forward(request, response);
            return;
        }

        if (fullName == null || fullName.trim().isEmpty()) {
            request.setAttribute("error", "Full Name không được để trống.");
            request.getRequestDispatcher("edit-profile-admin.jsp").forward(request, response);
            return;
        }

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Email không được để trống.");
            request.getRequestDispatcher("edit-profile-admin.jsp").forward(request, response);
            return;
        }

        // Update admin information
        admin.setUsername(username);
        admin.setPassword(password);
        admin.setFullName(fullName);
        admin.setEmail(email);
        admin.setStatus(status);

        try {
            boolean updated = adminDAO.updateAdmin(admin);
            if (updated) {
                request.getSession().setAttribute("acc", admin);
                response.sendRedirect("view-profile-admin.jsp?success=true");
            } else {
                request.setAttribute("error", "Cập nhật thất bại, vui lòng thử lại.");
                request.getRequestDispatcher("edit-profile-admin.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("edit-profile-admin.jsp").forward(request, response);
        }
    }

//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        HttpSession session = request.getSession();
//        Object sessionUser = session.getAttribute("currentUser");
//        if (sessionUser == null) {
//            sessionUser = session.getAttribute("acc");
//        }
//        // Chỉ xử lý cho UserDTO, không xử lý cho AdminDTO
//        if (!(sessionUser instanceof UserDTO)) {
//            response.sendRedirect("./Login");
//            return;
//        }
//        UserDTO user = (UserDTO) sessionUser;
//        if (user == null) {
//            response.sendRedirect("./Login");
//            return;
//        }
//        try {
//            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
//            user.setFullName(request.getParameter("fullname").trim());
//            user.setDob(sdf.parse(request.getParameter("dob")));
//            user.setGender(request.getParameter("gender"));
//            user.setPhone(request.getParameter("phone").trim());
//            user.setAddress(request.getParameter("address").trim());
//            String sportLevel = request.getParameter("sportlevel");
//            if (sportLevel == null || sportLevel.trim().isEmpty()) {
//                sportLevel = user.getSportLevel() != null ? user.getSportLevel() : "Beginner";
//            }
//            user.setSportLevel(sportLevel);
//            boolean updated = userDAO.updateUserProfile1(user);
//            if (updated) {
//                session.setAttribute("currentUser", user);
//                session.setAttribute("acc", user);
//                response.sendRedirect("./home");
//            } else {
//                request.setAttribute("message", "Cập nhật thất bại, vui lòng thử lại.");
//                request.getRequestDispatcher("completeProfile.jsp").forward(request, response);
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//            request.setAttribute("message", "Lỗi hệ thống: " + e.getMessage());
//            request.getRequestDispatcher("completeProfile.jsp").forward(request, response);
//        }
//    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
