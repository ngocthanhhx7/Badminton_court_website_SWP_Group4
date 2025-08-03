# Chatbot Quick Test Guide

## 🚀 Cách test nhanh chatbot

### 1. Kiểm tra database trước
```sql
-- Chạy script này trong SQL Server Management Studio
USE BadmintonHub;
-- Copy và paste toàn bộ nội dung file: fix sql/chatbot_database_check.sql
```

### 2. Test API cơ bản
Truy cập: `http://localhost:8080/SWP_Project/chatbot-simple-test.html`

Trang này sẽ:
- ✅ Tự động kiểm tra API availability
- ✅ Test database connection
- ✅ Test get courts
- ✅ Test get services

### 3. Test chatbot thực tế
Truy cập: `http://localhost:8080/SWP_Project/chat-gemini.jsp`

Thử các câu hỏi:
- "test connection"
- "cho tôi xem danh sách sân"
- "kiểm tra lịch trống hôm nay"
- "cho tôi xem các dịch vụ"

### 4. Test API chi tiết
Truy cập: `http://localhost:8080/SWP_Project/chatbot-test.html`

Trang này có đầy đủ các test case.

## 🔧 Nếu gặp lỗi 404

### Kiểm tra web.xml
Đảm bảo file `web/WEB-INF/web.xml` có:
```xml
<servlet>
    <servlet-name>ChatbotController</servlet-name>
    <servlet-class>controller.user.ChatbotController</servlet-class>
</servlet>
<servlet-mapping>
    <servlet-name>ChatbotController</servlet-name>
    <url-pattern>/chatbot-api</url-pattern>
</servlet-mapping>
```

### Kiểm tra URL
- API URL phải là: `/SWP_Project/chatbot-api`
- Không phải: `/chatbot-api`

### Rebuild và redeploy
1. Clean project
2. Build project
3. Deploy lại

## 🐛 Debug

### Mở Developer Tools (F12)
- Tab Console: Xem JavaScript errors
- Tab Network: Xem API calls

### Kiểm tra server logs
- Xem console của server
- Tìm logs của ChatbotController

### Test từng bước
1. Test database connection trước
2. Test từng API riêng lẻ
3. Test chatbot UI

## 📞 Nếu vẫn lỗi

1. Chụp screenshot lỗi
2. Copy console logs
3. Ghi lại URL đang test
4. Liên hệ: Hotline 0981944060

## ✅ Checklist hoàn thành

- [ ] Database có dữ liệu (chạy script check)
- [ ] ChatbotController được đăng ký trong web.xml
- [ ] URL đúng: `/SWP_Project/chatbot-api`
- [ ] Project được rebuild và redeploy
- [ ] Test API cơ bản thành công
- [ ] Test chatbot UI thành công 