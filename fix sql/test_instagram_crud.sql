-- Test script for Instagram CRUD operations

-- 1. Check if table exists
IF OBJECT_ID('InstagramFeeds', 'U') IS NOT NULL
    PRINT 'InstagramFeeds table exists'
ELSE
    PRINT 'InstagramFeeds table does not exist'

-- 2. Check table structure
IF OBJECT_ID('InstagramFeeds', 'U') IS NOT NULL
BEGIN
    SELECT 
        COLUMN_NAME,
        DATA_TYPE,
        IS_NULLABLE,
        COLUMN_DEFAULT
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'InstagramFeeds'
    ORDER BY ORDINAL_POSITION;
END

-- 3. Check current data
IF OBJECT_ID('InstagramFeeds', 'U') IS NOT NULL
BEGIN
    SELECT * FROM InstagramFeeds ORDER BY DisplayOrder ASC;
END

-- 4. Test insert operation
IF OBJECT_ID('InstagramFeeds', 'U') IS NOT NULL
BEGIN
    INSERT INTO InstagramFeeds (ImageUrl, InstagramLink, DisplayOrder, IsVisible, CreatedAt)
    VALUES 
        ('https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=400',
         'https://www.instagram.com/p/test1/',
         1,
         1,
         GETDATE());
    
    PRINT 'Test insert completed';
    
    -- Show the inserted data
    SELECT * FROM InstagramFeeds WHERE InstagramLink LIKE '%test1%';
END

-- 5. Test update operation
IF OBJECT_ID('InstagramFeeds', 'U') IS NOT NULL
BEGIN
    UPDATE InstagramFeeds 
    SET ImageUrl = 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=400',
        IsVisible = 0
    WHERE InstagramLink LIKE '%test1%';
    
    PRINT 'Test update completed';
    
    -- Show the updated data
    SELECT * FROM InstagramFeeds WHERE InstagramLink LIKE '%test1%';
END

-- 6. Test delete operation
IF OBJECT_ID('InstagramFeeds', 'U') IS NOT NULL
BEGIN
    DELETE FROM InstagramFeeds WHERE InstagramLink LIKE '%test1%';
    
    PRINT 'Test delete completed';
    
    -- Verify deletion
    SELECT COUNT(*) as RemainingRecords FROM InstagramFeeds WHERE InstagramLink LIKE '%test1%';
END 