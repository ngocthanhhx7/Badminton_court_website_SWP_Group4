# Offer CRUD System - Hướng dẫn sử dụng

## Tổng quan
Hệ thống quản lý Offers (Gói du lịch) cung cấp đầy đủ chức năng CRUD với các tính năng nâng cao như phân trang, tìm kiếm, lọc, sắp xếp và upload ảnh.

## Tính năng chính

### 1. CRUD Operations
- **Create**: Thêm offer mới với upload ảnh
- **Read**: Xem danh sách offers với phân trang
- **Update**: Chỉnh sửa offer với preview ảnh
- **Delete**: Xóa offer và ảnh liên quan

### 2. Advanced Features
- **Pagination**: Phân trang với navigation
- **Search**: Tìm kiếm theo tiêu đề
- **Filtering**: Lọc theo trạng thái và loại VIP
- **Sorting**: Sắp xếp theo nhiều cột
- **File Upload**: Upload ảnh với preview
- **Status Toggle**: Bật/tắt trạng thái hoạt động

### 3. Security & Validation
- Phân quyền truy cập (Manager only)
- Validation dữ liệu đầu vào
- Sanitize file upload
- SQL injection prevention

## Cài đặt

### 1. Database Setup
```sql
-- Chạy script tạo bảng
EXEC create_offers_table.sql
```

### 2. Upload Directory Setup
```bash
# Tạo thư mục upload
mkdir -p web/img/offers/

# Set permissions (Linux/Unix)
chmod 755 web/img/offers/
chown www-data:www-data web/img/offers/

# Windows: Set IIS_IUSRS permissions
```

### 3. File Structure
```
src/java/
├── controllerAdmin/
│   └── OfferManagerController.java
├── dao/
│   └── OfferDAO.java
├── models/
│   └── OfferDTO.java
└── utils/
    └── FileUploadUtil.java

web/
├── offer-manager.jsp
└── img/
    └── offers/
```

## Sử dụng

### 1. Truy cập
```
URL: /offer-manager
Role: Manager
```

### 2. Thêm Offer Mới
1. Click "Thêm mới Offer"
2. Điền thông tin bắt buộc:
   - Tiêu đề (*)
   - Mô tả (*)
   - Sức chứa (*)
3. Upload ảnh hoặc nhập URL
4. Chọn loại VIP (tùy chọn)
5. Click "Thêm"

### 3. Chỉnh sửa Offer
1. Click "Sửa" trên offer cần chỉnh sửa
2. Modal sẽ hiển thị thông tin hiện tại
3. Thay đổi thông tin cần thiết
4. Upload ảnh mới (tùy chọn)
5. Click "Cập nhật"

### 4. Xóa Offer
1. Click "Xóa" trên offer cần xóa
2. Xác nhận trong dialog
3. Offer và ảnh liên quan sẽ bị xóa

### 5. Toggle Status
1. Click badge trạng thái
2. Xác nhận thay đổi
3. Trạng thái sẽ được cập nhật

### 6. Tìm kiếm & Lọc
- **Tìm kiếm**: Nhập từ khóa vào ô tìm kiếm
- **Lọc trạng thái**: Chọn "Hoạt động" hoặc "Không hoạt động"
- **Lọc loại**: Chọn "VIP" hoặc "Thường"
- **Sắp xếp**: Click header cột để sắp xếp
- **Phân trang**: Sử dụng navigation ở cuối bảng

## Database Schema

### Offers Table
```sql
CREATE TABLE Offers (
    OfferID INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(255) NOT NULL,
    Subtitle NVARCHAR(255),
    Description NTEXT,
    ImageUrl NVARCHAR(500),
    Capacity INT NOT NULL DEFAULT 0,
    IsVIP BIT NOT NULL DEFAULT 0,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME2 DEFAULT GETDATE()
);
```

### Indexes
- `IX_Offers_IsActive` - Performance cho filter trạng thái
- `IX_Offers_IsVIP` - Performance cho filter VIP
- `IX_Offers_CreatedAt` - Performance cho sorting

## API Endpoints

### GET /offer-manager
- **Purpose**: Hiển thị danh sách offers
- **Parameters**:
  - `page`: Số trang (default: 1)
  - `pageSize`: Số lượng/trang (default: 10)
  - `searchTitle`: Từ khóa tìm kiếm
  - `statusFilter`: Lọc trạng thái (active/inactive)
  - `vipFilter`: Lọc loại (vip/normal)
  - `sortBy`: Cột sắp xếp
  - `sortOrder`: Thứ tự (ASC/DESC)

### POST /offer-manager
- **Purpose**: Thực hiện CRUD operations
- **Parameters**:
  - `action`: Loại action (add/edit/delete/toggleStatus)
  - `offerID`: ID offer (cho edit/delete/toggleStatus)
  - `title`: Tiêu đề offer
  - `subtitle`: Subtitle
  - `description`: Mô tả
  - `capacity`: Sức chứa
  - `isVIP`: Loại VIP
  - `imageFile`: File ảnh upload
  - `imageUrl`: URL ảnh

## Troubleshooting

### 1. Lỗi Upload Ảnh
**Triệu chứng**: Không upload được ảnh
**Nguyên nhân**: 
- Thư mục upload không có quyền ghi
- File quá lớn (>5MB)
- Định dạng file không hỗ trợ

**Giải pháp**:
```bash
# Kiểm tra quyền thư mục
ls -la web/img/offers/

# Set quyền ghi
chmod 755 web/img/offers/
chown www-data:www-data web/img/offers/
```

### 2. Lỗi Database
**Triệu chứng**: Không kết nối được database
**Giải pháp**:
```sql
-- Chạy debug script
EXEC debug_offers_sql_server.sql
```

### 3. Lỗi Pagination
**Triệu chứng**: Phân trang không hoạt động
**Nguyên nhân**: SQL Server syntax
**Giải pháp**: Đảm bảo sử dụng `ROW_NUMBER() OVER()` thay vì `LIMIT`

### 4. Lỗi Session Messages
**Triệu chứng**: Thông báo không hiển thị
**Giải pháp**: Kiểm tra session configuration trong web.xml

## Debug & Logging

### 1. Console Logs
Controller có debug logs:
```java
System.out.println("DEBUG: Add offer - title: " + title);
```

### 2. Database Debug
```sql
-- Chạy debug script
EXEC debug_offers_sql_server.sql
```

### 3. Browser Console
JavaScript có debug logs:
```javascript
console.log('DEBUG: Edit button clicked');
```

## Performance Optimization

### 1. Database
- Sử dụng indexes cho các cột thường query
- Limit page size (max 100)
- Use pagination cho large datasets

### 2. File Upload
- Validate file size (max 5MB)
- Compress images before storage
- Use CDN for static assets

### 3. Caching
- Enable browser caching cho images
- Consider Redis for session storage
- Use connection pooling

## Security Considerations

### 1. File Upload
- Validate file types (only images)
- Sanitize filenames
- Use unique filenames
- Limit file size

### 2. SQL Injection
- Use PreparedStatement
- Validate sort parameters
- Sanitize search keywords

### 3. Access Control
- Check manager permissions
- Validate session
- Use CSRF protection

## Maintenance

### 1. Regular Tasks
- Backup database
- Clean up old images
- Monitor disk space
- Check error logs

### 2. Performance Monitoring
- Monitor query performance
- Check file upload success rate
- Track user activity

### 3. Updates
- Keep dependencies updated
- Monitor security patches
- Backup before updates

## Support

### 1. Common Issues
- Check browser console for JavaScript errors
- Verify database connection
- Test file upload permissions
- Review server logs

### 2. Debug Tools
- Browser Developer Tools
- Database Management Studio
- Server log files
- Debug SQL scripts

### 3. Contact
- Review error messages carefully
- Check debug logs
- Test with sample data
- Verify configuration

## Changelog

### Version 1.0.0
- Initial release
- Full CRUD functionality
- Pagination, search, filter
- File upload support
- SQL Server compatibility
- Security features
- Debug tools 