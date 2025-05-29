/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controllerUser;

import dao.CourtDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import models.CourtDTO;

/**
 *
 * @author nguye
 */
@WebServlet(name="CourtController", urlPatterns={"/court"})
public class CourtController extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
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
            out.println("<title>Servlet CourtController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CourtController at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
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
        CourtDAO courtDAO = new CourtDAO();
        String search = request.getParameter("search");
        String pageParam = request.getParameter("page");
        String status = request.getParameter("status");
        String courtType = request.getParameter("courtType");

        int page = 1;
        int courtsPerPage = 2;

        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        // Lọc dữ liệu
        List<CourtDTO> courts = courtDAO.filterCourts(search, status, courtType);

        if (courts == null || courts.isEmpty()) {
            request.setAttribute("message", "No court found");
        } else {
            int totalCourts = courts.size();
            int totalPages = (int) Math.ceil((double) totalCourts / courtsPerPage);

            if (page < 1) {
                page = 1;
            }
            if (page > totalPages) {
                page = totalPages;
            }

            int start = (page - 1) * courtsPerPage;
            int end = Math.min(start + courtsPerPage, totalCourts);
            List<CourtDTO> pagedCourts = courts.subList(start, end);

            request.setAttribute("courts", pagedCourts);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
        }

        // Gửi lại các giá trị lọc cho form
        request.setAttribute("search", search);
        request.setAttribute("status", status);
        request.setAttribute("courtType", courtType);

        request.getRequestDispatcher("courts.jsp").forward(request, response);
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
        processRequest(request, response);
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
