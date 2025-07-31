package controller.admin;

import dal.VideoDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.List;
import models.VideoDTO;
import utils.AccessControlUtil;

@WebServlet(name="VideoManagerController", urlPatterns={"/video-manager"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 1024 * 1024 * 5,   // 5 MB
    maxRequestSize = 1024 * 1024 * 10 // 10 MB
)
public class VideoManagerController extends HttpServlet {
    private static final int DEFAULT_PAGE_SIZE = 10;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet VideoManagerController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet VideoManagerController at " + request.getContextPath () + "</h1>");
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
            // Get parameters
            String searchKeyword = request.getParameter("search");
            String featuredParam = request.getParameter("featured");
            String pageParam = request.getParameter("page");
            
            int page = pageParam != null ? Integer.parseInt(pageParam) : 1;
            Boolean isFeatured = featuredParam != null ? Boolean.parseBoolean(featuredParam) : null;
            
            VideoDAO videoDAO = new VideoDAO();
            List<VideoDTO> videos = videoDAO.getAllVideos(page, DEFAULT_PAGE_SIZE, searchKeyword, isFeatured);
            int totalVideos = videoDAO.getTotalVideos(searchKeyword, isFeatured);
            int totalPages = (int) Math.ceil((double) totalVideos / DEFAULT_PAGE_SIZE);
            
            // Set attributes
            request.setAttribute("videos", videos);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("search", searchKeyword);
            request.setAttribute("featured", featuredParam);
            
            // Forward to JSP
            request.getRequestDispatcher("video-manager.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred: " + e.getMessage());
        }
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        // Kiểm tra phân quyền
        if (!AccessControlUtil.hasManagerAccess(request)) {
            response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        VideoDAO videoDAO = new VideoDAO();
        
        try {
            switch (action) {
                case "add":
                    handleAddVideo(request, videoDAO);
                    session.setAttribute("successMessage", "Video added successfully!");
                    break;
                    
                case "update":
                    handleUpdateVideo(request, videoDAO);
                    session.setAttribute("successMessage", "Video updated successfully!");
                    break;
                    
                case "delete":
                    handleDeleteVideo(request, videoDAO);
                    session.setAttribute("successMessage", "Video deleted successfully!");
                    break;
                    
                case "toggle-featured":
                    handleToggleFeatured(request, videoDAO);
                    session.setAttribute("successMessage", "Video featured status updated!");
                    break;
                    
                default:
                    throw new ServletException("Invalid action parameter");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/video-manager");
    }
    
    private void handleAddVideo(HttpServletRequest request, VideoDAO videoDAO) throws SQLException {
        VideoDTO video = VideoDTO.builder()
                .Title(request.getParameter("title"))
                .Subtitle(request.getParameter("subtitle"))
                .VideoUrl(request.getParameter("videoUrl"))
                .ThumbnailUrl(request.getParameter("thumbnailUrl"))
                .IsFeatured(Boolean.parseBoolean(request.getParameter("isFeatured")))
                .build();
        
        if (!videoDAO.addVideo(video)) {
            throw new SQLException("Failed to add video");
        }
    }
    
    private void handleUpdateVideo(HttpServletRequest request, VideoDAO videoDAO) throws SQLException {
        VideoDTO video = VideoDTO.builder()
                .VideoID(Integer.parseInt(request.getParameter("videoId")))
                .Title(request.getParameter("title"))
                .Subtitle(request.getParameter("subtitle"))
                .VideoUrl(request.getParameter("videoUrl"))
                .ThumbnailUrl(request.getParameter("thumbnailUrl"))
                .IsFeatured(Boolean.parseBoolean(request.getParameter("isFeatured")))
                .build();
        
        if (!videoDAO.updateVideo(video)) {
            throw new SQLException("Failed to update video");
        }
    }
    
    private void handleDeleteVideo(HttpServletRequest request, VideoDAO videoDAO) throws SQLException {
        int videoId = Integer.parseInt(request.getParameter("videoId"));
        if (!videoDAO.deleteVideo(videoId)) {
            throw new SQLException("Failed to delete video");
        }
    }
    
    private void handleToggleFeatured(HttpServletRequest request, VideoDAO videoDAO) throws SQLException {
        int videoId = Integer.parseInt(request.getParameter("videoId"));
        if (!videoDAO.toggleFeatured(videoId)) {
            throw new SQLException("Failed to toggle featured status");
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
