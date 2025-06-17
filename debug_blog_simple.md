# Debug Guide: Simplified Blog (No Comments)

## Changes Made

### 1. Removed Comment Functionality
- ✅ Removed all comment-related code from `single-blog.jsp`
- ✅ Simplified `BlogDetailController` to only handle post display
- ✅ Removed comment forms, comment lists, and comment processing

### 2. Simplified BlogDetailController
- ✅ Only handles GET requests for displaying posts
- ✅ Increments view count
- ✅ No comment processing
- ✅ Simple error handling

### 3. Simplified single-blog.jsp
- ✅ Only shows blog post content
- ✅ No comment sections
- ✅ Clean, simple layout

## Testing Steps

### 1. Test Blog Listing
```
http://localhost:8080/your-app/blog
```
**Expected**: List of blog posts with links to individual posts

### 2. Test Individual Blog Post
```
http://localhost:8080/your-app/single-blog?postId=1
```
**Expected**: Display the blog post content without comments

### 3. Check Database
```sql
-- Verify blog posts exist
SELECT COUNT(*) FROM BlogPosts;
SELECT TOP 5 * FROM BlogPosts ORDER BY PublishedAt DESC;
```

## Common Issues & Solutions

### Issue 1: Cannot Access Blog Posts
**Symptoms**: Clicking on blog post links doesn't work
**Solutions**:
1. Check if `BlogDetailController` is properly mapped
2. Verify `single-blog.jsp` exists in web directory
3. Check server logs for errors

### Issue 2: Blog Post Not Found
**Symptoms**: Error message "Không tìm thấy bài viết"
**Solutions**:
1. Check if post ID exists in database
2. Verify `getPostById` method in `BlogPostDAO`
3. Check database connection

### Issue 3: Page Stays on Blog Listing
**Symptoms**: Clicking post link but page doesn't change
**Solutions**:
1. Check browser console for JavaScript errors
2. Verify URL mapping in `@WebServlet`
3. Check if there are any redirects or filters blocking access

## Expected Behavior

### Blog Listing Page (`/blog`)
- Shows list of blog posts
- Each post has a clickable title
- Pagination works
- Search and sort work

### Blog Detail Page (`/single-blog?postId=X`)
- Shows full blog post content
- Displays title, content, author, date
- Shows view count
- No comment sections
- Clean, simple layout

## Debug Commands

### 1. Check Server Logs
Look for errors in Tomcat logs:
- Connection errors
- SQL exceptions
- Servlet mapping errors

### 2. Test Database Connection
```sql
-- Basic connection test
SELECT 1 as test;
```

### 3. Test Blog Post Retrieval
```sql
-- Test specific post
SELECT * FROM BlogPosts WHERE PostID = 1;
```

### 4. Check File Structure
```
web/
├── blog.jsp ✅
├── single-blog.jsp ✅
└── WEB-INF/
    └── web.xml ✅
```

## Quick Fixes

### 1. Clear Browser Cache
- Press Ctrl+F5
- Clear browser cache and cookies

### 2. Restart Application
- Stop Tomcat
- Start Tomcat
- Redeploy application

### 3. Check URL Patterns
- BlogController: `/blog`
- BlogDetailController: `/single-blog`

### 4. Verify Database
- Ensure BlogPosts table exists
- Ensure it has data
- Check column names match DTO

## Success Indicators

✅ Blog listing page loads  
✅ Individual blog posts are clickable  
✅ Blog detail page shows content  
✅ No comment sections visible  
✅ Clean, simple layout  
✅ View count increments  
✅ No JavaScript errors  
✅ No server errors in logs 