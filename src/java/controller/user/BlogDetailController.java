package controller.user;

import dao.BlogPostDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import models.BlogPostDTO;

@WebServlet(name = "BlogDetailController", urlPatterns = {"/single-blog"})
public class BlogDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            // Get post ID from parameters
            String postIdStr = request.getParameter("postId");
            if (postIdStr == null || postIdStr.trim().isEmpty()) {
                postIdStr = request.getParameter("id");
            }
            
            // Validate post ID
            if (postIdStr == null || postIdStr.trim().isEmpty()) {
                request.setAttribute("error", "Không tìm thấy ID bài viết");
                request.getRequestDispatcher("blog").forward(request, response);
                return;
            }
            
            int postId;
            try {
                postId = Integer.parseInt(postIdStr);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "ID bài viết không hợp lệ");
                request.getRequestDispatcher("blog").forward(request, response);
                return;
            }
            
            // Get blog post
            BlogPostDAO blogPostDAO = new BlogPostDAO();
            BlogPostDTO post = blogPostDAO.getPostById(postId);
            
            if (post == null) {
                request.setAttribute("error", "Không tìm thấy bài viết với ID: " + postId);
                request.getRequestDispatcher("blog").forward(request, response);
                return;
            }
            
            // Increment view count
            blogPostDAO.incrementViewCount(postId);
            
            // Get previous and next posts
            BlogPostDTO previousPost = blogPostDAO.getPreviousPost(postId);
            BlogPostDTO nextPost = blogPostDAO.getNextPost(postId);
            
            // Set attributes for JSP
            request.setAttribute("post", post);
            request.setAttribute("previousPost", previousPost);
            request.setAttribute("nextPost", nextPost);
            
            // Forward to JSP
            request.getRequestDispatcher("single-blog.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("blog").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect to GET method for any POST requests
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Blog Detail Controller";
    }
}
