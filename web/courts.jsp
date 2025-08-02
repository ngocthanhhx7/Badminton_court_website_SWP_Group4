<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="models.UserDTO, models.AdminDTO, models.GoogleAccount" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!doctype html>
<html class="no-js" lang="zxx">

    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>BadmintonHub</title>
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
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
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
        <script src="js/page-transitions.js"></script>
    </head>

    <body>
        <!--[if lte IE 9]>
                <p class="browserupgrade">You are using an <strong>outdated</strong> browser. Please <a href="https://browsehappy.com/">upgrade your browser</a> to improve your experience and security.</p>
            <![endif]-->

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
        
        <jsp:include page="chat-gemini.jsp" />

        <!-- header-end -->

        <!-- bradcam_area_start -->
        <div class="bradcam_area breadcam_bg_1">
            <h3>Laxaries Courts</h3>
        </div>
        <!-- bradcam_area_end -->

        <!-- List court -->
        <section class="court-section px-4 py-12 bg-gray-100">
            <div class="container mx-auto">

                <!-- Form tìm kiếm -->
                <form method="get" action="./court" class="mb-10 max-w-4xl mx-auto flex flex-wrap gap-2 md:gap-4 items-center justify-center">
                    <!-- Ô tìm kiếm -->
                    <input 
                        type="text" 
                        name="search" 
                        value="${param.search}" 
                        placeholder="Tìm kiếm sân cầu lông..."
                        class="w-full md:w-1/3 px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-secondary text-gray-700"
                        value="${search != null ? search : ''}"
                        />

                    <!-- Lọc trạng thái -->
                    <select name="status"
                            class="w-full md:w-1/5 px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-secondary text-gray-700">
                        <option value="">Tất cả trạng thái</option>
                        <option value="Available" ${param.status == 'Available' ? 'selected' : ''}>Available</option>
                        <option value="Unavailable" ${param.status == 'Unavailable' ? 'selected' : ''}>Unavailable</option>
                    </select>

                    <!-- Lọc loại sân -->
                    <select name="courtType"
                            class="w-full md:w-1/5 px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-secondary text-gray-700">
                        <option value="">Tất cả loại sân</option>
                        <option value="Single" ${param.courtType == 'Single' ? 'selected' : ''}>Single</option>
                        <option value="Double" ${param.courtType == 'Double' ? 'selected' : ''}>Double</option>
                        <option value="VIP" ${param.courtType == 'VIP' ? 'selected' : ''}>VIP</option>
                    </select>

                    <!-- Nút tìm -->
                    <button type="submit"
                            class="w-full md:w-auto px-6 py-2 bg-secondary text-white font-semibold rounded-lg hover:bg-red-600 transition duration-300">
                        Tìm
                    </button>
                </form>


                <!-- Thông báo -->
                <c:if test="${message != null}">
                    <p class="text-center text-secondary font-medium text-lg mb-6">${message}</p>
                </c:if>

                <!-- Danh sách sân -->
                <c:if test="${courts != null}">
                    <div class="flex flex-wrap justify-center gap-6">
                        <c:forEach items="${courts}" var="court">
                            <div class="court-card w-full max-w-[400px] bg-white rounded-2xl shadow-md hover:shadow-xl transform transition duration-300 hover:-translate-y-1">
                                <img src="${court.courtImage}" alt="Sân cầu lông ${court.courtName}"
                                     class="w-full h-[300px] object-cover rounded-t-2xl">
                                <div class="p-4">
                                    <h3 class="text-lg font-bold text-gray-800 mb-2 truncate">${court.courtName}</h3>
                                    <p class="text-gray-600 text-sm mb-2 line-clamp-2">${court.description}</p>
                                    <p class="text-sm text-gray-500">Loại sân: <span class="font-medium text-gray-700">${court.courtType}</span></p>
                                    <p class="text-sm text-gray-500 mb-4">
                                        Trạng thái:
                                        <span class="font-semibold ${court.status == 'Available' ? 'text-green-600' : 'text-red-500'}">${court.status}</span>
                                    </p>
                                    <form method="get" action="./court-detail" class="text-right">
                                        <input type="hidden" name="courtId" value="${court.courtId}">
                                        <button type="submit"
                                                class="px-4 py-2 bg-secondary text-white rounded-md hover:bg-red-600 transition duration-300 text-sm">
                                            Xem chi tiết
                                        </button>
                                    </form>
                                </div>
                            </div>

                        </c:forEach>

                    </div>
                </c:if>

                <!-- Phân trang -->
                <c:if test="${totalPages > 1}">
                    <div class="flex justify-center mt-8 space-x-2">
                        <!-- Nút lùi lại -->
                        <c:if test="${currentPage > 1}">
                            <a href="court?page=${currentPage - 1}&search=${param.search}&status=${param.status}&courtType=${param.courtType}"
                               class="px-4 py-2 bg-gray-200 text-gray-700 rounded hover:bg-gray-300 transition duration-200">
                                &laquo; 🏍️
                            </a>
                        </c:if>

                        <!-- Hiển thị số trang -->
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <a href="court?page=${i}&search=${param.search}&status=${param.status}&courtType=${param.courtType}"
                               class="px-4 py-2 rounded ${i == currentPage ? 'bg-secondary text-white' : 'bg-gray-100 text-gray-700 hover:bg-gray-300'} transition duration-200">
                                ${i}
                            </a>
                        </c:forEach>

                        <!-- Nút tiến -->
                        <c:if test="${currentPage < totalPages}">
                            <a href="court?page=${currentPage + 1}&search=${param.search}&status=${param.status}&courtType=${param.courtType}"
                               class="px-4 py-2 bg-gray-200 text-gray-700 rounded hover:bg-gray-300 transition duration-200">
                                🛬 &raquo;
                            </a>
                        </c:if>
                    </div>
                </c:if>


            </div>
        </section>
        <!-- List court end -->

        <!-- offers_area_start -->
        <c:if test="${not empty offers}">
            <div class="offers_area">
                <div class="container">
                    <div class="row">
                        <div class="col-xl-12">
                            <div class="section_title text-center mb-100">
                                <span>Our Offers</span>
                                <h3>Ongoing Offers</h3>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <c:forEach var="offer" items="${offers}">
                            <div class="col-xl-4 col-md-4">
                                <div class="single_offers">
                                    <div class="about_thumb">
                                        <img src="${offer.imageUrl}" alt="">
                                    </div>
                                    <h3>${offer.title} <br>${offer.subtitle}</h3>
                                    <ul>
                                        <li>${offer.description}</li>
                                        <li>${offer.capacity} người</li>
                                        <li>${offer.isVIP ? "VIP Service" : "Standard Service"}</li>
                                    </ul>
                                    <a href="bookCourt?offerID=${offer.offerID}" class="book_now">book now</a>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- offers_area_end -->

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

        <!-- instragram_area_start -->
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
        <!-- instragram_area_end -->

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
                                    <li><a href="about.jsp">About</a></li>
                                    <li><a href="blog.jsp">News</a></li>
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
