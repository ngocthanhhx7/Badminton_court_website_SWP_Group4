package controller.admin;

import dal.BlogPostDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/delete-post")
public class DeletePostServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        try {
            int postId = Integer.parseInt(request.getParameter("id"));
            BlogPostDAO dao = new BlogPostDAO();
            dao.delete(postId);
            response.sendRedirect("blog-management.jsp"); // hoặc trang quản lý bài viết
        } catch (Exception e) {
            throw new ServletException("Lỗi khi xóa bài viết: " + e.getMessage());
        }
    }
}

