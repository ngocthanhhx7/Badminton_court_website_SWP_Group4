<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.UserDTO" %>
<%
    Object accObj = session.getAttribute("acc");
    if (accObj == null || !(accObj instanceof UserDTO)) {
        response.sendRedirect("./Login.jsp");
        return;
    }

    UserDTO user = (UserDTO) accObj;
    String success = request.getParameter("success");
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Thông tin người dùng</title>
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
    </head>
    <body>

        <div class="card">
            <% if ("true".equals(success)) { %>
            <div class="message-success">Cập nhật thành công!</div>
            <% } %>

            <div class="profile-header">
                <% String avatarUrl;
                   String gender = user.getGender();
                   if ("Male".equalsIgnoreCase(gender)) {
                       avatarUrl = "https://symbols.vn/wp-content/uploads/2021/11/Anh-avatar-de-thuong-cho-nam.jpg"; 
                   } else if ("Female".equalsIgnoreCase(gender)) {
                       avatarUrl = "https://img6.thuthuatphanmem.vn/uploads/2022/10/23/hinh-avatar-chibi-cute_031501070.jpg"; 
                   } else {
                       avatarUrl = "https://cdn-icons-png.flaticon.com/512/149/149071.png"; 
                   }
                %>
                <img src="<%= avatarUrl %>" alt="Avatar người dùng">
                <div class="user-info">
                    <h3><%= user.getFullName() %></h3>
                    <span><%= user.getEmail() %></span>
                </div>
            </div>

            <hr class="line">

            <div class="info-row"><span class="info-label">Username:</span> <%= user.getUsername() %></div>
            <div class="info-row"><span class="info-label">Password:</span> 
                <%= "*".repeat(user.getPassword().length()) %>
            </div>

            <div class="info-row"><span class="info-label">Email:</span> <%= user.getEmail() %></div>
            <div class="info-row"><span class="info-label">Full Name:</span> <%= user.getFullName() %></div>
            <div class="info-row"><span class="info-label">DOB:</span> <%= user.getDob() %></div>
            <div class="info-row"><span class="info-label">Gender:</span> <%= user.getGender() %></div>
            <div class="info-row"><span class="info-label">Phone:</span> <%= user.getPhone() %></div>
            <div class="info-row"><span class="info-label">Address:</span> <%= user.getAddress() %></div>
            <div class="info-row"><span class="info-label">Sport Level:</span> <%= user.getSportLevel() %></div>
            <div class="info-row"><span class="info-label">Role:</span> <%= user.getRole() %></div>

            <hr class="line">

            <div class="social-buttons">
                <a href="https://www.facebook.com" target="_blank"><button type="button" class="neo-button"><i class="fa fa-facebook"></i></button></a>
                <a href="https://www.linkedin.com" target="_blank"><button type="button" class="neo-button"><i class="fa fa-linkedin"></i></button></a>
                <a href="https://www.google.com" target="_blank"><button type="button" class="neo-button"><i class="fa fa-google"></i></button></a>
                <a href="https://www.youtube.com" target="_blank"><button type="button" class="neo-button"><i class="fa fa-youtube"></i></button></a>
                <a href="https://www.twitter.com" target="_blank"><button type="button" class="neo-button"><i class="fa fa-twitter"></i></button></a>
            </div>

            <div class="button-row">
                <a href="./edit-profile.jsp" class="btn">Chỉnh sửa thông tin</a>
                <a href="./home" class="btn">← Về trang chủ</a>
            </div>
        </div>

    </body>
</html>
