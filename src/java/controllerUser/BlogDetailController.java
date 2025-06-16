package controllerUser;

import dao.BlogCommentDAO;
import dao.BlogPostDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import models.BlogCommentDTO;
import models.BlogPostDTO;

@WebServlet(name = "BlogDetailController", urlPatterns = {"/single-blog"})
public class BlogDetailController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet Blog Detail</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet Blog Detail at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check login by accType
        Object accType = request.getSession().getAttribute("accType");
        String postIdParam = request.getParameter("postId");
        String idParam = request.getParameter("id");
        String redirectParam = (postIdParam != null && !postIdParam.isEmpty()) ? ("postId=" + postIdParam) : (idParam != null && !idParam.isEmpty() ? ("id=" + idParam) : "");
        if (accType == null) {
            response.sendRedirect("Login?redirect=single-blog" + (redirectParam.isEmpty() ? "" : ("&" + redirectParam)));
            return;
        }
        try {
            String postIdStr = request.getParameter("postId");
            if (postIdStr == null || postIdStr.trim().isEmpty()) {
                postIdStr = request.getParameter("id");
            }
            if (postIdStr == null || postIdStr.trim().isEmpty()) {
                response.sendRedirect("blog");
                return;
            }
            int postId = Integer.parseInt(postIdStr);
            BlogPostDAO blogPostDAO = new BlogPostDAO();
            BlogCommentDAO blogCommentDAO = new BlogCommentDAO();
            BlogPostDTO post = blogPostDAO.getPostById(postId);
            if (post == null) {
                request.setAttribute("error", "Không tìm thấy bài viết");
                request.getRequestDispatcher("blog").forward(request, response);
                return;
            }
            // Get userId from session (if any)
            HttpSession session = request.getSession(false);
            int userId = session != null && session.getAttribute("userID") != null
                    ? (int) session.getAttribute("userID")
                    : -1;
            blogPostDAO.incrementViewCount(postId);
            List<BlogCommentDTO> comments = blogCommentDAO.getCommentsByPost(postId);
            List<BlogPostDTO> similarPosts = blogPostDAO.getSimilarPosts(postId, 3);
            request.setAttribute("post", post);
            request.setAttribute("comments", comments);
            request.setAttribute("userId", userId);
            request.setAttribute("similarPosts", similarPosts);
            request.getRequestDispatcher("single-blog.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect("blog");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("blog");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        BlogCommentDAO commentDAO = new BlogCommentDAO();

        int postId = Integer.parseInt(request.getParameter("postId"));
        int userId = (int) request.getSession().getAttribute("userID");

        String content = request.getParameter("content");
        String action = request.getParameter("action"); // "create", "update", "delete"

        if ("update".equals(action)) {
            int commentId = Integer.parseInt(request.getParameter("commentId"));
            BlogCommentDTO comment = commentDAO.getCommentById(commentId);
            if (comment != null && comment.getUserID() == userId) {
                comment.setContent(content);
                commentDAO.updateComment(comment);
            }
        } else if ("delete".equals(action)) {
            int commentId = Integer.parseInt(request.getParameter("commentId"));
            BlogCommentDTO comment = commentDAO.getCommentById(commentId);
            if (comment != null && comment.getUserID() == userId) {
                commentDAO.deleteReplies(commentId); // nếu có reply
                commentDAO.deleteComment(commentId);
            }
        } else {
            // default = create
            BlogCommentDTO comment = BlogCommentDTO.builder()
                    .PostID(postId)
                    .UserID(userId)
                    .Content(content)
                    .CreatedAt(new java.sql.Timestamp(System.currentTimeMillis()))
                    .ParentCommentID(null)
                    .build();
            commentDAO.createComment(comment);
        }

        response.sendRedirect("single-blog?postId=" + postId);
    }

    @Override
    public String getServletInfo() {
        return "Blog Detail Controller";
    }
}
