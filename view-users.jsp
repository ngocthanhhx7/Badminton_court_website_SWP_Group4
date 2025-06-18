<%-- 
    Document   : view-users
    Created on : Jun 17, 2025, 8:12:28 AM
    Author     : HP
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, models.User" %>
<%
    List<User> users = (List<User>) request.getAttribute("users");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh sách người dùng</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }

        h2 {
            text-align: center;
            margin-bottom: 30px;
            color: #343a40;
            font-weight: 600;
        }

        .table-wrapper {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
        }

        .table th, .table td {
            vertical-align: middle !important;
        }

        .status-active {
            color: #28a745;
            font-weight: bold;
        }

        .status-inactive {
            color: red;
            font-weight: bold;
        }

        .btn-sm {
            padding: 4px 10px;
            font-size: 13px;
            margin-right: 4px;
        }

        .btn-warning {
            background-color: #ffc107;
            border: none;
            color: #212529;
        }

        .btn-warning:hover {
            background-color: #e0a800;
        }

        .btn-success {
            background-color: #28a745;
            border: none;
        }

        .btn-success:hover {
            background-color: #218838;
        }

        .btn-primary {
            background-color: #007bff;
            border: none;
        }

        .btn-primary:hover {
            background-color: #0069d9;
        }

        .table thead {
            background-color: #343a40;
            color: white;
        }

        .container {
            max-width: 1100px;
        }
    </style>
</head>
<body>
<div class="container mt-5">
    <h2>📋 Danh sách người dùng</h2>

    <div class="table-wrapper">
        <table class="table table-bordered table-hover">
            <thead>
            <tr>
                <th>Username</th>
                <th>Họ tên</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Role</th>
                <th>Trạng thái</th>
                <th>Hành động</th>
            </tr>
            </thead>
            <tbody>
            <% for (User u : users) { %>
            <tr>
                <td><%= u.getUsername() %></td>
                <td><%= u.getFullName() %></td>
                <td><%= u.getEmail() %></td>
                <td><%= u.getPhone() %></td>
                <td><%= u.getRole() %></td>
                <td>
                    <% if ("Active".equalsIgnoreCase(u.getStatus())) { %>
                        <span class="status-active">Active</span>
                    <% } else { %>
                        <span class="status-inactive">Inactive</span>
                    <% } %>
                </td>
                <td>
                    <% if ("Active".equalsIgnoreCase(u.getStatus())) { %>
                        <a href="toggle-status?email=<%= u.getEmail() %>&action=deactivate"
                           class="btn btn-sm btn-warning"
                           onclick="return confirm('Bạn có chắc muốn vô hiệu hóa tài khoản này?');">
                            🛑 Vô hiệu hóa
                        </a>
                        <a href="edit-user.jsp?email=<%= u.getEmail() %>"
                           class="btn btn-sm btn-primary">
                            ✏️ Chỉnh sửa
                        </a>
                    <% } else { %>
                        <a href="toggle-status?email=<%= u.getEmail() %>&action=activate"
                           class="btn btn-sm btn-success"
                           onclick="return confirm('Bạn có chắc muốn kích hoạt lại tài khoản này?');">
                            ✅ Kích hoạt lại
                        </a>
                    <% } %>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>

    <!-- ✅ Nút quay lại trang chính -->
    <div class="text-center mt-4">
        <a href="page-manager" class="btn btn-secondary btn-lg">
            🔙 Quay lại trang chính
        </a>
    </div>
</div>
</body>
</html>
