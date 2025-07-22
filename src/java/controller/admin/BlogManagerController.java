package controller.admin;

import dao.BlogPostDAO;
import models.BlogPostDTO;
import utils.AccessControlUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;

@WebServlet(name = "BlogManagerController", urlPatterns = {"/blog-manager"})
public class BlogManagerController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!AccessControlUtil.hasManagerAccess(request)) {
            response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
            return;
        }
        String title = request.getParameter("title");
        String status = request.getParameter("status");
        String authorIdStr = request.getParameter("authorId");
        String sortBy = request.getParameter("sortBy");
        String sortOrder = request.getParameter("sortOrder");
        String pageStr = request.getParameter("page");
        String pageSizeStr = request.getParameter("pageSize");
        Integer authorId = null;
        if (authorIdStr != null && !authorIdStr.trim().isEmpty()) {
            try { authorId = Integer.parseInt(authorIdStr); } catch (NumberFormatException ignored) {}
        }
        int page = 1;
        int pageSize = 10;
        if (pageStr != null) {
            try { page = Integer.parseInt(pageStr); if (page < 1) page = 1; } catch (NumberFormatException ignored) {}
        }
        if (pageSizeStr != null) {
            try { pageSize = Integer.parseInt(pageSizeStr); if (pageSize < 1) pageSize = 10; if (pageSize > 100) pageSize = 100; } catch (NumberFormatException ignored) {}
        }
        if (sortBy == null || sortBy.trim().isEmpty()) sortBy = "PostID";
        if (sortOrder == null || sortOrder.trim().isEmpty()) sortOrder = "DESC";
        BlogPostDAO blogDAO = new BlogPostDAO();
        List<BlogPostDTO> posts = blogDAO.getBlogPostsWithFilters(title, status, authorId, sortBy, sortOrder, page, pageSize);
        int totalPosts = blogDAO.getFilteredBlogPostsCount(title, status, authorId);
        int totalPages = (int) Math.ceil((double) totalPosts / pageSize);
        request.setAttribute("posts", posts);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalPosts", totalPosts);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("title", title);
        request.setAttribute("status", status);
        request.setAttribute("authorId", authorIdStr);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("sortOrder", sortOrder);
        int startRecord = (page - 1) * pageSize + 1;
        int endRecord = Math.min(page * pageSize, totalPosts);
        request.setAttribute("startRecord", startRecord);
        request.setAttribute("endRecord", endRecord);
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
        request.getRequestDispatcher("blog-manager.jsp").forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!AccessControlUtil.hasManagerAccess(request)) {
            response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
            return;
        }
        String action = request.getParameter("action");
        BlogPostDAO blogDAO = new BlogPostDAO();
        HttpSession session = request.getSession();
        try {
            switch (action) {
                case "add":
                    handleAddPost(request, session, blogDAO);
                    break;
                case "edit":
                    handleEditPost(request, session, blogDAO);
                    break;
                case "delete":
                    handleDeletePost(request, session, blogDAO);
                    break;
                case "toggleStatus":
                    handleToggleStatus(request, session, blogDAO);
                    break;
                default:
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage());
        }
        response.sendRedirect("blog-manager");
    }
    private static final String[] VALID_STATUSES = {"Published", "Draft", "Archived"};
    private boolean isValidStatus(String status) {
        if (status == null) return false;
        for (String s : VALID_STATUSES) {
            if (s.equalsIgnoreCase(status)) return true;
        }
        return false;
    }
    private void handleAddPost(HttpServletRequest request, HttpSession session, BlogPostDAO blogDAO) {
        try {
            String title = request.getParameter("title");
            String slug = request.getParameter("slug");
            String content = request.getParameter("content");
            String summary = request.getParameter("summary");
            String thumbnailUrl = request.getParameter("thumbnailUrl");
            String publishedAtStr = request.getParameter("publishedAt");
            String status = request.getParameter("status");
            int authorId = Integer.parseInt(request.getParameter("authorId"));
            if (!isValidStatus(status)) {
                session.setAttribute("errorMessage", "Trạng thái không hợp lệ!");
                return;
            }
            Timestamp publishedAt = publishedAtStr != null && !publishedAtStr.isEmpty() ? Timestamp.valueOf(publishedAtStr + ":00") : null;
            BlogPostDTO post = BlogPostDTO.builder()
                    .Title(title)
                    .Slug(slug)
                    .Content(content)
                    .Summary(summary)
                    .ThumbnailUrl(thumbnailUrl)
                    .PublishedAt(publishedAt)
                    .AuthorID(authorId)
                    .ViewCount(0)
                    .Status(status)
                    .build();
            boolean success = blogDAO.addBlogPost(post);
            if (success) session.setAttribute("successMessage", "Thêm bài viết thành công!");
            else session.setAttribute("errorMessage", "Thêm bài viết thất bại!");
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Dữ liệu không hợp lệ!");
        }
    }
    private void handleEditPost(HttpServletRequest request, HttpSession session, BlogPostDAO blogDAO) {
        try {
            int postId = Integer.parseInt(request.getParameter("postId"));
            String title = request.getParameter("title");
            String slug = request.getParameter("slug");
            String content = request.getParameter("content");
            String summary = request.getParameter("summary");
            String thumbnailUrl = request.getParameter("thumbnailUrl");
            String publishedAtStr = request.getParameter("publishedAt");
            String status = request.getParameter("status");
            int authorId = Integer.parseInt(request.getParameter("authorId"));
            if (!isValidStatus(status)) {
                session.setAttribute("errorMessage", "Trạng thái không hợp lệ!");
                return;
            }
            Timestamp publishedAt = publishedAtStr != null && !publishedAtStr.isEmpty() ? Timestamp.valueOf(publishedAtStr + ":00") : null;
            BlogPostDTO post = BlogPostDTO.builder()
                    .PostID(postId)
                    .Title(title)
                    .Slug(slug)
                    .Content(content)
                    .Summary(summary)
                    .ThumbnailUrl(thumbnailUrl)
                    .PublishedAt(publishedAt)
                    .AuthorID(authorId)
                    .ViewCount(0)
                    .Status(status)
                    .build();
            boolean success = blogDAO.updateBlogPost(post);
            if (success) session.setAttribute("successMessage", "Cập nhật bài viết thành công!");
            else session.setAttribute("errorMessage", "Cập nhật bài viết thất bại!");
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Dữ liệu không hợp lệ!");
        }
    }
    private void handleDeletePost(HttpServletRequest request, HttpSession session, BlogPostDAO blogDAO) {
        try {
            int postId = Integer.parseInt(request.getParameter("postId"));
            boolean success = blogDAO.deleteBlogPost(postId);
            if (success) session.setAttribute("successMessage", "Xóa bài viết thành công!");
            else session.setAttribute("errorMessage", "Xóa bài viết thất bại!");
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Dữ liệu không hợp lệ!");
        }
    }
    private void handleToggleStatus(HttpServletRequest request, HttpSession session, BlogPostDAO blogDAO) {
        try {
            int postId = Integer.parseInt(request.getParameter("postId"));
            String newStatus = request.getParameter("newStatus");
            if (!isValidStatus(newStatus)) {
                session.setAttribute("errorMessage", "Trạng thái mới không hợp lệ!");
                return;
            }
            boolean success = blogDAO.updateBlogPostStatus(postId, newStatus);
            if (success) session.setAttribute("successMessage", "Cập nhật trạng thái thành công!");
            else session.setAttribute("errorMessage", "Cập nhật trạng thái thất bại!");
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Dữ liệu không hợp lệ!");
        }
    }
} 