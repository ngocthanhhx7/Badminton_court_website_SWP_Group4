package dao;

import models.BookingDTO;
import models.BookingDetailDTO;
import utils.DBUtils;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import models.BookingView;

public class BookingDAO {
    
    public Long createBooking(BookingDTO booking) {
        String sql = "INSERT INTO Bookings (CustomerID, Status, Notes, CreatedBy) VALUES (?, ?, ?, ?)";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setLong(1, booking.getCustomerId());
            ps.setString(2, booking.getStatus());
            ps.setString(3, booking.getNotes());
            ps.setObject(4, booking.getCreatedBy());
            
            int result = ps.executeUpdate();
            if (result > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean addBookingDetail(BookingDetailDTO detail) {
        String sql = "INSERT INTO BookingDetails (BookingID, CourtID, StartTime, EndTime, HourlyRate) VALUES (?, ?, ?, ?, ?)";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setLong(1, detail.getBookingId());
            ps.setLong(2, detail.getCourtId());
            ps.setTimestamp(3, Timestamp.valueOf(detail.getStartTime()));
            ps.setTimestamp(4, Timestamp.valueOf(detail.getEndTime()));
            ps.setBigDecimal(5, detail.getHourlyRate());
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<BookingDTO> getBookingsByCustomer(Long customerId) {
        String sql = """
            SELECT b.*, u.FullName, u.Email, u.Phone 
            FROM Bookings b 
            JOIN Users u ON b.CustomerID = u.UserID 
            WHERE b.CustomerID = ? 
            ORDER BY b.CreatedAt DESC
        """;
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        List<BookingDTO> bookings = new ArrayList<>();
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setLong(1, customerId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                BookingDTO booking = BookingDTO.builder()
                    .bookingId(rs.getLong("BookingID"))
                    .customerId(rs.getLong("CustomerID"))
                    .status(rs.getString("Status"))
                    .notes(rs.getString("Notes"))
                    .createdAt(rs.getTimestamp("CreatedAt").toLocalDateTime())
                    .updatedAt(rs.getTimestamp("UpdatedAt") != null ? 
                              rs.getTimestamp("UpdatedAt").toLocalDateTime() : null)
                    .createdAtStr(rs.getTimestamp("CreatedAt").toLocalDateTime().format(formatter))
                    .updatedAtStr(rs.getTimestamp("UpdatedAt") != null ? rs.getTimestamp("UpdatedAt").toLocalDateTime().format(formatter) : null)
                    .customerName(rs.getString("FullName"))
                    .customerEmail(rs.getString("Email"))
                    .customerPhone(rs.getString("Phone"))
                    .build();
                bookings.add(booking);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return bookings;
    }
    
    public List<BookingDetailDTO> getBookingDetails(Long bookingId) {
        String sql = """
            SELECT bd.*, c.CourtName, c.CourtType 
            FROM BookingDetails bd 
            JOIN Courts c ON bd.CourtID = c.CourtID 
            WHERE bd.BookingID = ?
        """;
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        List<BookingDetailDTO> details = new ArrayList<>();
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setLong(1, bookingId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                BookingDetailDTO detail = BookingDetailDTO.builder()
                    .bookingDetailId(rs.getLong("BookingDetailID"))
                    .bookingId(rs.getLong("BookingID"))
                    .courtId(rs.getLong("CourtID"))
                    .startTime(rs.getTimestamp("StartTime").toLocalDateTime())
                    .endTime(rs.getTimestamp("EndTime").toLocalDateTime())
                    .startTimeStr(rs.getTimestamp("StartTime").toLocalDateTime().format(formatter))
                    .endTimeStr(rs.getTimestamp("EndTime").toLocalDateTime().format(formatter))
                    .hourlyRate(rs.getBigDecimal("HourlyRate"))
                    .subtotal(rs.getBigDecimal("Subtotal"))
                    .courtName(rs.getString("CourtName"))
                    .courtType(rs.getString("CourtType"))
                    .build();
                details.add(detail);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return details;
    }
    
    public boolean updateBookingStatus(Long bookingId, String status) {
        String sql = "UPDATE Bookings SET Status = ?, UpdatedAt = GETDATE() WHERE BookingID = ?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setLong(2, bookingId);
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<BookingDTO> getAllBookings(LocalDate startDate, LocalDate endDate) {
        String sql = """
            SELECT b.*, u.FullName, u.Email, u.Phone 
            FROM Bookings b 
            JOIN Users u ON b.CustomerID = u.UserID 
            WHERE CAST(b.CreatedAt AS DATE) BETWEEN ? AND ?
            ORDER BY b.CreatedAt DESC
        """;

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        List<BookingDTO> bookings = new ArrayList<>();

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDate(1, java.sql.Date.valueOf(startDate));
            ps.setDate(2, java.sql.Date.valueOf(endDate));

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BookingDTO booking = BookingDTO.builder()
                    .bookingId(rs.getLong("BookingID"))
                    .customerId(rs.getLong("CustomerID"))
                    .status(rs.getString("Status"))
                    .notes(rs.getString("Notes"))
                    .createdAt(rs.getTimestamp("CreatedAt").toLocalDateTime())
                    .updatedAt(rs.getTimestamp("UpdatedAt") != null 
                               ? rs.getTimestamp("UpdatedAt").toLocalDateTime() 
                               : null)
                    .createdAtStr(rs.getTimestamp("CreatedAt").toLocalDateTime().format(formatter))
                    .updatedAtStr(rs.getTimestamp("UpdatedAt") != null 
                                  ? rs.getTimestamp("UpdatedAt").toLocalDateTime().format(formatter) 
                                  : null)
                    .customerName(rs.getString("FullName"))
                    .customerEmail(rs.getString("Email"))
                    .customerPhone(rs.getString("Phone"))
                    .build();
                bookings.add(booking);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return bookings;
    }


    
    public BookingDTO getBookingById(Long bookingId) {
        String sql = """
            SELECT b.*, u.FullName, u.Email, u.Phone 
            FROM Bookings b 
            JOIN Users u ON b.CustomerID = u.UserID 
            WHERE b.BookingID = ?
        """;
        
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setLong(1, bookingId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return BookingDTO.builder()
                    .bookingId(rs.getLong("BookingID"))
                    .customerId(rs.getLong("CustomerID"))
                    .status(rs.getString("Status"))
                    .notes(rs.getString("Notes"))
                    .createdAt(rs.getTimestamp("CreatedAt").toLocalDateTime())
                    .updatedAt(rs.getTimestamp("UpdatedAt") != null ? 
                              rs.getTimestamp("UpdatedAt").toLocalDateTime() : null)
                    .customerName(rs.getString("FullName"))
                    .customerEmail(rs.getString("Email"))
                    .customerPhone(rs.getString("Phone"))
                    .build();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }


    public double getWeeklyRevenue(int time, int year) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public double getMonthlyRevenue(int time, int year) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

   

    public List<BookingView> getAllBookingViews() {
       List<BookingView> list = new ArrayList<>();

       String sql = "SELECT b.BookingID, u.FullName, u.Phone, u.Email, " +
                    "c.CourtName, bd.StartTime, bd.EndTime, " +
                    "DATEDIFF(MINUTE, bd.StartTime, bd.EndTime) / 60 AS DurationHours, " +
                    "b.Status, n.NoteDetails, n.Status AS NoteStatus, " +
                    "bd.HourlyRate, bd.Subtotal " +
                    "FROM Bookings b " +
                    "JOIN Users u ON b.CustomerID = u.UserID " +
                    "JOIN BookingDetails bd ON b.BookingID = bd.BookingID " +
                    "JOIN Courts c ON bd.CourtID = c.CourtID " +
                    "LEFT JOIN BookingNotes n ON b.BookingID = n.BookingID " +
                    "ORDER BY bd.StartTime DESC";

       try (Connection con = DBUtils.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()) {

           while (rs.next()) {
               BookingView bv = new BookingView();
               bv.setBookingID(rs.getInt("BookingID"));
               bv.setCustomerName(rs.getString("FullName"));
               bv.setPhone(rs.getString("Phone"));
               bv.setEmail(rs.getString("Email"));
               bv.setCourtName(rs.getString("CourtName"));
               bv.setBookingTime(rs.getTimestamp("StartTime"));
               bv.setDurationHours(rs.getInt("DurationHours"));
               bv.setStatus(rs.getString("Status"));
               bv.setNoteDetails(rs.getString("NoteDetails"));
               bv.setNoteStatus(rs.getString("NoteStatus"));
               bv.setHourlyRate(rs.getDouble("HourlyRate"));
               bv.setSubtotal(rs.getDouble("Subtotal"));
               list.add(bv);
           }

       } catch (Exception e) {
           e.printStackTrace();
       }

       return list;
   }

public List<BookingView> getBookingViewsByPhone(String phone) {
    List<BookingView> list = new ArrayList<>();

    String sql = "SELECT b.BookingID, u.FullName, u.Phone, u.Email, " +
                 "c.CourtName, bd.StartTime, bd.EndTime, " +
                 "DATEDIFF(MINUTE, bd.StartTime, bd.EndTime) / 60 AS DurationHours, " +
                 "b.Status, n.NoteDetails, n.Status AS NoteStatus, " +
                 "bd.HourlyRate, bd.Subtotal " +
                 "FROM Bookings b " +
                 "JOIN Users u ON b.CustomerID = u.UserID " +
                 "JOIN BookingDetails bd ON b.BookingID = bd.BookingID " +
                 "JOIN Courts c ON bd.CourtID = c.CourtID " +
                 "LEFT JOIN BookingNotes n ON b.BookingID = n.BookingID " +
                 "WHERE u.Phone LIKE ? " +
                 "ORDER BY bd.StartTime DESC";

    try (Connection con = DBUtils.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setString(1, "%" + phone + "%");
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            BookingView bv = new BookingView();
            bv.setBookingID(rs.getInt("BookingID"));
            bv.setCustomerName(rs.getString("FullName"));
            bv.setPhone(rs.getString("Phone"));
            bv.setEmail(rs.getString("Email"));
            bv.setCourtName(rs.getString("CourtName"));
            bv.setBookingTime(rs.getTimestamp("StartTime"));
            bv.setDurationHours(rs.getInt("DurationHours"));
            bv.setStatus(rs.getString("Status"));
            bv.setNoteDetails(rs.getString("NoteDetails"));
            bv.setNoteStatus(rs.getString("NoteStatus"));
            bv.setHourlyRate(rs.getDouble("HourlyRate"));
            bv.setSubtotal(rs.getDouble("Subtotal"));
            list.add(bv);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}

    public List<BookingView> getBookingViewsByDateRange(Date startDate, Date endDate) {
    List<BookingView> list = new ArrayList<>();

    String sql = "SELECT b.BookingID, u.FullName, u.Phone, u.Email, " +
                 "bd.StartTime, bd.EndTime, bd.HourlyRate, bd.Subtotal, " +
                 "b.DurationHours, b.Status, n.NoteDetails " +
                 "FROM Bookings b " +
                 "JOIN Users u ON b.CustomerID = u.UserID " +
                 "JOIN BookingDetails bd ON b.BookingID = bd.BookingID " +
                 "LEFT JOIN BookingNotes n ON b.BookingID = n.BookingID " +
                 "WHERE bd.StartTime >= ? AND bd.StartTime < ?";

    try (Connection con = DBUtils.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setTimestamp(1, new java.sql.Timestamp(startDate.getTime()));
        ps.setTimestamp(2, new java.sql.Timestamp(endDate.getTime()));
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            BookingView bv = new BookingView();
            bv.setBookingID(rs.getInt("BookingID"));
            bv.setCustomerName(rs.getString("FullName"));
            bv.setPhone(rs.getString("Phone"));
            bv.setEmail(rs.getString("Email"));
            bv.setBookingTime(rs.getTimestamp("StartTime"));
            bv.setDurationHours(rs.getInt("DurationHours"));
            bv.setStatus(rs.getString("Status"));
            bv.setNoteDetails(rs.getString("NoteDetails"));
            bv.setHourlyRate(rs.getDouble("HourlyRate"));
            bv.setSubtotal(rs.getDouble("Subtotal"));
            list.add(bv);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}

public void updateBookingStatus(int bookingID, String newStatus) {
    String sql = "UPDATE Bookings SET Status = ? WHERE BookingID = ?";

    try (Connection con = DBUtils.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setString(1, newStatus);
        ps.setInt(2, bookingID);
        ps.executeUpdate();

    } catch (Exception e) {
        e.printStackTrace();
    }
}

// Trong BookingDAO.java
    public Map<String, Double> getRevenueByDate() {
        Map<String, Double> revenueMap = new LinkedHashMap<>();

        String sql = "SELECT CONVERT(DATE, bd.StartTime) AS BookingDate, SUM(bd.Subtotal) AS TotalRevenue " +
                     "FROM BookingDetails bd " +
                     "GROUP BY CONVERT(DATE, bd.StartTime) " +
                     "ORDER BY BookingDate";

        try (Connection con = DBUtils.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                String date = rs.getString("BookingDate");
                double revenue = rs.getDouble("TotalRevenue");
                revenueMap.put(date, revenue);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return revenueMap;
    }

    
    public List<BookingDTO> getBookingsByCustomerAndBookingDetail(Long customerId) {
        List<BookingDTO> bookings = getBookingsByCustomer(customerId);
        return bookings.stream()
        .filter(b -> "Completed".equalsIgnoreCase(b.getStatus()))
        .peek(b -> b.setBookingDetails(getBookingDetails(b.getBookingId())))
        .collect(Collectors.toList());
    }
    
    public List<BookingDTO> getBookingsByCustomerAndBookingDetailDraft(Long customerId) {
        List<BookingDTO> bookings = getBookingsByCustomer(customerId);
        System.out.println(bookings.size());
        return bookings.stream()
        .filter(b -> "Pending".equalsIgnoreCase(b.getStatus()))
        .peek(b -> b.setBookingDetails(getBookingDetails(b.getBookingId())))
        .collect(Collectors.toList());
    }
    
    public List<BookingDTO> getAllBookingsAndBookingDetail(LocalDate startDate, LocalDate endDate){
         List<BookingDTO> bookings = getAllBookings(startDate, endDate);
         return bookings.stream()
        .peek(b -> b.setBookingDetails(getBookingDetails(b.getBookingId())))
        .collect(Collectors.toList());
    }

}
