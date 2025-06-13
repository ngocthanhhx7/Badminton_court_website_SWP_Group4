package controllerUser;

import dao.CourtDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.CourtDTO;

@WebServlet(name = "CourtDetailController", urlPatterns = {"/court-detail"})
public class CourtDetailController extends HttpServlet {
   
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CourtDetailController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CourtDetailController at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Kiểm tra đăng nhập
        Object user = request.getSession().getAttribute("accType");
        if (user == null) {
            response.sendRedirect("Login?redirect=court-detail&courtId=" + request.getParameter("courtId"));
            return;
        }
        try {
            // Get courtId from request parameter
            String courtIdStr = request.getParameter("courtId");
            if (courtIdStr == null || courtIdStr.trim().isEmpty()) {
                response.sendRedirect("courts");
                return;
            }

            // Parse courtId to Long
            Long courtId = Long.parseLong(courtIdStr);
            
            // Get court details using CourtDAO
            CourtDAO courtDAO = new CourtDAO();
            CourtDTO court = courtDAO.getCourtById(courtId);
            
            if (court == null) {
                request.setAttribute("error", "Không tìm thấy thông tin sân");
                request.getRequestDispatcher("courts").forward(request, response);
                return;
            }
            
            // Get similar courts (5 items)
            java.util.List<models.CourtDTO> similarCourts = courtDAO.getSimilarCourts(courtId, 5);
            request.setAttribute("similarCourts", similarCourts);
            // Set court details to request attribute
            request.setAttribute("court", court);
            
            // Forward to court-detail.jsp
            request.getRequestDispatcher("court-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect("courts");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("courts");
        }
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
