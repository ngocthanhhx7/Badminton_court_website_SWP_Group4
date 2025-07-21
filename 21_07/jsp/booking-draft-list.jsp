<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="models.UserDTO, models.AdminDTO, models.GoogleAccount" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!doctype html>
<html class="no-js" lang="zxx">
<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>BadmintonHub - Draft Bookings</title>
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
            border-left: 4px solid #ffc107;
        }
        .booking-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }
        .booking-card.expired {
            border-left-color: #dc3545;
            opacity: 0.7;
        }
        .status-badge {
            font-size: 0.75rem;
            padding: 0.25rem 0.75rem;
            border-radius: 50px;
            font-weight: 600;
            text-transform: uppercase;
        }
        .status-draft { background-color: #fff3cd; color: #856404; }
        .status-expired { background-color: #f8d7da; color: #721c24; }
        .status-pending { background-color: #d1ecf1; color: #0c5460; }
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
        .expired-overlay {
            position: relative;
        }
        .expired-overlay::after {
            content: 'EXPIRED';
            position: absolute;
            top: 10px;
            right: 10px;
            background: #dc3545;
            color: white;
            padding: 5px 10px;
            border-radius: 4px;
            font-size: 0.7rem;
            font-weight: bold;
            transform: rotate(15deg);
        }
        .btn-continue {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            border: none;
            color: white;
            transition: all 0.3s ease;
        }
        .btn-continue:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
            color: white;
        }
        .btn-cancel {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            border: none;
            color: white;
            transition: all 0.3s ease;
        }
        .btn-cancel:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(220, 53, 69, 0.3);
            color: white;
        }
        .btn:disabled {
            opacity: 0.6;
            transform: none !important;
            box-shadow: none !important;
            cursor: not-allowed;
        }
        .draft-info {
            background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);
            color: white;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .draft-info i {
            font-size: 1.2rem;
            margin-right: 8px;
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
        <h3>Draft Bookings</h3>
    </div>
    <!-- bradcam_area_end -->

    <!-- Draft Bookings Section Start -->
    <div class="container" style="padding: 60px 0;">
        <div class="row">
            <div class="col-12">
                <div class="mb-4">
                    <h2 class="text-2xl font-bold text-gray-800 mb-2">Your Draft Bookings</h2>
                    <p class="text-gray-600">Complete your pending bookings or manage your drafts</p>
                </div>

                <!-- Draft Info Banner -->
                <div class="draft-info">
                    <i class="fa fa-info-circle"></i>
                    <strong>Important:</strong> Draft bookings are temporary and will expire after a certain time. 
                    Please complete your booking to secure your court reservation.
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
                    <c:when test="${empty draftList}">
                        <!-- Empty State -->
                        <div class="empty-state">
                            <i class="fa fa-file-text-o"></i>
                            <h3>No Draft Bookings Found</h3>
                            <p>You don't have any draft bookings at the moment. Start by creating a new booking!</p>
                            <a href="./court" class="btn btn-primary mt-3">
                                <i class="fa fa-plus"></i> Book a Court
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- Draft Booking Cards -->
                        <c:forEach var="draft" items="${draftList}" varStatus="status">
                            <div class="booking-card bg-white rounded-lg shadow-md mb-4 overflow-hidden ${draft.expire ? 'expired' : ''}">
                                <c:if test="${draft.expire}">
                                    <div class="expired-overlay"></div>
                                </c:if>
                                
                                <!-- Booking Header -->
                                <div class="bg-gray-50 px-4 py-3 border-b">
                                    <div class="row align-items-center">
                                        <div class="col-md-6">
                                            <h5 class="mb-1 font-weight-bold">
                                                <i class="fa fa-file-text text-warning"></i>
                                                Draft #${draft.bookingId}
                                            </h5>
                                            <small class="text-muted">
                                                <i class="fa fa-clock-o"></i>
                                                Created: ${draft.createdAtStr}
                                            </small>
                                        </div>
                                        <div class="col-md-6 text-md-right">
                                            <span class="status-badge status-${draft.expire ? 'expired' : 'draft'}">
                                                ${draft.expire ? 'EXPIRED' : 'DRAFT'}
                                            </span>
                                        </div>
                                    </div>
                                </div>

                                <!-- Booking Content -->
                                <div class="p-4">
                                    <c:if test="${not empty draft.notes}">
                                        <div class="mb-3">
                                            <small class="text-muted">Notes:</small>
                                            <p class="mb-0 text-gray-700">${draft.notes}</p>
                                        </div>
                                    </c:if>

                                    <!-- Expiry Warning -->
                                    <c:if test="${draft.expire}">
                                        <div class="alert alert-danger mb-3">
                                            <i class="fa fa-exclamation-triangle"></i>
                                            <strong>This draft has expired!</strong> You can no longer continue or cancel this booking.
                                        </div>
                                    </c:if>

                                    <!-- Booking Details -->
                                    <c:if test="${not empty draft.bookingDetails}">
                                        <h6 class="font-weight-bold mb-3 text-gray-800">
                                            <i class="fa fa-list"></i> Booking Details
                                        </h6>

                                        <c:set var="totalAmount" value="0" />

                                        <c:forEach var="detail" items="${draft.bookingDetails}">
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
                                            <c:if test="${not empty draft.updatedAt}">
                                                <small class="text-muted">
                                                    <i class="fa fa-refresh"></i>
                                                    Last updated: ${draft.updatedAtStr}
                                                </small>
                                            </c:if>
                                        </div>
                                        <div class="col-md-6 text-md-right">
                                            <c:choose>
                                                <c:when test="${draft.expire}">
                                                    <button class="btn btn-sm btn-secondary" disabled>
                                                        <i class="fa fa-clock-o"></i> Expired
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <!-- Continue Booking Button -->
                                                    <a href="booking?courtScheduleIds=${draft.notes}" 
                                                       class="btn btn-sm btn-continue mr-2">
                                                        <i class="fa fa-play"></i> Continue Booking
                                                    </a>
  
                                                    <!-- Cancel Draft Button -->
                                                    <c:if test="${draft.cancel}">
                                                        <form method="post" action="booking" style="display: inline;" 
                                                              onsubmit="return confirm('Are you sure you want to cancel this draft booking?');">
                                                            <input type="hidden" name="draftId" value="${draft.bookingId}" />
                                                            <input type="hidden" name="action" value="cancel" />
                                                            <button type="submit" class="btn btn-sm btn-cancel">
                                                                <i class="fa fa-times"></i> Cancel Draft
                                                            </button>
                                                        </form>
                                                    </c:if>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>

                        <!-- Pagination (if needed) -->
                        <div class="text-center mt-4">
                            <p class="text-muted">Showing ${draftList.size()} draft booking(s)</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    <!-- Draft Bookings Section End -->

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
        // Auto-hide alerts after 5 seconds
        document.addEventListener('DOMContentLoaded', function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                setTimeout(() => {
                    if (alert.classList.contains('show')) {
                        alert.classList.remove('show');
                        setTimeout(() => alert.remove(), 150);
                    }
                }, 5000);
            });
        });

        // Add confirmation for continue booking
        document.querySelectorAll('a[href*="continue-booking"]').forEach(link => {
            link.addEventListener('click', function(e) {
                if (!confirm('Do you want to continue with this booking?')) {
                    e.preventDefault();
                }
            });
        });
    </script>
</body>
</html>
