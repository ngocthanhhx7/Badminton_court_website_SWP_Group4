package controller.admin;

import dal.CourtDAO;
import dal.CourtScheduleDAO;
import models.CourtDTO;
import models.CourtScheduleDTO;
import utils.AccessControlUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet(name = "CourtSchedulerManagerController", urlPatterns = {"/court-scheduler-manager"})
public class CourtSchedulerManagerController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Kiểm tra quyền truy cập
        if (!AccessControlUtil.hasManagerAccess(request)) {
            response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
            return;
        }

        // Lấy tham số lọc, phân trang, sắp xếp
        String courtIdStr = request.getParameter("courtId");
        String status = request.getParameter("status");
        String courtType = request.getParameter("courtType");
        String scheduleDateStr = request.getParameter("scheduleDate");
        String sortBy = request.getParameter("sortBy");
        String sortOrder = request.getParameter("sortOrder");
        String pageStr = request.getParameter("page");
        String pageSizeStr = request.getParameter("pageSize");

        Integer courtId = null;
        if (courtIdStr != null && !courtIdStr.trim().isEmpty()) {
            try { courtId = Integer.parseInt(courtIdStr); } catch (NumberFormatException ignored) {}
        }
        LocalDate scheduleDate = null;
        if (scheduleDateStr != null && !scheduleDateStr.trim().isEmpty()) {
            try { scheduleDate = LocalDate.parse(scheduleDateStr, DateTimeFormatter.ISO_LOCAL_DATE); } catch (Exception ignored) {}
        }
        int page = 1;
        int pageSize = 10;
        if (pageStr != null) {
            try { page = Integer.parseInt(pageStr); if (page < 1) page = 1; } catch (NumberFormatException ignored) {}
        }
        if (pageSizeStr != null) {
            try { pageSize = Integer.parseInt(pageSizeStr); if (pageSize < 1) pageSize = 10; if (pageSize > 100) pageSize = 100; } catch (NumberFormatException ignored) {}
        }
        if (sortBy == null || sortBy.trim().isEmpty()) sortBy = "ScheduleID";
        if (sortOrder == null || sortOrder.trim().isEmpty()) sortOrder = "DESC";

        CourtScheduleDAO scheduleDAO = new CourtScheduleDAO();
        CourtDAO courtDAO = new CourtDAO();
        List<CourtScheduleDTO> schedules = scheduleDAO.getSchedulesWithFilters(courtId, status, courtType, scheduleDate, sortBy, sortOrder, page, pageSize);
        int totalSchedules = scheduleDAO.getFilteredSchedulesCount(courtId, status, courtType, scheduleDate);
        int totalPages = (int) Math.ceil((double) totalSchedules / pageSize);
        List<CourtDTO> courts = courtDAO.getAllCourts();

        // Set attributes for JSP
        request.setAttribute("schedules", schedules);
        request.setAttribute("courts", courts);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalSchedules", totalSchedules);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("courtId", courtIdStr);
        request.setAttribute("status", status);
        request.setAttribute("courtType", courtType);
        request.setAttribute("scheduleDate", scheduleDateStr);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("sortOrder", sortOrder);
        int startRecord = (page - 1) * pageSize + 1;
        int endRecord = Math.min(page * pageSize, totalSchedules);
        request.setAttribute("startRecord", startRecord);
        request.setAttribute("endRecord", endRecord);

        // Hiển thị thông báo nếu có
        HttpSession session = request.getSession();
        String successMessage = (String) session.getAttribute("successMessage");
        String errorMessage = (String) session.getAttribute("errorMessage");
        if (successMessage != null) {
            request.setAttribute("successMessage", successMessage);
            session.removeAttribute("successMessage");
        }
        if (errorMessage != null) {
            request.setAttribute("errorMessage", errorMessage);
            session.removeAttribute("errorMessage");
        }

        request.getRequestDispatcher("court-scheduler-manager.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!AccessControlUtil.hasManagerAccess(request)) {
            response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
            return;
        }
        String action = request.getParameter("action");
        CourtScheduleDAO scheduleDAO = new CourtScheduleDAO();
        HttpSession session = request.getSession();
        try {
            switch (action) {
                case "add":
                    handleAddSchedule(request, session, scheduleDAO);
                    break;
                case "edit":
                    handleEditSchedule(request, session, scheduleDAO);
                    break;
                case "delete":
                    handleDeleteSchedule(request, session, scheduleDAO);
                    break;
                case "toggleStatus":
                    handleToggleStatus(request, session, scheduleDAO);
                    break;
                case "generate7days":
                    boolean genSuccess = scheduleDAO.generateCourtSchedules7Days();
                    if (genSuccess) session.setAttribute("successMessage", "Tạo lịch 7 ngày thành công!");
                    else session.setAttribute("errorMessage", "Tạo lịch 7 ngày thất bại!");
                    break;
                default:
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage());
        }
        response.sendRedirect("court-scheduler-manager");
    }

    private void handleAddSchedule(HttpServletRequest request, HttpSession session, CourtScheduleDAO scheduleDAO) {
        try {
            Integer courtId = Integer.parseInt(request.getParameter("courtId"));
            LocalDate scheduleDate = LocalDate.parse(request.getParameter("scheduleDate"));
            String startTime = request.getParameter("startTime");
            String endTime = request.getParameter("endTime");
            String status = request.getParameter("status");
            boolean isHoliday = "on".equals(request.getParameter("isHoliday"));
            Long createdBy = 1L; // Có thể lấy từ session nếu có
            CourtScheduleDTO schedule = CourtScheduleDTO.builder()
                    .courtId(courtId)
                    .scheduleDate(scheduleDate)
                    .startTime(java.time.LocalTime.parse(startTime))
                    .endTime(java.time.LocalTime.parse(endTime))
                    .status(status)
                    .isHoliday(isHoliday)
                    .createdBy(createdBy)
                    .build();
            boolean success = scheduleDAO.addSchedule(schedule);
            if (success) session.setAttribute("successMessage", "Thêm lịch sân thành công!");
            else session.setAttribute("errorMessage", "Thêm lịch sân thất bại!");
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Dữ liệu không hợp lệ!");
        }
    }

    private void handleEditSchedule(HttpServletRequest request, HttpSession session, CourtScheduleDAO scheduleDAO) {
        try {
            Long scheduleId = Long.parseLong(request.getParameter("scheduleId"));
            Integer courtId = Integer.parseInt(request.getParameter("courtId"));
            LocalDate scheduleDate = LocalDate.parse(request.getParameter("scheduleDate"));
            String startTime = request.getParameter("startTime");
            String endTime = request.getParameter("endTime");
            String status = request.getParameter("status");
            boolean isHoliday = "on".equals(request.getParameter("isHoliday"));
            CourtScheduleDTO schedule = CourtScheduleDTO.builder()
                    .scheduleId(scheduleId)
                    .courtId(courtId)
                    .scheduleDate(scheduleDate)
                    .startTime(java.time.LocalTime.parse(startTime))
                    .endTime(java.time.LocalTime.parse(endTime))
                    .status(status)
                    .isHoliday(isHoliday)
                    .build();
            boolean success = scheduleDAO.updateSchedule(schedule);
            if (success) session.setAttribute("successMessage", "Cập nhật lịch sân thành công!");
            else session.setAttribute("errorMessage", "Cập nhật lịch sân thất bại!");
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Dữ liệu không hợp lệ!");
        }
    }

    private void handleDeleteSchedule(HttpServletRequest request, HttpSession session, CourtScheduleDAO scheduleDAO) {
        try {
            Long scheduleId = Long.parseLong(request.getParameter("scheduleId"));
            boolean success = scheduleDAO.deleteSchedule(scheduleId);
            if (success) session.setAttribute("successMessage", "Xóa lịch sân thành công!");
            else session.setAttribute("errorMessage", "Xóa lịch sân thất bại!");
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Dữ liệu không hợp lệ!");
        }
    }

    private void handleToggleStatus(HttpServletRequest request, HttpSession session, CourtScheduleDAO scheduleDAO) {
        try {
            Long scheduleId = Long.parseLong(request.getParameter("scheduleId"));
            String currentStatus = request.getParameter("currentStatus");
            String newStatus = "Available".equals(currentStatus) ? "Booked" : "Available";
            boolean success = scheduleDAO.updateScheduleStatus(scheduleId, newStatus);
            if (success) session.setAttribute("successMessage", "Cập nhật trạng thái thành công!");
            else session.setAttribute("errorMessage", "Cập nhật trạng thái thất bại!");
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Dữ liệu không hợp lệ!");
        }
    }
} 