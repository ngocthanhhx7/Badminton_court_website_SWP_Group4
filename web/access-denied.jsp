<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Access Denied - BadmintonHub</title>
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .access-denied-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .access-denied-card {
            background: white;
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            text-align: center;
            max-width: 500px;
            width: 90%;
        }
        .access-denied-icon {
            font-size: 80px;
            color: #dc3545;
            margin-bottom: 20px;
        }
        .access-denied-title {
            color: #dc3545;
            font-size: 28px;
            font-weight: bold;
            margin-bottom: 15px;
        }
        .access-denied-message {
            color: #6c757d;
            font-size: 16px;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        .btn-back {
            background: #007bff;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 25px;
            font-size: 16px;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
        }
        .btn-back:hover {
            background: #0056b3;
            color: white;
            text-decoration: none;
            transform: translateY(-2px);
        }
        .btn-home {
            background: #28a745;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 25px;
            font-size: 16px;
            text-decoration: none;
            display: inline-block;
            margin-left: 15px;
            transition: all 0.3s ease;
        }
        .btn-home:hover {
            background: #1e7e34;
            color: white;
            text-decoration: none;
            transform: translateY(-2px);
        }
        .role-info {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin: 20px 0;
            border-left: 4px solid #007bff;
        }
        .role-info h5 {
            color: #007bff;
            margin-bottom: 10px;
        }
        .role-info p {
            margin-bottom: 5px;
            color: #6c757d;
        }
    </style>
</head>
<body>
    <div class="access-denied-container">
        <div class="access-denied-card">
            <div class="access-denied-icon">🚫</div>
            <h1 class="access-denied-title">Access Denied</h1>
            <p class="access-denied-message">
                Bạn không có quyền truy cập vào trang này. 
                Chỉ Admin mới có thể truy cập các trang quản lý hệ thống.
            </p>
            
            <div class="role-info">
                <h5>📋 Phân quyền hệ thống:</h5>
                <p><strong>Admin:</strong> Có quyền truy cập tất cả trang quản lý</p>
                <p><strong>Staff:</strong> Chỉ có quyền truy cập trang quản lý cơ bản</p>
                <p><strong>Customer:</strong> Chỉ có quyền truy cập trang người dùng</p>
            </div>
            
            <div>
                <a href="javascript:history.back()" class="btn-back">← Quay lại</a>
                <a href="home" class="btn-home">🏠 Về trang chủ</a>
            </div>
        </div>
    </div>

    <script src="js/bootstrap.bundle.min.js"></script>
    <script>
        // Auto redirect sau 10 giây
        setTimeout(function() {
            window.location.href = 'home';
        }, 10000);
        
        // Hiển thị countdown
        let countdown = 10;
        const countdownElement = document.createElement('div');
        countdownElement.style.cssText = 'margin-top: 20px; color: #6c757d; font-size: 14px;';
        document.querySelector('.access-denied-card').appendChild(countdownElement);
        
        const timer = setInterval(function() {
            countdown--;
            countdownElement.textContent = `Tự động chuyển về trang chủ sau ${countdown} giây...`;
            if (countdown <= 0) {
                clearInterval(timer);
            }
        }, 1000);
    </script>
</body>
</html> 