-- SQL Server script to create Offers table with sample data
-- Run this script in your SQL Server database

-- Create Offers table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Offers' AND xtype='U')
BEGIN
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
    
    PRINT 'Offers table created successfully.';
END
ELSE
BEGIN
    PRINT 'Offers table already exists.';
END

-- Create indexes for better performance
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Offers_IsActive')
BEGIN
    CREATE INDEX IX_Offers_IsActive ON Offers(IsActive);
    PRINT 'Index IX_Offers_IsActive created.';
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Offers_IsVIP')
BEGIN
    CREATE INDEX IX_Offers_IsVIP ON Offers(IsVIP);
    PRINT 'Index IX_Offers_IsVIP created.';
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Offers_CreatedAt')
BEGIN
    CREATE INDEX IX_Offers_CreatedAt ON Offers(CreatedAt);
    PRINT 'Index IX_Offers_CreatedAt created.';
END

-- Insert sample data
IF NOT EXISTS (SELECT * FROM Offers WHERE Title = 'Gói Du Lịch Hà Nội - Sapa')
BEGIN
    INSERT INTO Offers (Title, Subtitle, Description, ImageUrl, Capacity, IsVIP, IsActive, CreatedAt) VALUES
    (N'Gói Du Lịch Hà Nội - Sapa', N'Khám phá vẻ đẹp miền Bắc', N'Chuyến du lịch 3 ngày 2 đêm khám phá Hà Nội và Sapa với những trải nghiệm tuyệt vời về văn hóa và cảnh đẹp miền núi phía Bắc.', '/img/offers/hanoi_sapa.jpg', 20, 0, 1, GETDATE()),
    (N'Du Lịch Đà Nẵng - Hội An', N'Di sản văn hóa thế giới', N'Hành trình 4 ngày 3 đêm khám phá Đà Nẵng và phố cổ Hội An - di sản văn hóa thế giới được UNESCO công nhận.', '/img/offers/danang_hoian.jpg', 25, 0, 1, GETDATE()),
    (N'Gói VIP Phú Quốc', N'Thiên đường biển đảo', N'Chuyến du lịch cao cấp 5 ngày 4 đêm tại đảo ngọc Phú Quốc với dịch vụ 5 sao và những trải nghiệm độc đáo.', '/img/offers/phuquoc_vip.jpg', 15, 1, 1, GETDATE()),
    (N'Du Lịch Nha Trang', N'Thành phố biển xinh đẹp', N'Chuyến du lịch 3 ngày 2 đêm tại Nha Trang với những bãi biển đẹp và các hoạt động giải trí dưới nước.', '/img/offers/nhatrang.jpg', 30, 0, 1, GETDATE()),
    (N'Gói VIP Đà Lạt', N'Thành phố ngàn hoa', N'Chuyến du lịch cao cấp 4 ngày 3 đêm tại Đà Lạt với khí hậu mát mẻ và những địa điểm check-in đẹp.', '/img/offers/dalat_vip.jpg', 12, 1, 1, GETDATE()),
    (N'Du Lịch Huế', N'Cố đô lịch sử', N'Chuyến du lịch 2 ngày 1 đêm khám phá Huế với những di tích lịch sử và văn hóa đặc trưng của miền Trung.', '/img/offers/hue.jpg', 35, 0, 1, GETDATE()),
    (N'Gói Du Lịch Mũi Né', N'Thiên đường cát trắng', N'Chuyến du lịch 3 ngày 2 đêm tại Mũi Né với những đồi cát đẹp và các hoạt động thể thao mạo hiểm.', '/img/offers/muine.jpg', 18, 0, 0, GETDATE()),
    (N'Du Lịch Cần Thơ', N'Miền Tây sông nước', N'Chuyến du lịch 2 ngày 1 đêm khám phá miền Tây sông nước với những chợ nổi và văn hóa đặc trưng.', '/img/offers/cantho.jpg', 22, 0, 1, GETDATE()),
    (N'Gói VIP Hạ Long', N'Vịnh di sản thiên nhiên', N'Chuyến du lịch cao cấp 3 ngày 2 đêm trên vịnh Hạ Long với du thuyền 5 sao và dịch vụ đẳng cấp.', '/img/offers/halong_vip.jpg', 10, 1, 1, GETDATE()),
    (N'Du Lịch Vũng Tàu', N'Thành phố biển gần Sài Gòn', N'Chuyến du lịch 2 ngày 1 đêm tại Vũng Tàu với những bãi biển đẹp và ẩm thực hải sản tươi ngon.', '/img/offers/vungtau.jpg', 28, 0, 1, GETDATE());
    
    PRINT 'Sample data inserted successfully.';
END
ELSE
BEGIN
    PRINT 'Sample data already exists.';
END

-- Display the created data
SELECT 
    OfferID,
    Title,
    Subtitle,
    LEFT(Description, 50) + '...' as DescriptionPreview,
    ImageUrl,
    Capacity,
    CASE WHEN IsVIP = 1 THEN 'VIP' ELSE 'Thường' END as Type,
    CASE WHEN IsActive = 1 THEN 'Hoạt động' ELSE 'Không hoạt động' END as Status,
    CreatedAt
FROM Offers
ORDER BY OfferID;

PRINT 'Offers table setup completed successfully!'; 