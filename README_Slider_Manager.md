# Slider Manager - Hướng dẫn sử dụng

## Tổng quan
Slider Manager cho phép quản lý các slider/banner trên trang web với các chức năng CRUD đầy đủ.

## Các tính năng đã được thêm

### ✅ Thêm Slider
- Click "Thêm mới Slider" → Modal form → Submit
- Các trường bắt buộc: Tiêu đề, Subtitle, Đường dẫn ảnh nền, Vị trí
- Validation đầy đủ cho tất cả các trường

### ✅ Sửa Slider  
- Click "Sửa" → Modal form với dữ liệu hiện tại → Submit
- Có thể chỉnh sửa tất cả thông tin của slider
- Validation đầy đủ

### ✅ Xóa Slider
- Click "Xóa" → Confirmation dialog → Submit
- Xóa vĩnh viễn slider khỏi database

### ✅ Chuyển trạng thái
- Click badge "Hoạt động"/"Không hoạt động" → Confirmation → Toggle status
- Chuyển đổi giữa hiển thị và ẩn slider

### ✅ Validation & Feedback
- Kiểm tra dữ liệu đầu vào
- Hiển thị thông báo thành công/lỗi
- Auto-hide alerts sau 5 giây

## Cấu trúc Database
Bảng `Sliders` cần có các cột:
- `SliderID` (int, primary key, identity)
- `Title` (nvarchar(255), not null)
- `Subtitle` (nvarchar(500))
- `BackgroundImage` (nvarchar(500), not null)
- `Position` (int, default 1)
- `IsActive` (bit, default 1)
- `CreatedAt` (datetime, default GETDATE())

## Cách sử dụng

### Bước 1: Thiết lập Database
1. Mở SQL Server Management Studio
2. Kết nối đến database `BadmintonHub`
3. Chạy script `check_slider_table.sql` để tạo bảng và dữ liệu mẫu

### Bước 2: Truy cập Slider Manager
1. Đăng nhập với quyền Manager
2. Truy cập `/slider-manager`
3. Xem danh sách slider hiện tại

### Bước 3: Thêm Slider mới
1. Click "Thêm mới Slider"
2. Điền thông tin:
   - **Tiêu đề**: Tiêu đề chính của slider
   - **Subtitle**: Mô tả phụ
   - **Đường dẫn ảnh nền**: URL hoặc đường dẫn tương đối đến ảnh
   - **Vị trí**: Thứ tự hiển thị (số nhỏ hiển thị trước)
3. Click "Thêm"

### Bước 4: Chỉnh sửa Slider
1. Click "Sửa" trên slider cần chỉnh sửa
2. Thay đổi thông tin trong modal
3. Click "Cập nhật"

### Bước 5: Ẩn/Hiện Slider
1. Click vào badge trạng thái
2. Xác nhận trong dialog
3. Trạng thái sẽ được chuyển đổi

### Bước 6: Xóa Slider
1. Click "Xóa" trên slider cần xóa
2. Xác nhận trong dialog
3. Slider sẽ bị xóa vĩnh viễn

## Định dạng ảnh nền
- **Đường dẫn tương đối**: `/img/carousel/banner_1.jpg`
- **URL tuyệt đối**: `https://example.com/image.jpg`
- **Đường dẫn local**: `C:\path\to\image.jpg` (không khuyến khích)

## Lưu ý quan trọng
1. **Vị trí**: Số nhỏ hơn sẽ hiển thị trước
2. **Trạng thái**: Chỉ slider có `IsActive = 1` mới hiển thị trên frontend
3. **Ảnh nền**: Đảm bảo đường dẫn ảnh chính xác và ảnh tồn tại
4. **Quyền truy cập**: Chỉ Manager mới có thể truy cập trang này

## Troubleshooting
Nếu gặp lỗi:
1. Kiểm tra console logs trong browser
2. Kiểm tra server logs
3. Đảm bảo database connection hoạt động
4. Kiểm tra quyền truy cập database
5. Đảm bảo bảng `Sliders` đã được tạo đúng cấu trúc

## API Endpoints
- `GET /slider-manager`: Hiển thị trang quản lý
- `POST /slider-manager?action=add`: Thêm slider mới
- `POST /slider-manager?action=edit`: Cập nhật slider
- `POST /slider-manager?action=delete`: Xóa slider
- `POST /slider-manager?action=toggleStatus`: Chuyển đổi trạng thái 