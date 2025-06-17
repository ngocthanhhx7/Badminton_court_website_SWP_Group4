-- Script kiểm tra và thiết lập thư mục upload cho Slider (SQL Server)
-- Chạy script này để đảm bảo thư mục upload tồn tại

-- Kiểm tra bảng Sliders có tồn tại không
SELECT 'Checking Sliders table...' as status;

-- Tạo bảng Sliders nếu chưa tồn tại
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sliders]') AND type in (N'U'))
BEGIN
    CREATE TABLE Sliders (
        SliderID INT IDENTITY(1,1) PRIMARY KEY,
        Title NVARCHAR(255) NOT NULL,
        Subtitle NTEXT,
        BackgroundImage NVARCHAR(500),
        Position INT DEFAULT 1,
        IsActive BIT DEFAULT 1,
        CreatedAt DATETIME DEFAULT GETDATE(),
        UpdatedAt DATETIME DEFAULT GETDATE()
    );
    PRINT 'Created Sliders table';
END

-- Kiểm tra cột IsActive có tồn tại không
SELECT 'Checking IsActive column...' as status;

-- Thêm cột IsActive nếu chưa tồn tại
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Sliders') AND name = 'IsActive')
BEGIN
    ALTER TABLE Sliders ADD IsActive BIT DEFAULT 1;
    PRINT 'Added IsActive column';
END

-- Thêm dữ liệu mẫu nếu bảng trống
IF NOT EXISTS (SELECT TOP 1 * FROM Sliders WHERE Title = 'Slider 1')
BEGIN
    INSERT INTO Sliders (Title, Subtitle, BackgroundImage, Position, IsActive) 
    VALUES ('Slider 1', 'Subtitle cho slider 1', '/img/carousel/banner_1.jpg', 1, 1);
    PRINT 'Added sample slider 1';
END

IF NOT EXISTS (SELECT TOP 1 * FROM Sliders WHERE Title = 'Slider 2')
BEGIN
    INSERT INTO Sliders (Title, Subtitle, BackgroundImage, Position, IsActive) 
    VALUES ('Slider 2', 'Subtitle cho slider 2', '/img/carousel/banner_2.jpg', 2, 1);
    PRINT 'Added sample slider 2';
END

-- Hiển thị thông tin bảng
SELECT 'Current Sliders data:' as info;
SELECT * FROM Sliders ORDER BY Position;

-- Kiểm tra cấu trúc bảng
SELECT 'Table structure:' as info;
SELECT 
    c.name AS ColumnName,
    t.name AS DataType,
    c.max_length AS MaxLength,
    c.is_nullable AS IsNullable,
    c.column_id AS ColumnOrder
FROM sys.columns c
INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
WHERE c.object_id = OBJECT_ID('Sliders')
ORDER BY c.column_id;

-- Thông báo hoàn thành
SELECT 'Setup completed successfully!' as status;
SELECT 'Upload directory should be: web/img/carousel/' as directory_info;
SELECT 'Make sure the directory exists and has write permissions' as permission_info; 