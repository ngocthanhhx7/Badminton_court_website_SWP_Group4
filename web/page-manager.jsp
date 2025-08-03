<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Page Manager - Badminton Hub</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- base:css -->
    <link rel="stylesheet" href="vendors/typicons.font/font/typicons.css">
    <link rel="stylesheet" href="vendors/css/vendor.bundle.base.css">
    <!-- endinject -->
    
    <!-- inject:css -->
    <link rel="stylesheet" href="css/vertical-layout-light/style.css">
    <!-- endinject -->
    
    <link rel="shortcut icon" href="img/favicon.png" />
</head>
<body>
    <div class="container-scroller">
        <!-- Header -->
        <jsp:include page="header-manager.jsp" />
        
        <!-- Main Panel -->
        <div class="main-panel">
            <div class="content-wrapper">
                <div class="container-fluid px-4 py-3">
                    <div class="row">
                        <div class="col-12">
                            <h2 class="mb-4">Quản lý trang</h2>
                            
                            <!-- Navigation Cards -->
                            <div class="row">
                                <div class="col-md-4 mb-4">
                                    <div class="card shadow-sm h-100">
                                        <div class="card-body text-center">
                                            <i class="typcn typcn-chart-line-outline" style="font-size: 3rem; color: #007bff;"></i>
                                            <h5 class="card-title mt-3">Thống kê hệ thống</h5>
                                            <p class="card-text">Xem thống kê tổng quan về hệ thống</p>
                                            <a href="AdminStatisticsController" class="btn btn-primary">Xem thống kê</a>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="col-md-4 mb-4">
                                    <div class="card shadow-sm h-100">
                                        <div class="card-body text-center">
                                            <i class="typcn typcn-calendar-outline" style="font-size: 3rem; color: #28a745;"></i>
                                            <h5 class="card-title mt-3">Quản lý lịch sân</h5>
                                            <p class="card-text">Quản lý lịch đặt sân và booking</p>
                                            <a href="scheduler-manager" class="btn btn-success">Quản lý lịch</a>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="col-md-4 mb-4">
                                    <div class="card shadow-sm h-100">
                                        <div class="card-body text-center">
                                            <i class="typcn typcn-user-outline" style="font-size: 3rem; color: #ffc107;"></i>
                                            <h5 class="card-title mt-3">Quản lý người dùng</h5>
                                            <p class="card-text">Quản lý tài khoản người dùng</p>
                                            <a href="user-manager" class="btn btn-warning">Quản lý người dùng</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Additional Management Options -->
                            <div class="row mt-4">
                                <div class="col-md-6 mb-4">
                                    <div class="card shadow-sm h-100">
                                        <div class="card-body text-center">
                                            <i class="typcn typcn-cog-outline" style="font-size: 3rem; color: #6c757d;"></i>
                                            <h5 class="card-title mt-3">Cài đặt hệ thống</h5>
                                            <p class="card-text">Cấu hình các thông số hệ thống</p>
                                            <a href="system-settings" class="btn btn-secondary">Cài đặt</a>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="col-md-6 mb-4">
                                    <div class="card shadow-sm h-100">
                                        <div class="card-body text-center">
                                            <i class="typcn typcn-document-text-outline" style="font-size: 3rem; color: #dc3545;"></i>
                                            <h5 class="card-title mt-3">Báo cáo</h5>
                                            <p class="card-text">Xem các báo cáo chi tiết</p>
                                            <a href="reports" class="btn btn-danger">Xem báo cáo</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
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
</body>
</html> 