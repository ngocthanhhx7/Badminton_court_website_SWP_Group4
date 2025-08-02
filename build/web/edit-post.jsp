<%-- 
    Document   : edit-post
    Created on : Jun 18, 2025, 8:26:53 PM
    Author     : HP
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="models.BlogPostDTO, dao.BlogPostDAO" %>
<%
    int postID = Integer.parseInt(request.getParameter("id"));
    BlogPostDTO post = new BlogPostDAO().getById(postID);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Sửa bài viết</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(to right, #e6f2ff, #ffffff);
            margin: 0;
            padding: 0;
            color: #333;
        }

        .banner {
            background: linear-gradient(120deg, #0d47a1, #1976d2);
            color: white;
            padding: 30px 20px;
            text-align: center;
            background-image: url('https://cdn.pixabay.com/photo/2017/02/02/15/15/badminton-2032096_960_720.jpg');
            background-size: cover;
            background-position: center;
            position: relative;
        }

        .banner::before {
            content: "";
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(0, 0, 0, 0.5);
        }

        .banner h1 {
            position: relative;
            font-size: 36px;
            margin: 0;
            z-index: 1;
        }

        .banner p {
            position: relative;
            font-size: 18px;
            margin-top: 10px;
            z-index: 1;
        }

        h2 {
            text-align: center;
            color: #0b5394;
            text-transform: uppercase;
            margin: 30px 0 10px;
        }

        form {
            max-width: 600px;
            margin: 0 auto;
            background: #ffffff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 10px 20px rgba(0, 128, 255, 0.1);
            border-left: 10px solid #1d73be;
            animation: slideIn 0.5s ease-out;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateX(-30px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        input[type="text"],
        textarea,
        input[type="file"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 2px solid #1d73be;
            border-radius: 6px;
            transition: 0.3s ease;
            font-size: 14px;
        }

        input[type="text"]:focus,
        textarea:focus {
            border-color: #ff6f00;
            outline: none;
            box-shadow: 0 0 5px rgba(255, 111, 0, 0.5);
        }

        textarea {
            resize: vertical;
        }

        img {
            display: block;
            margin: 10px auto;
            max-height: 120px;
            border-radius: 8px;
            border: 3px solid #1d73be;
        }

        input[type="submit"] {
            background-color: #ff6f00;
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: bold;
            text-transform: uppercase;
            cursor: pointer;
            transition: background-color 0.3s ease;
            width: 100%;
        }

        input[type="submit"]:hover {
            background-color: #e65100;
        }
    </style>
</head>
<body>
    <div class="banner">
        <h1>🏸 BadmintonHub Blog</h1>
        <p>Chia sẻ kiến thức & đam mê cầu lông mỗi ngày</p>
    </div>

    <h2>Sửa bài viết</h2>
<form action="<%= request.getContextPath() %>/update-post" method="post" enctype="multipart/form-data">
    <input type="hidden" name="postID" value="<%= post.getPostID() %>"/>

    Tiêu đề: <input type="text" name="title" value="<%= post.getTitle() %>" required><br/>
    Slug: <input type="text" name="slug" value="<%= post.getSlug() %>" required><br/>
    Summary: <input type="text" name="summary" value="<%= post.getSummary() %>" required><br/>
    Nội dung:<br/>
    <textarea name="content" rows="10" cols="50"><%= post.getContent() %></textarea><br/>
    
    <label>Ảnh đại diện mới (thumbnail):</label>
    <input type="file" name="thumbnailFile" accept="image/*"><br/>
    <img src="<%= post.getThumbnailUrl() %>" width="100"/><br/>

    <label>Trạng thái bài viết:</label>
    <select name="status" required>
        <option value="published" <%= post.getStatus().equals("published") ? "selected" : "" %>>Published</option>
        <option value="scheduled" <%= post.getStatus().equals("scheduled") ? "selected" : "" %>>Scheduled</option>
        <option value="draft" <%= post.getStatus().equals("draft") ? "selected" : "" %>>Draft</option>
        <option value="archived" <%= post.getStatus().equals("archived") ? "selected" : "" %>>Archived</option>
    </select><br/>

    <input type="submit" value="Cập nhật bài viết"/>
</form>

</body>
</html>

