-- SQL Server script to create AboutSections table
-- Run this script in your SQL Server database

-- Check if table exists and drop it
IF OBJECT_ID('AboutSections', 'U') IS NOT NULL
    DROP TABLE AboutSections;
GO

-- Create AboutSections table
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
GO

-- Insert sample data
INSERT INTO AboutSections (Title, Subtitle, Content, Image1, Image2, SectionType, IsActive, CreatedAt) VALUES
('Chào mừng đến với chúng tôi', 'Dịch vụ chất lượng cao', 'Chúng tôi cung cấp các dịch vụ chất lượng cao với đội ngũ chuyên nghiệp và giàu kinh nghiệm. Cam kết mang đến sự hài lòng tuyệt đối cho khách hàng.', '/img/about/hero_1.jpg', '/img/about/hero_2.jpg', 'hero', 1, GETDATE()),
('Về chúng tôi', 'Đội ngũ chuyên nghiệp', 'Với hơn 10 năm kinh nghiệm trong lĩnh vực, chúng tôi tự hào là đối tác tin cậy của nhiều doanh nghiệp lớn. Đội ngũ nhân viên được đào tạo bài bản, luôn sẵn sàng phục vụ khách hàng.', '/img/about/about_1.jpg', '/img/about/about_2.jpg', 'about', 1, GETDATE()),
('Dịch vụ của chúng tôi', 'Đa dạng và chất lượng', 'Chúng tôi cung cấp đa dạng các dịch vụ từ tư vấn, thiết kế đến triển khai và bảo trì. Mỗi dịch vụ đều được thực hiện với tiêu chuẩn chất lượng cao nhất.', '/img/about/service_1.jpg', '/img/about/service_2.jpg', 'service', 1, GETDATE()),
('Đội ngũ nhân viên', 'Chuyên nghiệp và tận tâm', 'Đội ngũ nhân viên của chúng tôi bao gồm các chuyên gia có trình độ cao, giàu kinh nghiệm và luôn tận tâm với công việc. Chúng tôi cam kết mang đến những giải pháp tốt nhất cho khách hàng.', '/img/about/team_1.jpg', '/img/about/team_2.jpg', 'team', 1, GETDATE());
GO

-- Create indexes for better performance
CREATE INDEX IX_AboutSections_SectionType ON AboutSections(SectionType);
CREATE INDEX IX_AboutSections_IsActive ON AboutSections(IsActive);
CREATE INDEX IX_AboutSections_CreatedAt ON AboutSections(CreatedAt);
CREATE INDEX IX_AboutSections_Title ON AboutSections(Title);
GO

-- Verify the table creation
SELECT * FROM AboutSections;
GO

PRINT 'AboutSections table created successfully with sample data!'; 