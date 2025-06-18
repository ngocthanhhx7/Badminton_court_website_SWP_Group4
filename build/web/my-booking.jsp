<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="models.UserDTO, models.AdminDTO, models.GoogleAccount" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!doctype html>
<html class="no-js" lang="zxx">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>BadmintonHub - My Bookings</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon" href="img/favicon.png">

    <!-- CSS here -->
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="css/font-awesome.min.css">
    <link rel="stylesheet" href="css/style.css">

    <script src="https://cdn.tailwindcss.com"></script>
    
    <style>
        .bookings-container {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            padding: 40px 0;
        }
        
        .bookings-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            overflow: hidden;
            margin-bottom: 30px;
        }
        
        .bookings-header {
            background: linear-gradient(45deg, #667eea, #764ba2);
            color: white;
            padding: 30px;
            text-align: center;
        }
        
        .booking-item {
            border: 1px solid #e9ecef;
            border-radius: 10px;
            margin-bottom: 20px;
            overflow: hidden;
            transition: all 0.3s ease;
        }
        
        .booking-item:hover {
            border-color: #667eea;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .booking-header {
            background: #f8f9fa;
            padding: 15px 20px;
            border-bottom: 1px solid #e9ecef;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .booking-id {
            font-weight: 600;
            color: #2c3e50;
        }
        
        .booking-status {
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .status-pending {
            background: #fff3cd;
            color: #856404;
            border: 1px solid #ffeaa7;
        }
        
        .status-confirmed {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .status-completed {
            background: #d1ecf1;
            color: #0c5460;
            border: 1px solid #bee5eb;
        }
        
        .status-cancelled {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .booking-details {
            padding: 20px;
        }
        
        .booking-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 15px;
        }
        
        .info-item {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .info-icon {
            color: #667eea;
            width: 16px;
        }
        
        .booking-actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        
        .btn-action {
            padding: 8px 16px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 500;
            text-decoration: none;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
        }
        
        .btn-view {
            background: #17a2b8;
            color: white;
        }
        
        .btn-view:hover {
            background: #138496;
            color: white;
        }
        
        .btn-cancel {
            background: #dc3545;
            color: white;
        }
        
        .btn-cancel:hover {
            background: #c82333;
            color: white;
        }
        
        .btn-rebook {
            background: #28a745;
            color: white;
        }
        
        .btn-rebook:hover {
            background: #218838;
            color: white;
        }
        
        .no-bookings {
            text-align: center;
            padding: 60px 20px;
            color: #6c757d;
        }
        
        .booking-notes {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            margin-top: 15px;
            border-left: 4px solid #667eea;
        }
        
        .booking-date {
            font-size: 14px;
            color: #6c757d;
        }
        
        @media (max-width: 768px) {
            .booking-header {
                flex-direction: column;
                gap: 10px;
                text-align: center;
            }
            
            .booking-info {
                grid-template-columns: 1fr;
            }
            
            .booking-actions {
                justify-content: center;
            }
        }
    </style>
</head>

<body>
    <!-- header-start -->
    <%
        String accType = (String) session.getAttribute("accType");
        if (accType == null) {
    %>
    <jsp:include page="header.jsp" />
    <%
        } else if ("admin".equals(accType)) {
    %>
    <jsp:include page="header-auth.jsp" />
    <%
        } else if ("user".equals(accType) || "google".equals(accType)) {
    %>
    <jsp:include page="header-user.jsp" />
    <%
        }
    %>
    <!-- header-end -->

    <!-- My Bookings Section -->
    <div class="bookings-container">
        <div class="container">
            <div class="row">
                <div class="col-12">
                    <div class="bookings-card">
                        <div class="bookings-header">
                            <h2><i class="fa fa-list"></i> My Bookings</h2>
                            <p>Manage your court reservations</p>
                        </div>
                        
                        <div style="padding: 30px;">
                            <c:if test="${not empty bookings}">
                                <c:forEach var="booking" items="${bookings}">
                                    <div class="booking-item">
                                        <div class="booking-header">
                                            <div>
                                                <div class="booking-id">
                                                    <i class="fa fa-ticket"></i> Booking #${booking.bookingId}
                                                </div>
                                                <div class="booking-date">
                                                    <fmt:formatDate value="${booking.createdAt}" pattern="MMM dd, yyyy 'at' HH:mm" />
                                                </div>
                                            </div>
                                            <div class="booking-status status-${booking.status.toLowerCase()}">
                                                ${booking.status}
                                            </div>
                                        </div>
                                        
                                        <div class="booking-details">
                                            <div class="booking-info">
                                                <div class="info-item">
                                                    <i class="fa fa-user info-icon"></i>
                                                    <span>${booking.customerName}</span>
                                                </div>
                                                <div class="info-item">
                                                    <i class="fa fa-envelope info-icon"></i>
                                                    <span>${booking.customerEmail}</span>
                                                </div>
                                                <div class="info-item">
                                                    <i class="fa fa-phone info-icon"></i>
                                                    <span>${booking.customerPhone}</span>
                                                </div>
                                                <div class="info-item">
                                                    <i class="fa fa-calendar info-icon"></i>
                                                    <span>
                                                        <fmt:formatDate value="${booking.createdAt}" pattern="EEEE, MMMM dd, yyyy" />
                                                    </span>
                                                </div>
                                            </div>
                                            
                                            <c:if test="${not empty booking.notes}">
                                                <div class="booking-notes">
                                                    <strong><i class="fa fa-comment"></i> Notes:</strong>
                                                    <p style="margin: 5px 0 0 0;">${booking.notes}</p>
                                                </div>
                                            </c:if>
                                            
                                            <div class="booking-actions">
                                                <a href="booking-details?id=${booking.bookingId}" class="btn-action btn-view">
                                                    <i class="fa fa-eye"></i> View Details
                                                </a>
                                                
                                                <c:if test="${booking.status == 'Pending' || booking.status == 'Confirmed'}">
                                                    <button onclick="cancelBooking(${booking.bookingId})" class="btn-action btn-cancel">
                                                        <i class="fa fa-times"></i> Cancel
                                                    </button>
                                                </c:if>
                                                
                                                <c:if test="${booking.status == 'Completed' || booking.status == 'Cancelled'}">
                                                    <a href="booking?courtId=${booking.courtId}" class="btn-action btn-rebook">
                                                        <i class="fa fa-refresh"></i> Book Again
                                                    </a>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:if>
                            
                            <c:if test="${empty bookings}">
                                <div class="no-bookings">
                                    <i class="fa fa-calendar-times-o" style="font-size: 4rem; color: #dee2e6; margin-bottom: 20px;"></i>
                                    <h4>No Bookings Found</h4>
                                    <p>You haven't made any court reservations yet.</p>
                                    <a href="court" class="btn btn-primary" style="margin-top: 20px;">
                                        <i class="fa fa-plus"></i> Make Your First Booking
                                    </a>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- footer -->
    <jsp:include page="footer.jsp" />

    <!-- JS here -->
    <script src="js/vendor/jquery-1.12.4.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script src="js/main.js"></script>
    
    <script>
        function cancelBooking(bookingId) {
            if (confirm('Are you sure you want to cancel this booking?')) {
                // Send AJAX request to cancel booking
                fetch('booking-cancel', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'bookingId=' + bookingId
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert('Booking cancelled successfully!');
                        location.reload();
                    } else {
                        alert('Failed to cancel booking: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('An error occurred while cancelling the booking.');
                });
            }
        }
        
        // Auto-refresh every 2 minutes to show updated booking status
        setInterval(function() {
            location.reload();
        }, 120000);
    </script>
</body>
</html>