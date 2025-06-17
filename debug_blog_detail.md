# Debug Guide for BlogDetailController

## Overview
BlogDetailController handles single blog post display with comments and similar posts functionality.

## Common Issues and Solutions

### 1. "Không tìm thấy ID bài viết"
**Problem**: No postId or id parameter provided
**Solution**: 
- Check URL format: `/single-blog?postId=1` or `/single-blog?id=1`
- Verify links in blog listing page
- Check if parameter names match controller expectations

### 2. "ID bài viết không hợp lệ"
**Problem**: postId parameter is not a valid integer
**Solution**:
- Check URL parameter value
- Verify database has posts with numeric IDs
- Check for URL encoding issues

### 3. "Không tìm thấy bài viết với ID: X"
**Problem**: Post with specified ID doesn't exist in database
**Solution**:
- Run test_blog_detail.sql to check available posts
- Verify BlogPosts table has data
- Check if post status is active

### 4. Comments not loading
**Problem**: Comments section is empty
**Solution**:
- Check BlogComments table exists
- Verify comment data for the post
- Check BlogCommentDAO.getCommentsByPost() method

### 5. Similar posts not showing
**Problem**: Similar posts section is empty
**Solution**:
- Check BlogTags table exists
- Verify post has tags assigned
- Check BlogPostDAO.getSimilarPosts() method

## Testing Steps

### 1. Database Verification
```sql
-- Check if tables exist
SELECT * FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_NAME IN ('BlogPosts', 'BlogComments', 'BlogTags')

-- Check for blog posts
SELECT PostID, Title, Status FROM BlogPosts ORDER BY PostID

-- Check for comments
SELECT PostID, COUNT(*) as CommentCount 
FROM BlogComments 
GROUP BY PostID
```

### 2. URL Testing
Test these URLs:
- `http://localhost:8080/your-app/single-blog?postId=1`
- `http://localhost:8080/your-app/single-blog?id=1`
- `http://localhost:8080/your-app/single-blog` (should redirect to blog)

### 3. Controller Debug
Add debug logging to controller:
```java
System.out.println("=== Blog Detail Debug ===");
System.out.println("postIdStr: " + postIdStr);
System.out.println("postId: " + postId);
System.out.println("post: " + (post != null ? post.getTitle() : "null"));
System.out.println("comments count: " + (comments != null ? comments.size() : "null"));
System.out.println("similar posts count: " + (similarPosts != null ? similarPosts.size() : "null"));
System.out.println("=========================");
```

### 4. JSP Debug
Add debug output to single-blog.jsp:
```jsp
<!-- Debug info -->
<div style="background: #f0f0f0; padding: 10px; margin: 10px;">
    <h5>Debug Info:</h5>
    <p>Post: ${post != null ? post.title : 'null'}</p>
    <p>Post ID: ${post != null ? post.postID : 'null'}</p>
    <p>Comments count: ${comments.size()}</p>
    <p>Similar posts count: ${similarPosts.size()}</p>
    <p>User ID: ${userId}</p>
</div>
```

## Database Schema Requirements

### BlogPosts Table
```sql
CREATE TABLE BlogPosts (
    PostID INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(255) NOT NULL,
    Slug NVARCHAR(255),
    Content NTEXT,
    Summary NVARCHAR(500),
    ThumbnailUrl NVARCHAR(1000),
    PublishedAt DATETIME,
    AuthorID INT,
    ViewCount INT DEFAULT 0,
    Status NVARCHAR(50) DEFAULT 'published',
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE()
);
```

### BlogComments Table
```sql
CREATE TABLE BlogComments (
    CommentID INT IDENTITY(1,1) PRIMARY KEY,
    PostID INT NOT NULL,
    UserID INT NOT NULL,
    Content NTEXT NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    ParentCommentID INT NULL,
    FOREIGN KEY (PostID) REFERENCES BlogPosts(PostID)
);
```

### BlogTags Table
```sql
CREATE TABLE BlogTags (
    TagID INT IDENTITY(1,1) PRIMARY KEY,
    PostID INT NOT NULL,
    TagName NVARCHAR(100) NOT NULL,
    FOREIGN KEY (PostID) REFERENCES BlogPosts(PostID)
);
```

## Error Messages

### 1. "Không tìm thấy ID bài viết"
- **Cause**: Missing postId or id parameter
- **Fix**: Check URL format and parameter names

### 2. "ID bài viết không hợp lệ"
- **Cause**: postId is not a valid integer
- **Fix**: Verify parameter value and database data

### 3. "Không tìm thấy bài viết với ID: X"
- **Cause**: Post doesn't exist in database
- **Fix**: Check database for post with that ID

### 4. "Có lỗi xảy ra: [error message]"
- **Cause**: General exception in controller
- **Fix**: Check server logs for detailed error

## Browser Console Debug
Add this JavaScript to check URL parameters:
```javascript
// Debug URL parameters
console.log('URL:', window.location.href);
console.log('postId:', new URLSearchParams(window.location.search).get('postId'));
console.log('id:', new URLSearchParams(window.location.search).get('id'));
```

## Server Log Debug
Check server logs for:
- SQL exceptions
- Servlet exceptions
- Parameter parsing errors
- Database connection issues

## Sample Data for Testing
```sql
-- Insert sample blog post
INSERT INTO BlogPosts (Title, Content, Summary, ThumbnailUrl, AuthorID, Status, PublishedAt)
VALUES (
    'Sample Blog Post',
    'This is a sample blog post content for testing.',
    'Sample blog post summary',
    'https://example.com/image.jpg',
    1,
    'published',
    GETDATE()
);

-- Insert sample comment
INSERT INTO BlogComments (PostID, UserID, Content)
VALUES (1, 1, 'This is a sample comment');
```

## Performance Optimization
- Add database indexes on frequently queried columns
- Implement caching for similar posts
- Optimize comment loading with pagination
- Use connection pooling for database connections 