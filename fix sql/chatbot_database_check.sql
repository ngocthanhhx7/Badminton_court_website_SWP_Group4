-- Chatbot Database Check and Fix Script
-- This script checks and fixes common database issues for the chatbot functionality

USE BadmintonHub;
GO

-- 1. Check if Courts table exists and has data
PRINT '=== Checking Courts table ===';
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Courts')
BEGIN
    DECLARE @courtCount INT;
    SELECT @courtCount = COUNT(*) FROM Courts;
    PRINT 'Courts table exists with ' + CAST(@courtCount AS VARCHAR) + ' records';
    
    IF @courtCount = 0
    BEGIN
        PRINT 'WARNING: Courts table is empty! Adding sample data...';
        
        INSERT INTO Courts (CourtName, CourtType, Status, Description, CreatedBy, CreatedAt, UpdatedAt)
        VALUES 
        ('Sân 1', 'Indoor', 'Available', 'Sân cầu lông trong nhà chất lượng cao', 1, GETDATE(), GETDATE()),
        ('Sân 2', 'Indoor', 'Available', 'Sân cầu lông trong nhà với đèn LED', 1, GETDATE(), GETDATE()),
        ('Sân 3', 'Outdoor', 'Available', 'Sân cầu lông ngoài trời với mái che', 1, GETDATE(), GETDATE()),
        ('Sân 4', 'Outdoor', 'Available', 'Sân cầu lông ngoài trời thông thoáng', 1, GETDATE(), GETDATE()),
        ('Sân 5', 'Indoor', 'Maintenance', 'Sân đang bảo trì', 1, GETDATE(), GETDATE());
        
        PRINT 'Added 5 sample courts';
    END
END
ELSE
BEGIN
    PRINT 'ERROR: Courts table does not exist!';
    PRINT 'Please create the Courts table first.';
END

-- 2. Check if Services table exists and has data
PRINT '=== Checking Services table ===';
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'services')
BEGIN
    DECLARE @serviceCount INT;
    SELECT @serviceCount = COUNT(*) FROM services;
    PRINT 'Services table exists with ' + CAST(@serviceCount AS VARCHAR) + ' records';
    
    IF @serviceCount = 0
    BEGIN
        PRINT 'WARNING: Services table is empty! Adding sample data...';
        
        INSERT INTO services (ServiceName, ServiceType, Description, Unit, Price, Status, CreatedBy, CreatedAt, UpdatedAt)
        VALUES 
        ('Thuê vợt cầu lông', 'Equipment', 'Vợt cầu lông chất lượng cao', 'cái', 50000, 'Active', 1, GETDATE(), GETDATE()),
        ('Thuê giày cầu lông', 'Equipment', 'Giày cầu lông chuyên dụng', 'đôi', 30000, 'Active', 1, GETDATE(), GETDATE()),
        ('Thuê bóng cầu lông', 'Equipment', 'Bóng cầu lông chính hãng', 'quả', 10000, 'Active', 1, GETDATE(), GETDATE()),
        ('Nước uống', 'Beverage', 'Nước khoáng, nước ngọt các loại', 'chai', 15000, 'Active', 1, GETDATE(), GETDATE()),
        ('Massage', 'Service', 'Dịch vụ massage thư giãn', 'lần', 200000, 'Active', 1, GETDATE(), GETDATE());
        
        PRINT 'Added 5 sample services';
    END
END
ELSE
BEGIN
    PRINT 'ERROR: Services table does not exist!';
    PRINT 'Please create the services table first.';
END

-- 3. Check if CourtSchedules table exists and has data
PRINT '=== Checking CourtSchedules table ===';
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'CourtSchedules')
BEGIN
    DECLARE @scheduleCount INT;
    SELECT @scheduleCount = COUNT(*) FROM CourtSchedules;
    PRINT 'CourtSchedules table exists with ' + CAST(@scheduleCount AS VARCHAR) + ' records';
    
    IF @scheduleCount = 0
    BEGIN
        PRINT 'WARNING: CourtSchedules table is empty! Adding sample data...';
        
        -- Get today's date
        DECLARE @today DATE = GETDATE();
        DECLARE @tomorrow DATE = DATEADD(day, 1, @today);
        
        -- Add sample schedules for today and tomorrow
        INSERT INTO CourtSchedules (CourtID, ScheduleDate, StartTime, EndTime, Status, IsHoliday, CreatedAt, UpdatedAt)
        SELECT 
            c.CourtID,
            @today,
            '06:00:00',
            '07:00:00',
            'Available',
            0,
            GETDATE(),
            GETDATE()
        FROM Courts c
        WHERE c.Status = 'Available'
        UNION ALL
        SELECT 
            c.CourtID,
            @today,
            '07:00:00',
            '08:00:00',
            'Available',
            0,
            GETDATE(),
            GETDATE()
        FROM Courts c
        WHERE c.Status = 'Available'
        UNION ALL
        SELECT 
            c.CourtID,
            @today,
            '08:00:00',
            '09:00:00',
            'Available',
            0,
            GETDATE(),
            GETDATE()
        FROM Courts c
        WHERE c.Status = 'Available'
        UNION ALL
        SELECT 
            c.CourtID,
            @tomorrow,
            '06:00:00',
            '07:00:00',
            'Available',
            0,
            GETDATE(),
            GETDATE()
        FROM Courts c
        WHERE c.Status = 'Available'
        UNION ALL
        SELECT 
            c.CourtID,
            @tomorrow,
            '07:00:00',
            '08:00:00',
            'Available',
            0,
            GETDATE(),
            GETDATE()
        FROM Courts c
        WHERE c.Status = 'Available';
        
        PRINT 'Added sample schedules for today and tomorrow';
    END
END
ELSE
BEGIN
    PRINT 'ERROR: CourtSchedules table does not exist!';
    PRINT 'Please create the CourtSchedules table first.';
END

-- 4. Check database connection and permissions
PRINT '=== Checking database connection ===';
IF EXISTS (SELECT * FROM sys.database_principals WHERE name = 'sa')
BEGIN
    PRINT 'SA user exists and has access';
END
ELSE
BEGIN
    PRINT 'WARNING: SA user may not have proper permissions';
END

-- 5. Check if all required columns exist
PRINT '=== Checking required columns ===';

-- Check Courts table columns
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Courts' AND COLUMN_NAME = 'CourtID')
    PRINT 'Courts.CourtID - OK'
ELSE
    PRINT 'ERROR: Courts.CourtID column missing!'

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Courts' AND COLUMN_NAME = 'CourtName')
    PRINT 'Courts.CourtName - OK'
ELSE
    PRINT 'ERROR: Courts.CourtName column missing!'

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Courts' AND COLUMN_NAME = 'CourtType')
    PRINT 'Courts.CourtType - OK'
ELSE
    PRINT 'ERROR: Courts.CourtType column missing!'

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Courts' AND COLUMN_NAME = 'Status')
    PRINT 'Courts.Status - OK'
ELSE
    PRINT 'ERROR: Courts.Status column missing!'

-- Check Services table columns
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'services' AND COLUMN_NAME = 'ServiceID')
    PRINT 'services.ServiceID - OK'
ELSE
    PRINT 'ERROR: services.ServiceID column missing!'

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'services' AND COLUMN_NAME = 'ServiceName')
    PRINT 'services.ServiceName - OK'
ELSE
    PRINT 'ERROR: services.ServiceName column missing!'

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'services' AND COLUMN_NAME = 'ServiceType')
    PRINT 'services.ServiceType - OK'
ELSE
    PRINT 'ERROR: services.ServiceType column missing!'

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'services' AND COLUMN_NAME = 'Price')
    PRINT 'services.Price - OK'
ELSE
    PRINT 'ERROR: services.Price column missing!'

-- Check CourtSchedules table columns
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CourtSchedules' AND COLUMN_NAME = 'ScheduleID')
    PRINT 'CourtSchedules.ScheduleID - OK'
ELSE
    PRINT 'ERROR: CourtSchedules.ScheduleID column missing!'

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CourtSchedules' AND COLUMN_NAME = 'CourtID')
    PRINT 'CourtSchedules.CourtID - OK'
ELSE
    PRINT 'ERROR: CourtSchedules.CourtID column missing!'

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CourtSchedules' AND COLUMN_NAME = 'ScheduleDate')
    PRINT 'CourtSchedules.ScheduleDate - OK'
ELSE
    PRINT 'ERROR: CourtSchedules.ScheduleDate column missing!'

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CourtSchedules' AND COLUMN_NAME = 'StartTime')
    PRINT 'CourtSchedules.StartTime - OK'
ELSE
    PRINT 'ERROR: CourtSchedules.StartTime column missing!'

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CourtSchedules' AND COLUMN_NAME = 'EndTime')
    PRINT 'CourtSchedules.EndTime - OK'
ELSE
    PRINT 'ERROR: CourtSchedules.EndTime column missing!'

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CourtSchedules' AND COLUMN_NAME = 'Status')
    PRINT 'CourtSchedules.Status - OK'
ELSE
    PRINT 'ERROR: CourtSchedules.Status column missing!'

PRINT '=== Database check completed ===';
PRINT 'If you see any ERROR messages above, please fix them before testing the chatbot.';
PRINT 'If you see WARNING messages, sample data has been added automatically.'; 