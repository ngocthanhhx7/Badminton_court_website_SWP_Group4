# Instagram Feed CRUD System

## Overview
Complete CRUD (Create, Read, Update, Delete) system for managing Instagram feeds in the travel website admin panel.

## Features
- ✅ Add new Instagram feeds
- ✅ Edit existing feeds
- ✅ Delete feeds
- ✅ Toggle visibility status
- ✅ Manage display order
- ✅ Search and filter feeds
- ✅ Pagination support
- ✅ Preview grid
- ✅ Responsive design

## Setup Instructions

### 1. Database Setup
Run the SQL script to create the InstagramFeeds table:
```sql
-- Execute this script in your SQL Server database
EXEC create_instagram_feeds_table.sql
```

### 2. File Structure
```
src/java/
├── dao/
│   └── InstagramFeedDAO.java          # Data access layer
├── controllerAdmin/
│   └── InstagramManagerController.java # Controller for admin operations
└── models/
    └── InstagramFeedDTO.java          # Data transfer object

web/
└── instagram-manager.jsp              # Admin interface

SQL Files:
├── create_instagram_feeds_table.sql   # Database setup
├── test_instagram_crud.sql           # Test queries
└── debug_instagram_crud.md           # Debug guide
```

### 3. Access the System
Navigate to: `http://your-domain/instagram-manager`

## Usage Guide

### Adding a New Feed
1. Click "Add New Feed" button
2. Fill in the required fields:
   - **Image URL**: Direct link to the Instagram image
   - **Instagram Link**: Link to the Instagram post
   - **Visible**: Check to make the feed visible on the website
3. Click "Add Feed"

### Editing a Feed
1. Click "Edit" button on any feed row
2. Modify the fields as needed
3. Click "Save Changes"

### Managing Visibility
- Click the "Visible/Hidden" button to toggle status
- Visible feeds appear on the website
- Hidden feeds are stored but not displayed

### Managing Display Order
- Change the number in the "Display Order" field
- Feeds are sorted by this number (ascending)
- Lower numbers appear first

### Search and Filter
- Use the search box to find feeds by image URL or Instagram link
- Use the dropdown to filter by visibility status
- Results are paginated for better performance

## Troubleshooting

### Common Issues

#### 1. Modal Not Opening
**Problem**: Add/Edit buttons don't open modals
**Solution**: 
- Check browser console for JavaScript errors
- Verify Bootstrap JS is loaded
- Check if modal IDs match data-target attributes

#### 2. Form Submission Fails
**Problem**: Forms submit but data doesn't save
**Solution**:
- Check server logs for error messages
- Verify database table exists
- Check if all required fields are filled
- Ensure proper database connection

#### 3. Checkbox Issues
**Problem**: Visibility toggle doesn't work
**Solution**:
- Checkbox sends "on" when checked, null when unchecked
- Controller properly handles both cases
- Test with both checked and unchecked states

#### 4. Database Errors
**Problem**: SQL exceptions or connection failures
**Solution**:
- Run the database setup script
- Check database connection settings
- Verify table structure matches DTO fields

### Debug Steps

#### 1. Check Server Logs
Look for debug output in server console:
```
=== Instagram Manager Debug ===
Action: add
ImageUrl: https://example.com/image.jpg
InstagramLink: https://instagram.com/p/test/
IsVisible: on
FeedId: null
DisplayOrder: null
===============================
```

#### 2. Database Verification
Run these queries to check database status:
```sql
-- Check if table exists
SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'InstagramFeeds'

-- Check table structure
SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'InstagramFeeds'

-- Check current data
SELECT * FROM InstagramFeeds ORDER BY DisplayOrder ASC
```

#### 3. Browser Console Debug
Add this JavaScript to check form data:
```javascript
// Debug form submissions
$('form').on('submit', function(e) {
    console.log('Form data:', $(this).serialize());
    console.log('Form action:', $(this).attr('action'));
});
```

## Technical Details

### Database Schema
```sql
CREATE TABLE InstagramFeeds (
    FeedID INT IDENTITY(1,1) PRIMARY KEY,
    ImageUrl NVARCHAR(1000) NOT NULL,
    InstagramLink NVARCHAR(1000) NOT NULL,
    DisplayOrder INT DEFAULT 0,
    IsVisible BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE()
);
```

### Key Methods

#### InstagramFeedDAO
- `getAllFeeds(page, pageSize, searchKeyword, isVisible)` - Get paginated feeds with filters
- `addFeed(feed)` - Add new feed with auto-generated display order
- `updateFeed(feed)` - Update existing feed
- `deleteFeed(id)` - Delete feed by ID
- `toggleVisibility(id)` - Toggle visibility status
- `updateDisplayOrder(id, newOrder)` - Update display order

#### InstagramManagerController
- `doGet()` - Display feeds with pagination and filters
- `doPost()` - Handle CRUD operations
- `handleAddFeed()` - Process add operation
- `handleUpdateFeed()` - Process update operation
- `handleDeleteFeed()` - Process delete operation

### Security Features
- Access control using `AccessControlUtil.hasManagerAccess()`
- Input validation and sanitization
- SQL injection prevention with prepared statements
- Session-based messaging for user feedback

### Performance Optimizations
- Pagination to handle large datasets
- Database indexes on frequently queried columns
- Efficient SQL queries with proper joins
- Resource cleanup with try-with-resources

## File Descriptions

### Core Files
- **InstagramFeedDAO.java**: Data access layer with all database operations
- **InstagramManagerController.java**: Servlet controller handling HTTP requests
- **InstagramFeedDTO.java**: Data transfer object for Instagram feed data
- **instagram-manager.jsp**: Admin interface with Bootstrap UI

### Support Files
- **create_instagram_feeds_table.sql**: Database setup script
- **test_instagram_crud.sql**: Test queries for verification
- **debug_instagram_crud.md**: Comprehensive debug guide
- **README_Instagram_CRUD.md**: This documentation file

## Dependencies
- Java Servlet API (Jakarta)
- SQL Server JDBC Driver
- Bootstrap CSS/JS
- jQuery
- Lombok (for DTO)

## Browser Support
- Chrome (recommended)
- Firefox
- Safari
- Edge

## Version History
- v1.0: Initial implementation with basic CRUD
- v1.1: Added pagination and search
- v1.2: Added visibility toggle and display order management
- v1.3: Added preview grid and improved UI 