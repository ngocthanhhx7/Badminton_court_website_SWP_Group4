# Hướng dẫn sửa lỗi NullPointerException khi đăng ký

## Vấn đề
Lỗi: `Cannot invoke "String.trim()" because the return value of "jakarta.servlet.http.HttpServletRequest.getParameter(String)" is null`

## Nguyên nhân
- Code đang cố gắng gọi `.trim()` trên giá trị `null` từ `request.getParameter()`
- Không có xử lý null an toàn trước khi gọi `.trim()`
- Lỗi cú pháp trong `RegistrationController.java`

## Giải pháp đã thực hiện

### 1. Sửa lỗi trong RegistrationController.java

**Trước:**
```java
String username = request.getParameter("username");
String email = request.getParameter("email");
String password = request.getParameter("password");
String role = request.getParameter("role");

// Lỗi: gọi .trim() trên giá trị có thể null
if (username == null || username.trim().isEmpty()
    || email == null || email.trim().isEmpty()
    || password == null || password.trim().isEmpty()
    || role == null || role.trim().isEmpty()) {
    // ...
}
```

**Sau:**
```java
// Lấy các tham số từ form với xử lý null an toàn
String username = request.getParameter("username");
String email = request.getParameter("email");
String password = request.getParameter("password");
String role = request.getParameter("role");

// Xử lý null values
username = (username != null) ? username.trim() : "";
email = (email != null) ? email.trim() : "";
password = (password != null) ? password.trim() : "";
role = (role != null) ? role.trim() : "Customer"; // Default role

// Validation an toàn
if (username.isEmpty() || email.isEmpty() || password.isEmpty()) {
    // ...
}
```

### 2. Sửa lỗi trong RegisterController.java

**Trước:**
```java
String username = request.getParameter("username").trim();
String email = request.getParameter("email").trim();
String rawPwd = request.getParameter("password").trim();
```

**Sau:**
```java
// Lấy các tham số từ form với xử lý null an toàn
String username = request.getParameter("username");
String email = request.getParameter("email");
String rawPwd = request.getParameter("password");

// Xử lý null values
username = (username != null) ? username.trim() : "";
email = (email != null) ? email.trim() : "";
rawPwd = (rawPwd != null) ? rawPwd.trim() : "";
```

### 3. Cải thiện giao diện register.jsp

**Thêm hiển thị thông báo lỗi:**
```jsp
<!-- Hiển thị thông báo lỗi -->
<% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger" role="alert">
        <%= request.getAttribute("error") %>
    </div>
<% } %>

<!-- Hiển thị thông báo thành công -->
<% if (request.getAttribute("message") != null) { %>
    <div class="alert alert-success" role="alert">
        <%= request.getAttribute("message") %>
    </div>
<% } %>
```

## Các thay đổi chính

### 1. Xử lý null an toàn
- Kiểm tra null trước khi gọi `.trim()`
- Sử dụng toán tử ternary để xử lý null
- Đặt giá trị mặc định cho các trường không bắt buộc

### 2. Cải thiện validation
- Loại bỏ kiểm tra null không cần thiết sau khi đã xử lý
- Thông báo lỗi rõ ràng hơn
- Giữ lại giá trị đã nhập khi có lỗi

### 3. Cải thiện UX
- Hiển thị thông báo lỗi/thành công với Bootstrap alert
- Giữ lại dữ liệu đã nhập khi form bị lỗi
- Chuyển hướng phù hợp sau khi đăng ký thành công

## Kiểm tra sau khi sửa

### 1. Test truy cập trang register
- Truy cập `http://localhost:8080/your-app/register.jsp`
- Không còn lỗi NullPointerException

### 2. Test đăng ký với dữ liệu hợp lệ
- Username: `testuser123`
- Email: `test@example.com`
- Password: `123456`
- Kết quả: Đăng ký thành công

### 3. Test đăng ký với dữ liệu không hợp lệ
- Để trống các trường bắt buộc
- Kết quả: Hiển thị thông báo lỗi rõ ràng

### 4. Test đăng ký với username/email đã tồn tại
- Kết quả: Hiển thị thông báo "Username hoặc Email đã tồn tại"

## Lưu ý quan trọng

### 1. Luôn xử lý null
```java
// Đúng
String param = request.getParameter("param");
param = (param != null) ? param.trim() : "";

// Sai
String param = request.getParameter("param").trim(); // Có thể gây NullPointerException
```

### 2. Validation an toàn
```java
// Đúng
if (param.isEmpty()) {
    // Xử lý lỗi
}

// Sai
if (param == null || param.trim().isEmpty()) {
    // Không cần thiết sau khi đã xử lý null
}
```

### 3. Giữ lại dữ liệu khi có lỗi
```java
request.setAttribute("username", username);
request.setAttribute("email", email);
```

## Nếu vẫn gặp lỗi

### 1. Kiểm tra log
- Xem log Tomcat/GlassFish
- Xem log ứng dụng Java

### 2. Debug code
- Thêm `System.out.println()` để debug
- Kiểm tra giá trị các tham số

### 3. Kiểm tra mapping
- Đảm bảo URL mapping đúng
- Kiểm tra web.xml

## Liên hệ hỗ trợ

Nếu vẫn gặp vấn đề, hãy cung cấp:
1. Log lỗi chi tiết
2. URL đang truy cập
3. Cấu hình web.xml
4. Phiên bản Java và Servlet container 