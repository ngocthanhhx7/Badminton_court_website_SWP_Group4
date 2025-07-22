/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.admin;

import dao.BookingDAO;
import dao.CourtScheduleDAO;
import dao.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import models.AdminDTO;
import models.BookingDTO;
import models.BookingDetailDTO;
import models.CourtScheduleDTO;
import models.User;
import models.UserDTO;

/**
 *
 * @author Admin
 */
@WebServlet(name="SchedulerManager", urlPatterns={"/scheduler-manager"})
public class SchedulerManager extends HttpServlet {
   
   
   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        CourtScheduleDAO scheduleDAO = new CourtScheduleDAO();
        UserDAO userDAO = new UserDAO();
        String type = request.getParameter("type");
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
        List<CourtScheduleDTO> schedules = scheduleDAO.getAllAvailableSchedules(selectedDate);        
        if (type != null && !type.isEmpty()) {
            schedules.removeIf(schedule -> !type.equalsIgnoreCase(schedule.getCourtType()));
        }
        request.setAttribute("selectedType", type);

        DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
        for (CourtScheduleDTO schedule : schedules) {
            schedule.setStartTimeStr(schedule.getStartTime().format(timeFormatter));
            schedule.setEndTimeStr(schedule.getEndTime().format(timeFormatter));
        }
        request.setAttribute("schedules", schedules);
        List<UserDTO> users = new ArrayList<>();
        try {
            users = userDAO.getAllUsers();
        } catch (SQLException ex) {
            
        }
        request.setAttribute("users", users);
        request.getRequestDispatcher("court-schedule.jsp").forward(request, response);
    } 
    
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession();
        AdminDTO user = (AdminDTO) session.getAttribute("acc");
         CourtScheduleDAO courtScheduleDAO = new CourtScheduleDAO();
        BookingDAO bookingDAO = new BookingDAO();

        if (user == null) {
            response.sendRedirect("Login.jsp");
            return;
        }
        try {
            Integer courtId = Integer.parseInt(request.getParameter("courtId"));
            String dateStr = request.getParameter("bookingDate");
            String startTimeStr = request.getParameter("startTime");
            String endTimeStr = request.getParameter("endTime");
            String notes = request.getParameter("notes");
            Long courtScheduleId = Long.parseLong(request.getParameter("courtScheduleId"));
            String userID = request.getParameter("userId");
            
            notes = request.getParameter("courtScheduleId");
            LocalDate bookingDate = LocalDate.now();
            LocalTime startTime = LocalTime.parse(startTimeStr);
            LocalTime endTime = LocalTime.parse(endTimeStr);
            

            // Create booking
            BookingDTO booking = BookingDTO.builder()
                    .customerId(Long.valueOf(userID))
                    .status("Pending")
                    .notes(notes)
                    .build();

            Long bookingId = bookingDAO.createBooking(booking);

            if (bookingId != null) {
                // Create booking detail
                LocalDateTime startDateTime = LocalDateTime.of(bookingDate, startTime);
                LocalDateTime endDateTime = LocalDateTime.of(bookingDate, endTime);

                BookingDetailDTO detail = BookingDetailDTO.builder()
                        .bookingId(bookingId)
                        .courtId(courtId.longValue())
                        .startTime(startDateTime)
                        .endTime(endDateTime)
                        .hourlyRate(new BigDecimal("100000"))
                        .build();
                if(courtScheduleId != null){
                    courtScheduleDAO.updateScheduleStatus(courtScheduleId, "Booked");
                }
                if (bookingDAO.addBookingDetail(detail)) {
                    doGet(request, response);
                } 
            }
          

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
        }
    }

   
}
