-- Test script to check blog access
-- Run these queries to verify blog functionality

-- 1. Check if BlogPosts table exists and has data
SELECT 'Checking BlogPosts table...' as info;
SELECT COUNT(*) as total_posts FROM BlogPosts;

-- 2. Show sample blog posts
SELECT 'Sample blog posts:' as info;
SELECT TOP 5 PostID, Title, AuthorID, PublishedAt, ViewCount, Status 
FROM BlogPosts 
ORDER BY PublishedAt DESC;

-- 3. Check if a specific post exists (replace 1 with actual post ID)
SELECT 'Checking specific post (ID=1):' as info;
SELECT PostID, Title, Content, Summary, ThumbnailUrl, AuthorID, PublishedAt, ViewCount, Status
FROM BlogPosts 
WHERE PostID = 1;

-- 4. Check comment count for posts
SELECT 'Post comment counts:' as info;
SELECT p.PostID, p.Title, COUNT(c.CommentID) as comment_count
FROM BlogPosts p
LEFT JOIN BlogComments c ON p.PostID = c.PostID
GROUP BY p.PostID, p.Title
ORDER BY p.PublishedAt DESC;

-- 5. Test pagination query (similar to what BlogController uses)
SELECT 'Testing pagination query:' as info;
SELECT * FROM BlogPosts 
WHERE Title LIKE '%' 
ORDER BY PublishedAt DESC 
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;

-- 6. Check if BlogComments table exists
SELECT 'Checking BlogComments table...' as info;
SELECT COUNT(*) as total_comments FROM BlogComments;

-- 7. Show sample comments
SELECT 'Sample comments:' as info;
SELECT TOP 5 CommentID, PostID, UserID, Content, CreatedAt
FROM BlogComments
ORDER BY CreatedAt DESC; 