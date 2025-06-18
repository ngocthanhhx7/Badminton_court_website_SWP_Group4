# Hướng dẫn sửa lỗi đăng ký - UNIQUE KEY constraint

## Vấn đề
Lỗi: `Violation of UNIQUE KEY constraint 'UQ__Users__5C7E359E6A98716B'. Cannot insert duplicate key in object 'dbo.Users'. The duplicate key value is ().`

## Nguyên nhân
- Ràng buộc UNIQUE KEY được tạo tự động bởi SQL Server
- Có thể áp dụng cho cột có giá trị NULL hoặc rỗng
- Cấu trúc bảng Users không khớp với code Java

## Giải pháp

### Bước 1: Kiểm tra cấu trúc hiện tại
Chạy script `check_users_table_structure.sql` để kiểm tra:
```sql
-- Mở SQL Server Management Studio
-- Kết nối đến database BadmintonHub
-- Chạy file: check_users_table_structure.sql
```

### Bước 2: Sửa lỗi UNIQUE KEY constraint
Chạy script `fix_users_unique_constraint.sql`:
```sql
-- Chạy file: fix_users_unique_constraint.sql
-- Script này sẽ:
-- 1. Xóa ràng buộc UNIQUE KEY gây lỗi
-- 2. Dọn dẹp dữ liệu NULL/empty
-- 3. Tạo lại các ràng buộc UNIQUE hợp lý
```

### Bước 3: Tạo lại bảng Users (nếu cần)
Nếu vẫn gặp lỗi, chạy script `recreate_users_table.sql`:
```sql
-- Chạy file: recreate_users_table.sql
-- Script này sẽ:
-- 1. Backup dữ liệu hiện tại
-- 2. Xóa bảng Users cũ
-- 3. Tạo lại bảng với cấu trúc đúng
-- 4. Khôi phục dữ liệu
-- 5. Tạo các ràng buộc UNIQUE hợp lý
```

## Cấu trúc bảng Users đúng

```sql
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    Username NVARCHAR(50) NOT NULL,
    Password NVARCHAR(255) NOT NULL,
    Email NVARCHAR(100) NOT NULL,
    FullName NVARCHAR(100) NULL,
    Dob DATE NULL,
    Gender NVARCHAR(10) NULL,
    Phone NVARCHAR(15) NULL,
    Address NVARCHAR(255) NULL,
    SportLevel NVARCHAR(50) NULL,
    Role NVARCHAR(20) NOT NULL DEFAULT 'Customer',
    Status NVARCHAR(20) NOT NULL DEFAULT 'Active',
    CreatedBy INT NULL,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    UpdatedAt DATETIME NOT NULL DEFAULT GETDATE()
);
```

## Ràng buộc UNIQUE hợp lý

```sql
-- Ràng buộc UNIQUE cho Username
ALTER TABLE Users ADD CONSTRAINT UQ_Users_Username UNIQUE (Username);

-- Ràng buộc UNIQUE cho Email
ALTER TABLE Users ADD CONSTRAINT UQ_Users_Email UNIQUE (Email);

-- Index UNIQUE cho Phone (chỉ áp dụng cho giá trị không NULL)
CREATE UNIQUE INDEX IX_Users_Phone_Unique ON Users(Phone) WHERE Phone IS NOT NULL;
```

## Kiểm tra sau khi sửa

### 1. Kiểm tra cấu trúc bảng
```sql
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Users'
ORDER BY ORDINAL_POSITION;
```

### 2. Kiểm tra các ràng buộc
```sql
SELECT 
    c.CONSTRAINT_NAME,
    c.CONSTRAINT_TYPE,
    cc.COLUMN_NAME
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS c
INNER JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE cc 
    ON c.CONSTRAINT_NAME = cc.CONSTRAINT_NAME
WHERE c.TABLE_NAME = 'Users'
ORDER BY c.CONSTRAINT_TYPE, c.CONSTRAINT_NAME;
```

### 3. Kiểm tra dữ liệu
```sql
SELECT TOP 5 
    UserID,
    Username,
    Email,
    Role,
    Status,
    CreatedAt
FROM Users
ORDER BY UserID;
```

## Lưu ý quan trọng

### 1. Backup dữ liệu
- Luôn backup dữ liệu trước khi thực hiện thay đổi
- Script `recreate_users_table.sql` sẽ tự động backup

### 2. Kiểm tra code Java
Đảm bảo code Java sử dụng đúng tên cột:
- `Username` (không phải `username`)
- `Email` (không phải `email`)
- `Password` (không phải `password`)

### 3. Xử lý giá trị NULL
- Phone có thể NULL
- FullName, Dob, Gender, Address, SportLevel có thể NULL
- Username và Email phải NOT NULL

## Test đăng ký

Sau khi sửa xong, thử đăng ký với:
- Username: `testuser123`
- Email: `test@example.com`
- Password: `123456`

## Nếu vẫn gặp lỗi

### 1. Kiểm tra log
- Xem log SQL Server
- Xem log ứng dụng Java

### 2. Debug code
- Kiểm tra method `registerUserBasic` trong `UserDAO.java`
- Kiểm tra method `registerUser` trong `UserService.java`

### 3. Kiểm tra kết nối database
- Đảm bảo kết nối đến đúng database
- Kiểm tra quyền truy cập

## Liên hệ hỗ trợ

Nếu vẫn gặp vấn đề, hãy cung cấp:
1. Kết quả chạy script `check_users_table_structure.sql`
2. Log lỗi chi tiết
3. Code Java đang sử dụng để đăng ký 