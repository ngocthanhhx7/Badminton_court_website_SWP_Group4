-- Script tạo lại bảng Users với cấu trúc đúng
USE BadmintonHub;

-- 1. Backup dữ liệu hiện tại (nếu có)
PRINT '=== BACKUP DỮ LIỆU HIỆN TẠI ===';
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Users')
BEGIN
    -- Tạo bảng backup
    SELECT * INTO Users_Backup FROM Users;
    PRINT 'Đã backup dữ liệu vào bảng Users_Backup';
    
    -- Hiển thị số lượng record đã backup
    DECLARE @backupCount INT;
    SELECT @backupCount = COUNT(*) FROM Users_Backup;
    PRINT 'Số lượng record đã backup: ' + CAST(@backupCount AS VARCHAR(10));
END
ELSE
BEGIN
    PRINT 'Bảng Users chưa tồn tại, không cần backup';
END

-- 2. Xóa bảng Users hiện tại
PRINT '=== XÓA BẢNG USERS HIỆN TẠI ===';
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Users')
BEGIN
    DROP TABLE Users;
    PRINT 'Đã xóa bảng Users cũ';
END

-- 3. Tạo lại bảng Users với cấu trúc đúng
PRINT '=== TẠO LẠI BẢNG USERS ===';
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

PRINT 'Đã tạo bảng Users mới';

-- 4. Tạo các ràng buộc UNIQUE hợp lý
PRINT '=== TẠO CÁC RÀNG BUỘC UNIQUE ===';

-- Ràng buộc UNIQUE cho Username
ALTER TABLE Users ADD CONSTRAINT UQ_Users_Username UNIQUE (Username);
PRINT 'Đã tạo ràng buộc UNIQUE cho Username';

-- Ràng buộc UNIQUE cho Email
ALTER TABLE Users ADD CONSTRAINT UQ_Users_Email UNIQUE (Email);
PRINT 'Đã tạo ràng buộc UNIQUE cho Email';

-- Ràng buộc UNIQUE cho Phone (chỉ áp dụng cho giá trị không NULL)
-- Tạo index filtered để chỉ áp dụng cho giá trị không NULL
CREATE UNIQUE INDEX IX_Users_Phone_Unique ON Users(Phone) WHERE Phone IS NOT NULL;
PRINT 'Đã tạo index UNIQUE cho Phone (chỉ áp dụng cho giá trị không NULL)';

-- 5. Tạo các index khác để tối ưu hiệu suất
PRINT '=== TẠO CÁC INDEX TỐI ƯU ===';

-- Index cho Role
CREATE INDEX IX_Users_Role ON Users(Role);
PRINT 'Đã tạo index cho Role';

-- Index cho Status
CREATE INDEX IX_Users_Status ON Users(Status);
PRINT 'Đã tạo index cho Status';

-- Index cho CreatedAt
CREATE INDEX IX_Users_CreatedAt ON Users(CreatedAt DESC);
PRINT 'Đã tạo index cho CreatedAt';

-- 6. Khôi phục dữ liệu từ backup (nếu có)
PRINT '=== KHÔI PHỤC DỮ LIỆU ===';
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Users_Backup')
BEGIN
    -- Chỉ khôi phục các record có dữ liệu hợp lệ
    INSERT INTO Users (Username, Password, Email, FullName, Dob, Gender, Phone, Address, SportLevel, Role, Status, CreatedBy, CreatedAt, UpdatedAt)
    SELECT 
        CASE 
            WHEN Username IS NULL OR Username = '' THEN 'user_' + CAST(UserID AS VARCHAR(10))
            ELSE Username 
        END,
        Password,
        CASE 
            WHEN Email IS NULL OR Email = '' THEN 'user_' + CAST(UserID AS VARCHAR(10)) + '@example.com'
            ELSE Email 
        END,
        FullName,
        Dob,
        Gender,
        Phone,
        Address,
        SportLevel,
        COALESCE(Role, 'Customer'),
        COALESCE(Status, 'Active'),
        CreatedBy,
        COALESCE(CreatedAt, GETDATE()),
        COALESCE(UpdatedAt, GETDATE())
    FROM Users_Backup;
    
    DECLARE @restoredCount INT;
    SELECT @restoredCount = COUNT(*) FROM Users;
    PRINT 'Đã khôi phục ' + CAST(@restoredCount AS VARCHAR(10)) + ' record';
    
    -- Xóa bảng backup
    DROP TABLE Users_Backup;
    PRINT 'Đã xóa bảng backup';
END
ELSE
BEGIN
    PRINT 'Không có dữ liệu để khôi phục';
END

-- 7. Thêm dữ liệu mẫu nếu bảng trống
PRINT '=== THÊM DỮ LIỆU MẪU ===';
IF NOT EXISTS (SELECT 1 FROM Users)
BEGIN
    INSERT INTO Users (Username, Password, Email, FullName, Dob, Gender, Phone, Address, SportLevel, Role, Status, CreatedBy)
    VALUES 
    ('admin', 'admin123', 'admin@badmintonhub.com', 'Administrator', '1990-01-01', 'Male', '0123456789', '123 Admin Street', 'Advanced', 'Admin', 'Active', NULL),
    ('customer1', 'customer123', 'customer1@example.com', 'John Doe', '1995-05-15', 'Male', '0987654321', '456 Customer Ave', 'Intermediate', 'Customer', 'Active', NULL),
    ('staff1', 'staff123', 'staff1@badmintonhub.com', 'Jane Smith', '1988-12-10', 'Female', '0111222333', '789 Staff Road', 'Advanced', 'Staff', 'Active', 1);
    
    PRINT 'Đã thêm 3 record mẫu';
END
ELSE
BEGIN
    PRINT 'Bảng đã có dữ liệu, không cần thêm mẫu';
END

-- 8. Kiểm tra kết quả cuối cùng
PRINT '=== KIỂM TRA KẾT QUẢ CUỐI CÙNG ===';

-- Hiển thị cấu trúc bảng
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Users'
ORDER BY ORDINAL_POSITION;

-- Hiển thị các ràng buộc
SELECT 
    c.CONSTRAINT_NAME,
    c.CONSTRAINT_TYPE,
    cc.COLUMN_NAME
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS c
INNER JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE cc 
    ON c.CONSTRAINT_NAME = cc.CONSTRAINT_NAME
WHERE c.TABLE_NAME = 'Users'
ORDER BY c.CONSTRAINT_TYPE, c.CONSTRAINT_NAME;

-- Hiển thị dữ liệu
SELECT TOP 5 
    UserID,
    Username,
    Email,
    Role,
    Status,
    CreatedAt
FROM Users
ORDER BY UserID;

PRINT '=== HOÀN THÀNH TẠO LẠI BẢNG USERS ===';
PRINT 'Bây giờ bạn có thể đăng ký tài khoản mới!'; 