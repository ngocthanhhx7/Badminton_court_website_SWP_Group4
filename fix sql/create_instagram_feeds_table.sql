-- Create InstagramFeeds table
CREATE TABLE InstagramFeeds (
    FeedID INT IDENTITY(1,1) PRIMARY KEY,
    ImageUrl NVARCHAR(1000) NOT NULL,
    InstagramLink NVARCHAR(1000) NOT NULL,
    DisplayOrder INT DEFAULT 0,
    IsVisible BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- Create indexes for better performance
CREATE INDEX IX_InstagramFeeds_DisplayOrder ON InstagramFeeds(DisplayOrder ASC);
CREATE INDEX IX_InstagramFeeds_IsVisible ON InstagramFeeds(IsVisible);
CREATE INDEX IX_InstagramFeeds_CreatedAt ON InstagramFeeds(CreatedAt DESC);

-- Insert sample data
INSERT INTO InstagramFeeds (ImageUrl, InstagramLink, DisplayOrder, IsVisible, CreatedAt)
VALUES 
    ('https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=400',
     'https://www.instagram.com/p/example1/',
     1,
     1,
     GETDATE()),
    
    ('https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=400',
     'https://www.instagram.com/p/example2/',
     2,
     1,
     DATEADD(DAY, -1, GETDATE())),
    
    ('https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=400',
     'https://www.instagram.com/p/example3/',
     3,
     1,
     DATEADD(DAY, -2, GETDATE())),
    
    ('https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=400',
     'https://www.instagram.com/p/example4/',
     4,
     0,
     DATEADD(DAY, -3, GETDATE())),
    
    ('https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=400',
     'https://www.instagram.com/p/example5/',
     5,
     1,
     DATEADD(DAY, -4, GETDATE())),
    
    ('https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=400',
     'https://www.instagram.com/p/example6/',
     6,
     1,
     DATEADD(DAY, -5, GETDATE()));

-- Verify the data
SELECT * FROM InstagramFeeds ORDER BY DisplayOrder ASC; 