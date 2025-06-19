package controller.admin;

import dao.AboutSectionDAO;
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
import models.AboutSectionDTO;
import utils.AccessControlUtil;
import utils.FileUploadUtil;

@WebServlet(name="AboutManagerController", urlPatterns={"/about-manager"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 1024 * 1024 * 5,   // 5 MB
    maxRequestSize = 1024 * 1024 * 10 // 10 MB
)
public class AboutManagerController extends HttpServlet {
   
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AboutManagerController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AboutManagerController at " + request.getContextPath () + "</h1>");
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
            String sectionTypeFilter = request.getParameter("sectionTypeFilter");
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
                sortBy = "AboutID";
            }
            if (sortOrder == null || sortOrder.trim().isEmpty()) {
                sortOrder = "DESC";
            }
            
            // Validate sortBy to prevent SQL injection
            String[] allowedSortFields = {"AboutID", "Title", "SectionType", "IsActive", "CreatedAt"};
            boolean isValidSortField = false;
            for (String field : allowedSortFields) {
                if (field.equals(sortBy)) {
                    isValidSortField = true;
                    break;
                }
            }
            if (!isValidSortField) {
                sortBy = "AboutID";
            }
            
            // Validate sortOrder
            if (!"ASC".equalsIgnoreCase(sortOrder) && !"DESC".equalsIgnoreCase(sortOrder)) {
                sortOrder = "DESC";
            }
            
            AboutSectionDAO aboutSectionDAO = new AboutSectionDAO();
            
            // Get filtered sections with pagination
            List<AboutSectionDTO> sections = aboutSectionDAO.getSectionsWithFilters(isActive, searchTitle, sectionTypeFilter, sortBy, sortOrder, page, pageSize);
            
            // Get total count for pagination
            int totalSections = aboutSectionDAO.getFilteredSectionsCount(isActive, searchTitle, sectionTypeFilter);
            int totalPages = (int) Math.ceil((double) totalSections / pageSize);
            
            // Set attributes for JSP
            request.setAttribute("sections", sections);
            request.setAttribute("currentPage", page);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalSections", totalSections);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("searchTitle", searchTitle);
            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("sectionTypeFilter", sectionTypeFilter);
            request.setAttribute("sortBy", sortBy);
            request.setAttribute("sortOrder", sortOrder);
            
            // Calculate pagination info
            int startRecord = (page - 1) * pageSize + 1;
            int endRecord = Math.min(page * pageSize, totalSections);
            request.setAttribute("startRecord", startRecord);
            request.setAttribute("endRecord", endRecord);
            
            request.getRequestDispatcher("about-manager.jsp").forward(request, response);
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
            AboutSectionDAO aboutSectionDAO = new AboutSectionDAO();
            
            switch (action) {
                case "add":
                    handleAddSection(request, response, aboutSectionDAO);
                    break;
                case "edit":
                    handleEditSection(request, response, aboutSectionDAO);
                    break;
                case "delete":
                    handleDeleteSection(request, response, aboutSectionDAO);
                    break;
                case "toggleStatus":
                    handleToggleStatus(request, response, aboutSectionDAO);
                    break;
                default:
                    response.sendRedirect("about-manager");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred: " + e.getMessage());
        }
    }
    
    private void handleAddSection(HttpServletRequest request, HttpServletResponse response, AboutSectionDAO aboutSectionDAO) 
            throws ServletException, IOException, SQLException {
        String title = request.getParameter("title");
        String subtitle = request.getParameter("subtitle");
        String content = request.getParameter("content");
        String sectionType = request.getParameter("sectionType");
        Part image1Part = request.getPart("image1File");
        Part image2Part = request.getPart("image2File");
        String image1 = request.getParameter("image1");
        String image2 = request.getParameter("image2");
        HttpSession session = request.getSession();
        
        System.out.println("DEBUG: Add section - title: " + title);
        System.out.println("DEBUG: Add section - subtitle: " + subtitle);
        System.out.println("DEBUG: Add section - content: " + content);
        System.out.println("DEBUG: Add section - sectionType: " + sectionType);
        System.out.println("DEBUG: Add section - image1Part: " + (image1Part != null ? image1Part.getSubmittedFileName() : "null"));
        System.out.println("DEBUG: Add section - image2Part: " + (image2Part != null ? image2Part.getSubmittedFileName() : "null"));
        
        if (title != null && !title.trim().isEmpty() && 
            content != null && !content.trim().isEmpty() && 
            sectionType != null && !sectionType.trim().isEmpty()) {
            
            // Handle file uploads
            String finalImage1Path = image1;
            String finalImage2Path = image2;
            
            if (image1Part != null && image1Part.getSize() > 0) {
                try {
                    String uploadedPath = FileUploadUtil.uploadFile(image1Part, request.getServletContext().getRealPath(""));
                    if (uploadedPath != null) {
                        finalImage1Path = uploadedPath;
                    }
                } catch (IOException e) {
                    session.setAttribute("errorMessage", "Lỗi upload file ảnh 1: " + e.getMessage());
                    response.sendRedirect("about-manager");
                    return;
                }
            }
            
            if (image2Part != null && image2Part.getSize() > 0) {
                try {
                    String uploadedPath = FileUploadUtil.uploadFile(image2Part, request.getServletContext().getRealPath(""));
                    if (uploadedPath != null) {
                        finalImage2Path = uploadedPath;
                    }
                } catch (IOException e) {
                    session.setAttribute("errorMessage", "Lỗi upload file ảnh 2: " + e.getMessage());
                    response.sendRedirect("about-manager");
                    return;
                }
            }
            
            AboutSectionDTO newSection = AboutSectionDTO.builder()
                    .Title(title.trim())
                    .Subtitle(subtitle != null ? subtitle.trim() : "")
                    .Content(content.trim())
                    .Image1(finalImage1Path)
                    .Image2(finalImage2Path)
                    .SectionType(sectionType.trim())
                    .IsActive(true)
                    .CreatedAt(new Timestamp(System.currentTimeMillis()))
                    .build();
            
            boolean success = aboutSectionDAO.addSection(newSection);
            if (success) {
                session.setAttribute("successMessage", "Thêm section thành công!");
            } else {
                session.setAttribute("errorMessage", "Thêm section thất bại!");
            }
        } else {
            session.setAttribute("errorMessage", "Vui lòng nhập đầy đủ thông tin bắt buộc!");
        }
        
        response.sendRedirect("about-manager");
    }
    
    private void handleEditSection(HttpServletRequest request, HttpServletResponse response, AboutSectionDAO aboutSectionDAO) 
            throws ServletException, IOException, SQLException {
        String sectionIdStr = request.getParameter("sectionID");
        String title = request.getParameter("title");
        String subtitle = request.getParameter("subtitle");
        String content = request.getParameter("content");
        String sectionType = request.getParameter("sectionType");
        Part image1Part = request.getPart("image1File");
        Part image2Part = request.getPart("image2File");
        String image1 = request.getParameter("image1");
        String image2 = request.getParameter("image2");
        HttpSession session = request.getSession();
        
        System.out.println("DEBUG: Edit section - sectionID: " + sectionIdStr);
        System.out.println("DEBUG: Edit section - title: " + title);
        System.out.println("DEBUG: Edit section - content: " + content);
        System.out.println("DEBUG: Edit section - sectionType: " + sectionType);
        
        if (sectionIdStr != null && title != null && content != null && sectionType != null) {
            try {
                int sectionId = Integer.parseInt(sectionIdStr);
                
                System.out.println("DEBUG: Parsed sectionID: " + sectionId);
                
                // Get the current section to preserve the IsActive status
                AboutSectionDTO currentSection = aboutSectionDAO.getSectionById(sectionId);
                if (currentSection == null) {
                    System.out.println("DEBUG: Current section not found for ID: " + sectionId);
                    session.setAttribute("errorMessage", "Không tìm thấy section!");
                    response.sendRedirect("about-manager");
                    return;
                }
                
                System.out.println("DEBUG: Current section found, IsActive: " + currentSection.getIsActive());
                
                // Handle file uploads
                String finalImage1Path = image1;
                String finalImage2Path = image2;
                String oldImage1Path = currentSection.getImage1();
                String oldImage2Path = currentSection.getImage2();
                
                if (image1Part != null && image1Part.getSize() > 0) {
                    try {
                        String uploadedPath = FileUploadUtil.uploadFile(image1Part, request.getServletContext().getRealPath(""));
                        if (uploadedPath != null) {
                            finalImage1Path = uploadedPath;
                            // Delete old image file if it's not an external URL
                            if (oldImage1Path != null && !oldImage1Path.startsWith("http")) {
                                FileUploadUtil.deleteFile(oldImage1Path, request.getServletContext().getRealPath(""));
                            }
                        }
                    } catch (IOException e) {
                        session.setAttribute("errorMessage", "Lỗi upload file ảnh 1: " + e.getMessage());
                        response.sendRedirect("about-manager");
                        return;
                    }
                } else if (image1 == null || image1.trim().isEmpty()) {
                    // If no new file and no image path provided, keep the old one
                    finalImage1Path = oldImage1Path;
                }
                
                if (image2Part != null && image2Part.getSize() > 0) {
                    try {
                        String uploadedPath = FileUploadUtil.uploadFile(image2Part, request.getServletContext().getRealPath(""));
                        if (uploadedPath != null) {
                            finalImage2Path = uploadedPath;
                            // Delete old image file if it's not an external URL
                            if (oldImage2Path != null && !oldImage2Path.startsWith("http")) {
                                FileUploadUtil.deleteFile(oldImage2Path, request.getServletContext().getRealPath(""));
                            }
                        }
                    } catch (IOException e) {
                        session.setAttribute("errorMessage", "Lỗi upload file ảnh 2: " + e.getMessage());
                        response.sendRedirect("about-manager");
                        return;
                    }
                } else if (image2 == null || image2.trim().isEmpty()) {
                    // If no new file and no image path provided, keep the old one
                    finalImage2Path = oldImage2Path;
                }
                
                AboutSectionDTO section = AboutSectionDTO.builder()
                        .AboutID(sectionId)
                        .Title(title.trim())
                        .Subtitle(subtitle != null ? subtitle.trim() : "")
                        .Content(content.trim())
                        .Image1(finalImage1Path)
                        .Image2(finalImage2Path)
                        .SectionType(sectionType.trim())
                        .IsActive(currentSection.getIsActive()) // Preserve the current status
                        .build();
                
                System.out.println("DEBUG: About to update section with ID: " + section.getAboutID());
                
                boolean success = aboutSectionDAO.updateSection(section);
                System.out.println("DEBUG: Update result: " + success);
                
                if (success) {
                    session.setAttribute("successMessage", "Cập nhật section thành công!");
                } else {
                    session.setAttribute("errorMessage", "Cập nhật section thất bại!");
                }
            } catch (NumberFormatException e) {
                System.out.println("DEBUG: NumberFormatException: " + e.getMessage());
                session.setAttribute("errorMessage", "ID section không hợp lệ!");
            }
        } else {
            System.out.println("DEBUG: Missing required parameters");
            session.setAttribute("errorMessage", "Vui lòng nhập đầy đủ thông tin!");
        }
        
        response.sendRedirect("about-manager");
    }
    
    private void handleDeleteSection(HttpServletRequest request, HttpServletResponse response, AboutSectionDAO aboutSectionDAO) 
            throws ServletException, IOException, SQLException {
        String sectionIdStr = request.getParameter("sectionID");
        HttpSession session = request.getSession();
        
        if (sectionIdStr != null) {
            try {
                int sectionId = Integer.parseInt(sectionIdStr);
                
                // Get section info before deleting to remove image files
                AboutSectionDTO section = aboutSectionDAO.getSectionById(sectionId);
                if (section != null) {
                    // Delete image files if they're not external URLs
                    if (section.getImage1() != null && !section.getImage1().startsWith("http")) {
                        FileUploadUtil.deleteFile(section.getImage1(), request.getServletContext().getRealPath(""));
                    }
                    if (section.getImage2() != null && !section.getImage2().startsWith("http")) {
                        FileUploadUtil.deleteFile(section.getImage2(), request.getServletContext().getRealPath(""));
                    }
                }
                
                boolean success = aboutSectionDAO.deleteSection(sectionId);
                if (success) {
                    session.setAttribute("successMessage", "Xóa section thành công!");
                } else {
                    session.setAttribute("errorMessage", "Xóa section thất bại!");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "ID section không hợp lệ!");
            }
        } else {
            session.setAttribute("errorMessage", "ID section không được cung cấp!");
        }
        
        response.sendRedirect("about-manager");
    }
    
    private void handleToggleStatus(HttpServletRequest request, HttpServletResponse response, AboutSectionDAO aboutSectionDAO) 
            throws ServletException, IOException, SQLException {
        String sectionIdStr = request.getParameter("sectionID");
        HttpSession session = request.getSession();
        
        if (sectionIdStr != null) {
            try {
                int sectionId = Integer.parseInt(sectionIdStr);
                boolean success = aboutSectionDAO.toggleSectionStatus(sectionId);
                if (success) {
                    session.setAttribute("successMessage", "Cập nhật trạng thái thành công!");
                } else {
                    session.setAttribute("errorMessage", "Cập nhật trạng thái thất bại!");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "ID section không hợp lệ!");
            }
        } else {
            session.setAttribute("errorMessage", "ID section không được cung cấp!");
        }
        
        response.sendRedirect("about-manager");
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
