# Contact Manager - Hướng dẫn sửa lỗi Toggle Status

## Vấn đề
Chức năng chuyển trạng thái (toggle status) của contact manager không hoạt động.

## Nguyên nhân có thể
1. Cột `IsActive` không tồn tại trong bảng `ContactInfo`
2. Cấu hình database không đúng
3. Lỗi trong code

## Cách khắc phục

### Bước 1: Kiểm tra và sửa database
1. Mở SQL Server Management Studio
2. Kết nối đến database `BadmintonHub`
3. Chạy script `check_contact_table.sql` để kiểm tra và thêm cột `IsActive` nếu cần

### Bước 2: Kiểm tra cấu trúc bảng
Chạy lệnh SQL sau để xem cấu trúc bảng:
```sql
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'ContactInfo'
ORDER BY ORDINAL_POSITION;
```

### Bước 3: Kiểm tra dữ liệu
Chạy lệnh SQL sau để xem dữ liệu hiện tại:
```sql
SELECT * FROM ContactInfo;
```

### Bước 4: Test chức năng
1. Truy cập trang contact manager
2. Click vào badge "Hiện" hoặc "Ẩn" để test chức năng toggle
3. Kiểm tra console logs nếu có lỗi

## Các tính năng đã được thêm

### ✅ Thêm Contact
- Click "Thêm mới Contact" → Modal form → Submit

### ✅ Sửa Contact  
- Click "Sửa" → Modal form với dữ liệu hiện tại → Submit

### ✅ Xóa Contact
- Click "Xóa" → Confirmation → Submit

### ✅ Chuyển trạng thái
- Click badge "Hiện"/"Ẩn" → Confirmation → Toggle status

### ✅ Validation & Feedback
- Kiểm tra dữ liệu đầu vào
- Hiển thị thông báo thành công/lỗi
- Auto-hide alerts sau 5 giây

## Cấu trúc Database
Bảng `ContactInfo` cần có các cột:
- `ContactID` (int, primary key)
- `Message` (varchar/text)
- `PhoneNumber` (varchar)
- `IsActive` (bit, default 1)

## Troubleshooting
Nếu vẫn không hoạt động:
1. Kiểm tra console logs trong browser
2. Kiểm tra server logs
3. Đảm bảo database connection hoạt động
4. Kiểm tra quyền truy cập database 