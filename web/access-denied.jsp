<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>Access Denied - BadmintonHub</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon" href="img/favicon.png">

    <!-- CSS here -->
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="css/owl.carousel.min.css">
    <link rel="stylesheet" href="css/magnific-popup.css">
    <link rel="stylesheet" href="css/font-awesome.min.css">
    <link rel="stylesheet" href="css/themify-icons.css">
    <link rel="stylesheet" href="css/nice-select.css">
    <link rel="stylesheet" href="css/flaticon.css">
    <link rel="stylesheet" href="css/animate.css">
    <link rel="stylesheet" href="css/slicknav.css">
    <link rel="stylesheet" href="css/style.css">
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
        <h3>Access Denied</h3>
    </div>
    <!-- bradcam_area_end -->

    <!-- Start Sample Area -->
    <section class="sample-text-area">
        <div class="container box_1170">
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="text-center">
                        <div class="mb-4">
                            <i class="fa fa-exclamation-triangle" style="font-size: 80px; color: #ff6b6b;"></i>
                        </div>
                        <h2 class="mb-4">Access Denied</h2>
                        <p class="mb-4" style="font-size: 18px; color: #666;">
                            Sorry, you don't have permission to access this page. 
                            Only Administrators and Staff members can access management pages.
                        </p>
                        <div class="mt-4">
                            <a href="./home" class="btn btn-primary mr-3">Go to Homepage</a>
                            <a href="./Login" class="btn btn-outline-primary">Login with Different Account</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <!-- End Sample Area -->

    <!-- footer_start -->
    <jsp:include page="footer.jsp" />
    <!-- footer_end -->

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
    <script src="js/contact.js"></script>
    <script src="js/jquery.ajaxchimp.min.js"></script>
    <script src="js/jquery.form.js"></script>
    <script src="js/jquery.validate.min.js"></script>
    <script src="js/mail-script.js"></script>
    <script src="js/main.js"></script>
</body>
</html> 