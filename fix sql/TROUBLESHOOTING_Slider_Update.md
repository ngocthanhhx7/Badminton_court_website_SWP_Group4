# Troubleshooting - Lỗi Cập nhật Slider

## Vấn đề
Tính năng cập nhật slider không hoạt động.

## Các bước kiểm tra và sửa lỗi

### Bước 1: Kiểm tra Database
1. Chạy script `debug_slider_data.sql` để kiểm tra:
   - Bảng Sliders có tồn tại không
   - Cấu trúc bảng có đúng không
   - Dữ liệu hiện tại
   - Có NULL values không

### Bước 2: Kiểm tra Console Logs
1. Mở Developer Tools trong browser (F12)
2. Chuyển sang tab Console
3. Click nút "Sửa" trên một slider
4. Kiểm tra các log messages:
   - `DEBUG: Edit button clicked`
   - `DEBUG: sliderId: [value]`
   - `DEBUG: title: [value]`
   - `DEBUG: subtitle: [value]`
   - `DEBUG: backgroundImage: [value]`
   - `DEBUG: position: [value]`
   - `DEBUG: Form values set, opening modal`
   - `DEBUG: Form submitted: [form data]`

### Bước 3: Kiểm tra Server Logs
1. Kiểm tra console của server/IDE
2. Tìm các log messages:
   - `DEBUG: Edit slider - sliderID: [value]`
   - `DEBUG: Edit slider - title: [value]`
   - `DEBUG: Edit slider - subtitle: [value]`
   - `DEBUG: Edit slider - backgroundImage: [value]`
   - `DEBUG: Edit slider - position: [value]`
   - `DEBUG: Parsed sliderID: [value], position: [value]`
   - `DEBUG: Current slider found, IsActive: [value]`
   - `DEBUG: About to update slider with ID: [value]`
   - `DEBUG: Update result: [true/false]`

### Bước 4: Kiểm tra DAO Logs
Tìm các log messages từ DAO:
- `DEBUG: DAO - Starting update for sliderID: [value]`
- `DEBUG: DAO - Title: [value]`
- `DEBUG: DAO - Subtitle: [value]`
- `DEBUG: DAO - BackgroundImage: [value]`
- `DEBUG: DAO - Position: [value]`
- `DEBUG: DAO - IsActive: [value]`
- `DEBUG: DAO - Executing SQL: [SQL query]`
- `DEBUG: DAO - Parameters: [parameter values]`
- `DEBUG: DAO - Rows affected: [number]`
- `DEBUG: DAO - Exception occurred: [error message]`

## Các vấn đề có thể gặp

### 1. Vấn đề với Data Attributes
**Triệu chứng**: Console logs hiển thị `undefined` cho các giá trị
**Nguyên nhân**: Ký tự đặc biệt trong dữ liệu gây lỗi JavaScript
**Giải pháp**: Escape ký tự đặc biệt trong JSP

### 2. Vấn đề với Database Connection
**Triệu chứng**: Exception trong DAO logs
**Nguyên nhân**: Không kết nối được database
**Giải pháp**: Kiểm tra cấu hình database

### 3. Vấn đề với SQL Query
**Triệu chứng**: Rows affected = 0
**Nguyên nhân**: SliderID không tồn tại hoặc query sai
**Giải pháp**: Kiểm tra dữ liệu và SQL query

### 4. Vấn đề với NULL Values
**Triệu chứng**: NullPointerException
**Nguyên nhân**: Dữ liệu NULL trong database
**Giải pháp**: Cập nhật dữ liệu NULL

## Cách sửa lỗi

### Sửa lỗi Data Attributes
Nếu có vấn đề với ký tự đặc biệt, thay đổi JSP:
```jsp
<button class="btn btn-warning btn-sm edit-slider-btn" 
        data-slider-id="${slider.sliderID}" 
        data-title="${fn:escapeXml(slider.title)}" 
        data-subtitle="${fn:escapeXml(slider.subtitle)}"
        data-background-image="${fn:escapeXml(slider.backgroundImage)}"
        data-position="${slider.position}">Sửa</button>
```

### Sửa lỗi Database
Chạy script để cập nhật dữ liệu NULL:
```sql
UPDATE Sliders SET IsActive = 1 WHERE IsActive IS NULL;
UPDATE Sliders SET Title = 'Default Title' WHERE Title IS NULL;
UPDATE Sliders SET BackgroundImage = '/img/default.jpg' WHERE BackgroundImage IS NULL;
```

### Kiểm tra Quyền Database
Đảm bảo user có quyền UPDATE trên bảng Sliders:
```sql
GRANT UPDATE ON Sliders TO [username];
```

## Test Cases
1. **Test với dữ liệu đơn giản**: Chỉ thay đổi title
2. **Test với dữ liệu có ký tự đặc biệt**: Title có dấu, ký tự Unicode
3. **Test với đường dẫn ảnh dài**: URL dài
4. **Test với position = 0**: Giá trị edge case

## Reporting
Khi báo cáo lỗi, cung cấp:
1. Console logs từ browser
2. Server logs
3. Database query results
4. Các bước để reproduce lỗi
5. Dữ liệu slider đang test 