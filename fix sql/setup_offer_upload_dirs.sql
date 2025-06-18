-- Script to set up upload directories for Offers
-- This is a reference script - directories need to be created manually on the server

/*
SETUP UPLOAD DIRECTORIES FOR OFFERS

1. Create the following directory structure in your web application:
   /web/img/offers/

2. Set proper permissions:
   - Read permissions for web server
   - Write permissions for web application
   - Recommended: 755 for directories, 644 for files

3. Directory structure should be:
   /web/img/offers/
   ├── hanoi_sapa.jpg
   ├── danang_hoian.jpg
   ├── phuquoc_vip.jpg
   ├── nhatrang.jpg
   ├── dalat_vip.jpg
   ├── hue.jpg
   ├── muine.jpg
   ├── cantho.jpg
   ├── halong_vip.jpg
   └── vungtau.jpg

4. For Windows Server:
   - Right-click on /web/img/ folder
   - Select "Properties" -> "Security"
   - Add the web server user (usually IIS_IUSRS or NETWORK SERVICE)
   - Grant "Modify" permissions

5. For Linux/Unix Server:
   - chmod 755 /path/to/web/img/offers/
   - chown www-data:www-data /path/to/web/img/offers/ (adjust user/group as needed)

6. Test upload functionality:
   - Try uploading a small image file
   - Check if file is saved correctly
   - Verify file permissions

7. Security considerations:
   - Validate file types (only images)
   - Limit file sizes (max 5MB)
   - Use unique filenames to prevent conflicts
   - Sanitize uploaded filenames

8. Backup strategy:
   - Regular backups of uploaded images
   - Consider using cloud storage for production
   - Implement image optimization for better performance

9. Performance optimization:
   - Implement image resizing for thumbnails
   - Use CDN for static assets
   - Enable browser caching for images
   - Compress images before storage

10. Monitoring:
    - Monitor disk space usage
    - Track upload success/failure rates
    - Log file operations for debugging
*/

-- SQL to check if upload directory exists (if using database to track files)
-- This is optional and depends on your implementation

/*
-- Create a table to track uploaded files (optional)
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='UploadedFiles' AND xtype='U')
BEGIN
    CREATE TABLE UploadedFiles (
        FileID INT IDENTITY(1,1) PRIMARY KEY,
        OriginalName NVARCHAR(255) NOT NULL,
        StoredName NVARCHAR(255) NOT NULL,
        FilePath NVARCHAR(500) NOT NULL,
        FileSize BIGINT NOT NULL,
        ContentType NVARCHAR(100) NOT NULL,
        UploadedAt DATETIME2 DEFAULT GETDATE(),
        RelatedTable NVARCHAR(50),
        RelatedID INT
    );
    
    PRINT 'UploadedFiles tracking table created.';
END
*/

PRINT 'Upload directory setup instructions completed.';
PRINT 'Please create the directories manually as described above.'; 