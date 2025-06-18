# Debug Guide: Blog Access Issue

## Problem Description
User can access the blog listing page but cannot navigate to individual blog post details.

## Root Cause Analysis

### 1. Session Check Issue (FIXED)
- **Problem**: `single-blog.jsp` had mandatory login check that redirected to Login.jsp
- **Solution**: Removed mandatory login requirement, made it optional for comments only
- **Status**: ✅ Fixed

### 2. Potential Issues to Check

#### A. Database Issues
```sql
-- Check if blog posts exist
SELECT COUNT(*) FROM BlogPosts;
SELECT TOP 5 * FROM BlogPosts ORDER BY PublishedAt DESC;
```

#### B. URL Mapping Issues
- BlogController: `@WebServlet("/blog")` ✅
- BlogDetailController: `@WebServlet("/single-blog")` ✅

#### C. JSP File Issues
- Check if `single-blog.jsp` exists in web directory
- Verify file permissions

#### D. Server Configuration
- Check if Tomcat is running properly
- Verify application deployment

## Testing Steps

### 1. Test Blog Listing
```
http://localhost:8080/your-app/blog
```
Expected: Should show list of blog posts

### 2. Test Individual Blog Post
```
http://localhost:8080/your-app/single-blog?postId=1
```
Expected: Should show blog post details

### 3. Check Browser Console
- Open Developer Tools (F12)
- Check for JavaScript errors
- Check Network tab for failed requests

### 4. Check Server Logs
- Look for error messages in Tomcat logs
- Check for SQL exceptions

## Common Solutions

### 1. Clear Browser Cache
- Press Ctrl+F5 to force refresh
- Clear browser cache and cookies

### 2. Restart Application
- Stop and restart Tomcat
- Redeploy the application

### 3. Check Database Connection
- Verify database is running
- Check connection string in DBUtils

### 4. Verify File Structure
```
web/
├── blog.jsp ✅
├── single-blog.jsp ✅
└── WEB-INF/
    └── web.xml ✅
```

## Debug Commands

### 1. Test Database Connection
```sql
-- Test basic query
SELECT 1 as test;
```

### 2. Test Blog Post Retrieval
```sql
-- Test getPostById method
SELECT * FROM BlogPosts WHERE PostID = 1;
```

### 3. Test Pagination
```sql
-- Test getPostsByPage method
SELECT * FROM BlogPosts 
WHERE Title LIKE '%' 
ORDER BY PublishedAt DESC 
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;
```

## Expected Behavior After Fix

1. **Blog Listing Page**: Shows all blog posts with links
2. **Blog Detail Page**: Shows individual post content
3. **Comments**: Shows existing comments
4. **Comment Form**: Shows for logged users, login prompt for others
5. **Navigation**: Back to blog listing works

## If Still Not Working

1. Check if the issue is with specific post IDs
2. Verify all required fields in BlogPosts table
3. Check if there are any JavaScript conflicts
4. Test with different browsers
5. Check server error logs for specific exceptions 