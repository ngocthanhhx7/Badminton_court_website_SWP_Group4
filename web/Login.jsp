<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="models.AdminDTO, models.UserDTO" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html class="no-js" lang="zxx">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Login Page</title>
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
    </head>
    <body>
        <!--[if lte IE 9]>
                <p class="browserupgrade">You are using an <strong>outdated</strong> browser. Please <a href="https://browsehappy.com/">upgrade your browser</a> to improve your experience and security.</p>
        <![endif]-->

        <%
Object acc = session.getAttribute("acc");
if (acc == null) {
// Nếu chưa đăng nhập, hiển thị header mặc định
        %>
        <jsp:include page="header.jsp" />
        <%
            } else {
                int type = 0;
                if (acc instanceof AdminDTO) {
                    type = 1;
                } else if (acc instanceof UserDTO) {
                    type = 2;
                }

                if (type == 1) {
        %>
        <jsp:include page="header-auth.jsp" />
        <%
                } else if (type == 2) {
        %>
        <jsp:include page="header-user.jsp" />
        <%
                }
            }
        %>

        <div class="bradcam_area breadcam_bg">
            <h3>About Montana</h3>
        </div>

        <section class="py-3 py-md-5 py-xl-8" style="margin-top: 120px;">

            <div class="container">
                <div class="row">
                    <div class="col-12">
                        <div class="mb-5">
                            <h2 class="display-5 fw-bold text-center">Sign in</h2>
                            <p class="text-center m-0">Don't have an account? <a href="register.jsp">Sign up</a></p>
                        </div>
                    </div>
                </div>

                <div class="row justify-content-center">
                    <div class="col-12 col-lg-10 col-xl-8">
                        <div class="row gy-5 justify-content-center">
                            <div class="col-12 col-lg-5">

                                <form action="Login" method="post">
                                    <div class="row gy-3 overflow-hidden">
                                        <div class="col-12">
                                            <!-- Hiển thị thông báo lỗi -->
                                            <c:if test="${not empty mess || not empty error}">
                                                <div class="alert alert-danger">
                                                    ${mess}${error}
                                                </div>
                                            </c:if>

                                            <div class="form-floating mb-3">
                                                <input type="text" class="form-control border-0 border-bottom rounded-0"
                                                       name="emailOrUsername" id="emailOrUsername"
                                                       value="${savedIdentifier}" placeholder="Enter your email or username" required>
                                                <label for="emailOrUsername" class="form-label">Email or Username</label>
                                            </div>
                                        </div>

                                        <div class="col-12">
                                            <div class="form-floating mb-3">
                                                <input type="password" class="form-control border-0 border-bottom rounded-0"
                                                       name="password" id="password"
                                                       value="${savedPassword}" placeholder="Password" required>
                                                <label for="password" class="form-label">Password</label>
                                            </div>
                                        </div>

                                        <div class="col-12">
                                            <div class="row justify-content-between">
                                                <div class="col-6">
                                                    <div class="form-check">
                                                        <input class="form-check-input" type="checkbox" name="remember_me" id="remember_me"
                                                               ${rememberChecked ? "checked" : ""}>

                                                        <label class="form-check-label text-secondary" for="remember_me">
                                                            Remember me
                                                        </label>
                                                    </div>
                                                </div>
                                                <div class="col-6 text-end">
                                                    <a href="forgotPassword.jsp" class="link-secondary text-decoration-none">Forgot password?</a>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="col-12">
                                            <div class="d-grid">
                                                <button class="btn btn-primary btn-lg" type="submit">Log in</button>
                                            </div>
                                        </div>
                                    </div>
                                </form>
                            </div>

                            <!-- Divider and Social login (unchanged) -->
                            <div class="col-12 col-lg-2 d-flex align-items-center justify-content-center gap-3 flex-lg-column">
                                <div class="bg-dark h-100 d-none d-lg-block" style="width: 1px; --bs-bg-opacity: .1;"></div>
                                <div class="bg-dark w-100 d-lg-none" style="height: 1px; --bs-bg-opacity: .1;"></div>
                                <div>or</div>
                                <div class="bg-dark h-100 d-none d-lg-block" style="width: 1px; --bs-bg-opacity: .1;"></div>
                                <div class="bg-dark w-100 d-lg-none" style="height: 1px; --bs-bg-opacity: .1;"></div>
                            </div>

                            <!-- Social buttons section (kept as-is, but you can customize) -->
                            <div class="col-12 col-lg-5 d-flex align-items-center">
                                <div class="d-flex gap-3 flex-column w-100">
                                    <a href="https://accounts.google.com/o/oauth2/auth?scope=email profile openid&redirect_uri=http://localhost:9999/SWP_Project/home&response_type=code&client_id=1064234495889-fl5bu11s9ofnk50uui5m6od0tdb3u0tp.apps.googleusercontent.com&approval_prompt=force" class="btn btn-lg btn-danger">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-google" viewBox="0 0 16 16">
                                        <path d="M15.545 6.558a9.42 9.42 0 0 1 .139 1.626c0 2.434-.87 4.492-2.384 5.885h.002C11.978 15.292 10.158 16 8 16A8 8 0 1 1 8 0a7.689 7.689 0 0 1 5.352 2.082l-2.284 2.284A4.347 4.347 0 0 0 8 3.166c-2.087 0-3.86 1.408-4.492 3.304a4.792 4.792 0 0 0 0 3.063h.003c.635 1.893 2.405 3.301 4.492 3.301 1.078 0 2.004-.276 2.722-.764h-.003a3.702 3.702 0 0 0 1.599-2.431H8v-3.08h7.545z" />
                                        </svg>
                                        <span class="ms-2 fs-6">Sign in with Google</span>
                                    </a>
                                    <a href="#" class="btn btn-lg btn-primary">
                                        <i class="bi bi-facebook"></i> <span class="ms-2 fs-6">Sign in with Facebook</span>
                                    </a>
                                    <a href="#" class="btn btn-lg btn-dark">
                                        <i class="bi bi-apple"></i> <span class="ms-2 fs-6">Sign in with Apple</span>
                                    </a>
                                </div>
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
