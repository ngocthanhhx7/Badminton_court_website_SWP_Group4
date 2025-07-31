package controller.admin;

import dao.OfferDAO;
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
import models.OfferDTO;
import utils.AccessControlUtil;
import utils.FileUploadUtil;

@WebServlet(name="OfferManagerController", urlPatterns={"/offer-manager"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 1024 * 1024 * 5,   // 5 MB
    maxRequestSize = 1024 * 1024 * 10 // 10 MB
)
public class OfferManagerController extends HttpServlet {
   
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet OfferManagerController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet OfferManagerController at " + request.getContextPath () + "</h1>");
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
            String vipFilter = request.getParameter("vipFilter");
            String sortBy = request.getParameter("sortBy");
            String sortOrder = request.getParameter("sortOrder");
            String pageStr = request.getParameter("page");
            String pageSizeStr = request.getParameter("pageSize");
            
            // Set default values
            int page = 1;
            int pageSize = 10;
            Boolean isActive = null;
            Boolean isVIP = null;
            
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
            
            // Parse VIP filter
            if (vipFilter != null && !vipFilter.trim().isEmpty()) {
                if ("vip".equals(vipFilter)) {
                    isVIP = true;
                } else if ("normal".equals(vipFilter)) {
                    isVIP = false;
                }
            }
            
            // Validate sort parameters
            if (sortBy == null || sortBy.trim().isEmpty()) {
                sortBy = "OfferID";
            }
            if (sortOrder == null || sortOrder.trim().isEmpty()) {
                sortOrder = "DESC";
            }
            
            // Validate sortBy to prevent SQL injection
            String[] allowedSortFields = {"OfferID", "Title", "Capacity", "IsVIP", "IsActive", "CreatedAt"};
            boolean isValidSortField = false;
            for (String field : allowedSortFields) {
                if (field.equals(sortBy)) {
                    isValidSortField = true;
                    break;
                }
            }
            if (!isValidSortField) {
                sortBy = "OfferID";
            }
            
            // Validate sortOrder
            if (!"ASC".equalsIgnoreCase(sortOrder) && !"DESC".equalsIgnoreCase(sortOrder)) {
                sortOrder = "DESC";
            }
            
            OfferDAO offerDAO = new OfferDAO();
            
            // Get filtered offers with pagination
            List<OfferDTO> offers = offerDAO.getOffersWithFilters(isActive, searchTitle, isVIP, sortBy, sortOrder, page, pageSize);
            
            // Get total count for pagination
            int totalOffers = offerDAO.getFilteredOffersCount(isActive, searchTitle, isVIP);
            int totalPages = (int) Math.ceil((double) totalOffers / pageSize);
            
            // Set attributes for JSP
            request.setAttribute("offers", offers);
            request.setAttribute("currentPage", page);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalOffers", totalOffers);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("searchTitle", searchTitle);
            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("vipFilter", vipFilter);
            request.setAttribute("sortBy", sortBy);
            request.setAttribute("sortOrder", sortOrder);
            
            // Calculate pagination info
            int startRecord = (page - 1) * pageSize + 1;
            int endRecord = Math.min(page * pageSize, totalOffers);
            request.setAttribute("startRecord", startRecord);
            request.setAttribute("endRecord", endRecord);
            
            request.getRequestDispatcher("offer-manager.jsp").forward(request, response);
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
            OfferDAO offerDAO = new OfferDAO();
            
            switch (action) {
                case "add":
                    handleAddOffer(request, response, offerDAO);
                    break;
                case "edit":
                    handleEditOffer(request, response, offerDAO);
                    break;
                case "delete":
                    handleDeleteOffer(request, response, offerDAO);
                    break;
                case "toggleStatus":
                    handleToggleStatus(request, response, offerDAO);
                    break;
                default:
                    response.sendRedirect("offer-manager");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred: " + e.getMessage());
        }
    }
    
    private void handleAddOffer(HttpServletRequest request, HttpServletResponse response, OfferDAO offerDAO) 
            throws ServletException, IOException, SQLException {
        String title = request.getParameter("title");
        String subtitle = request.getParameter("subtitle");
        String description = request.getParameter("description");
        String capacityStr = request.getParameter("capacity");
        String isVIPStr = request.getParameter("isVIP");
        Part imagePart = request.getPart("imageFile");
        String imageUrl = request.getParameter("imageUrl");
        HttpSession session = request.getSession();
        
        System.out.println("DEBUG: Add offer - title: " + title);
        System.out.println("DEBUG: Add offer - subtitle: " + subtitle);
        System.out.println("DEBUG: Add offer - description: " + description);
        System.out.println("DEBUG: Add offer - capacity: " + capacityStr);
        System.out.println("DEBUG: Add offer - isVIP: " + isVIPStr);
        System.out.println("DEBUG: Add offer - imagePart: " + (imagePart != null ? imagePart.getSubmittedFileName() : "null"));
        
        if (title != null && !title.trim().isEmpty() && 
            description != null && !description.trim().isEmpty() && 
            capacityStr != null && !capacityStr.trim().isEmpty()) {
            
            // Parse capacity
            int capacity;
            try {
                capacity = Integer.parseInt(capacityStr);
                if (capacity < 0) {
                    session.setAttribute("errorMessage", "Sức chứa phải là số dương!");
                    response.sendRedirect("offer-manager");
                    return;
                }
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "Sức chứa không hợp lệ!");
                response.sendRedirect("offer-manager");
                return;
            }
            
            // Parse isVIP
            boolean isVIP = "on".equals(isVIPStr) || "true".equals(isVIPStr);
            
            // Handle file upload
            String finalImageUrl = imageUrl;
            
            if (imagePart != null && imagePart.getSize() > 0) {
                try {
                    String uploadedPath = FileUploadUtil.uploadFile(imagePart, request.getServletContext().getRealPath(""));
                    if (uploadedPath != null) {
                        finalImageUrl = uploadedPath;
                    }
                } catch (IOException e) {
                    session.setAttribute("errorMessage", "Lỗi upload file ảnh: " + e.getMessage());
                    response.sendRedirect("offer-manager");
                    return;
                }
            }
            
            OfferDTO newOffer = OfferDTO.builder()
                    .Title(title.trim())
                    .Subtitle(subtitle != null ? subtitle.trim() : "")
                    .Description(description.trim())
                    .ImageUrl(finalImageUrl)
                    .Capacity(capacity)
                    .IsVIP(isVIP)
                    .IsActive(true)
                    .CreatedAt(new Timestamp(System.currentTimeMillis()))
                    .build();
            
            boolean success = offerDAO.addOffer(newOffer);
            if (success) {
                session.setAttribute("successMessage", "Thêm offer thành công!");
            } else {
                session.setAttribute("errorMessage", "Thêm offer thất bại!");
            }
        } else {
            session.setAttribute("errorMessage", "Vui lòng nhập đầy đủ thông tin bắt buộc!");
        }
        
        response.sendRedirect("offer-manager");
    }
    
    private void handleEditOffer(HttpServletRequest request, HttpServletResponse response, OfferDAO offerDAO) 
            throws ServletException, IOException, SQLException {
        String offerIdStr = request.getParameter("offerID");
        String title = request.getParameter("title");
        String subtitle = request.getParameter("subtitle");
        String description = request.getParameter("description");
        String capacityStr = request.getParameter("capacity");
        String isVIPStr = request.getParameter("isVIP");
        Part imagePart = request.getPart("imageFile");
        String imageUrl = request.getParameter("imageUrl");
        HttpSession session = request.getSession();
        
        System.out.println("DEBUG: Edit offer - offerID: " + offerIdStr);
        System.out.println("DEBUG: Edit offer - title: " + title);
        System.out.println("DEBUG: Edit offer - description: " + description);
        System.out.println("DEBUG: Edit offer - capacity: " + capacityStr);
        
        if (offerIdStr != null && title != null && description != null && capacityStr != null) {
            try {
                int offerId = Integer.parseInt(offerIdStr);
                
                System.out.println("DEBUG: Parsed offerID: " + offerId);
                
                // Get the current offer to preserve the IsActive status
                OfferDTO currentOffer = offerDAO.getOfferById(offerId);
                if (currentOffer == null) {
                    System.out.println("DEBUG: Current offer not found for ID: " + offerId);
                    session.setAttribute("errorMessage", "Không tìm thấy offer!");
                    response.sendRedirect("offer-manager");
                    return;
                }
                
                System.out.println("DEBUG: Current offer found, IsActive: " + currentOffer.getIsActive());
                
                // Parse capacity
                int capacity;
                try {
                    capacity = Integer.parseInt(capacityStr);
                    if (capacity < 0) {
                        session.setAttribute("errorMessage", "Sức chứa phải là số dương!");
                        response.sendRedirect("offer-manager");
                        return;
                    }
                } catch (NumberFormatException e) {
                    session.setAttribute("errorMessage", "Sức chứa không hợp lệ!");
                    response.sendRedirect("offer-manager");
                    return;
                }
                
                // Parse isVIP
                boolean isVIP = "on".equals(isVIPStr) || "true".equals(isVIPStr);
                
                // Handle file upload
                String finalImageUrl = imageUrl;
                String oldImageUrl = currentOffer.getImageUrl();
                
                if (imagePart != null && imagePart.getSize() > 0) {
                    try {
                        String uploadedPath = FileUploadUtil.uploadFile(imagePart, request.getServletContext().getRealPath(""));
                        if (uploadedPath != null) {
                            finalImageUrl = uploadedPath;
                            // Delete old image file if it's not an external URL
                            if (oldImageUrl != null && !oldImageUrl.startsWith("http")) {
                                FileUploadUtil.deleteFile(oldImageUrl, request.getServletContext().getRealPath(""));
                            }
                        }
                    } catch (IOException e) {
                        session.setAttribute("errorMessage", "Lỗi upload file ảnh: " + e.getMessage());
                        response.sendRedirect("offer-manager");
                        return;
                    }
                } else if (imageUrl == null || imageUrl.trim().isEmpty()) {
                    // If no new file and no image path provided, keep the old one
                    finalImageUrl = oldImageUrl;
                }
                
                OfferDTO offer = OfferDTO.builder()
                        .OfferID(offerId)
                        .Title(title.trim())
                        .Subtitle(subtitle != null ? subtitle.trim() : "")
                        .Description(description.trim())
                        .ImageUrl(finalImageUrl)
                        .Capacity(capacity)
                        .IsVIP(isVIP)
                        .IsActive(currentOffer.getIsActive()) // Preserve the current status
                        .build();
                
                System.out.println("DEBUG: About to update offer with ID: " + offer.getOfferID());
                
                boolean success = offerDAO.updateOffer(offer);
                System.out.println("DEBUG: Update result: " + success);
                
                if (success) {
                    session.setAttribute("successMessage", "Cập nhật offer thành công!");
                } else {
                    session.setAttribute("errorMessage", "Cập nhật offer thất bại!");
                }
            } catch (NumberFormatException e) {
                System.out.println("DEBUG: NumberFormatException: " + e.getMessage());
                session.setAttribute("errorMessage", "ID offer không hợp lệ!");
            }
        } else {
            System.out.println("DEBUG: Missing required parameters");
            session.setAttribute("errorMessage", "Vui lòng nhập đầy đủ thông tin!");
        }
        
        response.sendRedirect("offer-manager");
    }
    
    private void handleDeleteOffer(HttpServletRequest request, HttpServletResponse response, OfferDAO offerDAO) 
            throws ServletException, IOException, SQLException {
        String offerIdStr = request.getParameter("offerID");
        HttpSession session = request.getSession();
        
        if (offerIdStr != null) {
            try {
                int offerId = Integer.parseInt(offerIdStr);
                
                // Get offer info before deleting to remove image file
                OfferDTO offer = offerDAO.getOfferById(offerId);
                if (offer != null) {
                    // Delete image file if it's not an external URL
                    if (offer.getImageUrl() != null && !offer.getImageUrl().startsWith("http")) {
                        FileUploadUtil.deleteFile(offer.getImageUrl(), request.getServletContext().getRealPath(""));
                    }
                }
                
                boolean success = offerDAO.deleteOffer(offerId);
                if (success) {
                    session.setAttribute("successMessage", "Xóa offer thành công!");
                } else {
                    session.setAttribute("errorMessage", "Xóa offer thất bại!");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "ID offer không hợp lệ!");
            }
        } else {
            session.setAttribute("errorMessage", "ID offer không được cung cấp!");
        }
        
        response.sendRedirect("offer-manager");
    }
    
    private void handleToggleStatus(HttpServletRequest request, HttpServletResponse response, OfferDAO offerDAO) 
            throws ServletException, IOException, SQLException {
        String offerIdStr = request.getParameter("offerID");
        HttpSession session = request.getSession();
        
        if (offerIdStr != null) {
            try {
                int offerId = Integer.parseInt(offerIdStr);
                boolean success = offerDAO.toggleOfferStatus(offerId);
                if (success) {
                    session.setAttribute("successMessage", "Cập nhật trạng thái thành công!");
                } else {
                    session.setAttribute("errorMessage", "Cập nhật trạng thái thất bại!");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "ID offer không hợp lệ!");
            }
        } else {
            session.setAttribute("errorMessage", "ID offer không được cung cấp!");
        }
        
        response.sendRedirect("offer-manager");
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
