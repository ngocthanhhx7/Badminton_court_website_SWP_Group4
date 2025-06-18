-- Script kiểm tra cấu trúc bảng Users và sửa lỗi UNIQUE KEY constraint
USE BadmintonHub;

-- 1. Kiểm tra cấu trúc bảng Users hiện tại
PRINT '=== CẤU TRÚC BẢNG USERS HIỆN TẠI ===';
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT,
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Users'
ORDER BY ORDINAL_POSITION;

-- 2. Kiểm tra các ràng buộc UNIQUE KEY
PRINT '=== CÁC RÀNG BUỘC UNIQUE KEY ===';
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

-- 3. Kiểm tra dữ liệu hiện tại trong bảng Users
PRINT '=== DỮ LIỆU HIỆN TẠI TRONG BẢNG USERS ===';
SELECT TOP 10 
    UserID,
    Username,
    Email,
    Phone,
    Role,
    Status,
    CreatedAt
FROM Users
ORDER BY UserID DESC;

-- 4. Kiểm tra các giá trị NULL hoặc rỗng có thể gây lỗi UNIQUE
PRINT '=== KIỂM TRA GIÁ TRỊ NULL/RỖNG ===';
SELECT 
    'Username NULL/Empty' as Field,
    COUNT(*) as Count
FROM Users 
WHERE Username IS NULL OR Username = ''
UNION ALL
SELECT 
    'Email NULL/Empty' as Field,
    COUNT(*) as Count
FROM Users 
WHERE Email IS NULL OR Email = ''
UNION ALL
SELECT 
    'Phone NULL/Empty' as Field,
    COUNT(*) as Count
FROM Users 
WHERE Phone IS NULL OR Phone = '';

-- 5. Kiểm tra các giá trị trùng lặp
PRINT '=== KIỂM TRA GIÁ TRỊ TRÙNG LẶP ===';
SELECT 
    'Duplicate Usernames' as Field,
    Username,
    COUNT(*) as Count
FROM Users 
WHERE Username IS NOT NULL AND Username != ''
GROUP BY Username
HAVING COUNT(*) > 1
UNION ALL
SELECT 
    'Duplicate Emails' as Field,
    Email,
    COUNT(*) as Count
FROM Users 
WHERE Email IS NOT NULL AND Email != ''
GROUP BY Email
HAVING COUNT(*) > 1
UNION ALL
SELECT 
    'Duplicate Phones' as Field,
    Phone,
    COUNT(*) as Count
FROM Users 
WHERE Phone IS NOT NULL AND Phone != ''
GROUP BY Phone
HAVING COUNT(*) > 1;

-- 6. Hiển thị thông tin về ràng buộc cụ thể gây lỗi
PRINT '=== THÔNG TIN RÀNG BUỘC GÂY LỖI ===';
SELECT 
    'UQ__Users__5C7E359E6A98716B' as ConstraintName,
    'This constraint is causing the error' as Description; 