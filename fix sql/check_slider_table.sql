-- Script to check and create Sliders table if needed
USE BadmintonHub;

-- Check if Sliders table exists
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Sliders')
BEGIN
    -- Create Sliders table
    CREATE TABLE Sliders (
        SliderID INT IDENTITY(1,1) PRIMARY KEY,
        Title NVARCHAR(255) NOT NULL,
        Subtitle NVARCHAR(500),
        BackgroundImage NVARCHAR(500) NOT NULL,
        Position INT DEFAULT 1,
        IsActive BIT DEFAULT 1,
        CreatedAt DATETIME DEFAULT GETDATE()
    );
    PRINT 'Sliders table created successfully';
END
ELSE
BEGIN
    PRINT 'Sliders table already exists';
END

-- Check if IsActive column exists
IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'Sliders' 
    AND COLUMN_NAME = 'IsActive'
)
BEGIN
    -- Add IsActive column with default value true
    ALTER TABLE Sliders ADD IsActive BIT DEFAULT 1;
    PRINT 'IsActive column added to Sliders table';
END
ELSE
BEGIN
    PRINT 'IsActive column already exists in Sliders table';
END

-- Update existing records to have IsActive = 1 if they don't have it set
UPDATE Sliders SET IsActive = 1 WHERE IsActive IS NULL;

-- Show the table structure
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Sliders'
ORDER BY ORDINAL_POSITION;

-- Show sample data
SELECT TOP 5 * FROM Sliders;

-- Insert sample data if table is empty
IF NOT EXISTS (SELECT TOP 1 1 FROM Sliders)
BEGIN
    INSERT INTO Sliders (Title, Subtitle, BackgroundImage, Position, IsActive, CreatedAt) VALUES
    ('Chào mừng đến với Badminton Hub', 'Nơi tốt nhất để chơi cầu lông', '/img/carousel/banner_1.jpg', 1, 1, GETDATE()),
    ('Sân cầu lông chất lượng cao', 'Đặt sân ngay hôm nay', '/img/carousel/banner_2.jpg', 2, 1, GETDATE()),
    ('Huấn luyện viên chuyên nghiệp', 'Nâng cao kỹ năng của bạn', '/img/carousel/banner_3.jpg', 3, 1, GETDATE());
    PRINT 'Sample data inserted into Sliders table';
END 