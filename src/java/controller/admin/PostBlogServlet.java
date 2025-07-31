package controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.nio.file.*;
import dal.BlogPostDAO;
import models.BlogPostDTO;

@WebServlet("/post-blog")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 5 * 1024 * 1024,
    maxRequestSize = 10 * 1024 * 1024
)
public class PostBlogServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String title = request.getParameter("title");
        String slug = request.getParameter("slug");
        String summary = request.getParameter("summary");
        String content = request.getParameter("content");
String status = "published"; // ✅ Mặc định là 'published'

        int authorID = (int) request.getSession().getAttribute("userID");

        BlogPostDAO dao = new BlogPostDAO();

        // Kiểm tra slug trùng
        if (dao.isSlugTaken(slug)) {
            request.setAttribute("error", "Slug đã tồn tại. Vui lòng chọn slug khác.");
            request.getRequestDispatcher("new-post.jsp").forward(request, response);
            return;
        }

        // Xử lý file ảnh
        String uploadPath = getServletContext().getRealPath("/img/blog");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        Part filePart = request.getPart("thumbnailFile");
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

        if (fileName == null || fileName.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng chọn ảnh đại diện cho bài viết.");
            request.getRequestDispatcher("new-post.jsp").forward(request, response);
            return;
        }

        // Ghi file ảnh vào thư mục
        filePart.write(uploadPath + File.separator + fileName);
        String thumbnailUrl = "img/blog/" + fileName;

        try {
            // ✅ Sử dụng constructor có status
            BlogPostDTO post = new BlogPostDTO(title, slug, content, summary, thumbnailUrl, authorID, status);
            dao.insert(post);
            response.sendRedirect("blog-management.jsp");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
