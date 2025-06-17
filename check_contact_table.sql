-- Script to check and add IsActive column to ContactInfo table
USE BadmintonHub;

-- Check if IsActive column exists
IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'ContactInfo' 
    AND COLUMN_NAME = 'IsActive'
)
BEGIN
    -- Add IsActive column with default value true
    ALTER TABLE ContactInfo ADD IsActive BIT DEFAULT 1;
    PRINT 'IsActive column added to ContactInfo table';
END
ELSE
BEGIN
    PRINT 'IsActive column already exists in ContactInfo table';
END

-- Update existing records to have IsActive = 1 if they don't have it set
UPDATE ContactInfo SET IsActive = 1 WHERE IsActive IS NULL;

-- Show the table structure
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'ContactInfo'
ORDER BY ORDINAL_POSITION;

-- Show sample data
SELECT TOP 5 * FROM ContactInfo; 