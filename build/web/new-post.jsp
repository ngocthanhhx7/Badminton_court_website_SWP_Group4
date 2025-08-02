<%-- 
    Document   : new-post
    Created on : Jun 18, 2025, 2:30:10 AM
    Author     : HP
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%
    if (session.getAttribute("userID") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Đăng bài mới</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(to right, #c8e6c9, #bbdefb); /* xanh lá nhạt -> xanh dương nhạt */
            margin: 0;
            padding: 40px;
        }

        h2 {
            text-align: center;
            color: #1b5e20; /* xanh đậm */
            margin-bottom: 30px;
        }

        form {
            background-color: #ffffff;
            padding: 25px 30px;
            border-radius: 15px;
            max-width: 700px;
            margin: auto;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
            border-left: 6px solid #388e3c;
        }

        label {
            display: block;
            margin-top: 18px;
            font-weight: bold;
            color: #2e7d32; /* xanh rêu */
        }

        input[type="text"],
        textarea,
        input[type="file"] {
            width: 100%;
            padding: 12px;
            margin-top: 6px;
            border: 1px solid #ccc;
            border-radius: 6px;
            box-sizing: border-box;
            transition: 0.3s ease-in-out;
        }

        input[type="text"]:focus,
        textarea:focus {
            border-color: #64b5f6; /* xanh dương nhạt */
            background-color: #f1f8e9;
            outline: none;
        }

        input[type="submit"] {
            margin-top: 25px;
            padding: 12px 25px;
            background: linear-gradient(to right, #43a047, #1e88e5); /* xanh lá -> xanh dương */
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: 0.3s;
        }

        input[type="submit"]:hover {
            background: linear-gradient(to right, #2e7d32, #1565c0);
        }

        .error {
            color: red;
            font-weight: bold;
            margin-bottom: 10px;
            text-align: center;
        }

        /* Optional: thumbnail input styling */
        input[type="file"] {
            padding: 6px;
            background-color: #f5f5f5;
        }
    </style>
</head>
<body>

<h2>🏸 Đăng Bài Viết Mới về Cầu Lông 🏸</h2>

<%-- HIỂN THỊ THÔNG BÁO LỖI --%>
<% if (request.getAttribute("error") != null) { %>
    <div class="error"><%= request.getAttribute("error") %></div>
<% } %>

<form action="post-blog" method="post" enctype="multipart/form-data">

    <label>Tiêu đề (Title):</label>
    <input type="text" name="title" required>

    <label>Slug (không dấu, viết thường, cách nhau bằng dấu `-`):</label>
    <input type="text" name="slug" required>

    <label>Tóm tắt (Summary):</label>
    <input type="text" name="summary" required>

    <label>Nội dung bài viết:</label>
    <textarea name="content" rows="8" required></textarea>

    <label>Ảnh đại diện (Thumbnail):</label>
    <input type="file" name="thumbnailFile" accept="image/*" required>

    <input type="submit" value="🏸 Đăng bài">
</form>

</body>
</html>






