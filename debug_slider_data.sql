-- Script to debug Sliders table data
USE BadmintonHub;

-- Check if Sliders table exists
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Sliders')
BEGIN
    PRINT 'Sliders table exists';
    
    -- Show table structure
    SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'Sliders'
    ORDER BY ORDINAL_POSITION;
    
    -- Show all data
    SELECT * FROM Sliders ORDER BY SliderID;
    
    -- Count records
    SELECT COUNT(*) as TotalSliders FROM Sliders;
    
    -- Check for any NULL values in important columns
    SELECT 'Records with NULL Title' as CheckType, COUNT(*) as Count
    FROM Sliders WHERE Title IS NULL
    UNION ALL
    SELECT 'Records with NULL BackgroundImage' as CheckType, COUNT(*) as Count
    FROM Sliders WHERE BackgroundImage IS NULL
    UNION ALL
    SELECT 'Records with NULL IsActive' as CheckType, COUNT(*) as Count
    FROM Sliders WHERE IsActive IS NULL;
    
END
ELSE
BEGIN
    PRINT 'Sliders table does not exist!';
END 