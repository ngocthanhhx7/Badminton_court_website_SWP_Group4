-- Tạo bảng Videos nếu chưa tồn tại
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Videos' AND xtype='U')
BEGIN
    CREATE TABLE Videos (
        VideoID INT PRIMARY KEY IDENTITY(1,1),
        Title NVARCHAR(255) NOT NULL,
        Subtitle NVARCHAR(500),
        VideoUrl NVARCHAR(500) NOT NULL,
        ThumbnailUrl NVARCHAR(500),
        IsFeatured BIT DEFAULT 0,
        CreatedAt DATETIME DEFAULT GETDATE()
    );
    PRINT 'Videos table created successfully!';
END
ELSE
BEGIN
    PRINT 'Videos table already exists.';
END

-- Thêm dữ liệu mẫu nếu bảng trống
IF NOT EXISTS (SELECT 1 FROM Videos)
BEGIN
    INSERT INTO Videos (Title, Subtitle, VideoUrl, ThumbnailUrl, IsFeatured, CreatedAt) 
    VALUES 
    ('Badminton Training Video', 'Learn the basics of badminton', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 'https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg', 1, GETDATE()),
    ('Advanced Badminton Techniques', 'Master advanced badminton skills', 'https://www.youtube.com/watch?v=9bZkp7q19f0', 'https://img.youtube.com/vi/9bZkp7q19f0/maxresdefault.jpg', 0, GETDATE()),
    ('Badminton Court Tour', 'Explore our world-class facilities', 'https://www.youtube.com/watch?v=oHg5SJYRHA0', 'https://img.youtube.com/vi/oHg5SJYRHA0/maxresdefault.jpg', 1, GETDATE());
    
    PRINT 'Sample videos added successfully!';
END
ELSE
BEGIN
    PRINT 'Videos already exist in database.';
END

-- Kiểm tra dữ liệu
SELECT * FROM Videos; 