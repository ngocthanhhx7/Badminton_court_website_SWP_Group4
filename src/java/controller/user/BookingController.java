package controller.user;

import com.google.gson.JsonObject;
import com.vnpay.common.Config;
import dao.BookingDAO;
import dao.BookingNoteDAO;
import dao.CourtDAO;
import dao.CourtScheduleDAO;
import dao.UserDAO;
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
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.*;
import models.BookingNotesDTO;

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
            case "history":
                showHistory(request, response);
                break;
            case "draft":
                showDraft(request, response);
                break;    
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
             case "rating":
                ratingBooking(request, response);
                break;   
            case "cancel":
                cancelBooking(request, response);
                break;
        }
    }

    private void showMyBookings(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String courtIdParam = request.getParameter("courtId");

        if (courtIdParam != null) {
            try {
                Integer courtId = Integer.parseInt(courtIdParam);
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

   private void showBookingForm(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        String courtScheduleIdsParam = request.getParameter("courtScheduleIds");
        double sum = 0;
        if (courtScheduleIdsParam != null && !courtScheduleIdsParam.trim().isEmpty()) {
            try {
                String[] idStrings = courtScheduleIdsParam.split(",");// 1810,1811
                List<Integer> courtScheduleIds = new ArrayList<>();

                for (String idStr : idStrings) {
                    if (idStr != null && !idStr.trim().isEmpty()) {
                        courtScheduleIds.add(Integer.parseInt(idStr.trim()));
                    }
                }

                if (!courtScheduleIds.isEmpty()) {
                    CourtScheduleDAO scheduleDAO = new CourtScheduleDAO();
                    List<CourtScheduleDTO> schedules = scheduleDAO.getSchedulesByIds(courtScheduleIds);

                    
                    for(CourtScheduleDTO cs : schedules ){
                        sum += cs.getPrice();
                    }
                    request.setAttribute("courtSchedules", schedules);
                    request.setAttribute("courtScheduleIds", courtScheduleIdsParam);
                } else {
                    request.setAttribute("error", "Không có ID lịch sân hợp lệ nào được cung cấp.");
                }
                request.setAttribute("sum", sum);
                

            } catch (NumberFormatException e) {
                request.setAttribute("error", "Định dạng ID lịch sân không hợp lệ.");
                e.printStackTrace();
            }
        } else {
            request.setAttribute("error", "Vui lòng chọn lịch sân.");
        }

        request.setAttribute("now", new java.util.Date());

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
            Integer courtId = Integer.parseInt(request.getParameter("courtId"));
            String dateStr = request.getParameter("bookingDate");
            String startTimeStr = request.getParameter("startTime");
            String endTimeStr = request.getParameter("endTime");
            String notes = request.getParameter("notes");
            Long courtScheduleId = Long.parseLong(request.getParameter("courtScheduleId"));

            LocalDate bookingDate = LocalDate.parse(dateStr);
            LocalTime startTime = LocalTime.parse(startTimeStr);
            LocalTime endTime = LocalTime.parse(endTimeStr);
            
            notes = request.getParameter("courtScheduleId");

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
                    .createdBy(Long.valueOf(user.getUserID()))
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
                if (bookingDAO.addBookingDetail(detail)) {
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

    
    private void showHistory(HttpServletRequest request, HttpServletResponse response) 
        throws IOException, ServletException {
        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("acc");
        if (user == null) {
            response.sendRedirect("Login.jsp");
            return;
        }
        List<BookingDTO> list = bookingDAO.getBookingsByCustomerAndBookingDetail(Long.valueOf(user.getUserID()));
        LocalDateTime today = LocalDateTime.now(); // Lấy ngày hiện tại (không bao gồm thời gian)
        CourtScheduleDAO courtScheduleDAO = new CourtScheduleDAO();
        for (BookingDTO booking : list) {
            LocalDateTime bookingDate = booking.getCreatedAt();
            if (bookingDate.isBefore(today)) {
               booking.setCancel(false);        // Có thể hủy nếu ngày booking < hôm nay
               booking.setCanRating(true);
            }
            else if(bookingDate.equals(today)){
               booking.setCancel(false);        // Có thể hủy nếu ngày booking < hôm nay
               booking.setCanRating(true);
            }
            else{
               booking.setCancel(true);        // Có thể hủy nếu ngày booking < hôm nay
               booking.setCanRating(false);
            }
            String note = booking.getNotes();
            
            boolean isExpire = false;
            try{
//                int in = Integer.parseInt(note);
                String[] arr = note.split(",");
                System.out.println(arr[0]);
                CourtScheduleDTO dto = courtScheduleDAO.getScheduleById(Integer.parseInt(arr[0]));
                 // Ghép ngày + giờ để so sánh
                LocalDateTime scheduleStart = LocalDateTime.of(dto.getScheduleDate(), dto.getEndTime());

                if (scheduleStart.isBefore(LocalDateTime.now())) {
                    isExpire = true;
                }
                booking.setCanRating(isExpire);
            }catch(Exception e){
            }
        }
        request.setAttribute("bookingList", list);
        request.getRequestDispatcher("booking-history.jsp").forward(request, response);
    }


    private void ratingBooking(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        try {
            HttpSession session = request.getSession();
            UserDTO user = (UserDTO) session.getAttribute("acc");
            if (user == null) {
                response.sendRedirect("Login.jsp");
                return;
            }
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            int customerId = user.getUserID();
            int rating = Integer.parseInt(request.getParameter("rating")); // từ 1 đến 5
            String noteDetails = request.getParameter("noteDetails");
            BookingNotesDTO note = new BookingNotesDTO();
            note.setBookingID(bookingId);
            note.setCustomerID(customerId);
            note.setRating(rating);
            note.setNoteType("Feedback");
            note.setNoteDetails(noteDetails);
            note.setStatus("Pending"); // hoặc "Completed", "Visible", v.v.
            note.setCreatedAt(LocalDateTime.now());
            note.setCreatedBy(customerId); // hoặc lấy từ session người dùng

            BookingNoteDAO dao = new BookingNoteDAO();
            boolean success = dao.addNote(note);

            if (success) {
                request.setAttribute("message", "Thank you for your feedback!");
            } else {
                request.setAttribute("error", "Failed to save your rating.");
            }
            response.sendRedirect("booking?action=history");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid input for rating.");
        }
    }

    
    private void showDraft(HttpServletRequest request, HttpServletResponse response)throws IOException, ServletException {
         HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("acc");
        if (user == null) {
            response.sendRedirect("Login.jsp");
            return;
        }
        System.out.println(user.getUserID());
        List<BookingDTO> list = bookingDAO.getBookingsByCustomerAndBookingDetailDraft(Long.valueOf(user.getUserID()));
        System.out.println(list.size());
        LocalDateTime today = LocalDateTime.now(); // Lấy ngày hiện tại (không bao gồm thời gian)
        for (BookingDTO booking : list) {
            LocalDateTime bookingDate = booking.getCreatedAt();
            booking.setCancel(true); 
        }
        request.setAttribute("draftList", list);
        request.getRequestDispatcher("booking-draft-list.jsp").forward(request, response);
    }
    
    
     private void cancelBooking(HttpServletRequest request, HttpServletResponse response)throws IOException, ServletException{
         BookingDAO bookingDAO = new BookingDAO();
         String id = request.getParameter("draftId");
         BookingDTO bookingDTO = bookingDAO.getBookingById(Long.parseLong(id));
         String note = bookingDTO.getNotes();
         CourtScheduleDAO courtScheduleDAO = new CourtScheduleDAO();
         
         String[] arr = note.split(",");
         for(String x : arr){
           try{
               int courtSchedulerID = Integer.parseInt(x);
               courtScheduleDAO.updateScheduleStatus(Long.valueOf(courtSchedulerID), "Available");
           }catch(Exception e){
               
           }     
         }
     
         
         bookingDAO.updateBookingStatus(Integer.parseInt(id), "Cancelled");
//         request.getRequestDispatcher("booking-draft-list.jsp").forward(request, response);
         response.sendRedirect("booking?action=draft");
     }
    
}
