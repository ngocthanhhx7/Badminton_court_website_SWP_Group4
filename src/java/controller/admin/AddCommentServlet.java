package controller.admin;

import dal.BlogCommentDAO;
import models.BlogCommentDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.Arrays;
import java.util.List;

@WebServlet("/add-comment")
public class AddCommentServlet extends HttpServlet {

    private static final List<String> BANNED_WORDS = Arrays.asList("dcm", "clm", "cmm");

    private boolean containsBannedWords(String content) {
        if (content == null) return false;
        String normalized = content.toLowerCase().replaceAll("[^a-z]", "");
        for (String word : BANNED_WORDS) {
            if (normalized.contains(word)) return true;
        }
        return false;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Integer userID = (Integer) session.getAttribute("userID");
        String role = (String) session.getAttribute("role"); // "user" hoặc "staff"

        if (userID == null || role == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        String content = request.getParameter("content");
        String postIDStr = request.getParameter("postID");
        String parentStr = request.getParameter("parentID");

        int postID;
        try {
            postID = Integer.parseInt(postIDStr);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "⚠️ Bài viết không hợp lệ.");
            request.getRequestDispatcher("blog.jsp").forward(request, response);
            return;
        }

        Integer parentCommentID = null;
        try {
            if (parentStr != null && !parentStr.trim().isEmpty()) {
                parentCommentID = Integer.parseInt(parentStr);
            }
        } catch (NumberFormatException e) {
            parentCommentID = null;
        }

        // Kiểm tra từ cấm
        if (containsBannedWords(content)) {
            request.setAttribute("error", "❌ Bình luận chứa từ ngữ không phù hợp.");
            request.setAttribute("scrollToPostID", postID);

            if ("staff".equalsIgnoreCase(role)) {
                request.getRequestDispatcher("dashboard.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("blog.jsp").forward(request, response);
            }
            return;
        }

        // Tạo comment
        BlogCommentDTO comment = new BlogCommentDTO(postID, userID, content, parentCommentID);
        comment.setCreatedAt(new Timestamp(System.currentTimeMillis()));

        try {
            new BlogCommentDAO().insert(comment);

            // ✅ Điều hướng dựa theo role
            if ("staff".equalsIgnoreCase(role)) {
                response.sendRedirect("dashboard.jsp");
            } else {
                response.sendRedirect("blog.jsp#post" + postID);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "⚠️ Không thể gửi bình luận.");
            request.setAttribute("scrollToPostID", postID);

            if ("staff".equalsIgnoreCase(role)) {
                request.getRequestDispatcher("dashboard.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("blog.jsp").forward(request, response);
            }
        }
    }
}
