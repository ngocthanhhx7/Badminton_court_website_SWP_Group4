# Slider Manager - Tính năng Upload File Ảnh

## Tổng quan
Tính năng upload file ảnh cho slider cho phép người dùng tải lên ảnh trực tiếp thay vì chỉ nhập đường dẫn URL.

## Các tính năng mới

### ✅ Upload File Ảnh
- **Chọn file**: Click nút "Chọn ảnh" để browse file từ máy tính
- **Preview**: Xem trước ảnh trước khi upload
- **Validation**: Kiểm tra định dạng file và kích thước
- **Auto-save**: Tự động lưu file vào thư mục `/img/carousel/`

### ✅ Hỗ trợ Định dạng
- **JPG/JPEG**: Định dạng phổ biến
- **PNG**: Hỗ trợ trong suốt
- **GIF**: Hỗ trợ animation
- **WebP**: Định dạng hiện đại

### ✅ Giới hạn File
- **Kích thước tối đa**: 5MB
- **File size threshold**: 1MB
- **Request size tối đa**: 10MB

## Cách sử dụng

### Thêm Slider với Upload Ảnh
1. Click "Thêm mới Slider"
2. Điền thông tin: Tiêu đề, Subtitle, Vị trí
3. **Chọn ảnh**:
   - Click "Chọn ảnh" → Browse file từ máy tính
   - Hoặc nhập đường dẫn ảnh vào ô text
4. Xem preview ảnh
5. Click "Thêm"

### Sửa Slider với Upload Ảnh
1. Click "Sửa" trên slider cần chỉnh sửa
2. Thay đổi thông tin cần thiết
3. **Thay đổi ảnh**:
   - Click "Chọn ảnh" để upload ảnh mới
   - Hoặc thay đổi đường dẫn ảnh
   - Ảnh cũ sẽ tự động bị xóa (nếu không phải URL)
4. Click "Cập nhật"

### Xóa Slider
- Khi xóa slider, file ảnh sẽ tự động bị xóa khỏi server
- Chỉ áp dụng cho file local, không xóa URL external

## Cấu trúc Thư mục
```
web/
├── img/
│   └── carousel/
│       ├── [uuid1].jpg
│       ├── [uuid2].png
│       └── [uuid3].gif
```

## Tên File
- **UUID**: Tên file được tạo bằng UUID để tránh trùng lặp
- **Extension**: Giữ nguyên extension gốc của file
- **Ví dụ**: `550e8400-e29b-41d4-a716-446655440000.jpg`

## Validation

### Kiểm tra File
- **Kích thước**: Tối đa 5MB
- **Định dạng**: Chỉ chấp nhận JPG, JPEG, PNG, GIF, WebP
- **Tên file**: Tự động tạo tên unique

### Xử lý Lỗi
- **File quá lớn**: Hiển thị thông báo lỗi
- **Định dạng không hợp lệ**: Hiển thị thông báo lỗi
- **Upload thất bại**: Hiển thị thông báo lỗi

## Bảo mật

### Validation Server-side
- Kiểm tra file size
- Kiểm tra file extension
- Tạo tên file an toàn

### Xử lý File
- Lưu file vào thư mục riêng biệt
- Không cho phép truy cập trực tiếp vào thư mục upload
- Xóa file cũ khi update/delete

## Troubleshooting

### Lỗi Upload
1. **File quá lớn**: Giảm kích thước file hoặc nén ảnh
2. **Định dạng không hỗ trợ**: Chuyển đổi sang JPG/PNG
3. **Quyền thư mục**: Kiểm tra quyền ghi vào `/img/carousel/`

### Lỗi Preview
1. **JavaScript disabled**: Bật JavaScript trong browser
2. **File không load**: Kiểm tra đường dẫn file

### Lỗi Database
1. **Đường dẫn không lưu**: Kiểm tra quyền ghi database
2. **File không tồn tại**: Kiểm tra thư mục upload

## Cấu hình

### MultipartConfig
```java
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 1024 * 1024 * 5,   // 5 MB
    maxRequestSize = 1024 * 1024 * 10 // 10 MB
)
```

### FileUploadUtil
- **UPLOAD_DIRECTORY**: `img/carousel`
- **MAX_FILE_SIZE**: 5MB
- **ALLOWED_EXTENSIONS**: `.jpg`, `.jpeg`, `.png`, `.gif`, `.webp`

## Best Practices

### Kích thước Ảnh
- **Khuyến nghị**: 1920x1080px hoặc tương tự
- **Tối thiểu**: 800x600px
- **Tối đa**: 5MB

### Định dạng Ảnh
- **WebP**: Tốt nhất cho web (kích thước nhỏ)
- **PNG**: Cho ảnh có trong suốt
- **JPG**: Cho ảnh thông thường

### Performance
- Nén ảnh trước khi upload
- Sử dụng ảnh có kích thước phù hợp
- Tránh upload ảnh quá lớn không cần thiết 