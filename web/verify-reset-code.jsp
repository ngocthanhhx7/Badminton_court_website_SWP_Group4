<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!doctype html>
<html class="no-js" lang="zxx">
<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>Xác minh mã đặt lại mật khẩu - BadmintonHub</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon" href="img/favicon.png">
    
    <!-- CSS here -->
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="css/style.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .verification-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            padding: 40px;
            width: 100%;
            max-width: 450px;
            text-align: center;
        }

        .verification-header {
            margin-bottom: 30px;
        }

        .verification-icon {
            width: 80px;
            height: 80px;
            margin: 0 auto 20px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 40px;
            color: white;
        }

        .verification-title {
            color: #333;
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 10px;
        }

        .verification-subtitle {
            color: #666;
            font-size: 16px;
            line-height: 1.5;
        }

        .email-display {
            background: #f8f9ff;
            border: 2px solid #667eea;
            border-radius: 10px;
            padding: 12px;
            margin: 20px 0;
            font-weight: 600;
            color: #667eea;
            word-break: break-word;
        }

        .verification-form {
            margin-top: 30px;
        }

        .form-group {
            margin-bottom: 25px;
            text-align: left;
        }

        .form-label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 600;
            font-size: 14px;
        }

        .verification-input {
            width: 100%;
            padding: 15px;
            border: 2px solid #e1e5e9;
            border-radius: 10px;
            font-size: 18px;
            text-align: center;
            letter-spacing: 5px;
            font-weight: 600;
            transition: all 0.3s ease;
            background: white;
        }

        .verification-input:focus {
            border-color: #667eea;
            outline: none;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .btn-verify {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-bottom: 15px;
        }

        .btn-verify:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.3);
        }

        .btn-verify:active {
            transform: translateY(0);
        }

        .btn-resend {
            width: 100%;
            padding: 12px;
            background: transparent;
            color: #667eea;
            border: 2px solid #667eea;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-bottom: 20px;
        }

        .btn-resend:hover {
            background: #667eea;
            color: white;
        }

        .back-link {
            color: #667eea;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            transition: all 0.3s ease;
        }

        .back-link:hover {
            color: #764ba2;
            text-decoration: none;
        }

        .alert {
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 20px;
            border: none;
            font-weight: 500;
        }

        .alert-danger {
            background: linear-gradient(135deg, #ff6b6b, #ee5a24);
            color: white;
        }

        .alert-success {
            background: linear-gradient(135deg, #51cf66, #40c057);
            color: white;
        }

        .alert-info {
            background: linear-gradient(135deg, #339af0, #228be6);
            color: white;
        }

        .instruction-text {
            background: #f8f9ff;
            border-left: 4px solid #667eea;
            padding: 15px;
            margin: 20px 0;
            border-radius: 0 10px 10px 0;
            font-size: 14px;
            color: #555;
            text-align: left;
        }

        @media (max-width: 480px) {
            .verification-container {
                margin: 20px;
                padding: 30px 20px;
            }
            
            .verification-title {
                font-size: 24px;
            }
            
            .verification-subtitle {
                font-size: 14px;
            }
        }
    </style>
</head>

<body>
    <div class="verification-container">
        <div class="verification-header">
            <div class="verification-icon">
                <i class="fas fa-shield-alt"></i>
            </div>
            <h1 class="verification-title">Xác minh Email</h1>
            <p class="verification-subtitle">
                Chúng tôi đã gửi mã xác minh 6 chữ số đến email của bạn
            </p>
        </div>

        <c:if test="${not empty email}">
            <div class="email-display">
                <i class="fas fa-envelope"></i> ${email}
            </div>
        </c:if>

        <div class="instruction-text">
            <i class="fas fa-info-circle"></i>
            <strong>Lưu ý:</strong> Mã xác minh có hiệu lực trong 10 phút. Vui lòng kiểm tra cả hộp thư spam nếu không thấy email.
        </div>

        <!-- Display messages -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-triangle"></i>
                ${error}
            </div>
        </c:if>

        <c:if test="${not empty success}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                ${success}
            </div>
        </c:if>

        <!-- Verification Form -->
        <form method="post" action="VerifyResetCodeServlet" class="verification-form">
            <input type="hidden" name="email" value="${email}">
            
            <div class="form-group">
                <label for="verificationCode" class="form-label">
                    <i class="fas fa-key"></i> Mã xác minh (6 chữ số)
                </label>
                <input type="text" 
                       id="verificationCode" 
                       name="verificationCode" 
                       class="verification-input" 
                       placeholder="000000"
                       maxlength="6"
                       pattern="[0-9]{6}"
                       required
                       autocomplete="off">
            </div>

            <button type="submit" class="btn-verify">
                <i class="fas fa-check"></i> Xác minh mã
            </button>
        </form>

        <!-- Resend Code Form -->
        <form method="post" action="VerifyResetCodeServlet" style="margin-bottom: 20px;">
            <input type="hidden" name="email" value="${email}">
            <input type="hidden" name="action" value="resend">
            <button type="submit" class="btn-resend">
                <i class="fas fa-redo"></i> Gửi lại mã xác minh
            </button>
        </form>

        <!-- Back to login -->
        <a href="Login" class="back-link">
            <i class="fas fa-arrow-left"></i>
            Quay lại đăng nhập
        </a>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Auto-format verification code input
        const codeInput = document.getElementById('verificationCode');
        
        codeInput.addEventListener('input', function(e) {
            // Only allow numbers
            this.value = this.value.replace(/[^0-9]/g, '');
            
            // Limit to 6 digits
            if (this.value.length > 6) {
                this.value = this.value.slice(0, 6);
            }
        });

        // Auto-submit when 6 digits are entered
        codeInput.addEventListener('input', function(e) {
            if (this.value.length === 6) {
                // Add visual feedback
                this.style.borderColor = '#51cf66';
                this.style.backgroundColor = '#f8fff8';
            } else {
                this.style.borderColor = '#e1e5e9';
                this.style.backgroundColor = 'white';
            }
        });

        // Focus on code input when page loads
        window.addEventListener('load', function() {
            codeInput.focus();
        });

        // Paste handling for verification code
        codeInput.addEventListener('paste', function(e) {
            e.preventDefault();
            const paste = (e.clipboardData || window.clipboardData).getData('text');
            const numbers = paste.replace(/[^0-9]/g, '').slice(0, 6);
            this.value = numbers;
            
            if (numbers.length === 6) {
                this.style.borderColor = '#51cf66';
                this.style.backgroundColor = '#f8fff8';
            }
        });
    </script>
</body>
</html>
