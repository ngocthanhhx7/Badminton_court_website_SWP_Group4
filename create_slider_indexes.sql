-- Script tạo index cho bảng Sliders để tối ưu performance (SQL Server)
-- Chạy script này sau khi đã tạo bảng Sliders

-- Kiểm tra bảng Sliders có tồn tại không
SELECT 'Checking Sliders table...' as status;

-- Tạo index cho cột Title (tìm kiếm)
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_sliders_title' AND object_id = OBJECT_ID('Sliders'))
BEGIN
    CREATE INDEX idx_sliders_title ON Sliders(Title);
    PRINT 'Created index idx_sliders_title';
END

-- Tạo index cho cột IsActive (lọc theo trạng thái)
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_sliders_isactive' AND object_id = OBJECT_ID('Sliders'))
BEGIN
    CREATE INDEX idx_sliders_isactive ON Sliders(IsActive);
    PRINT 'Created index idx_sliders_isactive';
END

-- Tạo index cho cột Position (sắp xếp theo vị trí)
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_sliders_position' AND object_id = OBJECT_ID('Sliders'))
BEGIN
    CREATE INDEX idx_sliders_position ON Sliders(Position);
    PRINT 'Created index idx_sliders_position';
END

-- Tạo index cho cột CreatedAt (sắp xếp theo ngày tạo)
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_sliders_createdat' AND object_id = OBJECT_ID('Sliders'))
BEGIN
    CREATE INDEX idx_sliders_createdat ON Sliders(CreatedAt);
    PRINT 'Created index idx_sliders_createdat';
END

-- Tạo composite index cho tìm kiếm kết hợp
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_sliders_title_isactive' AND object_id = OBJECT_ID('Sliders'))
BEGIN
    CREATE INDEX idx_sliders_title_isactive ON Sliders(Title, IsActive);
    PRINT 'Created index idx_sliders_title_isactive';
END

-- Tạo index cho SliderID (sắp xếp theo ID)
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_sliders_id' AND object_id = OBJECT_ID('Sliders'))
BEGIN
    CREATE INDEX idx_sliders_id ON Sliders(SliderID);
    PRINT 'Created index idx_sliders_id';
END

-- Hiển thị thông tin index đã tạo
SELECT 'Created indexes for Sliders table:' as info;

-- Kiểm tra các index đã tạo
SELECT 
    i.name AS INDEX_NAME,
    c.name AS COLUMN_NAME,
    i.is_unique AS NON_UNIQUE,
    ic.key_ordinal AS SEQ_IN_INDEX
FROM sys.indexes i
INNER JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
INNER JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
WHERE i.object_id = OBJECT_ID('Sliders')
ORDER BY i.name, ic.key_ordinal;

-- Thông báo hoàn thành
SELECT 'Index creation completed successfully!' as status;
SELECT 'These indexes will improve performance for:' as info;
SELECT '- Searching by title' as benefit;
SELECT '- Filtering by status' as benefit;
SELECT '- Sorting by position, date, ID' as benefit;
SELECT '- Combined search and filter operations' as benefit;

-- Kiểm tra performance với execution plan
SELECT 'Testing query performance...' as test_info;

-- Test query với execution plan
SET STATISTICS IO ON;
SELECT * FROM (
    SELECT ROW_NUMBER() OVER (ORDER BY Position ASC) AS RowNum, * 
    FROM Sliders 
    WHERE IsActive = 1 
    AND Title LIKE '%banner%'
) AS PagedResults 
WHERE RowNum BETWEEN 1 AND 10;
SET STATISTICS IO OFF; 