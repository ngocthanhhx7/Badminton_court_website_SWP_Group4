package controllerCourt;

import com.google.gson.JsonObject;
import com.vnpay.common.Config;
import dao.BookingDAO;
import dao.CourtDAO;
import dao.CourtScheduleDAO;
import models.BookingDTO;
import models.BookingDetailDTO;
import models.CourtDTO;
import models.CourtScheduleDTO;
import models.UserDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.*;

@WebServlet(name = "BookingController", urlPatterns = {"/booking"})
public class BookingController extends HttpServlet {

    private BookingDAO bookingDAO;
    private CourtDAO courtDAO;
    private CourtScheduleDAO scheduleDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        bookingDAO = new BookingDAO();
        courtDAO = new CourtDAO();
        scheduleDAO = new CourtScheduleDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "show";
        }

        switch (action) {
            case "show":
                showBookingForm(request, response);
                break;
            case "schedule":
                showSchedule(request, response);
                break;
            case "my-bookings":
                showMyBookings(request, response);
                break;
            default:
                showBookingForm(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "create";
        }

        switch (action) {
            case "create":
                createBooking(request, response);
                break;
        }
    }

    private void showMyBookings(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String courtIdParam = request.getParameter("courtId");

        if (courtIdParam != null) {
            try {
                Long courtId = Long.parseLong(courtIdParam);
                CourtDTO court = courtDAO.getCourtById(courtId);
                request.setAttribute("court", court);

                // Get available schedules for next 7 days
                List<CourtScheduleDTO> schedules = new ArrayList<>();
                LocalDate today = LocalDate.now();
                for (int i = 0; i < 7; i++) {
                    LocalDate date = today.plusDays(i);
                    List<CourtScheduleDTO> daySchedules = scheduleDAO.getAvailableSchedules(courtId, date);
                    schedules.addAll(daySchedules);
                }
                request.setAttribute("schedules", schedules);

            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid court ID");
            }
        }

        request.getRequestDispatcher("booking-form.jsp").forward(request, response);
    }

    private void showSchedule(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

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
        request.getRequestDispatcher("court-schedule.jsp").forward(request, response);
    }

    private void showBookingForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String courtIdParam = request.getParameter("courtId");
        String dateParam = request.getParameter("date");
        String startTimeParam = request.getParameter("startTime");
        String endTimeParam = request.getParameter("endTime");
        String courtScheduleId = request.getParameter("courtScheduleId");

        if (courtIdParam != null) {
            try {
                Long courtId = Long.parseLong(courtIdParam);
                CourtDTO court = courtDAO.getCourtById(courtId);
                request.setAttribute("court", court);

                if (dateParam != null && !dateParam.isEmpty()) {
                    request.setAttribute("selectedDate", dateParam);
                }
                if (startTimeParam != null && !startTimeParam.isEmpty()) {
                    request.setAttribute("selectedStartTime", startTimeParam);
                }
                if (endTimeParam != null && !endTimeParam.isEmpty()) {
                    request.setAttribute("selectedEndTime", endTimeParam);
                }

                if (dateParam != null && startTimeParam != null && endTimeParam != null) {
                    request.setAttribute("fromSchedule", true);
                }
                if (courtScheduleId != null && !courtScheduleId.isEmpty()) {
                    request.setAttribute("courtScheduleId", courtScheduleId);
                }

            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid court ID");
            }
        }

        request.setAttribute("now", new Date());
        request.getRequestDispatcher("booking-form.jsp").forward(request, response);
    }

    private void createBooking(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("acc");

        if (user == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        try {
            Long courtId = Long.parseLong(request.getParameter("courtId"));
            String dateStr = request.getParameter("bookingDate");
            String startTimeStr = request.getParameter("startTime");
            String endTimeStr = request.getParameter("endTime");
            String notes = request.getParameter("notes");
            Long courtScheduleId = Long.parseLong(request.getParameter("courtScheduleId"));

            LocalDate bookingDate = LocalDate.parse(dateStr);
            LocalTime startTime = LocalTime.parse(startTimeStr);
            LocalTime endTime = LocalTime.parse(endTimeStr);

            // Check if time slot is available
            if (!scheduleDAO.isTimeSlotAvailable(courtScheduleId)) {
                request.setAttribute("error", "Selected time slot is not available");
                showBookingForm(request, response);
                return;
            }

            // Create booking
            BookingDTO booking = BookingDTO.builder()
                    .customerId(Long.valueOf(user.getUserID()))
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
                        .courtId(courtId)
                        .startTime(startDateTime)
                        .endTime(endDateTime)
                        .hourlyRate(new BigDecimal("100000"))
                        .build();
                if (bookingDAO.addBookingDetail(detail)) {
                    // ← REDIRECT ĐẾN GET REQUEST VỚI ACTION=PAYMENT
                    request.getRequestDispatcher("vn_pay.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Failed to create booking details");
                    showBookingForm(request, response);
                }
            } else {
                request.setAttribute("error", "Failed to create booking");
                showBookingForm(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            showBookingForm(request, response);
        }
    }

}
