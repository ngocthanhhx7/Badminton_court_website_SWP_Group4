<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="models.UserDTO, models.AdminDTO, models.GoogleAccount" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!doctype html>
<html class="no-js" lang="zxx">
<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>BadmintonHub - Booking History</title>
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
        }
        .booking-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }
        .status-badge {
            font-size: 0.75rem;
            padding: 0.25rem 0.75rem;
            border-radius: 50px;
            font-weight: 600;
            text-transform: uppercase;
        }
        .status-confirmed { background-color: #d4edda; color: #155724; }
        .status-pending { background-color: #fff3cd; color: #856404; }
        .status-cancelled { background-color: #f8d7da; color: #721c24; }
        .status-completed { background-color: #d1ecf1; color: #0c5460; }
        .detail-row {
            border-bottom: 1px solid #f8f9fa;
            padding: 0.75rem 0;
        }
        .detail-row:last-child {
            border-bottom: none;
        }
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            color: #6c757d;
        }
        .empty-state i {
            font-size: 4rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }
                
        /* Enhanced Rating Modal Styles */
        .rating-modal {
            z-index: 1060 !important;
        }
        .rating-modal .modal-backdrop {
            z-index: 1055 !important;
        }
        .rating-modal .modal-content {
            border-radius: 20px;
            border: none;
            box-shadow: 0 15px 35px rgba(0,0,0,0.1);
            z-index: 1065 !important;
            position: relative;
            overflow: hidden;
        }
        .rating-modal .modal-dialog {
            z-index: 1065 !important;
        }
        .rating-modal .modal-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 20px 20px 0 0;
            border-bottom: none;
            padding: 1.5rem;
        }
        
        /* Enhanced Star Rating Styles */
        .star-rating {
            display: flex;
            justify-content: center;
            gap: 8px;
            margin: 30px 0;
            z-index: 1070;
            position: relative;
        }
        
        .star {
            font-size: 3rem;
            color: #e0e0e0;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            user-select: none;
            z-index: 1070;
            position: relative;
            text-shadow: 0 2px 4px rgba(0,0,0,0.1);
            filter: drop-shadow(0 2px 4px rgba(0,0,0,0.1));
        }
        
        .star:hover {
            transform: scale(1.2) rotate(5deg);
            color: #ffd700;
            text-shadow: 0 0 20px rgba(255, 215, 0, 0.6);
            filter: drop-shadow(0 4px 8px rgba(255, 215, 0, 0.3));
        }
        
        .star.active {
            color: #ffd700;
            transform: scale(1.1);
            text-shadow: 0 0 15px rgba(255, 215, 0, 0.5);
            filter: drop-shadow(0 3px 6px rgba(255, 215, 0, 0.4));
        }
        
        .star.selected {
            color: #ffd700;
            transform: scale(1.1);
            text-shadow: 0 0 15px rgba(255, 215, 0, 0.5);
            animation: starPulse 0.6s ease-out;
        }
        
        @keyframes starPulse {
            0% {
                transform: scale(1.1);
            }
            50% {
                transform: scale(1.3);
            }
            100% {
                transform: scale(1.1);
            }
        }
        
        .rating-text {
            text-align: center;
            margin-top: 15px;
            font-weight: 600;
            color: #667eea;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            min-height: 30px;
        }
        
        .rating-description {
            text-align: center;
            margin-bottom: 20px;
            color: #6c757d;
            font-size: 0.95rem;
        }
        
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        
        .btn-rating {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 25px;
            padding: 12px 30px;
            font-weight: 600;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .btn-rating:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
        }
        
        .btn-rating:disabled {
            background: #6c757d;
            transform: none;
            box-shadow: none;
        }
        
        .btn-rating::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s;
        }
        
        .btn-rating:hover::before {
            left: 100%;
        }

        /* Cart Item Styles */
        .cart-item {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 10px;
            transition: all 0.3s ease;
        }
        .cart-item:hover {
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .cart-item-header {
            display: flex;
            justify-content: between;
            align-items: center;
            margin-bottom: 10px;
        }
        .delete-cart-btn {
            background: #dc3545;
            border: none;
            color: white;
            padding: 5px 10px;
            border-radius: 4px;
            font-size: 12px;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .delete-cart-btn:hover {
            background: #c82333;
            transform: scale(1.05);
        }
        
        /* Rating feedback messages */
        .rating-feedback {
            text-align: center;
            margin-top: 10px;
            font-style: italic;
            color: #6c757d;
            transition: all 0.3s ease;
            opacity: 0;
            transform: translateY(-10px);
        }
        
        .rating-feedback.show {
            opacity: 1;
            transform: translateY(0);
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
    <div class="bradcam_area breadcam_bg_1">
        <h3>Booking History</h3>
    </div>
    <!-- bradcam_area_end -->

    <!-- Booking History Section Start -->
    <div class="container" style="padding: 60px 0;">
        <div class="row">
            <div class="col-12">
                <div class="mb-4">
                    <h2 class="text-2xl font-bold text-gray-800 mb-2">Nếu bạn muốn hủy sân hay liên lạc với chúng tôi qua số điện thoại 0000000000</h2>
                    <p class="text-gray-600">View all your badminton court bookings and their details</p>
                </div>

                <!-- Success/Error Messages -->
                <c:if test="${not empty message}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fa fa-check-circle"></i> ${message}
                        <button type="button" class="close" data-dismiss="alert">
                            <span>&times;</span>
                        </button>
                    </div>
                </c:if>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fa fa-exclamation-circle"></i> ${error}
                        <button type="button" class="close" data-dismiss="alert">
                            <span>&times;</span>
                        </button>
                    </div>
                </c:if>

                <c:choose>
                    <c:when test="${empty bookingList}">
                        <!-- Empty State -->
                        <div class="empty-state">
                            <i class="fa fa-calendar-times-o"></i>
                            <h3>No Bookings Found</h3>
                            <p>You haven't made any bookings yet. Start by booking a court!</p>
                            <a href="./court" class="btn btn-primary mt-3">
                                <i class="fa fa-plus"></i> Book a Court
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- Booking Cards -->
                        <c:forEach var="booking" items="${bookingList}" varStatus="status">
                            <div class="booking-card bg-white rounded-lg shadow-md mb-4 overflow-hidden">
                                <!-- Booking Header -->
                                <div class="bg-gray-50 px-4 py-3 border-b">
                                    <div class="row align-items-center">
                                        <div class="col-md-6">
                                            <h5 class="mb-1 font-weight-bold">
                                                <i class="fa fa-bookmark text-primary"></i>
                                                Booking #${booking.bookingId}
                                            </h5>
                                            <small class="text-muted">
                                                <i class="fa fa-clock-o"></i>
                                                Created: ${booking.createdAtStr}
                                            </small>
                                        </div>
                                        <div class="col-md-6 text-md-right">
                                            <span class="status-badge status-${booking.status.toLowerCase()}">
                                                ${booking.status}
                                            </span>
                                        </div>
                                    </div>
                                </div>

                                <!-- Booking Content -->
                                <div class="p-4">
                                    <c:if test="${not empty booking.notes}">
                                        <div class="mb-3">
                                            <small class="text-muted">Notes:</small>
                                            <p class="mb-0 text-gray-700">${booking.notes}</p>
                                        </div>
                                    </c:if>

                                    <!-- Booking Details -->
                                    <c:if test="${not empty booking.bookingDetails}">
                                        <h6 class="font-weight-bold mb-3 text-gray-800">
                                            <i class="fa fa-list"></i> Booking Details
                                        </h6>
                                        
                                        <c:set var="totalAmount" value="0" />
                                        
                                        <c:forEach var="detail" items="${booking.bookingDetails}">
                                            <div class="detail-row">
                                                <div class="row align-items-center">
                                                    <div class="col-md-4">
                                                        <strong class="text-primary">${detail.courtName}</strong>
                                                        <br>
                                                        <small class="text-muted">${detail.courtType}</small>
                                                    </div>
                                                    <div class="col-md-4">
                                                        <i class="fa fa-clock-o text-muted"></i>
                                                        ${detail.startTimeStr}
                                                        <br>
                                                        <small class="text-muted">
                                                            ${detail.startTimeStr} - ${detail.endTimeStr}
                                                            (${detail.durationHours}h)
                                                        </small>
                                                    </div>
                                                    <div class="col-md-2 text-center">
                                                        <small class="text-muted">Rate</small><br>
                                                        <strong>$<fmt:formatNumber value="${detail.hourlyRate}" pattern="#,##0.00"/>/h</strong>
                                                    </div>
                                                    <div class="col-md-2 text-right">
                                                        <small class="text-muted">Subtotal</small><br>
                                                        <strong class="text-success">$<fmt:formatNumber value="${detail.subtotal}" pattern="#,##0.00"/></strong>
                                                    </div>
                                                </div>
                                            </div>
                                            <c:set var="totalAmount" value="${totalAmount + detail.subtotal}" />
                                        </c:forEach>

                                        <!-- Total Amount -->
                                        <div class="mt-3 pt-3 border-top">
                                            <div class="row">
                                                <div class="col-md-8">
                                                    <strong>Total Amount:</strong>
                                                </div>
                                                <div class="col-md-4 text-right">
                                                    <h5 class="text-success font-weight-bold mb-0">
                                                        $<fmt:formatNumber value="${totalAmount}" pattern="#,##0.00"/>
                                                    </h5>
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>
                                </div>

                                <!-- Booking Footer -->
                                <div class="bg-gray-50 px-4 py-3 border-top">
                                    <div class="row align-items-center">
                                        <div class="col-md-6">
                                            <c:if test="${not empty booking.updatedAt}">
                                                <small class="text-muted">
                                                    <i class="fa fa-refresh"></i>
                                                    Last updated: ${booking.updatedAtStr}
                                                </small>
                                            </c:if>
                                        </div>
                                       <div class="col-md-6 text-md-right">
                                            <c:if test="${booking.canRating}">
                                                <button class="btn btn-sm btn-outline-warning mr-2"
                                                        onclick="openRatingModal('${booking.bookingId}')"
                                                        data-bs-toggle="modal"
                                                        data-bs-target="#ratingModal">
                                                    <i class="fa fa-star"></i> Rate Booking
                                                </button>
                                            </c:if>

                                            <c:if test="${booking.cancel}">
                                                <form method="post" action="cancel-booking" style="display: inline;">
                                                    <input type="hidden" name="bookingId" value="${booking.bookingId}" />
                                                    <button type="submit" class="btn btn-sm btn-outline-danger">
                                                        <i class="fa fa-times"></i> Cancel Booking
                                                    </button>
                                                </form>
                                            </c:if>
                                        </div>

                                    </div>
                                </div>
                            </div>
                        </c:forEach>

                        <!-- Pagination (if needed) -->
                        <div class="text-center mt-4">
                            <p class="text-muted">Showing ${bookingList.size()} booking(s)</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    <!-- Booking History Section End -->

    <!-- Enhanced Rating Modal -->
    <div class="modal fade rating-modal" id="ratingModal" tabindex="-1" role="dialog" aria-labelledby="ratingModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="ratingModalLabel">
                        <i class="fa fa-star"></i> Rate Your Booking Experience
                    </h5>
                    <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <form id="ratingForm" method="post" action="booking">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="rating">
                        <input type="hidden" name="bookingId" id="modalBookingId">
                        <input type="hidden" name="rating" id="selectedRating" value="0">
                        
                        <div class="text-center mb-4">
                            <h6>How was your badminton court experience?</h6>
                            <p class="rating-description">Your feedback helps us improve our service</p>
                        </div>
                        
                        <!-- Enhanced Star Rating -->
                        <div class="star-rating">
                            <span class="star" data-rating="1">★</span>
                            <span class="star" data-rating="2">★</span>
                            <span class="star" data-rating="3">★</span>
                            <span class="star" data-rating="4">★</span>
                            <span class="star" data-rating="5">★</span>
                        </div>
                        
                        <div class="rating-text" id="ratingText">Click on stars to rate</div>
                        <div class="rating-feedback" id="ratingFeedback"></div>
                        
                        <!-- Comment Section -->
                        <div class="form-group mt-4">
                            <label for="noteDetails" class="font-weight-bold">
                                <i class="fa fa-comment"></i> Additional Comments (Optional)
                            </label>
                            <textarea class="form-control" name="noteDetails" id="noteDetails" rows="4"
                                       placeholder="Tell us more about your experience..."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">
                            <i class="fa fa-times"></i> Cancel
                        </button>
                        <button type="submit" class="btn btn-primary btn-rating" id="submitRating" disabled>
                            <i class="fa fa-paper-plane"></i> Submit Rating
                        </button>
                    </div>
                </form>
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
    <!-- footer_end -->

    <!-- JS here -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/vendor/modernizr-3.5.0.min.js"></script>
    <script src="js/vendor/jquery-1.12.4.min.js"></script>
    <script src="js/popper.min.js"></script>
    
    <script>
        // Rating feedback messages
        const ratingMessages = {
            1: "We're sorry to hear that. We'll work to improve!",
            2: "Thank you for your feedback. We'll do better!",
            3: "Thanks for rating! We appreciate your feedback.",
            4: "Great! We're glad you had a good experience.",
            5: "Excellent! Thank you for the amazing feedback!"
        };

        function openRatingModal(bookingId) {
            // Reset modal state
            document.getElementById('modalBookingId').value = bookingId;
            document.getElementById('selectedRating').value = 0;
            document.getElementById('ratingText').innerText = "Click on stars to rate";
            document.getElementById('submitRating').disabled = true;
            document.getElementById('noteDetails').value = '';
            
            // Clear all star states
            document.querySelectorAll('.star-rating .star').forEach(star => {
                star.classList.remove('selected', 'active');
            });
            
            // Hide feedback message
            const feedback = document.getElementById('ratingFeedback');
            feedback.classList.remove('show');
            feedback.innerText = '';
        }

        // Enhanced star rating functionality
        document.addEventListener('DOMContentLoaded', function() {
            const stars = document.querySelectorAll('.star-rating .star');
            const ratingText = document.getElementById('ratingText');
            const ratingFeedback = document.getElementById('ratingFeedback');
            const submitButton = document.getElementById('submitRating');
            let currentRating = 0;

            stars.forEach((star, index) => {
                // Mouse enter event
                star.addEventListener('mouseenter', function() {
                    const rating = parseInt(this.getAttribute('data-rating'));
                    highlightStars(rating);
                    updateRatingText(rating, false);
                });

                // Mouse leave event
                star.addEventListener('mouseleave', function() {
                    if (currentRating > 0) {
                        highlightStars(currentRating);
                        updateRatingText(currentRating, true);
                    } else {
                        clearStars();
                        ratingText.innerText = "Click on stars to rate";
                    }
                });

                // Click event
                star.addEventListener('click', function() {
                    const rating = parseInt(this.getAttribute('data-rating'));
                    currentRating = rating;
                    document.getElementById('selectedRating').value = rating;
                    
                    // Add selected class with animation
                    clearStars();
                    for (let i = 0; i < rating; i++) {
                        setTimeout(() => {
                            stars[i].classList.add('selected');
                        }, i * 100);
                    }
                    
                    updateRatingText(rating, true);
                    showFeedback(rating);
                    submitButton.disabled = false;
                });
            });

            function highlightStars(rating) {
                stars.forEach((star, index) => {
                    star.classList.remove('active');
                    if (index < rating) {
                        star.classList.add('active');
                    }
                });
            }

            function clearStars() {
                stars.forEach(star => {
                    star.classList.remove('active', 'selected');
                });
            }

            function updateRatingText(rating, isSelected) {
                const texts = {
                    1: isSelected ? "★ Poor" : "Poor",
                    2: isSelected ? "★★ Fair" : "Fair", 
                    3: isSelected ? "★★★ Good" : "Good",
                    4: isSelected ? "★★★★ Very Good" : "Very Good",
                    5: isSelected ? "★★★★★ Excellent" : "Excellent"
                };
                ratingText.innerText = texts[rating] || "Click on stars to rate";
                ratingText.style.color = isSelected ? '#667eea' : '#6c757d';
            }

            function showFeedback(rating) {
                ratingFeedback.innerText = ratingMessages[rating];
                ratingFeedback.classList.add('show');
            }
        });

        // Reset modal when closed
        $('#ratingModal').on('hidden.bs.modal', function() {
            document.querySelectorAll('.star-rating .star').forEach(star => {
                star.classList.remove('selected', 'active');
            });
            document.getElementById('ratingText').innerText = "Click on stars to rate";
            document.getElementById('ratingFeedback').classList.remove('show');
            currentRating = 0;
        });
    </script>
</body>
</html>
