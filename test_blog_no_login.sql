-- Test Blog Without Login Requirement
-- Verify that blog posts can be accessed without authentication

-- 1. Check if BlogPosts table has data
SELECT '=== BLOG POSTS AVAILABLE ===' as info;
SELECT COUNT(*) as total_posts FROM BlogPosts;

-- 2. Show sample blog posts that should be accessible
SELECT '=== SAMPLE BLOG POSTS ===' as info;
SELECT TOP 5 
    PostID,
    Title,
    LEFT(Content, 100) + '...' as Content_Preview,
    AuthorID,
    PublishedAt,
    ViewCount,
    Status
FROM BlogPosts 
WHERE Status = 'published' OR Status IS NULL
ORDER BY PublishedAt DESC;

-- 3. Test specific post retrieval (for URL testing)
SELECT '=== TEST POST FOR URL ===' as info;
SELECT 
    PostID,
    Title,
    'single-blog?postId=' + CAST(PostID as VARCHAR(10)) as test_url
FROM BlogPosts 
WHERE PostID = 1;

-- 4. Check if posts have required fields
SELECT '=== POSTS WITH REQUIRED FIELDS ===' as info;
SELECT 
    PostID,
    Title,
    CASE 
        WHEN Content IS NOT NULL AND LEN(Content) > 0 THEN 'OK'
        ELSE 'MISSING CONTENT'
    END as content_status,
    CASE 
        WHEN ThumbnailUrl IS NOT NULL AND LEN(ThumbnailUrl) > 0 THEN 'OK'
        ELSE 'MISSING THUMBNAIL'
    END as thumbnail_status
FROM BlogPosts 
ORDER BY PublishedAt DESC;

-- 5. Test pagination query (same as BlogController)
SELECT '=== PAGINATION TEST ===' as info;
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

-- 6. Check view count functionality
SELECT '=== VIEW COUNT TEST ===' as info;
SELECT 
    PostID,
    Title,
    ViewCount,
    'UPDATE BlogPosts SET ViewCount = ViewCount + 1 WHERE PostID = ' + CAST(PostID as VARCHAR(10)) as increment_query
FROM BlogPosts 
WHERE PostID = 1; 