<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="models.UserDTO" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    Object sessionUser = session.getAttribute("currentUser");
    if (sessionUser == null) {
        sessionUser = session.getAttribute("acc");
    }
    if (sessionUser == null || !(sessionUser instanceof UserDTO)) {
        response.sendRedirect("./Login.jsp");
        return;
    }
    UserDTO user = (UserDTO) sessionUser;
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Hoàn thiện hồ sơ - BadmintonCourt</title>
        <meta name="description" content="Hoàn thiện thông tin cá nhân để sử dụng dịch vụ">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <link rel="shortcut icon" type="image/x-icon" href="img/favicon.png">

        <!-- CSS here -->
        <link rel="stylesheet" href="css/bootstrap.min.css">
        <link rel="stylesheet" href="css/font-awesome.min.css">
        <link rel="stylesheet" href="css/style.css">
        
        <style>
            :root {
                --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                --success-gradient: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
                --danger-gradient: linear-gradient(135deg, #ff416c 0%, #ff4b2b 100%);
                --glass-bg: rgba(255, 255, 255, 0.1);
                --glass-border: rgba(255, 255, 255, 0.2);
                --text-primary: #2c3e50;
                --text-secondary: #7f8c8d;
                --shadow-lg: 0 20px 40px rgba(0, 0, 0, 0.1);
                --shadow-xl: 0 25px 50px rgba(0, 0, 0, 0.15);
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: var(--primary-gradient);
                min-height: 100vh;
                position: relative;
                overflow-x: hidden;
            }

            /* Animated Background */
            body::before {
                content: '';
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: 
                    radial-gradient(circle at 20% 80%, rgba(120, 119, 198, 0.3) 0%, transparent 50%),
                    radial-gradient(circle at 80% 20%, rgba(255, 119, 198, 0.3) 0%, transparent 50%),
                    radial-gradient(circle at 40% 40%, rgba(120, 219, 255, 0.2) 0%, transparent 50%);
                z-index: -1;
                animation: backgroundFlow 10s ease-in-out infinite alternate;
            }

            @keyframes backgroundFlow {
                0% { transform: translateX(-20px) translateY(-20px); }
                100% { transform: translateX(20px) translateY(20px); }
            }

            .profile-setup-container {
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 20px;
                position: relative;
            }

            .profile-card {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(20px);
                border: 1px solid rgba(255, 255, 255, 0.3);
                border-radius: 24px;
                padding: 40px;
                max-width: 600px;
                width: 100%;
                box-shadow: 0 25px 50px rgba(0, 0, 0, 0.2);
                position: relative;
                animation: cardSlideUp 0.8s ease-out;
            }

            @keyframes cardSlideUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .profile-header {
                text-align: center;
                margin-bottom: 40px;
                position: relative;
                padding: 20px;
                background: rgba(255, 255, 255, 0.1);
                border-radius: 16px;
                border: 1px solid rgba(255, 255, 255, 0.2);
                backdrop-filter: blur(10px);
            }

            .profile-icon {
                width: 80px;
                height: 80px;
                margin: 0 auto 20px;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                box-shadow: 0 10px 30px rgba(102, 126, 234, 0.3);
                animation: iconPulse 2s ease-in-out infinite;
            }

            @keyframes iconPulse {
                0%, 100% { transform: scale(1); }
                50% { transform: scale(1.05); }
            }

            .profile-icon i {
                font-size: 36px;
                color: white;
                text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
            }

            .profile-header h2 {
                color: white;
                font-size: 28px;
                font-weight: 700;
                margin-bottom: 10px;
                text-shadow: 
                    0 1px 3px rgba(0, 0, 0, 0.5),
                    0 2px 6px rgba(0, 0, 0, 0.3),
                    0 3px 12px rgba(0, 0, 0, 0.2);
                position: relative;
                z-index: 2;
            }

            /* Alternative header style for better visibility */
            .profile-header::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: linear-gradient(135deg, rgba(102, 126, 234, 0.2) 0%, rgba(118, 75, 162, 0.2) 100%);
                border-radius: 16px;
                z-index: -1;
            }

            /* Enhanced text visibility */
            .profile-header h2 {
                color: white;
                font-size: 28px;
                font-weight: 700;
                margin-bottom: 10px;
                text-shadow: 
                    0 1px 3px rgba(0, 0, 0, 0.5),
                    0 2px 6px rgba(0, 0, 0, 0.3),
                    0 3px 12px rgba(0, 0, 0, 0.2);
                position: relative;
                z-index: 2;
            }

            .form-group {
                margin-bottom: 25px;
                animation: fadeInUp 0.6s ease-out forwards;
                opacity: 0;
            }

            .form-group:nth-child(1) { animation-delay: 0.1s; }
            .form-group:nth-child(2) { animation-delay: 0.2s; }
            .form-group:nth-child(3) { animation-delay: 0.3s; }
            .form-group:nth-child(4) { animation-delay: 0.4s; }
            .form-group:nth-child(5) { animation-delay: 0.5s; }
            .form-group:nth-child(6) { animation-delay: 0.6s; }

            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            label {
                display: block;
                margin-bottom: 8px;
                color: #2c3e50;
                font-weight: 600;
                font-size: 14px;
            }

            .required-indicator {
                color: #ff6b6b;
                margin-left: 3px;
            }

            .input-group {
                position: relative;
            }

            .input-icon {
                position: absolute;
                left: 16px;
                top: 50%;
                transform: translateY(-50%);
                color: #7f8c8d;
                font-size: 16px;
                z-index: 2;
                transition: color 0.3s ease;
                pointer-events: none;
            }

            .form-control-modern {
                width: 100%;
                padding: 16px 16px 16px 50px;
                border: 2px solid rgba(255, 255, 255, 0.3);
                border-radius: 12px;
                background: rgba(255, 255, 255, 0.9);
                backdrop-filter: blur(10px);
                color: #2c3e50;
                font-size: 15px;
                font-weight: 500;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            }

            .form-control-modern::placeholder {
                color: #7f8c8d;
                font-weight: 400;
            }

            .form-control-modern:focus {
                outline: none;
                border-color: #667eea;
                background: rgba(255, 255, 255, 0.95);
                transform: scale(1.02);
                box-shadow: 0 8px 25px rgba(102, 126, 234, 0.2);
                color: #2c3e50;
            }

            .form-control-modern:focus + .input-icon {
                color: #667eea;
            }

            /* Specific styles for select dropdown */
            select.form-control-modern {
                background: rgba(255, 255, 255, 0.9) url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20'%3e%3cpath stroke='%236b7280' stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' d='m6 8 4 4 4-4'/%3e%3c/svg%3e") no-repeat right 12px center/16px 16px;
                appearance: none;
                -webkit-appearance: none;
                -moz-appearance: none;
                cursor: pointer;
            }

            select.form-control-modern:focus {
                background: rgba(255, 255, 255, 0.95) url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20'%3e%3cpath stroke='%23667eea' stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' d='m6 8 4 4 4-4'/%3e%3c/svg%3e") no-repeat right 12px center/16px 16px;
            }

            /* Dropdown options styling */
            select.form-control-modern option {
                background: #ffffff;
                color: #2c3e50;
                padding: 12px 16px;
                font-weight: 500;
                border: none;
            }

            select.form-control-modern option:hover,
            select.form-control-modern option:focus,
            select.form-control-modern option:checked {
                background: #667eea;
                color: white;
            }

            /* Date input specific styling */
            input[type="date"].form-control-modern {
                color: #2c3e50;
            }

            input[type="date"].form-control-modern::-webkit-calendar-picker-indicator {
                background: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' fill='%236b7280' viewBox='0 0 20 20'%3e%3cpath fill-rule='evenodd' d='M6 2a1 1 0 00-1 1v1H4a2 2 0 00-2 2v10a2 2 0 002 2h12a2 2 0 002-2V6a2 2 0 00-2-2h-1V3a1 1 0 10-2 0v1H7V3a1 1 0 00-1-1zm0 5a1 1 0 000 2h8a1 1 0 100-2H6z' clip-rule='evenodd'/%3e%3c/svg%3e") no-repeat center;
                background-size: 16px 16px;
                width: 16px;
                height: 16px;
                cursor: pointer;
            }

            /* Readonly input styling */
            .form-control-modern[readonly] {
                background: rgba(108, 117, 125, 0.1);
                color: #6c757d;
                cursor: not-allowed;
                border-color: rgba(255, 255, 255, 0.2);
            }

            /* Input validation states */
            .form-control-modern.valid {
                border-color: #28a745;
                box-shadow: 0 4px 15px rgba(40, 167, 69, 0.2);
            }

            .form-control-modern.invalid {
                border-color: #dc3545;
                box-shadow: 0 4px 15px rgba(220, 53, 69, 0.2);
            }

            /* Enhanced dropdown styling for better browser compatibility */
            .form-control-modern:focus {
                outline: none;
                border-color: #667eea;
                background: rgba(255, 255, 255, 0.95);
                transform: scale(1.02);
                box-shadow: 0 8px 25px rgba(102, 126, 234, 0.2);
                color: #2c3e50;
            }

            /* Custom dropdown for better visibility */
            .enhanced-select {
                position: relative;
                display: block;
            }

            .enhanced-select::after {
                content: '';
                position: absolute;
                right: 16px;
                top: 50%;
                transform: translateY(-50%);
                width: 0;
                height: 0;
                border-left: 6px solid transparent;
                border-right: 6px solid transparent;
                border-top: 6px solid #7f8c8d;
                pointer-events: none;
                z-index: 3;
            }

            /* Mobile responsive improvements */
            @media (max-width: 768px) {
                .form-control-modern {
                    padding: 14px 14px 14px 45px;
                    font-size: 16px; /* Prevents zoom on iOS */
                }
                
                select.form-control-modern {
                    background-position: right 10px center;
                }
            }

            .form-hint {
                margin-top: 6px;
                font-size: 12px;
                color: #6c757d;
                background: rgba(108, 117, 125, 0.1);
                padding: 4px 8px;
                border-radius: 6px;
                border: 1px solid rgba(108, 117, 125, 0.2);
            }

            .sport-level-info {
                margin-top: 8px;
                padding: 12px;
                background: rgba(52, 152, 219, 0.1);
                border-radius: 8px;
                border-left: 4px solid #3498db;
                font-size: 13px;
                color: #2c3e50;
                border: 1px solid rgba(52, 152, 219, 0.2);
            }

            .sport-level-info i {
                margin-right: 8px;
                color: #3498db;
            }

            .submit-btn {
                width: 100%;
                padding: 18px;
                background: var(--success-gradient);
                border: none;
                border-radius: 12px;
                color: white;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                box-shadow: var(--shadow-lg);
                position: relative;
                overflow: hidden;
                margin-top: 20px;
            }

            .submit-btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
            }

            .submit-btn:active {
                transform: translateY(0);
            }

            .submit-btn i {
                margin-right: 10px;
                font-size: 18px;
            }

            .alert-modern {
                padding: 16px 20px;
                border-radius: 12px;
                margin-bottom: 25px;
                border: none;
                font-size: 14px;
                animation: alertSlideDown 0.5s ease-out;
            }

            .alert-danger-modern {
                background: rgba(231, 76, 60, 0.1);
                color: #e74c3c;
                border-left: 4px solid #e74c3c;
                backdrop-filter: blur(10px);
            }

            @keyframes alertSlideDown {
                from {
                    opacity: 0;
                    transform: translateY(-20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            /* Responsive Design */
            @media (max-width: 768px) {
                .profile-card {
                    padding: 30px 20px;
                    margin: 10px;
                }

                .profile-header h2 {
                    font-size: 24px;
                }

                .form-control-modern {
                    padding: 14px 14px 14px 45px;
                }
            }

            /* Loading Animation */
            .submit-btn.loading {
                pointer-events: none;
            }

            .submit-btn.loading::after {
                content: '';
                position: absolute;
                top: 50%;
                left: 50%;
                width: 20px;
                height: 20px;
                margin: -10px 0 0 -10px;
                border: 2px solid transparent;
                border-top: 2px solid white;
                border-radius: 50%;
                animation: spin 1s linear infinite;
            }

            @keyframes spin {
                0% { transform: rotate(0deg); }
                100% { transform: rotate(360deg); }
            }
        </style>
    </head>
    <body>
        <div class="profile-setup-container">
            <div class="profile-card">
                <div class="profile-header">
                    <div class="profile-icon">
                        <i class="fa fa-user-circle"></i>
                    </div>
                    <h2>Hoàn thiện hồ sơ</h2>
                    <p>Vui lòng cung cấp thông tin cá nhân để có trải nghiệm tốt nhất với dịch vụ của chúng tôi</p>
                </div>
                
                <c:if test="${not empty message}">
                    <div class="alert-modern alert-danger-modern">
                        <i class="fa fa-exclamation-triangle"></i> ${message}
                    </div>
                </c:if>
                
                <form action="profile-setup" method="post" id="profileForm">
                    <div class="form-group">
                        <label for="fullname">Họ và tên <span class="required-indicator">*</span></label>
                        <div class="input-group">
                            <input type="text" 
                                   name="fullname" 
                                   id="fullname"
                                   class="form-control-modern" 
                                   placeholder="Nhập họ và tên đầy đủ"
                                   value="<%= user.getFullName() != null ? user.getFullName() : "" %>"
                                   required>
                            <div class="input-icon"><i class="fa fa-user"></i></div>
                        </div>
                        <div class="form-hint">Ví dụ: Nguyễn Văn An</div>
                    </div>
                    
                    <div class="form-group">
                        <label for="dob">Ngày sinh <span class="required-indicator">*</span></label>
                        <div class="input-group">
                            <input type="date" 
                                   name="dob" 
                                   id="dob"
                                   class="form-control-modern"
                                   value="<%= user.getDob() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd").format(user.getDob()) : "" %>"
                                   max="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>"
                                   required>
                            <div class="input-icon"><i class="fa fa-calendar"></i></div>
                        </div>
                        <div class="form-hint">Chọn ngày sinh của bạn</div>
                    </div>
                    
                    <div class="form-group">
                        <label for="gender">Giới tính <span class="required-indicator">*</span></label>
                        <div class="input-group enhanced-select">
                            <select name="gender" id="gender" class="form-control-modern" required>
                                <option value="">-- Chọn giới tính --</option>
                                <option value="Male" <%= "Male".equals(user.getGender()) ? "selected" : "" %>>Nam</option>
                                <option value="Female" <%= "Female".equals(user.getGender()) ? "selected" : "" %>>Nữ</option>
                                <option value="Other" <%= "Other".equals(user.getGender()) ? "selected" : "" %>>Khác</option>
                            </select>
                            <div class="input-icon"><i class="fa fa-venus-mars"></i></div>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="phone">Số điện thoại <span class="required-indicator">*</span></label>
                        <div class="input-group">
                            <input type="tel" 
                                   name="phone" 
                                   id="phone"
                                   class="form-control-modern" 
                                   placeholder="Nhập số điện thoại"
                                   value="<%= user.getPhone() != null ? user.getPhone() : "" %>"
                                   pattern="^(03|04|05|07|08|09)\d{8}$"
                                   required>
                            <div class="input-icon"><i class="fa fa-phone"></i></div>
                        </div>
                        <div class="form-hint">Ví dụ: 0901234567 (10 chữ số)</div>
                    </div>
                    
                    <div class="form-group">
                        <label for="address">Địa chỉ <span class="required-indicator">*</span></label>
                        <div class="input-group">
                            <input type="text" 
                                   name="address" 
                                   id="address"
                                   class="form-control-modern" 
                                   placeholder="Nhập địa chỉ của bạn"
                                   value="<%= user.getAddress() != null ? user.getAddress() : "" %>"
                                   required>
                            <div class="input-icon"><i class="fa fa-map-marker"></i></div>
                        </div>
                        <div class="form-hint">Địa chỉ nơi ở hiện tại</div>
                    </div>
                    
                    <div class="form-group">
                        <label for="sportlevel">Trình độ thể thao</label>
                        <div class="input-group">
                            <input type="text" 
                                   name="sportlevel" 
                                   id="sportlevel"
                                   class="form-control-modern" 
                                   value="<%= user.getSportLevel() != null ? user.getSportLevel() : "Beginner" %>"
                                   readonly>
                            <div class="input-icon"><i class="fa fa-trophy"></i></div>
                        </div>
                        <div class="sport-level-info">
                            <i class="fa fa-info-circle"></i> 
                            Trình độ mặc định là "Beginner". Bạn có thể cập nhật sau khi hoàn thiện hồ sơ.
                        </div>
                    </div>
                    
                    <button type="submit" class="submit-btn" id="submitBtn">
                        <i class="fa fa-check-circle"></i> Hoàn thiện hồ sơ
                    </button>
                </form>
            </div>
        </div>

        <!-- JS here -->
        <script src="js/jquery-1.12.4.min.js"></script>
        <script>
            $(document).ready(function() {
                // Real-time validation with visual feedback
                $('input, select').on('input change', function() {
                    // Add visual feedback
                    if (this.checkValidity()) {
                        $(this).removeClass('invalid').addClass('valid');
                    } else {
                        $(this).removeClass('valid').addClass('invalid');
                    }
                });
                
                // Enhanced form submission
                $('#profileForm').on('submit', function(e) {
                    const submitBtn = $('#submitBtn');
                    submitBtn.addClass('loading');
                    submitBtn.html('<i class="fa fa-spinner fa-spin"></i> Đang xử lý...');
                });
                
                // Add floating label effect
                $('.form-control-modern').on('focus blur', function(e) {
                    const $this = $(this);
                    const $parent = $this.closest('.input-group');
                    
                    if (e.type === 'focus' || $this.val() !== '') {
                        $parent.addClass('focused');
                    } else {
                        $parent.removeClass('focused');
                    }
                });
            });
        </script>
    </body>
</html>
