package dao;

import models.BookingDTO;
import models.BookingDetailDTO;
import utils.DBUtils;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

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
}