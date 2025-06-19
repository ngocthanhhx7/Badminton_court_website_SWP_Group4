/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.user;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.UserDTO;
import models.AdminDTO;

@WebServlet(name="ViewProfileController", urlPatterns={"/view-profile"})
public class ViewProfileController extends HttpServlet {
   
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ViewProfileController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ViewProfileController at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession();
        Object accObj = session.getAttribute("acc");
        String accType = (String) session.getAttribute("accType");
        
        if (accObj == null) {
            response.sendRedirect("./Login.jsp");
            return;
        }
        
        if ("admin".equals(accType) && accObj instanceof AdminDTO) {
            request.getRequestDispatcher("view-profile-admin.jsp").forward(request, response);
        } else if (("user".equals(accType) || "google".equals(accType)) && accObj instanceof UserDTO) {
            request.getRequestDispatcher("view-profile.jsp").forward(request, response);
        } else {
            response.sendRedirect("./Login.jsp");
        }
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }

}
