<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Xác minh tài khoản</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-6 col-lg-5">
            <div class="card shadow-sm">
                <div class="card-body">
                    <h4 class="card-title text-center mb-4">Xác minh tài khoản</h4>

                    <!-- Hiển thị thông báo nếu có -->
                    <c:if test="${not empty message}">
                        <div class="alert alert-danger">${message}</div>
                    </c:if>

                    <form action="verify" method="post">
                        <!-- Ẩn email lấy từ session -->
                        <c:if test="${not empty sessionScope.PENDING_USER}">
                            <input type="hidden" name="email" value="${sessionScope.PENDING_USER.email}" />
                        </c:if>

                        <div class="mb-3">
                            <label for="code" class="form-label">Mã xác minh</label>
                            <input type="text" class="form-control" id="code" name="code" required>
                        </div>

                        <button type="submit" class="btn btn-primary w-100">Xác minh</button>
                    </form>

                    <p class="mt-3 text-center">
                        <a href="register.jsp">Quay lại đăng ký</a>
                    </p>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>