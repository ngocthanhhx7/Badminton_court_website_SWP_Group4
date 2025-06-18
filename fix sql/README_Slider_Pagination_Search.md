# Slider Manager - Tính năng Phân trang, Sắp xếp, Lọc và Tìm kiếm (SQL Server)

## Tổng quan
Đã thêm các tính năng nâng cao cho Slider Manager bao gồm phân trang, sắp xếp theo nhiều tiêu chí, lọc theo trạng thái và tìm kiếm theo tiêu đề. Hệ thống sử dụng SQL Server.

## Các tính năng mới

### ✅ **Phân trang (Pagination)**
- **Hiển thị**: 5, 10, 20, 50 slider mỗi trang
- **Điều hướng**: Nút Trước/Sau và số trang
- **Thông tin**: Hiển thị vị trí bản ghi hiện tại
- **Responsive**: Tự động ẩn/hiện nút phân trang
- **SQL Server**: Sử dụng ROW_NUMBER() OVER() cho pagination

### ✅ **Sắp xếp (Sorting)**
- **Cột có thể sắp xếp**: ID, Tiêu đề, Vị trí, Trạng thái, Ngày tạo
- **Hướng sắp xếp**: Tăng dần (ASC) / Giảm dần (DESC)
- **Icon trực quan**: Mũi tên chỉ hướng sắp xếp
- **Mặc định**: Sắp xếp theo ID giảm dần

### ✅ **Lọc (Filtering)**
- **Trạng thái**: Tất cả, Hoạt động, Không hoạt động
- **Kết hợp**: Có thể lọc kết hợp với tìm kiếm
- **Reset**: Nút "Làm mới" để xóa tất cả bộ lọc

### ✅ **Tìm kiếm (Search)**
- **Tìm theo tiêu đề**: Tìm kiếm không phân biệt hoa thường
- **Từ khóa**: Hỗ trợ tìm kiếm một phần từ khóa
- **Kết hợp**: Có thể kết hợp với bộ lọc trạng thái

## Cách sử dụng

### Tìm kiếm và Lọc
1. **Tìm kiếm theo tiêu đề**:
   - Nhập từ khóa vào ô "Tìm kiếm theo tiêu đề"
   - Click "Tìm kiếm" hoặc nhấn Enter

2. **Lọc theo trạng thái**:
   - Chọn "Hoạt động" để chỉ hiển thị slider đang hoạt động
   - Chọn "Không hoạt động" để chỉ hiển thị slider bị ẩn
   - Chọn "Tất cả" để hiển thị tất cả slider

3. **Thay đổi số lượng hiển thị**:
   - Chọn số lượng slider muốn hiển thị mỗi trang
   - Tự động reload với số lượng mới

### Sắp xếp
1. **Click vào header cột** để sắp xếp
2. **Click lần đầu**: Sắp xếp tăng dần
3. **Click lần hai**: Sắp xếp giảm dần
4. **Icon mũi tên** chỉ hướng sắp xếp hiện tại

### Phân trang
1. **Nút Trước/Sau**: Di chuyển giữa các trang
2. **Số trang**: Click trực tiếp vào số trang
3. **Thông tin**: Hiển thị vị trí bản ghi hiện tại
4. **Dấu "..."**: Hiển thị khi có nhiều trang

## Thông số kỹ thuật

### URL Parameters
- `page`: Số trang hiện tại
- `pageSize`: Số lượng bản ghi mỗi trang
- `searchTitle`: Từ khóa tìm kiếm
- `statusFilter`: Bộ lọc trạng thái (active/inactive)
- `sortBy`: Cột sắp xếp
- `sortOrder`: Hướng sắp xếp (ASC/DESC)

### Ví dụ URL
```
slider-manager?page=2&pageSize=10&searchTitle=banner&statusFilter=active&sortBy=Title&sortOrder=ASC
```

### Giới hạn
- **Page size**: Tối đa 100 bản ghi mỗi trang
- **Search**: Không giới hạn độ dài từ khóa
- **Sort fields**: Chỉ cho phép các cột được định nghĩa

## Database Queries (SQL Server)

### Count Query
```sql
SELECT COUNT(*) FROM Sliders 
WHERE (? IS NULL OR IsActive = ?) 
AND (? IS NULL OR Title LIKE ?)
```

### Filtered Query với Pagination
```sql
SELECT * FROM (
    SELECT ROW_NUMBER() OVER (ORDER BY [sortField] [sortOrder]) AS RowNum, * 
    FROM Sliders 
    WHERE (? IS NULL OR IsActive = ?) 
    AND (? IS NULL OR Title LIKE ?)
) AS PagedResults 
WHERE RowNum BETWEEN ? AND ?
```

### Toggle Status Query
```sql
UPDATE Sliders SET IsActive = ~IsActive WHERE SliderID = ?
```

## Bảo mật

### SQL Injection Prevention
- **Parameterized queries**: Sử dụng PreparedStatement
- **Field validation**: Chỉ cho phép các trường sắp xếp hợp lệ
- **Input sanitization**: Làm sạch dữ liệu đầu vào

### XSS Prevention
- **Output encoding**: Sử dụng JSTL để encode output
- **Input validation**: Kiểm tra dữ liệu đầu vào

## Performance

### Optimization
- **Indexing**: Đảm bảo có index trên các cột sắp xếp
- **Pagination**: Chỉ load dữ liệu cần thiết
- **Caching**: Có thể cache kết quả tìm kiếm

### Recommended Indexes (SQL Server)
```sql
-- Tạo index cho cột Title (tìm kiếm)
CREATE INDEX idx_sliders_title ON Sliders(Title);

-- Tạo index cho cột IsActive (lọc theo trạng thái)
CREATE INDEX idx_sliders_isactive ON Sliders(IsActive);

-- Tạo index cho cột Position (sắp xếp theo vị trí)
CREATE INDEX idx_sliders_position ON Sliders(Position);

-- Tạo index cho cột CreatedAt (sắp xếp theo ngày tạo)
CREATE INDEX idx_sliders_createdat ON Sliders(CreatedAt);

-- Tạo composite index cho tìm kiếm kết hợp
CREATE INDEX idx_sliders_title_isactive ON Sliders(Title, IsActive);
```

## Troubleshooting

### Lỗi thường gặp

1. **Không hiển thị dữ liệu**:
   - Kiểm tra kết nối database
   - Kiểm tra quyền truy cập bảng Sliders
   - Kiểm tra dữ liệu trong bảng

2. **Phân trang không hoạt động**:
   - Kiểm tra tham số page và pageSize
   - Kiểm tra JavaScript console
   - Kiểm tra URL parameters

3. **Tìm kiếm không kết quả**:
   - Kiểm tra từ khóa tìm kiếm
   - Kiểm tra encoding của database
   - Kiểm tra cấu trúc bảng

4. **Sắp xếp không đúng**:
   - Kiểm tra tên cột trong database
   - Kiểm tra quyền truy cập
   - Kiểm tra SQL query

5. **Lỗi SQL Server**:
   - Kiểm tra cú pháp SQL Server
   - Kiểm tra version SQL Server
   - Kiểm tra quyền thực thi query

### Debug Information
- **Console logs**: Kiểm tra JavaScript console
- **Server logs**: Kiểm tra log của server
- **Database logs**: Kiểm tra log của SQL Server

## Cấu hình

### Default Values
- **Page size**: 10 bản ghi
- **Sort by**: SliderID
- **Sort order**: DESC
- **Status filter**: Tất cả
- **Search**: Không có

### Customization
Có thể thay đổi các giá trị mặc định trong:
- `SliderManagerController.java`: Thay đổi default values
- `slider-manager.jsp`: Thay đổi UI options
- `SliderDAO.java`: Thay đổi SQL queries

## SQL Server Specific

### Data Types
- **Title**: NVARCHAR(255) - Hỗ trợ Unicode
- **Subtitle**: NTEXT - Text dài với Unicode
- **BackgroundImage**: NVARCHAR(500) - Đường dẫn ảnh
- **Position**: INT - Vị trí sắp xếp
- **IsActive**: BIT - Trạng thái hoạt động (1/0)
- **CreatedAt**: DATETIME - Thời gian tạo

### Identity Column
```sql
SliderID INT IDENTITY(1,1) PRIMARY KEY
```

### Default Values
```sql
IsActive BIT DEFAULT 1
CreatedAt DATETIME DEFAULT GETDATE()
```

## Best Practices

### Performance
- Sử dụng page size phù hợp (10-20 bản ghi)
- Tạo index cho các cột thường xuyên tìm kiếm
- Cache kết quả tìm kiếm phổ biến
- Sử dụng ROW_NUMBER() cho pagination hiệu quả

### UX
- Hiển thị loading indicator khi tìm kiếm
- Giữ lại các tham số khi chuyển trang
- Hiển thị thông tin rõ ràng về kết quả

### Security
- Validate tất cả input parameters
- Sử dụng parameterized queries
- Kiểm tra quyền truy cập
- Escape output để tránh XSS 