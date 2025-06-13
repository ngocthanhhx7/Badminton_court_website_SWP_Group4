package controllerUser;

import com.google.gson.Gson;
import dao.CourtDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.CourtDTO;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/api/courts")
public class CourtApiController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            String search = request.getParameter("search");
            String status = request.getParameter("status");
            String courtType = request.getParameter("courtType");
            int page = 1;
            int courtsPerPage = 2;
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (Exception ignored) {}

            CourtDAO courtDAO = new CourtDAO();
            List<CourtDTO> courts = courtDAO.filterCourts(search, status, courtType);
            int totalCourts = courts != null ? courts.size() : 0;
            int totalPages = (int) Math.ceil((double) totalCourts / courtsPerPage);
            if (page < 1) page = 1;
            if (page > totalPages) page = totalPages;
            int start = (page - 1) * courtsPerPage;
            int end = Math.min(start + courtsPerPage, totalCourts);
            List<CourtDTO> pagedCourts = courts != null && totalCourts > 0 ? courts.subList(start, end) : java.util.Collections.emptyList();

            Map<String, Object> result = new HashMap<>();
            result.put("courts", pagedCourts);
            result.put("currentPage", page);
            result.put("totalPages", totalPages);

            out.print(new Gson().toJson(result));
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"error\":\"Server error\"}");
        } finally {
            out.close();
        }
    }
} 