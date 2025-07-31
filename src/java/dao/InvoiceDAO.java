package dao;

import models.InvoiceDTO;
import utils.DBUtils;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class InvoiceDAO {
    
    public Long createInvoice(InvoiceDTO invoice) {
        String sql = """
            INSERT INTO Invoices (BookingID, CustomerID, TotalAmount, Discount, Tax, 
                                PaymentMethod, Status, CreatedBy) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        """;
        
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setLong(1, invoice.getBookingId());
            ps.setLong(2, invoice.getCustomerId());
            ps.setBigDecimal(3, invoice.getTotalAmount());
            ps.setBigDecimal(4, invoice.getDiscount());
            ps.setBigDecimal(5, invoice.getTax());
            ps.setString(6, invoice.getPaymentMethod());
            ps.setString(7, invoice.getStatus());
            ps.setObject(8, invoice.getCreatedBy());
            
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
    
    public InvoiceDTO getInvoiceByBookingId(Long bookingId) {
        String sql = "SELECT * FROM Invoices WHERE BookingID = ?";
        
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setLong(1, bookingId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return InvoiceDTO.builder()
                    .invoiceId(rs.getLong("InvoiceID"))
                    .bookingId(rs.getLong("BookingID"))
                    .customerId(rs.getLong("CustomerID"))
                    .totalAmount(rs.getBigDecimal("TotalAmount"))
                    .discount(rs.getBigDecimal("Discount"))
                    .tax(rs.getBigDecimal("Tax"))
                    .finalAmount(rs.getBigDecimal("FinalAmount"))
                    .paymentMethod(rs.getString("PaymentMethod"))
                    .status(rs.getString("Status"))
                    .createdAt(rs.getTimestamp("CreatedAt").toLocalDateTime())
                    .updatedAt(rs.getTimestamp("UpdatedAt") != null ? 
                              rs.getTimestamp("UpdatedAt").toLocalDateTime() : null)
                    .build();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public List<InvoiceDTO> getInvoicesByCustomer(Long customerId) {
        String sql = "SELECT * FROM Invoices WHERE CustomerID = ? ORDER BY CreatedAt DESC";
        List<InvoiceDTO> invoices = new ArrayList<>();
        
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setLong(1, customerId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                InvoiceDTO invoice = InvoiceDTO.builder()
                    .invoiceId(rs.getLong("InvoiceID"))
                    .bookingId(rs.getLong("BookingID"))
                    .customerId(rs.getLong("CustomerID"))
                    .totalAmount(rs.getBigDecimal("TotalAmount"))
                    .discount(rs.getBigDecimal("Discount"))
                    .tax(rs.getBigDecimal("Tax"))
                    .finalAmount(rs.getBigDecimal("FinalAmount"))
                    .paymentMethod(rs.getString("PaymentMethod"))
                    .status(rs.getString("Status"))
                    .createdAt(rs.getTimestamp("CreatedAt").toLocalDateTime())
                    .updatedAt(rs.getTimestamp("UpdatedAt") != null ? 
                              rs.getTimestamp("UpdatedAt").toLocalDateTime() : null)
                    .build();
                invoices.add(invoice);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return invoices;
    }
    
    public boolean updateInvoiceStatus(Long invoiceId, String status) {
        String sql = "UPDATE Invoices SET Status = ?, UpdatedAt = GETDATE() WHERE InvoiceID = ?";
        
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setLong(2, invoiceId);
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}