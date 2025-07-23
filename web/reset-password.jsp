<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!doctype html>
<html class="no-js" lang="zxx">
<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>Đặt lại mật khẩu - BadmintonHub</title>
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

        .reset-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            padding: 40px;
            width: 100%;
            max-width: 450px;
        }

        .reset-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .reset-icon {
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

        .reset-title {
            color: #333;
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 10px;
        }

        .reset-subtitle {
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
            text-align: center;
            word-break: break-word;
        }

        .reset-form {
            margin-top: 30px;
        }

        .form-group {
            margin-bottom: 25px;
            position: relative;
        }

        .form-label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 600;
            font-size: 14px;
        }

        .form-input {
            width: 100%;
            padding: 15px 50px 15px 15px;
            border: 2px solid #e1e5e9;
            border-radius: 10px;
            font-size: 16px;
            transition: all 0.3s ease;
            background: white;
        }

        .form-input:focus {
            border-color: #667eea;
            outline: none;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .password-toggle {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: #666;
            cursor: pointer;
            font-size: 18px;
            padding: 5px;
            transition: color 0.3s ease;
        }

        .password-toggle:hover {
            color: #667eea;
        }

        .btn-reset {
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
            margin-bottom: 20px;
        }

        .btn-reset:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.3);
        }

        .btn-reset:active {
            transform: translateY(0);
        }

        .back-link {
            display: block;
            text-align: center;
            color: #667eea;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
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

        .password-requirements {
            background: #f8f9ff;
            border-left: 4px solid #667eea;
            padding: 15px;
            margin: 20px 0;
            border-radius: 0 10px 10px 0;
            font-size: 13px;
            color: #555;
        }

        .password-requirements ul {
            margin: 10px 0 0 0;
            padding-left: 20px;
        }

        .password-requirements li {
            margin-bottom: 5px;
        }

        .verified-badge {
            background: linear-gradient(135deg, #51cf66, #40c057);
            color: white;
            padding: 8px 15px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            margin-bottom: 20px;
        }

        @media (max-width: 480px) {
            .reset-container {
                margin: 20px;
                padding: 30px 20px;
            }
            
            .reset-title {
                font-size: 24px;
            }
            
            .reset-subtitle {
                font-size: 14px;
            }
        }
    </style>
</head>

<body>
    <div class="reset-container">
        <div class="reset-header">
            <div class="reset-icon">
                <i class="fas fa-key"></i>
            </div>
            <h1 class="reset-title">Đặt lại mật khẩu</h1>
            <p class="reset-subtitle">
                Tạo mật khẩu mới cho tài khoản của bạn
            </p>
        </div>

        <!-- Verified status -->
        <div class="text-center">
            <span class="verified-badge">
                <i class="fas fa-check-circle"></i>
                Email đã được xác minh
            </span>
        </div>

        <c:if test="${not empty email}">
            <div class="email-display">
                <i class="fas fa-envelope"></i> ${email}
            </div>
        </c:if>

        <div class="password-requirements">
            <i class="fas fa-info-circle"></i>
            <strong>Yêu cầu mật khẩu:</strong>
            <ul>
                <li>Ít nhất 6 ký tự</li>
                <li>Khác với mật khẩu cũ</li>
            </ul>
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

        <!-- Reset Password Form -->
        <form method="post" action="ResetPasswordServlet" class="reset-form" id="resetForm">
            <input type="hidden" name="email" value="${email}">
            <input type="hidden" name="verified" value="true">
            
            <div class="form-group">
                <label for="password" class="form-label">
                    <i class="fas fa-lock"></i> Mật khẩu mới
                </label>
                <input type="password" 
                       id="password" 
                       name="password" 
                       class="form-input" 
                       placeholder="Nhập mật khẩu mới"
                       required
                       minlength="6">
                <button type="button" class="password-toggle" onclick="togglePassword('password')">
                    <i class="fas fa-eye" id="password-eye"></i>
                </button>
            </div>

            <div class="form-group">
                <label for="confirmPassword" class="form-label">
                    <i class="fas fa-lock"></i> Xác nhận mật khẩu
                </label>
                <input type="password" 
                       id="confirmPassword" 
                       name="confirmPassword" 
                       class="form-input" 
                       placeholder="Nhập lại mật khẩu mới"
                       required
                       minlength="6">
                <button type="button" class="password-toggle" onclick="togglePassword('confirmPassword')">
                    <i class="fas fa-eye" id="confirmPassword-eye"></i>
                </button>
            </div>

            <button type="submit" class="btn-reset">
                <i class="fas fa-save"></i> Đặt lại mật khẩu
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
        // Toggle password visibility
        function togglePassword(fieldId) {
            const field = document.getElementById(fieldId);
            const eye = document.getElementById(fieldId + '-eye');
            
            if (field.type === 'password') {
                field.type = 'text';
                eye.classList.remove('fa-eye');
                eye.classList.add('fa-eye-slash');
            } else {
                field.type = 'password';
                eye.classList.remove('fa-eye-slash');
                eye.classList.add('fa-eye');
            }
        }

        // Form validation
        document.getElementById('resetForm').addEventListener('submit', function(e) {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (password !== confirmPassword) {
                e.preventDefault();
                alert('Mật khẩu và xác nhận mật khẩu không khớp!');
                return false;
            }
            
            if (password.length < 6) {
                e.preventDefault();
                alert('Mật khẩu phải có ít nhất 6 ký tự!');
                return false;
            }
        });

        // Real-time password matching feedback
        document.getElementById('confirmPassword').addEventListener('input', function() {
            const password = document.getElementById('password').value;
            const confirmPassword = this.value;
            
            if (confirmPassword.length > 0) {
                if (password === confirmPassword) {
                    this.style.borderColor = '#51cf66';
                    this.style.backgroundColor = '#f8fff8';
                } else {
                    this.style.borderColor = '#ff6b6b';
                    this.style.backgroundColor = '#fff8f8';
                }
            } else {
                this.style.borderColor = '#e1e5e9';
                this.style.backgroundColor = 'white';
            }
        });

        // Focus on first input when page loads
        window.addEventListener('load', function() {
            document.getElementById('password').focus();
        });
    </script>
</body>
</html>
