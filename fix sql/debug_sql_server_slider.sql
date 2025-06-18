-- Script debug và kiểm tra SQL Server cho Slider Manager
-- Chạy script này để kiểm tra và sửa lỗi

-- 1. Kiểm tra kết nối và quyền
SELECT 'Checking database connection and permissions...' as status;
SELECT DB_NAME() as CurrentDatabase;
SELECT USER_NAME() as CurrentUser;

-- 2. Kiểm tra bảng Sliders
SELECT 'Checking Sliders table...' as status;
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sliders]') AND type in (N'U'))
BEGIN
    SELECT 'Sliders table exists' as result;
    
    -- Kiểm tra cấu trúc bảng
    SELECT 'Table structure:' as info;
    SELECT 
        c.name AS ColumnName,
        t.name AS DataType,
        c.max_length AS MaxLength,
        c.is_nullable AS IsNullable,
        c.column_id AS ColumnOrder,
        CASE WHEN ic.column_id IS NOT NULL THEN 'YES' ELSE 'NO' END AS IsIndexed
    FROM sys.columns c
    INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
    LEFT JOIN sys.index_columns ic ON c.object_id = ic.object_id AND c.column_id = ic.column_id
    WHERE c.object_id = OBJECT_ID('Sliders')
    ORDER BY c.column_id;
    
    -- Kiểm tra dữ liệu
    SELECT 'Data count:' as info;
    SELECT COUNT(*) as TotalRecords FROM Sliders;
    
    -- Hiển thị dữ liệu mẫu
    SELECT 'Sample data:' as info;
    SELECT TOP 5 * FROM Sliders ORDER BY SliderID DESC;
    
END
ELSE
BEGIN
    SELECT 'Sliders table does not exist' as result;
    SELECT 'Please run setup_upload_directory.sql first' as action;
END

-- 3. Kiểm tra indexes
SELECT 'Checking indexes...' as status;
SELECT 
    i.name AS IndexName,
    i.type_desc AS IndexType,
    c.name AS ColumnName,
    ic.key_ordinal AS KeyOrdinal
FROM sys.indexes i
INNER JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
INNER JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
WHERE i.object_id = OBJECT_ID('Sliders')
ORDER BY i.name, ic.key_ordinal;

-- 4. Test pagination query
SELECT 'Testing pagination query...' as status;
BEGIN TRY
    SELECT * FROM (
        SELECT ROW_NUMBER() OVER (ORDER BY SliderID DESC) AS RowNum, * 
        FROM Sliders 
        WHERE (1 IS NULL OR IsActive = 1) 
        AND (NULL IS NULL OR Title LIKE '%banner%')
    ) AS PagedResults 
    WHERE RowNum BETWEEN 1 AND 10;
    
    SELECT 'Pagination query successful' as result;
END TRY
BEGIN CATCH
    SELECT 'Pagination query failed:' as error;
    SELECT ERROR_MESSAGE() as error_message;
    SELECT ERROR_LINE() as error_line;
END CATCH

-- 5. Test count query
SELECT 'Testing count query...' as status;
BEGIN TRY
    SELECT COUNT(*) as TotalCount FROM Sliders 
    WHERE (1 IS NULL OR IsActive = 1) 
    AND (NULL IS NULL OR Title LIKE '%banner%');
    
    SELECT 'Count query successful' as result;
END TRY
BEGIN CATCH
    SELECT 'Count query failed:' as error;
    SELECT ERROR_MESSAGE() as error_message;
    SELECT ERROR_LINE() as error_line;
END CATCH

-- 6. Test toggle status query
SELECT 'Testing toggle status query...' as status;
BEGIN TRY
    -- Lưu trạng thái hiện tại
    DECLARE @CurrentStatus BIT;
    SELECT @CurrentStatus = IsActive FROM Sliders WHERE SliderID = 1;
    
    -- Test toggle
    UPDATE Sliders SET IsActive = ~IsActive WHERE SliderID = 1;
    
    -- Khôi phục trạng thái
    UPDATE Sliders SET IsActive = @CurrentStatus WHERE SliderID = 1;
    
    SELECT 'Toggle status query successful' as result;
END TRY
BEGIN CATCH
    SELECT 'Toggle status query failed:' as error;
    SELECT ERROR_MESSAGE() as error_message;
    SELECT ERROR_LINE() as error_line;
END CATCH

-- 7. Kiểm tra performance
SELECT 'Checking query performance...' as status;
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT * FROM (
    SELECT ROW_NUMBER() OVER (ORDER BY SliderID DESC) AS RowNum, * 
    FROM Sliders 
    WHERE IsActive = 1
) AS PagedResults 
WHERE RowNum BETWEEN 1 AND 10;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;

-- 8. Thông tin hệ thống
SELECT 'System information:' as info;
SELECT 
    @@VERSION as SQLServerVersion,
    SERVERPROPERTY('ProductLevel') as ProductLevel,
    SERVERPROPERTY('Edition') as Edition;

-- 9. Kiểm tra collation
SELECT 'Checking collation...' as status;
SELECT 
    DATABASEPROPERTYEX(DB_NAME(), 'Collation') as DatabaseCollation,
    SERVERPROPERTY('Collation') as ServerCollation;

-- 10. Kết luận và khuyến nghị
SELECT 'Debug completed. Recommendations:' as conclusion;

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_sliders_title' AND object_id = OBJECT_ID('Sliders'))
BEGIN
    SELECT 'Create index on Title column for better search performance' as recommendation;
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_sliders_isactive' AND object_id = OBJECT_ID('Sliders'))
BEGIN
    SELECT 'Create index on IsActive column for better filter performance' as recommendation;
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_sliders_position' AND object_id = OBJECT_ID('Sliders'))
BEGIN
    SELECT 'Create index on Position column for better sort performance' as recommendation;
END

SELECT 'Run create_slider_indexes.sql to create all recommended indexes' as final_action; 