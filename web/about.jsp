<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="models.UserDTO, models.AdminDTO, models.GoogleAccount" %>

<!doctype html>
<html class="no-js" lang="zxx">

    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>About</title>
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
        <!-- <link rel="stylesheet" href="css/responsive.css"> -->
        <script src="https://cdn.tailwindcss.com"></script>
        <script>
            tailwind.config = {
                theme: {
                    extend: {
                        colors: {
                            primary: '#78350f', // Green
                            secondary: '#78350f', // Red
                        }
                    }
                }
            }
        </script>

        <link rel="stylesheet" href="css/owl.carousel.min.css">
        <link rel="stylesheet" href="css/page-transitions.css">
        <script src="js/jquery.min.js"></script>
        <script src="js/owl.carousel.min.js"></script>
        <script src="js/effects.js"></script>
        <script src="js/page-transitions.js"></script>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            $(document).ready(function () {
                $('.about_active').owlCarousel({
                    items: 1,
                    loop: true,
                    autoplay: true,
                    autoplayTimeout: 6000,
                    nav: false,
                    dots: true
                });
            });
        </script>
        <script src="js/chat.js"></script>
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
            <h3>About BadmintonHub</h3>
        </div>
        <!-- bradcam_area_end -->

        <!-- about_area_start -->
        <div class="about_area">
            <div class="container">
                <div class="about_active owl-carousel">
                    <c:forEach var="about" items="${aboutSections}">
                        <div class="row">
                            <div class="col-xl-5 col-lg-5">
                                <div class="about_info">
                                    <div class="section_title mb-20px">
                                        <span>About Us</span>
                                        <h3>${about.title}<br>${about.subtitle}</h3>
                                    </div>
                                    <p>${about.content}</p>
                                    <a href="#" class="line-button">Learn More</a>
                                </div>
                            </div>
                            <div class="col-xl-7 col-lg-7">
                                <div class="about_thumb d-flex">
                                    <div class="img_1">
                                        <img src="${about.image1}" alt="">
                                    </div>
                                    <div class="img_2">
                                        <img src="${about.image2}" alt="">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
        <!-- about_area_end -->

        <!-- video_area_start -->
        <c:if test="${not empty video}">
            <div class="video_area video_bg overlay" style="background-image: url('${video.thumbnailUrl}');">
                <div class="video_area_inner text-center">
                    <span>${video.title}</span>
                    <h3>${video.subtitle}</h3>
                    <a href="${video.videoUrl}" class="video_btn popup-video">
                        <i class="fa fa-play"></i>
                    </a>
                </div>
            </div>
        </c:if>
        <!-- video_area_end -->

        <!-- about_area_start -->
        <c:if test="${empty param.search}">
            <div class="about_area">
                <div class="container">
                    <div class="about_active owl-carousel">
                        <c:forEach var="about" items="${aboutSections}">
                            <div class="row">
                                <div class="col-xl-7 col-lg-7">
                                    <div class="about_thumb2 d-flex">
                                        <div class="img_1">
                                            <img src="${about.image1}" alt="">
                                        </div>
                                        <div class="img_2">
                                            <img src="${about.image2}" alt="">
                                        </div>
                                    </div>
                                </div>
                                <div class="col-xl-5 col-lg-5">
                                    <div class="about_info">
                                        <div class="section_title mb-20px">
                                            <span>${about.sectionType}</span>
                                            <h3>${about.title} <br> ${about.subtitle}</h3>
                                        </div>
                                        <p>${about.content}</p>
                                        <a href="about.jsp" class="line-button">Learn More</a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </c:if>
        <!-- about_area_end -->



        <!-- forQuery_start -->
        <c:forEach var="contact" items="${contactInfos}">
            <div class="forQuery">
                <div class="container">
                    <div class="row">
                        <div class="col-xl-10 offset-xl-1 col-md-12">
                            <div class="Query_border">
                                <div class="row align-items-center justify-content-center">
                                    <div class="col-xl-6 col-md-6">
                                        <div class="Query_text">
                                            <p>${contact.message}</p>
                                        </div>
                                    </div>
                                    <div class="col-xl-6 col-md-6">
                                        <div class="phone_num">
                                            <a href="tel:${contact.phoneNumber}" class="mobile_no">${contact.phoneNumber}</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
        <!-- forQuery_end-->

        <!--                 instragram_area_start -->
        <div class="instragram_area">
            <c:forEach var="feed" items="${instagramFeeds}">
                <div class="single_instagram">
                    <img src="${feed.imageUrl}" alt="Instagram Feed">
                    <div class="ovrelay">
                        <a href="${feed.instagramLink}" target="_blank">
                            <i class="fa fa-instagram"></i>
                        </a>
                    </div>
                </div>
            </c:forEach>
        </div>
        <!--                 instragram_area_end -->

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
