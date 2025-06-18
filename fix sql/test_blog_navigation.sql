-- Test Blog Navigation (Previous/Next Posts)
-- Verify that navigation between posts works correctly

-- 1. Check if we have enough posts for navigation
SELECT '=== TOTAL BLOG POSTS ===' as info;
SELECT COUNT(*) as total_posts FROM BlogPosts;

-- 2. Show all posts with their IDs for navigation testing
SELECT '=== ALL POSTS WITH IDS ===' as info;
SELECT 
    PostID,
    Title,
    LEFT(Content, 50) + '...' as Content_Preview,
    PublishedAt,
    ViewCount
FROM BlogPosts 
ORDER BY PostID ASC;

-- 3. Test previous post functionality
SELECT '=== TEST PREVIOUS POST ===' as info;
SELECT 
    'Current Post' as type,
    PostID,
    Title
FROM BlogPosts 
WHERE PostID = 2
UNION ALL
SELECT 
    'Previous Post' as type,
    PostID,
    Title
FROM BlogPosts 
WHERE PostID = (SELECT TOP 1 PostID FROM BlogPosts WHERE PostID < 2 ORDER BY PostID DESC);

-- 4. Test next post functionality
SELECT '=== TEST NEXT POST ===' as info;
SELECT 
    'Current Post' as type,
    PostID,
    Title
FROM BlogPosts 
WHERE PostID = 2
UNION ALL
SELECT 
    'Next Post' as type,
    PostID,
    Title
FROM BlogPosts 
WHERE PostID = (SELECT TOP 1 PostID FROM BlogPosts WHERE PostID > 2 ORDER BY PostID ASC);

-- 5. Test edge cases (first and last posts)
SELECT '=== EDGE CASES ===' as info;

-- First post (should have no previous)
SELECT 
    'First Post' as case_type,
    PostID,
    Title,
    'No previous post' as previous_status
FROM BlogPosts 
WHERE PostID = (SELECT MIN(PostID) FROM BlogPosts);

-- Last post (should have no next)
SELECT 
    'Last Post' as case_type,
    PostID,
    Title,
    'No next post' as next_status
FROM BlogPosts 
WHERE PostID = (SELECT MAX(PostID) FROM BlogPosts);

-- 6. Test navigation queries (same as DAO methods)
SELECT '=== NAVIGATION QUERIES ===' as info;

-- Previous post query for post ID 3
SELECT 'Previous post for ID 3:' as query_info;
SELECT TOP 1 PostID, Title FROM BlogPosts WHERE PostID < 3 ORDER BY PostID DESC;

-- Next post query for post ID 3
SELECT 'Next post for ID 3:' as query_info;
SELECT TOP 1 PostID, Title FROM BlogPosts WHERE PostID > 3 ORDER BY PostID ASC;

-- 7. Test URLs that should be generated
SELECT '=== GENERATED URLs ===' as info;
SELECT 
    PostID,
    Title,
    'single-blog?postId=' + CAST(PostID as VARCHAR(10)) as detail_url,
    CASE 
        WHEN PostID > (SELECT MIN(PostID) FROM BlogPosts) 
        THEN 'single-blog?postId=' + CAST((SELECT TOP 1 PostID FROM BlogPosts WHERE PostID < p.PostID ORDER BY PostID DESC) as VARCHAR(10))
        ELSE 'No previous post'
    END as previous_url,
    CASE 
        WHEN PostID < (SELECT MAX(PostID) FROM BlogPosts) 
        THEN 'single-blog?postId=' + CAST((SELECT TOP 1 PostID FROM BlogPosts WHERE PostID > p.PostID ORDER BY PostID ASC) as VARCHAR(10))
        ELSE 'No next post'
    END as next_url
FROM BlogPosts p
ORDER BY PostID; 