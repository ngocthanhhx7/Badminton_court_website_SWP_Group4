package controller.user;

import dao.PartnerSearchDAO;
import models.PartnerSearchPostDTO;
import models.PartnerSearchResponseDTO;
import models.UserDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.util.List;

@WebServlet(name = "PartnerSearchController", urlPatterns = {"/partner-search"})
public class PartnerSearchController extends HttpServlet {

    private PartnerSearchDAO partnerSearchDAO = new PartnerSearchDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "list":
                    showPartnerSearchList(request, response);
                    break;
                case "detail":
                    showPostDetail(request, response);
                    break;
                case "create":
                    showCreateForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "my-posts":
                    showMyPosts(request, response);
                    break;
                case "search":
                    searchPosts(request, response);
                    break;
                default:
                    showPartnerSearchList(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect("partner-search");
            return;
        }

        try {
            switch (action) {
                case "create":
                    createPost(request, response);
                    break;
                case "update":
                    updatePost(request, response);
                    break;
                case "respond":
                    respondToPost(request, response);
                    break;
                case "close":
                    closePost(request, response);
                    break;
                case "activate":
                    activatePost(request, response);
                    break;
                case "deactivate":
                    deactivatePost(request, response);
                    break;
                case "delete":
                    deletePost(request, response);
                    break;
                default:
                    response.sendRedirect("partner-search");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    private void showPartnerSearchList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<PartnerSearchPostDTO> posts = partnerSearchDAO.getAllActivePosts();
        request.setAttribute("partnerPosts", posts);
        request.getRequestDispatcher("partner-search-list.jsp").forward(request, response);
    }

    private void searchPosts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String location = request.getParameter("location");
        String skillLevel = request.getParameter("skillLevel");
        String playStyle = request.getParameter("playStyle");
        String maxDistanceStr = request.getParameter("maxDistance");
        
        Integer maxDistance = null;
        if (maxDistanceStr != null && !maxDistanceStr.trim().isEmpty()) {
            try {
                maxDistance = Integer.parseInt(maxDistanceStr);
            } catch (NumberFormatException e) {
                // Ignore invalid distance
            }
        }

        List<PartnerSearchPostDTO> posts = partnerSearchDAO.searchPosts(location, skillLevel, playStyle, maxDistance);
        request.setAttribute("partnerPosts", posts);
        request.setAttribute("searchLocation", location);
        request.setAttribute("searchSkillLevel", skillLevel);
        request.setAttribute("searchPlayStyle", playStyle);
        request.setAttribute("searchMaxDistance", maxDistanceStr);
        request.getRequestDispatcher("partner-search-list.jsp").forward(request, response);
    }

    private void showPostDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String postIdStr = request.getParameter("id");
        if (postIdStr == null) {
            response.sendRedirect("partner-search");
            return;
        }

        try {
            int postId = Integer.parseInt(postIdStr);
            PartnerSearchPostDTO post = partnerSearchDAO.getPostById(postId);
            if (post == null) {
                response.sendRedirect("partner-search");
                return;
            }
            // Increment view count
            partnerSearchDAO.incrementViewCount(postId);
            // Luôn lấy responses cho mọi user
            List<PartnerSearchResponseDTO> responses = partnerSearchDAO.getResponsesByPost(postId);
            request.setAttribute("responses", responses);
            // Kiểm tra quyền owner
            HttpSession session = request.getSession();
            UserDTO currentUser = (UserDTO) session.getAttribute("acc");
            boolean isOwner = (currentUser != null && currentUser.getUserID() == post.getUserID());
            request.setAttribute("isOwner", isOwner);
            request.setAttribute("post", post);
            request.getRequestDispatcher("partner-search-detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect("partner-search");
        }
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("acc");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        request.getRequestDispatcher("partner-search-create.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String postIdStr = request.getParameter("id");
        if (postIdStr == null) {
            response.sendRedirect("partner-search");
            return;
        }

        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("acc");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int postId = Integer.parseInt(postIdStr);
            PartnerSearchPostDTO post = partnerSearchDAO.getPostById(postId);
            
            if (post == null || post.getUserID() != user.getUserID()) {
                response.sendRedirect("partner-search");
                return;
            }

            request.setAttribute("post", post);
            request.getRequestDispatcher("partner-search-edit.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect("partner-search");
        }
    }

    private void showMyPosts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("acc");
        
        // Temporary: Use test user if not logged in
        if (user == null) {
            // Create a test user for debugging
            user = new UserDTO();
            user.setUserID(1); // Use existing user ID
            user.setFullName("Test User");
        }

        try {
            List<PartnerSearchPostDTO> posts = partnerSearchDAO.getPostsByUser(user.getUserID());
            request.setAttribute("myPosts", posts);
            request.getRequestDispatcher("partner-search-my-posts.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading posts: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    private void createPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("acc");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            PartnerSearchPostDTO post = new PartnerSearchPostDTO();
            post.setUserID(user.getUserID());
            post.setTitle(request.getParameter("title"));
            post.setDescription(request.getParameter("description"));
            post.setPreferredLocation(request.getParameter("preferredLocation"));
            
            String maxDistanceStr = request.getParameter("maxDistance");
            if (maxDistanceStr != null && !maxDistanceStr.trim().isEmpty()) {
                post.setMaxDistance(Integer.parseInt(maxDistanceStr));
            }
            
            String preferredDateTimeStr = request.getParameter("preferredDateTime");
            if (preferredDateTimeStr != null && !preferredDateTimeStr.trim().isEmpty()) {
                post.setPreferredDateTime(LocalDateTime.parse(preferredDateTimeStr));
            }
            
            post.setSkillLevel(request.getParameter("skillLevel"));
            post.setPlayStyle(request.getParameter("playStyle"));
            post.setContactMethod(request.getParameter("contactMethod"));
            post.setContactInfo(request.getParameter("contactInfo"));
            
            // Set expiration to 30 days from now by default
            post.setExpiresAt(LocalDateTime.now().plusDays(30));

            if (partnerSearchDAO.createPost(post)) {
                response.sendRedirect("partner-search?action=my-posts&success=created");
            } else {
                request.setAttribute("error", "Failed to create post. Please try again.");
                request.getRequestDispatcher("partner-search-create.jsp").forward(request, response);
            }
            
        } catch (DateTimeParseException | NumberFormatException e) {
            request.setAttribute("error", "Invalid date/time or number format. Please check your input.");
            request.getRequestDispatcher("partner-search-create.jsp").forward(request, response);
        }
    }

    private void updatePost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("acc");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int postId = Integer.parseInt(request.getParameter("postId"));
            PartnerSearchPostDTO existingPost = partnerSearchDAO.getPostById(postId);
            
            if (existingPost == null || existingPost.getUserID() != user.getUserID()) {
                response.sendRedirect("partner-search");
                return;
            }

            existingPost.setTitle(request.getParameter("title"));
            existingPost.setDescription(request.getParameter("description"));
            existingPost.setPreferredLocation(request.getParameter("preferredLocation"));
            
            String maxDistanceStr = request.getParameter("maxDistance");
            if (maxDistanceStr != null && !maxDistanceStr.trim().isEmpty()) {
                existingPost.setMaxDistance(Integer.parseInt(maxDistanceStr));
            } else {
                existingPost.setMaxDistance(null);
            }
            
            String preferredDateTimeStr = request.getParameter("preferredDateTime");
            if (preferredDateTimeStr != null && !preferredDateTimeStr.trim().isEmpty()) {
                existingPost.setPreferredDateTime(LocalDateTime.parse(preferredDateTimeStr));
            } else {
                existingPost.setPreferredDateTime(null);
            }
            
            existingPost.setSkillLevel(request.getParameter("skillLevel"));
            existingPost.setPlayStyle(request.getParameter("playStyle"));
            existingPost.setContactMethod(request.getParameter("contactMethod"));
            existingPost.setContactInfo(request.getParameter("contactInfo"));

            if (partnerSearchDAO.updatePost(existingPost)) {
                response.sendRedirect("partner-search?action=detail&id=" + postId + "&success=updated");
            } else {
                request.setAttribute("error", "Failed to update post. Please try again.");
                request.setAttribute("post", existingPost);
                request.getRequestDispatcher("partner-search-edit.jsp").forward(request, response);
            }
            
        } catch (DateTimeParseException | NumberFormatException e) {
            request.setAttribute("error", "Invalid date/time or number format. Please check your input.");
            request.getRequestDispatcher("partner-search-edit.jsp").forward(request, response);
        }
    }

    private void respondToPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("acc");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int postId = Integer.parseInt(request.getParameter("postId"));
            String message = request.getParameter("message");

            PartnerSearchResponseDTO responseDTO = new PartnerSearchResponseDTO();
            responseDTO.setPostID(postId);
            responseDTO.setResponderID(user.getUserID());
            responseDTO.setMessage(message);

            if (partnerSearchDAO.addResponse(responseDTO)) {
                response.sendRedirect("partner-search?action=detail&id=" + postId + "&success=responded");
            } else {
                request.setAttribute("error", "Failed to send response. Please try again.");
                response.sendRedirect("partner-search?action=detail&id=" + postId + "&error=response_failed");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect("partner-search");
        }
    }

    private void closePost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("acc");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int postId = Integer.parseInt(request.getParameter("postId"));
            PartnerSearchPostDTO post = partnerSearchDAO.getPostById(postId);
            
            if (post == null || post.getUserID() != user.getUserID()) {
                response.sendRedirect("partner-search");
                return;
            }

            post.setStatus("Closed");
            
            if (partnerSearchDAO.updatePost(post)) {
                response.sendRedirect("partner-search?action=my-posts&success=closed");
            } else {
                response.sendRedirect("partner-search?action=detail&id=" + postId + "&error=close_failed");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect("partner-search");
        }
    }

    private void activatePost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("acc");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int postId = Integer.parseInt(request.getParameter("id"));
            
            if (partnerSearchDAO.updatePostStatus(postId, "Active", user.getUserID())) {
                response.sendRedirect("partner-search?action=my-posts&success=activated");
            } else {
                response.sendRedirect("partner-search?action=my-posts&error=activation_failed");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect("partner-search?action=my-posts");
        }
    }

    private void deactivatePost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("acc");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int postId = Integer.parseInt(request.getParameter("id"));
            
            if (partnerSearchDAO.updatePostStatus(postId, "Inactive", user.getUserID())) {
                response.sendRedirect("partner-search?action=my-posts&success=deactivated");
            } else {
                response.sendRedirect("partner-search?action=my-posts&error=deactivation_failed");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect("partner-search?action=my-posts");
        }
    }

    private void deletePost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("acc");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int postId = Integer.parseInt(request.getParameter("id"));
            
            if (partnerSearchDAO.deletePost(postId, user.getUserID())) {
                response.sendRedirect("partner-search?action=my-posts&success=deleted");
            } else {
                response.sendRedirect("partner-search?action=my-posts&error=deletion_failed");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect("partner-search?action=my-posts");
        }
    }
}