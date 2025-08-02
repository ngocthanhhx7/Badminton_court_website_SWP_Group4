<%@ page import="java.util.*, models.BlogPostDTO, dao.BlogPostDAO" %>
<%@ page import="dao.BlogCommentDAO, models.BlogCommentDTO" %>
<%@ page import="utils.CommentUtils" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
    Integer userID = (Integer) session.getAttribute("userID");
    String accType = (String) session.getAttribute("accType");

    String idParam = request.getParameter("postID");
    if (idParam == null) {
        response.sendRedirect("blog.jsp");
        return;
    }

    int postID = Integer.parseInt(idParam);
    BlogPostDAO postDAO = new BlogPostDAO();
    BlogCommentDAO commentDAO = new BlogCommentDAO();

    BlogPostDTO post = postDAO.getById(postID);
    if (post == null) {
        out.println("<h2>Bài viết không tồn tại.</h2>");
        return;
    }

    Map<Integer, List<BlogCommentDTO>> commentTree = commentDAO.getCommentTree(postID);
    String nestedCommentsHtml = CommentUtils.renderComments(commentTree, 0, 0, postID);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= post.getTitle() %></title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: auto;
        }
        .title { font-size: 28px; margin-top: 20px; }
        .meta { color: gray; font-size: 13px; margin-bottom: 15px; }
        img { max-width: 100%; border-radius: 10px; }
        .content { margin: 20px 0; line-height: 1.6; }
        .comments { margin-top: 30px; }

        button {
            padding: 10px 20px;
            background-color: #0088cc;
            color: white;
            border: none;
            border-radius: 25px;
            font-weight: bold;
            font-size: 14px;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.2s ease;
            box-shadow: 0 4px 6px rgba(0, 136, 204, 0.2);
        }

        button:hover {
            background-color: #006da1;
            transform: scale(1.03);
        }

        a[href="blog.jsp"] {
            display: inline-block;
            margin-top: 30px;
            color: #0088cc;
            text-decoration: none;
            font-weight: bold;
            padding: 10px 20px;
            border: 2px solid #0088cc;
            border-radius: 25px;
            transition: all 0.3s ease;
        }

        a[href="blog.jsp"]:hover {
            background-color: #0088cc;
            color: white;
        }

        .error-message {
            color: red;
            font-weight: bold;
            margin-top: 10px;
        }
    </style>
</head>
<body>

  <body>

    <%
        String error = (String) session.getAttribute("error");
        if (error != null) {
    %>
        <div style="color: red; font-weight: bold; margin-bottom: 15px;"><%= error %></div>
    <%
            session.removeAttribute("error");
        }
    %>

    <div class="title"><%= post.getTitle() %></div>
    <div class="meta">🗓️ Ngày đăng: <%= post.getPublishedAt() %></div>
    <img src="<%= post.getThumbnailUrl() %>" alt="Thumbnail">
    <div class="content"><%= post.getContent() %></div>

    <div class="comments">
        <h4>💬 Bình luận:</h4>
        <%= nestedCommentsHtml %>

        <!-- Form bình luận -->
        <form method="post" action="add-comment">
            <input type="hidden" name="postID" value="<%= postID %>">
            <textarea name="content" required placeholder="Viết bình luận..." rows="3" style="width:100%;"></textarea>
            <br>
            <button type="submit">Gửi bình luận</button>
        </form>
    </div>

    <br><br>
    <a href="blog.jsp">⬅️ Quay lại danh sách bài viết</a>

    <script>
        function toggleComments(postID) {
            const section = document.getElementById("comments" + postID);
            section.style.display = section.style.display === "block" ? "none" : "block";
        }

        function toggleReply(commentID) {
            const block = document.getElementById("replyBlock" + commentID);
            if (block.style.display === "none" || block.style.display === "") {
                block.style.display = "block";
            } else {
                block.style.display = "none";
            }
        }
    </script>

</body>


</body>
</html>
