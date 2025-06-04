<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="models.UserDTO, models.AdminDTO, models.GoogleAccount" %>

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
    <!-- <link rel="stylesheet" href="css/responsive.css"> -->
</head>
<header>
    <div class="header-area">
        <div id="sticky-header" class="main-header-area">
            <div class="container-fluid p-0">
                <div class="row align-items-center no-gutters">
                    <div class="col-xl-5 col-lg-6">
                        <div class="main-menu d-none d-lg-block">
                            <nav>
                                <ul id="navigation">
                                    <li><a class="active" href="./homepage.jsp">home</a></li>
                                    <li><a href="./courts.jsp">Courts</a></li>
                                    <li><a href="./about.jsp">About</a></li>
                                    <li><a href="#">blog <i class="ti-angle-down"></i></a>
                                        <ul class="submenu">
                                            <li><a href="blog.jsp">blog</a></li>
                                            <li><a href="single-blog.jsp">single-blog</a></li>
                                        </ul>
                                    </li>
                                    <li><a href="#">pages <i class="ti-angle-down"></i></a>
                                        <ul class="submenu">
                                            <li><a href="my-bookings.jsp?accountId=${sessionScope.account.id}">My Bookings</a></li>
                                        </ul>
                                    </li>
                                    <li><a href="contact.jsp">Contact</a></li>
                                </ul>
                            </nav>
                        </div>
                    </div>
                    <div class="col-xl-2 col-lg-2">
                        <div class="logo-img">
                            <a href="./home">
                                <img src="img/logo.png" alt="Logo" width="200" height="92">
                            </a>
                        </div>
                    </div>
                    <div class="col-xl-5 col-lg-4 d-none d-lg-block">
                        <div class="book_court d-flex align-items-center justify-content-end">

                            <!-- Social links -->
                            <div class="socail_links mb-3">
                                <ul class="list-inline mb-0 d-flex gap-3 justify-content-end">
                                    <li class="list-inline-item">
                                        <a href="https://www.facebook.com/ngocthanh552004/" class="text-primary fs-4"><i class="fa fa-facebook-square"></i></a>
                                    </li>
                                    <li class="list-inline-item">
                                        <a href="https://www.facebook.com/ngocthanh552004/" class="text-info fs-4"><i class="fa fa-twitter"></i></a>
                                    </li>
                                    <li class="list-inline-item">
                                        <a href="https://www.facebook.com/ngocthanh552004/" class="text-danger fs-4"><i class="fa fa-instagram"></i></a>
                                    </li>
                                </ul>
                            </div>

                            <!-- Welcome and Account -->
                            <!-- Welcome + Avatar + Username -->
                            <div class="d-flex align-items-center gap-3 mb-2">
                                <c:choose>
                                    <c:when test="${sessionScope.accType == 'google'}">
                                        <img src="${sessionScope.acc.picture}" alt="Avatar" class="rounded-circle" width="40" height="40">
                                        <div>
                                            <span class="text-dark">Welcome,</span>
                                            <a href="view-profile.jsp" class="text-primary fw-bold">${sessionScope.acc.name}</a>
                                            <div class="text-muted small">${sessionScope.acc.email}</div>
                                        </div>
                                    </c:when>

                                    <c:otherwise>
                                        <div>
                                            <span class="text-dark">Welcome,</span>
                                            <a href="view-profile.jsp" class="text-primary fw-bold">${sessionScope.acc.username}</a>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- Logout Button -->
                            <div class="text-end">
                                <a href="./logout" class="btn btn-danger px-4">Logout</a>
                            </div>

                        </div>
                    </div>

                </div>
                <div class="col-12">
                    <div class="mobile_menu d-block d-lg-none"></div>
                </div>
            </div>
        </div>
    </div>
</div>
</header>
