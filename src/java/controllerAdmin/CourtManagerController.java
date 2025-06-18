/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controllerAdmin;

import dao.CourtDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.CourtDTO;
import java.io.IOException;
import java.util.List;

/**
 *
 * @author nguye
 */
@WebServlet(name = "CourtManagerController", urlPatterns = {"/court-manager"})
public class CourtManagerController extends HttpServlet {

    private CourtDAO courtDAO;

    @Override
    public void init() {
        courtDAO = new CourtDAO();
    }

    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                listCourts(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteCourt(request, response);
                break;
            case "toggleStatus":
                toggleStatus(request, response);
                break;
            case "search":
                searchCourts(request, response);
                break;
            default:
                listCourts(request, response);
                break;
        }
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        switch (action) {
            case "add":
                addCourt(request, response);
                break;
            case "update":
                updateCourt(request, response);
                break;
            case "search":
                searchCourts(request, response);
                break;
            default:
                response.sendRedirect("court-manager");
                break;
        }
    }

    private void listCourts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<CourtDTO> courts = courtDAO.getAllCourts();
        request.setAttribute("courtList", courts);
        request.getRequestDispatcher("/court-manager.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String courtIdStr = request.getParameter("id");
        if (courtIdStr != null && !courtIdStr.isEmpty()) {
            try {
                Integer courtId = Integer.parseInt(courtIdStr);
                CourtDTO court = courtDAO.getCourtById(courtId);
                if (court != null) {
                    request.setAttribute("court", court);
                    request.getRequestDispatcher("/court-edit.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect("court-manager");
    }

    private void addCourt(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String courtName = request.getParameter("courtName");
            String description = request.getParameter("description");
            String courtType = request.getParameter("courtType");
            String status = request.getParameter("status");
            String courtImage = request.getParameter("courtImage");
            
            // Lấy thông tin người tạo từ session
            HttpSession session = request.getSession();
            Integer createdBy = 1; // Mặc định là admin ID = 1, có thể thay đổi theo logic của bạn
            
            CourtDTO court = CourtDTO.builder()
                    .courtName(courtName)
                    .description(description)
                    .courtType(courtType)
                    .status(status != null ? status : "Active")
                    .courtImage(courtImage)
                    .createdBy(createdBy)
                    .build();

            if (courtDAO.addCourt(court)) {
                request.setAttribute("message", "Thêm sân thành công!");
                request.setAttribute("messageType", "success");
            } else {
                request.setAttribute("message", "Thêm sân thất bại!");
                request.setAttribute("messageType", "error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Có lỗi xảy ra: " + e.getMessage());
            request.setAttribute("messageType", "error");
        }
        
        listCourts(request, response);
    }

    private void updateCourt(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String courtIdStr = request.getParameter("courtId");
            String courtName = request.getParameter("courtName");
            String description = request.getParameter("description");
            String courtType = request.getParameter("courtType");
            String status = request.getParameter("status");
            String courtImage = request.getParameter("courtImage");

            if (courtIdStr != null && !courtIdStr.isEmpty()) {
                Integer courtId = Integer.parseInt(courtIdStr);
                
                CourtDTO court = CourtDTO.builder()
                        .courtId(courtId)
                        .courtName(courtName)
                        .description(description)
                        .courtType(courtType)
                        .status(status)
                        .courtImage(courtImage)
                        .build();

                if (courtDAO.updateCourt(court)) {
                    request.setAttribute("message", "Cập nhật sân thành công!");
                    request.setAttribute("messageType", "success");
                } else {
                    request.setAttribute("message", "Cập nhật sân thất bại!");
                    request.setAttribute("messageType", "error");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Có lỗi xảy ra: " + e.getMessage());
            request.setAttribute("messageType", "error");
        }
        
        listCourts(request, response);
    }

    private void deleteCourt(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String courtIdStr = request.getParameter("id");
            if (courtIdStr != null && !courtIdStr.isEmpty()) {
                Integer courtId = Integer.parseInt(courtIdStr);
                if (courtDAO.deleteCourt(courtId)) {
                    request.setAttribute("message", "Xóa sân thành công!");
                    request.setAttribute("messageType", "success");
                } else {
                    request.setAttribute("message", "Xóa sân thất bại!");
                    request.setAttribute("messageType", "error");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Có lỗi xảy ra: " + e.getMessage());
            request.setAttribute("messageType", "error");
        }
        
        listCourts(request, response);
    }

    private void toggleStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String courtIdStr = request.getParameter("id");
            if (courtIdStr != null && !courtIdStr.isEmpty()) {
                Integer courtId = Integer.parseInt(courtIdStr);
                CourtDTO court = courtDAO.getCourtById(courtId);
                
                if (court != null) {
                    String newStatus = "Active".equals(court.getStatus()) ? "Inactive" : "Active";
                    court.setStatus(newStatus);
                    
                    if (courtDAO.updateCourt(court)) {
                        request.setAttribute("message", "Cập nhật trạng thái thành công!");
                        request.setAttribute("messageType", "success");
                    } else {
                        request.setAttribute("message", "Cập nhật trạng thái thất bại!");
                        request.setAttribute("messageType", "error");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Có lỗi xảy ra: " + e.getMessage());
            request.setAttribute("messageType", "error");
        }
        
        listCourts(request, response);
    }

    private void searchCourts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");
        String courtType = request.getParameter("courtType");
        
        List<CourtDTO> courts;
        
        if (keyword != null && !keyword.isEmpty()) {
            courts = courtDAO.searchCourtsByNameOrTypeOrStatus(keyword);
        } else {
            courts = courtDAO.filterCourts(keyword, status, courtType);
        }
        
        request.setAttribute("courtList", courts);
        request.setAttribute("keyword", keyword);
        request.setAttribute("status", status);
        request.setAttribute("courtType", courtType);
        request.getRequestDispatcher("/court-manager.jsp").forward(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Court CRUD";
    }
}
