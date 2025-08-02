<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Email Verification - BadmintonHub</title>
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .verification-container {
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            max-width: 500px;
            width: 100%;
            text-align: center;
        }
        
        .verification-icon {
            font-size: 4rem;
            color: #667eea;
            margin-bottom: 20px;
        }
        
        .verification-title {
            color: #333;
            margin-bottom: 10px;
            font-weight: 600;
        }
        
        .verification-subtitle {
            color: #666;
            margin-bottom: 30px;
        }
        
        .verify-code-input {
            font-size: 1.5rem;
            text-align: center;
            letter-spacing: 0.5rem;
            font-weight: bold;
            margin-bottom: 20px;
            border: 2px solid #ddd;
            border-radius: 10px;
            padding: 15px;
        }
        
        .verify-code-input:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        
        .btn-verify {
            background: linear-gradient(45deg, #667eea, #764ba2);
            border: none;
            padding: 12px 30px;
            border-radius: 8px;
            color: white;
            font-weight: 600;
            width: 100%;
            margin-bottom: 15px;
        }
        
        .btn-verify:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
            color: white;
        }
        
        .btn-resend {
            background: #6c757d;
            border: none;
            padding: 10px 25px;
            border-radius: 8px;
            color: white;
            margin-right: 10px;
        }
        
        .btn-resend:hover {
            background: #5a6268;
            color: white;
        }
        
        .btn-resend:disabled {
            background: #e9ecef;
            color: #6c757d;
            cursor: not-allowed;
        }
        
        .alert {
            border-radius: 10px;
            margin-bottom: 20px;
        }
        
        .info-box {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        
        .info-box h6 {
            color: #333;
            margin-bottom: 10px;
        }
        
        .info-box p {
            color: #666;
            margin: 5px 0;
        }
        
        .back-to-login {
            margin-top: 20px;
        }
        
        .back-to-login a {
            color: #667eea;
            text-decoration: none;
        }
        
        .back-to-login a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="verification-container">
        <i class="fas fa-envelope-open verification-icon"></i>
        <h2 class="verification-title">Xác Minh Email</h2>
        <p class="verification-subtitle">
            Chúng tôi đã gửi mã xác minh 6 số đến email: <br>
            <strong>${email}</strong>
        </p>

        <!-- Success Message -->
        <c:if test="${not empty success}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> ${success}
            </div>
        </c:if>

        <!-- Error Message -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>

        <!-- Verification Form -->
        <form method="POST" action="email-verification">
            <input type="hidden" name="action" value="verify">
            <input type="hidden" name="email" value="${email}">
            
            <div class="mb-3">
                <input type="text" 
                       class="form-control verify-code-input" 
                       name="verifyCode" 
                       placeholder="000000"
                       maxlength="6"
                       pattern="[0-9]{6}"
                       required
                       autocomplete="off">
            </div>
            
            <button type="submit" class="btn btn-verify">
                <i class="fas fa-check"></i> Xác Minh
            </button>
        </form>

        <!-- Resend Section -->
        <div class="resend-section">
            <c:choose>
                <c:when test="${canResend}">
                    <form method="POST" action="email-verification" style="display: inline;">
                        <input type="hidden" name="action" value="resend">
                        <input type="hidden" name="email" value="${email}">
                        <button type="submit" class="btn btn-resend">
                            <i class="fas fa-redo"></i> Gửi Lại Mã
                        </button>
                    </form>
                </c:when>
                <c:otherwise>
                    <button class="btn btn-resend" disabled>
                        <i class="fas fa-clock"></i> Chờ 2 phút để gửi lại
                    </button>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Info Box -->
        <div class="info-box">
            <h6><i class="fas fa-info-circle"></i> Thông Tin</h6>
            <p><i class="fas fa-clock"></i> Mã xác minh có hiệu lực trong 15 phút</p>
            <p><i class="fas fa-envelope"></i> Kiểm tra cả hộp thư spam/junk</p>
            <c:if test="${not empty resendCount and resendCount > 0}">
                <p><i class="fas fa-redo"></i> Đã gửi lại: ${resendCount} lần</p>
            </c:if>
        </div>

        <!-- Back to Login -->
        <div class="back-to-login">
            <a href="UserLoginController">
                <i class="fas fa-arrow-left"></i> Quay lại trang đăng nhập
            </a>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Auto focus on verify code input
        document.addEventListener('DOMContentLoaded', function() {
            const verifyCodeInput = document.querySelector('input[name="verifyCode"]');
            if (verifyCodeInput) {
                verifyCodeInput.focus();
            }
        });

        // Only allow numbers in verify code input
        document.querySelector('input[name="verifyCode"]').addEventListener('input', function(e) {
            this.value = this.value.replace(/[^0-9]/g, '');
        });
    </script>
</body>
</html>
