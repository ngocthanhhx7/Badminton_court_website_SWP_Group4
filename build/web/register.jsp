<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Đăng ký tài khoản</title>
        <style>
            /* Reset cơ bản */
            * {
                box-sizing: border-box;
            }
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: #f4f7f8;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                margin: 0;
            }
            .container {
                background: white;
                padding: 30px 40px;
                border-radius: 8px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
                max-width: 450px;
                width: 100%;
            }
            h2 {
                text-align: center;
                margin-bottom: 25px;
                color: #333;
            }
            form label {
                display: block;
                margin-bottom: 6px;
                font-weight: 600;
                color: #555;
            }
            form input[type="text"],
            form input[type="email"],
            form input[type="password"],
            form input[type="date"],
            form select {
                width: 100%;
                padding: 10px 12px;
                margin-bottom: 18px;
                border: 1.5px solid #ccc;
                border-radius: 5px;
                font-size: 15px;
                transition: border-color 0.3s ease;
            }
            form input[type="text"]:focus,
            form input[type="email"]:focus,
            form input[type="password"]:focus,
            form input[type="date"]:focus,
            form select:focus {
                border-color: #007BFF;
                outline: none;
            }
            form input[type="submit"] {
                width: 100%;
                background-color: #007BFF;
                color: white;
                padding: 12px;
                font-size: 17px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                font-weight: 700;
                transition: background-color 0.3s ease;
            }
            form input[type="submit"]:hover {
                background-color: #0056b3;
            }
            .message {
                text-align: center;
                margin-top: 15px;
                font-weight: 600;
                color: #d9534f; /* đỏ cho lỗi */
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>Đăng ký tài khoản mới</h2>
            <form action="RegisterServlet" method="post">
                <label for="username">Username*:</label>
                <input type="text" id="username" name="username" required>

                <label for="email">Email*:</label>
                <input type="email" id="email" name="email" required>

                <label for="password">Password*:</label>
                <input type="password" id="password" name="password" required>

                <label for="fullname">Full Name:</label>
                <input type="text" id="fullname" name="fullname">

                <label for="dob">Date of Birth:</label>
                <input type="date" id="dob" name="dob">

                <label for="gender">Gender:</label>
                <select id="gender" name="gender">
                    <option value="">--Chọn--</option>
                    <option value="Male">Nam</option>
                    <option value="Female">Nữ</option>
                    <option value="Other">Khác</option>
                </select>

                <label for="phone">Phone:</label>
                <input type="text" id="phone" name="phone">

                <label for="address">Address:</label>
                <input type="text" id="address" name="address">

                <label for="sportlevel">Sport Level:</label>
                <input type="text" id="sportlevel" name="sportlevel">

                <input type="submit" value="Đăng ký">
            </form>

            <% String message = (String) request.getAttribute("message");
               if (message != null) {
            %>
            <p class="message"><%= message %></p>
            <% } %>
        </div>
    </body>
</html>
