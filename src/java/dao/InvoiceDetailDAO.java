package dao;

import models.InvoiceDetailView;
import utils.DBUtils;

import java.sql.*;
import java.util.*;

public class InvoiceDetailDAO {

    // Lấy toàn bộ danh sách có kèm CustomerName và Username
    public List<InvoiceDetailView> getAllInvoiceDetails() {
        List<InvoiceDetailView> list = new ArrayList<>();
        String sql = """
            SELECT d.InvoiceDetailID, d.InvoiceID, d.ItemType, d.ItemID, d.ItemName,
                   d.Quantity, d.UnitPrice, d.Subtotal, d.Status,
                   u.FullName AS CustomerName, u.Username
            FROM InvoiceDetails d
            JOIN Invoices i ON d.InvoiceID = i.InvoiceID
            JOIN Users u ON i.CustomerID = u.UserID
            ORDER BY d.InvoiceDetailID
        """;

        try (Connection con = DBUtils.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                InvoiceDetailView d = new InvoiceDetailView(
                        rs.getInt("InvoiceDetailID"),
                        rs.getInt("InvoiceID"),
                        rs.getString("ItemType"),
                        rs.getInt("ItemID"),
                        rs.getString("ItemName"),
                        rs.getInt("Quantity"),
                        rs.getDouble("UnitPrice"),
                        rs.getDouble("Subtotal"),
                        rs.getString("Status"),
                        rs.getString("CustomerName"),
                        rs.getString("Username")
                );
                list.add(d);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy danh sách có phân trang (kèm CustomerName và Username)
    public List<InvoiceDetailView> getInvoiceDetailsByPage(int page, int pageSize) {
        List<InvoiceDetailView> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;

        String sql = """
            SELECT d.InvoiceDetailID, d.InvoiceID, d.ItemType, d.ItemID, d.ItemName,
                   d.Quantity, d.UnitPrice, d.Subtotal, d.Status,
                   u.FullName AS CustomerName, u.Username
            FROM InvoiceDetails d
            JOIN Invoices i ON d.InvoiceID = i.InvoiceID
            JOIN Users u ON i.CustomerID = u.UserID
            ORDER BY d.InvoiceDetailID
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;

        try (Connection con = DBUtils.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, offset);
            ps.setInt(2, pageSize);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                InvoiceDetailView d = new InvoiceDetailView(
                        rs.getInt("InvoiceDetailID"),
                        rs.getInt("InvoiceID"),
                        rs.getString("ItemType"),
                        rs.getInt("ItemID"),
                        rs.getString("ItemName"),
                        rs.getInt("Quantity"),
                        rs.getDouble("UnitPrice"),
                        rs.getDouble("Subtotal"),
                        rs.getString("Status"),
                        rs.getString("CustomerName"),
                        rs.getString("Username")
                );
                list.add(d);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Đếm tổng số dòng
    public int getTotalInvoiceDetailCount() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM InvoiceDetails";
        try (Connection con = DBUtils.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }
    public List<InvoiceDetailView> searchByCustomerName(String keyword, int page, int pageSize) {
    List<InvoiceDetailView> list = new ArrayList<>();
    int offset = (page - 1) * pageSize;

    String sql = """
        SELECT d.InvoiceDetailID, d.InvoiceID, d.ItemType, d.ItemID, d.ItemName,
               d.Quantity, d.UnitPrice, d.Subtotal, d.Status,
               u.FullName AS CustomerName, u.Username
        FROM InvoiceDetails d
        JOIN Invoices i ON d.InvoiceID = i.InvoiceID
        JOIN Users u ON i.CustomerID = u.UserID
        WHERE u.FullName LIKE ?
        ORDER BY d.InvoiceDetailID
        OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
    """;

    try (Connection con = DBUtils.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setString(1, "%" + keyword + "%");
        ps.setInt(2, offset);
        ps.setInt(3, pageSize);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            InvoiceDetailView d = new InvoiceDetailView(
                rs.getInt("InvoiceDetailID"),
                rs.getInt("InvoiceID"),
                rs.getString("ItemType"),
                rs.getInt("ItemID"),
                rs.getString("ItemName"),
                rs.getInt("Quantity"),
                rs.getDouble("UnitPrice"),
                rs.getDouble("Subtotal"),
                rs.getString("Status"),
                rs.getString("CustomerName"),
                rs.getString("Username")
            );
            list.add(d);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}

// Đếm kết quả tìm kiếm
public int countSearchResults(String keyword) {
    int count = 0;
    String sql = """
        SELECT COUNT(*)
        FROM InvoiceDetails d
        JOIN Invoices i ON d.InvoiceID = i.InvoiceID
        JOIN Users u ON i.CustomerID = u.UserID
        WHERE u.FullName LIKE ?
    """;

    try (Connection con = DBUtils.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setString(1, "%" + keyword + "%");
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            count = rs.getInt(1);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return count;
}
public void updateStatus(int id, String status) {
    String sql = "UPDATE InvoiceDetails SET Status = ? WHERE InvoiceDetailID = ?";
    try (Connection con = DBUtils.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setString(1, status);
        ps.setInt(2, id);
        ps.executeUpdate();
    } catch (Exception e) {
        e.printStackTrace();
    }
}
public InvoiceDetailView getInvoiceDetailByID(int id) {
    InvoiceDetailView item = null;
    try (Connection con = DBUtils.getConnection()) {
        String sql = "SELECT * FROM InvoiceDetailView WHERE InvoiceDetailID = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, id);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            item = new InvoiceDetailView(
                rs.getInt("InvoiceDetailID"),
                rs.getInt("InvoiceID"),
                rs.getString("ItemType"),
                rs.getInt("ItemID"),
                rs.getString("ItemName"),
                rs.getInt("Quantity"),
                rs.getDouble("UnitPrice"),
                rs.getDouble("Subtotal"),
                rs.getString("Status"),
                rs.getString("CustomerName"),
                rs.getString("Username")
            );
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return item;
}

   public Map<String, Integer> getItemNameTotalQuantity() {
    Map<String, Integer> map = new LinkedHashMap<>();
    String sql = "SELECT ItemName, SUM(Quantity) AS TotalQty " +
                 "FROM InvoiceDetails " +
                 "GROUP BY ItemName ORDER BY ItemName";

    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            map.put(rs.getString("ItemName"), rs.getInt("TotalQty"));
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    return map;
}




}
