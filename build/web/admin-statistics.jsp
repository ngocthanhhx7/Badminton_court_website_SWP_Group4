<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.StatsDTO, models.DailyRevenueDTO" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thống kê hệ thống</title>

    <!-- Bootstrap & Chart CSS/JS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.3.0/dist/chart.umd.min.js"></script>

    <!-- base:css -->
    <link rel="stylesheet" href="vendors/typicons.font/font/typicons.css">
    <link rel="stylesheet" href="vendors/css/vendor.bundle.base.css">
    <!-- endinject -->

    <!-- inject:css -->
    <link rel="stylesheet" href="css/vertical-layout-light/style.css">
    <!-- endinject -->

    <link rel="shortcut icon" href="img/favicon.png" />

    <style>
        #revenueChart {
            width:100% !important;
            height:400px !important;
        }
        #hoverInfo {
            font-style:italic;
            color:#007bff;
            margin-top:.5rem;
        }
    </style>
</head>
<body>
    <div class="container-scroller">
        <%-- Sidebar / Header Navigation --%>
        <jsp:include page="header-manager.jsp" />

        <!-- Main Panel -->
        <div class="main-panel">
            <div class="content-wrapper">
                <div class="container-fluid px-4 py-3">
                    <h2 class="mb-4">Thống kê hệ thống</h2>

                    <!-- Form lọc ngày -->
                    <form class="row g-3 align-items-end mb-4" method="get" action="AdminStatisticsController">
                        <div class="col-auto">
                            <label for="fromDate" class="form-label">Từ ngày</label>
                            <input type="date"
                                   id="fromDate" name="fromDate"
                                   class="form-control"
                                   value="${fn:substringBefore(stats.fromDateTime,'T')}">
                        </div>
                        <div class="col-auto">
                            <label for="toDate" class="form-label">Đến ngày</label>
                            <input type="date"
                                   id="toDate" name="toDate"
                                   class="form-control"
                                   value="${fn:substringBefore(stats.toDateTime,'T')}">
                        </div>
                        <div class="col-auto">
                            <button type="submit" class="btn btn-primary">Lọc</button>
                        </div>
                    </form>

                    <!-- Cards thống kê -->
                    <div class="row text-center gy-4 mb-4">
                        <c:set var="s" value="${stats}" />
                        <div class="col-md-3">
                            <div class="card shadow-sm"><div class="card-body">
                                    <h6 class="card-title">Tổng số sân</h6>
                                    <p class="display-6">${s.totalCourts}</p>
                                </div></div>
                        </div>
                        <div class="col-md-3">
                            <div class="card shadow-sm"><div class="card-body">
                                    <h6 class="card-title">Sân Single</h6>
                                    <p class="display-6">${s.singleCourtCount}</p>
                                </div></div>
                        </div>
                        <div class="col-md-3">
                            <div class="card shadow-sm"><div class="card-body">
                                    <h6 class="card-title">Sân Double</h6>
                                    <p class="display-6">${s.doubleCourtCount}</p>
                                </div></div>
                        </div>
                        <div class="col-md-3">
                            <div class="card shadow-sm"><div class="card-body">
                                    <h6 class="card-title">Sân VIP</h6>
                                    <p class="display-6">${s.vipCourtCount}</p>
                                </div></div>
                        </div>
                        <div class="col-md-4">
                            <div class="card shadow-sm"><div class="card-body">
                                    <h6 class="card-title">Tổng bài viết</h6>
                                    <p class="display-6">${s.totalPosts}</p>
                                </div></div>
                        </div>
                        <div class="col-md-4">
                            <div class="card shadow-sm"><div class="card-body">
                                    <h6 class="card-title">Tổng bình luận</h6>
                                    <p class="display-6">${s.totalComments}</p>
                                </div></div>
                        </div>
                    </div>

                    <!-- Doanh thu -->
                    <div class="alert alert-info">
                        <strong>Tổng doanh thu:</strong>
                        <fmt:formatNumber value="${s.totalRevenue}" type="number" groupingUsed="true"/> VNĐ
                    </div>

                    <!-- Biểu đồ doanh thu -->
                    <div class="mt-4">
                        <h5>
                            Doanh thu từ 
                            ${fn:substringBefore(stats.fromDateTime,'T')} 
                            đến 
                            ${fn:substringBefore(stats.toDateTime,'T')}
                        </h5>
                        <canvas id="revenueChart"></canvas>
                        <div id="hoverInfo"></div>
                    </div>
                </div>
            </div>
        </div>
        <!-- main-panel ends -->
    </div>
    <!-- container-scroller ends -->

    <!-- base:js -->
    <script src="vendors/js/vendor.bundle.base.js"></script>
    <!-- endinject -->

    <!-- inject:js -->
    <script src="js/off-canvas.js"></script>
    <script src="js/hoverable-collapse.js"></script>
    <script src="js/template.js"></script>
    <script src="js/settings.js"></script>
    <script src="js/todolist.js"></script>
    <!-- endinject -->

    <!-- Chart rendering -->
    <script>
        const labels = [
            <c:forEach var="dr" items="${s.dailyRevenues}" varStatus="st">
                '${dr.date}'<c:if test="${!st.last}">,</c:if>
            </c:forEach>
        ];
        const data = [
            <c:forEach var="dr" items="${s.dailyRevenues}" varStatus="st">
                ${dr.subtotal}<c:if test="${!st.last}">,</c:if>
            </c:forEach>
        ];

        const ctx = document.getElementById('revenueChart').getContext('2d');
        new Chart(ctx, {
            type: 'line',
            data: {
                labels,
                datasets: [{
                    label: 'Doanh thu (VNĐ)',
                    data,
                    borderColor: '#007bff',
                    backgroundColor: '#007bff33',
                    borderWidth: 2,
                    tension: 0.1,
                    fill: true,
                    pointRadius: v => v.raw === 0 ? 0 : 4,
                    pointHoverRadius: v => v.raw === 0 ? 0 : 6
                }]
            },
            options: {
                responsive: true,
                scales: {
                    x: {
                        title: {display: true, text: 'Ngày'},
                        ticks: {maxRotation: 45, minRotation: 45}
                    },
                    y: {
                        title: {display: true, text: 'Doanh thu (VNĐ)'},
                        beginAtZero: true
                    }
                },
                plugins: {
                    legend: {position: 'top'},
                    tooltip: {
                        filter: item => item.parsed.y !== 0,
                        callbacks: {
                            label: ctx => `Doanh thu: ${ctx.parsed.y.toLocaleString()} VNĐ`
                        }
                    }
                },
                onHover: (event, elements) => {
                    const info = document.getElementById('hoverInfo');
                    if (elements.length) {
                        const i = elements[0].index, d = labels[i], v = data[i];
                        info.textContent = `Ngày ${d}: ${v.toLocaleString()} VNĐ`;
                    } else {
                        info.textContent = '';
                    }
                }
            }
        });
    </script>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
