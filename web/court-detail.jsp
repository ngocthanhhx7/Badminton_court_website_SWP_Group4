<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="models.UserDTO, models.AdminDTO, models.GoogleAccount" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!doctype html>
<html class="no-js" lang="zxx">
<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>BadmintonHub - ${court.courtName} Details</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="shortcut icon" type="image/x-icon" href="img/favicon.png">
    <!-- CSS here -->
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="css/font-awesome.min.css">
    <link rel="stylesheet" href="css/style.css">
    <script src="https://cdn.tailwindcss.com"></script>
    
    <style>
        /* Your existing styles */
        .court-detail-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            overflow: hidden;
            margin-bottom: 30px;
        }
        
        .court-image-container {
            position: relative;
            overflow: hidden;
            height: 400px;
        }
        
        .court-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }
        
        .court-image:hover {
            transform: scale(1.05);
        }
        
        .status-badge {
            position: absolute;
            top: 20px;
            right: 20px;
            padding: 8px 16px;
            border-radius: 25px;
            font-weight: bold;
            text-transform: uppercase;
            font-size: 12px;
            letter-spacing: 1px;
        }
        
        .status-available {
            background: linear-gradient(45deg, #4CAF50, #45a049);
            color: white;
            box-shadow: 0 4px 15px rgba(76, 175, 80, 0.3);
        }
        
        .status-occupied {
            background: linear-gradient(45deg, #f44336, #d32f2f);
            color: white;
            box-shadow: 0 4px 15px rgba(244, 67, 54, 0.3);
        }
        
        .status-maintenance {
            background: linear-gradient(45deg, #ff9800, #f57c00);
            color: white;
            box-shadow: 0 4px 15px rgba(255, 152, 0, 0.3);
        }
        
        .court-info-card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            margin-top: -50px;
            position: relative;
            z-index: 2;
        }
        
        .court-title {
            color: #2c3e50;
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 15px;
            background: linear-gradient(45deg, #667eea, #764ba2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        /* NEW STYLES FOR RATING AND COMMENTS */
        .rating-section {
            background: linear-gradient(135deg, #ffecd2 0%, #fcb69f 100%);
            padding: 25px;
            border-radius: 15px;
            margin: 30px 0;
            text-align: center;
            box-shadow: 0 8px 25px rgba(252, 182, 159, 0.3);
        }
        .rating-title {
            color: #8b4513;
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 15px;
        }
        .stars-container {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 5px;
            margin-bottom: 10px;
        }
        .star {
            font-size: 1.8rem;
            color: #ddd;
            transition: all 0.3s ease;
        }
        .star.filled {
            color: #ffd700;
            text-shadow: 0 0 10px rgba(255, 215, 0, 0.5);
        }
        .rating-text {
            color: #8b4513;
            font-size: 1.1rem;
            font-weight: 500;
        }
        .comments-section {
            background: #f8f9fa;
            padding: 30px;
            border-radius: 15px;
            margin: 30px 0;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }
        .comments-title {
            color: #2c3e50;
            font-size: 1.8rem;
            font-weight: 600;
            margin-bottom: 25px;
            text-align: center;
            background: linear-gradient(45deg, #667eea, #764ba2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        .comment-item {
            background: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 15px;
            border-left: 4px solid #667eea;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            transition: transform 0.3s ease;
        }
        .comment-item:hover {
            transform: translateX(5px);
        }
        .comment-text {
            color: #555;
            font-size: 15px;
            line-height: 1.6;
            font-style: italic;
            position: relative;
        }
        .comment-text:before {
            content: '"';
            font-size: 2rem;
            color: #667eea;
            position: absolute;
            left: -10px;
            top: -5px;
        }
        .comment-text:after {
            content: '"';
            font-size: 2rem;
            color: #667eea;
        }
        .no-comments {
            text-align: center;
            color: #6c757d;
            font-style: italic;
            padding: 40px 20px;
        }
        
        .court-type-badge {
            display: inline-block;
            background: linear-gradient(45deg, #78350f, #a0522d);
            color: white;
            padding: 8px 20px;
            border-radius: 25px;
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 20px;
            box-shadow: 0 4px 15px rgba(120, 53, 15, 0.3);
        }
        
        .description-text {
            color: #555;
            font-size: 16px;
            line-height: 1.8;
            margin-bottom: 30px;
        }
        
        .action-buttons {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }
        
        .btn-book {
            background: linear-gradient(45deg, #667eea, #764ba2);
            border: none;
            color: white;
            padding: 12px 30px;
            border-radius: 25px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-book:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
            color: white;
            text-decoration: none;
        }
        
        .btn-schedule {
            background: linear-gradient(45deg, #28a745, #20c997);
            border: none;
            color: white;
            padding: 12px 30px;
            border-radius: 25px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-schedule:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(40, 167, 69, 0.4);
            color: white;
            text-decoration: none;
        }
        
        .btn-back {
            background: transparent;
            border: 2px solid #78350f;
            color: #78350f;
            padding: 12px 30px;
            border-radius: 25px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-back:hover {
            background: #78350f;
            color: white;
            transform: translateY(-2px);
            text-decoration: none;
        }
        
        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-top: 30px;
        }
        
        .feature-item {
            text-align: center;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 10px;
            transition: transform 0.3s ease;
        }
        
        .feature-item:hover {
            transform: translateY(-5px);
        }
        
        .feature-icon {
            font-size: 2rem;
            color: #667eea;
            margin-bottom: 10px;
        }
        
        .price-info {
            background: linear-gradient(45deg, #28a745, #20c997);
            color: white;
            padding: 20px;
            border-radius: 15px;
            text-align: center;
            margin: 20px 0;
            box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
        }
        
        .price-amount {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 5px;
        }
        
        .price-unit {
            font-size: 1rem;
            opacity: 0.9;
        }
        
        .login-prompt {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            color: #856404;
            padding: 15px;
            border-radius: 10px;
            text-align: center;
            margin: 20px 0;
        }

        /* Schedule Section Styles */
        .schedule-container {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            padding: 60px 0;
            margin-top: 40px;
        }
        
        .schedule-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        .schedule-header {
            background: linear-gradient(45deg, #667eea, #764ba2);
            color: white;
            padding: 30px;
            text-align: center;
        }
        
        .schedule-header h3 {
            margin: 0;
            font-size: 1.8rem;
            font-weight: 600;
        }
        
        .date-selector {
            background: white;
            padding: 20px;
            border-bottom: 1px solid #e9ecef;
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
        
        .time-slots-container {
            padding: 30px;
        }
        
        .time-slot {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px;
            margin-bottom: 10px;
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
        
        .btn-book-slot {
            background: #28a745;
            color: white;
            border: none;
            padding: 8px 20px;
            border-radius: 5px;
            font-size: 14px;
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

        .status-badge-schedule {
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 14px;
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
        
        .no-schedule {
            text-align: center;
            padding: 60px 20px;
            color: #6c757d;
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

        /* NEW: Multiple Selection Styles */
        .time-slot-checkbox {
            margin-right: 15px;
            transform: scale(1.2);
            cursor: pointer;
        }

        .time-slot.selected {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: 2px solid #5a6fd8;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }

        .selection-controls {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 20px;
            border-radius: 15px;
            margin: 20px 0;
            text-align: center;
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
        }

        .selection-info {
            color: white;
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 15px;
        }

        .btn-book-selected {
            background: linear-gradient(45deg, #28a745, #20c997);
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 25px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
            cursor: pointer;
            margin-right: 10px;
        }

        .btn-book-selected:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(40, 167, 69, 0.4);
        }

        .btn-book-selected:disabled {
            background: #6c757d;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }

        .btn-clear-selection {
            background: transparent;
            color: white;
            border: 2px solid white;
            padding: 12px 30px;
            border-radius: 25px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .btn-clear-selection:hover {
            background: white;
            color: #667eea;
            transform: translateY(-2px);
        }

        .selected-slots-list {
            background: rgba(255, 255, 255, 0.1);
            padding: 15px;
            border-radius: 10px;
            margin: 15px 0;
            color: white;
        }

        .selected-slot-item {
            display: inline-block;
            background: rgba(255, 255, 255, 0.2);
            padding: 5px 12px;
            border-radius: 15px;
            margin: 3px;
            font-size: 14px;
        }
        
        @media (max-width: 768px) {
            .court-title {
                font-size: 2rem;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .btn-book, .btn-schedule, .btn-back {
                width: 100%;
                text-align: center;
            }
            
            .date-nav {
                flex-direction: column;
                gap: 10px;
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
    <div class="bradcam_area breadcam_bg_1">
        <h3>Court Details</h3>
    </div>
    <!-- bradcam_area_end -->

    <!-- Court Detail Section Start -->
    <div class="container" style="padding: 60px 0;">
        <c:if test="${not empty court}">
            <div class="row justify-content-center">
                <div class="col-lg-10">
                    <div class="court-detail-card">
                        <!-- Court Image -->
                        <div class="court-image-container">
                            <img src="${not empty court.courtImage ? court.courtImage : 'img/court-placeholder.jpg'}"
                                 alt="${court.courtName}" class="court-image">
                        </div>
                        
                        <!-- Court Information -->
                        <div class="court-info-card">
                            <h1 class="court-title">${court.courtName}</h1>
                            
                            <div class="court-type-badge">
                                <i class="fa fa-tag"></i> ${court.courtType}
                            </div>
                            
                            <p class="description-text">
                                <c:choose>
                                    <c:when test="${not empty court.description}">
                                        ${court.description}
                                    </c:when>
                                    <c:otherwise>
                                        This is a premium badminton court equipped with professional-grade flooring,
                                        excellent lighting, and climate control. Perfect for both recreational and
                                        competitive play. The court meets international standards and provides an
                                        exceptional playing experience for all skill levels.
                                    </c:otherwise>
                                </c:choose>
                            </p>
                            
                            <!-- Features Grid -->
                            <div class="features-grid">
                                <div class="feature-item">
                                    <div class="feature-icon">
                                        <i class="fa fa-check-circle"></i>
                                    </div>
                                    <h5>Professional Grade</h5>
                                    <p>High-quality flooring and equipment</p>
                                </div>
                                <div class="feature-item">
                                    <div class="feature-icon">
                                        <i class="fa fa-lightbulb-o"></i>
                                    </div>
                                    <h5>LED Lighting</h5>
                                    <p>Optimal lighting for perfect visibility</p>
                                </div>
                                <div class="feature-item">
                                    <div class="feature-icon">
                                        <i class="fa fa-snowflake-o"></i>
                                    </div>
                                    <h5>Climate Control</h5>
                                    <p>Comfortable temperature year-round</p>
                                </div>
                                <div class="feature-item">
                                    <div class="feature-icon">
                                        <i class="fa fa-shield"></i>
                                    </div>
                                    <h5>Safety First</h5>
                                    <p>Non-slip surface and safety equipment</p>
                                </div>
                            </div>
                            
                            <div class="rating-section">
                                <h4 class="rating-title">
                                    <i class="fa fa-star"></i> Customer Rating
                                </h4>
                                <div class="stars-container">
                                    <c:choose>
                                        <c:when test="${not empty avgRating && avgRating > 0}">
                                            <c:forEach var="i" begin="1" end="5">
                                                <i class="fa fa-star star ${i <= avgRating ? 'filled' : ''}"></i>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="i" begin="1" end="5">
                                                <i class="fa fa-star star"></i>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="rating-text">
                                    <c:choose>
                                        <c:when test="${not empty avgRating && avgRating > 0}">
                                            <fmt:formatNumber value="${avgRating}" maxFractionDigits="1" minFractionDigits="1"/> out of 5 stars
                                        </c:when>
                                        <c:otherwise>
                                            No ratings yet
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <!-- NEW: Comments Section -->
                            <div class="comments-section">
                                <h4 class="comments-title">
                                    <i class="fa fa-comments"></i> Customer Reviews
                                </h4>
                                <c:choose>
                                    <c:when test="${not empty notes}">
                                        <c:forEach var="note" items="${notes}">
                                            <div class="comment-item">
                                                <p class="comment-text">${note}</p>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="no-comments">
                                            <i class="fa fa-comment-o" style="font-size: 2rem; margin-bottom: 10px; display: block;"></i>
                                            No reviews available yet. Be the first to leave a review!
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            
                            <!-- User Authentication Check -->
                            <c:choose>
                                <c:when test="${not empty sessionScope.acc}">
                                    <!-- Action Buttons for Logged-in Users -->
                                    <div class="action-buttons">
                                        <a href="booking?action=schedule" class="btn-schedule" onclick="scrollToSchedule()">
                                            <i class="fa fa-clock-o"></i> View Schedule Below
                                        </a>
                                        
                                        <a href="court" class="btn-back">
                                            <i class="fa fa-arrow-left"></i> Back to Courts
                                        </a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <!-- Login Prompt for Non-logged-in Users -->
                                    <div class="login-prompt">
                                        <i class="fa fa-info-circle"></i>
                                        <strong>Please login to book this court</strong>
                                    </div>
                                    
                                    <div class="action-buttons">
                                        <a href="Login" class="btn-book">
                                            <i class="fa fa-sign-in"></i> Login to Book
                                        </a>
                                        
                                        <a href="booking?action=schedule" class="btn-schedule" onclick="scrollToSchedule()">
                                            <i class="fa fa-clock-o"></i> View Schedule Below
                                        </a>
                                        
                                        <a href="court" class="btn-back">
                                            <i class="fa fa-arrow-left"></i> Back to Courts
                                        </a>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>
        
        <c:if test="${empty court}">
            <div class="row justify-content-center">
                <div class="col-lg-8 text-center">
                    <div class="alert alert-warning" style="padding: 40px; border-radius: 15px;">
                        <i class="fa fa-exclamation-triangle" style="font-size: 3rem; color: #f39c12; margin-bottom: 20px;"></i>
                        <h3>Court Not Found</h3>
                        <p>The requested court could not be found. Please check the URL or return to the courts listing.</p>
                        <a href="court" class="btn btn-primary" style="margin-top: 20px;">
                            <i class="fa fa-arrow-left"></i> Back to Courts
                        </a>
                    </div>
                </div>
            </div>
        </c:if>
    </div>
    <!-- Court Detail Section End -->

    <!-- Schedule Section Start -->
    <div class="schedule-container" id="schedule-section">
        <div class="container">
            <div class="row">
                <div class="col-12">
                    <div class="schedule-card">
                        <div class="schedule-header">
                            <h3><i class="fa fa-calendar"></i> ${court.courtName} Schedule</h3>
                            <p>Available time slots for this court</p>
                        </div>
                        
                        <div class="date-selector">
                            <div class="date-nav">
                                <a href="court-detail?courtId=${court.courtId}&date=<fmt:formatDate value='${prevDate}' pattern='yyyy-MM-dd' />#schedule-section" class="date-nav-btn">
                                    <i class="fa fa-chevron-left"></i> Previous Day
                                </a>
                                <div class="current-date">
                                    <c:choose>
                                        <c:when test="${not empty selectedDate}">
                                            <fmt:formatDate value="${selectedDate}" pattern="EEEE, MMMM dd, yyyy" />
                                        </c:when>
                                        <c:otherwise>
                                            <fmt:formatDate value="${now}" pattern="EEEE, MMMM dd, yyyy" />
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <a href="court-detail?courtId=${court.courtId}&date=<fmt:formatDate value='${nextDate}' pattern='yyyy-MM-dd' />#schedule-section" class="date-nav-btn">
                                    Next Day <i class="fa fa-chevron-right"></i>
                                </a>
                            </div>
                            
                            <!-- NEW: Date Picker -->
                            <div class="date-picker-container">
                                <div class="date-picker-title">
                                    <i class="fa fa-calendar-o"></i>
                                    Select a Specific Date
                                </div>
                                <form class="date-picker-form" method="GET" action="court-detail?courtId=${court.courtId}">
                                    <input type="hidden" name="courtId" value="${court.courtId}">
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

                        <!-- NEW: Multiple Selection Controls -->
                        <c:if test="${not empty sessionScope.acc}">
                            <div class="selection-controls" id="selectionControls" style="display: none;">
                                <div class="selection-info">
                                    <i class="fa fa-check-square-o"></i>
                                    <span id="selectedCount">0</span> time slot(s) selected
                                </div>
                                <div class="selected-slots-list" id="selectedSlotsList"></div>
                                <button type="button" class="btn-book-selected" id="bookSelectedBtn" onclick="bookSelectedSlots()" disabled>
                                    <i class="fa fa-calendar-check-o"></i> Book Selected Slots
                                </button>
                                <button type="button" class="btn-clear-selection" onclick="clearAllSelections()">
                                    <i class="fa fa-times"></i> Clear Selection
                                </button>
                            </div>
                        </c:if>
                        
                        <div class="time-slots-container">
                            <c:choose>
                                <c:when test="${not empty schedules}">
                                    <c:forEach var="schedule" items="${schedules}">
                                        <div class="time-slot ${schedule.status.toLowerCase()}" id="slot-${schedule.scheduleId}">
                                            <div style="
                                                display: flex;
                                                align-items: center;
                                                gap: 15px;
                                            ">
                                                <!-- NEW: Checkbox for multiple selection -->
                                                <c:if test="${not empty sessionScope.acc && schedule.status == 'Available' && not schedule.expire}">
                                                    <input type="checkbox" 
                                                           class="time-slot-checkbox" 
                                                           id="checkbox-${schedule.scheduleId}"
                                                           value="${schedule.scheduleId}"
                                                           data-time="${schedule.startTimeStr} - ${schedule.endTimeStr}"
                                                           data-price="${schedule.price}"
                                                           onchange="handleSlotSelection(this)">
                                                </c:if>
                                                
                                                <div style="
                                                    display: flex;
                                                    justify-content: space-between;
                                                    align-items: center;
                                                    padding: 12px 16px;
                                                    margin-bottom: 10px;
                                                    border-radius: 12px;
                                                    background-color: #f9f9f9;
                                                    box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
                                                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                                                    flex: 1;
                                                ">
                                                    <div style="font-size: 16px; font-weight: 600; color: #37474F;">
                                                        ⏰ ${schedule.startTimeStr} - ${schedule.endTimeStr}
                                                    </div>
                                                    <div style="font-size: 16px; font-weight: 600; color: #2E7D32;">
                                                        💰 ${schedule.price} ₫
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <div>
                                                <c:choose>
                                                    <c:when test="${schedule.status == 'Available'}">
                                                        <c:choose>
                                                            <c:when test="${not schedule.expire}">
                                                                <!-- Available -->
                                                                <span class="status-badge-schedule badge-available">Available</span>
                                                                <c:if test="${not empty sessionScope.acc}">
                                                                    <!-- Individual Book Now button -->
                                                                    <a href="booking?courtScheduleIds=${schedule.scheduleId}"
                                                                       class="inline-block bg-green-600 hover:bg-green-700 text-white font-semibold py-1.5 px-4 rounded-xl text-sm shadow-sm transition">
                                                                        <i class="fa fa-calendar-check-o mr-1"></i> Book Now
                                                                    </a>
                                                                    <!-- Add to Cart button -->
<!--                                                                    <form action="CartServlet" method="post" class="inline-block ml-2">
                                                                        <input type="hidden" name="action" value="create" />
                                                                        <input type="hidden" name="scheduleId" value="${schedule.scheduleId}" />
                                                                        <input type="hidden" name="price" value="${schedule.price}" />
                                                                        <button type="submit"
                                                                                class="bg-blue-600 hover:bg-blue-700 text-white font-semibold py-1.5 px-4 rounded-xl text-sm shadow-sm transition">
                                                                            <i class="fa fa-shopping-cart mr-1"></i> Add to Cart
                                                                        </button>
                                                                    </form>-->
                                                                </c:if>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <!-- Expired -->
                                                                <span class="status-badge-schedule badge-expired">Expired</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:when>
                                                    <c:when test="${schedule.status == 'Booked'}">
                                                        <span class="status-badge-schedule badge-booked">Booked</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge-schedule badge-maintenance">Maintenance</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="no-schedule">
                                        <i class="fa fa-calendar-times-o" style="font-size: 4rem; color: #dee2e6; margin-bottom: 20px;"></i>
                                        <h4 style="color: #6c757d; margin-bottom: 15px;">No Schedules Available</h4>
                                        <p style="color: #868e96;">
                                            There are no time slots available for this court on the selected date.
                                        </p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Schedule Section End -->

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
    <script src="js/vendor/modernizr-3.5.0.min.js"></script>
    <script src="js/vendor/jquery-1.12.4.min.js"></script>
    <script src="js/popper.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script src="js/main.js"></script>
    
    <script>
        // NEW: Multiple selection functionality
        let selectedSlots = [];

        function handleSlotSelection(checkbox) {
            const scheduleId = checkbox.value;
            const timeSlot = checkbox.getAttribute('data-time');
            const price = checkbox.getAttribute('data-price');
            const slotElement = document.getElementById('slot-' + scheduleId);

            if (checkbox.checked) {
                // Add to selection
                selectedSlots.push({
                    id: scheduleId,
                    time: timeSlot,
                    price: price
                });
                slotElement.classList.add('selected');
            } else {
                selectedSlots = selectedSlots.filter(slot => slot.id !== scheduleId);
                slotElement.classList.remove('selected');
            }

            updateSelectionDisplay();
        }

        function updateSelectionDisplay() {
            const selectionControls = document.getElementById('selectionControls');
            const selectedCount = document.getElementById('selectedCount');
            const selectedSlotsList = document.getElementById('selectedSlotsList');
            const bookSelectedBtn = document.getElementById('bookSelectedBtn');

            if (selectedSlots.length > 0) {
                selectionControls.style.display = 'block';
                selectedCount.textContent = selectedSlots.length;
                bookSelectedBtn.disabled = false;

                // Display selected slots
               selectedSlotsList.innerHTML = selectedSlots.map(function(slot) {
                            return '<span class="selected-slot-item">' + slot.time + ' - ' + slot.price + '₫</span>';
                        }).join('');
            } else {
                selectionControls.style.display = 'none';
                bookSelectedBtn.disabled = true;
                selectedSlotsList.innerHTML = '';
            }
        }

        function bookSelectedSlots() {
            if (selectedSlots.length === 0) {
                alert('Please select at least one time slot.');
                return;
            }

            const scheduleIds = selectedSlots.map(slot => slot.id).join(',');
            const bookingUrl = `booking?courtScheduleIds=` + scheduleIds;
            window.location.href = bookingUrl;
        }

        function clearAllSelections() {
            // Uncheck all checkboxes
            const checkboxes = document.querySelectorAll('.time-slot-checkbox');
            checkboxes.forEach(checkbox => {
                checkbox.checked = false;
                const slotElement = document.getElementById('slot-' + checkbox.value);
                slotElement.classList.remove('selected');
            });

            selectedSlots = [];
            updateSelectionDisplay();
        }

        // Smooth scroll to schedule section
        function scrollToSchedule() {
            document.getElementById('schedule-section').scrollIntoView({
                behavior: 'smooth'
            });
        }
        
        // Add smooth scrolling and animations
        $(document).ready(function() {
            $('.court-detail-card').addClass('animate__animated animate__fadeInUp');
            
            // Add hover effects to feature items
            $('.feature-item').hover(
                function() {
                    $(this).addClass('animate__animated animate__pulse');
                },
                function() {
                    $(this).removeClass('animate__animated animate__pulse');
                }
            );
            
            // Auto-scroll to schedule if hash is present
            if (window.location.hash === '#schedule-section') {
                setTimeout(function() {
                    scrollToSchedule();
                }, 500);
            }
        });
    </script>
</body>
</html>
