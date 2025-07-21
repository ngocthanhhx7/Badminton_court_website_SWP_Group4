<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.BookingDAO" %>
<%@ page import="models.BookingView" %>
<%@ page import="java.util.*, java.text.SimpleDateFormat" %>

<%
    String phone = request.getParameter("phone");
    BookingDAO dao = new BookingDAO();
    List<BookingView> list = (phone != null && !phone.trim().isEmpty())
        ? dao.getBookingViewsByPhone(phone.trim())
        : dao.getAllBookingViews();

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
    double totalSubtotal = 0;
%>

<html>
<head>
    <title>Danh sách Booking</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f2f2f2;
            margin: 0;
            padding: 30px;
        }
        .banner {
            background: linear-gradient(90deg, #007BFF, #00C6FF);
            padding: 20px;
            border-radius: 10px;
            text-align: center;
            color: white;
            font-size: 28px;
            font-weight: bold;
            margin-bottom: 30px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
            letter-spacing: 1px;
        }
        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
        }
        .search-form {
            text-align: center;
            margin-bottom: 25px;
        }
        .search-form form {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
        }
        .search-form input[type="text"] {
            padding: 10px;
            width: 250px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        .search-form input[type="submit"] {
            padding: 10px 16px;
            background-color: #28a745;
            border: none;
            color: white;
            border-radius: 4px;
            cursor: pointer;
        }
        .search-form input[type="submit"]:hover {
            background-color: #218838;
        }
        .revenue-button {
            padding: 10px 16px;
            background-color: #17a2b8;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            font-size: 14px;
            font-weight: bold;
            transition: background-color 0.3s ease;
        }
        .revenue-button:hover {
            background-color: #138496;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background-color: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }
        th, td {
            padding: 12px 15px;
            border: 1px solid #ddd;
            text-align: center;
        }
        th {
            background-color: #343a40;
            color: white;
        }
        tr:hover {
            background-color: #f1f1f1;
        }
        .status-form select {
            padding: 6px 10px;
            border-radius: 4px;
        }
        .status-form input[type="submit"] {
            padding: 6px 12px;
            margin-left: 8px;
            background-color: #ffc107;
            border: none;
            color: white;
            border-radius: 4px;
            cursor: pointer;
        }
        .status-form input[type="submit"]:hover {
            background-color: #e0a800;
        }
        .back-button {
            text-align: center;
            margin-top: 30px;
        }
        .back-button button {
            padding: 12px 20px;
            font-size: 16px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }
        .back-button button:hover {
            background-color: #0056b3;
        }
        .total-row {
            font-weight: bold;
            background-color: #e9f7ef;
        }
        .message {
            text-align: center;
            color: red;
            font-weight: bold;
            margin-top: 10px;
        }
    </style>
</head>
<body>

<div class="banner">
    🏸 HỆ THỐNG QUẢN LÝ ĐẶT SÂN CẦU LÔNG 🏸
</div>

<h2>Danh sách Booking</h2>

<div class="search-form">
    <form method="get">
        <label>Tìm theo số điện thoại:</label>
        <input type="text" name="phone" value="<%= phone != null ? phone : "" %>" />
        <input type="submit" value="Tìm kiếm" />
        <a href="revenueChart.jsp" class="revenue-button">📊 Thống kê</a>
    </form>

    <%-- In hóa đơn nếu có kết quả --%>
    <% if (phone != null && !phone.trim().isEmpty() && !list.isEmpty()) { %>
        <div style="margin-top: 15px;">
            <form method="get" action="invoice.jsp" target="_blank">
                <input type="hidden" name="phone" value="<%= phone.trim() %>" />
                <input type="submit" value="🖨 In hóa đơn" class="revenue-button" style="background-color:#dc3545;" />
            </form>
        </div>
    <% } %>

    <%-- Hiển thị nếu không có kết quả tìm kiếm --%>
    <% if (phone != null && !phone.trim().isEmpty() && list.isEmpty()) { %>
        <div class="message">
            ⚠️ Không tìm thấy đặt sân nào cho số điện thoại "<%= phone %>"
        </div>
    <% } %>
</div>

<% if (!list.isEmpty()) { %>
<table>
    <tr>
        <th>ID</th>
        <th>Khách hàng</th>
        <th>Điện thoại</th>
        <th>Email</th>
        <th>Sân</th>
        <th>Thời gian</th>
        <th>Số giờ</th>
        <th>Trạng thái</th>
        <th>Ghi chú</th>
        <th>Giá/giờ</th>
        <th>Tạm tính</th>
        <th>Cập nhật trạng thái</th>
    </tr>

<% for (BookingView b : list) {
       totalSubtotal += b.getSubtotal();
%>
    <tr>
        <td><%= b.getBookingID() %></td>
        <td><%= b.getCustomerName() %></td>
        <td><%= b.getPhone() %></td>
        <td><%= b.getEmail() %></td>
        <td><%= b.getCourtName() != null ? b.getCourtName() : "N/A" %></td>
        <td><%= b.getBookingTime() != null ? sdf.format(b.getBookingTime()) : "N/A" %></td>
        <td><%= b.getDurationHours() %></td>
        <td><%= b.getStatus() %></td>
        <td><%= b.getNoteDetails() != null ? b.getNoteDetails() : "" %></td>
        <td><%= String.format("%.2f", b.getHourlyRate()) %></td>
        <td><%= String.format("%.2f", b.getSubtotal()) %></td>
        <td>
            <form method="post" action="updateStatus.jsp" class="status-form">
                <input type="hidden" name="bookingID" value="<%= b.getBookingID() %>" />
                <select name="newStatus">
                    <option value="Đã đặt" <%= "Đã đặt".equals(b.getStatus()) ? "selected" : "" %>>Đã đặt</option>
                    <option value="Hoàn tất" <%= "Hoàn tất".equals(b.getStatus()) ? "selected" : "" %>>Hoàn tất</option>
                    <option value="Hủy" <%= "Hủy".equals(b.getStatus()) ? "selected" : "" %>>Hủy</option>
                </select>
                <input type="submit" value="Cập nhật" />
            </form>
        </td>
    </tr>
<% } %>

    <tr class="total-row">
        <td colspan="10" style="text-align: right;">Tổng cộng:</td>
        <td><%= String.format("%.2f", totalSubtotal) %></td>
        <td></td>
    </tr>
</table>
<% } %>

<div class="back-button">
    <button onclick="goBack()">Quay lại</button>
</div>

<script>
    function goBack() {
        window.history.back();
    }
</script>

</body>
</html>
