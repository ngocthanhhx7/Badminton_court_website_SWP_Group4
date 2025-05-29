<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complete Profile</title>
    <style>
        body {
            background: url('https://via.placeholder.com/1500x1000.png?text=Background') no-repeat center center fixed;
            background-size: cover;
            font-family: Arial, sans-serif;
            color: white;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        .container {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
        }
        .form-box {
            width: 100%;
            max-width: 400px;
            text-align: center;
        }
        .form-box h2 {
            font-size: 2rem;
            margin-bottom: 20px;
        }
        .form-box input, .form-box select {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: none;
            border-radius: 25px;
            background: rgba(255, 255, 255, 0.8);
        }
        .form-box button {
            width: 100%;
            padding: 10px;
            border: none;
            border-radius: 25px;
            background: #d1d5db;
            cursor: pointer;
        }
        .form-box button:hover {
            background: #b1b5b9;
        }
        .error {
            color: red;
            background: white;
            padding: 10px;
            border-radius: 5px;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="form-box">
            <h2>Complete Your Profile</h2>
            <form action="completeProfile.jsp" method="POST">
                <input type="text" name="fullName" placeholder="Full Name" required>
                <input type="date" name="dob" required>
                <select name="gender" required>
                    <option value="" disabled selected>Gender</option>
                    <option value="Male">Male</option>
                    <option value="Female">Female</option>
                    <option value="Other">Other</option>
                </select>
                <input type="text" name="phone" placeholder="Phone" required>
                <input type="text" name="address" placeholder="Address" required>
                <% 
                    String role = (String) session.getAttribute("role");
                    if ("Doctor".equals(role) || "Nurse".equals(role)) {
                %>
                    <input type="text" name="specialization" placeholder="Specialization" required>
                <% } %>
                <button type="submit">Submit</button>
            </form>

            <%
                if ("POST".equalsIgnoreCase(request.getMethod())) {
                    String username = (String) session.getAttribute("username");
                    String roleSession = (String) session.getAttribute("role");
                    String fullName = request.getParameter("fullName");
                    String dob = request.getParameter("dob");
                    String gender = request.getParameter("gender");
                    String phone = request.getParameter("phone");
                    String address = request.getParameter("address");
                    String specialization = request.getParameter("specialization");

                    if (("Doctor".equals(roleSession) || "Nurse".equals(roleSession)) && (specialization == null || specialization.trim().isEmpty())) {
            %>
                        <div class="error">Specialization is required for Doctors and Nurses</div>
            <%
                    } else {
                        Connection conn = null;
                        PreparedStatement pstmt = null;
                        ResultSet rs = null;
                        try {
                            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                            conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;databaseName=projectSwpIter1;user=sa;password=123456");

                            // Get data from PendingUsers
                            String sql = "SELECT * FROM PendingUsers WHERE Username = ?";
                            pstmt = conn.prepareStatement(sql);
                            pstmt.setString(1, username);
                            rs = pstmt.executeQuery();

                            if (rs.next()) {
                                String email = rs.getString("Email");
                                String password = rs.getString("Password");

                                // Insert into Users
                                sql = "INSERT INTO Users (Username, Email, [Password], FullName, Dob, Gender, Phone, [Address], Specialization, [Role]) " +
                                      "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                                pstmt = conn.prepareStatement(sql);
                                pstmt.setString(1, username);
                                pstmt.setString(2, email);
                                pstmt.setString(3, password);
                                pstmt.setString(4, fullName);
                                pstmt.setString(5, dob);
                                pstmt.setString(6, gender);
                                pstmt.setString(7, phone);
                                pstmt.setString(8, address);
                                if ("Doctor".equals(roleSession) || "Nurse".equals(roleSession)) {
                                    pstmt.setString(9, specialization);
                                } else {
                                    pstmt.setNull(9, java.sql.Types.NVARCHAR);
                                }
                                pstmt.setString(10, roleSession);
                                pstmt.executeUpdate();

                                // Delete from PendingUsers
                                sql = "DELETE FROM PendingUsers WHERE Username = ?";
                                pstmt = conn.prepareStatement(sql);
                                pstmt.setString(1, username);
                                pstmt.executeUpdate();

                                response.sendRedirect("dashboard.jsp");
                            }
                        } catch (Exception e) {
            %>
                            <div class="error">Error: <%= e.getMessage() %></div>
            <%
                        } finally {
                            if (rs != null) rs.close();
                            if (pstmt != null) pstmt.close();
                            if (conn != null) conn.close();
                        }
                    }
                }
            %>
        </div>
    </div>
</body>
</html>
