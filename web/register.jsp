<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Đăng ký</title>
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
        <link rel="stylesheet" href="css/register.css">
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
        <script src="js/jquery.min.js"></script>
        <script src="js/owl.carousel.min.js"></script>
        <script src="js/effects.js"></script>
        <script src="js/page-transitions.js"></script>

        <script>
            $(document).ready(function () {
                $('.about_active').owlCarousel({
                    items: 1,
                    loop: true,
                    autoplay: true,
                    autoplayTimeout: 6000,
                    nav: false,
                    dots: true
                }
                );
            }
            );
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
            <h3>Đăng ký</h3>
        </div>
        <!-- bradcam_area_end -->

        <div class="container">
            <h2>Đăng ký tài khoản</h2>
            <c:if test="${not empty message}">
                <div class="message">${message}</div>
            </c:if>
            <form action="register" method="post">
                <div class="form-group">
                    <label for="username">Username <span style="color:red">*</span></label>
                    <input type="text" id="username" name="username" value="${param.username}" required />
                </div>
                <div class="form-group">
                    <label for="email">Email <span style="color:red">*</span></label>
                    <input type="email" id="email" name="email" value="${param.email}" required />
                </div>
                <div class="form-group">
                    <label for="password">Mật khẩu <span style="color:red">*</span></label>
                    <input type="password" id="password" name="password" required />
                </div>
                <button class="genric-btn success" type="submit">Đăng ký</button>
            </form>
            <div class="genric-btn success-border circle">
                <p>Đã có tài khoản? <a href="Login.jsp">Đăng nhập</a></p>
            </div>
        </div>

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