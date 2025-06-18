-- Debug script for Offers table (SQL Server)
-- Run this script to troubleshoot issues with the Offers CRUD system

PRINT '=== OFFERS TABLE DEBUG SCRIPT ===';
PRINT '';

-- 1. Check if table exists
IF EXISTS (SELECT * FROM sysobjects WHERE name='Offers' AND xtype='U')
BEGIN
    PRINT '✓ Offers table exists';
    
    -- 2. Check table structure
    PRINT '';
    PRINT '--- TABLE STRUCTURE ---';
    SELECT 
        COLUMN_NAME,
        DATA_TYPE,
        IS_NULLABLE,
        COLUMN_DEFAULT
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'Offers'
    ORDER BY ORDINAL_POSITION;
    
    -- 3. Check indexes
    PRINT '';
    PRINT '--- INDEXES ---';
    SELECT 
        i.name AS IndexName,
        i.type_desc AS IndexType,
        STUFF((
            SELECT ', ' + COL_NAME(ic.object_id, ic.column_id)
            FROM sys.index_columns ic
            WHERE ic.object_id = i.object_id AND ic.index_id = i.index_id
            ORDER BY ic.key_ordinal
            FOR XML PATH('')
        ), 1, 2, '') AS Columns
    FROM sys.indexes i
    WHERE i.object_id = OBJECT_ID('Offers')
    ORDER BY i.name;
    
    -- 4. Count records
    PRINT '';
    PRINT '--- RECORD COUNT ---';
    DECLARE @RecordCount INT;
    SELECT @RecordCount = COUNT(*) FROM Offers;
    PRINT 'Total records: ' + CAST(@RecordCount AS VARCHAR(10));
    
    -- 5. Check data distribution
    PRINT '';
    PRINT '--- DATA DISTRIBUTION ---';
    SELECT 
        'Active Offers' AS Category,
        COUNT(*) AS Count
    FROM Offers 
    WHERE IsActive = 1
    UNION ALL
    SELECT 
        'Inactive Offers' AS Category,
        COUNT(*) AS Count
    FROM Offers 
    WHERE IsActive = 0
    UNION ALL
    SELECT 
        'VIP Offers' AS Category,
        COUNT(*) AS Count
    FROM Offers 
    WHERE IsVIP = 1
    UNION ALL
    SELECT 
        'Normal Offers' AS Category,
        COUNT(*) AS Count
    FROM Offers 
    WHERE IsVIP = 0;
    
    -- 6. Sample data check
    PRINT '';
    PRINT '--- SAMPLE DATA ---';
    SELECT TOP 5
        OfferID,
        Title,
        LEFT(Description, 30) + '...' AS DescriptionPreview,
        Capacity,
        CASE WHEN IsVIP = 1 THEN 'VIP' ELSE 'Normal' END AS Type,
        CASE WHEN IsActive = 1 THEN 'Active' ELSE 'Inactive' END AS Status,
        CreatedAt
    FROM Offers
    ORDER BY OfferID;
    
    -- 7. Check for potential issues
    PRINT '';
    PRINT '--- POTENTIAL ISSUES ---';
    
    -- Check for null titles
    IF EXISTS (SELECT * FROM Offers WHERE Title IS NULL OR Title = '')
    BEGIN
        PRINT '⚠ Found offers with null or empty titles';
        SELECT OfferID, Title FROM Offers WHERE Title IS NULL OR Title = '';
    END
    ELSE
    BEGIN
        PRINT '✓ All offers have valid titles';
    END
    
    -- Check for negative capacity
    IF EXISTS (SELECT * FROM Offers WHERE Capacity < 0)
    BEGIN
        PRINT '⚠ Found offers with negative capacity';
        SELECT OfferID, Capacity FROM Offers WHERE Capacity < 0;
    END
    ELSE
    BEGIN
        PRINT '✓ All offers have valid capacity values';
    END
    
    -- Check for very long descriptions
    IF EXISTS (SELECT * FROM Offers WHERE LEN(Description) > 1000)
    BEGIN
        PRINT '⚠ Found offers with very long descriptions (>1000 chars)';
        SELECT OfferID, LEN(Description) AS DescriptionLength FROM Offers WHERE LEN(Description) > 1000;
    END
    ELSE
    BEGIN
        PRINT '✓ All descriptions are within reasonable length';
    END
    
    -- 8. Test pagination query
    PRINT '';
    PRINT '--- PAGINATION TEST ---';
    DECLARE @Page INT = 1;
    DECLARE @PageSize INT = 5;
    DECLARE @StartRow INT = (@Page - 1) * @PageSize + 1;
    DECLARE @EndRow INT = @Page * @PageSize;
    
    PRINT 'Testing pagination: Page ' + CAST(@Page AS VARCHAR) + ', Size ' + CAST(@PageSize AS VARCHAR);
    
    SELECT * FROM (
        SELECT ROW_NUMBER() OVER (ORDER BY OfferID DESC) AS RowNum, *
        FROM Offers
    ) AS PagedResults 
    WHERE RowNum BETWEEN @StartRow AND @EndRow;
    
    -- 9. Test filtering query
    PRINT '';
    PRINT '--- FILTERING TEST ---';
    SELECT * FROM Offers 
    WHERE IsActive = 1 AND IsVIP = 1
    ORDER BY OfferID DESC;
    
    -- 10. Test search query
    PRINT '';
    PRINT '--- SEARCH TEST ---';
    SELECT * FROM Offers 
    WHERE Title LIKE '%Du Lịch%' OR Subtitle LIKE '%Du Lịch%' OR Description LIKE '%Du Lịch%'
    ORDER BY OfferID DESC;
    
END
ELSE
BEGIN
    PRINT '✗ Offers table does not exist!';
    PRINT 'Please run create_offers_table.sql first.';
END

PRINT '';
PRINT '=== DEBUG SCRIPT COMPLETED ===';

-- 11. Performance check
PRINT '';
PRINT '--- PERFORMANCE CHECK ---';
SET STATISTICS TIME ON;
SELECT * FROM Offers WHERE IsActive = 1 ORDER BY OfferID DESC;
SET STATISTICS TIME OFF;

-- 12. Check for locks or blocking
PRINT '';
PRINT '--- LOCK CHECK ---';
SELECT 
    request_session_id,
    resource_type,
    resource_description,
    request_mode,
    request_status
FROM sys.dm_tran_locks 
WHERE resource_database_id = DB_ID() 
AND resource_associated_entity_id = OBJECT_ID('Offers');

PRINT '';
PRINT 'Debug script completed. Check the output above for any issues.'; 