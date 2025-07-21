<%@ page import="dao.BookingDAO" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Biểu đồ doanh thu theo ngày</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 30px;
            background-color: #f9f9f9;
            position: relative;
        }

        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 30px;
        }

        .chart-container {
            width: 100%;
            max-width: 1200px;
            margin: auto;
        }

        canvas {
            width: 100% !important;
            height: 500px !important;
        }

        .back-button {
            position: absolute;
            top: 20px;
            left: 30px;
        }

        .back-button button {
            padding: 10px 20px;
            background-color: #2196F3;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 14px;
            cursor: pointer;
        }

        .back-button button:hover {
            background-color: #1976D2;
        }
    </style>
</head>
<body>

<!-- Nút quay lại -->
<div class="back-button">
    <form action="view-revenue.jsp" method="get">
        <button type="submit">⬅️ Danh sách Booking</button>
    </form>
</div>

<h2>📊 Biểu đồ doanh thu theo ngày</h2>

<div class="chart-container">
    <canvas id="revenueChart"></canvas>
</div>

<%
    BookingDAO dao = new BookingDAO();
    Map<String, Double> revenueMap = dao.getRevenueByDate();

    List<String> labels = new ArrayList<>(revenueMap.keySet());
    List<Double> values = new ArrayList<>(revenueMap.values());
%>

<script>
    const labels = <%= labels.toString().replace("[", "['").replace("]", "']").replace(", ", "', '") %>;
    const data = <%= values.toString() %>;

    const ctx = document.getElementById('revenueChart').getContext('2d');
    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [{
                label: 'Doanh thu (VNĐ)',
                data: data,
                backgroundColor: '#4CAF50',
                borderColor: '#388E3C',
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        callback: function(value) {
                            return value.toLocaleString('vi-VN') + ' ₫';
                        }
                    }
                }
            }
        }
    });
</script>

</body>
</html>
