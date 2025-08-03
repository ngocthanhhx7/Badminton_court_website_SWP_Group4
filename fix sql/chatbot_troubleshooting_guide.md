# Chatbot Troubleshooting Guide

## Tổng quan
Hướng dẫn này giúp khắc phục các vấn đề thường gặp với chatbot AI của BadmintonHub.

## Các vấn đề thường gặp

### 1. Lỗi kết nối database

**Triệu chứng:**
- Chatbot báo lỗi "Database connection failed"
- Không thể lấy thông tin sân, dịch vụ, lịch trống

**Nguyên nhân:**
- SQL Server không chạy
- Thông tin kết nối database sai
- Database BadmintonHub không tồn tại
- User 'sa' không có quyền truy cập

**Cách khắc phục:**

#### Bước 1: Kiểm tra SQL Server
```bash
# Kiểm tra SQL Server có đang chạy không
# Windows: Mở Services và tìm "SQL Server (MSSQLSERVER)"
# Hoặc chạy lệnh:
sqlcmd -S localhost -U sa -P 123
```

#### Bước 2: Kiểm tra database
```sql
-- Kết nối vào SQL Server và chạy:
SELECT name FROM sys.databases WHERE name = 'BadmintonHub';
```

#### Bước 3: Kiểm tra thông tin kết nối
Kiểm tra file `src/java/utils/DBUtils.java`:
```java
private final static String serverName = "localhost";
private final static String dbName = "BadmintonHub";
private final static String portNumber = "1433";
private final static String userID = "sa";
private final static String password = "123";
```

#### Bước 4: Chạy script kiểm tra database
Chạy file `fix sql/chatbot_database_check.sql` để:
- Kiểm tra các bảng cần thiết
- Thêm dữ liệu mẫu nếu cần
- Kiểm tra cấu trúc bảng

### 2. Lỗi API không phản hồi

**Triệu chứng:**
- Chatbot không trả lời
- Console browser hiển thị lỗi 404 hoặc 500
- Network tab không thấy request đến `/chatbot-api`

**Nguyên nhân:**
- Servlet ChatbotController chưa được deploy
- URL mapping sai
- Lỗi CORS

**Cách khắc phục:**

#### Bước 1: Kiểm tra deployment
- Đảm bảo project đã được build và deploy
- Kiểm tra file `web/WEB-INF/web.xml` có mapping đúng không

#### Bước 2: Kiểm tra URL
- Mở Developer Tools (F12)
- Vào tab Network
- Gửi tin nhắn trong chatbot
- Kiểm tra request đến `/chatbot-api`

#### Bước 3: Kiểm tra CORS
- Đảm bảo ChatbotController có CORS headers
- Kiểm tra console browser có lỗi CORS không

### 3. Lỗi Gemini API

**Triệu chứng:**
- Chatbot không trả lời thông minh
- Lỗi "API key invalid" hoặc "quota exceeded"

**Nguyên nhân:**
- API key Gemini không hợp lệ
- Hết quota API
- Network không thể kết nối đến Google API

**Cách khắc phục:**

#### Bước 1: Kiểm tra API key
Kiểm tra file `web/js/script-chat-gemini.js`:
```javascript
const API_KEY = "AIzaSyD1ClTMuvLuwlugJpmAH1tzGe_pnzSd3Lw";
```

#### Bước 2: Kiểm tra quota
- Vào Google AI Studio
- Kiểm tra quota còn lại
- Nếu hết, tạo API key mới

#### Bước 3: Test API key
```bash
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{"contents":[{"parts":[{"text":"Hello"}]}]}' \
  "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=YOUR_API_KEY"
```

### 4. Lỗi hiển thị dữ liệu

**Triệu chứng:**
- Chatbot trả lời nhưng không hiển thị thông tin sân/dịch vụ
- Dữ liệu hiển thị sai format

**Nguyên nhân:**
- Database không có dữ liệu
- Lỗi parsing JSON
- CSS không load đúng

**Cách khắc phục:**

#### Bước 1: Kiểm tra dữ liệu database
```sql
-- Kiểm tra bảng Courts
SELECT COUNT(*) FROM Courts;

-- Kiểm tra bảng Services
SELECT COUNT(*) FROM services;

-- Kiểm tra bảng CourtSchedules
SELECT COUNT(*) FROM CourtSchedules;
```

#### Bước 2: Chạy script thêm dữ liệu mẫu
```sql
-- Chạy file chatbot_database_check.sql
-- Script sẽ tự động thêm dữ liệu mẫu nếu cần
```

#### Bước 3: Kiểm tra console browser
- Mở Developer Tools (F12)
- Vào tab Console
- Kiểm tra có lỗi JavaScript không

### 5. Lỗi file upload

**Triệu chứng:**
- Không thể upload ảnh
- Lỗi "File too large" hoặc "Invalid file type"

**Nguyên nhân:**
- File quá lớn
- File type không được hỗ trợ
- Lỗi JavaScript

**Cách khắc phục:**

#### Bước 1: Kiểm tra file type
Chỉ hỗ trợ: JPEG, PNG, GIF, WEBP

#### Bước 2: Kiểm tra file size
Giới hạn: 5MB

#### Bước 3: Kiểm tra JavaScript
- Mở Developer Tools (F12)
- Vào tab Console
- Kiểm tra lỗi khi upload file

## Các bước kiểm tra tổng quát

### 1. Kiểm tra database
```sql
-- Chạy script kiểm tra
USE BadmintonHub;
-- Chạy nội dung file chatbot_database_check.sql
```

### 2. Kiểm tra server logs
- Kiểm tra console của server
- Tìm các log của ChatbotController
- Kiểm tra lỗi database connection

### 3. Kiểm tra browser
- Mở Developer Tools (F12)
- Vào tab Console
- Vào tab Network
- Gửi tin nhắn test và theo dõi

### 4. Test từng chức năng
1. **Test kết nối database:**
   - Gửi tin nhắn: "test connection"

2. **Test thông tin sân:**
   - Gửi tin nhắn: "cho tôi xem danh sách sân"

3. **Test thông tin dịch vụ:**
   - Gửi tin nhắn: "cho tôi xem các dịch vụ"

4. **Test lịch trống:**
   - Gửi tin nhắn: "kiểm tra lịch trống hôm nay"

## Log và Debug

### 1. Server Logs
ChatbotController có logging chi tiết:
```java
LOGGER.info("Getting all courts...");
LOGGER.severe("Database connection test failed");
```

### 2. Browser Console
JavaScript có console.log để debug:
```javascript
console.log("Calling chatbot API with action:", action);
console.log("Chatbot API response:", result);
```

### 3. Network Tab
- Kiểm tra request/response của `/chatbot-api`
- Kiểm tra status code
- Kiểm tra response body

## Liên hệ hỗ trợ

Nếu vẫn gặp vấn đề:
1. Chụp screenshot lỗi
2. Copy log từ console
3. Ghi lại các bước đã thực hiện
4. Liên hệ: Hotline 0981944060

## Cập nhật

- **Version 1.0**: Hướng dẫn cơ bản
- **Version 1.1**: Thêm troubleshooting cho CORS và API errors
- **Version 1.2**: Thêm script kiểm tra database tự động 