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

        <div class="container mt-5 mb-5">
            <div class="row justify-content-center">
                <div class="col-md-6 col-lg-5">
                    <div class="card shadow-lg border-0">
                        <div class="card-header bg-primary text-white text-center py-4">
                            <h2 class="mb-0">
                                <i class="fa fa-user-plus me-2"></i>
                                Đăng ký tài khoản
                            </h2>
                            <p class="mb-0 mt-2">Tạo tài khoản mới để trải nghiệm dịch vụ</p>
                        </div>
                        <div class="card-body p-4">
            
            <!-- Hiển thị thông báo lỗi -->
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fa fa-exclamation-triangle me-2"></i>
                    <%= request.getAttribute("error") %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>
            
            <!-- Hiển thị thông báo thành công -->
            <% if (request.getAttribute("message") != null) { %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fa fa-check-circle me-2"></i>
                    <%= request.getAttribute("message") %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>
            
            <form action="register" method="post" class="needs-validation" novalidate>
                <div class="mb-3">
                    <label for="username" class="form-label">
                        <i class="fa fa-user me-1 text-primary"></i>
                        Username <span class="text-danger">*</span>
                    </label>
                    <input type="text" 
                           class="form-control form-control-lg" 
                           id="username" 
                           name="username" 
                           value="${param.username}" 
                           placeholder="Nhập username của bạn"
                           required 
                           minlength="3"
                           maxlength="50"/>
                    <div class="invalid-feedback">
                        Username phải có ít nhất 3 ký tự.
                    </div>
                </div>

                <div class="mb-3">
                    <label for="email" class="form-label">
                        <i class="fa fa-envelope me-1 text-primary"></i>
                        Email <span class="text-danger">*</span>
                    </label>
                    <input type="email" 
                           class="form-control form-control-lg" 
                           id="email" 
                           name="email" 
                           value="${param.email}" 
                           placeholder="Nhập địa chỉ email"
                           required />
                    <div class="invalid-feedback">
                        Vui lòng nhập địa chỉ email hợp lệ.
                    </div>
                </div>

                <div class="mb-3">
                    <label for="phone" class="form-label">
                        <i class="fa fa-phone me-1 text-primary"></i>
                        Số điện thoại
                    </label>
                    <input type="tel" 
                           class="form-control form-control-lg" 
                           id="phone" 
                           name="phone" 
                           value="${param.phone}" 
                           placeholder="Ví dụ: 0912345678"
                           pattern="^[0-9+\-\s()]{10,15}$"/>
                    <div class="form-text">
                        <i class="fa fa-info-circle me-1"></i>
                        Số điện thoại sẽ giúp chúng tôi liên hệ với bạn khi cần thiết
                    </div>
                    <div class="invalid-feedback">
                        Số điện thoại phải có 10-15 chữ số.
                    </div>
                </div>

                <div class="mb-4">
                    <label for="password" class="form-label">
                        <i class="fa fa-lock me-1 text-primary"></i>
                        Mật khẩu <span class="text-danger">*</span>
                    </label>
                    <div class="input-group">
                        <input type="password" 
                               class="form-control form-control-lg" 
                               id="password" 
                               name="password" 
                               placeholder="Nhập mật khẩu"
                               required 
                               minlength="6"/>
                        <button class="btn btn-outline-secondary" type="button" id="togglePassword">
                            <i class="fa fa-eye"></i>
                        </button>
                    </div>
                    <div class="form-text">
                        <i class="fa fa-info-circle me-1"></i>
                        Mật khẩu phải có ít nhất 6 ký tự
                    </div>
                    <div class="invalid-feedback">
                        Mật khẩu phải có ít nhất 6 ký tự.
                    </div>
                </div>

                <div class="d-grid mb-3">
                    <button class="btn btn-primary btn-lg" type="submit">
                        <i class="fa fa-user-plus me-2"></i>
                        Đăng ký
                    </button>
                </div>
            </form>

            <div class="text-center">
                <p class="mb-0">
                    Đã có tài khoản? 
                    <a href="Login.jsp" class="text-primary text-decoration-none fw-bold">
                        <i class="fa fa-sign-in-alt me-1"></i>
                        Đăng nhập ngay
                    </a>
                </p>
            </div>
                        </div>
                    </div>
                </div>
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
        
        <!-- Custom JavaScript for registration form -->
        <script>
            // Form validation
            (function() {
                'use strict';
                window.addEventListener('load', function() {
                    var forms = document.getElementsByClassName('needs-validation');
                    var validation = Array.prototype.filter.call(forms, function(form) {
                        form.addEventListener('submit', function(event) {
                            if (form.checkValidity() === false) {
                                event.preventDefault();
                                event.stopPropagation();
                            }
                            form.classList.add('was-validated');
                        }, false);
                    });
                }, false);
            })();

            // Toggle password visibility
            document.getElementById('togglePassword').addEventListener('click', function() {
                const password = document.getElementById('password');
                const icon = this.querySelector('i');
                
                if (password.type === 'password') {
                    password.type = 'text';
                    icon.classList.remove('fa-eye');
                    icon.classList.add('fa-eye-slash');
                } else {
                    password.type = 'password';
                    icon.classList.remove('fa-eye-slash');
                    icon.classList.add('fa-eye');
                }
            });

            // Debug form submission
            document.querySelector('form').addEventListener('submit', function(e) {
                const formData = new FormData(this);
                console.log('Form submission debug:');
                for (let [key, value] of formData.entries()) {
                    console.log(key + ': "' + value + '"');
                }
            });

            // Real-time validation feedback
            document.getElementById('username').addEventListener('blur', function() {
                if (this.value.length < 3) {
                    this.setCustomValidity('Username phải có ít nhất 3 ký tự');
                } else {
                    this.setCustomValidity('');
                }
            });

            document.getElementById('password').addEventListener('input', function() {
                if (this.value.length < 6) {
                    this.setCustomValidity('Mật khẩu phải có ít nhất 6 ký tự');
                } else {
                    this.setCustomValidity('');
                }
            });
        </script>

        <style>
            .card {
                border-radius: 15px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            }
            
            .card-header {
                border-radius: 15px 15px 0 0;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            }
            
            .form-control-lg {
                padding: 12px 16px;
                border-radius: 8px;
                border: 2px solid #e9ecef;
                transition: all 0.3s ease;
            }
            
            .form-control-lg:focus {
                border-color: #667eea;
                box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
            }
            
            .btn-primary {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                border: none;
                border-radius: 8px;
                padding: 12px 30px;
                font-weight: 600;
                transition: all 0.3s ease;
            }
            
            .btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
            }
            
            .form-label {
                font-weight: 600;
                color: #333;
                margin-bottom: 8px;
            }
            
            .form-text {
                color: #6c757d;
                font-size: 0.875rem;
            }
            
            .alert {
                border-radius: 8px;
                border: none;
            }
            
            .text-primary {
                color: #667eea !important;
            }
            
            /* Ensure all form inputs are visible and styled consistently */
            input[type="text"], 
            input[type="email"], 
            input[type="tel"], 
            input[type="password"] {
                display: block !important;
                visibility: visible !important;
                opacity: 1 !important;
            }
            
            @media (max-width: 768px) {
                .col-md-6 {
                    margin: 20px;
                }
                
                .card-body {
                    padding: 20px;
                }
            }
        </style>

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