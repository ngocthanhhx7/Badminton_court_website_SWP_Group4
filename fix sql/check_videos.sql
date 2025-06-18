-- Kiểm tra bảng Videos
SELECT * FROM Videos;

-- Kiểm tra cấu trúc bảng Videos
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Videos';

-- Thêm dữ liệu mẫu nếu bảng trống
IF NOT EXISTS (SELECT 1 FROM Videos)
BEGIN
    INSERT INTO Videos (Title, Subtitle, VideoUrl, ThumbnailUrl, IsFeatured, CreatedAt) 
    VALUES 
    ('Badminton Training Video', 'Learn the basics of badminton', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 'https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg', 1, GETDATE()),
    ('Advanced Badminton Techniques', 'Master advanced badminton skills', 'https://www.youtube.com/watch?v=9bZkp7q19f0', 'https://img.youtube.com/vi/9bZkp7q19f0/maxresdefault.jpg', 0, GETDATE());
    
    PRINT 'Sample videos added successfully!';
END
ELSE
BEGIN
    PRINT 'Videos already exist in database.';
END 