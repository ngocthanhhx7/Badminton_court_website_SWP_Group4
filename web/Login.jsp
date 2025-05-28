<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login Page</title>
    <link rel="stylesheet" href="https://unpkg.com/bootstrap@5.3.2/dist/css/bootstrap.min.css">
</head>
<body>

<section class="py-3 py-md-5 py-xl-8">
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
                                        <input type="text" class="form-control border-0 border-bottom rounded-0" name="emailOrUsername" id="emailOrUsername" placeholder="Enter your email or username" required>
                                        <label for="emailOrUsername" class="form-label">Email or Username</label>
                                    </div>
                                </div>

                                <div class="col-12">
                                    <div class="form-floating mb-3">
                                        <input type="password" class="form-control border-0 border-bottom rounded-0" name="password" id="password" placeholder="Password" required>
                                        <label for="password" class="form-label">Password</label>
                                    </div>
                                </div>

                                <div class="col-12">
                                    <div class="row justify-content-between">
                                        <div class="col-6">
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" name="remember_me" id="remember_me">
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
                            <a href="https://accounts.google.com/o/oauth2/auth?..." class="btn btn-lg btn-danger">
                                <i class="bi bi-google"></i> <span class="ms-2 fs-6">Sign in with Google</span>
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
