/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controllerUser;

import dao.UserDAO;
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

public class UpdateProfileController extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

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
        UserDTO user = (UserDTO) session.getAttribute("acc");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        String password = request.getParameter("password");

        String specialCharRegex = ".*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>/?].*";
        String upperCaseRegex = ".*[A-Z].*";

        if (password.length() <= 6
                || !password.matches(upperCaseRegex)
                || !password.matches(specialCharRegex)) {

            request.setAttribute("error", "Mật khẩu phải nhiều hơn 6 ký tự, chứa ít nhất 1 chữ in hoa và 1 ký tự đặc biệt.");
            request.getRequestDispatcher("edit-profile.jsp").forward(request, response);
            return;
        }
        user.setPassword(password);

        String fullName = request.getParameter("fullName");
        String dobStr = request.getParameter("dob");
        String gender = request.getParameter("gender");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String sportLevel = request.getParameter("sportLevel");

        String phoneRegex = "^(09|03)\\d{8}$";
        if (!phone.matches(phoneRegex)) {
            request.setAttribute("error", "Số điện thoại không hợp lệ! Phải bắt đầu bằng 09 hoặc 03 và có đúng 10 chữ số.");
            request.getRequestDispatcher("edit-profile.jsp").forward(request, response);
            return;
        }

        java.util.Date dob = null;

        try {
            dob = new SimpleDateFormat("yyyy-MM-dd").parse(dobStr);
        } catch (ParseException e) {
            request.setAttribute("error", "Ngày sinh không hợp lệ! Định dạng phải là yyyy-MM-dd.");
            request.getRequestDispatcher("edit-profile.jsp").forward(request, response);
            return;
        }
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

        user.setFullName(fullName);
        user.setDob(dob);
        user.setGender(gender);
        user.setPhone(phone);
        user.setAddress(address);
        user.setSportLevel(sportLevel);

        new UserDAO().updateUser(user);
        session.setAttribute("currentUser", user);

        response.sendRedirect("view-profile.jsp?success=true");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        UserDTO user = (UserDTO) request.getSession().getAttribute("currentUser");
        if (user == null) {
            response.sendRedirect("./Login");
            return;
        }

        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            user.setFullName(request.getParameter("fullname").trim());
            user.setDob(sdf.parse(request.getParameter("dob")));
            user.setGender(request.getParameter("gender"));
            user.setPhone(request.getParameter("phone").trim());
            user.setAddress(request.getParameter("address").trim());
            user.setSportLevel(request.getParameter("sportlevel").trim());

            boolean updated = userDAO.updateUserProfile1(user);
            if (updated) {
                request.getSession().setAttribute("currentUser", user);
                response.sendRedirect("./home");
            } else {
                request.setAttribute("message", "Cập nhật thất bại, vui lòng thử lại.");
                request.getRequestDispatcher("completeProfile.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("completeProfile.jsp").forward(request, response);
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
