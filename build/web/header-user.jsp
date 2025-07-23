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
                                    <li><a href="./home">home</a></li>
                                    <li><a href="./court">Courts</a></li>
                                    <li><a href="./about">About</a></li>
                                    <li><a href="./blog">blog <i class="ti-angle-down"></i></a>
                                    </li>
                                    <li><a href="">pages <i class="ti-angle-down"></i></a>
                                        <ul class="submenu">
                                            <li><a href="booking?action=my-bookings">Booking History</a></li>
                                            <li><a href="./contact">Contact</a></li>
                                            <li><a href="booking?action=schedule">View Schedule</a></li>
                                            <li><a href="partner-search">Find Partner</a></li>
                                            
                                            
                                        </ul>
                                    </li>

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
                            <div class="d-flex align-items-center gap-3 mb-2">
                                <c:choose>
                                    <c:when test="${sessionScope.accType == 'google'}">
                                        <div class="dropdown">
                                            <img src="${sessionScope.acc.picture}" alt="Avatar" class="rounded-circle dropdown-toggle" width="40" height="40" style="cursor:pointer;" id="avatarDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                            <span class="ms-2" style="color: #fff;">Welcome, <a href="view-profile.jsp" class="text-primary fw-bold">${sessionScope.acc.name}</a></span>
                                            <ul class="dropdown-menu dropdown-menu-end mt-2" aria-labelledby="avatarDropdown">
                                                <li>
                                                    <div class="dropdown-header text-center fw-bold">
                                                        ${sessionScope.acc.name}
                                                    </div>
                                                </li>
                                                <li><hr class="dropdown-divider"></li>
                                                <li><a class="dropdown-item" href="view-profile.jsp"><i class="fa fa-user me-2"></i>View Profile</a></li>
                                                <li><a class="dropdown-item" href="booking?action=my-bookings"><i class="fa fa-history me-2"></i>Booking History</a></li>
                                                <li><a class="dropdown-item" href="partner-search?action=my-posts"><i class="fa fa-users me-2"></i>My Partner Posts</a></li>
                                                <li><a class="dropdown-item" href="change-password.jsp"><i class="fa fa-key me-2"></i>Change Password</a></li>
                                                <li><hr class="dropdown-divider"></li>
                                                <li><a class="dropdown-item text-danger" href="./logout"><i class="fa fa-sign-out me-2"></i>Logout</a></li>
                                            </ul>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="dropdown d-flex align-items-center">
                                            <span class="me-2" style="color: #fff;">Welcome, <a href="view-profile.jsp" class="text-primary fw-bold">${sessionScope.acc.username}</a></span>
                                            <% 
                                                Object accObj = session.getAttribute("acc");
                                                String avatarUrl = "https://cdn-icons-png.flaticon.com/512/149/149071.png";
                                                if (accObj != null && accObj instanceof models.UserDTO) {
                                                    models.UserDTO user = (models.UserDTO) accObj;
                                                    String gender = user.getGender();
                                                    if ("Male".equalsIgnoreCase(gender)) {
                                                        avatarUrl = "https://symbols.vn/wp-content/uploads/2021/11/Anh-avatar-de-thuong-cho-nam.jpg";
                                                    } else if ("Female".equalsIgnoreCase(gender)) {
                                                        avatarUrl = "https://img6.thuthuatphanmem.vn/uploads/2022/10/23/hinh-avatar-chibi-cute_031501070.jpg";
                                                    }
                                                }
                                            %>
                                            <img src="<%= avatarUrl %>" alt="Avatar" class="rounded-circle dropdown-toggle" width="40" height="40" style="cursor:pointer;" id="avatarDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                            <ul class="dropdown-menu dropdown-menu-end mt-2" aria-labelledby="avatarDropdown">
                                                <li>
                                                    <div class="dropdown-header text-center fw-bold">
                                                        ${sessionScope.acc.username}
                                                    </div>
                                                </li>
                                                <li><hr class="dropdown-divider"></li>
                                                <li><a class="dropdown-item" href="view-profile.jsp"><i class="fa fa-user me-2"></i>View Profile</a></li>
                                                <li><a class="dropdown-item" href="booking?action=my-bookings"><i class="fa fa-history me-2"></i>Booking History</a></li>
                                                <li><a class="dropdown-item" href="partner-search?action=my-posts"><i class="fa fa-users me-2"></i>My Partner Posts</a></li>
                                                <li><a class="dropdown-item" href="change-password.jsp"><i class="fa fa-key me-2"></i>Change Password</a></li>
                                                <li><hr class="dropdown-divider"></li>
                                                <li><a class="dropdown-item text-danger" href="./logout"><i class="fa fa-sign-out me-2"></i>Logout</a></li>
                                            </ul>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
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
