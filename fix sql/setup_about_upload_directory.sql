-- SQL Server script to create upload directory structure for About Sections
-- This script creates the necessary directories for image uploads

-- Note: This is a reference script. The actual directory creation should be done at the file system level.
-- The directories should be created in your web application's root directory.

/*
DIRECTORY STRUCTURE TO CREATE:

/web/
  /img/
    /about/
      /uploads/
        /hero/
        /about/
        /service/
        /team/

STEPS TO SETUP:

1. Create the base directories:
   mkdir -p web/img/about/uploads/hero
   mkdir -p web/img/about/uploads/about
   mkdir -p web/img/about/uploads/service
   mkdir -p web/img/about/uploads/team

2. Set proper permissions (if on Linux/Unix):
   chmod 755 web/img/about/uploads
   chmod 755 web/img/about/uploads/*

3. Ensure the web server has write permissions to these directories.

4. For Windows, ensure the application pool identity has write permissions.
*/

-- Check if the AboutSections table exists and has the correct structure
IF OBJECT_ID('AboutSections', 'U') IS NOT NULL
BEGIN
    PRINT 'AboutSections table exists.';
    
    -- Check if IsActive column exists
    IF COL_LENGTH('AboutSections', 'IsActive') IS NOT NULL
    BEGIN
        PRINT 'IsActive column exists.';
    END
    ELSE
    BEGIN
        PRINT 'IsActive column does not exist. Adding it...';
        ALTER TABLE AboutSections ADD IsActive BIT DEFAULT 1;
    END
    
    -- Check if CreatedAt column exists
    IF COL_LENGTH('AboutSections', 'CreatedAt') IS NOT NULL
    BEGIN
        PRINT 'CreatedAt column exists.';
    END
    ELSE
    BEGIN
        PRINT 'CreatedAt column does not exist. Adding it...';
        ALTER TABLE AboutSections ADD CreatedAt DATETIME2 DEFAULT GETDATE();
    END
    
    -- Display table structure
    SELECT 
        COLUMN_NAME,
        DATA_TYPE,
        IS_NULLABLE,
        COLUMN_DEFAULT
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'AboutSections'
    ORDER BY ORDINAL_POSITION;
END
ELSE
BEGIN
    PRINT 'AboutSections table does not exist. Please run create_about_sections_table.sql first.';
END
GO

PRINT 'About Sections upload directory setup script completed.';
PRINT 'Please ensure the physical directories are created as described above.'; 