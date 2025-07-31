package controller.admin;

import dal.BlogPostDAO;
import models.BlogPostDTO;
import jakarta.servlet.annotation.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

import java.io.*;
import java.nio.file.*;

@WebServlet("/update-post")
@MultipartConfig
public class UpdatePostServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        try {
            int postID = Integer.parseInt(request.getParameter("postID"));
            String title = request.getParameter("title");
            String slug = request.getParameter("slug");
            String summary = request.getParameter("summary");
            String content = request.getParameter("content");
            String status = request.getParameter("status");

            BlogPostDAO dao = new BlogPostDAO();
            String thumbnailUrl;

            // Upload path
            String uploadPath = getServletContext().getRealPath("/img/blog");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            Part filePart = request.getPart("thumbnailFile");
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

            if (fileName != null && !fileName.trim().isEmpty()) {
                // Save new thumbnail
                filePart.write(uploadPath + File.separator + fileName);
                thumbnailUrl = "img/blog/" + fileName;
            } else {
                // Use old thumbnail if not updated
                thumbnailUrl = dao.getById(postID).getThumbnailUrl();
            }

            // Update post
            BlogPostDTO updatedPost = new BlogPostDTO(postID, title, slug, content, summary, thumbnailUrl, status);
            dao.update(updatedPost);

            response.sendRedirect("blog-management.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "❌ Lỗi khi cập nhật bài viết: " + e.getMessage());
            request.getRequestDispatcher("edit-post.jsp?id=" + request.getParameter("postID"))
                    .forward(request, response);
        }
    }
}
