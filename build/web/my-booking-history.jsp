<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="models.UserDTO, models.AdminDTO, models.GoogleAccount" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!doctype html>
<html class="no-js" lang="zxx">
<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>BadmintonHub - My Booking History</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="shortcut icon" type="image/x-icon" href="img/favicon.png">
    <!-- CSS here -->
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="css/font-awesome.min.css">
    <link rel="stylesheet" href="css/style.css">
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <style>
        .booking-card {
            transition: all 0.3s ease;
            border-left: 4px solid #007bff;
            margin-bottom: 2rem;
            border-radius: 12px;
            overflow: hidden;
        }
        .booking-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
        }
        .status-badge {
            font-size: 0.75rem;
            padding: 0.4rem 1rem;
            border-radius: 25px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .status-confirmed { background-color: #d4edda; color: #155724; }
        .status-pending { background-color: #fff3cd; color: #856404; }
        .status-cancelled { background-color: #f8d7da; color: #721c24; }
        .status-completed { background-color: #d1ecf1; color: #0c5460; }
        
        .service-item {
            background-color: #f8f9fa;
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 0.75rem;
            border: 1px solid #e9ecef;
            transition: all 0.2s ease;
        }
        .service-item:hover {
            background-color: #e9ecef;
        }
        
        .court-info {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 10px;
            padding: 1.25rem;
            margin-bottom: 1rem;
            border: 1px solid #dee2e6;
        }
        
        .total-amount {
            background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
            color: white;
            padding: 1rem;
            border-radius: 10px;
            font-weight: bold;
            box-shadow: 0 4px 15px rgba(0, 123, 255, 0.3);
        }
        
        .booking-header {
            background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
            color: white;
            padding: 1.25rem;
            border-radius: 12px 12px 0 0;
        }
        
        .empty-state {
            text-align: center;
            padding: 5rem 2rem;
            color: #6c757d;
        }
        
        .btn-sm {
            padding: 0.5rem 1rem;
            font-size: 0.875rem;
            border-radius: 6px;
            font-weight: 500;
        }
        
        .card-body {
            padding: 2rem;
        }
        
        /* Fix button spacing */
        .d-flex.gap-2 > * {
            margin-right: 0.5rem;
            margin-bottom: 0.5rem;
        }
        .d-flex.gap-2 > *:last-child {
            margin-right: 0;
        }
        
        /* Responsive improvements */
        @media (max-width: 768px) {
            .booking-header .row {
                text-align: center;
            }
            .court-info .row {
                text-align: center;
            }
            .court-info .text-end {
                text-align: center !important;
                margin-top: 1rem;
            }
        }
        
        /* Breadcrumb styling */
        .breadcrumb {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 8px;
            padding: 0.75rem 1rem;
            margin-bottom: 0;
        }
        
        .breadcrumb-item a {
            color: #007bff;
            transition: color 0.3s ease;
        }
        
        .breadcrumb-item a:hover {
            color: #0056b3;
        }
    </style>
</head>

<body>
    <%
        UserDTO acc = (UserDTO) session.getAttribute("acc");
        AdminDTO admin = (AdminDTO) session.getAttribute("admin");
        GoogleAccount ggAcc = (GoogleAccount) session.getAttribute("ggAcc");
        
        if (acc == null && admin == null && ggAcc == null) {
            response.sendRedirect("Login.jsp");
            return;
        }
    %>

    <!-- Header -->
    <%@include file="header.jsp" %>

    <!-- Main content -->
    <main>
        <div class="container mt-5 pt-5">
            <div class="row">
                <div class="col-12">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2 class="fw-bold text-primary">
                            <i class="fa fa-calendar-check-o me-2"></i>
                            My Booking History
                        </h2>
                        
                        <!-- If admin/staff viewing specific customer -->
                        <c:if test="${not empty customerInfo}">
                            <div class="alert alert-info mb-0">
                                <i class="fa fa-user me-2"></i>
                                Viewing bookings for: <strong>${customerInfo.fullName}</strong> (${customerInfo.email})
                            </div>
                        </c:if>
                    </div>

                    <!-- Navigation Breadcrumb -->
                    <nav aria-label="breadcrumb" class="mb-4">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="index.jsp" class="text-decoration-none">Home</a></li>
                            <li class="breadcrumb-item"><a href="court" class="text-decoration-none">Courts</a></li>
                            <li class="breadcrumb-item active" aria-current="page">My Bookings</li>
                        </ol>
                    </nav>

                    <!-- Error/Success Messages -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show">
                            <i class="fa fa-exclamation-triangle me-2"></i>
                            ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty message}">
                        <div class="alert alert-info alert-dismissible fade show">
                            <i class="fa fa-info-circle me-2"></i>
                            ${message}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <!-- Admin/Staff Search Form -->
                    <c:if test="${currentUser.role == 'Admin' || currentUser.role == 'Staff'}">
                        <div class="card mb-4">
                            <div class="card-body">
                                <h5 class="card-title">Search Customer Bookings</h5>
                                <form method="get" action="booking" class="row g-3">
                                    <input type="hidden" name="action" value="my-bookings">
                                    <div class="col-md-8">
                                        <label for="customerId" class="form-label">Customer ID</label>
                                        <input type="number" class="form-control" id="customerId" name="customerId" 
                                               value="${param.customerId}" placeholder="Enter customer ID">
                                    </div>
                                    <div class="col-md-4 d-flex align-items-end">
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fa fa-search me-2"></i>Search
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </c:if>

                    <!-- Booking List -->
                    <c:choose>
                        <c:when test="${empty bookingList}">
                            <div class="empty-state">
                                <i class="fa fa-calendar-times-o fa-4x mb-3 text-muted"></i>
                                <h4>No Booking History Found</h4>
                                <p class="text-muted">You haven't made any bookings yet. Start by booking your first court!</p>
                                <a href="booking?action=show" class="btn btn-primary btn-lg mt-3">
                                    <i class="fa fa-plus me-2"></i>Book a Court Now
                                </a>
                            </div>
                        </c:when>
                        <c:otherwise>
                                            <div class="row">
                                                <c:forEach var="booking" items="${bookingList}">
                                                    <div class="col-12 mb-4">
                                                        <div class="card booking-card shadow-sm">
                                                            <!-- Booking Header -->
                                                            <div class="booking-header">
                                                                <div class="row align-items-center">
                                                                    <div class="col-md-8">
                                                                        <h5 class="mb-1">
                                                                            <i class="fa fa-ticket me-2"></i>
                                                                            Booking #${booking.bookingId}
                                                                        </h5>
                                                                        <small class="opacity-75">
                                                                            <i class="fa fa-clock-o me-1"></i>
                                                                            Created: ${booking.createdAtStr}
                                                                        </small>
                                                                    </div>
                                                                    <div class="col-md-4 text-md-end mt-2 mt-md-0">
                                                                        <span class="status-badge status-${booking.status.toLowerCase()}">
                                                                            ${booking.status}
                                                                        </span>
                                                                    </div>
                                                                </div>
                                                            </div>

                                            <div class="card-body">
                                                <!-- Customer Info (for admin/staff view) -->
                                                <c:if test="${currentUser.role == 'Admin' || currentUser.role == 'Staff'}">
                                                    <div class="alert alert-light">
                                                        <strong>Customer:</strong> ${booking.customerName}<br>
                                                        <strong>Email:</strong> ${booking.customerEmail}<br>
                                                        <strong>Phone:</strong> ${booking.customerPhone}
                                                    </div>
                                                </c:if>

                                                <!-- Booking Details -->
                                                <h6 class="text-primary mb-3">
                                                    <i class="fa fa-info-circle me-2"></i>Court Details
                                                </h6>
                                                
                                                <c:forEach var="detail" items="${booking.bookingDetails}">
                                                    <div class="court-info">
                                                        <div class="row align-items-center">
                                                            <div class="col-md-4">
                                                                <h6 class="mb-1">
                                                                    <i class="fa fa-map-marker me-2"></i>
                                                                    ${detail.courtName}
                                                                </h6>
                                                                <small class="text-muted">Type: ${detail.courtType}</small>
                                                            </div>
                                                            <div class="col-md-4">
                                                                <p class="mb-1">
                                                                    <i class="fa fa-clock-o me-1"></i>
                                                                    <strong>Time:</strong>
                                                                </p>
                                                                <small>${detail.startTimeStr} - ${detail.endTimeStr}</small>
                                                            </div>
                                                            <div class="col-md-4 text-end">
                                                                <p class="mb-1">
                                                                    <i class="fa fa-money me-1"></i>
                                                                    <strong>Rate:</strong> 
                                                                    <fmt:formatNumber value="${detail.hourlyRate}" type="currency" currencyCode="VND" />
                                                                </p>
                                                                <div class="text-primary fw-bold">
                                                                    <fmt:formatNumber value="${detail.subtotal}" type="currency" currencyCode="VND" />
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </c:forEach>

                                                <!-- Services -->
                                                <c:if test="${not empty booking.bookingServices}">
                                                    <h6 class="text-primary mb-3 mt-4">
                                                        <i class="fa fa-cogs me-2"></i>Additional Services
                                                    </h6>
                                                    <div class="row">
                                                        <c:forEach var="service" items="${booking.bookingServices}">
                                                            <div class="col-md-6 mb-2">
                                                                <div class="service-item">
                                                                    <div class="d-flex justify-content-between align-items-start">
                                                                        <div>
                                                                            <h6 class="mb-1">${service.serviceName}</h6>
                                                                            <small class="text-muted">${service.description}</small>
                                                                            <br>
                                                                            <small class="text-info">
                                                                                Quantity: ${service.quantity} ${service.unit}
                                                                            </small>
                                                                        </div>
                                                                        <div class="text-end">
                                                                            <div class="fw-bold">
                                                                                <fmt:formatNumber value="${service.subtotal}" type="currency" currencyCode="VND" />
                                                                            </div>
                                                                            <small class="text-muted">
                                                                                @ <fmt:formatNumber value="${service.unitPrice}" type="currency" currencyCode="VND" />/${service.unit}
                                                                            </small>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </c:forEach>
                                                    </div>
                                                </c:if>

                                                <!-- Total Amount -->
                                                <div class="total-amount mt-3">
                                                    <div class="row align-items-center">
                                                        <div class="col">
                                                            <strong>Total Amount:</strong>
                                                        </div>
                                                        <div class="col-auto">
                                                            <h5 class="mb-0">
                                                                <c:set var="totalAmount" value="0" />
                                                                <c:forEach var="detail" items="${booking.bookingDetails}">
                                                                    <c:set var="totalAmount" value="${totalAmount + detail.subtotal}" />
                                                                </c:forEach>
                                                                <c:forEach var="service" items="${booking.bookingServices}">
                                                                    <c:set var="totalAmount" value="${totalAmount + service.subtotal}" />
                                                                </c:forEach>
                                                                <fmt:formatNumber value="${totalAmount}" type="currency" currencyCode="VND" />
                                                            </h5>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Notes -->
                                                <c:if test="${not empty booking.notes}">
                                                    <div class="mt-3">
                                                        <h6 class="text-primary">
                                                            <i class="fa fa-sticky-note me-2"></i>Notes
                                                        </h6>
                                                        <p class="text-muted">${booking.notes}</p>
                                                    </div>
                                                </c:if>

                                                <!-- Action Buttons -->
                                                <div class="mt-4">
                                                    <div class="d-flex flex-wrap gap-2">
                                                        <c:if test="${booking.canRating && booking.status == 'Completed'}">
                                                            <button class="btn btn-success btn-sm" onclick="openRatingModal('${booking.bookingId}')">
                                                                <i class="fa fa-star me-1"></i>Rate Experience
                                                            </button>
                                                        </c:if>
                                                        
                                                        <c:if test="${booking.cancel && booking.status == 'Pending'}">
                                                            <button class="btn btn-warning btn-sm" onclick="cancelBooking('${booking.bookingId}')">
                                                                <i class="fa fa-times me-1"></i>Cancel Booking
                                                            </button>
                                                        </c:if>
                                                        
                                                        <!-- Cancel Booking for Completed status -->
                                                        <c:if test="${booking.status == 'Completed'}">
                                                            <button class="btn btn-danger btn-sm" onclick="cancelBooking('${booking.bookingId}')">
                                                                <i class="fa fa-times me-1"></i>Cancel Booking
                                                            </button>
                                                        </c:if>
                                                    </div>
                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </main>

    <!-- Rating Modal -->
    <div class="modal fade" id="ratingModal" tabindex="-1" aria-labelledby="ratingModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title" id="ratingModalLabel">
                        <i class="fa fa-star me-2"></i>Rate Your Experience
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form id="ratingForm" method="post" action="booking?action=rating">
                    <div class="modal-body">
                        <input type="hidden" id="ratingBookingId" name="bookingId">
                        
                        <div class="text-center mb-4">
                            <h6 class="text-muted">How was your badminton experience?</h6>
                        </div>
                        
                        <div class="mb-4">
                            <label class="form-label text-center d-block mb-3">
                                <strong>Your Rating:</strong>
                            </label>
                            <div class="rating-stars d-flex justify-content-center">
                                <input type="radio" id="star5" name="rating" value="5" required>
                                <label for="star5" class="star">★</label>
                                <input type="radio" id="star4" name="rating" value="4">
                                <label for="star4" class="star">★</label>
                                <input type="radio" id="star3" name="rating" value="3">
                                <label for="star3" class="star">★</label>
                                <input type="radio" id="star2" name="rating" value="2">
                                <label for="star2" class="star">★</label>
                                <input type="radio" id="star1" name="rating" value="1">
                                <label for="star1" class="star">★</label>
                            </div>
                            <div class="text-center mt-2">
                                <small class="text-muted">Click to rate from 1 to 5 stars</small>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="noteDetails" class="form-label">
                                <strong>Your Comments</strong> <span class="text-muted">(Optional)</span>
                            </label>
                            <textarea class="form-control" id="noteDetails" name="noteDetails" rows="4" 
                                      placeholder="Tell us about your experience - court condition, service quality, facilities, etc."></textarea>
                            <div class="form-text">Your feedback helps us improve our services!</div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fa fa-times me-1"></i>Cancel
                        </button>
                        <button type="submit" class="btn btn-primary" id="submitRatingBtn">
                            <i class="fa fa-paper-plane me-1"></i>Submit Rating
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Custom Footer for Booking History Page -->
    <footer class="footer bg-dark text-white mt-5">
        <div class="container">
            <div class="row py-4">
                <div class="col-md-6">
                    <h5>BadmintonHub</h5>
                    <p class="text-muted">Your premier destination for badminton court bookings.</p>
                </div>
                <div class="col-md-6 text-md-end">
                    <div class="d-flex justify-content-md-end gap-3">
                        <a href="./home" class="text-decoration-none text-light">Home</a>
                        <a href="./court" class="text-decoration-none text-light">Courts</a>
                        <a href="./about" class="text-decoration-none text-light">About</a>
                        <a href="./contact" class="text-decoration-none text-light">Contact</a>
                    </div>
                </div>
            </div>
            <hr class="my-3">
            <div class="row">
                <div class="col-12 text-center">
                    <p class="mb-0 text-muted">&copy; 2025 BadmintonHub. All rights reserved.</p>
                </div>
            </div>
        </div>
    </footer>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function openRatingModal(bookingId) {
            document.getElementById('ratingBookingId').value = bookingId;
            var modal = new bootstrap.Modal(document.getElementById('ratingModal'));
            modal.show();
            
            // Reset form
            document.getElementById('ratingForm').reset();
            resetStars();
        }

        function cancelBooking(bookingId) {
            if (confirm('Are you sure you want to cancel this booking?\n\nNote: Cancellation may be subject to fees depending on the timing.')) {
                // Show loading state
                const button = event.target;
                const originalText = button.innerHTML;
                button.innerHTML = '<i class="fa fa-spinner fa-spin me-1"></i>Cancelling...';
                button.disabled = true;
                
                window.location.href = 'booking?action=cancel&draftId=' + bookingId;
            }
        }

        function viewBookingDetails(bookingId) {
            // Create a detailed modal or expand the current card
            alert('Detailed view for booking #' + bookingId + ' will be implemented in a future update.');
            // TODO: Implement detailed view modal
        }
        
        function rebookCourt(bookingId) {
            if (confirm('Would you like to book the same court again?')) {
                window.location.href = 'booking?action=rebook&bookingId=' + bookingId;
            }
        }

        // Star rating interaction with improved UX
        function resetStars() {
            const stars = document.querySelectorAll('.rating-stars label');
            stars.forEach(star => {
                star.style.color = '#e9ecef';
            });
        }

        document.addEventListener('DOMContentLoaded', function() {
            // Form validation for rating
            document.getElementById('ratingForm').addEventListener('submit', function(e) {
                const rating = document.querySelector('input[name="rating"]:checked');
                if (!rating) {
                    e.preventDefault();
                    alert('Please select a rating before submitting.');
                    return false;
                }
                
                // Show loading state
                const submitBtn = document.getElementById('submitRatingBtn');
                const originalText = submitBtn.innerHTML;
                submitBtn.innerHTML = '<i class="fa fa-spinner fa-spin me-1"></i>Submitting...';
                submitBtn.disabled = true;
                
                // Re-enable button after 5 seconds as fallback
                setTimeout(() => {
                    submitBtn.innerHTML = originalText;
                    submitBtn.disabled = false;
                }, 5000);
            });
            
            // Star rating interaction
            document.querySelectorAll('.rating-stars input[type="radio"]').forEach(radio => {
                radio.addEventListener('change', function() {
                    const stars = document.querySelectorAll('.rating-stars label');
                    const rating = parseInt(this.value);
                    
                    stars.forEach((star, index) => {
                        if (index >= 5 - rating) {
                            star.style.color = '#ffc107';
                        } else {
                            star.style.color = '#e9ecef';
                        }
                    });
                });
            });
            
            // Add hover effect for stars
            document.querySelectorAll('.rating-stars label').forEach((star, index) => {
                star.addEventListener('mouseenter', function() {
                    const stars = document.querySelectorAll('.rating-stars label');
                    const hoverRating = 5 - index;
                    
                    stars.forEach((s, i) => {
                        if (i >= 5 - hoverRating) {
                            s.style.color = '#ffc107';
                        } else {
                            s.style.color = '#e9ecef';
                        }
                    });
                });
            });
            
            // Reset stars on mouse leave
            document.querySelector('.rating-stars').addEventListener('mouseleave', function() {
                const checkedRadio = document.querySelector('.rating-stars input[type="radio"]:checked');
                if (checkedRadio) {
                    checkedRadio.dispatchEvent(new Event('change'));
                } else {
                    resetStars();
                }
            });
            
            // Auto-dismiss alerts after 5 seconds
            setTimeout(function() {
                const alerts = document.querySelectorAll('.alert-dismissible');
                alerts.forEach(alert => {
                    const bsAlert = new bootstrap.Alert(alert);
                    bsAlert.close();
                });
            }, 5000);
        });
    </script>

    <style>
        .rating-stars {
            display: flex;
            flex-direction: row-reverse;
            justify-content: center;
            gap: 8px;
            margin: 1rem 0;
        }
        
        .rating-stars input[type="radio"] {
            display: none;
        }
        
        .rating-stars label {
            font-size: 2.5rem;
            color: #e9ecef;
            cursor: pointer;
            transition: all 0.2s ease;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.1);
        }
        
        .rating-stars label:hover {
            transform: scale(1.1);
        }
        
        .rating-stars input[type="radio"]:checked ~ label,
        .rating-stars label:hover,
        .rating-stars label:hover ~ label {
            color: #ffc107;
            text-shadow: 2px 2px 4px rgba(255,193,7,0.3);
        }
        
        /* Improved modal styling */
        .modal-content {
            border-radius: 15px;
            border: none;
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
        }
        
        .modal-header {
            border-radius: 15px 15px 0 0;
            border-bottom: none;
            padding: 1.5rem;
        }
        
        .modal-body {
            padding: 2rem;
        }
        
        .modal-footer {
            border-top: 1px solid #e9ecef;
            padding: 1.5rem;
        }
    </style>
</body>
</html>
