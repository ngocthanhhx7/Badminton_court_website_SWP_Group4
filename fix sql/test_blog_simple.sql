-- Simple Blog Test Script (No Comments)
-- Test basic blog functionality

-- 1. Check if BlogPosts table has data
SELECT '=== BLOG POSTS CHECK ===' as info;
SELECT COUNT(*) as total_posts FROM BlogPosts;

-- 2. Show all blog posts
SELECT '=== ALL BLOG POSTS ===' as info;
SELECT 
    PostID,
    Title,
    LEFT(Content, 100) + '...' as Content_Preview,
    LEFT(Summary, 50) + '...' as Summary_Preview,
    AuthorID,
    PublishedAt,
    ViewCount,
    Status
FROM BlogPosts 
ORDER BY PublishedAt DESC;

-- 3. Test specific post retrieval (replace 1 with actual post ID)
SELECT '=== TEST SPECIFIC POST ===' as info;
SELECT 
    PostID,
    Title,
    Content,
    Summary,
    ThumbnailUrl,
    AuthorID,
    PublishedAt,
    ViewCount,
    Status
FROM BlogPosts 
WHERE PostID = 1;

-- 4. Test pagination query (same as BlogController uses)
SELECT '=== TEST PAGINATION ===' as info;
SELECT 
    PostID,
    Title,
    AuthorID,
    PublishedAt,
    ViewCount
FROM BlogPosts 
WHERE Title LIKE '%' 
ORDER BY PublishedAt DESC 
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;

-- 5. Test view count increment
SELECT '=== TEST VIEW COUNT ===' as info;
SELECT PostID, Title, ViewCount FROM BlogPosts WHERE PostID = 1;

-- 6. Check if table structure is correct
SELECT '=== TABLE STRUCTURE ===' as info;
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'BlogPosts'
ORDER BY ORDINAL_POSITION; 