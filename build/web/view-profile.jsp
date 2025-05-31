<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.UserDTO" %>
<%
    Object accObj = session.getAttribute("acc");
    if (accObj == null || !(accObj instanceof UserDTO)) {
        response.sendRedirect("login.jsp");
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
        <!-- <link rel="stylesheet" href="css/responsive.css"> -->
        <style>
            @import url('https://fonts.googleapis.com/css2?family=Noto+Sans&display=swap');
            * {
                margin: 0;

            }
            html, body {
                height: 100%;
                overflow: hidden;
            }
            body {
                display: flex;
                justify-content: center;
                align-items: center;
                background: linear-gradient(135deg, #42a5f5, #7e57c2);
            }
            .card {
                color: #fff;
                width: 400px;
                border-radius: 10px;
                background: linear-gradient(145deg, #9a40a9, #b74cc9);
                box-shadow: 20px 20px 60px #913ca0, -20px -20px 60px #c552d8;
                border: none;
                padding: 30px 20px;
                text-align: center;
            }
            .card img {
                width: 100px;
                height: 100px;
                border-radius: 50%;
                object-fit: cover;
                margin-bottom: 10px;
            }
            .card h3 {
                font-size: 22px;
                margin: 1px 0 1px;
            }
            .card span {
                font-size: 14px;
                color: #eee;
            }
            .info-row {
                margin-top: 10px;
                font-size: 14px;
                text-align: left;
            }
            .info-label {
                font-weight: bold;
                display: inline-block;
                width: 120px;
            }
            .line {
                margin: 1px 0;
                border: 0;
                height: 1px;
                background-color: #fff;
            }
            .neo-button {
                width: 40px;
                height: 40px;
                outline: 0 !important;
                cursor: pointer;
                color: #fff;
                font-size: 15px;
                border: none;
                margin: 5px;
                border-radius: 50%;
                background: linear-gradient(145deg, #9a40a9, #b74cc9);
                box-shadow: inset 20px 20px 60px #913ca0, inset -20px -20px 60px #c552d8;
            }
            .neo-button:active {
                background: #AB47BC;
                box-shadow: 28px 28px 57px #933da2, -28px -28px 57px #c351d6;
            }
            .profile_button, .home_button {
                color: #fff;
                padding: 10px 30px;
                border: none;
                outline: 0 !important;
                border-radius: 50px;
                background: #AB47BC;
                box-shadow: 28px 28px 57px #933da2, -28px -28px 57px #c351d6;
                margin: 10px;
                cursor: pointer;
            }
            .social-buttons {
                margin-top: 20px;
            }
            .message-success {
                color: limegreen;
                font-weight: bold;
                margin-bottom: 10px;
                text-align: center;
            }

            .profile-header {
                display: flex;
                align-items: center;
                background-color: #9b42b0; /* Màu nền tím như ảnh */
                padding: 20px;
                border-radius: 8px;
                gap: 20px;
            }

            .profile-header img {
                width: 80px;
                height: 80px;
                border-radius: 50%;
                object-fit: cover;
                border: 2px solid white;
                background-color: white;
            }

            .user-info {
                display: flex;
                flex-direction: column;
                justify-content: center;
                color: white;
            }

            .user-info h3 {
                font-size: 20px;
                margin: 0;
                font-weight: bold;
            }

            .user-info span {
                font-size: 14px;
                margin-top: 4px;
                color: #f1f1f1;
            }
            .button-row {
                display: flex;
                justify-content: center;
                gap: 20px; /* Khoảng cách giữa 2 nút */
                margin-top: 20px;
            }

            .btn {
                padding: 10px 20px;
                background-color: rgba(255, 255, 255, 0.15);
                color: white;
                border: none;
                border-radius: 25px;
                text-decoration: none;
                font-size: 16px;
                transition: background 0.3s ease;
            }

            .btn:hover {
                background-color: rgba(255, 255, 255, 0.3);
            }


        </style>
    </head>
    <body>

        <div class="card">
            <% if ("true".equals(success)) { %>
            <div class="message-success">Cập nhật thành công!</div>
            <% } %>

            <div class="profile-header">
                <img src="https://cdn2.fptshop.com.vn/unsafe/1920x0/filters:format(webp):quality(75)/small/avatar_hoat_hinh_db4e0e9cf4.jpg" alt="Avatar người dùng">
                <div class="user-info">
                    <h3><%= user.getFullName() %></h3>
                    <span><%= user.getEmail() %></span>
                </div>
            </div>

            <hr class="line">

            <div class="info-row"><span class="info-label">Username:</span> <%= user.getUsername() %></div>
            <div class="info-row"><span class="info-label">Password:</span> <%= user.getPassword() %></div>
            <div class="info-row"><span class="info-label">Email:</span> <%= user.getEmail() %></div>
            <div class="info-row"><span class="info-label">Full Name:</span> <%= user.getFullName() %></div>
            <div class="info-row"><span class="info-label">DOB:</span> <%= user.getDob() %></div>
            <div class="info-row"><span class="info-label">Gender:</span> <%= user.getGender() %></div>
            <div class="info-row"><span class="info-label">Phone:</span> <%= user.getPhone() %></div>
            <div class="info-row"><span class="info-label">Address:</span> <%= user.getAddress() %></div>
            <div class="info-row"><span class="info-label">Sport Level:</span> <%= user.getSportLevel() %></div>
            <div class="info-row"><span class="info-label">Role:</span> <%= user.getRole() %></div>
            <div class="info-row"><span class="info-label">Created By:</span> <%= user.getCreatedBy() %></div>

            <hr class="line">

            <div class="social-buttons">
                <a href="https://www.facebook.com" target="_blank"><button type="button" class="neo-button"><i class="fa fa-facebook"></i></button></a>
                <a href="https://www.linkedin.com" target="_blank"><button type="button" class="neo-button"><i class="fa fa-linkedin"></i></button></a>
                <a href="https://www.google.com" target="_blank"><button type="button" class="neo-button"><i class="fa fa-google"></i></button></a>
                <a href="https://www.youtube.com" target="_blank"><button type="button" class="neo-button"><i class="fa fa-youtube"></i></button></a>
                <a href="https://www.twitter.com" target="_blank"><button type="button" class="neo-button"><i class="fa fa-twitter"></i></button></a>
            </div>

            <div class="button-row">
                <a href="edit-profile.jsp" class="btn">Chỉnh sửa thông tin</a>
                <a href="./home" class="btn">← Về trang chủ</a>
            </div>
        </div>

    </body>
</html>
