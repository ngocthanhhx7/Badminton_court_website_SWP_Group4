<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ page import="java.util.*, models.BlogPostDTO, dao.BlogPostDAO" %>
<%@ page import="dao.BlogCommentDAO, models.BlogCommentDTO" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Blog Dashboard</title>
        <link rel="stylesheet" href="vendors/typicons.font/font/typicons.css">
        <link rel="stylesheet" href="vendors/css/vendor.bundle.base.css">
        <link rel="stylesheet" href="css/vertical-layout-light/style.css">
        <link rel="shortcut icon" href="img/favicon.png" />
        <style>
            /* Các style chung từ template gốc */
            .image-preview {
                max-width: 200px;
                max-height: 150px;
                margin-top: 10px;
                border: 1px solid #ddd;
                border-radius: 4px;
            }
            .file-input-wrapper {
                position: relative;
                display: inline-block;
                cursor: pointer;
            }
            .file-input-wrapper input[type=file] {
                position: absolute;
                left: -9999px;
            }
            .file-input-wrapper .btn {
                margin-right: 10px;
            }
            .filter-section {
                background: #f8f9fa;
                padding: 20px;
                border-radius: 8px;
                margin-bottom: 20px;
            }
            .sort-header {
                cursor: pointer;
                user-select: none;
            }
            .sort-header:hover {
                background-color: #f8f9fa;
            }
            .sort-icon {
                margin-left: 5px;
                font-size: 12px;
            }
            .pagination-info {
                margin: 10px 0;
                color: #6c757d;
            }
            .search-box {
                max-width: 300px;
            }

            /* Các style từ bảng điều khiển blog */
            body {
                font-family: 'Segoe UI', sans-serif;
                background: linear-gradient(to right, #f0f4ff, #e0f7fa);
                margin: 0;
                padding: 0;
            }
            /* Đã xóa .header CSS vì không còn thanh header đó */

            /* Điều chỉnh cho nút "Viết bài mới" để phù hợp với bố cục mới */
            .blog-actions-container {
                display: flex;
                justify-content: flex-end; /* Đẩy sang phải */
                margin-bottom: 20px; /* Thêm khoảng cách với form tìm kiếm */
                padding-right: 10px; /* Căn chỉnh với nội dung card */
            }

            .menu-toggle {
                position: relative;
                display: inline-block; /* Để button không chiếm toàn bộ chiều rộng */
            }
            .menu-toggle button {
                background: #ffd54f;
                color: #0d47a1;
                padding: 10px 20px;
                font-weight: bold;
                border: none;
                border-radius: 8px;
                cursor: pointer;
            }
            .dropdown {
                display: none;
                position: absolute;
                top: 45px; /* Điều chỉnh vị trí dropdown */
                right: 0; /* Căn phải với nút */
                background: white;
                border: 1px solid #ccc;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                z-index: 999;
                min-width: 220px;
            }
            .dropdown a {
                display: block;
                padding: 12px 20px;
                text-decoration: none;
                color: #0d47a1;
                font-weight: bold;
                border-bottom: 1px solid #eee;
            }
            .dropdown a:last-child { border-bottom: none; }
            .dropdown a:hover { background-color: #f0f0f0; }

            /* Đã xóa .header a.logout-link CSS */

            .search-form {
                max-width: 500px;
                margin: 0 auto 20px; /* Căn giữa và thêm khoảng cách dưới */
                display: flex;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                border-radius: 8px;
                overflow: hidden;
                background-color: #fff;
            }
            .search-form input[type="text"] {
                flex: 1;
                padding: 12px 16px;
                font-size: 15px;
                border: none;
                outline: none;
                background-color: #f9f9f9;
            }
            .search-form button {
                padding: 0 20px;
                background-color: #1976d2;
                color: white;
                border: none;
                font-size: 16px;
                font-weight: bold;
                cursor: pointer;
            }
            .search-form button:hover { background-color: #0d47a1; }
            .feed {
                max-width: 900px;
                margin: 20px auto;
                padding: 10px;
            }
            .post-card {
                position: relative;
                background: #ffffff;
                border-radius: 12px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.1);
                padding: 20px;
                margin-bottom: 25px;
                transition: transform 0.3s ease;
            }
            .post-card:hover { transform: translateY(-5px); }
            .status-badge {
                position: absolute;
                top: 15px;
                right: 15px;
                font-size: 12px;
                font-weight: bold;
                padding: 4px 10px;
                border-radius: 12px;
                text-transform: uppercase;
                box-shadow: 0 1px 5px rgba(0,0,0,0.1);
            }
            .status-draft { background-color: #ffc107; color: #000; }
            .status-published { background-color: #4caf50; color: white; }
            .status-archived { background-color: #9e9e9e; color: white; }
            .status-scheduled { background-color: #42a5f5; color: white; }
            .post-title { font-size: 22px; font-weight: bold; color: #0d47a1; margin-bottom: 8px; }
            .post-meta { font-size: 13px; color: #607d8b; margin-bottom: 12px; }
            .post-thumbnail img { width: 100%; max-height: 220px; object-fit: cover; border-radius: 8px; margin-bottom: 15px; }
            .post-summary { font-size: 15px; font-weight: 600; color: #333; margin-bottom: 10px; }
            .post-content { font-size: 14px; color: #555; margin-bottom: 15px; }
            .post-footer {
                display: flex;
                justify-content: space-between;
                align-items: center;
                font-size: 13px;
                color: #999;
                border-top: 1px solid #e0e0e0;
                padding-top: 10px;
            }
            .actions a {
                display: inline-block;
                padding: 8px 16px;
                margin-left: 10px;
                border-radius: 5px;
                font-weight: bold;
                font-size: 13px;
                text-decoration: none;
            }
            .actions a.edit { background-color: #29b6f6; color: white; }
            .actions a.edit:hover { background-color: #0288d1; }
            .actions a.delete { background-color: #ef5350; color: white; }
            .actions a.delete:hover { background-color: #d32f2f; }

            .comment-section { margin-top: 20px; padding-top: 10px; border-top: 1px dashed #ccc; }
            .comment { margin-bottom: 10px; background: #f9f9f9; padding: 10px; border-radius: 6px; }
            .comment-meta { font-size: 12px; color: gray; }
            .comment-form textarea { width: 100%; padding: 8px; border-radius: 5px; border: 1px solid #ccc; }
            .comment-form button { margin-top: 5px; background-color: #1976d2; color: white; padding: 6px 12px; border: none; border-radius: 5px; cursor: pointer; }

            .comment-toggle {
                color: #1976d2;
                font-weight: bold;
                cursor: pointer;
                margin-top: 15px;
                display: inline-block;
            }
        </style>
    </head>
    <body>
        <div class="container-scroller">
            <jsp:include page="header-manager.jsp" />
            <div class="main-panel">
                <div class="content-wrapper">
                    <div class="row">
                        <div class="col-lg-12 grid-margin stretch-card">
                            <div class="card">
                                <div class="card-body">
                                    <%
                                        Integer userID = (Integer) session.getAttribute("userID");
                                        if (userID == null) {
                                            response.sendRedirect("login.jsp");
                                            return;
                                        }

                                        String keyword = request.getParameter("q");
                                        BlogPostDAO dao = new BlogPostDAO();
                                        List<BlogPostDTO> posts;
                                        if (keyword != null && !keyword.trim().isEmpty()) {
                                            posts = dao.searchByTitle(keyword.trim());
                                        } else {
                                            posts = dao.getAll();
                                        }

                                        BlogCommentDAO commentDAO = new BlogCommentDAO();
                                    %>

                                    <%-- Nút "Thêm bài viết mới" và menu dropdown --%>
                                    <div class="blog-actions-container">
                                        <div class="menu-toggle">
                                            <button id="menuButton" onclick="toggleNewPostMenu()">+ Viết bài mới</button>
                                            <div id="newPostMenu" class="dropdown">
                                                <a href="new-post.jsp">✍️ Viết bài thủ công</a>
                                                <a href="new-post-schedule.jsp">⏰ Viết bài hẹn giờ</a>
                                            </div>
                                        </div>
                                    </div>

                                    <%-- Form tìm kiếm --%>
                                    <form class="search-form" method="get" action="dashboard.jsp">
                                        <input type="text" name="q" placeholder="Tìm kiếm tiêu đề..." value="<%= request.getParameter("q") != null ? request.getParameter("q") : "" %>">
                                        <button type="submit">🔍</button>
                                    </form>

                                    <%-- Hiển thị danh sách bài viết --%>
                                    <div class="feed">
                                        <% if (posts.isEmpty()) { %>
                                            <p style="text-align:center; color: gray;">Không tìm thấy bài viết nào.</p>
                                        <% } else {
                                            for (BlogPostDTO post : posts) {
                                                String status = post.getStatus() != null ? post.getStatus() : "archived";
                                                String statusClass = "status-archived";
                                                if ("published".equalsIgnoreCase(status)) statusClass = "status-published";
                                                else if ("scheduled".equalsIgnoreCase(status)) statusClass = "status-scheduled";
                                                else if ("draft".equalsIgnoreCase(status)) statusClass = "status-draft";
                                                List<BlogCommentDTO> comments = commentDAO.getByPostId(post.getPostID());
                                        %>
                                            <div class="post-card">
                                                <div class="status-badge <%= statusClass %>"><%= status %></div>
                                                <div class="post-title"><%= post.getTitle() %></div>
                                                <div class="post-meta">Bởi Staff ID <%= post.getAuthorID() %> • <%= post.getPublishedAt() %></div>
                                                <div class="post-thumbnail"><img src="<%= post.getThumbnailUrl() %>" alt="Ảnh đại diện bài viết"></div>
                                                <div class="post-summary"><%= post.getSummary() %></div>
                                                <div class="post-content"><%= post.getContent() %></div>
                                                <div class="post-footer">
                                                    <div><strong>Slug:</strong> <%= post.getSlug() %> • <strong>Lượt xem:</strong> <%= post.getViewCount() %></div>
                                                    <div class="actions">
                                                        <a class="edit" href="edit-post.jsp?id=<%= post.getPostID() %>">✏️ Sửa</a>
                                                        <a class="delete" href="delete-post?id=<%= post.getPostID() %>" onclick="return confirm('Bạn có chắc muốn xóa bài viết này?');">🗑️ Xóa</a>
                                                    </div>
                                                </div>

                                                <div class="comment-toggle" onclick="toggleComments(<%= post.getPostID() %>)">
                                                    💬 Bình luận (<%= comments.size() %>)
                                                </div>

                                                <div class="comment-section" id="comments<%= post.getPostID() %>" style="display: none;">
                                                    <% for (BlogCommentDTO c : comments) { %>
                                                        <div class="comment">
                                                            <strong>User <%= c.getUserID() %></strong>: <%= c.getContent() %>
                                                            <div class="comment-meta"><%= c.getCreatedAt() %></div>
                                                        </div>
                                                    <% } %>
                                                    <% if (comments.isEmpty()) { %>
                                                        <p style="color: gray; font-style: italic;">Chưa có bình luận nào.</p>
                                                    <% } %>

                                                    <form class="comment-form" action="add-comment" method="post">
                                                        <input type="hidden" name="postID" value="<%= post.getPostID() %>">
                                                        <input type="hidden" name="userID" value="<%= session.getAttribute("userID") %>">
                                                        <textarea name="content" rows="2" required placeholder="Viết bình luận tại đây..."></textarea>
                                                        <button type="submit">Gửi bình luận</button>
                                                    </form>
                                                </div>
                                            </div>
                                        <% }} %>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="vendors/js/vendor.bundle.base.js"></script>
        <script src="js/off-canvas.js"></script>
        <script src="js/hoverable-collapse.js"></script>
        <script src="js/template.js"></script>
        <script src="js/settings.js"></script>
        <script src="js/todolist.js"></script>
        <script src="vendors/progressbar.js/progressbar.min.js"></script>
        <script src="vendors/chart.js/Chart.min.js"></script>
        <script src="js/dashboard.js"></script>
        <script>
            // Auto-hide alerts after 5 seconds
            $(document).ready(function() {
                setTimeout(function() {
                    $('.alert').fadeOut('slow');
                }, 5000);
            });

            // Scripts for blog dashboard functionality
            function toggleNewPostMenu() {
                const menu = document.getElementById("newPostMenu");
                // Đảm bảo menu hiển thị bên phải của nút
                menu.style.display = menu.style.display === "block" ? "none" : "block";
            }
            window.onclick = function(e) {
                const menu = document.getElementById("newPostMenu");
                const button = document.getElementById("menuButton");
                if (menu && !menu.contains(e.target) && e.target !== button) {
                    menu.style.display = "none";
                }
            }

            function toggleComments(postID) {
                const el = document.getElementById("comments" + postID);
                if (el.style.display === "none" || el.style.display === "") {
                    el.style.display = "block";
                } else {
                    el.style.display = "none";
                }
            }
        </script>
    </body>
</html>