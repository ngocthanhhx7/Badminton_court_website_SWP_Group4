<%-- 
    Document   : invoice-statistics
    Created on : Jun 18, 2025, 4:54:20 PM
    Author     : HP
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <title>Thống kê hóa đơn</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f5f5f5;
            margin: 30px;
        }

        h2 {
            text-align: center;
            color: #2c3e50;
        }

        table {
            width: 60%;
            margin: 30px auto;
            border-collapse: collapse;
            background-color: white;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }

        th, td {
            padding: 12px;
            border: 1px solid #ccc;
            text-align: center;
        }

        th {
            background-color: #007bff;
            color: white;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        a.back {
            display: block;
            width: 200px;
            margin: auto;
            margin-top: 20px;
            text-align: center;
            background-color: #6c757d;
            color: white;
            padding: 10px;
            border-radius: 6px;
            text-decoration: none;
        }

        a.back:hover {
            background-color: #5a6268;
        }
    </style>
</head>
<body>
<h2>📊 Thống kê số lượng theo ItemName</h2>

<table>
    <tr>
        <th>Item Name</th>
        <th>Tổng số lượng</th>
    </tr>
    <c:forEach var="entry" items="${itemQtyStats}">
        <tr>
            <td>${entry.key}</td>
            <td>${entry.value}</td>
        </tr>
    </c:forEach>
</table>


    <a href="view-invoice-details" class="back">↩️ Quay về danh sách hóa đơn</a>
</body>
</html>
