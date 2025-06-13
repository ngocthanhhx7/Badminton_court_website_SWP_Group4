<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="models.UserDTO" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    UserDTO user = (UserDTO) session.getAttribute("acc");
    if (user == null) {
        response.sendRedirect("./Login");
        return;
    }
    String dobFormatted = "";
    if (user.getDob() != null) {
        dobFormatted = new SimpleDateFormat("yyyy-MM-dd").format(user.getDob());
    }

    // THÊM DÒNG NÀY ĐỂ TRÁNH LỖI
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Chỉnh sửa profile</title>
        <link href="https://fonts.googleapis.com/css2?family=Noto+Sans&display=swap" rel="stylesheet">
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1">

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
        <link rel="stylesheet" href="css/edit-profile.css">
        <!-- <link rel="stylesheet" href="css/responsive.css"> -->
    </head>

    <link rel="stylesheet" href="css/owl.carousel.min.css">
    <link rel="stylesheet" href="css/page-transitions.css">
    <script src="js/jquery.min.js"></script>
    <script src="js/owl.carousel.min.js"></script>
    <script src="js/effects.js"></script>
    <script src="js/page-transitions.js"></script>

    <body>
        <div class="form-container">
            <h2>Edit Profile</h2>

            <% if (error != null) { %>
            <div style="color: red; font-weight: bold; text-align: center;">
                <%= error %>
            </div>
            <% } %>

            <form action="update-profile" method="get">
                <table>
                    <tr>
                        <td>Name:</td>
                        <td><input type="text" name="fullName" value="<%= user.getFullName() %>" /></td>
                    </tr>
                    <tr>
                        <td>Password:</td>
                        <td><input type="text" name="password" value="<%= user.getPassword() %>" /></td>
                    </tr>
                    <tr>
                        <td>Date:</td>
                        <td><input type="date" name="dob" value="<%= dobFormatted %>" /></td>
                    </tr>
                    <tr>
                        <td>Gender:</td>
                        <td>
                            <div class="form-select" id="default-select">
                                <select name="gender" required>
                                    <option value="">-- Chọn giới tính --</option>
                                    <option value="Male" <%= "Male".equals(user.getGender()) ? "selected" : "" %>>Nam</option>
                                    <option value="Female" <%= "Female".equals(user.getGender()) ? "selected" : "" %>>Nữ</option>
                                    <option value="Other" <%= "Other".equals(user.getGender()) ? "selected" : "" %>>Khác</option>
                                </select>
                            </div>
                        </td>
                    </tr>

                    <tr>
                        <td>Phone:</td>
                        <td><input type="text" name="phone" value="<%= user.getPhone() %>" /></td>
                    </tr>
                    <tr>
                        <td>Address:</td>
                        <td><input type="text" name="address" value="<%= user.getAddress() %>" /></td>
                    </tr>
                    <tr>
                        <td>Sport Level:</td>
                        <td><%= user.getSportLevel() %></td>
                    </tr>
                    <tr>
                        <td>Role:</td>
                        <td><%= user.getRole() %></td>
                    </tr>
                    <tr>
                        <td colspan="2"><input type="submit" value="Update"></td>
                    </tr>
                </table>
            </form>
            <a href="view-profile.jsp">Về Profile</a>

        </div>
    </body>
</html>
