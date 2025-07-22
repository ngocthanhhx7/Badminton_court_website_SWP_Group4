package controller.admin;

import dao.CourtDAO;
import dao.CourtRateDAO;
import models.CourtDTO;
import models.CourtRateDTO;
import utils.AccessControlUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalTime;
import java.util.List;

@WebServlet(name = "CourtRatesManagerController", urlPatterns = {"/court-rates-manager"})
public class CourtRatesManagerController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!AccessControlUtil.hasManagerAccess(request)) {
            response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
            return;
        }
        String courtIdStr = request.getParameter("courtId");
        String dayOfWeekStr = request.getParameter("dayOfWeek");
        String isHolidayStr = request.getParameter("isHoliday");
        String sortBy = request.getParameter("sortBy");
        String sortOrder = request.getParameter("sortOrder");
        String pageStr = request.getParameter("page");
        String pageSizeStr = request.getParameter("pageSize");
        Integer courtId = null;
        if (courtIdStr != null && !courtIdStr.trim().isEmpty()) {
            try { courtId = Integer.parseInt(courtIdStr); } catch (NumberFormatException ignored) {}
        }
        Integer dayOfWeek = null;
        if (dayOfWeekStr != null && !dayOfWeekStr.trim().isEmpty()) {
            try { dayOfWeek = Integer.parseInt(dayOfWeekStr); } catch (NumberFormatException ignored) {}
        }
        Boolean isHoliday = null;
        if (isHolidayStr != null && !isHolidayStr.trim().isEmpty()) {
            if ("1".equals(isHolidayStr) || "true".equalsIgnoreCase(isHolidayStr)) isHoliday = true;
            else if ("0".equals(isHolidayStr) || "false".equalsIgnoreCase(isHolidayStr)) isHoliday = false;
        }
        int page = 1;
        int pageSize = 10;
        if (pageStr != null) {
            try { page = Integer.parseInt(pageStr); if (page < 1) page = 1; } catch (NumberFormatException ignored) {}
        }
        if (pageSizeStr != null) {
            try { pageSize = Integer.parseInt(pageSizeStr); if (pageSize < 1) pageSize = 10; if (pageSize > 100) pageSize = 100; } catch (NumberFormatException ignored) {}
        }
        if (sortBy == null || sortBy.trim().isEmpty()) sortBy = "RateID";
        if (sortOrder == null || sortOrder.trim().isEmpty()) sortOrder = "DESC";
        CourtRateDAO rateDAO = new CourtRateDAO();
        CourtDAO courtDAO = new CourtDAO();
        List<CourtRateDTO> rates = rateDAO.getRatesWithFilters(courtId, dayOfWeek, isHoliday, sortBy, sortOrder, page, pageSize);
        int totalRates = rateDAO.getFilteredRatesCount(courtId, dayOfWeek, isHoliday);
        int totalPages = (int) Math.ceil((double) totalRates / pageSize);
        List<CourtDTO> courts = courtDAO.getAllCourts();
        request.setAttribute("rates", rates);
        request.setAttribute("courts", courts);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalRates", totalRates);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("courtId", courtIdStr);
        request.setAttribute("dayOfWeek", dayOfWeekStr);
        request.setAttribute("isHoliday", isHolidayStr);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("sortOrder", sortOrder);
        int startRecord = (page - 1) * pageSize + 1;
        int endRecord = Math.min(page * pageSize, totalRates);
        request.setAttribute("startRecord", startRecord);
        request.setAttribute("endRecord", endRecord);
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
        request.getRequestDispatcher("court-rates-manager.jsp").forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!AccessControlUtil.hasManagerAccess(request)) {
            response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
            return;
        }
        String action = request.getParameter("action");
        CourtRateDAO rateDAO = new CourtRateDAO();
        HttpSession session = request.getSession();
        try {
            switch (action) {
                case "add":
                    handleAddRate(request, session, rateDAO);
                    break;
                case "edit":
                    handleEditRate(request, session, rateDAO);
                    break;
                case "delete":
                    handleDeleteRate(request, session, rateDAO);
                    break;
                default:
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage());
        }
        response.sendRedirect("court-rates-manager");
    }
    private void handleAddRate(HttpServletRequest request, HttpSession session, CourtRateDAO rateDAO) {
        try {
            Integer courtId = Integer.parseInt(request.getParameter("courtId"));
            Integer dayOfWeek = Integer.parseInt(request.getParameter("dayOfWeek"));
            LocalTime startHour = LocalTime.parse(request.getParameter("startHour"));
            LocalTime endHour = LocalTime.parse(request.getParameter("endHour"));
            BigDecimal hourlyRate = new BigDecimal(request.getParameter("hourlyRate"));
            Boolean isHoliday = request.getParameter("isHoliday") != null;
            CourtRateDTO rate = CourtRateDTO.builder()
                    .courtId(courtId)
                    .dayOfWeek(dayOfWeek)
                    .startHour(startHour)
                    .endHour(endHour)
                    .hourlyRate(hourlyRate)
                    .isHoliday(isHoliday)
                    .build();
            boolean success = rateDAO.addRate(rate);
            if (success) session.setAttribute("successMessage", "Thêm giá sân thành công!");
            else session.setAttribute("errorMessage", "Thêm giá sân thất bại!");
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Dữ liệu không hợp lệ!");
        }
    }
    private void handleEditRate(HttpServletRequest request, HttpSession session, CourtRateDAO rateDAO) {
        try {
            Integer rateId = Integer.parseInt(request.getParameter("rateId"));
            Integer courtId = Integer.parseInt(request.getParameter("courtId"));
            Integer dayOfWeek = Integer.parseInt(request.getParameter("dayOfWeek"));
            LocalTime startHour = LocalTime.parse(request.getParameter("startHour"));
            LocalTime endHour = LocalTime.parse(request.getParameter("endHour"));
            BigDecimal hourlyRate = new BigDecimal(request.getParameter("hourlyRate"));
            Boolean isHoliday = request.getParameter("isHoliday") != null;
            CourtRateDTO rate = CourtRateDTO.builder()
                    .rateId(rateId)
                    .courtId(courtId)
                    .dayOfWeek(dayOfWeek)
                    .startHour(startHour)
                    .endHour(endHour)
                    .hourlyRate(hourlyRate)
                    .isHoliday(isHoliday)
                    .build();
            boolean success = rateDAO.updateRate(rate);
            if (success) session.setAttribute("successMessage", "Cập nhật giá sân thành công!");
            else session.setAttribute("errorMessage", "Cập nhật giá sân thất bại!");
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Dữ liệu không hợp lệ!");
        }
    }
    private void handleDeleteRate(HttpServletRequest request, HttpSession session, CourtRateDAO rateDAO) {
        try {
            Integer rateId = Integer.parseInt(request.getParameter("rateId"));
            boolean success = rateDAO.deleteRate(rateId);
            if (success) session.setAttribute("successMessage", "Xóa giá sân thành công!");
            else session.setAttribute("errorMessage", "Xóa giá sân thất bại!");
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Dữ liệu không hợp lệ!");
        }
    }
} 