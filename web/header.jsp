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
    <div class="header-area ">
        <div id="sticky-header" class="main-header-area">
            <div class="container-fluid p-0">
                <div class="row align-items-center no-gutters">
                    <div class="col-xl-5 col-lg-6">
                        <div class="main-menu  d-none d-lg-block">
                            <nav>
                                <ul id="navigation">
                                    <li><a href="./home">Trang chủ</a></li>
                                    <li><a href="./court">Danh sách sân</a></li>
                                    <li><a href="./about">Giới thiệu</a></li>
                                    <li><a href="">Khác <i class="ti-angle-down"></i></a>
                                        <ul class="submenu">
                                            <li><a href="contact.jsp">Liên hệ nhanh</a></li>
                                        </ul>
                                    </li>
                                    
                                </ul>
                            </nav>
                        </div>
                    </div>
                    <div class="col-xl-2 col-lg-2">
                        <div class="logo-img">
                            <a href="./home">
                                <img src="img/logo.png" alt="" width="200" height="92">
                            </a>
                        </div>
                    </div>
                    <div class="col-xl-5 col-lg-4 d-none d-lg-block">
                        <div class="book_room d-flex align-items-center justify-content-end">
                            <div class="book_btn d-flex gap-2">
                                <a href="./Login" class="btn btn-outline-primary">Đăng Nhập</a>
                                <a href="./register" class="btn btn-primary">Đăng ký</a>
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
