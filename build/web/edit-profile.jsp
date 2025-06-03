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
        <meta charset="UTF-8">
        <title>Update Information</title>
        <link href="https://fonts.googleapis.com/css2?family=Noto+Sans&display=swap" rel="stylesheet">
        <style>
            body {
                font-family: 'Noto Sans', sans-serif;
                background: linear-gradient(135deg, #42a5f5, #7e57c2);
                margin: 0;
                padding: 0;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                overflow: hidden;
            }

            .form-container {
                background: white;
                padding: 30px 40px;
                border-radius: 12px;
                box-shadow: 0 10px 25px rgba(0,0,0,0.2);
                width: 400px;
            }

            h2 {
                text-align: center;
                color: #7b1fa2;
                margin-bottom: 20px;
            }

            table {
                width: 100%;
            }

            td {
                padding: 10px 0;
            }

            input[type="text"],
            input[type="date"] {
                width: 100%;
                padding: 8px 12px;
                border: 1px solid #ccc;
                border-radius: 8px;
                transition: 0.3s;
            }

            input[type="text"]:focus,
            input[type="date"]:focus {
                border-color: #ab47bc;
                outline: none;
            }

            input[type="submit"] {
                background: #ab47bc;
                color: white;
                padding: 10px;
                border: none;
                border-radius: 30px;
                cursor: pointer;
                width: 100%;
                font-weight: bold;
                transition: background 0.3s;
            }

            input[type="submit"]:hover {
                background: #8e24aa;
            }

            a {
                display: inline-block;
                margin-top: 15px;
                text-align: center;
                color: #7b1fa2;
                text-decoration: none;
                width: 100%;
            }

            a:hover {
                text-decoration: underline;
            }
        </style>
    </head>

    <body>
        <div class="form-container">
            <h2>Edit Profile</h2>

            <% if (error != null) { %>
            <div style="color: red; font-weight: bold; text-align: center;">
                <%= error %>
            </div>
            <% } %>

            <form action="update-profile" method="post">
                <table>
                    <tr><td>Name:</td><td><input type="text" name="fullName" value="<%= user.getFullName() %>" /></td></tr>
                    <tr><td>Password:</td><td><input type="text" name="password" value="<%= user.getPassword() %>" /></td></tr>
                    <tr><td>Date:</td><td><input type="date" name="dob" value="<%= dobFormatted %>" /></td></tr>
                    <tr><td>Gender:</td><td><input type="text" name="gender" value="<%= user.getGender() %>" /></td></tr>
                    <tr><td>Phone:</td><td><input type="text" name="phone" value="<%= user.getPhone() %>" /></td></tr>
                    <tr><td>Address:</td><td><input type="text" name="address" value="<%= user.getAddress() %>" /></td></tr>
                    <tr><td>Sport Level:</td><td><input type="text" name="sportLevel" value="<%= user.getSportLevel() %>" /></td></tr>
                    <tr><td>Role:</td><td><input type="text" name="role" value="<%= user.getRole() %>" /></td></tr>
                    <tr><td colspan="2"><input type="submit" value="Update"></td></tr>
                </table>
            </form>
            <a href="view-profile.jsp">Về Profile</a>
        </div>
    </body>
</html>
