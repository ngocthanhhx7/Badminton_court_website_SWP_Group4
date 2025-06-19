package controllerAdmin;

import dao.CourtDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;
import models.CourtDTO;
import utils.AccessControlUtil;
import utils.FileUploadUtil;

/**
 *
 * @author nguye
 */
@WebServlet(name="CourtManagerController", urlPatterns={"/court-manager"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 1024 * 1024 * 5,   // 5 MB
    maxRequestSize = 1024 * 1024 * 10 // 10 MB
)
public class CourtManagerController extends HttpServlet {
   
    @Override
    public void init() throws ServletException {
        super.init();
        // Check and create table if needed
        try {
            CourtDAO courtDAO = new CourtDAO();
            courtDAO.checkAndCreateTable();
        } catch (Exception e) {
            System.err.println("Error initializing CourtManagerController: " + e.getMessage());
            e.printStackTrace();
        }
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CourtManagerController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CourtManagerController at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Expires", "0");
        
        // Kiểm tra phân quyền
        if (!AccessControlUtil.hasManagerAccess(request)) {
            response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
            return;
        }
        
        try {
            // Get messages from session and remove them
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
            
            // Get filter and pagination parameters
            String searchName = request.getParameter("searchName");
            String statusFilter = request.getParameter("statusFilter");
            String courtTypeFilter = request.getParameter("courtTypeFilter");
            String sortBy = request.getParameter("sortBy");
            String sortOrder = request.getParameter("sortOrder");
            String pageStr = request.getParameter("page");
            String pageSizeStr = request.getParameter("pageSize");
            
            // Set default values
            int page = 1;
            int pageSize = 10;
            String status = null;
            String courtType = null;
            
            // Parse pagination parameters
            if (pageStr != null && !pageStr.trim().isEmpty()) {
                try {
                    page = Integer.parseInt(pageStr);
                    if (page < 1) page = 1;
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }
            
            if (pageSizeStr != null && !pageSizeStr.trim().isEmpty()) {
                try {
                    pageSize = Integer.parseInt(pageSizeStr);
                    if (pageSize < 1) pageSize = 10;
                    if (pageSize > 100) pageSize = 100; // Limit maximum page size
                } catch (NumberFormatException e) {
                    pageSize = 10;
                }
            }
            
            // Parse status filter
            if (statusFilter != null && !statusFilter.trim().isEmpty()) {
                status = statusFilter;
            }
            
            // Parse court type filter
            if (courtTypeFilter != null && !courtTypeFilter.trim().isEmpty()) {
                courtType = courtTypeFilter;
            }
            
            // Validate sort parameters
            if (sortBy == null || sortBy.trim().isEmpty()) {
                sortBy = "CourtID";
            }
            if (sortOrder == null || sortOrder.trim().isEmpty()) {
                sortOrder = "DESC";
            }
            
            // Validate sortBy to prevent SQL injection
            String[] allowedSortFields = {"CourtID", "CourtName", "CourtType", "Status", "CreatedAt"};
            boolean isValidSortField = false;
            for (String field : allowedSortFields) {
                if (field.equals(sortBy)) {
                    isValidSortField = true;
                    break;
                }
            }
            if (!isValidSortField) {
                sortBy = "CourtID";
            }
            
            // Validate sortOrder
            if (!"ASC".equalsIgnoreCase(sortOrder) && !"DESC".equalsIgnoreCase(sortOrder)) {
                sortOrder = "DESC";
            }
            
            CourtDAO courtDAO = new CourtDAO();
            
            // Get filtered courts with pagination
            List<CourtDTO> courts = courtDAO.getCourtsWithFilters(status, courtType, searchName, sortBy, sortOrder, page, pageSize);
            
            // Get total count for pagination
            int totalCourts = courtDAO.getFilteredCourtsCount(status, courtType, searchName);
            int totalPages = (int) Math.ceil((double) totalCourts / pageSize);
            
            // Set attributes for JSP
            request.setAttribute("courts", courts);
            request.setAttribute("currentPage", page);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalCourts", totalCourts);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("searchName", searchName);
            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("courtTypeFilter", courtTypeFilter);
            request.setAttribute("sortBy", sortBy);
            request.setAttribute("sortOrder", sortOrder);
            
            // Calculate pagination info
            int startRecord = (page - 1) * pageSize + 1;
            int endRecord = Math.min(page * pageSize, totalCourts);
            request.setAttribute("startRecord", startRecord);
            request.setAttribute("endRecord", endRecord);
            
            request.getRequestDispatcher("court-manager.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred: " + e.getMessage());
        }
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Kiểm tra phân quyền
        if (!AccessControlUtil.hasManagerAccess(request)) {
            response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            CourtDAO courtDAO = new CourtDAO();
            
            switch (action) {
                case "add":
                    handleAddCourt(request, response, courtDAO);
                    break;
                case "edit":
                    handleEditCourt(request, response, courtDAO);
                    break;
                case "delete":
                    handleDeleteCourt(request, response, courtDAO);
                    break;
                case "toggleStatus":
                    handleToggleStatus(request, response, courtDAO);
                    break;
                default:
                    response.sendRedirect("court-manager");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            response.sendRedirect("court-manager");
        }
    }

    private void handleAddCourt(HttpServletRequest request, HttpServletResponse response, CourtDAO courtDAO) 
            throws ServletException, IOException, SQLException {
        
        try {
            String courtName = request.getParameter("courtName");
            String description = request.getParameter("description");
            String courtType = request.getParameter("courtType");
            String status = request.getParameter("status");
            String courtImage = request.getParameter("courtImage");
            
            System.out.println("Add Court - Parameters: " + 
                "courtName=" + courtName + 
                ", description=" + description + 
                ", courtType=" + courtType + 
                ", status=" + status + 
                ", courtImage=" + courtImage);
            
            // Validate required fields
            if (courtName == null || courtName.trim().isEmpty()) {
                setErrorMessage(request, "Tên sân không được để trống");
                response.sendRedirect("court-manager");
                return;
            }
            
            if (courtType == null || courtType.trim().isEmpty()) {
                setErrorMessage(request, "Loại sân không được để trống");
                response.sendRedirect("court-manager");
                return;
            }
            
            // Create court object
            String statusVal = (status != null && (status.equals("Available") || status.equals("Unavailable") || status.equals("Maintenance"))) ? status : "Available";
            CourtDTO court = CourtDTO.builder()
                    .courtName(courtName.trim())
                    .description(description != null ? description.trim() : null)
                    .courtType(courtType.trim())
                    .status(statusVal)
                    .courtImage(courtImage != null ? courtImage.trim() : null)
                    .createdBy(1) // Default admin ID
                    .build();
            
            // Save to database
            boolean success = courtDAO.addCourt(court);
            
            if (success) {
                setSuccessMessage(request, "Thêm sân thành công!");
            } else {
                setErrorMessage(request, "Thêm sân thất bại! Vui lòng kiểm tra lại thông tin.");
            }
            
        } catch (Exception e) {
            System.err.println("Error in handleAddCourt: " + e.getMessage());
            e.printStackTrace();
            setErrorMessage(request, "Lỗi: " + e.getMessage());
        }
        
        response.sendRedirect("court-manager");
    }

    private void handleEditCourt(HttpServletRequest request, HttpServletResponse response, CourtDAO courtDAO) 
            throws ServletException, IOException, SQLException {
        
        try {
            String courtIdStr = request.getParameter("courtId");
            String courtName = request.getParameter("courtName");
            String description = request.getParameter("description");
            String courtType = request.getParameter("courtType");
            String status = request.getParameter("status");
            String courtImage = request.getParameter("courtImage");
            
            System.out.println("Edit Court - Parameters: " + 
                "courtId=" + courtIdStr + 
                ", courtName=" + courtName + 
                ", description=" + description + 
                ", courtType=" + courtType + 
                ", status=" + status + 
                ", courtImage=" + courtImage);
            
            // Validate required fields
            if (courtIdStr == null || courtIdStr.trim().isEmpty()) {
                setErrorMessage(request, "ID sân không hợp lệ");
                response.sendRedirect("court-manager");
                return;
            }
            
            if (courtName == null || courtName.trim().isEmpty()) {
                setErrorMessage(request, "Tên sân không được để trống");
                response.sendRedirect("court-manager");
                return;
            }
            
            if (courtType == null || courtType.trim().isEmpty()) {
                setErrorMessage(request, "Loại sân không được để trống");
                response.sendRedirect("court-manager");
                return;
            }
            
            Integer courtId = Integer.parseInt(courtIdStr);
            
            // Get existing court
            CourtDTO existingCourt = courtDAO.getCourtById(courtId);
            if (existingCourt == null) {
                setErrorMessage(request, "Không tìm thấy sân!");
                response.sendRedirect("court-manager");
                return;
            }
            
            // Update court object
            String statusVal2 = (status != null && (status.equals("Available") || status.equals("Unavailable") || status.equals("Maintenance"))) ? status : "Available";
            CourtDTO court = CourtDTO.builder()
                    .courtId(courtId)
                    .courtName(courtName.trim())
                    .description(description != null ? description.trim() : null)
                    .courtType(courtType.trim())
                    .status(statusVal2)
                    .courtImage(courtImage != null ? courtImage.trim() : null)
                    .createdBy(existingCourt.getCreatedBy())
                    .createdAt(existingCourt.getCreatedAt())
                    .build();
            
            // Update in database
            boolean success = courtDAO.updateCourt(court);
            
            if (success) {
                setSuccessMessage(request, "Cập nhật sân thành công!");
            } else {
                setErrorMessage(request, "Cập nhật sân thất bại! Vui lòng kiểm tra lại thông tin.");
            }
            
        } catch (NumberFormatException e) {
            setErrorMessage(request, "ID sân không hợp lệ");
        } catch (Exception e) {
            System.err.println("Error in handleEditCourt: " + e.getMessage());
            e.printStackTrace();
            setErrorMessage(request, "Lỗi: " + e.getMessage());
        }
        
        response.sendRedirect("court-manager");
    }

    private void handleDeleteCourt(HttpServletRequest request, HttpServletResponse response, CourtDAO courtDAO) 
            throws ServletException, IOException, SQLException {
        
        try {
            String courtIdStr = request.getParameter("courtId");
            
            System.out.println("Delete Court - Parameters: courtId=" + courtIdStr);
            
            if (courtIdStr == null || courtIdStr.trim().isEmpty()) {
                setErrorMessage(request, "ID sân không hợp lệ");
                response.sendRedirect("court-manager");
                return;
            }
            
            Integer courtId = Integer.parseInt(courtIdStr);
            
            // Check if court exists
            CourtDTO court = courtDAO.getCourtById(courtId);
            if (court == null) {
                setErrorMessage(request, "Không tìm thấy sân!");
                response.sendRedirect("court-manager");
                return;
            }
            
            // Delete court
            boolean success = courtDAO.deleteCourt(courtId);
            
            if (success) {
                setSuccessMessage(request, "Xóa sân thành công!");
            } else {
                setErrorMessage(request, "Xóa sân thất bại! Vui lòng thử lại.");
            }
            
        } catch (NumberFormatException e) {
            setErrorMessage(request, "ID sân không hợp lệ");
        } catch (Exception e) {
            System.err.println("Error in handleDeleteCourt: " + e.getMessage());
            e.printStackTrace();
            setErrorMessage(request, "Lỗi: " + e.getMessage());
        }
        
        response.sendRedirect("court-manager");
    }

    private void handleToggleStatus(HttpServletRequest request, HttpServletResponse response, CourtDAO courtDAO) 
            throws ServletException, IOException, SQLException {
        
        String courtIdStr = request.getParameter("courtId");
        
        if (courtIdStr == null || courtIdStr.trim().isEmpty()) {
            setErrorMessage(request, "ID sân không hợp lệ");
            response.sendRedirect("court-manager");
            return;
        }
        
        try {
            Integer courtId = Integer.parseInt(courtIdStr);
            
            // Get existing court
            CourtDTO court = courtDAO.getCourtById(courtId);
            if (court == null) {
                setErrorMessage(request, "Không tìm thấy sân!");
                response.sendRedirect("court-manager");
                return;
            }
            
            // Toggle status
            String newStatus = "Available".equals(court.getStatus()) ? "Unavailable" : "Available";
            court.setStatus(newStatus);
            
            // Update in database
            boolean success = courtDAO.updateCourt(court);
            
            if (success) {
                setSuccessMessage(request, "Cập nhật trạng thái sân thành công!");
            } else {
                setErrorMessage(request, "Cập nhật trạng thái sân thất bại!");
            }
            
        } catch (NumberFormatException e) {
            setErrorMessage(request, "ID sân không hợp lệ");
        }
        
        response.sendRedirect("court-manager");
    }

    private void setSuccessMessage(HttpServletRequest request, String message) {
        HttpSession session = request.getSession();
        session.setAttribute("successMessage", message);
    }

    private void setErrorMessage(HttpServletRequest request, String message) {
        HttpSession session = request.getSession();
        session.setAttribute("errorMessage", message);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

} 