<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.AdminDTO" %>
<%
    Object accObj = session.getAttribute("acc");
    if (accObj == null || !(accObj instanceof AdminDTO)) {
        response.sendRedirect("./Login.jsp");
        return;
    }

    AdminDTO admin = (AdminDTO) accObj;
    String success = request.getParameter("success");
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Thông tin Admin</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
        <!-- <link rel="manifest" href="site.webmanifest"> -->
        <link rel="shortcut icon" type="image/x-icon" href="img/favicon.png">
        <!-- Place favicon.ico in the root directory -->

        <!-- CSS here -->
        <link rel="stylesheet" href="css/bootstrap.min.css">
        <link rel="stylesheet" href="css/owl.carousel.min.css">
        <link rel="stylesheet" href="css/magnific-popup.css">
        <link rel="stylesheet" href="css/font-awesome.min.css">
        <link rel="stylesheet" href="css/themify-icons.css">
        <link rel="stylesheet" href="css/nice-select.css">
        <link rel="stylesheet" href="css/flaticon.css">
        <link rel="stylesheet" href="css/gijgo.css">
        <link rel="stylesheet" href="css/animate.css">
        <link rel="stylesheet" href="css/slicknav.css">
        <link rel="stylesheet" href="css/style.css">
        <link rel="stylesheet" href="css/view-profile.css">
        <!-- <link rel="stylesheet" href="css/responsive.css"> -->

        <link rel="stylesheet" href="css/owl.carousel.min.css">
        <link rel="stylesheet" href="css/page-transitions.css">
        <script src="js/jquery.min.js"></script>
        <script src="js/owl.carousel.min.js"></script>
        <script src="js/effects.js"></script>
        <script src="js/page-transitions.js"></script>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </head>
    <body>

        <div class="card">
            <% if ("true".equals(success)) { %>
            <div class="message-success">Cập nhật thành công!</div>
            <% } %>

            <div class="profile-header">
                <% String avatarUrl = "https://cdn-icons-png.flaticon.com/512/149/149071.png"; %>
                <img src="<%= avatarUrl %>" alt="Avatar Admin">
                <div class="user-info">
                    <h3><%= admin.getFullName() %></h3>
                    <span><%= admin.getEmail() %></span>
                </div>
            </div>

            <hr class="line">

            <div class="info-row"><span class="info-label">Admin ID:</span> <%= admin.getAdminID() %></div>
            <div class="info-row"><span class="info-label">Username:</span> <%= admin.getUsername() %></div>
            <div class="info-row"><span class="info-label">Password:</span> 
                <%= "*".repeat(admin.getPassword().length()) %>
            </div>
            <div class="info-row"><span class="info-label">Email:</span> <%= admin.getEmail() %></div>
            <div class="info-row"><span class="info-label">Full Name:</span> <%= admin.getFullName() %></div>
            <div class="info-row"><span class="info-label">Status:</span> 
                <span class="badge <%= "Active".equals(admin.getStatus()) ? "badge-success" : "badge-warning" %>">
                    <%= admin.getStatus() %>
                </span>
            </div>
            <div class="info-row"><span class="info-label">Created At:</span> <%= admin.getCreatedAt() %></div>
            <div class="info-row"><span class="info-label">Updated At:</span> <%= admin.getUpdatedAt() %></div>

            <hr class="line">

            <div class="social-buttons">
                <a href="https://www.facebook.com" target="_blank"><button type="button" class="neo-button"><i class="fa fa-facebook"></i></button></a>
                <a href="https://www.linkedin.com" target="_blank"><button type="button" class="neo-button"><i class="fa fa-linkedin"></i></button></a>
                <a href="https://www.google.com" target="_blank"><button type="button" class="neo-button"><i class="fa fa-google"></i></button></a>
                <a href="https://www.youtube.com" target="_blank"><button type="button" class="neo-button"><i class="fa fa-youtube"></i></button></a>
                <a href="https://www.twitter.com" target="_blank"><button type="button" class="neo-button"><i class="fa fa-twitter"></i></button></a>
            </div>

            <div class="button-row">
                <a href="./update-profile-admin" class="btn">Chỉnh sửa thông tin</a>
                <a href="./home" class="btn">← Về trang quản lý</a>
            </div>
        </div>

    </body>
</html>
