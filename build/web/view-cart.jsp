<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="models.UserDTO, models.AdminDTO, models.GoogleAccount" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!doctype html>
<html class="no-js" lang="zxx">
<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>BadmintonHub - Shopping Cart</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="shortcut icon" type="image/x-icon" href="img/favicon.png">
    
    <!-- CSS here -->
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="css/font-awesome.min.css">
    <link rel="stylesheet" href="css/style.css">
    <script src="https://cdn.tailwindcss.com"></script>
    
    <style>
        .cart-container {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            padding: 60px 0;
            min-height: 80vh;
        }
        
        .cart-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            overflow: hidden;
            margin-bottom: 30px;
        }
        
        .cart-header {
            background: linear-gradient(45deg, #667eea, #764ba2);
            color: white;
            padding: 30px;
            text-align: center;
        }
        
        .cart-header h2 {
            margin: 0;
            font-size: 2.2rem;
            font-weight: 700;
        }
        
        .cart-item {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 20px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            border: 1px solid #e9ecef;
            transition: all 0.3s ease;
        }
        
        .cart-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.12);
        }
        
        .court-info {
            display: flex;
            align-items: center;
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
            padding: 4px 12px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: 600;
            margin-left: 15px;
        }
        
        .schedule-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }
        
        .detail-item {
            display: flex;
            align-items: center;
            color: #555;
            padding: 8px 0;
        }
        
        .detail-item i {
            color: #667eea;
            margin-right: 8px;
            width: 16px;
            text-align: center;
        }
        
        .detail-label {
            font-weight: 600;
            margin-right: 8px;
        }
        
        .price-section {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 20px;
            border-top: 2px solid #e9ecef;
        }
        
        .price-amount {
            font-size: 1.5rem;
            font-weight: 700;
            color: #28a745;
        }
        
        .btn-remove {
            background: linear-gradient(45deg, #dc3545, #c82333);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 25px;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(220, 53, 69, 0.3);
            cursor: pointer;
        }
        
        .btn-remove:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(220, 53, 69, 0.4);
            color: white;
        }
        
        .cart-summary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 15px;
            margin-top: 30px;
        }
        
        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
            padding-bottom: 15px;
            border-bottom: 1px solid rgba(255,255,255,0.2);
        }
        
        .summary-row:last-child {
            border-bottom: none;
            margin-bottom: 0;
            font-size: 1.3rem;
            font-weight: 700;
        }
        
        .btn-checkout {
            background: linear-gradient(45deg, #28a745, #20c997);
            color: white;
            border: none;
            padding: 15px 40px;
            border-radius: 25px;
            font-weight: 700;
            font-size: 1.1rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
            width: 100%;
            margin-top: 20px;
            cursor: pointer;
        }
        
        .btn-checkout:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(40, 167, 69, 0.4);
            color: white;
        }
        
        .btn-continue {
            background: transparent;
            border: 2px solid #667eea;
            color: #667eea;
            padding: 12px 30px;
            border-radius: 25px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            margin-right: 15px;
        }
        
        .btn-continue:hover {
            background: #667eea;
            color: white;
            transform: translateY(-2px);
            text-decoration: none;
        }
        
        .empty-cart {
            text-align: center;
            padding: 80px 20px;
            color: #6c757d;
        }
        
        .empty-cart i {
            font-size: 5rem;
            color: #dee2e6;
            margin-bottom: 30px;
        }
        
        .empty-cart h3 {
            color: #495057;
            margin-bottom: 20px;
        }
        
        .status-badge {
            padding: 6px 12px;
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
        
        @media (max-width: 768px) {
            .cart-header h2 {
                font-size: 1.8rem;
            }
            
            .schedule-details {
                grid-template-columns: 1fr;
            }
            
            .price-section {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }
            
            .court-info {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
            
            .court-type {
                margin-left: 0;
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
        <h3>Shopping Cart</h3>
    </div>
    <!-- bradcam_area_end -->

    <!-- Cart Section Start -->
    <div class="cart-container">
        <div class="container">
            <div class="row">
                <div class="col-12">
                    <div class="cart-card">
                        <div class="cart-header">
                            <h2><i class="fa fa-shopping-cart"></i> Your Cart</h2>
                            <p>Review your selected court bookings</p>
                        </div>
                        
                        <div style="padding: 30px;">
                            <c:choose>
                                <c:when test="${not empty cartItems}">
                                    <!-- Cart Items -->
                                    <c:set var="totalAmount" value="0" />
                                    <c:forEach var="item" items="${cartItems}" varStatus="status">
                                        <c:set var="schedule" value="${scheduleMap[item.cartItemID]}" />
                                        <c:set var="totalAmount" value="${totalAmount + item.price}" />
                                        
                                        <div class="cart-item">
                                            <div class="court-info">
                                                <h4 class="court-name">
                                                    <c:choose>
                                                        <c:when test="${not empty schedule.courtName}">
                                                            ${schedule.courtName}
                                                        </c:when>
                                                        <c:otherwise>
                                                            Court #${schedule.courtId}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </h4>
                                                <c:if test="${not empty schedule.courtType}">
                                                    <span class="court-type">
                                                        <i class="fa fa-tag"></i> ${schedule.courtType}
                                                    </span>
                                                </c:if>
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
                                                    <i class="fa fa-calendar-plus-o"></i>
                                                    <span class="detail-label">Added:</span>
                                                    <span>${item.createdAt}</span>
                                                </div>
                                            </div>
                                            
                                            <div class="price-section">
                                                <div class="price-amount">
                                                    <i class="fa fa-money"></i> 
                                                    <span class="price-value" data-price="${item.price}">${item.price}</span> VND
                                                </div>
                                                <form action="CartServlet" method="post" style="display: inline;">
                                                    <input type="hidden" name="action" value="delete" />
                                                    <input type="hidden" name="cartItemId" value="${item.cartItemID}" />
                                                    <button type="submit" class="btn-remove" 
                                                            onclick="return confirm('Are you sure you want to remove this item from your cart?')">
                                                        <i class="fa fa-trash"></i> Remove
                                                    </button>
                                                </form>
                                            </div>
                                        </div>
                                    </c:forEach>
                                    
                                    <!-- Cart Summary -->
                                    <div class="cart-summary">
                                        <h3 style="margin-bottom: 25px; text-align: center;">
                                            <i class="fa fa-calculator"></i> Order Summary
                                        </h3>
                                        
                                        <div class="summary-row">
                                            <span>Number of Courts:</span>
                                            <span>${cartItems.size()}</span>
                                        </div>
                                        
                                        <div class="summary-row">
                                            <span>Subtotal:</span>
                                            <span class="subtotal-value" data-total="${totalAmount}">${totalAmount} VND</span>
                                        </div>
                                        
                                        
                                        <div class="summary-row">
                                            <span><strong>Total Amount:</strong></span>
                                            <span><strong class="total-value" data-total="${totalAmount}">${totalAmount} VND</strong></span>
                                        </div>
                                        
                                       
                                    </div>
                                    
                                    <!-- Action Buttons -->
                                   <div style="text-align: center; margin-top: 30px;">
                                        <a href="court"
                                           class="inline-block bg-gray-500 hover:bg-gray-600 text-white font-semibold py-1.5 px-4 rounded-xl text-sm shadow-sm transition mr-2">
                                            <i class="fa fa-arrow-left"></i> Continue Shopping
                                        </a>

                                        <a href="booking?courtScheduleIds=${courtScheduleIds}"
                                           class="inline-block bg-green-600 hover:bg-green-700 text-white font-semibold py-1.5 px-4 rounded-xl text-sm shadow-sm transition">
                                            <i class="fa fa-credit-card"></i> Proceed to Checkout
                                        </a>
                                    </div>

                                    
                                </c:when>
                                <c:otherwise>
                                    <!-- Empty Cart -->
                                    <div class="empty-cart">
                                        <i class="fa fa-shopping-cart"></i>
                                        <h3>Your cart is empty</h3>
                                        <p>Looks like you haven't added any court bookings to your cart yet.</p>
                                        <a href="court" class="btn-checkout" style="display: inline-block; width: auto; margin-top: 30px;">
                                            <i class="fa fa-search"></i> Browse Courts
                                        </a>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Cart Section End -->

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
        // Function to format number with commas
        function formatPrice(price) {
            return parseFloat(price).toLocaleString('vi-VN');
        }
        
        $(document).ready(function() {
            // Format all prices on page load
            $('.price-value').each(function() {
                var price = $(this).data('price');
                $(this).text(formatPrice(price));
            });
            
            $('.subtotal-value, .total-value').each(function() {
                var total = $(this).data('total');
                var formattedTotal = formatPrice(total);
                if ($(this).hasClass('total-value')) {
                    $(this).html('<strong>' + formattedTotal + ' VND</strong>');
                } else {
                    $(this).text(formattedTotal + ' VND');
                }
            });
            
            // Add animation to cart items
            $('.cart-item').each(function(index) {
                $(this).delay(index * 100).fadeIn(500);
            });
            
            // Add loading state to buttons
            $('form').on('submit', function() {
                var button = $(this).find('button[type="submit"]');
                var originalText = button.html();
                button.prop('disabled', true).html('<i class="fa fa-spinner fa-spin"></i> Processing...');
                
                // Re-enable button after 3 seconds in case of error
                setTimeout(function() {
                    button.prop('disabled', false).html(originalText);
                }, 3000);
            });
            
            // Auto-hide success/error messages
            setTimeout(function() {
                $('.alert').fadeOut();
            }, 5000);
        });
    </script>
</body>
</html>