<%-- 
    Document   : view-invoice-details
    Created on : Jun 18, 2025, 10:10:14 AM
    Author     : HP
--%>
<%-- 
    Document   : view-invoice-details
    Created on : Jun 18, 2025, 10:10:14 AM
    Author     : HP
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="models.InvoiceDetailView" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    List<InvoiceDetailView> invoiceDetails = (List<InvoiceDetailView>) request.getAttribute("invoiceDetails");
    int currentPage = (Integer) request.getAttribute("currentPage");
    int totalPages = (Integer) request.getAttribute("totalPages");
    String keyword = (String) request.getAttribute("keyword");

    request.setAttribute("invoiceDetails", invoiceDetails);
    request.setAttribute("currentPage", currentPage);
    request.setAttribute("totalPages", totalPages);
    request.setAttribute("keyword", keyword);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Invoice Details</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(to right, #f0f2f5, #e6f0ff);
            margin: 30px;
        }

        h2 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 30px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background-color: #fff;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            border-radius: 10px;
            overflow: hidden;
        }

        th {
            background-color: #3498db;
            color: white;
            padding: 12px;
        }

        td {
            padding: 10px;
            border-bottom: 1px solid #ddd;
            text-align: center;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        tr:hover {
            background-color: #f1f1f1;
        }

        .pagination {
            margin-top: 25px;
            text-align: center;
        }

        .pagination a {
            padding: 8px 15px;
            margin: 0 5px;
            text-decoration: none;
            border-radius: 6px;
            color: #333;
            background-color: #e0e0e0;
            transition: 0.3s;
        }

        .pagination a.active {
            background-color: #ff9800;
            color: white;
            font-weight: bold;
        }

        .pagination a:hover {
            background-color: #ffcc80;
        }

        .search-box {
            text-align: center;
            margin-bottom: 30px;
        }

        .search-box input[type="text"] {
            padding: 8px 12px;
            width: 280px;
            border: 1px solid #ccc;
            border-radius: 6px;
            outline: none;
        }

        .search-box button {
            padding: 8px 16px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 6px;
            margin-left: 5px;
            cursor: pointer;
        }

        .search-box button:hover {
            background-color: #218838;
        }

        .search-box a {
            padding: 8px 16px;
            background-color: #6c757d;
            color: white;
            text-decoration: none;
            border-radius: 6px;
            margin-left: 10px;
        }

        .search-box a:hover {
            background-color: #5a6268;
        }

        #totalBox {
            text-align: right;
            margin-top: 15px;
            font-size: 18px;
            font-weight: bold;
        }

        #printBtn {
            margin-top: 20px;
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            float: right;
        }

        #printBtn:hover {
            background-color: #0056b3;
        }
    </style>

    <script>
        function updateTotal() {
            let checkboxes = document.querySelectorAll(".subtotalCheck");
            let total = 0;
            checkboxes.forEach(cb => {
                if (cb.checked) {
                    total += parseFloat(cb.dataset.subtotal);
                }
            });
            document.getElementById("totalValue").innerText = total.toFixed(2);
        }

        function printSelected() {
            const selectedIDs = Array.from(document.querySelectorAll(".subtotalCheck:checked"))
                .map(cb => cb.value);
            if (selectedIDs.length === 0) {
                alert("Vui lòng chọn ít nhất một hóa đơn để in.");
                return;
            }
            // Gửi lên server hoặc mở trang in mới
            alert("In các hóa đơn có ID: " + selectedIDs.join(", "));
            // window.location.href = 'print-invoice?ids=' + selectedIDs.join(',');
        }
    </script>
</head>
<body>

<h2>Invoice Details - Page ${currentPage}</h2>

<div class="search-box">
    <form method="get" action="view-invoice-details" style="display: inline-block;">
        <input type="text" name="keyword" placeholder="Search by Customer Name" value="${keyword}" />
        <button type="submit">🔍 Search</button>
        <a href="invoice-statistics" style="background-color:#ffc107;">📊 Thống kê</a>

    </form>
    <a href="view-invoice-details">↩️ Quay về</a>
</div>

<form id="invoiceForm">
    <table>
        <tr>
            <th>✔</th>
            <th>ID</th>
            <th>InvoiceID</th>
            <th>Type</th>
            <th>ItemID</th>
            <th>ItemName</th>
            <th>Qty</th>
            <th>Unit Price</th>
            <th>Subtotal</th>
            <th>Status</th>
            <th>Customer Name</th>
            <th>Username</th>
        </tr>
        <c:forEach var="item" items="${invoiceDetails}">
            <tr>
                <td>
                    <input type="checkbox"
                           class="subtotalCheck"
                           value="${item.invoiceDetailID}"
                           data-subtotal="${item.subtotal}"
                           onclick="updateTotal()" />
                </td>
                <td>${item.invoiceDetailID}</td>
                <td>${item.invoiceID}</td>
                <td>${item.itemType}</td>
                <td>${item.itemID}</td>
                <td>${item.itemName}</td>
                <td>${item.quantity}</td>
                <td>${item.unitPrice}</td>
                <td>${item.subtotal}</td>
                <td>${item.status}</td>
                <td>${item.customerName}</td>
                <td>${item.username}</td>
            </tr>
        </c:forEach>
    </table>
</form>

<div id="totalBox">Tổng Subtotal đã chọn: <span id="totalValue">0.00</span> ₫</div>

<button id="printBtn" onclick="printSelected()">🖨️ In Hóa Đơn</button>

<div class="pagination" style="clear: both;">
    <c:if test="${currentPage > 1}">
        <a href="view-invoice-details?page=${currentPage - 1}&keyword=${keyword}">« Prev</a>
    </c:if>
    <c:forEach var="i" begin="1" end="${totalPages}">
        <a href="view-invoice-details?page=${i}&keyword=${keyword}" class="${i == currentPage ? 'active' : ''}">${i}</a>
    </c:forEach>
    <c:if test="${currentPage < totalPages}">
        <a href="view-invoice-details?page=${currentPage + 1}&keyword=${keyword}">Next »</a>
    </c:if>
</div>

</body>
</html>



















