<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="models.UserDTO" %>
<%
    Object accObj = session.getAttribute("acc");
    UserDTO user = null;
    
    // Chỉ xử lý cho UserDTO
    if (accObj instanceof UserDTO) {
        user = (UserDTO) accObj;
    } else {
        response.sendRedirect("./Login.jsp");
        return;
    }
    
    if (user == null) {
        response.sendRedirect("./Login.jsp");
        return;
    }

    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Đổi mật khẩu</title>
        <link href="https://fonts.googleapis.com/css2?family=Noto+Sans&display=swap" rel="stylesheet">
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <link rel="shortcut icon" type="image/x-icon" href="img/favicon.png">
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
        
        <style>
            body {
                font-family: 'Noto Sans', sans-serif;
                background: linear-gradient(135deg, #42a5f5, #7e57c2);
                margin: 0;
                padding: 0;
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
                overflow: auto;
            }

            .form-container {
                background: white;
                padding: 40px 50px;
                border-radius: 12px;
                box-shadow: 0 10px 25px rgba(0,0,0,0.2);
                width: 450px;
                max-width: 90%;
                margin: 20px;
            }

            h2 {
                text-align: center;
                color: #7b1fa2;
                margin-bottom: 30px;
                font-size: 24px;
                font-weight: 600;
            }

            .form-group {
                margin-bottom: 20px;
            }

            .form-group label {
                display: block;
                margin-bottom: 8px;
                color: #333;
                font-weight: 600;
                font-size: 14px;
            }

            .form-group input {
                width: 100%;
                padding: 12px 15px;
                border: 1px solid #ddd;
                border-radius: 8px;
                font-size: 14px;
                transition: all 0.3s ease;
                box-sizing: border-box;
            }

            .form-group input:focus {
                border-color: #ab47bc;
                outline: none;
                box-shadow: 0 0 5px rgba(171, 71, 188, 0.3);
            }

            .btn-primary {
                background: #ab47bc;
                color: white;
                padding: 12px 20px;
                border: none;
                border-radius: 30px;
                cursor: pointer;
                width: 100%;
                font-weight: bold;
                font-size: 16px;
                transition: background 0.3s ease;
                margin-top: 10px;
            }

            .btn-primary:hover {
                background: #8e24aa;
            }

            .btn-secondary {
                display: inline-block;
                margin-top: 15px;
                text-align: center;
                color: #7b1fa2;
                text-decoration: none;
                width: 100%;
                padding: 10px;
                border: 1px solid #7b1fa2;
                border-radius: 30px;
                transition: all 0.3s ease;
                box-sizing: border-box;
            }

            .btn-secondary:hover {
                background: #7b1fa2;
                color: white;
                text-decoration: none;
            }

            .alert {
                padding: 12px 15px;
                border-radius: 8px;
                margin-bottom: 20px;
                text-align: center;
                font-weight: 500;
            }

            .alert-danger {
                background-color: #f8d7da;
                border: 1px solid #f5c6cb;
                color: #721c24;
            }

            .alert-success {
                background-color: #d4edda;
                border: 1px solid #c3e6cb;
                color: #155724;
            }

            .password-requirements {
                font-size: 12px;
                color: #666;
                margin-top: 5px;
                font-style: italic;
            }

            .required {
                color: #e74c3c;
            }

            @media (max-width: 768px) {
                .form-container {
                    padding: 30px 25px;
                    width: 95%;
                }
                
                h2 {
                    font-size: 20px;
                }
            }
        </style>
    </head>

    <body>
        <div class="form-container">
            <h2><i class="fa fa-lock"></i> Đổi mật khẩu</h2>

            <% if (error != null) { %>
                <div class="alert alert-danger">
                    <i class="fa fa-exclamation-triangle"></i> <%= error %>
                </div>
            <% } %>
            
            <% if (success != null) { %>
                <div class="alert alert-success">
                    <i class="fa fa-check-circle"></i> <%= success %>
                </div>
            <% } %>

            <form action="change-password" method="post" id="changePasswordForm" onsubmit="return validateChangePasswordForm()">
                <div class="form-group">
                    <label for="currentPassword">
                        <i class="fa fa-key"></i> Mật khẩu hiện tại <span class="required">*</span>
                    </label>
                    <input type="password" 
                           id="currentPassword" 
                           name="currentPassword" 
                           required 
                           placeholder="Nhập mật khẩu hiện tại">
                </div>

                <div class="form-group">
                    <label for="newPassword">
                        <i class="fa fa-lock"></i> Mật khẩu mới <span class="required">*</span>
                    </label>
                    <input type="password" 
                           id="newPassword" 
                           name="newPassword" 
                           required 
                           minlength="6"
                           placeholder="Nhập mật khẩu mới">
                    <div class="password-requirements">
                        Mật khẩu phải có ít nhất 6 ký tự
                    </div>
                </div>

                <div class="form-group">
                    <label for="confirmPassword">
                        <i class="fa fa-check"></i> Xác nhận mật khẩu mới <span class="required">*</span>
                    </label>
                    <input type="password" 
                           id="confirmPassword" 
                           name="confirmPassword" 
                           required 
                           minlength="6"
                           placeholder="Nhập lại mật khẩu mới">
                </div>

                <button type="submit" class="btn-primary">
                    <i class="fa fa-save"></i> Cập nhật mật khẩu
                </button>
            </form>

            <a href="view-profile" class="btn-secondary">
                <i class="fa fa-arrow-left"></i> Quay lại hồ sơ
            </a>
        </div>

        <script>
            // Function to remove whitespace from input
            function removeWhitespace(input) {
                input.value = input.value.replace(/\s/g, '');
            }

            // Function to validate form before submission
            function validateChangePasswordForm() {
                const currentPassword = document.getElementById('currentPassword');
                const newPassword = document.getElementById('newPassword');
                const confirmPassword = document.getElementById('confirmPassword');
                
                // Check for whitespace in the middle of the input
                if (currentPassword.value.includes(' ')) {
                    alert("Mật khẩu hiện tại không được chứa khoảng trắng!");
                    currentPassword.focus();
                    return false;
                }
                
                if (newPassword.value.includes(' ')) {
                    alert("Mật khẩu mới không được chứa khoảng trắng!");
                    newPassword.focus();
                    return false;
                }
                
                if (confirmPassword.value.includes(' ')) {
                    alert("Xác nhận mật khẩu không được chứa khoảng trắng!");
                    confirmPassword.focus();
                    return false;
                }
                
                // Remove any existing whitespace
                removeWhitespace(currentPassword);
                removeWhitespace(newPassword);
                removeWhitespace(confirmPassword);
                
                // Check if fields are empty after removing whitespace
                if (!currentPassword.value.trim()) {
                    alert("Mật khẩu hiện tại không được để trống!");
                    currentPassword.focus();
                    return false;
                }
                
                if (!newPassword.value.trim()) {
                    alert("Mật khẩu mới không được để trống!");
                    newPassword.focus();
                    return false;
                }
                
                if (!confirmPassword.value.trim()) {
                    alert("Xác nhận mật khẩu không được để trống!");
                    confirmPassword.focus();
                    return false;
                }
                
                // Check password match
                if (newPassword.value !== confirmPassword.value) {
                    alert('Mật khẩu mới và xác nhận mật khẩu không khớp!');
                    confirmPassword.focus();
                    return false;
                }
                
                // Check password length
                if (newPassword.value.length < 6) {
                    alert('Mật khẩu mới phải có ít nhất 6 ký tự!');
                    newPassword.focus();
                    return false;
                }
                
                return true;
            }

            // Add event listeners to prevent whitespace input
            document.addEventListener('DOMContentLoaded', function() {
                const currentPassword = document.getElementById('currentPassword');
                const newPassword = document.getElementById('newPassword');
                const confirmPassword = document.getElementById('confirmPassword');
                
                // Prevent whitespace on input with immediate feedback
                currentPassword.addEventListener('input', function() {
                    if (this.value.includes(' ')) {
                        alert("Mật khẩu hiện tại không được chứa khoảng trắng!");
                        this.value = this.value.replace(/\s/g, '');
                    }
                });
                
                newPassword.addEventListener('input', function() {
                    if (this.value.includes(' ')) {
                        alert("Mật khẩu mới không được chứa khoảng trắng!");
                        this.value = this.value.replace(/\s/g, '');
                    }
                });
                
                confirmPassword.addEventListener('input', function() {
                    if (this.value.includes(' ')) {
                        alert("Xác nhận mật khẩu không được chứa khoảng trắng!");
                        this.value = this.value.replace(/\s/g, '');
                    }
                });
                
                // Prevent paste with whitespace
                currentPassword.addEventListener('paste', function(e) {
                    setTimeout(() => {
                        if (this.value.includes(' ')) {
                            alert("Mật khẩu hiện tại không được chứa khoảng trắng!");
                            this.value = this.value.replace(/\s/g, '');
                        }
                    }, 0);
                });
                
                newPassword.addEventListener('paste', function(e) {
                    setTimeout(() => {
                        if (this.value.includes(' ')) {
                            alert("Mật khẩu mới không được chứa khoảng trắng!");
                            this.value = this.value.replace(/\s/g, '');
                        }
                    }, 0);
                });
                
                confirmPassword.addEventListener('paste', function(e) {
                    setTimeout(() => {
                        if (this.value.includes(' ')) {
                            alert("Xác nhận mật khẩu không được chứa khoảng trắng!");
                            this.value = this.value.replace(/\s/g, '');
                        }
                    }, 0);
                });
                
                // Prevent space key from being typed
                currentPassword.addEventListener('keydown', function(e) {
                    if (e.key === ' ') {
                        e.preventDefault();
                        alert("Mật khẩu hiện tại không được chứa khoảng trắng!");
                    }
                });
                
                newPassword.addEventListener('keydown', function(e) {
                    if (e.key === ' ') {
                        e.preventDefault();
                        alert("Mật khẩu mới không được chứa khoảng trắng!");
                    }
                });
                
                confirmPassword.addEventListener('keydown', function(e) {
                    if (e.key === ' ') {
                        e.preventDefault();
                        alert("Xác nhận mật khẩu không được chứa khoảng trắng!");
                    }
                });
            });

            // Real-time validation for password match
            document.getElementById('confirmPassword').addEventListener('input', function() {
                const newPassword = document.getElementById('newPassword').value;
                const confirmPassword = this.value;
                
                if (confirmPassword && newPassword !== confirmPassword) {
                    this.style.borderColor = '#e74c3c';
                } else if (confirmPassword && newPassword === confirmPassword) {
                    this.style.borderColor = '#27ae60';
                } else {
                    this.style.borderColor = '#ddd';
                }
            });
        </script>
    </body>
</html>
