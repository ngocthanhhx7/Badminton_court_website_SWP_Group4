
-- Tạo CSDL
CREATE DATABASE BadmintonBooking;
GO
USE BadmintonBooking;
GO

-- Bảng Customers
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100),
    Password NVARCHAR(50),
    Address NVARCHAR(200),
    Phone NVARCHAR(50) UNIQUE
);
GO

-- Bảng Account
CREATE TABLE Account (
    AccountID NVARCHAR(50) PRIMARY KEY,
    UserName NVARCHAR(50),
    Password NVARCHAR(50),
    FullName NVARCHAR(200),
    Type INT, -- 1 = Admin, 2 = Customer
    CustomerID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
GO

-- Bảng Courts
CREATE TABLE Courts (
    CourtID INT IDENTITY(1,1) PRIMARY KEY,
    CourtName NVARCHAR(100),
    Location NVARCHAR(200),
    HourlyRate FLOAT,
    CourtImage NVARCHAR(1000)
);
GO

-- Bảng Bookings
CREATE TABLE Bookings (
    BookingID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT,
    BookingDate DATETIME,
    StartTime DATETIME,
    EndTime DATETIME,
    TotalHours INT,
    RecurringID INT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
GO

-- Bảng RecurringBookings
CREATE TABLE RecurringBookings (
    RecurringID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT,
    CourtID INT,
    StartTime TIME,
    EndTime TIME,
    WeekDay INT,
    IntervalType NVARCHAR(50),
    StartDate DATE,
    EndDate DATE,
    IsActive BIT DEFAULT 1,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (CourtID) REFERENCES Courts(CourtID)
);
GO

-- Khóa ngoại bổ sung cho Bookings
ALTER TABLE Bookings
ADD CONSTRAINT FK_Bookings_Recurring FOREIGN KEY (RecurringID) REFERENCES RecurringBookings(RecurringID);
GO

-- Bảng BookingDetails
CREATE TABLE BookingDetails (
    BookingID INT,
    CourtID INT,
    HourlyRate FLOAT,
    TotalHours INT,
    TotalAmount AS (HourlyRate * TotalHours) PERSISTED,
    Discount FLOAT DEFAULT 0,
    Note NVARCHAR(200),
    Status NVARCHAR(50) DEFAULT 'Pending',
    PRIMARY KEY (BookingID, CourtID),
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID),
    FOREIGN KEY (CourtID) REFERENCES Courts(CourtID)
);
GO

-- Bảng Payments
CREATE TABLE Payments (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    BookingID INT,
    RecurringID INT NULL,
    PaymentDate DATETIME,
    PaymentMethod NVARCHAR(50),
    Amount FLOAT,
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID),
    FOREIGN KEY (RecurringID) REFERENCES RecurringBookings(RecurringID)
);
GO

-- Dữ liệu mẫu
INSERT INTO Customers (FullName, Password, Address, Phone)
VALUES (N'Nguyễn Văn A', '123456', N'123 Trần Hưng Đạo', '0909123456');
GO

INSERT INTO Account (AccountID, UserName, Password, FullName, Type, CustomerID)
VALUES ('user1', 'nguyenvana', '123456', N'Nguyễn Văn A', 2, 1),
       ('admin1', 'admin', 'admin123', N'Admin', 1, NULL);
GO

-- DỮ LIỆU MẪU BỔ SUNG

-- Thêm sân mẫu
INSERT INTO Courts (CourtName, Location, HourlyRate, CourtImage)
VALUES 
(N'Sân A1', N'123 Lê Lợi, Q1', 120000, N'/img/court_a1.jpg'),
(N'Sân B2', N'456 Trần Hưng Đạo, Q5', 100000, N'/img/court_b2.jpg');

-- Thêm lịch đặt định kỳ: mỗi thứ Hai từ 13h đến 14h, lặp hàng tuần
INSERT INTO RecurringBookings (CustomerID, CourtID, StartTime, EndTime, WeekDay, IntervalType, StartDate, EndDate)
VALUES (1, 1, '13:00', '14:00', 2, 'Weekly', '2025-06-03', '2025-09-30');

-- Thêm một lần đặt sân cụ thể từ lịch đặt định kỳ trên
INSERT INTO Bookings (CustomerID, BookingDate, StartTime, EndTime, TotalHours, RecurringID)
VALUES (1, '2025-06-09', '2025-06-09 13:00', '2025-06-09 14:00', 1, 1);

-- Thêm chi tiết booking
INSERT INTO BookingDetails (BookingID, CourtID, HourlyRate, TotalHours)
VALUES (1, 1, 120000, 1);

-- Thêm thanh toán cho booking trên
INSERT INTO Payments (BookingID, RecurringID, PaymentDate, PaymentMethod, Amount)
VALUES (1, 1, GETDATE(), N'Momo', 120000);
