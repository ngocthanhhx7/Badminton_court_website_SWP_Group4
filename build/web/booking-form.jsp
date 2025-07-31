<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="models.UserDTO, models.AdminDTO, models.GoogleAccount" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!doctype html>
<html class="no-js" lang="zxx">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>BadmintonHub - Book Court Schedules</title>
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
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
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
                background: linear-gradient(45deg, #fcedc9, #dbaa32);
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
            .schedule-item {
                background: white;
                border: 2px solid #e9ecef;
                border-radius: 15px;
                padding: 25px;
                margin-bottom: 20px;
                transition: all 0.3s ease;
                box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            }
            .schedule-item:hover {
                border-color: #667eea;
                box-shadow: 0 8px 25px rgba(102, 126, 234, 0.15);
                transform: translateY(-2px);
            }
            .court-header {
                display: flex;
                align-items: center;
                justify-content: space-between;
                margin-bottom: 15px;
                flex-wrap: wrap;
            }
            .court-name {
                font-size: 1.4rem;
                font-weight: 700;
                color: #2c3e50;
                margin: 0;
            }
            .court-type {
                background: linear-gradient(45deg, #78350f, #a0522d);
                color: white;
                padding: 6px 15px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
                text-transform: uppercase;
            }
            .schedule-details {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 15px;
                margin-bottom: 15px;
            }
            .detail-item {
                display: flex;
                align-items: center;
                color: #555;
                padding: 10px;
                background: #f8f9fa;
                border-radius: 8px;
            }
            .detail-item i {
                color: #667eea;
                margin-right: 10px;
                width: 18px;
                text-align: center;
            }
            .detail-label {
                font-weight: 600;
                margin-right: 8px;
            }
            .time-display {
                background: linear-gradient(45deg, #667eea, #764ba2);
                color: white;
                padding: 8px 16px;
                border-radius: 20px;
                font-weight: 600;
                font-size: 14px;
                display: inline-block;
            }
            .date-display {
                background: linear-gradient(45deg, #28a745, #20c997);
                color: white;
                padding: 8px 16px;
                border-radius: 20px;
                font-weight: 600;
                font-size: 14px;
                display: inline-block;
            }
            .status-badge {
                padding: 8px 16px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
                text-transform: uppercase;
            }
            .status-available {
                background: #d4edda;
                color: #155724;
            }
            .status-booked {
                background: #f8d7da;
                color: #721c24;
            }
            .status-maintenance {
                background: #fff3cd;
                color: #856404;
            }
            .price-info {
                background: linear-gradient(45deg, #28a745, #20c997);
                color: white;
                padding: 20px;
                border-radius: 15px;
                text-align: center;
                margin-bottom: 25px;
            }
            .booking-summary {
                background: linear-gradient(45deg, #17a2b8, #138496);
                color: white;
                padding: 25px;
                border-radius: 15px;
                margin-bottom: 25px;
            }
            .summary-item {
                display: flex;
                justify-content: space-between;
                margin-bottom: 12px;
                padding-bottom: 12px;
                border-bottom: 1px solid rgba(255,255,255,0.2);
            }
            .summary-item:last-child {
                border-bottom: none;
                margin-bottom: 0;
                font-weight: 700;
                font-size: 1.2rem;
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
            .schedules-list {
                max-height: 500px;
                overflow-y: auto;
                margin-bottom: 25px;
            }
            .no-schedules {
                text-align: center;
                padding: 80px 20px;
                color: #6c757d;
            }
            .no-schedules i {
                font-size: 5rem;
                color: #f39c12;
                margin-bottom: 30px;
            }
            .court-image {
                width: 80px;
                height: 60px;
                object-fit: cover;
                border-radius: 8px;
                margin-right: 15px;
            }
            @media (max-width: 768px) {
                .court-header {
                    flex-direction: column;
                    align-items: flex-start;
                    gap: 10px;
                }
                .schedule-details {
                    grid-template-columns: 1fr;
                }
                .court-type {
                    margin-top: 10px;
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
        <!-- bradcam_area_start -->
        <div class="bradcam_area breadcam_bg_2">
            <h3>Book Court Schedules</h3>
        </div>
        <!-- bradcam_area_end -->
        <!-- Booking Form Section -->
        <div class="booking-container mt-10">
            <div class="container-fluid" style="margin-top: 120px;">
                <div class="row justify-content-center">
                    <div class="col-lg-10">
                        <div class="booking-card">
                            <div class="booking-header">
                                <h2><i class="fa fa-calendar"></i> Book Court Schedules</h2>
                                <p>Reserve your selected court time slots</p>
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
                                
                                <c:choose>
                                    <c:when test="${not empty courtSchedules}">
                                        <!-- Court Schedules Information -->
                                        <div class="mb-4">
                                            <h4><i class="fa fa-list"></i> Selected Court Schedules (${courtSchedules.size()} time slots)</h4>
                                            <div class="schedules-list">
                                                <c:forEach var="schedule" items="${courtSchedules}" varStatus="status">
                                                    <div class="schedule-item">
                                                        <div class="court-header">
                                                            <div class="d-flex align-items-center">
                                                                <c:if test="${not empty schedule.courtDTO.courtImage}">
                                                                    <img src="${schedule.courtDTO.courtImage}" 
                                                                         alt="${schedule.courtDTO.courtName}" 
                                                                         class="court-image">
                                                                </c:if>
                                                                <div>
                                                                    <h5 class="court-name">
                                                                        <i class="fa fa-map-marker"></i> 
                                                                        <c:choose>
                                                                            <c:when test="${not empty schedule.courtName}">
                                                                                ${schedule.courtName}
                                                                            </c:when>
                                                                            <c:when test="${not empty schedule.courtDTO.courtName}">
                                                                                ${schedule.courtDTO.courtName}
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                Court #${schedule.courtId}
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </h5>
                                                                    <c:if test="${not empty schedule.courtType or not empty schedule.courtDTO.courtType}">
                                                                        <div class="court-type">
                                                                            <i class="fa fa-tag"></i> 
                                                                            <c:choose>
                                                                                <c:when test="${not empty schedule.courtType}">
                                                                                    ${schedule.courtType}
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    ${schedule.courtDTO.courtType}
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </div>
                                                                    </c:if>
                                                                </div>
                                                            </div>
                                                            <span class="status-badge 
                                                                <c:choose>
                                                                    <c:when test='${schedule.status eq "Available"}'>status-available</c:when>
                                                                    <c:when test='${schedule.status eq "Booked"}'>status-booked</c:when>
                                                                    <c:otherwise>status-maintenance</c:otherwise>
                                                                </c:choose>">
                                                                ${schedule.status}
                                                            </span>
                                                        </div>
                                                        
                                                        <div class="schedule-details">
                                                            <div class="detail-item">
                                                                <i class="fa fa-calendar"></i>
                                                                <span class="detail-label">Date:</span>
                                                                <span class="date-display">${schedule.scheduleDate}</span>
                                                            </div>
                                                            <div class="detail-item">
                                                                <i class="fa fa-clock-o"></i>
                                                                <span class="detail-label">Time:</span>
                                                                <span class="time-display">
                                                                    <c:choose>
                                                                        <c:when test="${not empty schedule.startTimeStr and not empty schedule.endTimeStr}">
                                                                            ${schedule.startTimeStr} - ${schedule.endTimeStr}
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            ${schedule.startTime} - ${schedule.endTime}
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </span>
                                                            </div>
                                                            <div class="detail-item">
                                                                <i class="fa fa-money"></i>
                                                                <span class="detail-label">Price:</span>
                                                                <span class="price-value">${schedule.price} VND</span>
                                                            </div>
                                                            <c:if test="${schedule.holiday}">
                                                                <div class="detail-item">
                                                                    <i class="fa fa-star"></i>
                                                                    <span class="detail-label">Holiday Rate</span>
                                                                    <span class="badge badge-warning">Special Rate</span>
                                                                </div>
                                                            </c:if>
                                                        </div>
                                                        
                                                        <c:if test="${not empty schedule.courtDTO.description}">
                                                            <div class="mt-2">
                                                                <small class="text-muted">
                                                                    <i class="fa fa-info-circle"></i> ${schedule.courtDTO.description}
                                                                </small>
                                                            </div>
                                                        </c:if>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </div>
                                        
                                      
                                        <!-- Booking Summary -->
                                        <div class="booking-summary">
                                            <h5 class="text-center mb-3">
                                                <i class="fa fa-calculator"></i> Booking Summary
                                            </h5>
                                            <div class="summary-item">
                                                <span>Number of Time Slots:</span>
                                                <span>${courtSchedules.size()}</span>
                                            </div>
                                            <div class="summary-item">
                                                <span>Price per Slot:</span>
                                                <span>${sum} VND</span>
                                            </div>
                                            <div class="summary-item">
                                                <span>Duration per Slot:</span>
                                                <span>1 Hour</span>
                                            </div>
                                            <div class="summary-item">
                                                <span><strong>Total Amount:</strong></span>
                                                <span><strong class="total-amount" data-schedules="${sum}">
                                                    <script>
                                                        document.write((${sum}).toLocaleString('vi-VN') + ' VND');
                                                    </script>
                                                </strong></span>
                                            </div>
                                        </div>
                                        
                                        <!-- Booking Form -->
                                        <form action="/SWP_Project/vnpayajax" method="post" id="bookingForm">
                                            <input type="hidden" name="action" value="create">
                                            <input type="hidden" name="courtScheduleIds" value="${courtScheduleIds}">
                                            <input type="hidden" name="totalAmount" value="${sum}">
                                            
                                            <div class="form-group">
                                                <label class="form-label">
                                                    <i class="fa fa-comment"></i> Notes (Optional)
                                                </label>
                                                <textarea name="notes" class="form-control" rows="3"
                                                           placeholder="Any special requests or notes for your booking..."></textarea>
                                            </div>
                                            
                                            <div class="form-group">
                                                <button type="submit" class="btn-book">
                                                    <i class="fa fa-credit-card"></i> Proceed to Payment
                                                    <span class="payment-amount">
                                                        (<script>document.write((${sum}).toLocaleString('vi-VN'));</script> VND)
                                                    </span>
                                                </button>
                                            </div>
                                        </form>
                                        
                                        <!-- Action Buttons -->
                                        <div class="text-center mt-3">
                                            <a href="court" class="btn btn-outline-secondary">
                                                <i class="fa fa-arrow-left"></i> Back to Courts
                                            </a>
<!--                                            <a href="CartServlet" class="btn btn-outline-primary ml-2">
                                                <i class="fa fa-shopping-cart"></i> View Cart
                                            </a>-->
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <!-- No Schedules Selected -->
                                        <div class="no-schedules">
                                            <i class="fa fa-calendar-times-o"></i>
                                            <h4>No Court Schedules Selected</h4>
                                            <p>Please select court time slots from our courts listing or add them to your cart to make a booking.</p>
                                            <div class="mt-4">
                                                <a href="court" class="btn btn-primary mr-2">
                                                    <i class="fa fa-search"></i> Browse Courts
                                                </a>
<!--                                                <a href="CartServlet" class="btn btn-outline-primary">
                                                    <i class="fa fa-shopping-cart"></i> View Cart
                                                </a>-->
                                            </div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- footer -->
        <footer class="footer">
            <div class="footer_top">
                <div class="container">
                    <div class="row">
                        <div class="col-xl-3 col-md-6 col-lg-3">
                            <div class="footer_widget">
                                <h3 class="footer_title">address</h3>
                                <p class="footer_text">Khu công nghệ cao <br>Hòa Lạc, Hà Nội</p>
                                <a href="#" class="line-button">Get Direction</a>
                            </div>
                        </div>
                        <div class="col-xl-3 col-md-6 col-lg-3">
                            <div class="footer_widget">
                                <h3 class="footer_title">Reservation</h3>
                                <p class="footer_text">+10 367 267 2678 <br>thanhnnhe186491@fpt.edu.vn</p>
                            </div>
                        </div>
                        <div class="col-xl-2 col-md-6 col-lg-2">
                            <div class="footer_widget">
                                <h3 class="footer_title">Navigation</h3>
                                <ul>
                                    <li><a href="./home">Home</a></li>
                                    <li><a href="./court">Courts</a></li>
                                    <li><a href="about.jsp">About</a></li>
                                    <li><a href="blog.jsp">News</a></li>
                                </ul>
                            </div>
                        </div>
                        <div class="col-xl-4 col-md-6 col-lg-4">
                            <div class="footer_widget">
                                <h3 class="footer_title">Newsletter</h3>
                                <form action="#" class="newsletter_form">
                                    <input type="text" placeholder="Enter your mail">
                                    <button type="submit">Sign Up</button>
                                </form>
                                <p class="newsletter_text">Subscribe newsletter to get updates</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="copy-right_text">
                <div class="container">
                    <div class="footer_border"></div>
                    <div class="row">
                        <div class="col-xl-8 col-md-7 col-lg-9">
                            <p class="copy_right">
                                Copyright &copy;<script>document.write(new Date().getFullYear());</script> All rights reserved
                            </p>
                        </div>
                        <div class="col-xl-4 col-md-5 col-lg-3">
                            <div class="socail_links">
                                <ul>
                                    <li><a href="#"><i class="fa fa-facebook-square"></i></a></li>
                                    <li><a href="#"><i class="fa fa-twitter"></i></a></li>
                                    <li><a href="#"><i class="fa fa-instagram"></i></a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </footer>
        
        <!-- JS here -->
        <script src="js/vendor/modernizr-3.5.0.min.js"></script>
        <script src="js/vendor/jquery-1.12.4.min.js"></script>
        <script src="js/popper.min.js"></script>
        <script src="js/bootstrap.min.js"></script>
        
        <script>
            $(document).ready(function() {
                // Add animation to schedule items
                $('.schedule-item').each(function(index) {
                    $(this).delay(index * 150).fadeIn(600);
                });
                
                // Add loading state to booking form
                $('#bookingForm').on('submit', function() {
                    var button = $(this).find('button[type="submit"]');
                    var originalText = button.html();
                    button.prop('disabled', true).html('<i class="fa fa-spinner fa-spin"></i> Processing Payment...');
                    
                    // Re-enable button after 5 seconds in case of error
                    setTimeout(function() {
                        button.prop('disabled', false).html(originalText);
                    }, 5000);
                });
                
                // Auto-hide alerts
                setTimeout(function() {
                    $('.alert').fadeOut();
                }, 5000);
                
                // Smooth scroll for long lists
                $('.schedules-list').on('scroll', function() {
                    var scrollTop = $(this).scrollTop();
                    var scrollHeight = $(this)[0].scrollHeight;
                    var height = $(this).height();
                    
                    if (scrollTop + height >= scrollHeight - 10) {
                        // Near bottom - could load more if needed
                    }
                });
            });
        </script>
    </body>
</html>