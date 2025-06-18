# Debug Guide for Instagram CRUD Issues

## Common Issues and Solutions

### 1. Modal Not Opening
**Problem**: Add/Edit modals don't open when clicking buttons
**Solution**: 
- Check if Bootstrap JS is loaded properly
- Verify modal IDs match the data-target attributes
- Check browser console for JavaScript errors

### 2. Form Submission Issues
**Problem**: Forms submit but data doesn't save
**Solution**:
- Check if action parameter is being sent correctly
- Verify all required fields are filled
- Check server logs for SQL errors
- Ensure database table exists

### 3. Checkbox Handling
**Problem**: Checkbox values not being processed correctly
**Solution**:
- Checkbox sends "on" when checked, null when unchecked
- Use proper boolean conversion in controller
- Test with both checked and unchecked states

### 4. Database Connection Issues
**Problem**: SQL errors or connection failures
**Solution**:
- Verify database connection settings
- Check if InstagramFeeds table exists
- Run the create_instagram_feeds_table.sql script
- Test connection with simple query

## Testing Steps

### 1. Database Setup
```sql
-- Run this to create the table
EXEC create_instagram_feeds_table.sql

-- Check if table exists
SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'InstagramFeeds'
```

### 2. Test Basic Operations
```sql
-- Test insert
INSERT INTO InstagramFeeds (ImageUrl, InstagramLink, DisplayOrder, IsVisible, CreatedAt)
VALUES ('https://example.com/image.jpg', 'https://instagram.com/p/test/', 1, 1, GETDATE())

-- Test select
SELECT * FROM InstagramFeeds

-- Test update
UPDATE InstagramFeeds SET IsVisible = 0 WHERE FeedID = 1

-- Test delete
DELETE FROM InstagramFeeds WHERE FeedID = 1
```

### 3. Controller Debug
Add debug logging to controller:
```java
System.out.println("Action: " + action);
System.out.println("ImageUrl: " + request.getParameter("imageUrl"));
System.out.println("InstagramLink: " + request.getParameter("instagramLink"));
System.out.println("IsVisible: " + request.getParameter("isVisible"));
```

### 4. JSP Debug
Add debug output to JSP:
```jsp
<!-- Debug info -->
<div style="background: #f0f0f0; padding: 10px; margin: 10px;">
    <h5>Debug Info:</h5>
    <p>Feeds count: ${feeds.size()}</p>
    <p>Current page: ${currentPage}</p>
    <p>Total pages: ${totalPages}</p>
    <p>Search: ${search}</p>
    <p>Visible: ${visible}</p>
</div>
```

## Common Error Messages

### 1. "Invalid action parameter"
- Check if action field is present in form
- Verify action value matches case in switch statement

### 2. "Failed to add Instagram feed"
- Check database connection
- Verify table structure
- Check for SQL syntax errors

### 3. "NumberFormatException"
- Check if numeric fields contain valid numbers
- Verify form field names match controller expectations

### 4. "NullPointerException"
- Check if required parameters are present
- Verify checkbox handling for null values

## Browser Console Debug
Add this JavaScript to check form data:
```javascript
// Debug form submission
$('form').on('submit', function(e) {
    console.log('Form data:', $(this).serialize());
    console.log('Form action:', $(this).attr('action'));
    console.log('Form method:', $(this).attr('method'));
});
```

## Server Log Debug
Check server logs for:
- SQL exceptions
- Servlet exceptions
- Connection pool issues
- Parameter parsing errors 