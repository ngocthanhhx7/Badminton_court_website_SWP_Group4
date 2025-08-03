<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Payment Result - Debug</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header">
                        <h3>Payment Result - Debug Mode</h3>
                    </div>
                    <div class="card-body">
                        <!-- Debug Information -->
                        <h5>Debug Information:</h5>
                        <ul>
                            <li><strong>Message:</strong> ${message}</li>
                            <li><strong>Error:</strong> ${error}</li>
                            <li><strong>Booking ID:</strong> ${bookingId}</li>
                            <li><strong>Amount:</strong> ${amount}</li>
                            <li><strong>Payment Method:</strong> ${paymentMethod}</li>
                            <li><strong>Transaction No:</strong> ${transactionNo}</li>
                        </ul>
                        
                        <!-- URL Parameters -->
                        <h5>URL Parameters:</h5>
                        <ul>
                            <li><strong>vnp_Amount:</strong> ${param.vnp_Amount}</li>
                            <li><strong>vnp_ResponseCode:</strong> ${param.vnp_ResponseCode}</li>
                            <li><strong>vnp_TxnRef:</strong> ${param.vnp_TxnRef}</li>
                            <li><strong>vnp_TransactionNo:</strong> ${param.vnp_TransactionNo}</li>
                            <li><strong>vnp_BankCode:</strong> ${param.vnp_BankCode}</li>
                        </ul>
                        
                        <!-- Booking Object -->
                        <h5>Booking Information:</h5>
                        <c:choose>
                            <c:when test="${not empty booking}">
                                <ul>
                                    <li><strong>Booking ID:</strong> ${booking.bookingId}</li>
                                    <li><strong>Customer ID:</strong> ${booking.customerId}</li>
                                    <li><strong>Status:</strong> ${booking.status}</li>
                                    <li><strong>Created At:</strong> ${booking.createdAt}</li>
                                </ul>
                            </c:when>
                            <c:otherwise>
                                <p><em>No booking object found in request attributes</em></p>
                            </c:otherwise>
                        </c:choose>
                        
                        <!-- Success/Error Messages -->
                        <div class="mt-4">
                            <c:if test="${not empty message}">
                                <div class="alert alert-success">
                                    <i class="fas fa-check-circle"></i> ${message}
                                </div>
                            </c:if>
                            
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger">
                                    <i class="fas fa-exclamation-triangle"></i> ${error}
                                </div>
                            </c:if>
                        </div>
                        
                        <!-- Actions -->
                        <div class="mt-4 text-center">
                            <a href="booking?action=my-bookings" class="btn btn-primary">
                                View My Bookings
                            </a>
                            <a href="court" class="btn btn-secondary ms-2">
                                Book Another Court
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
