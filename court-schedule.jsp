<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="models.UserDTO, models.AdminDTO, models.GoogleAccount" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!doctype html>
<html class="no-js" lang="zxx">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>BadmintonHub - Court Schedule</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon" href="img/favicon.png">

    <!-- CSS here -->
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="css/font-awesome.min.css">
    <link rel="stylesheet" href="css/style.css">

    <script src="https://cdn.tailwindcss.com"></script>
    
    <style>
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
            text-decoration: none;
            display: inline-block;
        }

        .btn-book-slot:hover {
            background: #218838;
            transform: scale(1.05);
            color: white;
            text-decoration: none;
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

    <!-- Schedule Section -->
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
                                                                               <a href="booking?courtId=${timeSlot.courtId}&date=<fmt:formatDate value='${selectedDate}' pattern='yyyy-MM-dd'/>&startTime=${timeSlot.startTime}&endTime=${timeSlot.endTime}&courtScheduleId=${timeSlot.scheduleId}" 
                                                                                    class="btn-book-slot">
                                                                                    Book
                                                                                 </a>
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

    <!-- footer -->
    <!-- footer  --> 

    <!-- JS here -->
    <script src="js/vendor/jquery-1.12.4.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script src="js/main.js"></script>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Auto-refresh every 5 minutes to show updated schedules
            setInterval(function() {
                location.reload();
            }, 300000);
        });
    </script>
</body>
</html>