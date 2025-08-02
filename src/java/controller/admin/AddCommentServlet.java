package controller.admin;

import dao.BlogCommentDAO;
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

    // Kiểm tra nội dung có từ bị cấm không
    private boolean containsBannedWords(String content) {
        if (content == null) return false;
        String[] words = content.toLowerCase().split("\\s+");
        for (String word : words) {
            if (BANNED_WORDS.contains(word)) return true;
        }
        return false;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Integer userID = (Integer) session.getAttribute("userID");
        if (userID == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String content = request.getParameter("content");
        String postIDStr = request.getParameter("postID");
        String parentStr = request.getParameter("parentID");

        int postID;
        try {
            postID = Integer.parseInt(postIDStr);
        } catch (NumberFormatException e) {
            response.sendRedirect("post-detail.jsp?postID=" + postIDStr + "&error=invalidPost");
            return;
        }

        Integer parentCommentID = null;
        try {
            if (parentStr != null && !parentStr.trim().isEmpty()) {
                parentCommentID = Integer.parseInt(parentStr);
            }
        } catch (NumberFormatException ignored) {
        }

        // Kiểm tra từ ngữ không phù hợp
        if (containsBannedWords(content)) {
            session.setAttribute("error", "❌ Bình luận chứa từ ngữ không phù hợp.");
            response.sendRedirect("post-detail.jsp?postID=" + postID);
            return;
        }

        // Tạo đối tượng bình luận
        BlogCommentDTO comment = new BlogCommentDTO(postID, userID, content, parentCommentID);
        comment.setCreatedAt(new Timestamp(System.currentTimeMillis()));

        try {
            new BlogCommentDAO().insert(comment);
            response.sendRedirect("post-detail.jsp?postID=" + postID);
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "⚠️ Đã xảy ra lỗi khi gửi bình luận.");
            response.sendRedirect("post-detail.jsp?postID=" + postID);
        }
    }
}
