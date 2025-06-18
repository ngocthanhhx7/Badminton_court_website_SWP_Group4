-- SQL Server debug script for AboutSection issues
-- Run this script to diagnose common problems

PRINT '=== ABOUT SECTION DEBUG SCRIPT ===';
PRINT '';

-- 1. Check if table exists
IF OBJECT_ID('AboutSections', 'U') IS NOT NULL
BEGIN
    PRINT '✓ AboutSections table exists';
    
    -- 2. Check table structure
    PRINT '';
    PRINT '--- TABLE STRUCTURE ---';
    SELECT 
        COLUMN_NAME,
        DATA_TYPE,
        IS_NULLABLE,
        COLUMN_DEFAULT,
        CHARACTER_MAXIMUM_LENGTH
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'AboutSections'
    ORDER BY ORDINAL_POSITION;
    
    -- 3. Check row count
    PRINT '';
    PRINT '--- ROW COUNT ---';
    DECLARE @RowCount INT;
    SELECT @RowCount = COUNT(*) FROM AboutSections;
    PRINT 'Total rows: ' + CAST(@RowCount AS VARCHAR(10));
    
    -- 4. Check sample data
    PRINT '';
    PRINT '--- SAMPLE DATA ---';
    SELECT TOP 3 
        AboutID,
        Title,
        SUBSTRING(Content, 1, 50) + '...' AS ContentPreview,
        SectionType,
        IsActive,
        CreatedAt
    FROM AboutSections
    ORDER BY AboutID DESC;
    
    -- 5. Check for null values
    PRINT '';
    PRINT '--- NULL VALUE CHECK ---';
    SELECT 
        'Title' AS ColumnName,
        COUNT(*) AS NullCount
    FROM AboutSections 
    WHERE Title IS NULL
    UNION ALL
    SELECT 
        'Content' AS ColumnName,
        COUNT(*) AS NullCount
    FROM AboutSections 
    WHERE Content IS NULL
    UNION ALL
    SELECT 
        'SectionType' AS ColumnName,
        COUNT(*) AS NullCount
    FROM AboutSections 
    WHERE SectionType IS NULL
    UNION ALL
    SELECT 
        'IsActive' AS ColumnName,
        COUNT(*) AS NullCount
    FROM AboutSections 
    WHERE IsActive IS NULL;
    
    -- 6. Check section types
    PRINT '';
    PRINT '--- SECTION TYPES ---';
    SELECT 
        SectionType,
        COUNT(*) AS Count
    FROM AboutSections
    GROUP BY SectionType
    ORDER BY Count DESC;
    
    -- 7. Check active/inactive status
    PRINT '';
    PRINT '--- ACTIVE STATUS ---';
    SELECT 
        IsActive,
        COUNT(*) AS Count
    FROM AboutSections
    GROUP BY IsActive;
    
    -- 8. Test pagination query
    PRINT '';
    PRINT '--- PAGINATION TEST ---';
    SELECT * FROM (
        SELECT ROW_NUMBER() OVER (ORDER BY AboutID DESC) AS RowNum, 
               AboutID, Title, SectionType, IsActive
        FROM AboutSections 
        WHERE (NULL IS NULL OR IsActive = NULL) 
          AND (NULL IS NULL OR Title LIKE NULL) 
          AND (NULL IS NULL OR SectionType = NULL)
    ) AS PagedResults 
    WHERE RowNum BETWEEN 1 AND 10;
    
    -- 9. Test filtered query
    PRINT '';
    PRINT '--- FILTERED QUERY TEST ---';
    SELECT * FROM (
        SELECT ROW_NUMBER() OVER (ORDER BY AboutID DESC) AS RowNum, 
               AboutID, Title, SectionType, IsActive
        FROM AboutSections 
        WHERE (1 IS NULL OR IsActive = 1) 
          AND (NULL IS NULL OR Title LIKE NULL) 
          AND (NULL IS NULL OR SectionType = NULL)
    ) AS PagedResults 
    WHERE RowNum BETWEEN 1 AND 10;
    
    -- 10. Test search query
    PRINT '';
    PRINT '--- SEARCH QUERY TEST ---';
    SELECT * FROM (
        SELECT ROW_NUMBER() OVER (ORDER BY AboutID DESC) AS RowNum, 
               AboutID, Title, SectionType, IsActive
        FROM AboutSections 
        WHERE (NULL IS NULL OR IsActive = NULL) 
          AND (NULL IS NULL OR Title LIKE '%chào%') 
          AND (NULL IS NULL OR SectionType = NULL)
    ) AS PagedResults 
    WHERE RowNum BETWEEN 1 AND 10;
    
    -- 11. Check for potential issues
    PRINT '';
    PRINT '--- POTENTIAL ISSUES ---';
    
    -- Check for very long titles
    SELECT 'Long titles (>200 chars)' AS Issue, COUNT(*) AS Count
    FROM AboutSections 
    WHERE LEN(Title) > 200;
    
    -- Check for very long content
    SELECT 'Long content (>1000 chars)' AS Issue, COUNT(*) AS Count
    FROM AboutSections 
    WHERE LEN(Content) > 1000;
    
    -- Check for invalid section types
    SELECT 'Invalid section types' AS Issue, SectionType, COUNT(*) AS Count
    FROM AboutSections 
    WHERE SectionType NOT IN ('hero', 'about', 'service', 'team')
    GROUP BY SectionType;
    
    -- Check for future dates
    SELECT 'Future creation dates' AS Issue, COUNT(*) AS Count
    FROM AboutSections 
    WHERE CreatedAt > GETDATE();
    
END
ELSE
BEGIN
    PRINT '✗ AboutSections table does not exist!';
    PRINT 'Please run create_about_sections_table.sql first.';
END

PRINT '';
PRINT '=== DEBUG SCRIPT COMPLETED ===';
PRINT 'Check the output above for any issues.'; 