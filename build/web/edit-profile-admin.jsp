<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="models.AdminDTO" %>
<%
    Object accObj = session.getAttribute("acc");
    AdminDTO admin = null;
    
    // Chỉ xử lý cho AdminDTO
    if (accObj instanceof AdminDTO) {
        admin = (AdminDTO) accObj;
    } else {
        response.sendRedirect("./Login");
        return;
    }
    
    if (admin == null) {
        response.sendRedirect("./Login");
        return;
    }

    // THÊM DÒNG NÀY ĐỂ TRÁNH LỖI
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Chỉnh sửa profile Admin</title>
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
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
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
            <h2>Edit Admin Profile</h2>

            <% if (error != null) { %>
            <div style="color: red; font-weight: bold; text-align: center;">
                <%= error %>
            </div>
            <% } %>

            <form action="update-profile-admin" method="get">
                <table>
                    <tr>
                        <td>Admin ID:</td>
                        <td><%= admin.getAdminID() %></td>
                    </tr>
                    <tr>
                        <td>Username:</td>
                        <td><input type="text" name="username" value="<%= admin.getUsername() %>" required /></td>
                    </tr>
                    <tr>
                        <td>Full Name:</td>
                        <td><input type="text" name="fullName" value="<%= admin.getFullName() %>" required /></td>
                    </tr>
                    <tr>
                        <td>Email:</td>
                        <td><input type="email" name="email" value="<%= admin.getEmail() %>" required /></td>
                    </tr>
                    <tr>
                        <td>Status:</td>
                        <td>
                            <div class="form-select" id="default-select">
                                <select name="status" required>
                                    <option value="">-- Chọn trạng thái --</option>
                                    <option value="Active" <%= "Active".equals(admin.getStatus()) ? "selected" : "" %>>Active</option>
                                    <option value="Inactive" <%= "Inactive".equals(admin.getStatus()) ? "selected" : "" %>>Inactive</option>
                                    <option value="Suspended" <%= "Suspended".equals(admin.getStatus()) ? "selected" : "" %>>Suspended</option>
                                    <option value="Locked" <%= "Locked".equals(admin.getStatus()) ? "selected" : "" %>>Locked</option>
                                </select>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2"><input type="submit" value="Update"></td>
                    </tr>
                </table>
            </form>
            <a href="view-profile-admin.jsp">Về Profile</a>

        </div>
    </body>
</html>
