package controllerAdmin;

import dao.InstagramFeedDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.List;
import models.InstagramFeedDTO;
import utils.AccessControlUtil;

@WebServlet(name="InstagramManagerController", urlPatterns={"/instagram-manager"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 1024 * 1024 * 5,   // 5 MB
    maxRequestSize = 1024 * 1024 * 10 // 10 MB
)
public class InstagramManagerController extends HttpServlet {
    private static final int DEFAULT_PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Expires", "0");
        
        // Check access control
        if (!AccessControlUtil.hasManagerAccess(request)) {
            response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
            return;
        }
        
        try {
            // Get parameters
            String searchKeyword = request.getParameter("search");
            String visibleParam = request.getParameter("visible");
            String pageParam = request.getParameter("page");
            
            int page = pageParam != null ? Integer.parseInt(pageParam) : 1;
            Boolean isVisible = visibleParam != null ? Boolean.parseBoolean(visibleParam) : null;
            
            InstagramFeedDAO instagramFeedDAO = new InstagramFeedDAO();
            List<InstagramFeedDTO> feeds = instagramFeedDAO.getAllFeeds(page, DEFAULT_PAGE_SIZE, searchKeyword, isVisible);
            int totalFeeds = instagramFeedDAO.getTotalFeeds(searchKeyword, isVisible);
            int totalPages = (int) Math.ceil((double) totalFeeds / DEFAULT_PAGE_SIZE);
            
            // Set attributes
            request.setAttribute("feeds", feeds);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("search", searchKeyword);
            request.setAttribute("visible", visibleParam);
            
            // Forward to JSP
            request.getRequestDispatcher("instagram-manager.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        // Check access control
        if (!AccessControlUtil.hasManagerAccess(request)) {
            response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        InstagramFeedDAO instagramFeedDAO = new InstagramFeedDAO();
        
        // Debug logging
        System.out.println("=== Instagram Manager Debug ===");
        System.out.println("Action: " + action);
        System.out.println("ImageUrl: " + request.getParameter("imageUrl"));
        System.out.println("InstagramLink: " + request.getParameter("instagramLink"));
        System.out.println("IsVisible: " + request.getParameter("isVisible"));
        System.out.println("FeedId: " + request.getParameter("feedId"));
        System.out.println("DisplayOrder: " + request.getParameter("displayOrder"));
        System.out.println("===============================");
        
        try {
            switch (action) {
                case "add":
                    handleAddFeed(request, instagramFeedDAO);
                    session.setAttribute("successMessage", "Instagram feed added successfully!");
                    break;
                    
                case "update":
                    handleUpdateFeed(request, instagramFeedDAO);
                    session.setAttribute("successMessage", "Instagram feed updated successfully!");
                    break;
                    
                case "delete":
                    handleDeleteFeed(request, instagramFeedDAO);
                    session.setAttribute("successMessage", "Instagram feed deleted successfully!");
                    break;
                    
                case "toggle-visibility":
                    handleToggleVisibility(request, instagramFeedDAO);
                    session.setAttribute("successMessage", "Visibility status updated successfully!");
                    break;
                    
                case "update-order":
                    handleUpdateOrder(request, instagramFeedDAO);
                    session.setAttribute("successMessage", "Display order updated successfully!");
                    break;
                    
                default:
                    System.out.println("Invalid action: " + action);
                    throw new ServletException("Invalid action parameter: " + action);
            }
        } catch (Exception e) {
            System.out.println("Error in Instagram Manager: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/instagram-manager");
    }
    
    private void handleAddFeed(HttpServletRequest request, InstagramFeedDAO dao) throws SQLException {
        String isVisibleParam = request.getParameter("isVisible");
        boolean isVisible = "on".equals(isVisibleParam) || "true".equals(isVisibleParam);
        
        InstagramFeedDTO feed = InstagramFeedDTO.builder()
                .ImageUrl(request.getParameter("imageUrl"))
                .InstagramLink(request.getParameter("instagramLink"))
                .IsVisible(isVisible)
                .build();
        
        if (!dao.addFeed(feed)) {
            throw new SQLException("Failed to add Instagram feed");
        }
    }
    
    private void handleUpdateFeed(HttpServletRequest request, InstagramFeedDAO dao) throws SQLException {
        String isVisibleParam = request.getParameter("isVisible");
        boolean isVisible = "on".equals(isVisibleParam) || "true".equals(isVisibleParam);
        
        InstagramFeedDTO feed = InstagramFeedDTO.builder()
                .FeedID(Integer.parseInt(request.getParameter("feedId")))
                .ImageUrl(request.getParameter("imageUrl"))
                .InstagramLink(request.getParameter("instagramLink"))
                .DisplayOrder(Integer.parseInt(request.getParameter("displayOrder")))
                .IsVisible(isVisible)
                .build();
        
        if (!dao.updateFeed(feed)) {
            throw new SQLException("Failed to update Instagram feed");
        }
    }
    
    private void handleDeleteFeed(HttpServletRequest request, InstagramFeedDAO dao) throws SQLException {
        int feedId = Integer.parseInt(request.getParameter("feedId"));
        if (!dao.deleteFeed(feedId)) {
            throw new SQLException("Failed to delete Instagram feed");
        }
    }
    
    private void handleToggleVisibility(HttpServletRequest request, InstagramFeedDAO dao) throws SQLException {
        int feedId = Integer.parseInt(request.getParameter("feedId"));
        if (!dao.toggleVisibility(feedId)) {
            throw new SQLException("Failed to toggle visibility");
        }
    }
    
    private void handleUpdateOrder(HttpServletRequest request, InstagramFeedDAO dao) throws SQLException {
        int feedId = Integer.parseInt(request.getParameter("feedId"));
        int newOrder = Integer.parseInt(request.getParameter("newOrder"));
        if (!dao.updateDisplayOrder(feedId, newOrder)) {
            throw new SQLException("Failed to update display order");
        }
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
