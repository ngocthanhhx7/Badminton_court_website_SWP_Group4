/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package control;

import dal.DAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Admins;
import model.Users;

/**
 *
 * @author PC - ACER
 */

public class Login extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
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
        request.getRequestDispatcher("Login.jsp").forward(request, response);
    }

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String Username = request.getParameter("Username");
        String Password = request.getParameter("Password");

        DAO dao = new DAO();
        Admins a = dao.login(Username, Password);
        Users b = dao.login1(Username, Password);

//        if (a == null) {
//            request.getSession().setAttribute("mess", "Wrong user or password");
//            response.sendRedirect("Login");  // redirect về GET
//        } else {
//            HttpSession session = request.getSession();
//            session.setAttribute("acc", a);
//            response.sendRedirect("Success.jsp");
//        }
                if (a != null) {
            HttpSession session = request.getSession();
            session.setAttribute("acc", a);
            response.sendRedirect("Success.jsp");
            return;
        }

        if (b != null) {
            HttpSession session = request.getSession();
            session.setAttribute("acc", b);
            response.sendRedirect("Success.jsp");
            return;
        }

// Nếu không phải admin cũng không phải user:
        request.getSession().setAttribute("mess", "Wrong user or password");
        response.sendRedirect("Login");
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
