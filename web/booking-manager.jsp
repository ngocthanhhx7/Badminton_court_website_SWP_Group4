<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <!-- Required meta tags -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Booking Manager</title>
        <!-- base:css -->
        <link rel="stylesheet" href="vendors/typicons.font/font/typicons.css">
        <link rel="stylesheet" href="vendors/css/vendor.bundle.base.css">
        <!-- endinject -->
        <!-- plugin css for this page -->
        <!-- End plugin css for this page -->
        <!-- inject:css -->
        <link rel="stylesheet" href="css/vertical-layout-light/style.css">
        <!-- endinject -->
        <link rel="shortcut icon" href="img/favicon.png" />
        <!-- Bootstrap CSS for modal -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome for icons -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        
        <style>
            .booking-card {
                transition: all 0.3s ease;
                border-left: 4px solid #007bff;
            }
            .booking-card:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            }
            .status-badge {
                font-size: 0.75rem;
                padding: 0.25rem 0.5rem;
            }
            .status-confirmed { background-color: #28a745; }
            .status-pending { background-color: #ffc107; }
            .status-cancelled { background-color: #dc3545; }
            .status-completed { background-color: #17a2b8; }
            .booking-details {
                background-color: #f8f9fa;
                border-radius: 8px;
                padding: 15px;
                margin-top: 10px;
            }
            .court-item {
                background: white;
                border-radius: 6px;
                padding: 10px;
                margin-bottom: 8px;
                border-left: 3px solid #007bff;
            }
            .filter-section {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 20px;
                border-radius: 10px;
                margin-bottom: 20px;
            }
            .stats-card {
                background: white;
                border-radius: 10px;
                padding: 20px;
                text-align: center;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            .stats-number {
                font-size: 2rem;
                font-weight: bold;
                color: #007bff;
            }
            .expired-booking {
                opacity: 0.7;
                border-left-color: #dc3545 !important;
            }
                        /* CSS cho màu của dropdown dựa vào status */
            .status-select.status-pending {
                background-color: #fff3cd;
                color: #856404;
            }

            .status-select.status-confirmed {
                background-color: #cce5ff;
                color: #004085;
            }

            .status-select.status-completed {
                background-color: #d4edda;
                color: #155724;
            }

            .status-select.status-cancelled {
                background-color: #f8d7da;
                color: #721c24;
            }

        </style>
    </head>
    <body>
        <div class="container-scroller">
            <jsp:include page="header-manager.jsp" />
            <!-- partial -->
            <div class="main-panel">
                <div class="schedule-container">
                    <div class="container-fluid" style="margin-top: 120px;">
                        
                        <!-- Page Header -->
                        <div class="row mb-4">
                            <div class="col-12">
                                <h2 class="page-title">
                                    <i class="fas fa-calendar-check me-2"></i>
                                    Booking Management
                                </h2>
                                <p class="text-muted">Manage and view all court bookings</p>
                            </div>
                        </div>

                        <!-- Filter Section -->
                        <div class="filter-section">
                            <form method="GET" action="scheduler-manager" class="row align-items-end">
                                <input type="hidden" name="action" value="list">
                                <div class="col-md-4">
                                    <label for="startDate" class="form-label">
                                        <i class="fas fa-calendar-alt me-1"></i>Start Date
                                    </label>
                                    <input type="date" class="form-control" id="startDate" name="startDate" 
                                           value="${param.startDate}">
                                </div>
                                <div class="col-md-4">
                                    <label for="endDate" class="form-label">
                                        <i class="fas fa-calendar-alt me-1"></i>End Date
                                    </label>
                                    <input type="date" class="form-control" id="endDate" name="endDate" 
                                           value="${param.endDate}">
                                </div>
                                <div class="col-md-4">
                                    <button type="submit" class="btn btn-light me-2">
                                        <i class="fas fa-search me-1"></i>Filter
                                    </button>
                                    <a href="scheduler-manager?action=list" class="btn btn-outline-light">
                                        <i class="fas fa-refresh me-1"></i>Reset
                                    </a>
                                </div>
                            </form>
                        </div>

                        <!-- Statistics -->
                        <div class="row mb-4">
                            <div class="col-md-3 mb-2">
                                <div class="stats-card">
                                    <div class="stats-number text-primary">
                                        ${sum} ₫
                                    </div>
                                    <div class="text-muted">Total Revenue</div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="stats-card">
                                    <div class="stats-number">${totalBooking}</div>
                                    <div class="text-muted">Total Bookings</div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="stats-card">
                                    <div class="stats-number text-success">
                                        <c:set var="confirmedCount" value="0"/>
                                        <c:forEach var="booking" items="${bookings}">
                                            <c:if test="${booking.status == 'Completed'}">
                                                <c:set var="confirmedCount" value="${confirmedCount + 1}"/>
                                            </c:if>
                                        </c:forEach>
                                        ${confirmedCount}
                                    </div>
                                    <div class="text-muted">Completed</div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="stats-card">
                                    <div class="stats-number text-warning">
                                        <c:set var="pendingCount" value="0"/>
                                        <c:forEach var="booking" items="${bookings}">
                                            <c:if test="${booking.status == 'Pending'}">
                                                <c:set var="pendingCount" value="${pendingCount + 1}"/>
                                            </c:if>
                                        </c:forEach>
                                        ${pendingCount}
                                    </div>
                                    <div class="text-muted">Pending</div>
                                </div>
                            </div>
<!--                                        <div class="col-md-3">
                                            <div class="stats-card">
                                                <div class="stats-number text-danger">
                                                    <c:set var="expiredCount" value="0"/>
                                                    <c:forEach var="booking" items="${bookings}">
                                                        <c:if test="${booking.expire}">
                                                            <c:set var="expiredCount" value="${expiredCount + 1}"/>
                                                        </c:if>
                                                    </c:forEach>
                                                    ${expiredCount}
                                                </div>
                                                <div class="text-muted">Expired</div>
                                            </div>
                                        </div>-->
                        </div>

                        <!-- Bookings List -->
                        <div class="row">
                            <div class="col-12">
                                <c:choose>
                                    <c:when test="${empty bookings}">
                                        <div class="card">
                                            <div class="card-body text-center py-5">
                                                <i class="fas fa-calendar-times fa-3x text-muted mb-3"></i>
                                                <h5 class="text-muted">No bookings found</h5>
                                                <p class="text-muted">Try adjusting your date range or check back later.</p>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="booking" items="${bookings}" varStatus="status">
                                            <div class="card booking-card mb-3 ${booking.expire ? 'expired-booking' : ''}">
                                                <div class="card-body">
                                                    <div class="row align-items-center">
                                                        <div class="col-md-8">
                                                            <div class="d-flex align-items-center mb-2">
                                                                <h5 class="card-title mb-0 me-3">
                                                                    <i class="fas fa-user me-1"></i>
                                                                    ${booking.customerName}
                                                                </h5>
                                                                <span class="badge status-badge status-${booking.status.toLowerCase()}">
                                                                    ${booking.status}
                                                                </span>
                                                                 <form method="post" action="scheduler-manager" class="ms-2">
                                                                    <input type="hidden" name="bookingId" value="${booking.bookingId}" />
                                                                    <input type="hidden" name="action" value="update" />
                                                                    <select class="form-select form-select-sm status-select status-${booking.status.toLowerCase()}" name="status" onchange="this.form.submit()">
                                                                        <option value="Pending" ${booking.status == 'Pending' ? 'selected' : ''}>Pending</option>
                                                                        <option value="Completed"  ${booking.status == 'Completed' ? 'selected' : ''}>Completed</option>
                                                                        <option value="Cancelled"  ${booking.status == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                                                                    </select>
                                                                </form>

                                                                
                                                                <c:if test="${booking.expire}">
                                                                    <span class="badge bg-danger ms-2">
                                                                        <i class="fas fa-clock me-1"></i>Expired
                                                                    </span>
                                                                </c:if>
                                                            </div>
                                                            <div class="row">
                                                                <div class="col-md-6">
                                                                    <small class="text-muted">
                                                                        <i class="fas fa-envelope me-1"></i>
                                                                        ${booking.customerEmail}
                                                                    </small>
                                                                </div>
                                                                <div class="col-md-6">
                                                                    <small class="text-muted">
                                                                        <i class="fas fa-phone me-1"></i>
                                                                        ${booking.customerPhone}
                                                                    </small>
                                                                </div>
                                                            </div>
                                                            <c:if test="${not empty booking.notes}">
                                                                <div class="mt-2">
                                                                    <small class="text-muted">
                                                                        <i class="fas fa-sticky-note me-1"></i>
                                                                        ${booking.notes}
                                                                    </small>
                                                                </div>
                                                            </c:if>
                                                        </div>
                                                        <div class="col-md-4 text-end">
                                                            <div class="mb-2">
                                                                <small class="text-muted">Booking ID: #${booking.bookingId}</small>
                                                            </div>
                                                            <div class="mb-2">
                                                                <small class="text-muted">
                                                                    <i class="fas fa-calendar me-1"></i>
                                                                    Created: ${booking.createdAtStr}
                                                                </small>
                                                            </div>
                                                            <button class="btn btn-outline-primary btn-sm" 
                                                                    type="button" 
                                                                    data-bs-toggle="collapse" 
                                                                    data-bs-target="#booking-details-${booking.bookingId}" 
                                                                    aria-expanded="false">
                                                                <i class="fas fa-eye me-1"></i>View Details
                                                            </button>
                                                        </div>
                                                    </div>

                                                    <!-- Booking Details (Collapsible) -->
                                                    <div class="collapse" id="booking-details-${booking.bookingId}">
                                                        <div class="booking-details mt-3">
                                                            <h6 class="mb-3">
                                                                <i class="fas fa-list me-2"></i>
                                                                Court Bookings (${booking.bookingDetails.size()} courts)
                                                            </h6>
                                                            
                                                            <c:set var="totalAmount" value="0"/>
                                                            <c:forEach var="detail" items="${booking.bookingDetails}">
                                                                <div class="court-item">
                                                                    <div class="row align-items-center">
                                                                        <div class="col-md-4">
                                                                            <strong>
                                                                                <i class="fas fa-tennis-ball me-1"></i>
                                                                                ${detail.courtName}
                                                                            </strong>
                                                                            <br>
                                                                            <small class="text-muted">${detail.courtType}</small>
                                                                        </div>
                                                                        <div class="col-md-4">
                                                                            <i class="fas fa-clock me-1"></i>
                                                                            <strong>${detail.startTimeStr} - ${detail.endTimeStr}</strong>
                                                                            <br>
                                                                            <small class="text-muted">
                                                                                Duration: ${detail.durationHours} hour(s)
                                                                            </small>
                                                                        </div>
                                                                        <div class="col-md-4 text-end">
                                                                            <div class="mb-1">
                                                                                <small class="text-muted">Rate: </small>
                                                                                <fmt:formatNumber value="${detail.hourlyRate}" type="currency" currencySymbol="$"/>
                                                                                <small class="text-muted">/hour</small>
                                                                            </div>
                                                                            <strong class="text-primary">
                                                                                Subtotal: <fmt:formatNumber value="${detail.subtotal}" type="currency" currencySymbol="$"/>
                                                                            </strong>
                                                                            <c:set var="totalAmount" value="${totalAmount + detail.subtotal}"/>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </c:forEach>
                                                            
                                                            <!-- Total Amount -->
                                                            <div class="row mt-3">
                                                                <div class="col-12 text-end">
                                                                    <h5 class="text-success">
                                                                        <i class="fas fa-dollar-sign me-1"></i>
                                                                        Total Amount: <fmt:formatNumber value="${totalAmount}" type="currency" currencySymbol="$"/>
                                                                    </h5>
                                                                </div>
                                                            </div>
                                                            
                                                            <!-- Action Buttons -->
                                                            <div class="row mt-3">
                                                                <div class="col-12 text-end">
                                                                    <c:if test="${booking.status == 'PENDING'}">
                                                                        <button class="btn btn-success btn-sm me-2" 
                                                                                onclick="updateBookingStatus(${booking.bookingId}, 'CONFIRMED')">
                                                                            <i class="fas fa-check me-1"></i>Confirm
                                                                        </button>
                                                                        <button class="btn btn-danger btn-sm me-2" 
                                                                                onclick="updateBookingStatus(${booking.bookingId}, 'CANCELLED')">
                                                                            <i class="fas fa-times me-1"></i>Cancel
                                                                        </button>
                                                                    </c:if>
<!--                                                                    <button class="btn btn-info btn-sm" 
                                                                            onclick="printBooking(${booking.bookingId})">
                                                                        <i class="fas fa-print me-1"></i>Print
                                                                    </button>-->
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        <!-- base:js -->
        <script src="vendors/js/vendor.bundle.base.js"></script>
        <!-- endinject -->
        <!-- Plugin js for this page-->
        <!-- End plugin js for this page-->
        <!-- inject:js -->
        <script src="js/off-canvas.js"></script>
        <script src="js/hoverable-collapse.js"></script>
        <script src="js/template.js"></script>
        <script src="js/settings.js"></script>
        <script src="js/todolist.js"></script>
        <!-- endinject -->
        <!-- plugin js for this page -->
        <script src="vendors/progressbar.js/progressbar.min.js"></script>
        <script src="vendors/chart.js/Chart.min.js"></script>
        <!-- End plugin js for this page -->
        <!-- Custom js for this page-->
        <!-- End custom js for this page-->
        
        <script>
            // Auto-hide alerts after 5 seconds
            $(document).ready(function () {
                setTimeout(function () {
                    $('.alert').fadeOut('slow');
                }, 5000);
                
                // Set default dates if not provided
                const today = new Date();
                const lastMonth = new Date(today.getFullYear(), today.getMonth() - 1, today.getDate());
                
                if (!document.getElementById('startDate').value) {
                    document.getElementById('startDate').value = lastMonth.toISOString().split('T')[0];
                }
                if (!document.getElementById('endDate').value) {
                    document.getElementById('endDate').value = today.toISOString().split('T')[0];
                }
            });

            // Function to update booking status
            function updateBookingStatus(bookingId, status) {
                if (confirm('Are you sure you want to ' + status.toLowerCase() + ' this booking?')) {
                    // You can implement AJAX call here to update status
                    fetch('booking-manager', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: 'action=updateStatus&bookingId=' + bookingId + '&status=' + status
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            location.reload();
                        } else {
                            alert('Error updating booking status');
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('Error updating booking status');
                    });
                }
            }

            // Function to print booking details
            function printBooking(bookingId) {
                window.open('print-booking?bookingId=' + bookingId, '_blank');
            }

            // Enhanced search functionality
            function searchBookings() {
                const searchTerm = document.getElementById('searchInput').value.toLowerCase();
                const bookingCards = document.querySelectorAll('.booking-card');
                
                bookingCards.forEach(card => {
                    const text = card.textContent.toLowerCase();
                    if (text.includes(searchTerm)) {
                        card.style.display = 'block';
                    } else {
                        card.style.display = 'none';
                    }
                });
            }
        </script>
    </body>
</html>
