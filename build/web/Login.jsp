<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="models.AdminDTO, models.UserDTO, models.GoogleAccount" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html class="no-js" lang="zxx">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Đăng nhập</title>
        <link rel="stylesheet" href="https://unpkg.com/bootstrap@5.3.2/dist/css/bootstrap.min.css">
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
        <script>
            function togglePassword() {
                const passField = document.getElementById("password");
                if (passField.type === "password") {
                    passField.type = "text";
                } else {
                    passField.type = "password";
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

        <jsp:include page="header.jsp" />


        <div class="bradcam_area breadcam_bg">
            <h3>Đăng nhập</h3>
            <p class="text-center m-0">Bạn không có tài khoản ? <a href="./register">Đăng ký</a></p>
        </div>

        <section class="py-3 py-md-5 py-xl-8" style="margin-top: 0px;">

            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-12 col-lg-10 col-xl-8">
                        <div class="row gy-5 justify-content-center">
                            <div class="col-12 col-lg-5">

                                <form action="Login" method="post">
                                    <div class="row gy-3 overflow-hidden">
                                        <div class="col-12">

                                            <c:if test="${not empty mess || not empty error}">
                                                <div class="alert alert-danger">
                                                    ${mess}${error}
                                                </div>
                                            </c:if>

                                            <div class="form-floating mb-3">
                                                <input type="text" class="form-control border-0 border-bottom rounded-0"
                                                       name="emailOrUsername" id="emailOrUsername"
                                                       value="${savedIdentifier}" placeholder="Nhập tên đăng nhập hoặc email" required>
                                                <label for="emailOrUsername" class="form-label">Tên đăng nhập hoặc email</label>
                                            </div>
                                        </div>

                                        <div class="col-12">
                                            <div class="form-floating mb-3 position-relative">
                                                <input type="password" class="form-control border-0 border-bottom rounded-0 pe-5"
                                                       name="password" id="password"
                                                       value="${savedPassword}" placeholder="Password" required>
                                                <label for="password" class="form-label">Mật khẩu</label>

                                                <button type="button"
                                                        onclick="togglePassword()"
                                                        class="position-absolute top-50 end-0 translate-middle-y"
                                                        style="border: none; background: transparent; padding: 0 10px; font-size: 18px; line-height: 1;">
                                                    👁️
                                                </button>
                                            </div>
                                        </div>


                                        <div class="col-12">
                                            <div class="row justify-content-between">
                                                <div class="col-6">
                                                    <div class="form-check">
                                                        <input class="form-check-input" type="checkbox" name="remember_me" id="remember_me"
                                                               ${rememberChecked ? "checked" : ""}>

                                                        <label class="form-check-label text-secondary" for="remember_me">
                                                            Ghi nhớ
                                                        </label>
                                                    </div>
                                                </div>
                                                <div class="col-6 text-end">
                                                    <a href="./forgotPassword.jsp" class="link-secondary text-decoration-none">Quên mật khẩu</a>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="col-12">
                                            <div class="d-grid">
                                                <button class="btn btn-primary btn-lg" type="submit">Đăng Nhập</button>
                                            </div>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Bootstrap Icons (if not already loaded) -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

    </body>
</html>
