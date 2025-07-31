<%-- 
    Document   : new-post-schedule
    Created on : Jun 30, 2025, 2:35:07 PM
    Author     : HP
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Integer userID = (Integer) session.getAttribute("userID");
    if (userID == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Viết bài hẹn giờ</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f2f2f2;
            padding: 30px;
        }

        .container {
            max-width: 800px;
            background: #fff;
            margin: auto;
            padding: 25px 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        h2 {
            color: #1976d2;
            margin-bottom: 20px;
            text-align: center;
        }

        label {
            display: block;
            margin: 12px 0 6px;
            font-weight: bold;
        }

        input[type="text"],
        input[type="datetime-local"],
        input[type="file"],
        textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
        }

        textarea {
            resize: vertical;
            height: 120px;
        }

        button {
            margin-top: 20px;
            padding: 12px 20px;
            background-color: #1976d2;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
        }

        button:hover {
            background-color: #0d47a1;
        }

        .back-link {
            display: inline-block;
            margin-top: 15px;
            text-decoration: none;
            color: #1976d2;
        }

        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>🕒 Viết bài và hẹn giờ đăng</h2>

        <%-- HIỂN THỊ THÔNG BÁO LỖI (nếu có) --%>
        <% if (request.getParameter("msg") != null && request.getParameter("msg").equals("error")) { %>
            <p style="color:red; font-weight:bold; text-align:center;">
                Lỗi: <%= request.getParameter("reason") %>
            </p>
        <% } else if (request.getParameter("msg") != null && request.getParameter("msg").equals("success")) { %>
            <p style="color:green; font-weight:bold; text-align:center;">
                ✅ Đặt lịch đăng bài thành công!
            </p>
        <% } %>

        <form action="schedule-post" method="post" enctype="multipart/form-data">
            <label for="title">Tiêu đề bài viết:</label>
            <input type="text" id="title" name="title" required>

            <label for="slug">Slug (tên không dấu, viết thường, cách nhau bằng -):</label>
            <input type="text" id="slug" name="slug" required>

            <label for="summary">Tóm tắt nội dung:</label>
            <textarea id="summary" name="summary" required></textarea>

            <label for="content">Nội dung chi tiết:</label>
            <textarea id="content" name="content" required></textarea>

            <label for="thumbnailFile">Ảnh đại diện (upload từ máy):</label>
            <input type="file" id="thumbnailFile" name="thumbnailFile" accept="image/*" required>

            <label for="scheduleTime">🗓️ Thời gian đăng bài:</label>
            <input type="datetime-local" id="scheduleTime" name="scheduleTime" required>

            <button type="submit">📤 Đặt lịch đăng</button>
        </form>

        <a href="dashboard.jsp" class="back-link">⬅️ Quay lại bảng điều khiển</a>
    </div>
</body>
</html>

