<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="models.UserDTO" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Hoàn thiện hồ sơ</title>
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
        <style>
            .form-background {
                background-color: #eaf4ff; 
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
            }
        </style>

    </head>
    <body>
        <!-- bradcam_area_start -->
        <div class="bradcam_area breadcam_bg">
            <h3>Hoàn thiện hồ sơ</h3>
        </div>
        <!-- bradcam_area_end -->

        <div class="section-top-border">
            <div class="row justify-content-center">
                <div class="col-lg-8 col-md-10 mx-auto">
                    <div class="form-background">
                        <h3 class="mb-30 text-center">Hoàn thiện thông tin cá nhân</h3>
                        <c:if test="${not empty message}">
                            <div class="alert alert-danger">${message}</div>
                        </c:if>
                        <form action="update-profile" method="post">
                            <div class="mt-10">
                                <input type="text" name="fullname" placeholder="Họ và tên"
                                       onfocus="this.placeholder = ''" onblur="this.placeholder = 'Họ và tên'" required
                                       class="single-input">
                            </div>
                            <div class="mt-10">
                                <input type="date" name="dob" placeholder="Ngày sinh"
                                       onfocus="this.placeholder = ''" onblur="this.placeholder = 'Ngày sinh'" required
                                       class="single-input">
                            </div>
                            <div class="input-group-icon mt-10">
                                <div class="icon"><i class="fa fa-venus-mars" aria-hidden="true"></i></div>
                                <div class="form-select" id="default-select">
                                    <select name="gender" required>
                                        <option value="">-- Chọn giới tính --</option>
                                        <option value="Male">Nam</option>
                                        <option value="Female">Nữ</option>
                                        <option value="Other">Khác</option>
                                    </select>
                                </div>
                            </div>
                            <div class="mt-10">
                                <input type="text" name="phone" placeholder="Số điện thoại"
                                       onfocus="this.placeholder = ''" onblur="this.placeholder = 'Số điện thoại'" required
                                       class="single-input">
                            </div>
                            <div class="input-group-icon mt-10">
                                <div class="icon"><i class="fa fa-home" aria-hidden="true"></i></div>
                                <input type="text" name="address" placeholder="Địa chỉ"
                                       onfocus="this.placeholder = ''" onblur="this.placeholder = 'Địa chỉ'" required
                                       class="single-input">
                            </div>
                            <div class="mt-10">
                                <input type="text" name="sportlevel" value="Beginner" readonly
                                       class="single-input" style="background:#e9ecef;cursor:not-allowed;">
                            </div>
                            <div class="mt-10 text-center">
                                <button type="submit" class="genric-btn primary">Lưu thông tin</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>


        <!-- JS here -->
        <script src="js/jquery-1.12.4.min.js"></script>
        <script src="js/bootstrap.min.js"></script>
        <script src="js/owl.carousel.min.js"></script>
        <script src="js/main.js"></script>
        <script>
            $(document).ready(function() {
                // code owl carousel hoặc các code khác
            });
        </script>


    </body>
</html>