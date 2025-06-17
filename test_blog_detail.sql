-- Test script for Blog Detail functionality

-- 1. Check if BlogPosts table exists
IF OBJECT_ID('BlogPosts', 'U') IS NOT NULL
    PRINT 'BlogPosts table exists'
ELSE
    PRINT 'BlogPosts table does not exist'

-- 2. Check table structure
IF OBJECT_ID('BlogPosts', 'U') IS NOT NULL
BEGIN
    SELECT 
        COLUMN_NAME,
        DATA_TYPE,
        IS_NULLABLE,
        COLUMN_DEFAULT
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'BlogPosts'
    ORDER BY ORDINAL_POSITION;
END

-- 3. Check current blog posts
IF OBJECT_ID('BlogPosts', 'U') IS NOT NULL
BEGIN
    SELECT 
        PostID,
        Title,
        AuthorID,
        ViewCount,
        Status,
        PublishedAt
    FROM BlogPosts 
    ORDER BY PublishedAt DESC;
END

-- 4. Check BlogComments table
IF OBJECT_ID('BlogComments', 'U') IS NOT NULL
BEGIN
    SELECT 
        CommentID,
        PostID,
        UserID,
        Content,
        CreatedAt
    FROM BlogComments 
    ORDER BY CreatedAt DESC;
END

-- 5. Test getPostById functionality
IF OBJECT_ID('BlogPosts', 'U') IS NOT NULL
BEGIN
    DECLARE @TestPostID INT = 1;
    
    -- Check if post exists
    IF EXISTS (SELECT 1 FROM BlogPosts WHERE PostID = @TestPostID)
    BEGIN
        PRINT 'Post with ID ' + CAST(@TestPostID AS VARCHAR) + ' exists';
        
        -- Get post details
        SELECT 
            PostID,
            Title,
            Content,
            Summary,
            ThumbnailUrl,
            AuthorID,
            ViewCount,
            Status,
            PublishedAt
        FROM BlogPosts 
        WHERE PostID = @TestPostID;
        
        -- Get comments for this post
        SELECT 
            CommentID,
            UserID,
            Content,
            CreatedAt
        FROM BlogComments 
        WHERE PostID = @TestPostID
        ORDER BY CreatedAt DESC;
        
        -- Get comment count
        SELECT COUNT(*) as CommentCount
        FROM BlogComments 
        WHERE PostID = @TestPostID;
        
    END
    ELSE
    BEGIN
        PRINT 'Post with ID ' + CAST(@TestPostID AS VARCHAR) + ' does not exist';
        
        -- Show available post IDs
        SELECT TOP 5 PostID, Title FROM BlogPosts ORDER BY PostID;
    END
END

-- 6. Test incrementViewCount functionality
IF OBJECT_ID('BlogPosts', 'U') IS NOT NULL
BEGIN
    DECLARE @TestPostID INT = 1;
    
    IF EXISTS (SELECT 1 FROM BlogPosts WHERE PostID = @TestPostID)
    BEGIN
        -- Get current view count
        SELECT PostID, Title, ViewCount as CurrentViewCount
        FROM BlogPosts 
        WHERE PostID = @TestPostID;
        
        -- Increment view count (simulate the DAO method)
        UPDATE BlogPosts 
        SET ViewCount = ViewCount + 1 
        WHERE PostID = @TestPostID;
        
        -- Check updated view count
        SELECT PostID, Title, ViewCount as UpdatedViewCount
        FROM BlogPosts 
        WHERE PostID = @TestPostID;
    END
END

-- 7. Check for any sample data
IF OBJECT_ID('BlogPosts', 'U') IS NOT NULL
BEGIN
    SELECT COUNT(*) as TotalPosts FROM BlogPosts;
    SELECT COUNT(*) as TotalComments FROM BlogComments;
    
    -- Show sample posts
    SELECT TOP 3 
        PostID,
        Title,
        LEFT(Content, 100) + '...' as ContentPreview,
        ViewCount,
        Status
    FROM BlogPosts 
    ORDER BY PublishedAt DESC;
END 