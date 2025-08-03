<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="models.UserDTO, models.AdminDTO, models.GoogleAccount" %>

<!doctype html>
<html class="no-js" lang="zxx">

    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Forgot Password</title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- <link rel="manifest" href="site.webmanifest"> -->
        <link rel="shortcut icon" type="image/x-icon" href="img/favicon.png">
        <!-- Place favicon.ico in the root directory -->

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

        <link rel="stylesheet" href="css/owl.carousel.min.css">
        <link rel="stylesheet" href="css/page-transitions.css">
        <script src="js/jquery.min.js"></script>
        <script src="js/owl.carousel.min.js"></script>
        <script src="js/effects.js"></script>
        <script src="js/page-transitions.js"></script>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }
            body {
                background: linear-gradient(135deg, #e6f0fa 0%, #b3c6e2 100%);
                font-family: 'Arial', sans-serif;
                min-height: 100vh;
                display: flex;
                flex-direction: column;
                justify-content: flex-start;
                align-items: center;
            }
            .wrapper {
                width: 100%;
                min-height: 100vh;
                background: url('path/to/your-background-image.jpg') no-repeat center center fixed;
                background-size: cover;
                display: flex;
                flex-direction: column;
            }
            .nav {
                background: #2c3e50;
                padding: 15px 30px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                width: 100%;
                color: #fff;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
            }
            .nav-logo p {
                font-size: 1.5rem;
                font-weight: bold;
                margin: 0;
            }
            .nav-menu ul {
                list-style: none;
                display: flex;
                margin: 0;
                padding: 0;
            }
            .nav-menu ul li {
                margin: 0 20px;
            }
            .nav-menu ul li a {
                color: #fff;
                text-decoration: none;
                font-size: 1rem;
                transition: color 0.3s ease;
            }
            .nav-menu ul li a:hover {
                color: #3498db;
            }
            .nav-button .btn {
                background: #3498db;
                color: #fff;
                border: none;
                padding: 8px 20px;
                border-radius: 5px;
                cursor: pointer;
                font-size: 1rem;
                margin-left: 10px;
                transition: background 0.3s ease;
            }
            .nav-button .btn:hover {
                background: #2980b9;
            }
            .form-box {
                flex: 1;
                display: flex;
                justify-content: center;
                align-items: center;
                padding: 20px;
            }
            .form-container {
                background: #fff;
                padding: 40px;
                border-radius: 10px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
                width: 100%;
                max-width: 500px;
                text-align: center;
            }
            .form-container header {
                font-size: 2.5rem;
                font-weight: 600;
                color: #2c3e50;
                margin-bottom: 30px;
            }
            .input-box {
                position: relative;
                margin: 20px 0;
            }
            .input-field {
                width: 100%;
                padding: 15px 40px 15px 15px;
                border: 1px solid #ddd;
                border-radius: 5px;
                font-size: 1.1rem;
                transition: border-color 0.3s ease, box-shadow 0.3s ease;
            }
            .input-field:focus {
                border-color: #3498db;
                outline: none;
                box-shadow: 0 0 8px rgba(52, 152, 219, 0.2);
            }
            .input-box i {
                position: absolute;
                right: 15px;
                top: 50%;
                transform: translateY(-50%);
                color: #777;
                font-size: 1.3rem;
            }
            .submit {
                width: 100%;
                padding: 15px;
                background: #3498db;
                color: #fff;
                border: none;
                border-radius: 5px;
                font-size: 1.1rem;
                font-weight: 500;
                cursor: pointer;
                transition: background 0.3s ease, transform 0.1s ease;
            }
            .submit:hover {
                background: #2980b9;
                transform: scale(1.02);
            }
            .submit:active {
                transform: scale(0.98);
            }
            .error, .success {
                margin-top: 20px;
                padding: 12px;
                border-radius: 5px;
                font-size: 1rem;
                text-align: center;
            }
            .error {
                background: #f8d7da;
                color: #721c24;
            }
            .success {
                background: #d4edda;
                color: #155724;
            }
            @media (max-width: 600px) {
                .nav {
                    flex-direction: column;
                    align-items: flex-start;
                    padding: 15px;
                }
                .nav-menu ul {
                    flex-direction: column;
                    margin-top: 10px;
                }
                .nav-menu ul li {
                    margin: 10px 0;
                }
                .nav-button {
                    margin-top: 10px;
                }
                .form-container {
                    padding: 20px;
                }
                .form-container header {
                    font-size: 2rem;
                }
                .input-field, .submit {
                    font-size: 1rem;
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
        <div class="bradcam_area breadcam_bg">
            <h3>Forgot Password</h3>
        </div>
        <!-- bradcam_area_end -->

        <!-- about_area_start -->
        <div class="wrapper">
            <div class="form-box">
                <div class="form-container">
                    <header>Quên Mật Khẩu</header>
                    <form action="${pageContext.request.contextPath}/ForgotPasswordServlet" method="post" onsubmit="return validateForgotPasswordForm()">
                        <div class="input-box">
                            <input type="email" class="input-field" name="email" placeholder="Nhập email của bạn" value="${email}" required>
                            <i class="fas fa-envelope"></i>
                        </div>
                        <div class="input-box">
                            <input type="submit" class="submit" value="Xác Minh">
                        </div>
                        <c:if test="${not empty error}">
                            <div class="error">${error}</div>
                        </c:if>
                        <c:if test="${not empty success}">
                            <div class="success">${success}</div>
                        </c:if>
                    </form>
                </div>
            </div>
        </div>

        <!-- footer -->
        <footer class="footer" >
            <div class="footer_top">
                <div class="container">
                    <div class="row">
                        <div class="col-xl-3 col-md-6 col-lg-3">
                            <div class="footer_widget">
                                <h3 class="footer_title">
                                    address
                                </h3>
                                <p class="footer_text" >  Khu công nghệ cao <br>
                                    Hòa Lạc, Hà Nội</p>
                                <a href="#" class="line-button">Get Direction</a>
                            </div>
                        </div>
                        <div class="col-xl-3 col-md-6 col-lg-3">
                            <div class="footer_widget">
                                <h3 class="footer_title">
                                    Reservation
                                </h3>
                                <p class="footer_text" >+10 367 267 2678 <br>
                                    thanhnnhe186491@fpt.edu.vn</p>
                            </div>
                        </div>
                        <div class="col-xl-2 col-md-6 col-lg-2">
                            <div class="footer_widget">
                                <h3 class="footer_title">
                                    Navigation
                                </h3>
                                <ul>
                                    <li><a href="./home">Home</a></li>
                                    <li><a href="./court">Courts</a></li>
                                    <li><a href="./about.jsp">About</a></li>
                                    <li><a href="./blog.jsp">News</a></li>
                                </ul>
                            </div>
                        </div>
                        <div class="col-xl-4 col-md-6 col-lg-4">
                            <div class="footer_widget">
                                <h3 class="footer_title">
                                    Newsletter
                                </h3>
                                <form action="#" class="newsletter_form">
                                    <input type="text" placeholder="Enter your mail">
                                    <button type="submit" >Sign Up</button>
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
                                <!-- Link back to Colorlib can't be removed. Template is licensed under CC BY 3.0. -->
                                Copyright &copy;<script>document.write(new Date().getFullYear());</script> All rights reserved
                                <!-- Link back to Colorlib can't be removed. Template is licensed under CC BY 3.0. -->
                            </p>
                        </div>
                        <div class="col-xl-4 col-md-5 col-lg-3">
                            <div class="socail_links">
                                <ul>
                                    <li>
                                        <a href="#">
                                            <i class="fa fa-facebook-square"></i>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="#">
                                            <i class="fa fa-twitter"></i>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="#">
                                            <i class="fa fa-instagram"></i>
                                        </a>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </footer>
        <!-- footer_end -->

        <!-- form itself end-->
        <form id="test-form" class="white-popup-block mfp-hide">
            <div class="popup_box ">
                <div class="popup_inner">
                    <h3>Check Availability</h3>
                    <form action="#">
                        <div class="row">
                            <div class="col-xl-6">
                                <input id="datepicker" placeholder="Check in date">
                            </div>
                            <div class="col-xl-6">
                                <input id="datepicker2" placeholder="Check out date">
                            </div>
                            <div class="col-xl-6">
                                <select class="form-select wide" id="default-select" class="">
                                    <option data-display="Adult">1</option>
                                    <option value="1">2</option>
                                    <option value="2">3</option>
                                    <option value="3">4</option>
                                </select>
                            </div>
                            <div class="col-xl-6">
                                <select class="form-select wide" id="default-select" class="">
                                    <option data-display="Children">1</option>
                                    <option value="1">2</option>
                                    <option value="2">3</option>
                                    <option value="3">4</option>
                                </select>
                            </div>
                            <div class="col-xl-12">
                                <select class="form-select wide" id="default-select" class="">
                                    <option data-display="Court type">Court type</option>
                                    <option value="1">Laxaries Courts</option>
                                    <option value="2">Deluxe Court</option>
                                    <option value="3">Signature Court</option>
                                    <option value="4">Couple Court</option>
                                </select>
                            </div>
                            <div class="col-xl-12">
                                <button type="submit" class="boxed-btn3">Check Availability</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </form>
        <!-- form itself end -->


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

        <!--contact js-->
        <script src="js/contact.js"></script>
        <script src="js/jquery.ajaxchimp.min.js"></script>
        <script src="js/jquery.form.js"></script>
        <script src="js/jquery.validate.min.js"></script>
        <script src="js/mail-script.js"></script>

        <script src="js/main.js"></script>
        <script>
            // Function to remove whitespace from input
            function removeWhitespace(input) {
                input.value = input.value.replace(/\s/g, '');
            }

            // Function to validate form before submission
            function validateForgotPasswordForm() {
                const email = document.querySelector('input[name="email"]');
                
                // Check for whitespace in the middle of the input
                if (email.value.includes(' ')) {
                    alert("Email không được chứa khoảng trắng!");
                    email.focus();
                    return false;
                }
                
                // Remove any existing whitespace
                removeWhitespace(email);
                
                // Check if field is empty after removing whitespace
                if (!email.value.trim()) {
                    alert("Email không được để trống!");
                    email.focus();
                    return false;
                }
                
                return true;
            }

            // Add event listeners to prevent whitespace input
            document.addEventListener('DOMContentLoaded', function() {
                const email = document.querySelector('input[name="email"]');
                
                // Prevent whitespace on input with immediate feedback
                email.addEventListener('input', function() {
                    if (this.value.includes(' ')) {
                        alert("Email không được chứa khoảng trắng!");
                        this.value = this.value.replace(/\s/g, '');
                    }
                });
                
                // Prevent paste with whitespace
                email.addEventListener('paste', function(e) {
                    setTimeout(() => {
                        if (this.value.includes(' ')) {
                            alert("Email không được chứa khoảng trắng!");
                            this.value = this.value.replace(/\s/g, '');
                        }
                    }, 0);
                });
                
                // Prevent space key from being typed
                email.addEventListener('keydown', function(e) {
                    if (e.key === ' ') {
                        e.preventDefault();
                        alert("Email không được chứa khoảng trắng!");
                    }
                });
            });

            $('#datepicker').datepicker({
                iconsLibrary: 'fontawesome',
                icons: {
                    rightIcon: '<span class="fa fa-caret-down"></span>'
                }
            });
            $('#datepicker2').datepicker({
                iconsLibrary: 'fontawesome',
                icons: {
                    rightIcon: '<span class="fa fa-caret-down"></span>'
                }

            });
        </script>


    </body>

</html>
