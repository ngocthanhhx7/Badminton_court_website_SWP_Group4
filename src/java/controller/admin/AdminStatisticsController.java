package controller.admin;

import dao.StatsDAO;
import models.StatsDTO;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminStatisticsController", urlPatterns = {"/AdminStatisticsController"})
public class AdminStatisticsController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String from = request.getParameter("fromDate");
        String to = request.getParameter("toDate");

        LocalDate startDate;
        LocalDate endDate;
        try {
            if (from != null && !from.isEmpty() && to != null && !to.isEmpty()) {
                startDate = LocalDate.parse(from);
                endDate = LocalDate.parse(to);
            } else {
                endDate = LocalDate.now();
                startDate = endDate.minusDays(6);
            }
        } catch (DateTimeParseException ex) {
            endDate = LocalDate.now();
            startDate = endDate.minusDays(6);
        }

        // Chuyển thành LocalDateTime từ đầu ngày đến cuối ngày để bao gồm toàn bộ giờ
        LocalDateTime fromDateTime = startDate.atStartOfDay();
        LocalDateTime toDateTime = endDate.atTime(LocalTime.MAX);

        // Gọi dao với khoảng thời gian có giờ
        StatsDTO stats = new StatsDAO().getStats(fromDateTime, toDateTime);

        request.setAttribute("stats", stats);
        request.getRequestDispatcher("/admin-statistics.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}
