package dao;

import models.BookingServiceDTO;
import models.ServiceDTO;
import utils.DBUtils;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class BookingServiceDAO {
    
    public boolean addBookingService(BookingServiceDTO bookingService) {
        String sql = "INSERT INTO BookingServices (BookingID, ServiceID, Quantity, UnitPrice, Subtotal) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setLong(1, bookingService.getBookingId());
            ps.setInt(2, bookingService.getServiceId());
            ps.setInt(3, bookingService.getQuantity());
            ps.setBigDecimal(4, bookingService.getUnitPrice());
            ps.setBigDecimal(5, bookingService.getSubtotal());
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean addBookingServices(List<BookingServiceDTO> bookingServices) {
        String sql = "INSERT INTO BookingServices (BookingID, ServiceID, Quantity, UnitPrice, Subtotal) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            connection.setAutoCommit(false);
            
            for (BookingServiceDTO service : bookingServices) {
                ps.setLong(1, service.getBookingId());
                ps.setInt(2, service.getServiceId());
                ps.setInt(3, service.getQuantity());
                ps.setBigDecimal(4, service.getUnitPrice());
                ps.setBigDecimal(5, service.getSubtotal());
                ps.addBatch();
            }
            
            int[] results = ps.executeBatch();
            connection.commit();
            
            for (int result : results) {
                if (result < 1) {
                    return false;
                }
            }
            return true;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<BookingServiceDTO> getBookingServices(Long bookingId) {
        String sql = """
            SELECT bs.*, s.ServiceName, s.ServiceType, s.Description, s.Unit, s.Status
            FROM BookingServices bs
            JOIN Services s ON bs.ServiceID = s.ServiceID
            WHERE bs.BookingID = ?
            ORDER BY bs.CreatedAt
        """;
        
        List<BookingServiceDTO> services = new ArrayList<>();
        
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setLong(1, bookingId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                BookingServiceDTO service = BookingServiceDTO.builder()
                    .bookingServiceId(rs.getLong("BookingServiceID"))
                    .bookingId(rs.getLong("BookingID"))
                    .serviceId(rs.getInt("ServiceID"))
                    .quantity(rs.getInt("Quantity"))
                    .unitPrice(rs.getBigDecimal("UnitPrice"))
                    .subtotal(rs.getBigDecimal("Subtotal"))
                    .createdAt(rs.getTimestamp("CreatedAt").toLocalDateTime())
                    .serviceName(rs.getString("ServiceName"))
                    .serviceType(rs.getString("ServiceType"))
                    .description(rs.getString("Description"))
                    .unit(rs.getString("Unit"))
                    .status(rs.getString("Status"))
                    .build();
                    
                services.add(service);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return services;
    }
    
    public BigDecimal getTotalServiceAmount(Long bookingId) {
        String sql = "SELECT ISNULL(SUM(Subtotal), 0) as TotalAmount FROM BookingServices WHERE BookingID = ?";
        
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setLong(1, bookingId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getBigDecimal("TotalAmount");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return BigDecimal.ZERO;
    }
    
    public boolean deleteBookingServices(Long bookingId) {
        String sql = "DELETE FROM BookingServices WHERE BookingID = ?";
        
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setLong(1, bookingId);
            return ps.executeUpdate() >= 0; // >=0 because there might be 0 services
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
