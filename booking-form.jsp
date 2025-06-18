<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="models.UserDTO, models.AdminDTO, models.GoogleAccount" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!doctype html>
<html class="no-js" lang="zxx">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>BadmintonHub - Book Court</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon" href="img/favicon.png">

    <!-- CSS here -->
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="css/owl.carousel.min.css">
    <link rel="stylesheet" href="css/magnific-popup.css">
    <link rel="stylesheet" href="css/font-awesome.min.css">
    <link rel="stylesheet" href="css/themify-icons.css">
    <link rel="stylesheet" href="css/nice-select.css">
    <link rel="stylesheet" href="css/flaticon.css">
    <link rel="stylesheet" href="css/gijgo.css">
    <link rel="stylesheet" href="css/animate.css">
    <link rel="stylesheet" href="css/slicknav.css">
    <link rel="stylesheet" href="css/style.css">

    <script src="https://cdn.tailwindcss.com"></script>
    
    <style>
        .booking-container {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 40px 0;
        }
        
        .booking-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            overflow: hidden;
            margin-bottom: 30px;
        }
        
        .booking-header {
            background: linear-gradient(45deg, #78350f, #a0522d);
            color: white;
            padding: 30px;
            text-align: center;
        }
        
        .booking-form {
            padding: 40px;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-label {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 8px;
            display: block;
        }
        
        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e9ecef;
            border-radius: 10px;
            font-size: 16px;
            transition: all 0.3s ease;
        }
        
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
            outline: none;
        }
        
        .btn-book {
            background: linear-gradient(45deg, #667eea, #764ba2);
            border: none;
            color: white;
            padding: 15px 40px;
            border-radius: 25px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
            width: 100%;
            font-size: 16px;
        }
        
        .btn-book:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
            color: white;
        }
        
        .court-info {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
        }
        
        .price-info {
            background: linear-gradient(45deg, #28a745, #20c997);
            color: white;
            padding: 15px;
            border-radius: 10px;
            text-align: center;
            margin-bottom: 20px;
        }
        
        .booking-details {
            background: linear-gradient(45deg, #17a2b8, #138496);
            color: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        
        .detail-item {
            background: rgba(255,255,255,0.1);
            padding: 15px;
            border-radius: 8px;
            text-align: center;
        }
        
        .detail-label {
            font-size: 14px;
            opacity: 0.8;
            margin-bottom: 5px;
        }
        
        .detail-value {
            font-size: 18px;
            font-weight: 600;
        }
        
        .alert {
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        
        .alert-danger {
            background: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
        }
        
        .alert-success {
            background: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
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

    <!-- Booking Form Section -->
    <div class="booking-container mt-10">
        <div class="container-fluid" style="margin-top: 120px;">
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="booking-card">
                        <div class="booking-header">
                            <h2><i class="fa fa-calendar"></i> Book Your Court</h2>
                            <p>Reserve your badminton court for the perfect game</p>
                        </div>
                        
                        <div class="booking-form mt-5">
                            <!-- Error/Success Messages -->
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger">
                                    <i class="fa fa-exclamation-triangle"></i> ${error}
                                </div>
                            </c:if>
                            
                            <c:if test="${not empty success}">
                                <div class="alert alert-success">
                                    <i class="fa fa-check-circle"></i> ${success}
                                </div>
                            </c:if>
                            
                            <c:if test="${not empty court}">
                                <!-- Court Information -->
                                <div class="court-info">
                                    <h4><i class="fa fa-map-marker"></i> ${court.courtName}</h4>
                                    <p><strong>Type:</strong> ${court.courtType}</p>
                                    <p><strong>Status:</strong> 
                                        <span class="badge badge-success">${court.status}</span>
                                    </p>
                                    <c:if test="${not empty court.description}">
                                        <p><strong>Description:</strong> ${court.description}</p>
                                    </c:if>
                                </div>
                                
                                <!-- Price Information -->
                                <div class="price-info">
                                    <h5><i class="fa fa-money"></i> 100,000 VND / Hour</h5>
                                    <small>Standard rate for all courts</small>
                                </div>
                                
                                <!-- Booking Details Display -->
                                <c:if test="${not empty selectedDate}">
                                    <div class="booking-details">
                                        <h5 class="text-center mb-3">
                                            <i class="fa fa-info-circle"></i> Selected Booking Details
                                        </h5>
                                        <div class="row">
                                            <div class="col-md-4">
                                                <div class="detail-item">
                                                    <div class="detail-label">Date</div>
                                                    <div class="detail-value">
                                                        <fmt:parseDate value="${selectedDate}" pattern="yyyy-MM-dd" var="parsedDate" type="date" />
                                                        <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy" />
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="detail-item">
                                                    <div class="detail-label">Start Time</div>
                                                    <div class="detail-value">${selectedStartTime}</div>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="detail-item">
                                                    <div class="detail-label">End Time</div>
                                                    <div class="detail-value">${selectedEndTime}</div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                                
                                <!-- Booking Form -->
                                <form action="/SWP_Project/vnpayajax" method="post" id="bookingForm">
                                    <input type="hidden" name="action" value="create">
                                    <input type="hidden" name="courtId" value="${court.courtId}">
                                    <input type="hidden" name="bookingDate" value="${selectedDate}">
                                    <input type="hidden" name="startTime" value="${selectedStartTime}">
                                    <input type="hidden" name="endTime" value="${selectedEndTime}">
                                    <input type="hidden" name="courtScheduleId" value="${courtScheduleId}">
                                    
                                    <div class="form-group">
                                        <label class="form-label">
                                            <i class="fa fa-comment"></i> Notes (Optional)
                                        </label>
                                        <textarea name="notes" class="form-control" rows="3" 
                                                placeholder="Any special requests or notes..."></textarea>
                                    </div>
                                    
                                    <div class="form-group">
                                        <button type="submit" class="btn-book">
                                            <i class="fa fa-credit-card"></i> Proceed to Payment
                                        </button>
                                    </div>
                                </form>
                            </c:if>
                            
                            <!-- No Court Selected -->
                            <c:if test="${empty court}">
                                <div class="text-center">
                                    <i class="fa fa-exclamation-triangle" style="font-size: 4rem; color: #f39c12; margin-bottom: 20px;"></i>
                                    <h4>No Court Selected</h4>
                                    <p>Please select a court from our courts listing to make a booking.</p>
                                    <a href="court" class="btn btn-primary">
                                        <i class="fa fa-arrow-left"></i> Browse Courts
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

    <!-- JS here -->
    <script src="js/vendor/modernizr-3.5.0.min.js"></script>
    <script src="js/vendor/jquery-1.12.4.min.js"></script>
    <script src="js/popper.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
</body>
</html>