<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Kết Quả Thanh Toán | Badminton Hub</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .result-container {
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 2rem 0;
        }
        .result-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            backdrop-filter: blur(10px);
            background: rgba(255,255,255,0.95);
        }
        .success-icon {
            font-size: 4rem;
            color: #28a745;
            margin-bottom: 1rem;
        }
        .error-icon {
            font-size: 4rem;
            color: #dc3545;
            margin-bottom: 1rem;
        }
        .amount-display {
            font-size: 2rem;
            font-weight: bold;
            color: #007bff;
        }
        .transaction-info {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 1.5rem;
            margin: 1rem 0;
        }
        .info-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.5rem;
        }
        .info-label {
            font-weight: 600;
            color: #6c757d;
        }
        .info-value {
            font-weight: 500;
            color: #495057;
        }
        .action-buttons {
            gap: 1rem;
        }
        .btn-custom {
            border-radius: 25px;
            padding: 0.75rem 2rem;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .btn-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
    </style>
</head>
<body>
    <div class="result-container">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-8 col-lg-6">
                    <div class="card result-card">
                        <div class="card-body text-center p-5">
                            <c:choose>
                                <c:when test="${not empty error}">
                                    <!-- Error State -->
                                    <i class="fas fa-times-circle error-icon"></i>
                                    <h2 class="text-danger mb-3">Thanh Toán Thất Bại</h2>
                                    <div class="alert alert-danger">
                                        <i class="fas fa-exclamation-triangle me-2"></i>
                                        ${error}
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <!-- Success State -->
                                    <i class="fas fa-check-circle success-icon"></i>
                                    <h2 class="text-success mb-3">Thanh Toán Thành Công!</h2>
                                    <p class="lead text-muted mb-4">Đơn đặt sân của bạn đã được xác nhận thành công.</p>
                                    
                                    <!-- Amount Display -->
                                    <c:if test="${not empty amount}">
                                        <div class="amount-display mb-4">
                                            <fmt:formatNumber value="${amount}" type="currency" currencySymbol="₫" groupingUsed="true" />
                                        </div>
                                    </c:if>
                                </c:otherwise>
                            </c:choose>
                            
                            <!-- Transaction Information -->
                            <div class="transaction-info">
                                <h5 class="mb-3"><i class="fas fa-receipt me-2"></i>Thông Tin Giao Dịch</h5>
                                
                                <c:if test="${not empty transactionNo}">
                                    <div class="info-row">
                                        <span class="info-label">Mã Giao Dịch:</span>
                                        <span class="info-value">${transactionNo}</span>
                                    </div>
                                </c:if>
                                
                                <c:if test="${not empty vnpTxnRef}">
                                    <div class="info-row">
                                        <span class="info-label">Mã Tham Chiếu:</span>
                                        <span class="info-value">${vnpTxnRef}</span>
                                    </div>
                                </c:if>
                                
                                <c:if test="${not empty paymentMethod}">
                                    <div class="info-row">
                                        <span class="info-label">Phương Thức:</span>
                                        <span class="info-value">${paymentMethod}</span>
                                    </div>
                                </c:if>
                                
                                <c:if test="${not empty param.vnp_BankCode}">
                                    <div class="info-row">
                                        <span class="info-label">Ngân Hàng:</span>
                                        <span class="info-value">${param.vnp_BankCode}</span>
                                    </div>
                                </c:if>
                                
                                <div class="info-row">
                                    <span class="info-label">Thời Gian:</span>
                                    <span class="info-value">
                                        <fmt:formatDate value="<%= new java.util.Date() %>" pattern="dd/MM/yyyy HH:mm:ss"/>
                                    </span>
                                </div>
                            </div>
                            
                            <!-- Success Message -->
                            <c:if test="${not empty message and empty error}">
                                <div class="alert alert-success border-0">
                                    <i class="fas fa-info-circle me-2"></i>
                                    ${message}
                                </div>
                            </c:if>
                            
                            <!-- Action Buttons -->
                            <div class="d-flex flex-column flex-sm-row justify-content-center action-buttons mt-4">
                                <a href="booking?action=my-bookings" class="btn btn-primary btn-custom">
                                    <i class="fas fa-calendar-check me-2"></i>
                                    Xem Lịch Đặt Sân
                                </a>
                                <a href="court" class="btn btn-outline-primary btn-custom">
                                    <i class="fas fa-plus-circle me-2"></i>
                                    Đặt Sân Mới
                                </a>
                            </div>
                            
                            <!-- Support Info -->
                            <div class="mt-4 pt-3 border-top">
                                <small class="text-muted">
                                    <i class="fas fa-phone me-1"></i>
                                    Cần hỗ trợ? Liên hệ: <strong>1900-BADMINTON</strong>
                                </small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
