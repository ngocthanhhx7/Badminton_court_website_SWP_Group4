-- Script sửa lỗi UNIQUE KEY constraint trong bảng Users
USE BadmintonHub;

-- 1. Xóa ràng buộc UNIQUE KEY gây lỗi
PRINT '=== XÓA RÀNG BUỘC UNIQUE KEY GÂY LỖI ===';
IF EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    WHERE CONSTRAINT_NAME = 'UQ__Users__5C7E359E6A98716B'
)
BEGIN
    ALTER TABLE Users DROP CONSTRAINT UQ__Users__5C7E359E6A98716B;
    PRINT 'Đã xóa ràng buộc UQ__Users__5C7E359E6A98716B';
END
ELSE
BEGIN
    PRINT 'Ràng buộc UQ__Users__5C7E359E6A98716B không tồn tại';
END

-- 2. Xóa các ràng buộc UNIQUE khác có thể gây vấn đề
PRINT '=== XÓA CÁC RÀNG BUỘC UNIQUE KHÁC ===';
DECLARE @sql NVARCHAR(MAX) = '';

SELECT @sql = @sql + 'ALTER TABLE Users DROP CONSTRAINT ' + QUOTENAME(CONSTRAINT_NAME) + ';' + CHAR(13)
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
WHERE TABLE_NAME = 'Users' 
    AND CONSTRAINT_TYPE = 'UNIQUE'
    AND CONSTRAINT_NAME != 'UQ__Users__5C7E359E6A98716B';

IF @sql != ''
BEGIN
    EXEC sp_executesql @sql;
    PRINT 'Đã xóa các ràng buộc UNIQUE khác';
END
ELSE
BEGIN
    PRINT 'Không có ràng buộc UNIQUE nào khác cần xóa';
END

-- 3. Dọn dẹp dữ liệu NULL/empty có thể gây vấn đề
PRINT '=== DỌN DẸP DỮ LIỆU NULL/EMPTY ===';

-- Cập nhật các giá trị NULL thành giá trị mặc định
UPDATE Users 
SET Username = 'user_' + CAST(UserID AS VARCHAR(10))
WHERE Username IS NULL OR Username = '';

UPDATE Users 
SET Email = 'user_' + CAST(UserID AS VARCHAR(10)) + '@example.com'
WHERE Email IS NULL OR Email = '';

-- 4. Tạo lại các ràng buộc UNIQUE hợp lý
PRINT '=== TẠO LẠI CÁC RÀNG BUỘC UNIQUE ===';

-- Ràng buộc UNIQUE cho Username (chỉ áp dụng cho giá trị không NULL)
IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    WHERE CONSTRAINT_NAME = 'UQ_Users_Username'
)
BEGIN
    ALTER TABLE Users ADD CONSTRAINT UQ_Users_Username UNIQUE (Username);
    PRINT 'Đã tạo ràng buộc UNIQUE cho Username';
END

-- Ràng buộc UNIQUE cho Email (chỉ áp dụng cho giá trị không NULL)
IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    WHERE CONSTRAINT_NAME = 'UQ_Users_Email'
)
BEGIN
    ALTER TABLE Users ADD CONSTRAINT UQ_Users_Email UNIQUE (Email);
    PRINT 'Đã tạo ràng buộc UNIQUE cho Email';
END

-- Ràng buộc UNIQUE cho Phone (chỉ áp dụng cho giá trị không NULL)
IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    WHERE CONSTRAINT_NAME = 'UQ_Users_Phone'
)
BEGIN
    ALTER TABLE Users ADD CONSTRAINT UQ_Users_Phone UNIQUE (Phone);
    PRINT 'Đã tạo ràng buộc UNIQUE cho Phone';
END

-- 5. Kiểm tra lại cấu trúc sau khi sửa
PRINT '=== KIỂM TRA LẠI CẤU TRÚC SAU KHI SỬA ===';
SELECT 
    c.CONSTRAINT_NAME,
    c.CONSTRAINT_TYPE,
    cc.COLUMN_NAME
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS c
INNER JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE cc 
    ON c.CONSTRAINT_NAME = cc.CONSTRAINT_NAME
WHERE c.TABLE_NAME = 'Users' 
    AND c.CONSTRAINT_TYPE = 'UNIQUE'
ORDER BY c.CONSTRAINT_NAME;

-- 6. Kiểm tra dữ liệu sau khi sửa
PRINT '=== KIỂM TRA DỮ LIỆU SAU KHI SỬA ===';
SELECT TOP 5 
    UserID,
    Username,
    Email,
    Phone,
    Role,
    Status
FROM Users
ORDER BY UserID DESC;

PRINT '=== HOÀN THÀNH SỬA LỖI UNIQUE KEY CONSTRAINT ===';
PRINT 'Bây giờ bạn có thể thử đăng ký lại!'; 