/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import dal.BookingDAO;
import dal.CourtScheduleDAO;
import dal.UserDAO;
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
@WebServlet(name = "SchedulerManager", urlPatterns = {"/scheduler-manager"})
public class SchedulerManager extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("list".equals(action)) {
            showBookingList(request, response);
            return;
        }
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

            LocalDateTime scheduleStartDateTime = schedule.getScheduleDate().atTime(schedule.getStartTime());
            if (scheduleStartDateTime.isBefore(LocalDateTime.now())) {
                schedule.setExpire(true);
            } else {
                schedule.setExpire(false);
            }
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
        String action = request.getParameter("action");
        if (action != null) {
            updateStatus(request, response);
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

            if (userID.equals("external")) {
                UserDAO udao = new UserDAO();

                String email = request.getParameter("externalEmail");
                String fullName = request.getParameter("externalFullName");
                String phone = request.getParameter("externalPhone");
                int suffix = 1;
                String originalEmail = email;
                while (udao.isEmailOrUsernameExists(email, email)) {
                    String prefix = originalEmail.substring(0, originalEmail.indexOf("@"));
                    String domain = originalEmail.substring(originalEmail.indexOf("@"));
                    email = prefix + suffix + domain;
                    suffix++;
                }
                UserDTO newUser = new UserDTO();
                newUser.setUsername(email);
                newUser.setEmail(email);
                newUser.setPassword("12345");
                newUser.setFullName(fullName);
                newUser.setPhone(phone);
                newUser.setSportLevel("Beginner");
                newUser.setRole("Customer");
                newUser.setStatus("Active");
                newUser.setDob(new Date());
                boolean success = udao.addUser(newUser, 1);
                userID = String.valueOf(udao.findUserByEmailOrUsername(email).getUserID());
            }
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
                if (courtScheduleId != null) {
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

    private void showBookingList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        BookingDAO bookingDAO = new BookingDAO();
        String start = request.getParameter("startDate");
        String end = request.getParameter("endDate");
        LocalDate startDate = start != null ? LocalDate.parse(start) : LocalDate.now().minusMonths(1);
        LocalDate endDate = end != null ? LocalDate.parse(end) : LocalDate.now();
        List<BookingDTO> bookings = bookingDAO.getAllBookingsAndBookingDetail(startDate, endDate);

        BigDecimal sum = BigDecimal.ZERO;

        for (BookingDTO dto : bookings) {
            if ("Completed".equalsIgnoreCase(dto.getStatus())) {
                for (BookingDetailDTO detailDTO : dto.getBookingDetails()) {
                    BigDecimal hourlyRate = detailDTO.getHourlyRate();  // giả sử kiểu BigDecimal
                    sum = sum.add(hourlyRate);  // cộng dồn
                }
            }
        }

        request.setAttribute("sum", sum);
        request.setAttribute("bookings", bookings);
        request.setAttribute("totalBooking", bookings.size());
        request.getRequestDispatcher("booking-manager.jsp").forward(request, response);
    }

    private void updateStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String status = request.getParameter("status");

        Long bookingID = Long.parseLong(request.getParameter("bookingId"));
        BookingDAO bookingDAO = new BookingDAO();
        bookingDAO.updateBookingStatus(bookingID, status);
        response.sendRedirect("scheduler-manager?action=list");
    }

}
