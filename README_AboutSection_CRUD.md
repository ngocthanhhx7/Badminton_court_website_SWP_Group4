# AboutSection CRUD System

Hệ thống quản lý AboutSection hoàn chỉnh với đầy đủ tính năng CRUD, phân trang, tìm kiếm, lọc và upload ảnh.

## Tính năng chính

### 1. CRUD Operations
- **Create**: Thêm section mới với upload ảnh
- **Read**: Hiển thị danh sách với phân trang
- **Update**: Sửa section với preview ảnh
- **Delete**: Xóa section và ảnh liên quan
- **Toggle Status**: Bật/tắt trạng thái hoạt động

### 2. Advanced Features
- **Pagination**: Phân trang với SQL Server ROW_NUMBER()
- **Search**: Tìm kiếm theo tiêu đề
- **Filtering**: Lọc theo trạng thái và loại section
- **Sorting**: Sắp xếp theo các cột
- **File Upload**: Upload ảnh với validation
- **Image Preview**: Xem trước ảnh khi upload

### 3. Section Types
- `hero`: Section hero/banner chính
- `about`: Section giới thiệu
- `service`: Section dịch vụ
- `team`: Section đội ngũ

## Cấu trúc Database

### AboutSections Table
```sql
CREATE TABLE AboutSections (
    AboutID INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(255) NOT NULL,
    Subtitle NVARCHAR(500),
    Content NTEXT,
    Image1 NVARCHAR(500),
    Image2 NVARCHAR(500),
    SectionType NVARCHAR(50) NOT NULL,
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME2 DEFAULT GETDATE()
);
```

## Files chính

### 1. Java Files
- `AboutSectionDTO.java`: Model class
- `AboutSectionDAO.java`: Data Access Object
- `AboutManagerController.java`: Controller xử lý requests
- `FileUploadUtil.java`: Utility class cho upload file

### 2. JSP Files
- `about-manager.jsp`: Giao diện quản lý

### 3. SQL Files
- `create_about_sections_table.sql`: Tạo bảng và dữ liệu mẫu
- `setup_about_upload_directory.sql`: Hướng dẫn tạo thư mục upload
- `debug_sql_server_about.sql`: Script debug cho SQL Server

## Cài đặt

### 1. Database Setup
```bash
# Chạy script tạo bảng
sqlcmd -S your_server -d your_database -i create_about_sections_table.sql
```

### 2. Directory Setup
```bash
# Tạo thư mục upload
mkdir -p web/img/about/uploads/hero
mkdir -p web/img/about/uploads/about
mkdir -p web/img/about/uploads/service
mkdir -p web/img/about/uploads/team

# Set permissions (Linux/Unix)
chmod 755 web/img/about/uploads
chmod 755 web/img/about/uploads/*
```

### 3. Web.xml Configuration
Đảm bảo có servlet mapping cho AboutManagerController:
```xml
<servlet>
    <servlet-name>AboutManagerController</servlet-name>
    <servlet-class>controllerAdmin.AboutManagerController</servlet-class>
</servlet>
<servlet-mapping>
    <servlet-name>AboutManagerController</servlet-name>
    <url-pattern>/about-manager</url-pattern>
</servlet-mapping>
```

## Sử dụng

### 1. Truy cập
```
http://your-domain/about-manager
```

### 2. Thêm Section Mới
1. Click "Thêm mới Section"
2. Điền thông tin bắt buộc (Title, Content, SectionType)
3. Upload ảnh hoặc nhập đường dẫn
4. Click "Thêm"

### 3. Sửa Section
1. Click nút "Sửa" trên section cần sửa
2. Chỉnh sửa thông tin
3. Upload ảnh mới (nếu cần)
4. Click "Cập nhật"

### 4. Xóa Section
1. Click nút "Xóa" trên section cần xóa
2. Xác nhận xóa
3. Section và ảnh liên quan sẽ bị xóa

### 5. Toggle Status
1. Click badge trạng thái (Hoạt động/Không hoạt động)
2. Xác nhận thay đổi
3. Trạng thái sẽ được cập nhật

### 6. Tìm kiếm và Lọc
- **Tìm kiếm**: Nhập từ khóa vào ô "Tìm kiếm theo tiêu đề"
- **Lọc trạng thái**: Chọn "Hoạt động" hoặc "Không hoạt động"
- **Lọc loại**: Chọn loại section cụ thể
- **Sắp xếp**: Click header cột để sắp xếp

### 7. Phân trang
- Chọn số lượng hiển thị (5, 10, 20, 50)
- Sử dụng nút phân trang để di chuyển
- Thông tin hiển thị: "Hiển thị X - Y của Z section"

## Troubleshooting

### 1. Lỗi Upload Ảnh
**Triệu chứng**: Không upload được ảnh
**Giải pháp**:
- Kiểm tra quyền ghi thư mục upload
- Kiểm tra kích thước file (tối đa 5MB)
- Kiểm tra định dạng file (chỉ hỗ trợ ảnh)

### 2. Lỗi Database
**Triệu chứng**: Lỗi SQL hoặc không hiển thị dữ liệu
**Giải pháp**:
```bash
# Chạy script debug
sqlcmd -S your_server -d your_database -i debug_sql_server_about.sql
```

### 3. Lỗi Pagination
**Triệu chứng**: Phân trang không hoạt động
**Giải pháp**:
- Kiểm tra SQL Server version (cần SQL Server 2005+)
- Kiểm tra ROW_NUMBER() function
- Xem log lỗi trong console

### 4. Lỗi Toggle Status
**Triệu chứng**: Không toggle được trạng thái
**Giải pháp**:
- Kiểm tra cột IsActive trong database
- Kiểm tra SQL query toggle
- Xem debug log trong controller

### 5. Lỗi Edit Section
**Triệu chứng**: Không sửa được section
**Giải pháp**:
- Kiểm tra console browser cho JavaScript errors
- Kiểm tra form data được gửi
- Xem debug log trong controller

## Debug

### 1. Enable Debug Logging
Trong AboutManagerController, các debug log đã được thêm:
```java
System.out.println("DEBUG: Add section - title: " + title);
System.out.println("DEBUG: Edit section - sectionID: " + sectionIdStr);
```

### 2. Browser Console
Mở Developer Tools (F12) và xem Console tab:
```javascript
// Debug logs sẽ hiển thị khi:
// - Click edit button
// - Submit form
// - Upload image
```

### 3. Database Debug
Chạy script debug để kiểm tra database:
```bash
sqlcmd -S your_server -d your_database -i debug_sql_server_about.sql
```

## Security

### 1. Access Control
- Sử dụng `AccessControlUtil.hasManagerAccess()` để kiểm tra quyền
- Chỉ manager mới có thể truy cập

### 2. File Upload Security
- Validate file type (chỉ ảnh)
- Validate file size (tối đa 5MB)
- Generate unique filename
- Sanitize file path

### 3. SQL Injection Prevention
- Sử dụng PreparedStatement
- Validate sort parameters
- Escape user input

## Performance

### 1. Database Indexes
```sql
CREATE INDEX IX_AboutSections_SectionType ON AboutSections(SectionType);
CREATE INDEX IX_AboutSections_IsActive ON AboutSections(IsActive);
CREATE INDEX IX_AboutSections_CreatedAt ON AboutSections(CreatedAt);
CREATE INDEX IX_AboutSections_Title ON AboutSections(Title);
```

### 2. Pagination Optimization
- Sử dụng ROW_NUMBER() cho SQL Server
- Limit page size (tối đa 100)
- Efficient WHERE clauses

### 3. Image Optimization
- Compress uploaded images
- Generate thumbnails
- Use appropriate image formats

## API Endpoints

### GET /about-manager
- Hiển thị danh sách sections
- Hỗ trợ parameters: page, pageSize, searchTitle, statusFilter, sectionTypeFilter, sortBy, sortOrder

### POST /about-manager
- **action=add**: Thêm section mới
- **action=edit**: Sửa section
- **action=delete**: Xóa section
- **action=toggleStatus**: Toggle trạng thái

## Dependencies

### Required Libraries
- Jakarta Servlet API
- SQL Server JDBC Driver
- Lombok (for DTO)
- Bootstrap (for UI)
- jQuery (for JavaScript)

### Optional Libraries
- Image processing library (for image optimization)
- Logging framework (for production logging)

## Changelog

### Version 1.0.0
- Initial release
- Full CRUD functionality
- Pagination and search
- File upload support
- SQL Server compatibility

## Support

Nếu gặp vấn đề, hãy:
1. Kiểm tra debug logs
2. Chạy debug SQL script
3. Xem browser console
4. Kiểm tra file permissions
5. Verify database connection 