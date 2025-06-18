/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controllerUser;

import dao.CourtDAO;
import dao.CourtScheduleDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.List;
import models.CourtDTO;
import models.CourtScheduleDTO;

public class CourtDetailController extends HttpServlet {
   
    
   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            String courtIdParam = request.getParameter("courtId");
            
            if (courtIdParam == null || courtIdParam.trim().isEmpty()) {
                response.sendRedirect("court");
                return;
            }
            
            CourtDAO courtDAO = new CourtDAO();
            Integer courtId = Integer.parseInt(courtIdParam);
            CourtDTO court = courtDAO.getCourtById(courtId);
            
            if (court == null) {
                request.setAttribute("error", "Court not found");
                request.getRequestDispatcher("error.jsp").forward(request, response);
                return;
            }
            
            String dateParam = request.getParameter("date");
            LocalDate selectedDate;
            if (dateParam != null && !dateParam.isEmpty()) {
                selectedDate = LocalDate.parse(dateParam);
            } else {
                selectedDate = LocalDate.now();
            }

            Date dateForJsp = Date.from(selectedDate.atStartOfDay(ZoneId.systemDefault()).toInstant());
            request.setAttribute("selectedDate", dateForJsp);

            String selectedDateStr = selectedDate.format(DateTimeFormatter.ISO_LOCAL_DATE);
            request.setAttribute("selectedDateStr", selectedDateStr);

            LocalDate prevDate = selectedDate.minusDays(1);
            LocalDate nextDate = selectedDate.plusDays(1);
            request.setAttribute("prevDate", Date.from(prevDate.atStartOfDay(ZoneId.systemDefault()).toInstant()));
            request.setAttribute("nextDate", Date.from(nextDate.atStartOfDay(ZoneId.systemDefault()).toInstant()));

            CourtScheduleDAO courtScheduleDAO = new CourtScheduleDAO();
            
            List<CourtScheduleDTO> schedules = courtScheduleDAO.getSchedulesByCourtAndDate(courtId, selectedDate);
            
            DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
            for (CourtScheduleDTO schedule : schedules) {
                schedule.setStartTimeStr(schedule.getStartTime().format(timeFormatter));
                schedule.setEndTimeStr(schedule.getEndTime().format(timeFormatter));
            }
            request.setAttribute("schedules", schedules);
            
            
            // Set court data as request attribute
            request.setAttribute("court", court);
            request.getRequestDispatcher("court-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect("court");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while loading court details");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }  

    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        
    }

    
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
