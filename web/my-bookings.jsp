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

        <style>
            .booking-history-container {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                padding: 40px 0;
            }

            .history-card {
                background: white;
                border-radius: 15px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
                margin-bottom: 30px;
                overflow: hidden;
            }

            .history-header {
                background: linear-gradient(45deg, #fcedc9, #dbaa32);
                color: white;
                padding: 20px 30px;
            }
            
            /* Fix button overlap issues */
            .btn {
                margin: 5px;
                white-space: nowrap;
            }
            
            .btn-back {
                display: inline-block;
                margin-bottom: 20px;
                z-index: 100;
                position: relative;
            }
            
            /* Ensure dropdown menu doesn't overlap */
            .dropdown-menu {
                z-index: 1050;
                min-width: 200px;
            }
            
            /* Fix navbar spacing */
            .navbar .dropdown {
                margin-left: 10px;
            }
            
            /* Responsive button spacing */
            @media (max-width: 768px) {
                .btn {
                    margin: 3px 0;
                    width: 100%;
                }
                
                .dropdown-menu {
                    position: absolute;
                    left: auto;
                    right: 0;
                }
            }

            .no-bookings {
                text-align: center;
            }

            .booking-item {
                border: 1px solid #e9ecef;
                border-radius: 10px;
                margin-bottom: 20px;
                padding: 20px;
                background: #f8f9fa;
                transition: all 0.3s ease;
            }

            .booking-item:hover {
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
                transform: translateY(-2px);
            }

            .booking-header-info {
                background: linear-gradient(45deg, #667eea, #764ba2);
                color: white;
                padding: 15px 20px;
                border-radius: 8px;
                margin-bottom: 15px;
            }

            .status-badge {
                padding: 5px 15px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
                text-transform: uppercase;
            }

            .status-pending {
                background-color: #fff3cd;
                color: #856404;
            }

            .status-confirmed {
                background-color: #d4edda;
                color: #155724;
            }

            .status-cancelled {
                background-color: #f8d7da;
                color: #721c24;
            }

            .status-completed {
                background-color: #d1ecf1;
                color: #0c5460;
            }

            .detail-row {
                padding: 10px 15px;
                border-bottom: 1px solid #dee2e6;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .detail-row:last-child {
                border-bottom: none;
            }

            .detail-label {
                font-weight: 600;
                color: #495057;
            }

            .detail-value {
                color: #6c757d;
            }

            .no-bookings {
                text-align: center;
                padding: 60px 20px;
                color: #6c757d;
            }

            .btn-back {
                background: linear-gradient(45deg, #6c757d, #495057);
                border: none;
                color: white;
                padding: 10px 25px;
                border-radius: 20px;
                text-decoration: none;
                display: inline-block;
                margin-bottom: 20px;
                transition: all 0.3s ease;
            }

            .btn-back:hover {
                color: white;
                transform: translateY(-1px);
                box-shadow: 0 3px 10px rgba(0,0,0,0.2);
            }

            .court-info {
                background: white;
                border-radius: 8px;
                padding: 15px;
                margin-top: 10px;
                border-left: 4px solid #667eea;
            }

            .time-info {
                background: #e9ecef;
                padding: 10px 15px;
                border-radius: 5px;
                margin: 5px 0;
            }

            .price-info {
                font-size: 18px;
                font-weight: bold;
                color: #28a745;
            }
            
            /* Modal fallback styles */
            .modal.show {
                display: block !important;
            }
            
            .modal-backdrop {
                position: fixed;
                top: 0;
                left: 0;
                z-index: 1040;
                width: 100vw;
                height: 100vh;
                background-color: #000;
                opacity: 0.5;
            }
            
            /* Close button fallback */
            .btn-close {
                background: none;
                border: 0;
                font-size: 1.5rem;
                font-weight: 700;
                line-height: 1;
                color: #fff;
                opacity: 0.8;
            }
            
            .btn-close:hover {
                opacity: 1;
            }
        </style>
    </head>

    <body>
        <!-- header-start -->
        <jsp:include page="header-user.jsp"/>
        <!-- header-end -->

        <div class="booking-history-container">
            <div class="container">
                <!-- Back Button -->
                <a href="./home" class="btn-back">
                    <i class="fa fa-arrow-left"></i> Back to Home
                </a>

                <div class="history-card">
                    <div class="history-header">
                        <h2 class="mb-0">
                            <i class="fa fa-history"></i> My Booking History
                        </h2>
                    </div>

                    <div class="card-body p-4">
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger" role="alert">
                                <i class="fa fa-exclamation-triangle"></i> ${error}
                            </div>
                        </c:if>

                        <c:if test="${not empty success}">
                            <div class="alert alert-success" role="alert">
                                <i class="fa fa-check-circle"></i> ${success}
                            </div>
                        </c:if>

                        <c:choose>
                            <c:when test="${empty userBookings}">
                                <div class="no-bookings">
                                    <i class="fa fa-calendar-times-o fa-3x mb-3"></i>
                                    <h4>No booking history yet</h4>
                                    <p>You haven't booked any courts yet. Start booking to experience our services!</p>
                                    <a href="./court" class="btn btn-primary mt-3">
                                        <i class="fa fa-calendar-plus-o"></i> Book Court Now
                                    </a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="booking" items="${userBookings}">
                                    <div class="booking-item">
                                        <div class="booking-header-info">
                                            <div class="row align-items-center">
                                                <div class="col-md-6">
                                                    <h5 class="mb-1">
                                                        <i class="fa fa-ticket"></i> Mã đặt sân: #${booking.bookingId}
                                                    </h5>
                                                    <small>Khách hàng: ${booking.customerName}</small>
                                                </div>
                                                <div class="col-md-6 text-md-right">
                                                    <span class="status-badge status-${booking.status.toLowerCase()}">
                                                        <c:choose>
                                                            <c:when test="${booking.status == 'Pending'}">Chờ xác nhận</c:when>
                                                            <c:when test="${booking.status == 'Confirmed'}">Đã xác nhận</c:when>
                                                            <c:when test="${booking.status == 'Cancelled'}">Đã hủy</c:when>
                                                            <c:when test="${booking.status == 'Completed'}">Hoàn thành</c:when>
                                                            <c:otherwise>${booking.status}</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                    <!-- Cancel button for Pending bookings -->
                                                    <c:if test="${booking.status == 'Pending'}">
                                                        <br>
                                                        <button type="button" class="btn btn-danger btn-sm mt-2" 
                                                                onclick="confirmCancel('${booking.bookingId}', '${booking.customerName}')">
                                                            <i class="fa fa-times"></i> Hủy đặt sân
                                                        </button>
                                                    </c:if>
                                                    <br>
                                                    <small>
                                                        ${booking.createdAt.toString().substring(0, 16).replace("T", " ")}
                                                    </small>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Booking Details -->
                                        <c:set var="bookingDetails" value="${bookingDetailsMap[booking.bookingId]}"/>
                                        <c:if test="${not empty bookingDetails}">
                                            <c:forEach var="detail" items="${bookingDetails}">
                                                <div class="court-info">
                                                    <div class="row">
                                                        <div class="col-md-8">
                                                            <h6 class="mb-2">
                                                                <i class="fa fa-map-marker"></i> ${detail.courtName}
                                                                <span class="badge badge-secondary ml-2">${detail.courtType}</span>
                                                            </h6>
                                                            <div class="time-info">
                                                                <i class="fa fa-clock-o"></i>
                                                                <strong>Time:</strong>
                                                                ${detail.startTime.toString().substring(0, 16).replace("T", " ")} - 
                                                                ${detail.endTime.toString().substring(11, 16)}
                                                            </div>
                                                        </div>
                                                        <div class="col-md-4 text-md-right">
                                                            <div class="price-info">
                                                                <i class="fa fa-money"></i>
                                                                <fmt:formatNumber value="${detail.subtotal}" pattern="#,###"/> VNĐ
                                                            </div>
                                                            <small class="text-muted">
                                                                <fmt:formatNumber value="${detail.hourlyRate}" pattern="#,###"/> VNĐ/giờ
                                                            </small>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:if>

                                        <!-- Notes -->
                                        <c:if test="${not empty booking.notes}">
                                            <div class="detail-row">
                                                <span class="detail-label">
                                                    <i class="fa fa-sticky-note-o"></i> Notes:
                                                </span>
                                                <span class="detail-value">${booking.notes}</span>
                                            </div>
                                        </c:if>

                                        <!-- Contact Info -->
                                        <div class="row mt-3">
                                            <div class="col-md-6">
                                                <small class="text-muted">
                                                    <i class="fa fa-envelope"></i> ${booking.customerEmail}
                                                </small>
                                            </div>
                                            <div class="col-md-6 text-md-right">
                                                <small class="text-muted">
                                                    <i class="fa fa-phone"></i> ${booking.customerPhone}
                                                </small>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>

                                <!-- Summary -->
                                <div class="mt-4 p-3 bg-light rounded">
                                    <div class="row text-center">
                                        <div class="col-md-4">
                                            <h6 class="text-muted">Total Bookings</h6>
                                            <h4 class="text-primary">${userBookings.size()}</h4>
                                        </div>
                                        <div class="col-md-4">
                                            <h6 class="text-muted">Completed</h6>
                                            <h4 class="text-success">
                                                <c:set var="completedCount" value="0"/>
                                                <c:forEach var="booking" items="${userBookings}">
                                                    <c:if test="${booking.status == 'Completed'}">
                                                        <c:set var="completedCount" value="${completedCount + 1}"/>
                                                    </c:if>
                                                </c:forEach>
                                                ${completedCount}
                                            </h4>
                                        </div>
                                        <div class="col-md-4">
                                            <h6 class="text-muted">Pending</h6>
                                            <h4 class="text-warning">
                                                <c:set var="pendingCount" value="0"/>
                                                <c:forEach var="booking" items="${userBookings}">
                                                    <c:if test="${booking.status == 'Pending'}">
                                                        <c:set var="pendingCount" value="${pendingCount + 1}"/>
                                                    </c:if>
                                                </c:forEach>
                                                ${pendingCount}
                                            </h4>
                                        </div>
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>

        <!-- Cancel Booking Modal -->
        <div class="modal fade" id="cancelBookingModal" tabindex="-1" aria-labelledby="cancelBookingModalLabel" aria-hidden="true" data-bs-backdrop="true" data-bs-keyboard="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header bg-danger text-white">
                        <h5 class="modal-title" id="cancelBookingModalLabel">
                            <i class="fa fa-exclamation-triangle"></i> Xác nhận hủy đặt sân
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close" onclick="closeCancelModal()">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <div class="text-center mb-3">
                            <i class="fa fa-times-circle fa-3x text-danger"></i>
                        </div>
                        <p class="text-center">
                            Bạn có chắc chắn muốn hủy đặt sân <strong id="cancelBookingInfo"></strong> không?
                        </p>
                        <div class="alert alert-warning">
                            <i class="fa fa-info-circle"></i>
                            <strong>Lưu ý:</strong> Sau khi hủy, việc hoàn tiền sẽ được xử lý trong vòng 3-5 ngày làm việc.
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" onclick="closeCancelModal()">
                            <i class="fa fa-times"></i> Không, giữ đặt sân
                        </button>
                        <form id="cancelBookingForm" method="POST" action="booking" style="display: inline;">
                            <input type="hidden" name="action" value="cancel">
                            <input type="hidden" name="bookingId" id="cancelBookingId">
                            <button type="submit" class="btn btn-danger">
                                <i class="fa fa-check"></i> Có, hủy đặt sân
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- footer start -->
        <jsp:include page="footer.jsp"/>
        <!-- footer end -->

        <!-- JS here -->
        <script src="js/vendor/modernizr-3.5.0.min.js"></script>
        <script src="js/vendor/jquery-1.12.4.min.js"></script>
        <script src="js/popper.min.js"></script>
        <script src="js/bootstrap.min.js"></script>
        <script src="js/owl.carousel.min.js"></script>
        <script src="js/isotope.pkgd.min.js"></script>
        <script src="js/ajax-form.js"></script>
        <script src="js/waypoints.min.js"></script>
        <script src="js/jquery.counterup.min.js"></script>
        <script src="js/imagesloaded.pkgd.min.js"></script>
        <script src="js/scrollIt.js"></script>
        <script src="js/jquery.scrollUp.min.js"></script>
        <script src="js/wow.min.js"></script>
        <script src="js/nice-select.min.js"></script>
        <script src="js/jquery.slicknav.min.js"></script>
        <script src="js/jquery.magnific-popup.min.js"></script>
        <script src="js/plugins.js"></script>
        <script src="js/gijgo.min.js"></script>
        <script src="js/main.js"></script>
        
        <script>
            // Global variables
            let currentModal = null;
            
            // Global function để confirm cancel
            window.confirmCancel = function(bookingId, customerName) {
                // Set booking ID in hidden input
                document.getElementById('cancelBookingId').value = bookingId;
                
                // Set booking info in modal
                document.getElementById('cancelBookingInfo').textContent = '#' + bookingId + ' (' + customerName + ')';
                
                // Show modal - tương thích với cả Bootstrap 4 và 5
                var modalElement = document.getElementById('cancelBookingModal');
                try {
                    // Try Bootstrap 5 first
                    if (typeof bootstrap !== 'undefined' && bootstrap.Modal) {
                        currentModal = new bootstrap.Modal(modalElement);
                        currentModal.show();
                    }
                    // Fallback to Bootstrap 4
                    else if (typeof $ !== 'undefined' && $.fn.modal) {
                        $(modalElement).modal('show');
                    }
                    // Manual fallback
                    else {
                        modalElement.style.display = 'block';
                        modalElement.classList.add('show');
                        document.body.classList.add('modal-open');
                        
                        // Add backdrop
                        var backdrop = document.createElement('div');
                        backdrop.className = 'modal-backdrop fade show';
                        backdrop.id = 'modal-backdrop';
                        document.body.appendChild(backdrop);
                    }
                } catch (e) {
                    console.error('Error showing modal:', e);
                    // Manual show as last resort
                    modalElement.style.display = 'block';
                    modalElement.classList.add('show');
                }
            };
            
            // Function để đóng modal
            window.closeCancelModal = function() {
                var modalElement = document.getElementById('cancelBookingModal');
                try {
                    // Try Bootstrap 5 first
                    if (currentModal && typeof currentModal.hide === 'function') {
                        currentModal.hide();
                        currentModal = null;
                    }
                    // Try Bootstrap 5 getInstance
                    else if (typeof bootstrap !== 'undefined' && bootstrap.Modal) {
                        var modal = bootstrap.Modal.getInstance(modalElement);
                        if (modal) {
                            modal.hide();
                        }
                    }
                    // Try Bootstrap 4
                    else if (typeof $ !== 'undefined' && $.fn.modal) {
                        $(modalElement).modal('hide');
                    }
                    // Manual fallback
                    else {
                        modalElement.style.display = 'none';
                        modalElement.classList.remove('show');
                        document.body.classList.remove('modal-open');
                        
                        // Remove backdrop
                        var backdrop = document.getElementById('modal-backdrop');
                        if (backdrop) {
                            backdrop.remove();
                        }
                    }
                } catch (e) {
                    console.error('Error hiding modal:', e);
                    // Manual hide as last resort
                    modalElement.style.display = 'none';
                    modalElement.classList.remove('show');
                    document.body.classList.remove('modal-open');
                }
            };
            
            // Document ready
            document.addEventListener('DOMContentLoaded', function() {
                // Debug: Check Bootstrap version
                console.log('Bootstrap check:');
                console.log('- bootstrap object:', typeof bootstrap !== 'undefined' ? 'found' : 'not found');
                console.log('- jQuery:', typeof $ !== 'undefined' ? 'found' : 'not found');
                console.log('- jQuery modal:', typeof $ !== 'undefined' && $.fn.modal ? 'found' : 'not found');
                
                var cancelModal = document.getElementById('cancelBookingModal');
                if (cancelModal) {
                    // Handle clicks on backdrop
                    cancelModal.addEventListener('click', function(e) {
                        if (e.target === cancelModal) {
                            closeCancelModal();
                        }
                    });
                    
                    // Handle escape key
                    document.addEventListener('keydown', function(e) {
                        if (e.key === 'Escape' && cancelModal.classList.contains('show')) {
                            closeCancelModal();
                        }
                    });
                    
                    // Handle all close buttons
                    var closeButtons = cancelModal.querySelectorAll('[data-bs-dismiss="modal"], .btn-secondary');
                    closeButtons.forEach(function(button) {
                        button.addEventListener('click', function(e) {
                            e.preventDefault();
                            closeCancelModal();
                        });
                    });
                }
            });
            
            // Auto hide alerts after 5 seconds
            setTimeout(function() {
                var alerts = document.querySelectorAll('.alert');
                alerts.forEach(function(alert) {
                    if (alert.classList.contains('alert-success') || alert.classList.contains('alert-danger')) {
                        alert.style.transition = 'opacity 0.5s';
                        alert.style.opacity = '0';
                        setTimeout(function() {
                            if (alert.parentNode) {
                                alert.parentNode.removeChild(alert);
                            }
                        }, 500);
                    }
                });
            }, 5000);
        </script>
    </body>
</html>
