<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="models.UserDTO, models.AdminDTO, models.GoogleAccount, jakarta.servlet.http.HttpSession" %>
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
    </head>

    <link rel="stylesheet" href="css/owl.carousel.min.css">
    <link rel="stylesheet" href="css/page-transitions.css">
    <script src="js/jquery.min.js"></script>
    <script src="js/owl.carousel.min.js"></script>
    <script src="js/effects.js"></script>
    <script src="js/page-transitions.js"></script>

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

        <!-- header-end -->

        <!-- bradcam_area_start -->
        <div class="bradcam_area breadcam_bg_2">
            <h3>Get in Touch</h3>
        </div>
        <!-- bradcam_area_end -->

        <!-- ================ contact section start ================= -->
        <section class="contact-section">
            <div class="container">
                <!-- THÔNG BÁO -->
                <%
                    String status = request.getParameter("status");
                    if (status != null) {
                        if (status.equals("success")) {
                %>
                <div class="alert alert-success">
                    Gửi mail thành công!
                </div>
                <%
                        } else if (status.equals("error")) {
                %>
                <div class="alert alert-danger">
                    Gửi mail thất bại. Vui lòng thử lại.
                </div>
                <%
                        }
                    }
                %>

                <div class="row">
                    <div class="col-12">
                        <h2 class="contact-title">Gửi thư phản hồi</h2>
                    </div>
                    <div class="col-lg-8">
                        <form class="form-contact contact_form" action="contact" method="post" id="contactForm" novalidate="novalidate">
                            <div class="row">
                                <div class="col-12">
                                    <div class="form-group">
                                        <textarea class="form-control w-100" name="message" id="message" cols="30" rows="9"
                                                  onfocus="this.placeholder = ''" onblur="this.placeholder = 'Enter Message'"
                                                  placeholder="Enter Message" required></textarea>
                                    </div>
                                </div>
                                <div class="col-sm-6">
                                    <div class="form-group">
                                        <input class="form-control valid" name="name" id="name" type="text"
                                               onfocus="this.placeholder = ''" onblur="this.placeholder = 'Enter your name'"
                                               placeholder="Enter your name" required>
                                    </div>
                                </div>
                                <div class="col-sm-6">
                                    <div class="form-group">
                                        <input class="form-control valid" name="email" id="email" type="email"
                                               onfocus="this.placeholder = ''" onblur="this.placeholder = 'Enter email address'"
                                               placeholder="Email" required>
                                    </div>
                                </div>
                                <div class="col-12">
                                    <div class="form-group">
                                        <input class="form-control" name="subject" id="subject" type="text"
                                               onfocus="this.placeholder = ''" onblur="this.placeholder = 'Enter Subject'"
                                               placeholder="Enter Subject" required>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group mt-3">
                                <button type="submit" class="button button-contactForm boxed-btn">Gửi</button>
                            </div>
                        </form>
                    </div>


                </div>
            </div>
        </section>
        <div class="col-lg-3 offset-lg-1">
            <div class="media contact-info">
                <span class="contact-info__icon"><i class="ti-home"></i></span>
                <div class="media-body">
                    <h3>Hà Nội, Hòa Lạc.</h3>
                    <p>Khu công nghệ cao, Đại học FPT</p>
                </div>
            </div>
            <div class="media contact-info">
                <span class="contact-info__icon"><i class="ti-tablet"></i></span>
                <div class="media-body">
                    <h3>+84981944060</h3>
                    <p>Thứ 2 Đến Thứ 6, 6h đến 18h </p>
                </div>
            </div>
            <div class="media contact-info">
                <span class="contact-info__icon"><i class="ti-email"></i></span>
                <div class="media-body">
                    <h3>thanhnnhe186491@fpt.edu.vn</h3>
                    <p>Send us your query anytime!</p>
                </div>
            </div>
        </div>

        <!-- ================ contact section end ================= -->

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

        <script>
            $(document).ready(function () {
                $('#contactForm').on('submit', function (e) {
                    e.preventDefault();

                    // Lấy dữ liệu form
                    var formData = {
                        name: $('#name').val(),
                        email: $('#email').val(),
                        subject: $('#subject').val(),
                        message: $('#message').val()
                    };

                    // Kiểm tra dữ liệu
                    if (!formData.name || !formData.email || !formData.subject || !formData.message) {
                        alert('Vui lòng điền đầy đủ thông tin!');
                        return;
                    }

                    // Gửi form
                    $.ajax({
                        type: 'POST',
                        url: 'contact',
                        data: formData,
                        success: function (response) {
                            alert('Gửi email thành công!');
                            $('#contactForm')[0].reset();
                        },
                        error: function (xhr, status, error) {
                            alert('Có lỗi xảy ra khi gửi email. Vui lòng thử lại!');
                        }
                    });
                });
            });
        </script>

    </body>

</html>
