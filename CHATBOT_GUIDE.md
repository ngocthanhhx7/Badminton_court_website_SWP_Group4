# BadmintonHub Chatbot Guide

## Tổng quan
Chatbot AI của BadmintonHub được tích hợp với hệ thống đặt sân cầu lông, có thể trả lời các câu hỏi liên quan đến:
- Tìm kiếm slot còn trống
- Hướng dẫn đặt sân
- Thông tin giá cả
- Liên hệ hỗ trợ

## Cách sử dụng

### 1. Tìm kiếm lịch trống
**Các câu hỏi mẫu:**
- "Lịch trống hôm nay"
- "Slot còn trống ngày mai"
- "Sân nào còn trống ngày 25/12/2024"
- "Có slot trống không?"

**Chatbot sẽ:**
- Tự động phát hiện ngày từ câu hỏi
- Gọi API để lấy dữ liệu thực tế từ database
- Hiển thị danh sách các sân còn trống và khung giờ

### 2. Hướng dẫn đặt sân
**Các câu hỏi mẫu:**
- "Cách đặt sân"
- "Hướng dẫn booking"
- "Làm sao để đặt sân"

**Chatbot sẽ:**
- Hiển thị các bước đặt sân chi tiết
- Thông tin giờ hoạt động
- Chính sách hủy đặt sân
- Thông tin liên hệ

### 3. Thông tin giá cả
**Các câu hỏi mẫu:**
- "Giá sân indoor"
- "Phí đặt sân outdoor"
- "Bảng giá"

### 4. Thông tin liên hệ
**Các câu hỏi mẫu:**
- "Liên hệ"
- "Hotline"
- "Email"

## Cấu trúc hệ thống

### Backend (Java)
- `ChatbotController.java`: Xử lý API requests từ chatbot
- `CourtScheduleDAO.java`: Truy vấn dữ liệu lịch trống
- Endpoint: `/chatbot-api`

### Frontend (JavaScript)
- `script-chat-gemini.js`: Logic chatbot và giao tiếp với API
- `chat-gemini.jsp`: Giao diện chatbot
- `style-chat-gemini.css`: Styling

### API Endpoints
1. `getAvailableSchedules`: Lấy danh sách slot trống theo ngày
2. `getSchedulesByDate`: Lấy lịch trống chi tiết theo ngày
3. `getSchedulesByCourt`: Lấy lịch trống của sân cụ thể
4. `getBookingInfo`: Lấy thông tin hướng dẫn đặt sân

## Tính năng nổi bật

### 1. Phát hiện ý định người dùng
- Tự động nhận diện các từ khóa liên quan đến đặt sân
- Phát hiện ngày tháng từ câu hỏi
- Phân loại loại câu hỏi (lịch trống, hướng dẫn, giá cả, liên hệ)

### 2. Tích hợp dữ liệu thực tế
- Kết nối trực tiếp với database
- Hiển thị thông tin lịch trống chính xác
- Cập nhật thông tin theo thời gian thực

### 3. Giao diện thân thiện
- Thiết kế responsive
- Animation mượt mà
- Hỗ trợ emoji và file đính kèm
- Loading indicator

## Cách triển khai

### 1. Cài đặt dependencies
```xml
<!-- Trong pom.xml hoặc build.xml -->
<dependency>
    <groupId>com.google.code.gson</groupId>
    <artifactId>gson</artifactId>
    <version>2.8.2</version>
</dependency>
```

### 2. Cấu hình database
Đảm bảo các bảng sau có sẵn:
- `CourtSchedules`: Lịch sân
- `Courts`: Thông tin sân
- `CourtRates`: Bảng giá

### 3. Deploy
1. Build project
2. Deploy lên server
3. Truy cập `/chat-gemini.jsp` để test

## Troubleshooting

### Lỗi thường gặp
1. **API không phản hồi**: Kiểm tra kết nối database
2. **Chatbot không hiển thị**: Kiểm tra CSS và JavaScript
3. **Dữ liệu không chính xác**: Kiểm tra logic trong `CourtScheduleDAO`

### Debug
- Mở Developer Tools (F12)
- Kiểm tra Console để xem lỗi JavaScript
- Kiểm tra Network tab để xem API calls

## Tùy chỉnh

### Thêm tính năng mới
1. Thêm endpoint trong `ChatbotController`
2. Cập nhật logic phát hiện ý định trong JavaScript
3. Thêm case xử lý trong `generateBotResponse`

### Thay đổi giao diện
- Chỉnh sửa `style-chat-gemini.css`
- Cập nhật HTML trong `chat-gemini.jsp`

### Thay đổi AI model
- Cập nhật `API_KEY` và `API_URL` trong JavaScript
- Điều chỉnh prompt trong `websiteContext`

## Bảo mật
- API key được lưu trong frontend (cần bảo mật hơn trong production)
- Validate input từ người dùng
- Sanitize output trước khi hiển thị
- Rate limiting cho API calls

## Performance
- Cache dữ liệu lịch trống
- Lazy loading cho emoji picker
- Optimize database queries
- Minify CSS/JS files 