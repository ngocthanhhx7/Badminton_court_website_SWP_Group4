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
import models.UserDTO;

public class UpdateProfileController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet UpdateProfileController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UpdateProfileController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("acc");

        if (user == null) {
            response.sendRedirect("login.html");
            return;
        }
        String password = request.getParameter("password");
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
}
