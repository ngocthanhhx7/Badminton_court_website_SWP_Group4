-- Create Videos table
CREATE TABLE Videos (
    VideoID INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(255) NOT NULL,
    Subtitle NVARCHAR(500),
    VideoUrl NVARCHAR(1000) NOT NULL,
    ThumbnailUrl NVARCHAR(1000) NOT NULL,
    IsFeatured BIT DEFAULT 0,
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- Create indexes for better performance
CREATE INDEX IX_Videos_CreatedAt ON Videos(CreatedAt DESC);
CREATE INDEX IX_Videos_IsFeatured ON Videos(IsFeatured);
CREATE INDEX IX_Videos_Title ON Videos(Title);

-- Insert sample data
INSERT INTO Videos (Title, Subtitle, VideoUrl, ThumbnailUrl, IsFeatured, CreatedAt)
VALUES 
    (N'Welcome to Our Tennis Club', 
     N'Experience world-class tennis facilities and coaching', 
     'https://www.youtube.com/watch?v=example1',
     'https://example.com/thumbnails/welcome.jpg',
     1,
     GETDATE()),
    
    (N'Tennis Training Tips', 
     N'Improve your game with our professional coaches', 
     'https://www.youtube.com/watch?v=example2',
     'https://example.com/thumbnails/training.jpg',
     1,
     DATEADD(DAY, -1, GETDATE())),
    
    (N'Club Tournament Highlights', 
     N'Watch the best moments from our recent tournament', 
     'https://www.youtube.com/watch?v=example3',
     'https://example.com/thumbnails/tournament.jpg',
     0,
     DATEADD(DAY, -2, GETDATE())),
    
    (N'Tennis Court Tour', 
     N'Take a virtual tour of our premium tennis courts', 
     'https://www.youtube.com/watch?v=example4',
     'https://example.com/thumbnails/courts.jpg',
     0,
     DATEADD(DAY, -3, GETDATE())),
    
    (N'Junior Tennis Program', 
     N'Introducing our comprehensive junior development program', 
     'https://www.youtube.com/watch?v=example5',
     'https://example.com/thumbnails/junior.jpg',
     1,
     DATEADD(DAY, -4, GETDATE()));

-- Verify the data
SELECT * FROM Videos ORDER BY CreatedAt DESC; 