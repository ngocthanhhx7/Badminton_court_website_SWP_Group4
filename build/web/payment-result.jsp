<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="models.UserDTO, models.AdminDTO, models.GoogleAccount" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!doctype html>
<html class="no-js" lang="zxx">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>BadmintonHub - Payment Result</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon" href="img/favicon.png">

    <!-- CSS here -->
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="css/font-awesome.min.css">
    <link rel="stylesheet" href="css/style.css">

    <script src="https://cdn.tailwindcss.com"></script>
    
    <style>
        .result-container {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 40px 0;
            display: flex;
            align-items: center;
        }
        
        .result-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            overflow: hidden;
            max-width: 600px;
            margin: 0 auto;
        }
        
        .result-header {
            padding: 40px;
            text-align: center;
        }
        
        .success-header {
            background: linear-gradient(45deg, #28a745, #20c997);
            color: white;
        }
        
        .error-header {
            background: linear-gradient(45deg, #dc3545, #c82333);
            color: white;
        }
        
        .result-icon {
            font-size: 4rem;
            margin-bottom: 20px;
        }
        
        .result-title {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 10px;
        }
        
        .result-message {
            font-size: 1.1rem;
            opacity: 0.9;
        }
        
        .result-details {
            padding: 40px;
        }
        
        .detail-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 0;
            border-bottom: 1px solid #e9ecef;
        }
        
        .detail-item:last-child {
            border-bottom: none;
        }
        
        .detail-label {
            font-weight: 600;
            color: #2c3e50;
        }
        
        .detail-value {
            color: #6c757d;
        }
        
        .amount-highlight {
            font-size: 1.5rem;
            font-weight: 700;
            color: #28a745;
        }
        
        .result-actions {
            padding: 30px 40px;
            background: #f8f9fa;
            text-align: center;
        }
        
        .btn-action {
            padding: 12px 30px;
            border-radius: 25px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            margin: 0 10px;
        }
        
        .btn-primary {
            background: linear-gradient(45deg, #667eea, #764ba2);
            color: white;
            border: none;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
            color: white;
        }
        
        .btn-secondary {
            background: transparent;
            color: #6c757d;
            border: 2px solid #6c757d;
        }
        
        .btn-secondary:hover {
            background: #6c757d;
            color: white;
        }
        
        .confetti {
            position: absolute;
            width: 10px;
            height: 10px;
            background: #f39c12;
            animation: confetti-fall 3s linear infinite;
        }
        
        @keyframes confetti-fall {
            0% {
                transform: translateY(-100vh) rotate(0deg);
                opacity: 1;
            }
            100% {
                transform: translateY(100vh) rotate(720deg);
                opacity: 0;
            }
        }
        
        .success-animation {
            animation: bounce 1s ease-in-out;
        }
        
        @keyframes bounce {
            0%, 20%, 50%, 80%, 100% {
                transform: translateY(0);
            }
            40% {
                transform: translateY(-20px);
            }
            60% {
                transform: translateY(-10px);
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

    <!-- Payment Result Section -->
    <div class="result-container">
        <div class="container">
            <div class="row">
                <div class="col-12">
                    <div class="result-card">
                        <c:choose>
                            <c:when test="${not empty message}">
                                <!-- Success Result -->
                                <div class="result-header success-header">
                                    <div class="result-icon success-animation">
                                        <i class="fa fa-check-circle"></i>
                                    </div>
                                    <h2 class="result-title">Payment Successful!</h2>
                                    <p class="result-message">${message}</p>
                                </div>
                                
                                <div class="result-details">
                                    <div class="detail-item">
                                        <span class="detail-label">
                                            <i class="fa fa-ticket"></i> Booking ID
                                        </span>
                                        <span class="detail-value">
                                            <c:choose>
                                                <c:when test="${not empty booking}">
                                                    #${booking.bookingId}
                                                </c:when>
                                                <c:otherwise>
                                                    #${bookingId}
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                    
                                    <c:if test="${not empty booking}">
                                        <!-- Display booking details if available -->
                                        <c:forEach var="detail" items="${booking.bookingDetails}">
                                            <div class="detail-item">
                                                <span class="detail-label">
                                                    <i class="fa fa-map-marker"></i> Court
                                                </span>
                                                <span class="detail-value">${detail.courtName} (${detail.courtType})</span>
                                            </div>
                                            
                                            <div class="detail-item">
                                                <span class="detail-label">
                                                    <i class="fa fa-clock-o"></i> Time Slot
                                                </span>
                                                <span class="detail-value">
                                                    <fmt:formatDate value="${detail.startTime}" pattern="MMM dd, yyyy 'at' HH:mm" /> - 
                                                    <fmt:formatDate value="${detail.endTime}" pattern="HH:mm" />
                                                </span>
                                            </div>
                                        </c:forEach>
                                        
                                        <!-- Display booking services if any -->
                                        <c:if test="${not empty booking.bookingServices}">
                                            <div class="detail-item">
                                                <span class="detail-label">
                                                    <i class="fa fa-plus-circle"></i> Additional Services
                                                </span>
                                                <span class="detail-value">
                                                    <c:forEach var="service" items="${booking.bookingServices}" varStatus="status">
                                                        ${service.serviceName} (x${service.quantity})<c:if test="${!status.last}">, </c:if>
                                                    </c:forEach>
                                                </span>
                                            </div>
                                        </c:if>
                                    </c:if>
                                    
                                    <div class="detail-item">
                                        <span class="detail-label">
                                            <i class="fa fa-money"></i> Amount Paid
                                        </span>
                                        <span class="detail-value amount-highlight">
                                            <c:choose>
                                                <c:when test="${not empty amount}">
                                                    <fmt:formatNumber value="${amount}" type="number" groupingUsed="true" />₫
                                                </c:when>
                                                <c:otherwise>
                                                    ${param.vnp_Amount / 100}₫
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                    
                                    <div class="detail-item">
                                        <span class="detail-label">
                                            <i class="fa fa-credit-card"></i> Payment Method
                                        </span>
                                        <span class="detail-value">
                                            <c:choose>
                                                <c:when test="${not empty paymentMethod}">
                                                    ${paymentMethod}
                                                </c:when>
                                                <c:otherwise>
                                                    VNPay
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                    
                                    <c:if test="${not empty transactionNo}">
                                        <div class="detail-item">
                                            <span class="detail-label">
                                                <i class="fa fa-barcode"></i> Transaction No
                                            </span>
                                            <span class="detail-value">${transactionNo}</span>
                                        </div>
                                    </c:if>
                                    
                                    <div class="detail-item">
                                        <span class="detail-label">
                                            <i class="fa fa-calendar"></i> Payment Date
                                        </span>
                                        <span class="detail-value">
                                            <jsp:useBean id="now" class="java.util.Date" />
                                            <fmt:formatDate value="${now}" pattern="MMM dd, yyyy 'at' HH:mm" />
                                        </span>
                                    </div>
                                    
                                    <div class="detail-item">
                                        <span class="detail-label">
                                            <i class="fa fa-check"></i> Status
                                        </span>
                                        <span class="detail-value" style="color: #28a745; font-weight: 600;">
                                            Confirmed & Paid
                                        </span>
                                    </div>
                                </div>
                                
                                <div class="result-actions">
                                    <a href="booking?action=my-bookings" class="btn-action btn-primary">
                                        <i class="fa fa-list"></i> View My Bookings
                                    </a>
                                    <a href="court" class="btn-action btn-secondary">
                                        <i class="fa fa-plus"></i> Book Another Court
                                    </a>
                                </div>
                            </c:when>
                            
                            <c:otherwise>
                                <!-- Error Result -->
                                <div class="result-header error-header">
                                    <div class="result-icon">
                                        <i class="fa fa-times-circle"></i>
                                    </div>
                                    <h2 class="result-title">Payment Failed</h2>
                                    <p class="result-message">
                                        <c:choose>
                                            <c:when test="${not empty error}">
                                                ${error}
                                            </c:when>
                                            <c:otherwise>
                                                Unfortunately, your payment could not be processed.
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                                
                                <div class="result-details">
                                    <div style="text-align: center; padding: 20px; color: #6c757d;">
                                        <i class="fa fa-info-circle" style="font-size: 2rem; margin-bottom: 15px;"></i>
                                        <p>Don't worry! No charges have been made to your account.</p>
                                        <p>You can try booking again or contact our support team for assistance.</p>
                                    </div>
                                </div>
                                
                                <div class="result-actions">
                                    <a href="court" class="btn-action btn-primary">
                                        <i class="fa fa-refresh"></i> Try Again
                                    </a>
                                    <a href="contact.jsp" class="btn-action btn-secondary">
                                        <i class="fa fa-support"></i> Contact Support
                                    </a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- footer -->

    <!-- JS here -->
    <script src="js/vendor/jquery-1.12.4.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script src="js/main.js"></script>
    
    <script>
        // Create confetti effect for successful payments
        <c:if test="${not empty message}">
            function createConfetti() {
                const colors = ['#f39c12', '#e74c3c', '#3498db', '#2ecc71', '#9b59b6'];
                
                for (let i = 0; i < 50; i++) {
                    setTimeout(() => {
                        const confetti = document.createElement('div');
                        confetti.className = 'confetti';
                        confetti.style.left = Math.random() * 100 + 'vw';
                        confetti.style.backgroundColor = colors[Math.floor(Math.random() * colors.length)];
                        confetti.style.animationDelay = Math.random() * 3 + 's';
                        confetti.style.animationDuration = (Math.random() * 3 + 2) + 's';
                        document.body.appendChild(confetti);
                        
                        setTimeout(() => {
                            confetti.remove();
                        }, 5000);
                    }, i * 100);
                }
            }
            
            // Start confetti after page load
            setTimeout(createConfetti, 500);
        </c:if>
        
        // Auto redirect to bookings page after 10 seconds for successful payments
        <c:if test="${not empty message}">
            let countdown = 10;
            const countdownElement = document.createElement('p');
            countdownElement.style.textAlign = 'center';
            countdownElement.style.color = '#6c757d';
            countdownElement.style.marginTop = '20px';
            document.querySelector('.result-actions').appendChild(countdownElement);
            
            const updateCountdown = () => {
                countdownElement.textContent = `Redirecting to your bookings in ${countdown} seconds...`;
                countdown--;
                
                if (countdown < 0) {
                    window.location.href = 'booking?action=my-bookings';
                }
            };
            
            updateCountdown();
            setInterval(updateCountdown, 1000);
        </c:if>
    </script>
</body>
</html>