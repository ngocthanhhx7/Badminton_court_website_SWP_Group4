package controller.admin;

import dao.SliderDAO;
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
import models.SliderDTO;
import utils.AccessControlUtil;
import utils.FileUploadUtil;

/**
 *
 * @author nguye
 */
@WebServlet(name="SliderManagerController", urlPatterns={"/slider-manager"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 1024 * 1024 * 5,   // 5 MB
    maxRequestSize = 1024 * 1024 * 10 // 10 MB
)
public class SliderManagerController extends HttpServlet {
   
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet SliderManagerController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SliderManagerController at " + request.getContextPath () + "</h1>");
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
            String searchTitle = request.getParameter("searchTitle");
            String statusFilter = request.getParameter("statusFilter");
            String sortBy = request.getParameter("sortBy");
            String sortOrder = request.getParameter("sortOrder");
            String pageStr = request.getParameter("page");
            String pageSizeStr = request.getParameter("pageSize");
            
            // Set default values
            int page = 1;
            int pageSize = 10;
            Boolean isActive = null;
            
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
                if ("active".equals(statusFilter)) {
                    isActive = true;
                } else if ("inactive".equals(statusFilter)) {
                    isActive = false;
                }
            }
            
            // Validate sort parameters
            if (sortBy == null || sortBy.trim().isEmpty()) {
                sortBy = "SliderID";
            }
            if (sortOrder == null || sortOrder.trim().isEmpty()) {
                sortOrder = "DESC";
            }
            
            // Validate sortBy to prevent SQL injection
            String[] allowedSortFields = {"SliderID", "Title", "Position", "IsActive", "CreatedAt"};
            boolean isValidSortField = false;
            for (String field : allowedSortFields) {
                if (field.equals(sortBy)) {
                    isValidSortField = true;
                    break;
                }
            }
            if (!isValidSortField) {
                sortBy = "SliderID";
            }
            
            // Validate sortOrder
            if (!"ASC".equalsIgnoreCase(sortOrder) && !"DESC".equalsIgnoreCase(sortOrder)) {
                sortOrder = "DESC";
            }
            
            SliderDAO sliderDAO = new SliderDAO();
            
            // Get filtered sliders with pagination
            List<SliderDTO> sliders = sliderDAO.getSlidersWithFilters(isActive, searchTitle, sortBy, sortOrder, page, pageSize);
            
            // Get total count for pagination
            int totalSliders = sliderDAO.getFilteredSlidersCount(isActive, searchTitle);
            int totalPages = (int) Math.ceil((double) totalSliders / pageSize);
            
            // Set attributes for JSP
            request.setAttribute("sliders", sliders);
            request.setAttribute("currentPage", page);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalSliders", totalSliders);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("searchTitle", searchTitle);
            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("sortBy", sortBy);
            request.setAttribute("sortOrder", sortOrder);
            
            // Calculate pagination info
            int startRecord = (page - 1) * pageSize + 1;
            int endRecord = Math.min(page * pageSize, totalSliders);
            request.setAttribute("startRecord", startRecord);
            request.setAttribute("endRecord", endRecord);
            
            request.getRequestDispatcher("slider-manager.jsp").forward(request, response);
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
            SliderDAO sliderDAO = new SliderDAO();
            
            switch (action) {
                case "add":
                    handleAddSlider(request, response, sliderDAO);
                    break;
                case "edit":
                    handleEditSlider(request, response, sliderDAO);
                    break;
                case "delete":
                    handleDeleteSlider(request, response, sliderDAO);
                    break;
                case "toggleStatus":
                    handleToggleStatus(request, response, sliderDAO);
                    break;
                default:
                    response.sendRedirect("slider-manager");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred: " + e.getMessage());
        }
    }
    
    private void handleAddSlider(HttpServletRequest request, HttpServletResponse response, SliderDAO sliderDAO) 
            throws ServletException, IOException, SQLException {
        String title = request.getParameter("title");
        String subtitle = request.getParameter("subtitle");
        String backgroundImage = request.getParameter("backgroundImage");
        String positionStr = request.getParameter("position");
        Part filePart = request.getPart("backgroundImageFile");
        HttpSession session = request.getSession();
        
        System.out.println("DEBUG: Add slider - title: " + title);
        System.out.println("DEBUG: Add slider - subtitle: " + subtitle);
        System.out.println("DEBUG: Add slider - backgroundImage: " + backgroundImage);
        System.out.println("DEBUG: Add slider - position: " + positionStr);
        System.out.println("DEBUG: Add slider - filePart: " + (filePart != null ? filePart.getSubmittedFileName() : "null"));
        
        if (title != null && !title.trim().isEmpty() && 
            subtitle != null && !subtitle.trim().isEmpty() && 
            positionStr != null) {
            try {
                int position = Integer.parseInt(positionStr);
                
                // Handle file upload
                String finalImagePath = backgroundImage;
                if (filePart != null && filePart.getSize() > 0) {
                    try {
                        String uploadedPath = FileUploadUtil.uploadFile(filePart, request.getServletContext().getRealPath("/img/carousel"));
                        if (uploadedPath != null) {
                            finalImagePath = uploadedPath;
                        }
                    } catch (IOException e) {
                        session.setAttribute("errorMessage", "Lỗi upload file: " + e.getMessage());
                        response.sendRedirect("slider-manager");
                        return;
                    }
                }
                
                // Validate that we have either uploaded file or image path
                if (finalImagePath == null || finalImagePath.trim().isEmpty()) {
                    session.setAttribute("errorMessage", "Vui lòng chọn ảnh hoặc nhập đường dẫn ảnh!");
                    response.sendRedirect("slider-manager");
                    return;
                }
                
                SliderDTO newSlider = SliderDTO.builder()
                        .Title(title.trim())
                        .Subtitle(subtitle.trim())
                        .BackgroundImage(finalImagePath.trim())
                        .Position(position)
                        .IsActive(true)
                        .CreatedAt(new Timestamp(System.currentTimeMillis()))
                        .build();
                
                boolean success = sliderDAO.addSlider(newSlider);
                if (success) {
                    session.setAttribute("successMessage", "Thêm slider thành công!");
                } else {
                    session.setAttribute("errorMessage", "Thêm slider thất bại!");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "Vị trí không hợp lệ!");
            }
        } else {
            session.setAttribute("errorMessage", "Vui lòng nhập đầy đủ thông tin!");
        }
        
        response.sendRedirect("slider-manager");
    }
    
    private void handleEditSlider(HttpServletRequest request, HttpServletResponse response, SliderDAO sliderDAO) 
            throws ServletException, IOException, SQLException {
        String sliderIdStr = request.getParameter("sliderID");
        String title = request.getParameter("title");
        String subtitle = request.getParameter("subtitle");
        String backgroundImage = request.getParameter("backgroundImage");
        String positionStr = request.getParameter("position");
        Part filePart = request.getPart("backgroundImageFile");
        HttpSession session = request.getSession();
        
        System.out.println("DEBUG: Edit slider - sliderID: " + sliderIdStr);
        System.out.println("DEBUG: Edit slider - title: " + title);
        System.out.println("DEBUG: Edit slider - subtitle: " + subtitle);
        System.out.println("DEBUG: Edit slider - backgroundImage: " + backgroundImage);
        System.out.println("DEBUG: Edit slider - position: " + positionStr);
        System.out.println("DEBUG: Edit slider - filePart: " + (filePart != null ? filePart.getSubmittedFileName() : "null"));
        
        if (sliderIdStr != null && title != null && subtitle != null && positionStr != null) {
            try {
                int sliderId = Integer.parseInt(sliderIdStr);
                int position = Integer.parseInt(positionStr);
                
                System.out.println("DEBUG: Parsed sliderID: " + sliderId + ", position: " + position);
                
                // Get the current slider to preserve the IsActive status
                SliderDTO currentSlider = sliderDAO.getSliderById(sliderId);
                if (currentSlider == null) {
                    System.out.println("DEBUG: Current slider not found for ID: " + sliderId);
                    session.setAttribute("errorMessage", "Không tìm thấy slider!");
                    response.sendRedirect("slider-manager");
                    return;
                }
                
                System.out.println("DEBUG: Current slider found, IsActive: " + currentSlider.getIsActive());
                
                // Handle file upload
                String finalImagePath = backgroundImage;
                String oldImagePath = currentSlider.getBackgroundImage();
                
                if (filePart != null && filePart.getSize() > 0) {
                    try {
                        String uploadedPath = FileUploadUtil.uploadFile(filePart, request.getServletContext().getRealPath(""));
                        if (uploadedPath != null) {
                            finalImagePath = uploadedPath;
                            // Delete old image file if it's not an external URL
                            if (oldImagePath != null && !oldImagePath.startsWith("http")) {
                                FileUploadUtil.deleteFile(oldImagePath, request.getServletContext().getRealPath(""));
                            }
                        }
                    } catch (IOException e) {
                        session.setAttribute("errorMessage", "Lỗi upload file: " + e.getMessage());
                        response.sendRedirect("slider-manager");
                        return;
                    }
                } else if (backgroundImage == null || backgroundImage.trim().isEmpty()) {
                    // If no new file and no image path provided, keep the old one
                    finalImagePath = oldImagePath;
                }
                
                SliderDTO slider = SliderDTO.builder()
                        .SliderID(sliderId)
                        .Title(title.trim())
                        .Subtitle(subtitle.trim())
                        .BackgroundImage(finalImagePath)
                        .Position(position)
                        .IsActive(currentSlider.getIsActive()) // Preserve the current status
                        .build();
                
                System.out.println("DEBUG: About to update slider with ID: " + slider.getSliderID());
                
                boolean success = sliderDAO.updateSlider(slider);
                System.out.println("DEBUG: Update result: " + success);
                
                if (success) {
                    session.setAttribute("successMessage", "Cập nhật slider thành công!");
                } else {
                    session.setAttribute("errorMessage", "Cập nhật slider thất bại!");
                }
            } catch (NumberFormatException e) {
                System.out.println("DEBUG: NumberFormatException: " + e.getMessage());
                session.setAttribute("errorMessage", "ID hoặc vị trí không hợp lệ!");
            }
        } else {
            System.out.println("DEBUG: Missing required parameters");
            session.setAttribute("errorMessage", "Vui lòng nhập đầy đủ thông tin!");
        }
        
        response.sendRedirect("slider-manager");
    }
    
    private void handleDeleteSlider(HttpServletRequest request, HttpServletResponse response, SliderDAO sliderDAO) 
            throws ServletException, IOException, SQLException {
        String sliderIdStr = request.getParameter("sliderID");
        HttpSession session = request.getSession();
        
        if (sliderIdStr != null) {
            try {
                int sliderId = Integer.parseInt(sliderIdStr);
                
                // Get slider info before deleting to remove image file
                SliderDTO slider = sliderDAO.getSliderById(sliderId);
                if (slider != null && slider.getBackgroundImage() != null) {
                    // Delete image file if it's not an external URL
                    if (!slider.getBackgroundImage().startsWith("http")) {
                        FileUploadUtil.deleteFile(slider.getBackgroundImage(), request.getServletContext().getRealPath(""));
                    }
                }
                
                boolean success = sliderDAO.deleteSlider(sliderId);
                if (success) {
                    session.setAttribute("successMessage", "Xóa slider thành công!");
                } else {
                    session.setAttribute("errorMessage", "Xóa slider thất bại!");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "ID slider không hợp lệ!");
            }
        } else {
            session.setAttribute("errorMessage", "ID slider không được cung cấp!");
        }
        
        response.sendRedirect("slider-manager");
    }
    
    private void handleToggleStatus(HttpServletRequest request, HttpServletResponse response, SliderDAO sliderDAO) 
            throws ServletException, IOException, SQLException {
        String sliderIdStr = request.getParameter("sliderID");
        HttpSession session = request.getSession();
        
        if (sliderIdStr != null) {
            try {
                int sliderId = Integer.parseInt(sliderIdStr);
                boolean success = sliderDAO.toggleSliderStatus(sliderId);
                if (success) {
                    session.setAttribute("successMessage", "Cập nhật trạng thái thành công!");
                } else {
                    session.setAttribute("errorMessage", "Cập nhật trạng thái thất bại!");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "ID slider không hợp lệ!");
            }
        } else {
            session.setAttribute("errorMessage", "ID slider không được cung cấp!");
        }
        
        response.sendRedirect("slider-manager");
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
