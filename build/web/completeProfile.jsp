<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="models.UserDTO" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complete Profile</title>
    <style>
        body {
            background: url('https://via.placeholder.com/1500x1000.png?text=Background') no-repeat center center fixed;
            background-size: cover;
            font-family: Arial, sans-serif;
            color: white;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            margin: 0;
        }
        .container {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        .form-box {
            width: 100%;
            max-width: 400px;
            background: rgba(0, 0, 0, 0.6);
            padding: 30px;
            border-radius: 10px;
        }
        .form-box h2 {
            font-size: 1.8rem;
            margin-bottom: 15px;
            text-align: center;
        }
        .form-box input,
        .form-box select {
            width: 100%;
            padding: 10px;
            margin: 8px 0;
            border: none;
            border-radius: 25px;
        }
        .form-box button {
            width: 100%;
            padding: 12px;
            margin-top: 15px;
            border: none;
            border-radius: 25px;
            background: #d1d5db;
            cursor: pointer;
            font-size: 1rem;
        }
        .form-box button:hover {
            background: #b1b5b9;
        }
        .error {
            color: #900;
            background: #fff;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 10px;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="form-box">
            <h2>Hoàn thiện thông tin cá nhân</h2>
            <c:if test="${not empty message}">
                <div class="error">${message}</div>
            </c:if>
            <form action="UpdateProfileServlet" method="post">
                <input type="text" name="fullname" placeholder="Họ và tên" required />
                <input type="date" name="dob" placeholder="Ngày sinh" required />
                <select name="gender" required>
                    <option value="">-- Chọn giới tính --</option>
                    <option value="Male">Nam</option>
                    <option value="Female">Nữ</option>
                    <option value="Other">Khác</option>
                </select>
                <input type="text" name="phone" placeholder="Số điện thoại" required />
                <input type="text" name="address" placeholder="Địa chỉ" required />
<input type="text" name="sportlevel" placeholder="Nghe Bài Trình Chưa" required />
                <button type="submit">Lưu thông tin</button>
            </form>
        </div>
    </div>
</body>
</html>
