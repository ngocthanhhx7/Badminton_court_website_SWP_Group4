<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <!-- Required meta tags -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Court Manager</title>
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
        <style>
            .image-preview {
                max-width: 200px;
                max-height: 150px;
                margin-top: 10px;
                border: 1px solid #ddd;
                border-radius: 4px;
            }
            .file-input-wrapper {
                position: relative;
                display: inline-block;
                cursor: pointer;
            }
            .file-input-wrapper input[type=file] {
                position: absolute;
                left: -9999px;
            }
            .file-input-wrapper .btn {
                margin-right: 10px;
            }
            .filter-section {
                background: #f8f9fa;
                padding: 20px;
                border-radius: 8px;
                margin-bottom: 20px;
            }
            .sort-header {
                cursor: pointer;
                user-select: none;
            }
            .sort-header:hover {
                background-color: #f8f9fa;
            }
            .sort-icon {
                margin-left: 5px;
                font-size: 12px;
            }
            .pagination-info {
                margin: 10px 0;
                color: #6c757d;
            }
            .search-box {
                max-width: 300px;
            }
            .court-image {
                max-width: 80px;
                max-height: 60px;
                border-radius: 4px;
            }
            .description-cell {
                max-width: 200px;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
            }
            .description-cell:hover {
                white-space: normal;
                word-wrap: break-word;
            }
             .schedule-container {
                background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
                min-height: 100vh;
                padding: 40px 0;
            }
            .schedule-card {
                background: white;
                border-radius: 15px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
                overflow: hidden;
                margin-bottom: 30px;
            }
            .schedule-header {
                background: linear-gradient(45deg, #667eea, #764ba2);
                color: white;
                padding: 30px;
                text-align: center;
            }
            .date-selector {
                background: white;
                padding: 20px;
                border-bottom: 1px solid #e9ecef;
            }
            .schedule-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                gap: 20px;
                padding: 30px;
            }
            .court-schedule {
                border: 2px solid #e9ecef;
                border-radius: 10px;
                overflow: hidden;
                transition: all 0.3s ease;
            }
            .court-schedule:hover {
                border-color: #667eea;
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            }
            .court-header {
                background: #f8f9fa;
                padding: 15px;
                border-bottom: 1px solid #e9ecef;
            }
            .court-name {
                font-weight: 600;
                color: #2c3e50;
                margin: 0;
            }
            .court-type {
                color: #6c757d;
                font-size: 14px;
            }
            .time-slots {
                padding: 15px;
            }
            .time-slot {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 10px;
                margin-bottom: 8px;
                border-radius: 8px;
                transition: all 0.3s ease;
            }
            .time-slot.available {
                background: #d4edda;
                border: 1px solid #c3e6cb;
                color: #155724;
            }
            .time-slot.booked {
                background: #f8d7da;
                border: 1px solid #f5c6cb;
                color: #721c24;
            }
            .time-slot.maintenance {
                background: #fff3cd;
                border: 1px solid #ffeaa7;
                color: #856404;
            }
            .date-nav {
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 20px;
            }
            .current-date {
                font-size: 18px;
                font-weight: 600;
                color: #2c3e50;
            }
            .no-schedules {
                text-align: center;
                padding: 60px 20px;
                color: #6c757d;
            }
            .empty-state {
                background: #f8f9fa;
                border: 2px dashed #dee2e6;
                border-radius: 15px;
                padding: 60px 20px;
                margin: 30px;
                text-align: center;
            }
            .empty-state-icon {
                font-size: 4rem;
                color: #dee2e6;
                margin-bottom: 20px;
            }
            .empty-state h4 {
                color: #6c757d;
                margin-bottom: 15px;
            }
            .empty-state p {
                color: #868e96;
                margin-bottom: 25px;
            }
            .debug-info {
                background: #fff3cd;
                border: 1px solid #ffeaa7;
                border-radius: 8px;
                padding: 15px;
                margin: 20px;
                font-size: 14px;
            }
            .legend {
                display: flex;
                justify-content: center;
                gap: 30px;
                padding: 20px;
                background: #f8f9fa;
                margin-top: 20px;
            }
            .legend-item {
                display: flex;
                align-items: center;
                gap: 8px;
            }
            .legend-color {
                width: 20px;
                height: 20px;
                border-radius: 4px;
            }
            .date-nav-btn {
                background: #667eea;
                color: white;
                border: none;
                padding: 10px 15px;
                border-radius: 8px;
                transition: all 0.3s ease;
                text-decoration: none;
                display: inline-block;
            }
            .date-nav-btn:hover {
                background: #5a6fd8;
                transform: translateY(-1px);
                color: white;
                text-decoration: none;
            }
            .btn-book-slot {
                background: #28a745;
                color: white;
                border: none;
                padding: 5px 15px;
                border-radius: 5px;
                font-size: 12px;
                transition: all 0.3s ease;
                cursor: pointer;
            }
            .btn-book-slot:hover {
                background: #218838;
                transform: scale(1.05);
                color: white;
            }
            .status-badge {
                padding: 4px 8px;
                border-radius: 4px;
                font-size: 12px;
                font-weight: 600;
            }
            .badge-available {
                background: #28a745;
                color: white;
            }
            .badge-booked {
                background: #dc3545;
                color: white;
            }
            .badge-maintenance {
                background: #ffc107;
                color: #212529;
            }
            
            /* Modal Styles */
            .booking-modal .modal-content {
                border-radius: 15px;
                border: none;
                box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            }
            
            .booking-modal .modal-header {
                background: linear-gradient(45deg, #667eea, #764ba2);
                color: white;
                border-radius: 15px 15px 0 0;
                border-bottom: none;
            }
            
            .booking-modal .modal-title {
                font-weight: 600;
            }
            
            .booking-modal .btn-close {
                filter: invert(1);
            }
            
            .booking-info {
                background: #f8f9fa;
                padding: 15px;
                border-radius: 8px;
                margin-bottom: 20px;
            }
            
            .booking-info h6 {
                color: #2c3e50;
                margin-bottom: 10px;
                font-weight: 600;
            }
            
            .booking-detail {
                display: flex;
                justify-content: space-between;
                margin-bottom: 5px;
            }
            
            .booking-detail strong {
                color: #495057;
            }
            
            .form-label {
                font-weight: 600;
                color: #2c3e50;
            }
            
            .form-control:focus {
                border-color: #667eea;
                box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
            }
            
            .btn-primary {
                background: linear-gradient(45deg, #667eea, #764ba2);
                border: none;
                padding: 10px 30px;
                border-radius: 8px;
                font-weight: 600;
            }
            
            .btn-primary:hover {
                background: linear-gradient(45deg, #5a6fd8, #6a4190);
                transform: translateY(-1px);
            }
            
            .btn-secondary {
                background: #6c757d;
                border: none;
                padding: 10px 20px;
                border-radius: 8px;
                font-weight: 600;
            }
            
            .user-info {
                font-size: 14px;
                color: #6c757d;
                margin-top: 5px;
            }
            
              /* NEW: Date Picker Styles */
        .date-picker-container {
            background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
            padding: 20px;
            border-radius: 15px;
            margin: 20px 0;
            text-align: center;
            box-shadow: 0 4px 15px rgba(187, 222, 251, 0.3);
        }

        .date-picker-title {
            color: #1565c0;
            font-size: 1.2rem;
            font-weight: 600;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .date-picker-form {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
            flex-wrap: wrap;
        }

        .date-input {
            padding: 12px 20px;
            border: 2px solid #90caf9;
            border-radius: 25px;
            font-size: 16px;
            font-weight: 500;
            color: #1565c0;
            background: white;
            transition: all 0.3s ease;
            outline: none;
            min-width: 180px;
        }

        .date-input:focus {
            border-color: #1976d2;
            box-shadow: 0 0 0 3px rgba(25, 118, 210, 0.1);
            transform: translateY(-1px);
        }

        .btn-date-submit {
            background: linear-gradient(45deg, #1976d2, #1565c0);
            color: white;
            border: none;
            padding: 12px 25px;
            border-radius: 25px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(25, 118, 210, 0.3);
            cursor: pointer;
        }

        .btn-date-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(25, 118, 210, 0.4);
        }

        .btn-date-submit:active {
            transform: translateY(0);
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
                        <div class="row">
                            <div class="col-12">
                                <div class="schedule-card">
                                    <div class="schedule-header">
                                        <h2><i class="fa fa-calendar"></i> Court Schedule</h2>
                                        <p>View available time slots for all courts</p>
                                    </div>
                                    <div class="date-selector">
                                        <div class="date-nav">
                                            <a href="booking?action=schedule&date=<fmt:formatDate value='${prevDate}' pattern='yyyy-MM-dd' />&type=${param.type}" class="date-nav-btn">
                                                <i class="fa fa-chevron-left"></i> Previous Day
                                            </a>
                                            <div class="current-date">
                                                <c:choose>
                                                    <c:when test="${not empty selectedDate}">
                                                        <fmt:formatDate value="${selectedDate}" pattern="EEEE, MMMM dd, yyyy" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="color: #dc3545;">Date not available</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <a href="booking?action=schedule&date=<fmt:formatDate value='${nextDate}' pattern='yyyy-MM-dd' />&type=${param.type}" class="date-nav-btn">
                                                Next Day <i class="fa fa-chevron-right"></i>
                                            </a>
                                        </div>
                                                
                                    
                                        <div class="date-picker-container">
                                            <div class="date-picker-title">
                                                <i class="fa fa-calendar-o"></i>
                                                Select a Specific Date
                                            </div>
                                            <form class="date-picker-form" method="GET" action="booking">
                                                <input type="hidden" name="action" value="schedule"/>
                                                <input type="date" 
                                                       name="date" 
                                                       class="date-input"
                                                       value="<c:choose><c:when test='${not empty selectedDateStr}'>${selectedDateStr}</c:when><c:otherwise><fmt:formatDate value='${now}' pattern='yyyy-MM-dd' /></c:otherwise></c:choose>"
                                                       min="<fmt:formatDate value='${now}' pattern='yyyy-MM-dd' />"
                                                       required>
                                                <button type="submit" class="btn-date-submit">
                                                    <i class="fa fa-search"></i> View Schedule
                                                </button>
                                            </form>
                                        </div>              
                                    </div>
                                    
                                    <!-- Debug Information (remove in production) -->
                                    <c:if test="${param.debug == 'true'}">
                                        <div class="debug-info">
                                            <strong>Debug Information:</strong><br>
                                            Selected Date: ${selectedDate}<br>
                                            Schedules Count: ${schedules != null ? schedules.size() : 'null'}<br>
                                            Schedules Empty: ${empty schedules}<br>
                                            Request Parameters: date=${param.date}, action=${param.action}
                                        </div>
                                    </c:if>
                                    
                                    <c:choose>
                                        <c:when test="${not empty schedules}">
                                            <div class="schedule-grid">
                                                <c:forEach var="schedule" items="${schedules}" varStatus="status">
                                                    <c:if test="${status.index == 0 || schedule.courtName != schedules[status.index-1].courtName}">
                                                        <div class="court-schedule">
                                                            <div class="court-header">
                                                                <h5 class="court-name">${schedule.courtName}</h5>
                                                                <div class="court-type">${schedule.courtType}</div>
                                                            </div>
                                                            <div class="time-slots">
                                                                <c:forEach var="timeSlot" items="${schedules}">
                                                                    <c:if test="${timeSlot.courtName == schedule.courtName}">
                                                                        <div class="time-slot ${timeSlot.status.toLowerCase()}">
                                                                            <div>
                                                                                <strong>
                                                                                    ${timeSlot.startTimeStr} - ${timeSlot.endTimeStr}
                                                                                </strong>
                                                                            </div>
                                                                            <div>
                                                                                <c:choose>
                                                                                    <c:when test="${timeSlot.status == 'Available'}">
                                                                                        <span class="status-badge badge-available">Available</span>
                                                                                        <c:if test="${not empty sessionScope.acc}">
                                                                                            <button type="button" class="btn-book-slot" 
                                                                                                onclick="openBookingModal('${timeSlot.courtId}', '${timeSlot.courtName}', '${timeSlot.courtType}', '<fmt:formatDate value='${selectedDate}' pattern='yyyy-MM-dd'/>', '${timeSlot.startTime}', '${timeSlot.endTime}', '${timeSlot.scheduleId}', '${timeSlot.startTimeStr}', '${timeSlot.endTimeStr}')">
                                                                                                Book
                                                                                            </button>
                                                                                        </c:if>
                                                                                    </c:when>
                                                                                    <c:when test="${timeSlot.status == 'Booked'}">
                                                                                        <span class="status-badge badge-booked">Booked</span>
                                                                                    </c:when>
                                                                                    <c:otherwise>
                                                                                        <span class="status-badge badge-maintenance">Maintenance</span>
                                                                                    </c:otherwise>
                                                                                </c:choose>
                                                                            </div>
                                                                        </div>
                                                                    </c:if>
                                                                </c:forEach>
                                                            </div>
                                                        </div>
                                                    </c:if>
                                                </c:forEach>
                                            </div>
                                            <div class="legend">
                                                <div class="legend-item">
                                                    <div class="legend-color" style="background: #d4edda;"></div>
                                                    <span>Available</span>
                                                </div>
                                                <div class="legend-item">
                                                    <div class="legend-color" style="background: #f8d7da;"></div>
                                                    <span>Booked</span>
                                                </div>
                                                <div class="legend-item">
                                                    <div class="legend-color" style="background: #fff3cd;"></div>
                                                    <span>Maintenance</span>
                                                </div>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="empty-state">
                                                <div class="empty-state-icon">
                                                    <i class="fa fa-calendar-times-o"></i>
                                                </div>
                                                <h4>No Court Schedules Available</h4>
                                                <p>
                                                    <c:choose>
                                                        <c:when test="${not empty selectedDate}">
                                                            There are no court schedules available for <strong><fmt:formatDate value="${selectedDate}" pattern="MMMM dd, yyyy" /></strong>.
                                                        </c:when>
                                                        <c:otherwise>
                                                            There are no court schedules available for the selected date.
                                                        </c:otherwise>
                                                    </c:choose>
                                                </p>
                                                <p style="font-size: 14px; color: #868e96;">
                                                    This could be because:
                                                </p>
                                                <ul style="text-align: left; display: inline-block; color: #868e96; font-size: 14px;">
                                                    <li>No courts are configured for this date</li>
                                                    <li>All courts are under maintenance</li>
                                                    <li>The selected date is in the past</li>
                                                    <li>Court schedules haven't been set up yet</li>
                                                </ul>
                                                <div style="margin-top: 30px;">
                                                    <a href="booking?action=schedule&date=<fmt:formatDate value='${nextDate}' pattern='yyyy-MM-dd' />"
                                                        class="btn btn-primary" style="margin-right: 10px;">
                                                        <i class="fa fa-chevron-right"></i> Try Next Day
                                                    </a>
                                                    <a href="booking?action=schedule" class="btn btn-secondary">
                                                        <i class="fa fa-calendar"></i> Today's Schedule
                                                    </a>
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
        </div>

        <!-- Booking Modal -->
        <div class="modal fade booking-modal" id="bookingModal" tabindex="-1" aria-labelledby="bookingModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="bookingModalLabel">
                            <i class="fa fa-calendar-plus-o"></i> Book Court Slot
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form method="post" action="scheduler-manager" id="bookingForm">
                        <div class="modal-body">
                            <!-- Booking Information Display -->
                            <div class="booking-info">
                                <h6><i class="fa fa-info-circle"></i> Booking Details</h6>
                                <div class="booking-detail">
                                    <span>Court:</span>
                                    <strong id="modalCourtName">-</strong>
                                </div>
                                <div class="booking-detail">
                                    <span>Type:</span>
                                    <strong id="modalCourtType">-</strong>
                                </div>
                                <div class="booking-detail">
                                    <span>Date:</span>
                                    <strong id="modalBookingDate">-</strong>
                                </div>
                                <div class="booking-detail">
                                    <span>Time:</span>
                                    <strong id="modalBookingTime">-</strong>
                                </div>
                            </div>

                            <!-- Hidden form fields -->
                            <input type="hidden" name="courtId" id="modalCourtId">
                            <input type="hidden" name="date" id="modalDate">
                            <input type="hidden" name="startTime" id="modalStartTime">
                            <input type="hidden" name="endTime" id="modalEndTime">
                            <input type="hidden" name="courtScheduleId" id="modalScheduleId">

                            <!-- User Selection -->
                            <div class="mb-3">
                                <label for="selectedUser" class="form-label">
                                    <i class="fa fa-user"></i> Select User *
                                </label>
                                <select class="form-control" id="selectedUser" name="userId" required onchange="updateUserInfo()">
                                    <option value="">Choose a user...</option>
                                    <c:forEach var="user" items="${users}">
                                        <option value="${user.userID}" 
                                                data-fullname="${user.fullName}" 
                                                data-email="${user.email}" 
                                                data-phone="${user.phone}"
                                                data-sportlevel="${user.sportLevel}">
                                            ${user.username} - ${user.fullName}
                                        </option>
                                    </c:forEach>
                                </select>
                                <div class="user-info" id="userInfo" style="display: none;">
                                    <small>
                                        <i class="fa fa-envelope"></i> <span id="userEmail">-</span> | 
                                        <i class="fa fa-phone"></i> <span id="userPhone">-</span> | 
                                        <i class="fa fa-trophy"></i> Level: <span id="userSportLevel">-</span>
                                    </small>
                                </div>
                            </div>

                            <!-- Booking Notes -->
                            <div class="mb-3">
                                <label for="bookingNotes" class="form-label">
                                    <i class="fa fa-sticky-note"></i> Notes (Optional)
                                </label>
                                <textarea class="form-control" id="bookingNotes" name="notes" rows="3" 
                                          placeholder="Add any special requests or notes for this booking..."></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                <i class="fa fa-times"></i> Cancel
                            </button>
                            <button type="submit" class="btn btn-primary">
                                <i class="fa fa-check"></i> Confirm Booking
                            </button>
                        </div>
                    </form>
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
            $(document).ready(function() {
                setTimeout(function() {
                    $('.alert').fadeOut('slow');
                }, 5000);
            });

            // Sort table function
            function sortTable(sortBy) {
                const urlParams = new URLSearchParams(window.location.search);
                let currentSortOrder = urlParams.get('sortOrder') || 'DESC';
                
                if (urlParams.get('sortBy') === sortBy) {
                    currentSortOrder = currentSortOrder === 'ASC' ? 'DESC' : 'ASC';
                } else {
                    currentSortOrder = 'ASC';
                }
                
                urlParams.set('sortBy', sortBy);
                urlParams.set('sortOrder', currentSortOrder);
                urlParams.set('page', '1'); // Reset to first page when sorting
                
                window.location.href = 'court-manager?' + urlParams.toString();
            }

            // Edit court function
            function editCourt(courtId, courtName, courtType, description, status, courtImage) {
                const editModal = document.getElementById('editCourtModal');
                if (editModal) {
                    document.getElementById('editCourtId').value = courtId;
                    document.getElementById('editCourtName').value = courtName;
                    document.getElementById('editCourtType').value = courtType;
                    document.getElementById('editDescription').value = description || '';
                    document.getElementById('editStatus').value = status;
                    document.getElementById('editCourtImage').value = courtImage || '';
                    
                    new bootstrap.Modal(editModal).show();
                }
            }

            // Delete court function
            function deleteCourt(courtId, courtName) {
                const deleteModal = document.getElementById('deleteCourtModal');
                if (deleteModal) {
                    document.getElementById('deleteCourtId').value = courtId;
                    document.getElementById('deleteCourtName').textContent = courtName;
                    
                    new bootstrap.Modal(deleteModal).show();
                }
            }

            // Open booking modal function
            function openBookingModal(courtId, courtName, courtType, date, startTime, endTime, scheduleId, startTimeStr, endTimeStr) {
                // Validate required parameters
                if (!courtId || !scheduleId) {
                    console.error('Missing required booking parameters');
                    return;
                }
                
                // Set hidden form values
                const modalCourtId = document.getElementById('modalCourtId');
                const modalDate = document.getElementById('modalDate');
                const modalStartTime = document.getElementById('modalStartTime');
                const modalEndTime = document.getElementById('modalEndTime');
                const modalScheduleId = document.getElementById('modalScheduleId');
                
                if (modalCourtId) modalCourtId.value = courtId;
                if (modalDate) modalDate.value = date;
                if (modalStartTime) modalStartTime.value = startTimeStr;
                if (modalEndTime) modalEndTime.value = endTimeStr;
                if (modalScheduleId) modalScheduleId.value = scheduleId;
                
                // Set display values
                const modalCourtName = document.getElementById('modalCourtName');
                const modalCourtType = document.getElementById('modalCourtType');
                const modalBookingDate = document.getElementById('modalBookingDate');
                const modalBookingTime = document.getElementById('modalBookingTime');
                
                if (modalCourtName) modalCourtName.textContent = courtName;
                if (modalCourtType) modalCourtType.textContent = courtType;
                if (modalBookingDate) modalBookingDate.textContent = formatDate(date);
                if (modalBookingTime) modalBookingTime.textContent = startTimeStr + ' - ' + endTimeStr;
                
                // Reset form
                const bookingForm = document.getElementById('bookingForm');
                const userInfo = document.getElementById('userInfo');
                
                if (bookingForm) bookingForm.reset();
                if (userInfo) userInfo.style.display = 'none';
                
                // Show modal
                const bookingModal = document.getElementById('bookingModal');
                if (bookingModal) {
                    new bootstrap.Modal(bookingModal).show();
                }
            }

            // Update user info when user is selected
            function updateUserInfo() {
                const select = document.getElementById('selectedUser');
                const userInfo = document.getElementById('userInfo');
                
                if (!select || !userInfo) return;
                
                const selectedOption = select.options[select.selectedIndex];
                
                if (selectedOption.value) {
                    const userEmail = document.getElementById('userEmail');
                    const userPhone = document.getElementById('userPhone');
                    const userSportLevel = document.getElementById('userSportLevel');
                    
                    if (userEmail) userEmail.textContent = selectedOption.dataset.email || '-';
                    if (userPhone) userPhone.textContent = selectedOption.dataset.phone || '-';
                    if (userSportLevel) userSportLevel.textContent = selectedOption.dataset.sportlevel || '-';
                    userInfo.style.display = 'block';
                } else {
                    userInfo.style.display = 'none';
                }
            }

            // Format date for display
            function formatDate(dateString) {
                try {
                    const date = new Date(dateString);
                    const options = { 
                        weekday: 'long', 
                        year: 'numeric', 
                        month: 'long', 
                        day: 'numeric' 
                    };
                    return date.toLocaleDateString('en-US', options);
                } catch (error) {
                    console.error('Error formatting date:', error);
                    return dateString;
                }
            }

            // Form validation before submission
            $(document).ready(function() {
                const bookingForm = document.getElementById('bookingForm');
                if (bookingForm) {
                    bookingForm.addEventListener('submit', function(e) {
                        const selectedUser = document.getElementById('selectedUser');
                        const scheduleId = document.getElementById('modalScheduleId');
                        
                        if (!selectedUser || !selectedUser.value) {
                            e.preventDefault();
                            alert('Please select a user for the booking.');
                            return false;
                        }
                        
                        if (!scheduleId || !scheduleId.value) {
                            e.preventDefault();
                            alert('Invalid schedule information. Please try again.');
                            return false;
                        }
                        
                        return true;
                    });
                }
            });
        </script>
    </body>
</html>
